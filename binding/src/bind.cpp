#include <llvm-c/Core.h>
#include <llvm-c/Types.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/InstrTypes.h>
#include <llvm/IR/GlobalVariable.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/Support/Casting.h>

using namespace llvm;

extern "C" {

unsigned LLVMGetAttributeCount(LLVMValueRef GlobalVar) {
  auto AS = unwrap<GlobalVariable>(GlobalVar)->getAttributes();
  return AS.getNumAttributes();
}

void LLVMGetAttributes(LLVMValueRef GlobalVar, LLVMAttributeRef *Attrs) {
  auto AS = unwrap<GlobalVariable>(GlobalVar)->getAttributes();
  for (auto A : AS)
    *Attrs++ = wrap(A);
}

const char* LLVMGetAllocInstName(LLVMValueRef AllocInst, size_t *Length) {
    Value *P = unwrap<Value>(AllocInst);
    AllocaInst *AI = dyn_cast<AllocaInst>(P);
    *Length = AI->getName().size();
    return AI->getName().data();
}

LLVMValueRef LLVMIsABinaryOperator(LLVMValueRef Val) {
    return wrap(static_cast<Value*>(dyn_cast_or_null<BinaryOperator>(unwrap(Val))));
}

Instruction::BinaryOps LLVMGetBinaryOpcode(LLVMValueRef Val) {
    return dyn_cast<BinaryOperator>(unwrap(Val))->getOpcode();
}

unsigned LLVMGetUnaryOpcode(LLVMValueRef Val) {
    return dyn_cast<UnaryInstruction>(unwrap(Val))->getOpcode();
}

LLVMValueRef LLVMGetReturnValue(LLVMValueRef Val) {
    return wrap(dyn_cast<ReturnInst>(unwrap(Val))->getReturnValue());
}

CmpInst::Predicate LLVMGetPredicate(LLVMValueRef Val) {
    return dyn_cast<CmpInst>(unwrap(Val))->getPredicate();
}

LLVMValueRef LLVMGetSelectCondition(LLVMValueRef Val) {
    return wrap(dyn_cast<SelectInst>(unwrap(Val))->getCondition());
}

LLVMValueRef LLVMGetTrueValue(LLVMValueRef Val) {
    return wrap(dyn_cast<SelectInst>(unwrap(Val))->getTrueValue());
}

LLVMValueRef LLVMGetFalseValue(LLVMValueRef Val) {
    return wrap(dyn_cast<SelectInst>(unwrap(Val))->getFalseValue());
}

LLVMValueRef LLVMGetSwitchCondition(LLVMValueRef Val) {
    return wrap(dyn_cast<SwitchInst>(unwrap(Val))->getCondition());
}

LLVMValueRef LLVMGetCalledFunction(LLVMValueRef Val) {
    return wrap(dyn_cast<CallInst>(unwrap(Val))->getCalledFunction());
}

LLVMValueRef LLVMGetArgOperands(LLVMValueRef Val, unsigned i) {
    return wrap(dyn_cast<CallInst>(unwrap(Val))->getArgOperand(i));
}

}
