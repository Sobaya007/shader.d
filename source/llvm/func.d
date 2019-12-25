module llvm.func;

import std;
import llvm;
import llvm.attr;
import llvm.block;
import llvm.type;
import llvm.var;
import llvm.value;


struct Function {
    package LLVMValueRef func;

    mixin ImplValue!(func);

    auto params() {
        auto cnt = LLVMCountParams(func);
        auto res = new LLVMValueRef[cnt];
        LLVMGetParams(func, res.ptr);
        return res.map!(p => Variable(p));
    }

    auto basicBlocks() {
        auto cnt = LLVMCountBasicBlocks(func);
        auto res = new LLVMBasicBlockRef[cnt];
        LLVMGetBasicBlocks(func, res.ptr);   
        return res.map!(b => BasicBlock(b));
    }
}
