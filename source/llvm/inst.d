module llvm.inst;

import std;
import llvm;
import llvm.type;
import llvm.value;

struct Instruction {
    package LLVMValueRef inst;

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

    // LLVMValueRef LLVMIsAAllocaInst(LLVMValueRef Val);
    /*
    LLVMValueRef LLVMIsAAllocaInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAArgument(LLVMValueRef Val);
    LLVMValueRef LLVMIsABitCastInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsABlockAddress(LLVMValueRef Val);
    LLVMValueRef LLVMIsABranchInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsACallInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsACastInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAAddrSpaceCastInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsACmpInst(LLVMValueRef Val);

    LLVMValueRef LLVMIsADbgDeclareInst(LLVMValueRef Val);
    static if (LLVM_Version >= asVersion(8, 0, 0)) {
        LLVMValueRef LLVMIsADbgLabelInst(LLVMValueRef Val);
    }
    LLVMValueRef LLVMIsADbgInfoIntrinsic(LLVMValueRef Val);
    LLVMValueRef LLVMIsAExtractElementInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAExtractValueInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAFCmpInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAFPExtInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAFPToSIInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAFPToUIInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAFPTruncInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAGetElementPtrInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAGlobalObject(LLVMValueRef Val);
    LLVMValueRef LLVMIsAFunction(LLVMValueRef Val);
    LLVMValueRef LLVMIsAGlobalVariable(LLVMValueRef Val);
    LLVMValueRef LLVMIsAICmpInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAIndirectBrInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAInlineAsm(LLVMValueRef Val);
    LLVMValueRef LLVMIsAInsertElementInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAInsertValueInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAInstruction(LLVMValueRef Val);
    LLVMValueRef LLVMIsAIntrinsicInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAIntToPtrInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAInvokeInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsALandingPadInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsALoadInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAMDNode(LLVMValueRef Val);
    LLVMValueRef LLVMIsAMDString(LLVMValueRef Val);
    LLVMValueRef LLVMIsAMemCpyInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAMemIntrinsic(LLVMValueRef Val);
    LLVMValueRef LLVMIsAMemMoveInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAMemSetInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAPHINode(LLVMValueRef Val);
    LLVMValueRef LLVMIsAPtrToIntInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAResumeInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsACleanupReturnInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsACatchReturnInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAFuncletPadInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsACatchPadInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsACleanupPadInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAReturnInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsASelectInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsASExtInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAShuffleVectorInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsASIToFPInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAStoreInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsASwitchInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsATerminatorInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsATruncInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAUIToFPInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAUnaryInstruction(LLVMValueRef Val);
    LLVMValueRef LLVMIsAUndefValue(LLVMValueRef Val);
    LLVMValueRef LLVMIsAUnreachableInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAUser(LLVMValueRef Val);
    LLVMValueRef LLVMIsAVAArgInst(LLVMValueRef Val);
    LLVMValueRef LLVMIsAZExtInst(LLVMValueRef Val);
    */
}
/*
    LLVMValueRef LLVMIsAConstantExpr(LLVMValueRef Val);
    LLVMValueRef LLVMIsAConstantFP(LLVMValueRef Val);
    LLVMValueRef LLVMIsAConstantInt(LLVMValueRef Val);
    LLVMValueRef LLVMIsAConstant(LLVMValueRef Val);
    LLVMValueRef LLVMIsAConstantPointerNull(LLVMValueRef Val);
    LLVMValueRef LLVMIsAConstantStruct(LLVMValueRef Val);
    static if (LLVM_Version >= asVersion(3, 8, 0)) {
        LLVMValueRef LLVMIsAConstantTokenNone(LLVMValueRef Val);
    }
    LLVMValueRef LLVMIsAConstantVector(LLVMValueRef Val);
    static if (LLVM_Version >= asVersion(8, 0, 0)) {
        LLVMValueRef LLVMIsADbgVariableIntrinsic(LLVMValueRef Val);
    }
    LLVMValueRef LLVMIsAGlobalValue(LLVMValueRef Val);
    LLVMValueRef LLVMIsAGlobalAlias(LLVMValueRef Val);
    static if (LLVM_Version >= asVersion(8, 0, 0)) {
        LLVMValueRef LLVMIsAGlobalIFunc(LLVMValueRef Val);
    }
    */
