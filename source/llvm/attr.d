module llvm.attr;

import std;
import llvm;

struct Attribute {
    package LLVMAttributeRef attr;

    uint kindAsEnum() {
        return LLVMGetEnumAttributeKind(attr);
    }

    ulong valueAsEnum() {
        return LLVMGetEnumAttributeValue(attr);
    }

    string kindAsString() {
        uint len;
        auto res = LLVMGetStringAttributeKind(attr, &len);
        return res[0..len].to!string;
    }

    string valueAsString() {
        uint len;
        auto res = LLVMGetStringAttributeValue(attr, &len);
        return res[0..len].to!string;
    }

    bool isEnum() {
        return LLVMIsEnumAttribute(attr) > 0;
    }

    bool isString() {
        return LLVMIsStringAttribute(attr) > 0;
    }

    string toString() {
        if (isEnum()) {
            return format!"%d : %d"(kindAsEnum, valueAsEnum);
        }
        if (isString()) {
            return format!"%s : %s"(kindAsString, valueAsString);
        }
        assert(false);
    }
}
