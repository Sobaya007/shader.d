module spirv.typeconstmanager;

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

alias ConstInstructions = AliasSeq!(
    ConstantTrueInstruction,
    ConstantFalseInstruction,
    ConstantInstruction!(uint),
    ConstantInstruction!(float),
    ConstantCompositeInstruction,
);

alias ConstInstruction = Algebraic!(ConstInstructions);

alias TypeConstInstructions = AliasSeq!(TypeInstructions, ConstInstructions);
alias TypeConstInstruction = Algebraic!(TypeConstInstructions);

class TypeConstManager {

    private IdManager idManager;
    private Id[string] types;
    private Id[Tuple!(string,string)] consts;
    private TypeConstInstruction[] instructions;

    this(IdManager idManager) {
        this.idManager = idManager;
    }

    Id requestType(Type type) {
        auto name = type.name;
        if (auto res = name in types) return *res;
        if (isVectorStruct(type)) return requestType(convertToVector(type));

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
                return newType!(TypeStructInstruction)
                    (name,
                     type.memberTypes.map!(p => requestType(p)).array);
            case LLVMArrayTypeKind:
                auto lenType = requestType(Type.getIntegerType!(32));
                auto lenId = requestConstant(lenType, type.lengthAsArray);
                return newType!(TypeArrayInstruction)
                    (name,
                     requestType(type.elementType),
                     lenId);
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

    Id requestConstant(T)(Id type, T value) {
        auto name = tuple(T.stringof, value.to!string);
        if (auto res = name in consts) return *res;

        static if (is(T == bool)) {
            if (value == true) return newConstant!(ConstantTrueInstruction)(type, name);
            else               return newConstant!(ConstantFalseInstruction)(type, name);
        } else static if (isScalarType!T) {
            return newConstant!(ConstantInstruction!(T), T)(type, name, value);
        } else {
            // TODO: handle vector or array
            static assert(false);
        }
    }

    void writeAllDeclarions(Writer writer) const {
        foreach (i; instructions) {
            static foreach (I; TypeConstInstructions) {
                if (auto r = i.peek!I) {
                    writer.writeInstruction(*r);
                }
            }
        }
    }

    private Id newType(Instruction, Args...)(string name, Args args) {
        Id id = idManager.requestId(name);
        types[name] = id;
        instructions ~= TypeConstInstruction(Instruction(id, args));
        return id;
    }

    private Id newConstant(Instruction, Args...)(Id type, Tuple!(string,string) name, Args args) {
        Id id = idManager.requestId(format!"(%s,%s)"(name.expand));
        consts[name] = id;
        instructions ~= TypeConstInstruction(Instruction(type, id, args));
        return id;
    }

    private bool isVectorStruct(Type type) {
        return type.name.matchAll(ctRegex!`shader\.builtin\.Vector!\((.*), (\d+)\w*\)\.Vector`).front.empty is false;
    }

    private Type convertToVector(Type type) {
        auto tmp = type.name.matchAll(ctRegex!`shader\.builtin\.Vector!\((.*), (\d+)\w*\)\.Vector`).array.front;
        Type elementType = getType(tmp[1]);
        uint num = tmp[2].to!uint;
        return Type.getVectorType(elementType, num);
    }

    private Type getType(string name) {
        if (name == "float") {
            return Type.getFloatType!(32);
        }
        assert(false);
    }
}
