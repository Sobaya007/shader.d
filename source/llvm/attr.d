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

enum AttributeEnum : uint {
    Alignment = 0,
    AllocSize,
    AlwaysInline,
    ArgMemOnly,
    Builtin,
    ByVal,
    Cold,
    Convergent,
    Dereferenceable,
    DereferenceableOrNull,
    ImmArg,
    InAlloca,
    InReg,
    InaccessibleMemOnly,
    InaccessibleMemOrArgMemOnly,
    InlineHint,
    JumpTable,
    MinSize,
    Naked,
    Nest,
    NoAlias,
    NoBuiltin,
    NoCapture,
    NoCfCheck,
    NoDuplicate,
    NoFree,
    NoImplicitFloat,
    NoInline,
    NoRecurse,
    NoRedZone,
    NoReturn,
    NoSync,
    NoUnwind,
    NonLazyBind,
    NonNull,
    OptForFuzzing,
    OptimizeForSize,
    OptimizeNone,
    ReadNone,
    ReadOnly,
    Returned,
    ReturnsTwice,
    SExt,
    SafeStack,
    SanitizeAddress,
    SanitizeHWAddress,
    SanitizeMemTag,
    SanitizeMemory,
    SanitizeThread,
    ShadowCallStack,
    Speculatable,
    SpeculativeLoadHardening,
    StackAlignment,
    StackProtect,
    StackProtectReq,
    StackProtectStrong,
    StrictFP,
    StructRet,
    SwiftError,
    SwiftSelf,
    UWTable,
    WillReturn,
    WriteOnly,
    ZExt,
}
