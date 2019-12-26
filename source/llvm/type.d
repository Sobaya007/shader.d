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

    string name() {
        final switch (kind) {
            case LLVMVoidTypeKind: return "void";
            case LLVMHalfTypeKind: return "half";
            case LLVMFloatTypeKind: return "float";
            case LLVMDoubleTypeKind: return "double";
            case LLVMX86_FP80TypeKind: return "fp80";
            case LLVMFP128TypeKind: return "quad";
            case LLVMPPC_FP128TypeKind: return "ppc_quad";
            case LLVMLabelTypeKind: assert(false);
            case LLVMIntegerTypeKind:
                // TODO: How can I determine sign?
                final switch (widthAsInt) {
                    case 1: return "bit";
                    case 8: return "byte";
                    case 16: return "short";
                    case 32: return "int";
                    case 64: return "long";
                }
            case LLVMFunctionTypeKind:
                return format!"%s (%s)"(returnType.name,
                     paramTypes.map!(p => p.name).join(", "));
            case LLVMStructTypeKind: return nameAsStruct;
            case LLVMArrayTypeKind:
                return format!"%s[%d]"(elementType.name, lengthAsArray);
            case LLVMPointerTypeKind:
                return format!"%s*"(elementType.name);
            case LLVMVectorTypeKind:
                return format!"Vector!(%s, %d)"(elementType.name, lengthAsVector);
            case LLVMMetadataTypeKind:
                assert(false);
            case LLVMX86_MMXTypeKind:
                assert(false);
            case LLVMTokenTypeKind:
                assert(false);
        }
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

    static Type getVectorType(Type elementType, uint elementCount) {
        return Type(LLVMVectorType(elementType.type, elementCount));
    }
}
