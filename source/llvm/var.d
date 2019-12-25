module llvm.var;

import std;
import llvm;
import llvm.value;

struct Variable {
    package LLVMValueRef var;
    mixin ImplValue!(var);
}
