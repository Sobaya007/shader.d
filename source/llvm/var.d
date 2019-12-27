module llvm.var;

import std;
import llvm;
import llvm.attr;
import llvm.value;

extern(C) uint LLVMGetAttributeCount(LLVMValueRef);
extern(C) void LLVMGetAttributes(LLVMValueRef, LLVMAttributeRef*);

struct Variable {
    LLVMValueRef var;
    mixin ImplValue!(var);

    Variable next() {
        return Variable(LLVMGetNextGlobal(var));
    }

    auto attributes() {
        int cnt = LLVMGetAttributeCount(var);
        auto res = new LLVMAttributeRef[cnt];
        LLVMGetAttributes(var, res.ptr);
        return res.map!(a => Attribute(a));
    }
}
