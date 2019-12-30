module spirv.funcmanager;

import std;
import spirv.capabilitymanager;
import spirv.entrypointmanager;
import spirv.extinstimportmanager;
import spirv.globalvarmanager;
import spirv.spv;
import spirv.typeconstmanager;
import spirv.idmanager;
import spirv.instruction;
import spirv.writer;
import shader.builtin;
import llvm;
import llvm.attr;
import llvm.block;
import llvm.inst;
import llvm.operand;
import llvm.type;
import llvm.func;

alias BodyInstructions = AliasSeq!(
    LabelInstruction,
    StoreInstruction,
    LoadInstruction,
    INotEqualInstruction,
    UnaryOpInstruction,
    BinaryOpInstrucion,
    UnreachableInstruction,
    ReturnInstruction,
    ReturnValueInstruction,
    ComparisonInstruction,
    SelectInstruction,
    BranchInstruction,
    BranchConditionalInstruction,
    ExtInstInstruction,
    CompositeConstructInstruction,
    AccessChainInstruction,
    VariableInstruction,
);
alias BodyInstruction = Algebraic!(BodyInstructions);

class FunctionManager {

    class Fn {
        FunctionInstruction decl;
        FunctionParameterInstruction[] ps;
        FunctionEndInstruction end;
        EntryPoint ep;
        Bk[] blocks;
        Tuple!(Id, LLVMValueRef, Nullable!StorageClass)[] variables;
    }

    class Bk {
        Fn parent;
        BasicBlock b;
        Id id;
        BodyInstruction[] bs;

        this(BasicBlock b, Fn f) { this.parent = f; this.b = b; }
    }

    private IdManager idManager;
    private CapabilityManager capabilityManager;
    private EntryPointManager entryPointManager;
    private ExtInstImportManager extInstImportManager;
    private GlobalVarManager globalVarManager;
    private TypeConstManager typeConstManager;
    private Fn[] fns;

    this(IdManager idManager, CapabilityManager capabilityManager, EntryPointManager entryPointManager, ExtInstImportManager extInstImportManager, GlobalVarManager globalVarManager, TypeConstManager typeConstManager) {
        this.idManager = idManager;
        this.capabilityManager = capabilityManager;
        this.entryPointManager = entryPointManager;
        this.extInstImportManager = extInstImportManager;
        this.globalVarManager = globalVarManager;
        this.typeConstManager = typeConstManager;
    }

    Id addFunction(Function func) {
        if (func.basicBlocks.empty) return 0;

        auto ft = func.type.elementType;
        auto returnType = typeConstManager.requestType(ft.returnType);
        auto funcId = idManager.requestId(func.name);
        auto funcType = typeConstManager.requestType(ft);

        auto fn = new Fn;

        enum FunctionControlMaskMap = [
            AttributeEnum.ReadNone     : FunctionControlMask.Pure,
            AttributeEnum.ReadOnly     : FunctionControlMask.Const,
            AttributeEnum.AlwaysInline : FunctionControlMask.Inline,
            AttributeEnum.NoInline     : FunctionControlMask.DontInline,
        ];
        const mask = FunctionControlMaskMap.byKeyValue
            .filter!(p => func.attributes.canFind!(a => a.isEnum && a.kindAsEnum == p.key))
            .map!(p => cast(uint)p.value)
            .fold!((a,b) => a | b)(0);
        fn.decl = FunctionInstruction(returnType, funcId, mask, funcType);

        foreach (i, p; func.params.enumerate) {
            auto paramType = typeConstManager.requestType(p.type);
            auto paramId = idManager.requestId(format!"%s.__param__%d"(func.name, i));
            fn.ps ~= FunctionParameterInstruction(paramType, paramId);
        }

        foreach (b; func.basicBlocks) {
            auto bk = new Bk(b, fn);
            fn.blocks ~= bk;
            bk.id = idManager.requestId();
            add(bk, LabelInstruction(bk.id));
        }
        foreach (b; fn.blocks) {
            addBlock(b);
        }

        auto epAttr = getAttribute!ExecutionModel(func, "entryPoint");
        if (epAttr.empty is false) {
            auto e = entryPointManager.addEntryPoint(funcId, epAttr.front);
            foreach (mode; getAttribute!ExecutionMode(func, "execMode")) {
                e.addMode(mode);
            }
            fn.ep = e;
        }

        fns ~= fn;

        return funcId;
    }

    void writeAllInstructions(Writer writer) const {
        foreach (fn; fns) {
            writer.writeInstruction(fn.decl);
            foreach (p; fn.ps) writer.writeInstruction(p);
            foreach (bk; fn.blocks) {
body:           foreach (b; bk.bs) {
                    static foreach (I; BodyInstructions) {
                        if (auto r = b.peek!I) {
                            writer.writeInstruction(*r);
                            continue body;
                        }
                    }
                    assert(false);
                }
            }
            writer.writeInstruction(fn.end);
        }
    }

    private void addBlock(Bk bk) {
        foreach (i; bk.b.instructions) {
            addBodyInstruction(bk, i);
        }
    }

    private void addBodyInstruction(Bk bk, Instruction i) {
        enum UnaryOpsMap = [
            UnaryOps.FNeg: Op.OpFNegate,
            UnaryOps.Trunc : Op.OpUConvert,
            UnaryOps.ZExt : Op.OpUConvert,
            UnaryOps.SExt : Op.OpSConvert,
            UnaryOps.FPToUI : Op.OpConvertFToU,
            UnaryOps.FPToSI : Op.OpConvertFToS,
            UnaryOps.UIToFP : Op.OpConvertUToF,
            UnaryOps.SIToFP : Op.OpConvertSToF,
            UnaryOps.FPTrunc : Op.OpFConvert,
            UnaryOps.FPExt : Op.OpFConvert,
            UnaryOps.PtrToInt : Op.OpConvertPtrToU,
            UnaryOps.IntToPtr : Op.OpConvertUToPtr,
            UnaryOps.BitCast : Op.OpBitcast,
            UnaryOps.AddrSpaceCast : Op.OpGenericCastToPtr,
        ];
        enum BinaryOpsMap = [
            BinaryOps.And : Op.OpBitwiseAnd,
            BinaryOps.Or : Op.OpBitwiseOr,
            BinaryOps.Xor : Op.OpBitwiseXor,
            BinaryOps.Add : Op.OpIAdd,
            BinaryOps.FAdd : Op.OpFAdd,
            BinaryOps.Sub : Op.OpISub,
            BinaryOps.FSub : Op.OpFSub,
            BinaryOps.Mul : Op.OpIMul,
            BinaryOps.FMul : Op.OpFMul,
            BinaryOps.UDiv : Op.OpUDiv,
            BinaryOps.SDiv : Op.OpSDiv,
            BinaryOps.FDiv : Op.OpFDiv,
            BinaryOps.SRem : Op.OpSRem,
            BinaryOps.FRem : Op.OpFRem,
            BinaryOps.URem : Op.OpUMod,
            BinaryOps.Shl : Op.OpShiftLeftLogical,
            BinaryOps.LShr : Op.OpShiftRightLogical,
            BinaryOps.RShr : Op.OpShiftRightArithmetic,
        ];
        enum CmpOpsMap = [
            Predicate.FCMP_OEQ : Op.OpFOrdEqual,
            Predicate.FCMP_OGT : Op.OpFOrdGreaterThan,
            Predicate.FCMP_OGE : Op.OpFOrdGreaterThanEqual,
            Predicate.FCMP_OLT : Op.OpFOrdLessThan,
            Predicate.FCMP_OLE : Op.OpFOrdLessThanEqual,
            Predicate.FCMP_ONE : Op.OpFOrdNotEqual,
            Predicate.FCMP_ORD : Op.OpOrdered,
            Predicate.FCMP_UNO : Op.OpUnordered,
            Predicate.FCMP_UEQ : Op.OpFUnordEqual,
            Predicate.FCMP_UGT : Op.OpFUnordGreaterThan,
            Predicate.FCMP_UGE : Op.OpFUnordGreaterThanEqual,
            Predicate.FCMP_ULT : Op.OpFUnordLessThan,
            Predicate.FCMP_ULE : Op.OpFUnordLessThanEqual,
            Predicate.FCMP_UNE : Op.OpFUnordNotEqual,
            Predicate.ICMP_EQ  : Op.OpIEqual,
            Predicate.ICMP_NE  : Op.OpINotEqual,
            Predicate.ICMP_UGT : Op.OpUGreaterThan,
            Predicate.ICMP_UGE : Op.OpUGreaterThanEqual,
            Predicate.ICMP_ULT : Op.OpULessThan,
            Predicate.ICMP_ULE : Op.OpULessThanEqual,
            Predicate.ICMP_SGT : Op.OpSGreaterThan,
            Predicate.ICMP_SGE : Op.OpSGreaterThanEqual,
            Predicate.ICMP_SLT : Op.OpSLessThan,
            Predicate.ICMP_SLE : Op.OpSLessThanEqual,
            ];
        if (i.isStoreInst) {
            // TODO: handle memory access mask
            auto dst = requestVar(bk, i.operands[0]);
            auto src = requestVar(bk, i.operands[1]);
            add(bk, StoreInstruction(src, dst));
        } else if (i.isLoadInst) {
            // TODO: handle memory access mask
            enforce(i.operands[0].type.kind == LLVMPointerTypeKind);
            auto src = requestVar(bk, i.operands[0]);
            auto type = requestType(i.operands[0].type.elementType);
            auto id = requestId(bk, i);
            add(bk, LoadInstruction(type, id, src));
        } else if (i.isBinaryOperator) {
            auto op0 = requestVar(bk, i.operands[0]);
            auto op1 = requestVar(bk, i.operands[1]);
            auto type = requestType(i.type);
            auto id = requestId(bk, i);
            auto code = BinaryOpsMap[i.opcodeAsBinary];
            add(bk, BinaryOpInstrucion(code, type, id, op0, op1));
        } else if (i.isUnreachableInst) {
            add(bk, UnreachableInstruction());
        } else if (i.isReturnInst) {
            auto ret = i.returnValue;
            if (ret.isNull) {
                add(bk, ReturnInstruction());
            } else {
                add(bk, ReturnValueInstruction(requestVar(bk, ret.get())));
            }
        } else if (i.isCmpInst) {
            // TODO: Handle Capability
            // TODO: Handle pointer comparison
            auto op0 = requestVar(bk, i.operands[0]);
            auto op1 = requestVar(bk, i.operands[1]);
            auto pred = CmpOpsMap[i.predicate];
            auto type = requestType(i.type);
            auto id = requestId(bk, i);
            add(bk, ComparisonInstruction(pred, type, id, op0, op1));
        } else if (i.isSelectInst) {
            auto type = requestType(i.type);
            auto id = requestId(bk, i);
            auto condition = requestVar(bk, i.conditionAsSelect);
            auto trueValue = requestVar(bk, i.trueValue);
            auto falseValue = requestVar(bk, i.falseValue);
            add(bk, SelectInstruction(type, id, condition, trueValue, falseValue));
        } else if (i.isAllocaInst) {
            // TODO: handle initializer
            auto type = requestType(i.type);
            auto id = requestId(bk, i, StorageClass.Function);
            add(bk, VariableInstruction(type, id, StorageClass.Function));
        } else if (i.isSwitchInst) {
            // TODO: Not yet implemented.
        } else if (i.isBranchInst) {
            // TODO: Handle LoopControlMask 
            auto successor = bk.parent.blocks.find!(b => b.b.block == i.successor(0).block).front.id;
            if (!i.isConditional) {
                add(bk, BranchInstruction(successor));
            } else {
                auto condition = requestVar(bk, i.conditionAsBranch);
                auto trueSuccessor = successor;
                auto falseSuccessor = bk.parent.blocks.find!(b => b.b.block == i.successor(1).block).front.id;
                add(bk, BranchConditionalInstruction(condition, trueSuccessor, falseSuccessor));
            }
        } else if (i.isPHINode) {
            //TODO: not implemneted yet.
            enforce(false);
        } else if (i.isExtractValueInst) {
            //TODO: not implemneted yet.
            enforce(false);
        } else if (i.isInsertValueInst) {
            //TODO: not implemneted yet.
            enforce(false);
        } else if (i.isUnaryInstruction) {
            // TODO: Handle AddrSpaceCast
            auto op = requestVar(bk, i.operands[0]);
            auto type = requestType(i.type);
            auto id = requestId(bk, i);
            auto code = UnaryOpsMap[i.opcodeAsUnary];
            if (code == Op.OpUConvert && i.type == Type.getIntegerType!(1)) {
                auto zeroType = typeConstManager.requestType(i.operands[0].type);
                add(bk, INotEqualInstruction(type, id, op, typeConstManager.requestConstant!uint(zeroType, 0)));
            } else {
                add(bk, UnaryOpInstruction(code, type, id, op));
            }
        } else if (i.isGetElementPtrInst) {
            enforce(Instruction(i.operands[1].op).isConstant);
            enforce(Instruction(i.operands[1].op).zExtValue == 0);
            enforce(Instruction(i.operands[0].op).type.kind == LLVMPointerTypeKind);
            auto base = requestVar(bk, i.operands[0]);
            auto storage = globalVarManager.getStorageClass(base);
            if (storage.isNull) {
                storage = bk.parent.variables
                    .find!(v => v[0] == base)
                    .front[2];
            }
            auto type = typeConstManager.requestType(i.type, storage.isNull ? StorageClass.Function : storage.get());
            auto id = requestId(bk, i, storage.get());
            auto indexes = i.operands[2..$].map!(op => requestVar(bk, op)).array;
            add(bk, AccessChainInstruction(type, id, base, indexes));
        } else if (i.isExtractElementInst) {
            //TODO: not implemneted yet.
            enforce(false);
        } else if (i.isInsertElementInst) {
            //TODO: not implemneted yet.
            enforce(false);
        } else if (i.isShuffleVectorInst) {
            //TODO: not implemneted yet.
            enforce(false);
        } else if (i.isIntrinsicInst) {
            //TODO: not implemneted yet.
            enforce(false);
        } else if (i.isCallInst) {
            auto binaryOps = getAttribute!BinaryOps(i.calledFunction, "operator");
            if (binaryOps.empty is false) {
                enforce(i.operands[0].type.kind == LLVMPointerTypeKind);
                auto code = BinaryOpsMap[binaryOps.front];
                auto type = requestType(i.operands[0].type.elementType);
                auto id = requestId(bk, i);
                auto op0 = requestVar(bk, i.operands[0]);
                auto op1 = requestVar(bk, i.operands[1]);
                add(bk, BinaryOpInstrucion(code, type, id, op0, op1));
                return;
            }

            auto extends = getAttribute!string(i.calledFunction, "extend");
            if (extends.empty is false) {
                auto tmp = extends.front.split(":");
                auto setName = tmp[0];
                uint instIndex = tmp[1].to!GLSLBuiltin.to!uint;
                auto type = requestType(i.type);
                auto id = requestId(bk, i);
                auto set = extInstImportManager.requestExtInstImport(setName);
                auto operands = i.argOperands.map!(arg => requestVar(bk, arg)).array;
                add(bk, ExtInstInstruction(type, id, set, instIndex, operands));
            }

            auto composite = getAttribute!string(i.calledFunction, "composite");
            if (composite.empty is false) {
                auto type = requestType(i.argOperand(0).type.elementType);
                auto id = requestId(bk, i);
                auto args = iota(1, i.numArgOperands).map!(j => requestVar(bk, i.argOperand(j))).array;
                add(bk, CompositeConstructInstruction(type, id, args));
                add(bk, StoreInstruction(requestVar(bk, i.argOperand(0)), id));
            }
            //TODO: not implemneted yet.
        } else {
            assert(false);
        }

    }

    private void add(Inst)(Bk bk, Inst i) {
        static if (hasUDA!(Inst, Necessary)) {
            static foreach (cap; getUDAs!(Inst, Necessary)[0].caps) {
                capabilitymanager.requestCapability(cap);
            }
        }
        bk.bs ~= BodyInstruction(i);
    }

    private Id requestVar(Bk bk, Operand op) {
        auto g = globalVarManager.getGlobalVar(op.op);
        if (g.isNull is false) return g.get();
        if (op.isConstant) {
            return requestConstant(op);
        }
        enforce(bk.parent.variables.canFind!(p => p[1] == op.op),
            format!"\nRequested: %s\nCandidates are:%s"(op, bk.parent.variables.map!(o => Operand(cast(LLVMValueRef)(o[1])).to!string).array.join("\n")));
        return bk.parent.variables.find!(p => p[1] == op.op).front[0];
    }

    private Id requestId(Bk bk, Instruction i) {
        return requestId(bk, i, Nullable!StorageClass.init);
    }

    private Id requestId(Bk bk, Instruction i, StorageClass st) {
        return requestId(bk, i, st.nullable);
    }

    private Id requestId(Bk bk, Instruction i, Nullable!StorageClass st) {
        auto id = idManager.requestId();
        bk.parent.variables ~= tuple(id, i.inst, st);
        return id;
    }

    private Id requestConstant(Operand op) {
        auto i = Instruction(op.op);
        auto type = requestType(i.type);
        if (i.isConstantInt) {
            if (i.type.widthAsInt == 32) {
                return typeConstManager.requestConstant(type, cast(int)i.zExtValue);
            } else if (i.type.widthAsInt == 64) {
                return typeConstManager.requestConstant(type, cast(long)i.zExtValue);
            } else {
                assert(false);
            }
        } else if (i.isConstantFP) {
            // TODO: Handle all floating type
            final switch (i.type.kind) {
                // case LLVMHalfTypeKind: return typeConstManager.requestConstant(type, cast(half)i.getConstDouble);
                case LLVMFloatTypeKind: return typeConstManager.requestConstant(type, cast(float)i.getConstDouble);
                case LLVMDoubleTypeKind: return typeConstManager.requestConstant(type, cast(double)i.getConstDouble);
                // case LLVMX86_FP80TypeKind: return "fp80";
                // case LLVMFP128TypeKind: return "quad";
                // case LLVMPPC_FP128TypeKind: return "ppc_quad";
            }
        } else if (i.isConstantDataVector) {
            auto components = iota(i.type.lengthAsVector).map!(j => requestConstant(i.elementAsConstant(j))).array;
            return typeConstManager.requestComponentConstant(type, components);
        }
        assert(false);
    }

    private Id requestType(Type type) {
        if (type.kind == LLVMPointerTypeKind) {
            return typeConstManager.requestType(type, StorageClass.Function);
        } else {
            return typeConstManager.requestType(type);
        }
    }

    private T[] getAttribute(T)(Function f, string kind) {
        return f.attributes
            .filter!(a => a.isString)
            .filter!(a => a.kindAsString == kind)
            .map!(a => a.valueAsString)
            .map!(to!T)
            .array;
    }
}
