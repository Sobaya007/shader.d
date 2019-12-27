module spirv.funcmanager;

import std;
import spirv.entrypointmanager;
import spirv.extinstimportmanager;
import spirv.spv;
import spirv.typeconstmanager;
import spirv.idmanager;
import spirv.instruction;
import spirv.writer;
import shader.builtin;
import llvm;
import llvm.block;
import llvm.inst;
import llvm.operand;
import llvm.type;
import llvm.func;

alias BodyInstructions = AliasSeq!(
    LabelInstruction,
    StoreInstruction,
    LoadInstruction,
    BinaryOpInstrucion,
    UnreachableInstruction,
    ReturnInstruction,
    ReturnValueInstruction,
    ComparisonInstruction,
    SelectInstruction,
    BranchInstruction,
    BranchConditionalInstruction,
    ExtInstInstruction,
);
alias BodyInstruction = Algebraic!(BodyInstructions);

class FunctionManager {

    class Fn {
        FunctionInstruction decl;
        FunctionParameterInstruction[] ps;
        VariableInstruction[] vs;
        FunctionEndInstruction end;
        EntryPoint ep;
        Bk[LLVMBasicBlockRef] blocks;
    }

    class Bk {
        Fn parent;
        BasicBlock b;
        Id id;
        BodyInstruction[] bs;
        Id[LLVMValueRef] variables;

        this(BasicBlock b, Fn f) { this.parent = f; this.b = b; }
    }

    private IdManager idManager;
    private EntryPointManager entryPointManager;
    private ExtInstImportManager extInstImportManager;
    private TypeConstManager typeConstManager;
    private Fn[] fns;

    this(IdManager idManager, EntryPointManager entryPointManager, ExtInstImportManager extInstImportManager, TypeConstManager typeConstManager) {
        this.idManager = idManager;
        this.entryPointManager = entryPointManager;
        this.extInstImportManager = extInstImportManager;
        this.typeConstManager = typeConstManager;
    }

    Id addFunction(Function func) {
        if (func.basicBlocks.empty) return 0;

        auto ft = func.type.elementType;
        auto returnType = typeConstManager.requestType(ft.returnType);
        auto funcId = idManager.requestId(func.name);
        auto funcType = typeConstManager.requestType(ft);

        auto fn = new Fn;

        /* TODO: Correctly handle control mask */
        fn.decl = FunctionInstruction(returnType, funcId, FunctionControlMask.MaskNone, funcType);

        foreach (i, p; func.params.enumerate) {
            auto paramType = typeConstManager.requestType(p.type);
            auto paramId = idManager.requestId(format!"%s.__param__%d"(func.name, i));
            fn.ps ~= FunctionParameterInstruction(paramType, paramId);
        }

        foreach (b; func.basicBlocks) {
            auto bk = new Bk(b, fn);
            fn.blocks[b.block] = bk;
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
            foreach (v; fn.vs) writer.writeInstruction(v);
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
        if (i.isStoreInst) {
            // TODO: handle memory access mask
            auto dst = requestVar(bk, i.operands[0]);
            auto src = requestVar(bk, i.operands[1]);
            add(bk, StoreInstruction(dst, src));
        } else if (i.isLoadInst) {
            // TODO: handle memory access mask
            auto src = requestVar(bk, i.operands[0]);
            auto type = typeConstManager.requestType(i.operands[0].type);
            auto id = idManager.requestId();
            add(bk, LoadInstruction(type, id, src));
        } else if (i.isBinaryOperator) {
            auto op0 = requestVar(bk, i.operands[0]);
            auto op1 = requestVar(bk, i.operands[1]);
            auto type = typeConstManager.requestType(i.type);
            auto id = idManager.requestId();
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
            enum Map = [
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
            // TODO: Handle pointer comparison
            auto op0 = requestVar(bk, i.operands[0]);
            auto op1 = requestVar(bk, i.operands[1]);
            auto pred = Map[i.predicate];
            auto type = typeConstManager.requestType(i.type);
            auto id = idManager.requestId();
            add(bk, ComparisonInstruction(pred, type, id, op0, op1));
        } else if (i.isSelectInst) {
            auto type = typeConstManager.requestType(i.type);
            auto id = idManager.requestId();
            auto condition = requestVar(bk, i.conditionAsSelect);
            auto trueValue = requestVar(bk, i.trueValue);
            auto falseValue = requestVar(bk, i.falseValue);
            add(bk, SelectInstruction(type, id, condition, trueValue, falseValue));
        } else if (i.isAllocaInst) {
            addVariable(bk, i, i.inst);
        } else if (i.isSwitchInst) {
            // TODO: Not yet implemented.
        } else if (i.isBranchInst) {
            // TODO: Handle LoopControlMask 
            auto successor = bk.parent.blocks[i.successor(0).block].id;
            if (!i.isConditional) {
                add(bk, BranchInstruction(successor));
            } else {
                auto condition = requestVar(bk, i.conditionAsBranch);
                auto trueSuccessor = successor;
                auto falseSuccessor = bk.parent.blocks[i.successor(1).block].id;
                add(bk, BranchConditionalInstruction(condition, trueSuccessor, falseSuccessor));
            }
        } else if (i.isPHINode) {
            //TODO: not implemneted yet.
        } else if (i.isExtractValueInst) {
            //TODO: not implemneted yet.
        } else if (i.isInsertValueInst) {
            //TODO: not implemneted yet.
        } else if (i.isUnaryInstruction) {
            //TODO: not implemneted yet.
        } else if (i.isGetElementPtrInst) {
            //TODO: not implemneted yet.
        } else if (i.isExtractElementInst) {
            //TODO: not implemneted yet.
        } else if (i.isInsertElementInst) {
            //TODO: not implemneted yet.
        } else if (i.isShuffleVectorInst) {
            //TODO: not implemneted yet.
        } else if (i.isIntrinsicInst) {
            //TODO: not implemneted yet.
        } else if (i.isCallInst) {
            auto binaryOps = getAttribute!BinaryOps(i.calledFunction, "operator");
            if (binaryOps.empty is false) {
                auto code = BinaryOpsMap[binaryOps.front];
                auto type = typeConstManager.requestType(i.operands[0].type);
                auto id = idManager.requestId();
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
                // auto type = typeConstManager.requestType(i.calledFunction.type.elementType.returnType);
                // auto id = idManager.requestId();
                // auto set = extInstImportManager.requestExtInstImport(setName);
                // uint instIndex = 31;
                // auto operands = i.calledFunction.operands.map!(o => requestVar(bk, o)).array;
                auto type = typeConstManager.requestType(Type.getFloatType!(32));
                auto id = idManager.requestId();
                auto set = extInstImportManager.requestExtInstImport(setName);
                auto operands = [id];
                add(bk, ExtInstInstruction(type, id, set, instIndex, operands));
            }
            //TODO: not implemneted yet.
        } else {
            assert(false);
        }

    }

    private void add(Inst)(Bk bk, Inst i) {
        bk.bs ~= BodyInstruction(i);
    }

    private void addVariable(Op)( Bk bk, Op op, LLVMValueRef val) {
        // TODO: handle initializer
        auto type = typeConstManager.requestType(op.type);
        auto id = idManager.requestId();
        bk.variables[val] = id;
        bk.parent.vs ~= VariableInstruction(type, id, StorageClass.Function);
    }

    private Id requestVar(Bk bk, Operand op) {
        if (op.op !in bk.variables) {
            addVariable(bk, op, op.op);
        }
        return bk.variables[op.op];
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
