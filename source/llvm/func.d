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
    
    auto attributes() {
        return getAttributes(LLVMAttributeFunctionIndex);
    }

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

    Function next() {
        return Function(LLVMGetNextFunction(func));
    }

    private auto getAttributes(LLVMAttributeIndex idx) {
        import std;
        int cnt = LLVMGetAttributeCountAtIndex(func, idx);
        auto res = new LLVMAttributeRef[cnt];
        LLVMGetAttributesAtIndex(func, idx, res.ptr);
        return res.map!(a => Attribute(a));
    }

    LLVMAttributeRef enumAttribute(LLVMAttributeIndex idx, uint kindID) {
        return LLVMGetEnumAttributeAtIndex(func, idx, kindID);
    }

    LLVMAttributeRef stringAttribute(LLVMAttributeIndex idx, string str) {
        return LLVMGetStringAttributeAtIndex(func, idx, str.ptr, cast(uint)str.length);
    }
}
