#include <llvm-c/Core.h>
#include <llvm/IR/GlobalVariable.h>

using namespace llvm;

unsigned LLVMGetAttributeCount(LLVMValueRef GlobalVar) {
  auto AS = unwrap<GlobalVariable>(GlobalVar)->getAttributes();
  return AS.getNumAttributes();
}

void LLVMGetAttributes(LLVMValueRef GlobalVar, LLVMAttributeRef *Attrs) {
  auto AS = unwrap<GlobalVariable>(GlobalVar)->getAttributes();
  for (auto A : AS)
    *Attrs++ = wrap(A);
}
