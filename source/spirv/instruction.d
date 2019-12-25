module spirv.instruction;

import std;
import spirv.spv;
import spirv.idmanager;

struct CapabilityInstruction {
    enum op = Op.OpCapability;
    Capability cap;
}

struct ExtensionInstruction {
    enum op = Op.OpExtension;
    string name;
}

struct ExtInstImportInstruction {
    enum op = Op.OpExtInstImport;
    Id id;
    string name;
}

struct MemoryModelInstuction {
    enum op = Op.OpMemoryModel;
    AddressingModel addrModel;
    MemoryModel memoryModel;
}

struct EntryPointInstruction {
    enum op = Op.OpEntryPoint;
    ExecutionModel exModel;
    Id id;
    string name;
    Id[] args;
}

struct ExecutionModeInstruction {
    enum op = Op.OpExecutionMode;
    Id entryPoint;
    ExecutionMode mode;
    uint[] extra;
}

struct FunctionInstruction {
    enum op = Op.OpFunction;
    Id returnType;
    Id id;
    FunctionControlMask control;
    Id functionType;
}

struct FunctionParameterInstruction {
    enum op = Op.OpFunctionParameter;
    Id type;
    Id id;
}

struct FunctionEndInstruction {
    enum op = Op.OpFunctionEnd;
}

struct TypeVoidInstruction {
    enum op = Op.OpTypeVoid;
    Id id;
}

struct TypeBoolInstruction {
    enum op = Op.OpTypeBool;
    Id id;
}

struct TypeIntInstruction {
    enum op = Op.OpTypeInt;
    Id id;
    uint width;
    uint signedness;
}

struct TypeFloatInstruction {
    enum op = Op.OpTypeFloat;
    Id id;
    uint width;
}

struct TypeVectorInstruction {
    enum op = Op.OpTypeVector;
    Id id;
    Id commonType;
    uint componentCount;
}

struct TypeMatrixInstruction {
    enum op = Op.OpTypeMatrix;
    Id id;
    Id columnType;
    uint columnCount;
}

struct TypeImageInstruction {
    enum op = Op.OpTypeImage;
    Id id;
    Id type;
    uint dim;
    uint depth;
    uint arrayed;
    uint multiSampled;
    uint sampled;
    ImageFormat imageFormat;
    AccessQualifier access;
}

struct TypeSampledImageInstruction {
    enum op = Op.OpTypeSampledImage;
    Id id;
    Id imageType;
}

struct TypeArrayInstruction {
    enum op = Op.OpTypeArray;
    Id id;
    Id elementType;
    Id length;
}

struct TypeRuntimeArrayInstruction {
    enum op = Op.OpTypeRuntimeArray;
    Id id;
    Id elementType;
}

struct TypeStructInstruction {
    enum op = Op.OpTypeStruct;
    Id id;
    Id[] members;
}

struct TypeOpaqueInstruction {
    enum op = Op.OpTypeOpaque;
    Id id;
    string name;
}

struct TypePointerInstruction {
    enum op = Op.OpTypePointer;
    Id id;
    StorageClass storage;
    Id type;
}

struct TypeFunctionInstruction {
    enum op = Op.OpTypeFunction;
    Id id;
    Id returnType;
    Id[] paramTypes;
}

struct TypeForwardPointerInstruction {
    enum op = Op.OpTypeForwardPointer;
    Id id;
    StorageClass storage;
}

struct ConstantTrueInstruction {
    enum op = Op.OpConstantTrue;
    Id type;
    Id id;
}

struct ConstantFalseInstruction {
    enum op = Op.OpConstantFalse;
    Id type;
    Id id;
}

struct ConstantInstruction(T) {
    enum op = Op.OpConstant;
    Id type;
    Id id;
    T value;
}

struct ConstantCompositeInstruction(T) {
    enum op = Op.OpConstantComposite;
    Id type;
    Id id;
    T value;
}
