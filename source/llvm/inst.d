module llvm.inst;

import std;
import llvm;
import llvm.block;
import llvm.func;
import llvm.type;
import llvm.operand;
import llvm.value;

extern(C) {
    LLVMValueRef LLVMIsABinaryOperator(LLVMValueRef);
    BinaryOps LLVMGetOpcode(LLVMValueRef);
    LLVMValueRef LLVMGetReturnValue(LLVMValueRef);
    Predicate LLVMGetPredicate(LLVMValueRef);
    LLVMValueRef LLVMGetSelectCondition(LLVMValueRef);
    LLVMValueRef LLVMGetTrueValue(LLVMValueRef);
    LLVMValueRef LLVMGetFalseValue(LLVMValueRef);
    LLVMValueRef LLVMGetCalledFunction(LLVMValueRef);
    LLVMValueRef LLVMGetArgOperands(LLVMValueRef, uint);
}

struct Instruction {
    LLVMValueRef inst;

    mixin ImplValue!(inst);

    Instruction next() {
        return Instruction(LLVMGetNextInstruction(inst));
    }

    LLVMOpcode opcode() {
        return LLVMGetInstructionOpcode(inst);
    }

    Type allocatedType()
        in (opcode == LLVMAlloca)
        {
            return Type(LLVMGetAllocatedType(inst));
        }

    uint numArgOperands() {
        return LLVMGetNumArgOperands(inst);
    }

    BinaryOps opcodeAsBinary() {
        return LLVMGetOpcode(inst);
    }

    Nullable!Operand returnValue() {
        auto v = LLVMGetReturnValue(inst);
        return v ? Operand(v).nullable : Nullable!Operand.init;
    }

    Predicate predicate() {
        return LLVMGetPredicate(inst);
    }

    Operand conditionAsSelect() {
        return Operand(LLVMGetSelectCondition(inst));
    }

    Operand trueValue() {
        return Operand(LLVMGetTrueValue(inst));
    }

    Operand falseValue() {
        return Operand(LLVMGetFalseValue(inst));
    }

    BasicBlock successor(uint i) {
        return BasicBlock(LLVMGetSuccessor(inst, i));
    }

    bool isConditional() {
        return LLVMIsConditional(inst) > 0;
    }

    Operand conditionAsBranch() {
        return Operand(LLVMGetCondition(inst));
    }

    Function calledFunction() {
        return Function(LLVMGetCalledFunction(inst));
    }

    Operand argOperand(uint i) {
        return Operand(LLVMGetArgOperands(inst, i));
    }

    Operand[] argOperands() {
        return iota(numArgOperands).map!(i => argOperand(i)).array;
    }

    ulong zExtValue() {
        return LLVMConstIntGetZExtValue(inst);
    }

    double getConstDouble() {
        LLVMBool losesInfo;
        return LLVMConstRealGetDouble(inst, &losesInfo);
    }

    double getConstDouble(ref bool losesInfo) {
        LLVMBool _losesInfo;
        scope (exit) losesInfo = _losesInfo > 0;
        return LLVMConstRealGetDouble(inst, &_losesInfo);
    }

    Operand elementAsConstant(uint idx) {
        return Operand(LLVMGetElementAsConstant(inst, idx));
    }

    bool isAllocaInst() {
        return LLVMIsAAllocaInst(inst) !is null;
    }

    bool isArgument() {
        return LLVMIsAArgument(inst) !is null;
    }

    bool isBitCastInst() {
        return LLVMIsABitCastInst(inst) !is null;
    }

    bool isBlockAddress() {
        return LLVMIsABlockAddress(inst) !is null;
    }

    bool isBranchInst() {
        return LLVMIsABranchInst(inst) !is null;
    }

    bool isCallInst() {
        return LLVMIsACallInst(inst) !is null;
    }

    bool isCastInst() {
        return LLVMIsACastInst(inst) !is null;
    }

    bool isAddrSpaceCastInst() {
        return LLVMIsAAddrSpaceCastInst(inst) !is null;
    }

    bool isCmpInst() {
        return LLVMIsACmpInst(inst) !is null;
    }


    bool isDbgDeclareInst() {
        return LLVMIsADbgDeclareInst(inst) !is null;
    }

    bool isDbgLabelInst() {
        return LLVMIsADbgLabelInst(inst) !is null;
    }

    bool isDbgInfoIntrinsic() {
        return LLVMIsADbgInfoIntrinsic(inst) !is null;
    }

    bool isExtractElementInst() {
        return LLVMIsAExtractElementInst(inst) !is null;
    }

    bool isExtractValueInst() {
        return LLVMIsAExtractValueInst(inst) !is null;
    }

    bool isFCmpInst() {
        return LLVMIsAFCmpInst(inst) !is null;
    }

    bool isFPExtInst() {
        return LLVMIsAFPExtInst(inst) !is null;
    }

    bool isFPToSIInst() {
        return LLVMIsAFPToSIInst(inst) !is null;
    }

    bool isFPToUIInst() {
        return LLVMIsAFPToUIInst(inst) !is null;
    }

    bool isFPTruncInst() {
        return LLVMIsAFPTruncInst(inst) !is null;
    }

    bool isGetElementPtrInst() {
        return LLVMIsAGetElementPtrInst(inst) !is null;
    }

    bool isGlobalObject() {
        return LLVMIsAGlobalObject(inst) !is null;
    }

    bool isFunction() {
        return LLVMIsAFunction(inst) !is null;
    }

    bool isGlobalVariable() {
        return LLVMIsAGlobalVariable(inst) !is null;
    }

    bool isICmpInst() {
        return LLVMIsAICmpInst(inst) !is null;
    }

    bool isIndirectBrInst() {
        return LLVMIsAIndirectBrInst(inst) !is null;
    }

    bool isInlineAsm() {
        return LLVMIsAInlineAsm(inst) !is null;
    }

    bool isInsertElementInst() {
        return LLVMIsAInsertElementInst(inst) !is null;
    }

    bool isInsertValueInst() {
        return LLVMIsAInsertValueInst(inst) !is null;
    }

    bool isInstruction() {
        return LLVMIsAInstruction(inst) !is null;
    }

    bool isIntrinsicInst() {
        return LLVMIsAIntrinsicInst(inst) !is null;
    }

    bool isIntToPtrInst() {
        return LLVMIsAIntToPtrInst(inst) !is null;
    }

    bool isInvokeInst() {
        return LLVMIsAInvokeInst(inst) !is null;
    }

    bool isLandingPadInst() {
        return LLVMIsALandingPadInst(inst) !is null;
    }

    bool isLoadInst() {
        return LLVMIsALoadInst(inst) !is null;
    }

    bool isMDNode() {
        return LLVMIsAMDNode(inst) !is null;
    }

    bool isMDString() {
        return LLVMIsAMDString(inst) !is null;
    }

    bool isMemCpyInst() {
        return LLVMIsAMemCpyInst(inst) !is null;
    }

    bool isMemIntrinsic() {
        return LLVMIsAMemIntrinsic(inst) !is null;
    }

    bool isMemMoveInst() {
        return LLVMIsAMemMoveInst(inst) !is null;
    }

    bool isMemSetInst() {
        return LLVMIsAMemSetInst(inst) !is null;
    }

    bool isPHINode() {
        return LLVMIsAPHINode(inst) !is null;
    }

    bool isPtrToIntInst() {
        return LLVMIsAPtrToIntInst(inst) !is null;
    }

    bool isResumeInst() {
        return LLVMIsAResumeInst(inst) !is null;
    }

    bool isCleanupReturnInst() {
        return LLVMIsACleanupReturnInst(inst) !is null;
    }

    bool isCatchReturnInst() {
        return LLVMIsACatchReturnInst(inst) !is null;
    }

    bool isFuncletPadInst() {
        return LLVMIsAFuncletPadInst(inst) !is null;
    }

    bool isCatchPadInst() {
        return LLVMIsACatchPadInst(inst) !is null;
    }

    bool isCleanupPadInst() {
        return LLVMIsACleanupPadInst(inst) !is null;
    }

    bool isReturnInst() {
        return LLVMIsAReturnInst(inst) !is null;
    }

    bool isSelectInst() {
        return LLVMIsASelectInst(inst) !is null;
    }

    bool isSExtInst() {
        return LLVMIsASExtInst(inst) !is null;
    }

    bool isShuffleVectorInst() {
        return LLVMIsAShuffleVectorInst(inst) !is null;
    }

    bool isSIToFPInst() {
        return LLVMIsASIToFPInst(inst) !is null;
    }

    bool isStoreInst() {
        return LLVMIsAStoreInst(inst) !is null;
    }

    bool isSwitchInst() {
        return LLVMIsASwitchInst(inst) !is null;
    }

    bool isTerminatorInst() {
        return LLVMIsATerminatorInst(inst) !is null;
    }

    bool isTruncInst() {
        return LLVMIsATruncInst(inst) !is null;
    }

    bool isUIToFPInst() {
        return LLVMIsAUIToFPInst(inst) !is null;
    }

    bool isUnaryInstruction() {
        return LLVMIsAUnaryInstruction(inst) !is null;
    }

    bool isUndefValue() {
        return LLVMIsAUndefValue(inst) !is null;
    }

    bool isUnreachableInst() {
        return LLVMIsAUnreachableInst(inst) !is null;
    }

    bool isUser() {
        return LLVMIsAUser(inst) !is null;
    }

    bool isVAArgInst() {
        return LLVMIsAVAArgInst(inst) !is null;
    }

    bool isZExtInst() {
        return LLVMIsAZExtInst(inst) !is null;
    }

    bool isConstantExpr() {
        return LLVMIsAConstantExpr(inst) !is null;
    }

    bool isConstantFP() {
        return LLVMIsAConstantFP(inst) !is null;
    }

    bool isConstantInt() {
        return LLVMIsAConstantInt(inst) !is null;
    }

    bool isConstant() {
        return LLVMIsAConstant(inst) !is null;
    }

    bool isConstantPointerNull() {
        return LLVMIsAConstantPointerNull(inst) !is null;
    }

    bool isConstantStruct() {
        return LLVMIsAConstantStruct(inst) !is null;
    }

    bool isConstantTokenNone() {
        return LLVMIsAConstantTokenNone(inst) !is null;
    }

    bool isConstantVector() {
        return LLVMIsAConstantVector(inst) !is null;
    }

    bool isConstantDataVector() {
        return LLVMIsAConstantDataVector(inst) !is null;
    }

    bool isDbgVariableIntrinsic() {
        return LLVMIsADbgVariableIntrinsic(inst) !is null;
    }

    bool isGlobalValue() {
        return LLVMIsAGlobalValue(inst) !is null;
    }

    bool isGlobalAlias() {
        return LLVMIsAGlobalAlias(inst) !is null;
    }

    bool isGlobalIFunc() {
        return LLVMIsAGlobalIFunc(inst) !is null;
    }

    bool isBinaryOperator() {
        return LLVMIsABinaryOperator(inst) !is null;
    }
}

enum BinaryOps {
    Add = 13,
    FAdd = 14,
    Sub = 15,
    FSub = 16,
    Mul = 17,
    FMul = 18,
    UDiv = 19,
    SDiv = 20,
    FDiv = 21,
    URem = 22,
    SRem = 23,
    FRem = 24,
    Shl = 25,
    LShr = 26,
    RShr = 27,
    And = 28,
    Or = 29,
    Xor = 30,
}

enum Predicate {
    FCMP_FALSE = 0,
    FCMP_OEQ = 1,
    FCMP_OGT = 2,
    FCMP_OGE = 3,
    FCMP_OLT = 4,
    FCMP_OLE = 5,
    FCMP_ONE = 6,
    FCMP_ORD = 7,
    FCMP_UNO = 8,
    FCMP_UEQ = 9,
    FCMP_UGT = 10,
    FCMP_UGE = 11,
    FCMP_ULT = 12,
    FCMP_ULE = 13,
    FCMP_UNE = 14,
    FCMP_TRUE = 15,
    ICMP_EQ = 32,
    ICMP_NE = 33,
    ICMP_UGT = 34,
    ICMP_UGE = 35,
    ICMP_ULT = 36,
    ICMP_ULE = 37,
    ICMP_SGT = 38,
    ICMP_SGE = 39,
    ICMP_SLT = 40,
    ICMP_SLE = 41,
}
