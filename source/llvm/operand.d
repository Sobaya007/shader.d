module llvm.operand;

import std;
import llvm;
import llvm.value;

struct Operand { 
    LLVMValueRef op;

    mixin ImplValue!(op);
}
