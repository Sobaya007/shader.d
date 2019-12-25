module llvm.operand;

import std;
import llvm;
import llvm.value;

struct Operand { 
    package LLVMValueRef op;

    mixin ImplValue!(op);
}
