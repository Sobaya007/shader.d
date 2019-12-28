module spirv.instruction;

import std;
import spirv.capabilitymanager;
import spirv.spv;
import spirv.idmanager;

struct NopInstruction {
    enum op = Op.OpNop;
}

struct UndefInstruction {
    enum op = Op.OpUndef;
    Id type;
    Id id;
}

struct SourceContinuedInstruction {
    enum op = Op.OpSourceContinued;
    SourceLanguage lang;
    int ver;
    Nullable!Id file;
    Nullable!string source;
}

struct SourceExtensionInstruction {
    enum op = Op.OpSourceExtension;
    string extension;
}

struct SourceInstruction {
    enum op = Op.OpSource;
    string source;
}

struct NameInstruction {
    enum op = Op.OpName;
    Id target;
    string name;
}

struct MemberNameInstruction {
    enum op = Op.OpMemberName;
    Id type;
    uint memberIndex;
    string name;
}

struct StringInstruction {
    enum op = Op.OpString;
    Id id;
    string str;
}

struct LineInstruction {
    enum op = Op.OpLine;
    Id file;
    uint line;
    uint column;
}

struct NoLineInstruction {
    enum op = Op.OpNoLine;
}

alias DecorationExtra = Algebraic!(uint, BuiltIn, FunctionParameterAttribute, FPRoundingMode, FPFastMathModeMask, Tuple!(string, LinkageType));

struct DecorateInstruction {
    enum op = Op.OpDecorate;
    Id target;
    Decoration decoration;
    Nullable!DecorationExtra extra;
}

struct MemberDecorateInstruction {
    enum op = Op.OpMemberDecorate;
    Id structType;
    uint memberIndex;
    Decoration decoration;
    Nullable!DecorationExtra extra;
}

struct DecorationGroupInstruction {
    enum op = Op.OpDecorationGroup;
    Id id;
}

struct GroupDecorateInstruction {
    enum op = Op.OpGroupDecorate;
    Id decorationGroup;
    Id[] targets;
}

struct GroupMemberDecorateInstruction {
    enum op = Op.OpGroupMemberDecorate;
    Id decorationGroup;
    Tuple!(Id, uint) targets;
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

struct ExtInstInstruction {
    enum op = Op.OpExtInst;
    Id type;
    Id id;
    Id set;
    uint instruction;
    Id[] operands;
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

struct CapabilityInstruction {
    enum op = Op.OpCapability;
    Capability cap;
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

@necessary(Capability.Matrix)
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

@necessary(Capability.Shader)
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

@necessary(Capability.Kernel)
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

@necessary(Capability.Kernel)
struct TypeEventInstruction {
    enum op = Op.OpTypeEvent;
    Id id;
}

@necessary(Capability.DeviceEnqueue)
struct TypeDeviceEventInstruction {
    enum op = Op.OpTypeDeviceEvent;
    Id id;
}

@necessary(Capability.Pipes)
struct TypeReservedIdInstruction {
    enum op = Op.OpTypeReserveId;
    Id id;
}

@necessary(Capability.DeviceEnqueue)
struct TypeQueueInstruction {
    enum op = Op.OpTypeQueue;
    Id id;
}

@necessary(Capability.Pipes)
struct TypePipeInstruction {
    enum op = Op.OpTypePipe;
    Id id;
    AccessQualifier access;
}

@necessary(Capability.Addresses)
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

struct ConstantCompositeInstruction {
    enum op = Op.OpConstantComposite;
    Id type;
    Id id;
    Id[] components;
}

@necessary(Capability.LiteralSampler)
struct ConstantSamplerInstruction {
    enum op = Op.OpConstantSampler;
    Id type;
    Id id;
    SamplerAddressingMode addressingMode;
    uint param;
    SamplerFilterMode filterMode;
}

struct ConstantNullInstruction {
    enum op = Op.OpConstantNull;
    Id type;
    Id id;
}

struct SpecCostantTrueInstruction {
    enum op = Op.OpSpecConstantTrue;
    Id type;
    Id id;
}

struct SpecConstantFalseInstruction {
    enum op = Op.OpSpecConstantFalse;
    Id type;
    Id id;
}

struct SpecConstantInstruction(T) {
    enum op = Op.OpSpecConstant;
    Id type;
    Id id;
    T value;
}

struct SpecConstantComposite {
    enum op = Op.OpSpecConstantComposite;
    Id type;
    Id id;
    Id[] constituents;
}

struct SpecConstantOpInstruction {
    enum op = Op.OpSpecConstantOp;
    Id type;
    Id id;
    Op opecode;
    Id[] operands;
}

struct VariableInstruction {
    enum op = Op.OpVariable;
    Id type;
    Id id;
    StorageClass storage;
    Nullable!Id initializer;
}

struct ImageTexelPointer {
    enum op = Op.OpImageTexelPointer;
    Id type;
    Id id;
    Id image;
    Id coordinate;
    Id sample;
}

struct LoadInstruction {
    enum op = Op.OpLoad;
    Id type;
    Id id;
    Id pointer;
    Nullable!MemoryAccessMask access;
}

struct StoreInstruction {
    enum op = Op.OpStore;
    Id pointer;
    Id object;
    Nullable!MemoryAccessMask access;
}

struct CopyMemoryInstruction {
    enum op = Op.OpCopyMemory;
    Id target;
    Id source;
    Nullable!MemoryAccessMask access;
}

@necessary(Capability.Addresses)
struct CopyMemorySizedInstruction {
    enum op = Op.OpCopyMemorySized;
    Id target;
    Id source;
    Id size;
    Nullable!MemoryAccessMask access;
}

struct AccessChainInstruction {
    enum op = Op.OpAccessChain;
    Id type;
    Id id;
    Id base;
    Id[] indexes;
}

struct InBoudsAccessChainInstruction {
    enum op = Op.OpInBoundsAccessChain;
    Id type;
    Id id;
    Id base;
    Id[] indexes;
}

@necessary(
        Capability.Addresses,
        Capability.VariablePointers,
        Capability.VariablePointersStorageBuffer)
struct PtrAccessChainInstruction {
    enum op = Op.OpPtrAccessChain;
    Id type;
    Id id;
    Id base;
    Id element;
    Id[] indexes;
}

@necessary(Capability.Shader)
struct ArrayLengthInstruction {
    enum op = Op.OpArrayLength;
    Id type;
    Id id;
    Id structure;
    uint arrayMemberIndex;
}

@necessary(Capability.Kernel)
struct GenericPtrMemSemanticsInstruction {
    enum op = Op.OpGenericPtrMemSemantics;
    Id type;
    Id id;
    Id pointer;
}

@necessary(Capability.Addresses)
struct InBoudsPtrAccessChainInstruction {
    enum op = Op.OpInBoundsPtrAccessChain;
    Id type;
    Id id;
    Id base;
    Id element;
    Id[] indexes;
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

struct FunctionCallInstrution {
    enum op = Op.OpFunctionCall;
    Id type;
    Id id;
    Id func;
    Id[] args;
}

struct SampledImageInstruction {
    enum op = Op.OpSampledImage;
    Id type;
    Id id;
    Id image;
    Id sampler;
}

@necessary(Capability.Shader)
struct ImageSampleImplicitLodInstruction {
    enum op = Op.OpImageSampleImplicitLod;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    Nullable!ImageOperandsMask operand;
    Id[] extra; // ????
}

struct ImageSampleExplicitLodInstruction {
    enum op = Op.OpImageSampleExplicitLod;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    ImageOperandsMask operand;
    Id lod;
    Id[] extra; // ????
}

@necessary(Capability.Shader)
struct ImageSampleDrefImplicitLod {
    enum op = Op.OpImageSampleDrefImplicitLod;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    Id dref;
    Nullable!ImageOperandsMask operand;
    Id[] extra; // ????
}

@necessary(Capability.Shader)
struct ImageSampleDrefExplicitLod {
    enum op = Op.OpImageSampleDrefExplicitLod;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    Id dref;
    ImageOperandsMask operand;
    Id lod;
    Id[] extra; // ????
}

@necessary(Capability.Shader)
struct ImageSampleProjImplicitLod {
    enum op = Op.OpImageSampleProjImplicitLod;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    Nullable!ImageOperandsMask operand;
    Id[] extra; // ????
}

@necessary(Capability.Shader)
struct ImageSampleProjExplicitLod {
    enum op = Op.OpImageSampleProjExplicitLod;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    ImageOperandsMask operand;
    Id lod;
    Id[] extra; // ????
}

@necessary(Capability.Shader)
struct ImageSampleProjDrefImplicitLod {
    enum op = Op.OpImageSampleProjDrefImplicitLod;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    Id dref;
    Nullable!ImageOperandsMask operand;
    Id[] extra; // ????
}

@necessary(Capability.Shader)
struct ImageSampleProjDrefExplicitLod {
    enum op = Op.OpImageSampleProjDrefExplicitLod;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    Id dref;
    ImageOperandsMask operand;
    Id lod;
    Id[] extra; // ????
}

struct ImageFetchInstruction {
    enum op = Op.OpImageFetch;
    Id type;
    Id id;
    Id image;
    Id coordinate;
    Nullable!ImageOperandsMask operand;
    Id[] extra; // ????
}

@necessary(Capability.Shader)
struct ImageGatherInstruction {
    enum op = Op.OpImageGather;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    Id component;
    Nullable!ImageOperandsMask operand;
    Id[] extra; // ????
}

@necessary(Capability.Shader)
struct ImageDrefGatherInstruction {
    enum op = Op.OpImageDrefGather;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    Id dref;
    Nullable!ImageOperandsMask operand;
    Id[] extra; // ????
}

struct ImageReadInstruction {
    enum op = Op.OpImageRead;
    Id type;
    Id id;
    Id image;
    Id coordinate;
    Nullable!ImageOperandsMask operand;
    Id[] extra; // ????
}

struct ImageWriteInstruction {
    enum op = Op.OpImageWrite;
    Id image;
    Id coordinate;
    Id texel;
    Nullable!ImageOperandsMask operand;
    Id[] extra; // ????
}

struct ImageInstruction {
    enum op = Op.OpImage;
    Id type;
    Id id;
    Id sampledImage;
}

@necessary(Capability.Kernel)
struct ImageQueryFormatInstruction {
    enum op = Op.OpImageQueryFormat;
    Id type;
    Id id;
    Id image;
}

@necessary(Capability.Kernel)
struct ImageQueryOrderInstruction {
    enum op = Op.OpImageQueryOrder;
    Id type;
    Id id;
    Id image;
}

@necessary(Capability.Kernel, Capability.ImageQuery)
struct ImageQuerySizeLodInstruction {
    enum op = Op.OpImageQuerySizeLod;
    Id type;
    Id id;
    Id image;
    Id lod;
}

@necessary(Capability.Kernel, Capability.ImageQuery)
struct ImageQuerySizeInstruction {
    enum op = Op.OpImageQuerySize;
    Id type;
    Id id;
    Id image;
}

@necessary(Capability.ImageQuery)
struct ImageQueryLodIntruction {
    enum op = Op.OpImageQueryLod;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
}

@necessary(Capability.Kernel, Capability.ImageQuery)
struct ImageQueryLevelsInstruction {
    enum op = Op.OpImageQueryLevels;
    Id type;
    Id id;
    Id image;
}

@necessary(Capability.Kernel, Capability.ImageQuery)
struct ImageQuerySamplesInstruction {
    enum op = Op.OpImageQuerySamples;
    Id type;
    Id id;
    Id image;
}

@necessary(Capability.SparseResidency)
struct ImageSparseSampleImplicitLodInstruction {
    enum op = Op.OpImageSparseSampleImplicitLod;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    Nullable!ImageOperandsMask ooperand;
    Id[] extra; // ????
}

@necessary(Capability.SparseResidency)
struct ImageSparseSampleExplicitLodInstruction {
    enum op = Op.OpImageSparseSampleExplicitLod;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    ImageOperandsMask ooperand;
    Id lod;
    Id[] extra; // ????
}

@necessary(Capability.SparseResidency)
struct ImageSparseSampleDrefImplicitLodInstruction {
    enum op = Op.OpImageSparseSampleDrefImplicitLod;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    Id dref;
    Nullable!ImageOperandsMask ooperand;
    Id[] extra; // ????
}

@necessary(Capability.SparseResidency)
struct ImageSparseSampleDrefExplicitLodInstruction {
    enum op = Op.OpImageSparseSampleDrefExplicitLod;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    Id dref;
    ImageOperandsMask ooperand;
    Id lod;
    Id[] extra; // ????
}

@necessary(Capability.SparseResidency)
struct ImageSparseSampleProjImplicitLodInstruction {
    enum op = Op.OpImageSparseSampleProjImplicitLod;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    Nullable!ImageOperandsMask ooperand;
    Id[] extra; // ????
}

@necessary(Capability.SparseResidency)
struct ImageSparseSampleProjExplicitLodInstruction {
    enum op = Op.OpImageSparseSampleProjExplicitLod;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    ImageOperandsMask ooperand;
    Id lod;
    Id[] extra; // ????
}

@necessary(Capability.SparseResidency)
struct ImageSparseSampleProjDrefImplicitLodInstruction {
    enum op = Op.OpImageSparseSampleProjDrefImplicitLod;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    Id dref;
    Nullable!ImageOperandsMask ooperand;
    Id[] extra; // ????
}

@necessary(Capability.SparseResidency)
struct ImageSparseSampleProjDrefExplicitLodInstruction {
    enum op = Op.OpImageSparseSampleProjDrefExplicitLod;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    Id dref;
    ImageOperandsMask ooperand;
    Id lod;
    Id[] extra; // ????
}

@necessary(Capability.SparseResidency)
struct ImageSparseFetchInstruction {
    enum op = Op.OpImageSparseFetch;
    Id type;
    Id id;
    Id image;
    Id coordinate;
    Nullable!ImageOperandsMask operand;
    Id[] extra; // ????
}

@necessary(Capability.SparseResidency)
struct ImageSparseGatherInstruction {
    enum op = Op.OpImageSparseGather;
    Id type;
    Id id;
    Id sampledImage;
    Id coordinate;
    Id component;
    Nullable!ImageOperandsMask operand;
    Id[] extra; // ????
}

@necessary(Capability.SparseResidency)
struct ImageSparseDrefGatherInstruction {
    enum op = Op.OpImageSparseDrefGather;
    Id type;
    Id id;
    Id sampledImage;
    Id coordindate;
    Id dref;
    Nullable!ImageOperandsMask operand;
    Id[] extra; // ????
}

@necessary(Capability.SparseResidency)
struct ImageSparseTexelsResidentInstruction {
    enum op = Op.OpImageSparseTexelsResident;
    Id type;
    Id id;
    Id residentCode;
}

@necessary(Capability.SparseResidency)
struct ImageSparseReadInstruction {
    enum op = Op.OpImageSparseRead;
    Id type;
    Id id;
    Id image;
    Id coordinate;
    Nullable!ImageOperandsMask operand;
    Id[] extra; // ????
}

@necessary(Capability.Shader)
struct QuantizeToF16Instruction {
    enum op = Op.OpQuantizeToF16;
    Id type;
    Id id;
    Id value;
}

/*
@necessary(Capability.Addresses)
struct ConvertPtrToUInstruction {
    enum op = Op.OpConvertPtrToU;
    Id type;
    Id id;
    Id pointer;
}
*/

@necessary(Capability.Kernel)
struct SatConvertSToUInstruction {
    enum op = Op.OpSatConvertSToU;
    Id type;
    Id id;
    Id signedValue;
}

@necessary(Capability.Kernel)
struct SatConvertUToSInstruction {
    enum op = Op.OpSatConvertUToS;
    Id type;
    Id id;
    Id unsignedValue;
}

/*
@necessary(Capability.Addresses)
struct ConvertUToPtrInstruction {
    enum op = Op.OpConvertUToPtr;
    Id type;
    Id id;
    Id integerValue;
}
*/

@necessary(Capability.Kernel)
struct PtrCastToGenericInstruction {
    enum op = Op.OpPtrCastToGeneric;
    Id type;
    Id id;
    Id pointer;

}

/*
@necessary(Capability.Kernel)
struct GenericCastToPtrInstruction {
    enum op = Op.OpGenericCastToPtr;
    Id type;
    Id id;
    Id pointer;
}
*/

@necessary(Capability.Kernel)
struct GenericCastToPtrExplicitInstruction {
    enum op = Op.OpGenericCastToPtrExplicit;
    Id type;
    Id id;
    Id pointer;
    StorageClass storage;
}

/*
struct BitcastInstruction {
    enum op = Op.OpBitcast;
    Id type;
    Id id;
    Id operand;
}
*/

struct VectorExtractDynamicInstruction {
    enum op = Op.OpVectorExtractDynamic;
    Id type;
    Id id;
    Id vector;
    Id index;
}

struct VectorInsertDynamicInstruction {
    enum op = Op.OpVectorInsertDynamic;
    Id type;
    Id id;
    Id vector;
    Id component;
    Id index;
}

struct VectorShuffleInstruction {
    enum op = Op.OpVectorShuffle;
    Id type;
    Id id;
    Id vector1;
    Id vector2;
    uint[] components;
}

struct CompositeConstructInstruction {
    enum op = Op.OpCompositeConstruct;
    Id type;
    Id id;
    Id[] constituents;
}

struct CompositeExtractInstruction {
    enum op = Op.OpCompositeExtract;
    Id type;
    Id id;
    Id composite;
    uint[] indexes;
}

struct CompositeInsertInstruction {
    enum op = Op.OpCompositeInsert;
    Id type;
    Id id;
    Id object;
    Id composite;
    uint[] inidexes;
}

struct CopyObjectInstruction {
    enum op = Op.OpCopyObject;
    Id type;
    Id id;
    Id operand;
}

@necessary(Capability.Matrix)
struct TransposeInstruction {
    enum op = Op.OpTranspose;
    Id type;
    Id id;
    Id matrix;
}

/*
struct SNegateInstruction {
    enum op = Op.OpSNegate;
    Id type;
    Id id;
    Id operand;
}
*/

struct UnaryOpInstruction {
    Op op;
    Id type;
    Id id;
    Id operand;
}

struct BinaryOpInstrucion {
    Op op;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

/*
struct SModInstruction {
    enum op = Op.OpSMod;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct FModInstruction {
    enum op = Op.OpFMod;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}
*/

struct VectorTimesScalarInstruction {
    enum op = Op.OpVectorTimesScalar;
    Id type;
    Id id;
    Id vector;
    Id scalar;
}

@necessary(Capability.Matrix)
struct MatrixTimesScalarInstruction {
    enum op = Op.OpMatrixTimesScalar;
    Id type;
    Id id;
    Id matrix;
    Id scalar;
}

@necessary(Capability.Matrix)
struct VectorTimesMatrixInstruction {
    enum op = Op.OpVectorTimesMatrix;
    Id type;
    Id id;
    Id vetor;
    Id matrix;
}

@necessary(Capability.Matrix)
struct MatrixTimesVectorInstruction {
    enum op = Op.OpMatrixTimesVector;
    Id type;
    Id id;
    Id matrix;
    Id vector;
}

@necessary(Capability.Matrix)
struct MatrixTimesMatrixInstruction {
    enum op = Op.OpMatrixTimesMatrix;
    Id type;
    Id id;
    Id left;
    Id right;
}

@necessary(Capability.Matrix)
struct OuterProductInstruction { 
    enum op = Op.OpOuterProduct;
    Id type;
    Id id;
    Id vector1;
    Id vector2;
}

struct DotInstruction { 
    enum op = Op.OpDot;
    Id type;
    Id id;
    Id vector1;
    Id vector2;
}

struct IAddCarryInstruction { 
    enum op = Op.OpIAddCarry;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct ISubBorrowInstruction { 
    enum op = Op.OpISubBorrow;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct UMulExtendedInstruction { 
    enum op = Op.OpUMulExtended;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct SMulExtendedInstruction { 
    enum op = Op.OpSMulExtended;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct NotInstruction { 
    enum op = Op.OpNot;
    Id type;
    Id id;
    Id operand;
}

@necessary(Capability.Shader)
struct BitFieldInsertInstruction { 
    enum op = Op.OpBitFieldInsert;
    Id type;
    Id id;
    Id base;
    Id insert;
    Id offset;
    Id count;
}

@necessary(Capability.Shader)
struct BitFieldSExtractInstruction { 
    enum op = Op.OpBitFieldSExtract;
    Id type;
    Id id;
    Id base;
    Id offset;
    Id count;
}

@necessary(Capability.Shader)
struct BitFieldUExtractInstruction { 
    enum op = Op.OpBitFieldUExtract;
    Id type;
    Id id;
    Id base;
    Id offset;
    Id count;
}

@necessary(Capability.Shader)
struct BitReverseInstruction { 
    enum op = Op.OpBitReverse;
    Id type;
    Id id;
    Id base;
}

struct BitCountInstruction { 
    enum op = Op.OpBitCount;
    Id type;
    Id id;
    Id base;
}

struct AnyInstruction { 
    enum op = Op.OpAny;
    Id type;
    Id id;
    Id vector;
}

struct AllInstruction { 
    enum op = Op.OpAll;
    Id type;
    Id id;
    Id vector;
}

struct IsNanInstruction { 
    enum op = Op.OpIsNan;
    Id type;
    Id id;
    Id x;
}

struct IsInfInstruction { 
    enum op = Op.OpIsInf;
    Id type;
    Id id;
    Id x;
}

@necessary(Capability.Kernel)
struct IsFiniteInstruction { 
    enum op = Op.OpIsFinite;
    Id type;
    Id id;
    Id x;
}

@necessary(Capability.Kernel)
struct IsNormalInstruction { 
    enum op = Op.OpIsNormal;
    Id type;
    Id id;
    Id x;
}

@necessary(Capability.Kernel)
struct SignBitSetInstruction { 
    enum op = Op.OpSignBitSet;
    Id type;
    Id id;
    Id x;
}

/*
TODO: Handle Capability
@necessary(Capability.Kernel)
struct LessOrGreaterInstruction { 
    enum op = Op.OpLessOrGreater;
    Id type;
    Id id;
    Id x;
    Id y;
}

@necessary(Capability.Kernel)
struct OrderedInstruction { 
    enum op = Op.OpOrdered;
    Id type;
    Id id;
    Id x;
    Id y;
}

@necessary(Capability.Kernel)
struct UnorderedInstruction { 
    enum op = Op.OpUnordered;
    Id type;
    Id id;
    Id x;
    Id y;
}
*/

struct ComparisonInstruction {
    Op op;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct SelectInstruction { 
    enum op = Op.OpSelect;
    Id type;
    Id id;
    Id condition;
    Id object1;
    Id object2;
}

struct IEqualInstruction { 
    enum op = Op.OpIEqual;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct INotEqualInstruction { 
    enum op = Op.OpINotEqual;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct UGreaterThanInstruction { 
    enum op = Op.OpUGreaterThan;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct SGreaterThanInstruction { 
    enum op = Op.OpSGreaterThan;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct UGreaterThanEqualInstruction { 
    enum op = Op.OpUGreaterThanEqual;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct SGreaterThanEqualInstruction { 
    enum op = Op.OpSGreaterThanEqual;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct ULessThanInstruction { 
    enum op = Op.OpULessThan;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct SLessThanInstruction { 
    enum op = Op.OpSLessThan;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct ULessThanEqualInstruction { 
    enum op = Op.OpULessThanEqual;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct SLessThanEqualInstruction { 
    enum op = Op.OpSLessThanEqual;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct FOrdEqualInstruction { 
    enum op = Op.OpFOrdEqual;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct FUnordEqualInstruction { 
    enum op = Op.OpFUnordEqual;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct FOrdNotEqualInstruction { 
    enum op = Op.OpFOrdNotEqual;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct FUnordNotEqualInstruction { 
    enum op = Op.OpFUnordNotEqual;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct FOrdLessThanInstruction { 
    enum op = Op.OpFOrdLessThan;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct FUnordLessThanInstruction { 
    enum op = Op.OpFUnordLessThan;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct FOrdGreaterThanInstruction { 
    enum op = Op.OpFOrdGreaterThan;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct FUnordGreaterThanInstruction { 
    enum op = Op.OpFUnordGreaterThan;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct FOrdLessThanEqualInstruction { 
    enum op = Op.OpFOrdLessThanEqual;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct FUnordLessThanEqualInstruction { 
    enum op = Op.OpFUnordLessThanEqual;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct FOrdGreaterThanEqualInstruction { 
    enum op = Op.OpFOrdGreaterThanEqual;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

struct FUnordGreaterThanEqualInstruction { 
    enum op = Op.OpFUnordGreaterThanEqual;
    Id type;
    Id id;
    Id operand1;
    Id operand2;
}

@necessary(Capability.Shader)
struct DPdxInstruction { 
    enum op = Op.OpDPdx;
    Id type;
    Id id;
    Id p;
}

@necessary(Capability.Shader)
struct DPdyInstruction { 
    enum op = Op.OpDPdy;
    Id type;
    Id id;
    Id p;
}

@necessary(Capability.Shader)
struct FwidthInstruction { 
    enum op = Op.OpFwidth;
    Id type;
    Id id;
    Id p;
}

@necessary(Capability.DerivativeControl)
struct DPdxFineInstruction { 
    enum op = Op.OpDPdxFine;
    Id type;
    Id id;
    Id p;
}

@necessary(Capability.DerivativeControl)
struct DPdyFineInstruction { 
    enum op = Op.OpDPdyFine;
    Id type;
    Id id;
    Id p;
}

@necessary(Capability.DerivativeControl)
struct FwidthFineInstruction { 
    enum op = Op.OpFwidthFine;
    Id type;
    Id id;
    Id p;
}

@necessary(Capability.DerivativeControl)
struct DPdxCoarseInstruction { 
    enum op = Op.OpDPdxCoarse;
    Id type;
    Id id;
    Id p;
}

@necessary(Capability.DerivativeControl)
struct DPdyCoarseInstruction { 
    enum op = Op.OpDPdyCoarse;
    Id type;
    Id id;
    Id p;
}

@necessary(Capability.DerivativeControl)
struct FwidthCoarseInstruction { 
    enum op = Op.OpFwidthCoarse;
    Id type;
    Id id;
    Id p;
}

struct PhiInstruction { 
    enum op = Op.OpPhi;
    Id type;
    Id id;
    Tuple!(Id,Id)[] variableParentPairs;
}

struct LoopMergeInstruction { 
    enum op = Op.OpLoopMerge;
    Id mergeBlock;
    Id continueTarget;
    LoopControlMask control;
}

struct SelectionMergeInstruction { 
    enum op = Op.OpSelectionMerge;
    Id mergeBlock;
    SelectionControlMask control;
}

struct LabelInstruction { 
    enum op = Op.OpLabel;
    Id id;
}

struct BranchInstruction { 
    enum op = Op.OpBranch;
    Id target;
}

struct BranchConditionalInstruction { 
    enum op = Op.OpBranchConditional;
    Id condition;
    Id trueLabel;
    Id falseLabel;
    uint[] branchWeights;
}

struct SwitchInstruction { 
    enum op = Op.OpSwitch;
    Id selector;
    Id defaultLabel;
    Tuple!(uint, Id) target;
}

@necessary(Capability.Shader)
struct KillInstruction { 
    enum op = Op.OpKill;
}

struct ReturnInstruction { 
    enum op = Op.OpReturn;
}

struct ReturnValueInstruction { 
    enum op = Op.OpReturnValue;
    Id value;
}

struct UnreachableInstruction { 
    enum op = Op.OpUnreachable;
}

@necessary(Capability.Kernel)
struct LifetimeStartInstruction { 
    enum op = Op.OpLifetimeStart;
    Id pointer;
    Id size;
}

@necessary(Capability.Kernel)
struct LifetimeStopInstruction { 
    enum op = Op.OpLifetimeStop;
    Id pointer;
    Id size;
}

struct AtomicLoadInstruction { 
    enum op = Op.OpAtomicLoad;
    Id type;
    Id id;
    Id pointer;
    Id scopeMask;
    Id memorySemantics;
}

struct AtomicStoreInstruction { 
    enum op = Op.OpAtomicStore;
    Id pointer;
    Id scopeMask;
    Id memorySemantics;
    Id value;
}

struct AtomicExchangeInstruction { 
    enum op = Op.OpAtomicExchange;
    Id type;
    Id id;
    Id pointer;
    Id scopeMask;
    Id memorySemantics;
    Id value;
}

struct AtomicCompareExchangeInstruction { 
    enum op = Op.OpAtomicCompareExchange;
    Id type;
    Id id;
    Id pointer;
    Id scopeMask;
    Id equalMemorySemantics;
    Id unequalMemorySemantics;
    Id value;
    Id compoarator;
}

@necessary(Capability.Kernel)
struct AtomicCompareExchangeWeakInstruction { 
    enum op = Op.OpAtomicCompareExchangeWeak;
    Id type;
    Id id;
    Id pointer;
    Id scopeMask;
    Id equalMemorySemantics;
    Id unequalMemorySemantics;
    Id value;
    Id compoarator;
}

struct AtomicIIncrementInstruction { 
    enum op = Op.OpAtomicIIncrement;
    Id type;
    Id id;
    Id pointer;
    Id scopeMask;
    Id memorySemantics;
}

struct AtomicIDecrementInstruction { 
    enum op = Op.OpAtomicIDecrement;
    Id type;
    Id id;
    Id pointer;
    Id scopeMask;
    Id memorySemantics;
}

struct AtomicIAddInstruction { 
    enum op = Op.OpAtomicIAdd;
    Id type;
    Id id;
    Id pointer;
    Id scopeMask;
    Id memorySemantics;
    Id value;
}

struct AtomicISubInstruction { 
    enum op = Op.OpAtomicISub;
    Id type;
    Id id;
    Id pointer;
    Id scopeMask;
    Id memorySemantics;
    Id value;
}

struct AtomicSMinInstruction { 
    enum op = Op.OpAtomicSMin;
    Id type;
    Id id;
    Id pointer;
    Id scopeMask;
    Id memorySemantics;
    Id value;
}

struct AtomicUMinInstruction { 
    enum op = Op.OpAtomicUMin;
    Id type;
    Id id;
    Id pointer;
    Id scopeMask;
    Id memorySemantics;
    Id value;
}

struct AtomicSMaxInstruction { 
    enum op = Op.OpAtomicSMax;
    Id type;
    Id id;
    Id pointer;
    Id scopeMask;
    Id memorySemantics;
    Id value;
}

struct AtomicUMaxInstruction { 
    enum op = Op.OpAtomicUMax;
    Id type;
    Id id;
    Id pointer;
    Id scopeMask;
    Id memorySemantics;
    Id value;
}

struct AtomicAndInstruction { 
    enum op = Op.OpAtomicAnd;
    Id type;
    Id id;
    Id pointer;
    Id scopeMask;
    Id memorySemantics;
    Id value;
}

struct AtomicOrInstruction { 
    enum op = Op.OpAtomicOr;
    Id type;
    Id id;
    Id pointer;
    Id scopeMask;
    Id memorySemantics;
    Id value;
}

struct AtomicXorInstruction { 
    enum op = Op.OpAtomicXor;
    Id type;
    Id id;
    Id pointer;
    Id scopeMask;
    Id memorySemantics;
    Id value;
}

@necessary(Capability.Kernel)
struct AtomicFlagTestAndSetInstruction { 
    enum op = Op.OpAtomicFlagTestAndSet;
    Id type;
    Id id;
    Id pointer;
    Id scopeMask;
    Id memorySemantics;
}

@necessary(Capability.Kernel)
struct AtomicFlagClearInstruction { 
    enum op = Op.OpAtomicFlagClear;
    Id pointer;
    Id scopeMask;
    Id memorySemantics;
}

@necessary(Capability.Geometry)
struct EmitVertexInstruction { 
    enum op = Op.OpEmitVertex;
}

@necessary(Capability.Geometry)
struct EndPrimitiveInstruction { 
    enum op = Op.OpEndPrimitive;
}

@necessary(Capability.GeometryStreams)
struct EmitStreamVertexInstruction { 
    enum op = Op.OpEmitStreamVertex;
    Id stream;
}

@necessary(Capability.GeometryStreams)
struct EndStreamPrimitiveInstruction { 
    enum op = Op.OpEndStreamPrimitive;
    Id stream;
}

struct ControlBarrierInstruction { 
    enum op = Op.OpControlBarrier;
    Id executionScope;
    Id memoryScope;
    Id memorySemantics;
}

struct MemoryBarrierInstruction { 
    enum op = Op.OpMemoryBarrier;
    Id memoryScope;
    Id memorySemantics;
}

@necessary(Capability.Kernel)
struct GroupAsyncCopyInstruction { 
    enum op = Op.OpGroupAsyncCopy;
    Id type;
    Id id;
    Id executionScope;
    Id destination;
    Id source;
    Id numElements;
    Id stride;
    Id event;
}

@necessary(Capability.Kernel)
struct GroupWaitEventsInstruction { 
    enum op = Op.OpGroupWaitEvents;
    Id executionScope;
    Id numEvents;
    Id eventList;
}

@necessary(Capability.Groups)
struct GroupAllInstruction { 
    enum op = Op.OpGroupAll;
    Id type;
    Id id;
    Id executionScope;
    Id predicate;
}

@necessary(Capability.Groups)
struct GroupAnyInstruction { 
    enum op = Op.OpGroupAny;
    Id type;
    Id id;
    Id executionScope;
    Id predicate;
}

@necessary(Capability.Groups)
struct GroupBroadcastInstruction { 
    enum op = Op.OpGroupBroadcast;
    Id type;
    Id id;
    Id executionScope;
    Id value;
    Id localId;
}

@necessary(Capability.Groups)
struct GroupIAddInstruction { 
    enum op = Op.OpGroupIAdd;
    Id type;
    Id id;
    Id executionScope;
    GroupOperation operation;
    Id x;
}

@necessary(Capability.Groups)
struct GroupFAddInstruction { 
    enum op = Op.OpGroupFAdd;
    Id type;
    Id id;
    Id executionScope;
    GroupOperation operation;
    Id x;
}

@necessary(Capability.Groups)
struct GroupFMinInstruction { 
    enum op = Op.OpGroupFMin;
    Id type;
    Id id;
    Id executionScope;
    GroupOperation operation;
    Id x;
}

@necessary(Capability.Groups)
struct GroupUMinInstruction { 
    enum op = Op.OpGroupUMin;
    Id type;
    Id id;
    Id executionScope;
    GroupOperation operation;
    Id x;
}

@necessary(Capability.Groups)
struct GroupSMinInstruction { 
    enum op = Op.OpGroupSMin;
    Id type;
    Id id;
    Id executionScope;
    GroupOperation operation;
    Id x;
}

@necessary(Capability.Groups)
struct GroupFMaxInstruction { 
    enum op = Op.OpGroupFMax;
    Id type;
    Id id;
    Id executionScope;
    GroupOperation operation;
    Id x;
}

@necessary(Capability.Groups)
struct GroupUMaxInstruction { 
    enum op = Op.OpGroupUMax;
    Id type;
    Id id;
    Id executionScope;
    GroupOperation operation;
    Id x;
}

@necessary(Capability.Groups)
struct GroupSMaxInstruction { 
    enum op = Op.OpGroupSMax;
    Id type;
    Id id;
    Id executionScope;
    GroupOperation operation;
    Id x;
}

@necessary(Capability.DeviceEnqueue)
struct EnqueueMarkerInstruction { 
    enum op = Op.OpEnqueueMarker;
    Id type;
    Id id;
    Id queue;
    Id numEvents;
    Id waitEvents;
    Id retEvents;
}

@necessary(Capability.DeviceEnqueue)
struct EnqueueKernelInstruction { 
    enum op = Op.OpEnqueueKernel;
    Id type;
    Id id;
    Id queue;
    Id flags;
    Id ndRange;
    Id numEvents;
    Id waitEvents;
    Id retEvents;
    Id invoke;
    Id param;
    Id paramSize;
    Id paramAlign;
    Id[] localSize;
}

@necessary(Capability.DeviceEnqueue)
struct GetKernelNDrangeSubGroupCountInstruction { 
    enum op = Op.OpGetKernelNDrangeSubGroupCount;
    Id type;
    Id id;
    Id ndRange;
    Id invoke;
    Id param;
    Id paramSize;
    Id paramAlign;
}

@necessary(Capability.DeviceEnqueue)
struct GetKernelNDrangeMaxSubGroupSizeInstruction { 
    enum op = Op.OpGetKernelNDrangeMaxSubGroupSize;
    Id type;
    Id id;
    Id ndRange;
    Id invoke;
    Id param;
    Id paramSize;
    Id paramAlign;
}

@necessary(Capability.DeviceEnqueue)
struct GetKernelWorkGroupSizeInstruction { 
    enum op = Op.OpGetKernelWorkGroupSize;
    Id type;
    Id id;
    Id invoke;
    Id param;
    Id paramSize;
    Id paramAlign;
}

@necessary(Capability.DeviceEnqueue)
struct GetKernelPreferredWorkGroupSizeMultipleInstruction { 
    enum op = Op.OpGetKernelPreferredWorkGroupSizeMultiple;
    Id type;
    Id id;
    Id invoke;
    Id param;
    Id paramSize;
    Id paramAlign;
}

@necessary(Capability.DeviceEnqueue)
struct RetainEventInstruction { 
    enum op = Op.OpRetainEvent;
    Id event;
}

@necessary(Capability.DeviceEnqueue)
struct ReleaseEventInstruction { 
    enum op = Op.OpReleaseEvent;
    Id event;
}

@necessary(Capability.DeviceEnqueue)
struct CreateUserEventInstruction { 
    enum op = Op.OpCreateUserEvent;
    Id type;
    Id id;
}

@necessary(Capability.DeviceEnqueue)
struct IsValidEventInstruction { 
    enum op = Op.OpIsValidEvent;
    Id type;
    Id id;
    Id event;
}

@necessary(Capability.DeviceEnqueue)
struct SetUserEventStatusInstruction { 
    enum op = Op.OpSetUserEventStatus;
    Id event;
    Id status;
}

@necessary(Capability.DeviceEnqueue)
struct CaptureEventProfilingInfoInstruction { 
    enum op = Op.OpCaptureEventProfilingInfo;
    Id event;
    Id profilingInfo;
    Id value;
}

@necessary(Capability.DeviceEnqueue)
struct GetDefaultQueueInstruction { 
    enum op = Op.OpGetDefaultQueue;
    Id type;
    Id id;
}

@necessary(Capability.DeviceEnqueue)
struct BuildNDRangeInstruction { 
    enum op = Op.OpBuildNDRange;
    Id type;
    Id id;
    Id globalWorkSize;
    Id localWorkSize;
    Id globalWorkOffset;
}

@necessary(Capability.Pipes)
struct ReadPipeInstruction { 
    enum op = Op.OpReadPipe;
    Id type;
    Id id;
    Id pipe;
    Id pointer;
    Id packetSize;
    Id packetAlignment;
}

@necessary(Capability.Pipes)
struct WritePipeInstruction { 
    enum op = Op.OpWritePipe;
    Id type;
    Id id;
    Id pipe;
    Id pointer;
    Id packetSize;
    Id packetAlignment;
}

@necessary(Capability.Pipes)
struct ReservedReadPipeInstruction { 
    enum op = Op.OpReservedReadPipe;
    Id type;
    Id id;
    Id pipe;
    Id reserveId;
    Id index;
    Id pointer;
    Id packetSize;
    Id packetAlignment;
}

@necessary(Capability.Pipes)
struct ReservedWritePipeInstruction { 
    enum op = Op.OpReservedWritePipe;
    Id type;
    Id id;
    Id pipe;
    Id reserveId;
    Id index;
    Id pointer;
    Id packetSize;
    Id packetAlignment;
}

@necessary(Capability.Pipes)
struct ReserveReadPipePacketsInstruction { 
    enum op = Op.OpReserveReadPipePackets;
    Id type;
    Id id;
    Id pipe;
    Id numPackets;
    Id packetSize;
    Id packetAlignment;
}

@necessary(Capability.Pipes)
struct ReserveWritePipePacketsInstruction { 
    enum op = Op.OpReserveWritePipePackets;
    Id type;
    Id id;
    Id pipe;
    Id numPackets;
    Id packetSize;
    Id packetAlignment;
}

@necessary(Capability.Pipes)
struct CommitReadPipeInstruction { 
    enum op = Op.OpCommitReadPipe;
    Id pipe;
    Id numPackets;
    Id packetSize;
    Id packetAlignment;
}

@necessary(Capability.Pipes)
struct CommitWritePipeInstruction { 
    enum op = Op.OpCommitWritePipe;
    Id pipe;
    Id numPackets;
    Id packetSize;
    Id packetAlignment;
}

@necessary(Capability.Pipes)
struct IsValidReserveIdInstruction { 
    enum op = Op.OpIsValidReserveId;
    Id type;
    Id id;
    Id reserveId;
}

@necessary(Capability.Pipes)
struct GetNumPipePacketsInstruction { 
    enum op = Op.OpGetNumPipePackets;
    Id type;
    Id id;
    Id pipe;
    Id packetSize;
    Id packetAlignment;
}

@necessary(Capability.Pipes)
struct GetMaxPipePacketsInstruction { 
    enum op = Op.OpGetMaxPipePackets;
    Id type;
    Id id;
    Id pipe;
    Id packetSize;
    Id packetAlignment;
}

@necessary(Capability.Pipes)
struct GroupReserveReadPipePacketsInstruction { 
    enum op = Op.OpGroupReserveReadPipePackets;
    Id type;
    Id id;
    Id executionScope;
    Id pipe;
    Id numPackets;
    Id packetSize;
    Id packetAlignment;
}

@necessary(Capability.Pipes)
struct GroupReserveWritePipePacketsInstruction { 
    enum op = Op.OpGroupReserveWritePipePackets;
    Id type;
    Id id;
    Id executionScope;
    Id pipe;
    Id numPackets;
    Id packetSize;
    Id packetAlignment;
}

@necessary(Capability.Pipes)
struct GroupCommitReadPipeInstruction { 
    enum op = Op.OpGroupCommitReadPipe;
    Id executionScope;
    Id pipe;
    Id reservedId;
    Id packetSize;
    Id packetAlignment;
}

@necessary(Capability.Pipes)
struct GroupCommitWritePipeInstruction { 
    enum op = Op.OpGroupCommitWritePipe;
    Id executionScope;
    Id pipe;
    Id reservedId;
    Id packetSize;
    Id packetAlignment;
}

/*
struct SizeOfInstruction { 
    enum op = Op.OpSizeOf;
    Id type;
    Id id;
}

struct TypePipeStorageInstruction { 
    enum op = Op.OpTypePipeStorage;
    Id type;
    Id id;
}

struct ConstantPipeStorageInstruction { 
    enum op = Op.OpConstantPipeStorage;
    Id type;
    Id id;
}

struct CreatePipeFromPipeStorageInstruction { 
    enum op = Op.OpCreatePipeFromPipeStorage;
    Id type;
    Id id;
}

struct GetKernelLocalSizeForSubgroupCountInstruction { 
    enum op = Op.OpGetKernelLocalSizeForSubgroupCount;
    Id type;
    Id id;
}

struct GetKernelMaxNumSubgroupsInstruction { 
    enum op = Op.OpGetKernelMaxNumSubgroups;
    Id type;
    Id id;
}

struct TypeNamedBarrierInstruction { 
    enum op = Op.OpTypeNamedBarrier;
    Id type;
    Id id;
}

struct NamedBarrierInitializeInstruction { 
    enum op = Op.OpNamedBarrierInitialize;
    Id type;
    Id id;
}

struct MemoryNamedBarrierInstruction { 
    enum op = Op.OpMemoryNamedBarrier;
    Id type;
    Id id;
}

struct ModuleProcessedInstruction { 
    enum op = Op.OpModuleProcessed;
    Id type;
    Id id;
}

struct ExecutionModeIdInstruction { 
    enum op = Op.OpExecutionModeId;
    Id type;
    Id id;
}

struct DecorateIdInstruction { 
    enum op = Op.OpDecorateId;
    Id type;
    Id id;
}

struct GroupNonUniformElectInstruction { 
    enum op = Op.OpGroupNonUniformElect;
    Id type;
    Id id;
}

struct GroupNonUniformAllInstruction { 
    enum op = Op.OpGroupNonUniformAll;
    Id type;
    Id id;
}

struct GroupNonUniformAnyInstruction { 
    enum op = Op.OpGroupNonUniformAny;
    Id type;
    Id id;
}

struct GroupNonUniformAllEqualInstruction { 
    enum op = Op.OpGroupNonUniformAllEqual;
    Id type;
    Id id;
}

struct GroupNonUniformBroadcastInstruction { 
    enum op = Op.OpGroupNonUniformBroadcast;
    Id type;
    Id id;
}

struct GroupNonUniformBroadcastFirstInstruction { 
    enum op = Op.OpGroupNonUniformBroadcastFirst;
    Id type;
    Id id;
}

struct GroupNonUniformBallotInstruction { 
    enum op = Op.OpGroupNonUniformBallot;
    Id type;
    Id id;
}

struct GroupNonUniformInverseBallotInstruction { 
    enum op = Op.OpGroupNonUniformInverseBallot;
    Id type;
    Id id;
}

struct GroupNonUniformBallotBitExtractInstruction { 
    enum op = Op.OpGroupNonUniformBallotBitExtract;
    Id type;
    Id id;
}

struct GroupNonUniformBallotBitCountInstruction { 
    enum op = Op.OpGroupNonUniformBallotBitCount;
    Id type;
    Id id;
}

struct GroupNonUniformBallotFindLSBInstruction { 
    enum op = Op.OpGroupNonUniformBallotFindLSB;
    Id type;
    Id id;
}

struct GroupNonUniformBallotFindMSBInstruction { 
    enum op = Op.OpGroupNonUniformBallotFindMSB;
    Id type;
    Id id;
}

struct GroupNonUniformShuffleInstruction { 
    enum op = Op.OpGroupNonUniformShuffle;
    Id type;
    Id id;
}

struct GroupNonUniformShuffleXorInstruction { 
    enum op = Op.OpGroupNonUniformShuffleXor;
    Id type;
    Id id;
}

struct GroupNonUniformShuffleUpInstruction { 
    enum op = Op.OpGroupNonUniformShuffleUp;
    Id type;
    Id id;
}

struct GroupNonUniformShuffleDownInstruction { 
    enum op = Op.OpGroupNonUniformShuffleDown;
    Id type;
    Id id;
}

struct GroupNonUniformIAddInstruction { 
    enum op = Op.OpGroupNonUniformIAdd;
    Id type;
    Id id;
}

struct GroupNonUniformFAddInstruction { 
    enum op = Op.OpGroupNonUniformFAdd;
    Id type;
    Id id;
}

struct GroupNonUniformIMulInstruction { 
    enum op = Op.OpGroupNonUniformIMul;
    Id type;
    Id id;
}

struct GroupNonUniformFMulInstruction { 
    enum op = Op.OpGroupNonUniformFMul;
    Id type;
    Id id;
}

struct GroupNonUniformSMinInstruction { 
    enum op = Op.OpGroupNonUniformSMin;
    Id type;
    Id id;
}

struct GroupNonUniformUMinInstruction { 
    enum op = Op.OpGroupNonUniformUMin;
    Id type;
    Id id;
}

struct GroupNonUniformFMinInstruction { 
    enum op = Op.OpGroupNonUniformFMin;
    Id type;
    Id id;
}

struct GroupNonUniformSMaxInstruction { 
    enum op = Op.OpGroupNonUniformSMax;
    Id type;
    Id id;
}

struct GroupNonUniformUMaxInstruction { 
    enum op = Op.OpGroupNonUniformUMax;
    Id type;
    Id id;
}

struct GroupNonUniformFMaxInstruction { 
    enum op = Op.OpGroupNonUniformFMax;
    Id type;
    Id id;
}

struct GroupNonUniformBitwiseAndInstruction { 
    enum op = Op.OpGroupNonUniformBitwiseAnd;
    Id type;
    Id id;
}

struct GroupNonUniformBitwiseOrInstruction { 
    enum op = Op.OpGroupNonUniformBitwiseOr;
    Id type;
    Id id;
}

struct GroupNonUniformBitwiseXorInstruction { 
    enum op = Op.OpGroupNonUniformBitwiseXor;
    Id type;
    Id id;
}

struct GroupNonUniformLogicalAndInstruction { 
    enum op = Op.OpGroupNonUniformLogicalAnd;
    Id type;
    Id id;
}

struct GroupNonUniformLogicalOrInstruction { 
    enum op = Op.OpGroupNonUniformLogicalOr;
    Id type;
    Id id;
}

struct GroupNonUniformLogicalXorInstruction { 
    enum op = Op.OpGroupNonUniformLogicalXor;
    Id type;
    Id id;
}

struct GroupNonUniformQuadBroadcastInstruction { 
    enum op = Op.OpGroupNonUniformQuadBroadcast;
    Id type;
    Id id;
}

struct GroupNonUniformQuadSwapInstruction { 
    enum op = Op.OpGroupNonUniformQuadSwap;
    Id type;
    Id id;
}

struct CopyLogicalInstruction { 
    enum op = Op.OpCopyLogical;
    Id type;
    Id id;
}

struct PtrEqualInstruction { 
    enum op = Op.OpPtrEqual;
    Id type;
    Id id;
}

struct PtrNotEqualInstruction { 
    enum op = Op.OpPtrNotEqual;
    Id type;
    Id id;
}

struct PtrDiffInstruction { 
    enum op = Op.OpPtrDiff;
    Id type;
    Id id;
}
*/

