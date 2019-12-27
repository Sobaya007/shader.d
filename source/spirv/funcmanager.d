module spirv.funcmanager;

import std;
import spirv.entrypointmanager;
import spirv.spv;
import spirv.typeconstmanager;
import spirv.idmanager;
import spirv.instruction;
import spirv.writer;
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
);
alias BodyInstruction = Algebraic!(BodyInstructions);

class FunctionManager {

    struct Fn {
        FunctionInstruction decl;
        FunctionParameterInstruction[] ps;
        VariableInstruction[] vs;
        BodyInstruction[] bs;
        FunctionEndInstruction end;
        EntryPoint ep;
        Id[LLVMValueRef] variables;
    }

    private IdManager idManager;
    private EntryPointManager entryPointManager;
    private TypeConstManager typeConstManager;
    private Fn[] fns;

    this(IdManager idManager, EntryPointManager entryPointManager, TypeConstManager typeConstManager) {
        this.idManager = idManager;
        this.entryPointManager = entryPointManager;
        this.typeConstManager = typeConstManager;
    }

    Id addFunction(Function func) {
        auto ft = func.type.elementType;
        auto returnType = typeConstManager.requestType(ft.returnType);
        auto funcId = idManager.requestId(func.name);
        auto funcType = typeConstManager.requestType(ft);

        Fn fn;

        /* TODO: Correctly handle control mask */
        fn.decl = FunctionInstruction(returnType, funcId, FunctionControlMask.MaskNone, funcType);

        foreach (i, p; func.params.enumerate) {
            auto paramType = typeConstManager.requestType(p.type);
            auto paramId = idManager.requestId(format!"%s.__param__%d"(func.name, i));
            fn.ps ~= FunctionParameterInstruction(paramType, paramId);
        }

        foreach (b; func.basicBlocks) {
            addBlock(fn, b);
        }

        auto epAttr = func.attributes.find!(a => a.isString && a.kindAsString == "entryPoint");
        if (epAttr.empty is false) {
            auto model = epAttr.front.valueAsString.to!ExecutionModel;
            auto e = entryPointManager.addEntryPoint(funcId, model);
            foreach (a; func.attributes.filter!(a => a.isString && a.kindAsString == "execMode")) {
                e.addMode(a.valueAsString.to!ExecutionMode);
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
body: foreach (b; fn.bs) {
                static foreach (I; BodyInstructions) {
                    if (auto r = b.peek!I) {
                        writer.writeInstruction(*r);
                        continue body;
                    }
                }
                assert(false);
            }
            writer.writeInstruction(fn.end);
        }
    }

    private Id addBlock(ref Fn fn, BasicBlock block) {
        auto id = idManager.requestId();
        add(fn, LabelInstruction(id));
        foreach (i; block.instructions) {
            addBodyInstruction(fn, i);
        }
        return id;
    }

    private void addBodyInstruction(ref Fn fn, Instruction i) {
        if (i.isStoreInst) {
            // TODO: handle memory access mask
            auto dst = requestVar(fn, i.operands[0]);
            auto src = requestVar(fn, i.operands[1]);
            add(fn, StoreInstruction(dst, src));
        } else if (i.isLoadInst) {
            // TODO: handle memory access mask
            auto src = requestVar(fn, i.operands[0]);
            auto type = typeConstManager.requestType(i.operands[0].type);
            auto id = idManager.requestId();
            add(fn, LoadInstruction(type, id, src));
        } else if (i.isBinaryOperator) {
            enum Map = [
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
            auto op0 = requestVar(fn, i.operands[0]);
            auto op1 = requestVar(fn, i.operands[1]);
            auto type = typeConstManager.requestType(i.type);
            auto id = idManager.requestId();
            auto code = Map[i.opcodeAsBinary];
            add(fn, BinaryOpInstrucion(code, type, id, op0, op1));
        } else if (i.isUnreachableInst) {
            add(fn, UnreachableInstruction());
        } else if (i.isReturnInst) {
            auto ret = i.returnValue;
            if (ret.isNull) {
                add(fn, ReturnInstruction());
            } else {
                add(fn, ReturnValueInstruction(requestVar(fn, ret.get())));
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
            auto op0 = requestVar(fn, i.operands[0]);
            auto op1 = requestVar(fn, i.operands[1]);
            auto pred = Map[i.predicate];
            auto type = typeConstManager.requestType(i.type);
            auto id = idManager.requestId();
            add(fn, ComparisonInstruction(pred, type, id, op0, op1));
        } else if (i.isSelectInst) {
            auto type = typeConstManager.requestType(i.type);
            auto id = idManager.requestId();
            auto condition = requestVar(fn, i.conditionAsSelect);
            auto trueValue = requestVar(fn, i.trueValue);
            auto falseValue = requestVar(fn, i.falseValue);
            add(fn, SelectInstruction(type, id, condition, trueValue, falseValue));
        } else if (i.isAllocaInst) {
            addVariable(fn, i, i.inst);
        } else if (i.isSwitchInst) {
            // TODO: Not yet implemented.
        } else if (i.isBranchInst) {
            // TODO: do
            // TODO: Handle LoopControlMask 
            // auto successor = addBlock(fn, i.successor(0));
            /*
            if (!i.isConditional) {
                add(fn, BranchInstruction(successor));
            } else {
                auto condition = requestVar(fn, i.conditionAsBranch);
                auto trueSuccessor = successor;
                auto falseSuccessor = addBlock(fn, i.successor(1));
                add(fn, BranchConditionalInstruction(condition, trueSuccessor, falseSuccessor));
            }
            */
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
            //TODO: not implemneted yet.
        } else {
            assert(false);
        }

    }

    private void add(Inst)(ref Fn fn, Inst i) {
        fn.bs ~= BodyInstruction(i);
    }

    private void addVariable(Op)(ref Fn fn, Op op, LLVMValueRef val) {
        // TODO: handle initializer
        auto type = typeConstManager.requestType(op.type);
        auto id = idManager.requestId();
        fn.variables[val] = id;
        fn.vs ~= VariableInstruction(type, id, StorageClass.Function);
    }

    private Id requestVar(ref Fn fn, Operand op) {
        if (op.op !in fn.variables) {
            addVariable(fn, op, op.op);
        }
        return fn.variables[op.op];
    }
}
