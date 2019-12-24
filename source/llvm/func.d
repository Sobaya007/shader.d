module llvm.func;

import std;
import llvm;
import llvm.attr;

struct Function {
    package LLVMValueRef func;

    string name() {
        size_t len;
        auto res = LLVMGetValueName2(func, &len);
        return res[0..len].to!string;
    }

    auto attributes() {
        return getAttributes(LLVMAttributeFunctionIndex);
    }

    private auto getAttributes(LLVMAttributeIndex idx) {
        uint cnt = LLVMGetAttributeCountAtIndex(func, idx);
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
