module spirv.typemanager;

import std;
import spirv.spv;
import spirv.idmanager;
import spirv.instruction;
import spirv.writer;
import llvm;
import llvm.type;

alias TypeInstructions = AliasSeq!(
    TypeVoidInstruction,
    TypeBoolInstruction,
    TypeIntInstruction,
    TypeFloatInstruction,
    TypeVectorInstruction,
    TypeMatrixInstruction,
    TypeImageInstruction,
    TypeSampledImageInstruction,
    TypeArrayInstruction,
    TypeRuntimeArrayInstruction,
    TypeStructInstruction,
    TypeOpaqueInstruction,
    TypePointerInstruction,
    TypeFunctionInstruction,
    TypeForwardPointerInstruction,
);

alias TypeInstruction = Algebraic!(TypeInstructions);

class TypeManager {

    private IdManager idManager;
    private Id[string] types;
    private TypeInstruction[] instructions;

    this(IdManager idManager) {
        this.idManager = idManager;
    }

    Id requestType(Type type) {
        auto name = type.toString();
        if (auto res = name in types) return *res;

        // TODO: handle all kind
        final switch (type.kind) {
            case LLVMVoidTypeKind:
                return newType!(TypeVoidInstruction)(name);
            case LLVMHalfTypeKind:
                return newType!(TypeFloatInstruction)(name, 16);
            case LLVMFloatTypeKind:
                return newType!(TypeFloatInstruction)(name, 32);
            case LLVMDoubleTypeKind:
                return newType!(TypeFloatInstruction)(name, 64);
            case LLVMX86_FP80TypeKind:
                assert(false);
            case LLVMFP128TypeKind:
                return newType!(TypeFloatInstruction)(name, 128);
            case LLVMPPC_FP128TypeKind:
                assert(false);
            case LLVMLabelTypeKind:
                assert(false);
            case LLVMIntegerTypeKind:
                return newType!(TypeIntInstruction)(name, type.widthAsInt);
            case LLVMFunctionTypeKind:
                return newType!(TypeFunctionInstruction)
                    (name, 
                     requestType(type.returnType),
                     type.paramTypes.map!(p => requestType(p)).array);
            case LLVMStructTypeKind:
                if (isBuiltin(name)) return newBuiltinType(name);
                return newType!(TypeStructInstruction)
                    (name,
                     type.memberTypes.map!(p => requestType(p)).array);
            case LLVMArrayTypeKind:
                return newType!(TypeArrayInstruction)
                    (name,
                     requestType(type.elementType),
                     type.lengthAsArray);
            case LLVMPointerTypeKind:
                // TODO: handle StorageClass correctly
                return newType!(TypePointerInstruction)
                    (name,
                     StorageClass.Private,
                     requestType(type.elementType));

            case LLVMVectorTypeKind:
                return newType!(TypeVectorInstruction)
                    (name,
                     requestType(type.elementType),
                     type.lengthAsVector);
            case LLVMMetadataTypeKind:
                assert(false);
            case LLVMX86_MMXTypeKind:
                assert(false);
            case LLVMTokenTypeKind:
                assert(false);
        }
    }

    void writeAllDeclarions(Writer writer) const {
        foreach (i; instructions) {
            static foreach (I; TypeInstructions) {
                if (auto r = i.peek!I) {
                    writer.writeInstruction(*r);
                }
            }
        }
    }

    private Id newType(Instruction, Args...)(string name, Args args) {
        Id id = idManager.requestId(name);
        types[name] = id;
        instructions ~= TypeInstruction(Instruction(id, args));
        return id;
    }

    private bool isBuiltin(string name) {
        // TODO: more strict algorithm
        if (auto r = name.matchAll(ctRegex!`%"(.*)".*`)) {
            auto n = r.array.front[1];
            if (auto r2 = n.matchAll(ctRegex!`shader\.builtin\.Vector!\((.*), (\d+)\w*\)\.Vector`)) {
                return true;
            }
        }
        return false;
    }

    private Id newBuiltinType(string name) {
        Id id = idManager.requestId(name);
        types[name] = id;
        if (auto r = name.matchAll(ctRegex!`%"(.*)".*`)) {
            auto n = r.array.front[1];
            if (auto r2 = n.matchAll(ctRegex!`shader\.builtin\.Vector!\((.*), (\d+)\w*\)\.Vector`)) {
                auto tmp = r2.array.front;
                Id elementType = requestType(getType(tmp[1]));
                uint num = tmp[2].to!uint;
                instructions ~= TypeInstruction(TypeVectorInstruction(id, elementType, num));
                return id;
            }
        }
        assert(false);
    }

    private Type getType(string name) {
        if (name == "float") {
            return Type.getFloatType!(32);
        }
        assert(false);
    }
}
