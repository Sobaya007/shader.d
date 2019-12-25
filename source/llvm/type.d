module llvm.type;

import std;
import llvm;

struct Type {
    private LLVMTypeRef type;

    LLVMTypeKind kind() {
        return LLVMGetTypeKind(type);
    }

    bool isSized() {
        return LLVMTypeIsSized(type) > 0;
    }

    string toString() {
        return LLVMPrintTypeToString(type).fromStringz.to!string;
    }

    /* Integer Type */
    uint widthAsInt() 
        in (kind == LLVMIntegerTypeKind)
    {
        return LLVMGetIntTypeWidth(type);
    }

    /* Function Type */
    bool isVarArg() 
        in (kind == LLVMFunctionTypeKind)
    {
        return LLVMIsFunctionVarArg(type) > 0;
    }

    Type returnType() 
        in (kind == LLVMFunctionTypeKind)
    {
        return Type(LLVMGetReturnType(type));
    }

    auto paramTypes() 
        in (kind == LLVMFunctionTypeKind)
    {
        auto cnt = LLVMCountParamTypes(type);
        auto res = new LLVMTypeRef[cnt];
        LLVMGetParamTypes(type, res.ptr);
        return res.map!(t => Type(t));
    }

    /* Struct Type */

    string nameAsStruct() 
        in (kind == LLVMStructTypeKind)
    {
        return fromStringz(LLVMGetStructName(type)).to!string;
    }

    auto memberTypes()
        in (kind == LLVMStructTypeKind)
    {
        auto cnt = LLVMCountStructElementTypes(type);
        auto res = new LLVMTypeRef[cnt];
        LLVMGetStructElementTypes(type, res.ptr);
        return res.map!(t =>Type(t));
    }

    bool isPacked() 
        in (kind == LLVMStructTypeKind)
    {
        return LLVMIsPackedStruct(type) > 0;
    }
    bool isOpaque() 
        in (kind == LLVMStructTypeKind)
    {
        return LLVMIsOpaqueStruct(type) > 0;
    }

    bool isLiteral() 
        in (kind == LLVMStructTypeKind)
    {
        return LLVMIsLiteralStruct(type) > 0;
    }

    /* Array Type */
    Type elementType() 
        in (kind == LLVMArrayTypeKind || kind == LLVMVectorTypeKind || kind == LLVMPointerTypeKind)
    {
        return Type(LLVMGetElementType(type));
    }

    uint lengthAsArray()
        in (kind == LLVMArrayTypeKind)
    {
        return LLVMGetArrayLength(type);
    }

    uint lengthAsVector() 
    {
        return LLVMGetVectorSize(type);
    }

    static Type getIntegerType(size_t sz)() {
        static if (sz == 1) {
            return Type(LLVMInt1Type());
        } else static if (sz == 8) {
            return Type(LLVMInt8Type());
        } else static if (sz == 16) {
            return Type(LLVMInt16Type());
        } else static if (sz == 32) {
            return Type(LLVMInt32Type());
        } else static if (sz == 64) {
            return Type(LLVMInt64Type());
        } else {
            static assert(false);
        }
    }

    static Type getFloatType(size_t sz)() {
        static if (sz == 16) {
            return Type(LLVMHalfType());
        } else static if (sz == 32) {
            return Type(LLVMFloatType());
        } else static if (sz == 64) {
            return Type(LLVMDoubleType());
        } else {
            static assert(false);
        }
    }
}
