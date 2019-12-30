module spirv.typeconstmanager;

import std;
import spirv.annotationmanager;
import spirv.capabilitymanager;
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
    ConstantInstruction!(int),
    ConstantInstruction!(uint),
    ConstantInstruction!(long),
    ConstantInstruction!(ulong),
    ConstantInstruction!(float),
    ConstantInstruction!(double),
    ConstantCompositeInstruction,
);

alias ConstInstruction = Algebraic!(ConstInstructions);

alias TypeConstInstructions = AliasSeq!(TypeInstructions, ConstInstructions);
alias TypeConstInstruction = Algebraic!(TypeConstInstructions);

class TypeConstManager {

    private IdManager idManager;
    private AnnotationManager annotationManager;
    private CapabilityManager capabilityManager;
    private Id[string] types;
    private Id[Tuple!(string,string)] consts;
    private TypeConstInstruction[] instructions;

    this(IdManager idManager, AnnotationManager annotationManager, CapabilityManager capabilityManager) {
        this.idManager = idManager;
        this.annotationManager = annotationManager;
        this.capabilityManager = capabilityManager;
    }

    Id requestType(Type type, StorageClass storage) {
        auto name = type.name ~ storage.to!string;
        if (auto res = name in types) return *res;
        if (isVectorStruct(type)) return requestType(convertToVector(type));
        enforce(type.kind == LLVMPointerTypeKind);
        return newType!(TypePointerInstruction)
            (name, storage,
             requestType(type.elementType));
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
                capabilityManager.requestCapability(Capability.Float16);
                return newType!(TypeFloatInstruction)(name, 16);
            case LLVMFloatTypeKind:
                return newType!(TypeFloatInstruction)(name, 32);
            case LLVMDoubleTypeKind:
                capabilityManager.requestCapability(Capability.Float64);
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
                switch (type.widthAsInt) {
                    case 1:
                        return newType!(TypeBoolInstruction)(name);
                    case 8:
                        capabilityManager.requestCapability(Capability.Int8);
                        break;
                    case 16:
                        capabilityManager.requestCapability(Capability.Int16);
                        break;
                    case 64:
                        capabilityManager.requestCapability(Capability.Int64);
                        break;
                    default: break;
                }
                return newType!(TypeIntInstruction)(name, type.widthAsInt);
            case LLVMFunctionTypeKind:
                return newType!(TypeFunctionInstruction)
                    (name, 
                     requestType(type.returnType),
                     type.paramTypes.map!(p => requestType(p)).array);
            case LLVMStructTypeKind:
                auto result = newType!(TypeStructInstruction)
                    (name,
                     type.memberTypes.map!(p => requestType(p)).array);
                // TODO: offset must be multiples of 4?
                uint offset = 0;
                foreach (i, t; type.memberTypes.enumerate) {
                    annotationManager.notifyMemberDecoration(result, cast(uint)i, Decoration.Offset, offset);
                    offset += getSize(t);
                }
                return result;
            case LLVMArrayTypeKind:
                auto lenType = requestType(Type.getIntegerType!(32));
                auto lenId = requestConstant(lenType, type.lengthAsArray);
                auto result = newType!(TypeArrayInstruction)
                    (name,
                     requestType(type.elementType),
                     lenId);
                // TODO: stride must be multiples of 4?
                auto stride = (getSize(type.elementType)+3) / 4 * 4;
                annotationManager.notifyDecoration(result, Decoration.ArrayStride, stride);
                return result;
            case LLVMVectorTypeKind:
                if (type.lengthAsVector.among(8, 16)) {
                    capabilityManager.requestCapability(Capability.Vector16);
                }
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

    Id requestComponentConstant(Id type, Id[] components) {
        auto name = tuple(idManager.getName(type), components.map!(c => idManager.getName(c)).join(" "));
        if (auto res = name in consts) return *res;

        return newConstant!(ConstantCompositeInstruction)(type, name, components);
    }

    void writeAllInstructions(Writer writer) const {
        foreach (i; instructions) {
            static foreach (I; TypeConstInstructions) {
                if (auto r = i.peek!I) {
                    writer.writeInstruction(*r);
                }
            }
        }
    }

    StorageClass getStorage(Id typeId) {
        return instructions
            .map!(i => i.peek!(TypePointerInstruction))
            .filter!(i => i !is null)
            .filter!(i => i.id == typeId)
            .front.storage;
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
        return type.name.matchAll(ctRegex!`^shader\.builtin\.Vector!\((.*), (\d+)\w*\)\.Vector$`).front.empty is false;
    }

    private Type convertToVector(Type type) {
        auto tmp = type.name.matchAll(ctRegex!`^shader\.builtin\.Vector!\((.*), (\d+)\w*\)\.Vector$`).array.front;
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

    private uint getSize(Type type) {
        // TODO: handle all kind
        final switch (type.kind) {
            case LLVMVoidTypeKind:
                enforce(false, "Array of void is not allowed.");
                break;
            case LLVMHalfTypeKind:
                return 2;
            case LLVMFloatTypeKind:
                return 4;
            case LLVMDoubleTypeKind:
                return 8;
            case LLVMX86_FP80TypeKind:
                return 10;
            case LLVMFP128TypeKind:
                return 16;
            case LLVMPPC_FP128TypeKind:
                return 16;
            case LLVMLabelTypeKind:
                assert(false);
            case LLVMIntegerTypeKind:
                return type.widthAsInt;
            case LLVMFunctionTypeKind:
                assert(false);
            case LLVMStructTypeKind:
                return type.memberTypes.map!(p => getSize(p)).sum;
            case LLVMArrayTypeKind:
                return getSize(type.elementType) * type.lengthAsArray;
            case LLVMPointerTypeKind:
                return 4; // TODO: Consider more seriously
            case LLVMVectorTypeKind:
                return getSize(type.elementType) * type.lengthAsVector;
            case LLVMMetadataTypeKind:
                assert(false);
            case LLVMX86_MMXTypeKind:
                assert(false);
            case LLVMTokenTypeKind:
                assert(false);
        }
        assert(false);
    }
}
