module shader.builtin;

import core.simd;
import std.traits : isInstanceOf;
import std.meta : Repeat;
import ldc.attributes;
import shader.attribute;
import spirv.spv;

llvmAttr operator(string name) {
    return llvmAttr("operator", name);
}

enum composite = llvmAttr("composite", "poyo");
enum index = llvmAttr("index", "");

@block
struct gl_PerVertex {
    @builtin(BuiltIn.Position) vec4 gl_Position;
    float gl_PointSize;
    float[1] gl_ClipDistance;
    float[1] gl_CullDistance;
}

@output gl_PerVertex vertexOut;

struct Vector(T, size_t N) {
    alias ElementType = T;
    enum Size = N;

    @composite
    this(Repeat!(N,T));

    template opBinary(string op) {
        @operator(BinaryOperator!(T,op))
        Vector opBinary(Vector);
    }
        
    void opOpAssign(string op)(Vector);

    @index
    T opIndex(size_t idx);
}

alias vec2 = Vector!(float,2);
alias vec3 = Vector!(float,3);
alias vec4 = Vector!(float,4);

struct Matrix(T, size_t R, size_t C) {
    alias ElementType = T;
    enum Row = R;
    enum Column = C;
}

struct sampler2D {}

template BinaryOperator(T, string op) {
    enum BinaryOperator = Prefix!(T) ~ OpName!(op);
}

template Prefix(T) {
    static if (__traits(isFloating, T)) {
        enum Prefix = "F";
    } else static if (__traits(isIntegral, T)) {
        static if (__traits(isUnsigned, T)) {
            enum Prefix = "U";
        } else {
            enum Prefix = "S";
        }
    } else {
        static assert(false, format!"Type '%s' is not allowed as element of Vector"(T.stringof));
    }
}

template OpName(string op) {
    static if (op == "+") {
        enum OpName = "Add";
    } else static if (op == "-") {
        enum OpName = "Sub";
    } else static if (op == "*") {
        enum OpName = "Mul";
    } else static if (op == "/") {
        enum OpName = "Div";
    } else static if (op == "%") {
        enum OpName = "Mod";
    } else {
        static assert(false, format!"Operator '%s' is not supported."(op));
    }
}

enum GLSLBuiltin {
    Round = 1,
    RoundEven = 2,
    Trunc = 3,
    FAbs = 4,
    SAbs = 5,
    FSign = 6,
    SSign = 7,
    Floor = 8,
    Ceil = 9,
    Fract = 10,
    Radians = 11,
    Degrees = 12,
    Sin = 13,
    Cos = 14,
    Tan = 15,
    Asin = 16,
    Acos = 17,
    Atan = 18,
    Sinh = 19,
    Cosh = 20,
    Tanh = 21,
    Asinh = 22,
    Acosh = 23,
    Atanh = 24,
    Atan2 = 25,
    Pow = 26,
    Exp = 27,
    Log = 28,
    Exp2 = 29,
    Log2 = 30,
    Sqrt = 31,
    InverseSqrt = 32,
    Determinant = 33,
    MatrixInverse = 34,
    Modf = 35,
    ModStruct = 36,
    FMin = 37,
    UMin = 38,
    SMin = 39,
    FMax = 40,
    UMax = 41,
    SMax = 42,
    FClamp = 43,
    UClamp = 44,
    SClamp = 45,
    FMix = 46,
    Step = 48,
    SmoothStep = 49,
    Fma = 50,
    Frexp = 51,
    FrexpStruct = 52,
    Ldexp = 53,
    PackSnorm4x8 = 54,
    PackUnorm4x8 = 55,
    PackSnorm2x16 = 56,
    PackUnorm2x16 = 57,
    PackHalf2x16 = 58,
    PackDouble2x32 = 59,
    UnpackSnorm2x16 = 60,
    UnpackUnorm2x16 = 61,
    UnpackHalf2x16 = 62,
    UnpackSnorm4x8 = 63,
    UnpackUnorm4x8 = 64,
    UnpackDouble2x32 = 65,
    Length = 66,
    Distance = 67,
    Cross = 68,
    Normalize = 69,
    FaceForward = 70,
    Reflect = 71,
    Refract = 72,
    FindILsb = 73,
    FindSMsb = 74,
    FindUMsb = 75,
    InterpolateAtCentroid = 76,
    InterpolateAtSample = 77,
    InterpolateAtOffset = 78,
    NMin = 79,
    NMax = 80,
    NClamp = 81,
}

llvmAttr extendedFromGLSL(GLSLBuiltin builtin) {
    string str;
    static foreach (E; __traits(allMembers, GLSLBuiltin)) {
        if (mixin("GLSLBuiltin.", E) == builtin) str ~= E;
    }
    return llvmAttr("extend", "GLSL.std.450:" ~ str);
}

enum FS(T)   = __traits(isScalar, T) &&  __traits(isFloating, T);
enum FS32(T) = __traits(isScalar, T) &&  is(T == float);
enum SS(T)   = __traits(isScalar, T) && !__traits(isUnsigned, T) && __traits(isIntegral, T);
enum US(T)   = __traits(isScalar, T) &&  __traits(isUnsigned, T) && __traits(isIntegral, T);
enum FSV(T)   = FS!T   || is(T == Vector!(E, N), E, size_t N) && FS!E;
enum SSV(T)   = SS!T   || is(T == Vector!(E, N), E, size_t N) && SS!E;
enum USV(T)   = US!T   || is(T == Vector!(E, N), E, size_t N) && US!E;
enum FSV32(T) = FS32!T || is(T == Vector!(E, N), E, size_t N) && FS32!E;
enum ISV(T)   = SSV!(T) || USV!(T);
enum Square(T) = isInstanceOf!(Matrix, T) && T.Row == T.Column;

@extendedFromGLSL(GLSLBuiltin.Round)
T round(T)(T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.RoundEven)
T roundEven(T)(T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.Trunc)
T trunc(T)(T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.FAbs)
T abs(T)(T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.SAbs)
T abs(T)(T) if (SSV!T);

@extendedFromGLSL(GLSLBuiltin.FSign)
T sign(T)(T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.SSign)
T sign(T)(T) if (SSV!T);

@extendedFromGLSL(GLSLBuiltin.Floor)
T floor(T)(T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.Ceil)
T ceil(T)(T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.Fract)
T fract(T)(T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.Radians)
T radians(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Degrees)
T degrees(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Sin)
T sin(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Cos)
T cos(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Tan)
T tan(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Asin)
T asin(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Acos)
T acos(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Atan)
T atan(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Sinh)
T sinh(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Cosh)
T cosh(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Tanh)
T tanh(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Asinh)
T asinh(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Acosh)
T acosh(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Atanh)
T atanh(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Atan2)
T atan2(T)(T,T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Pow)
T pow(T)(T,T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Exp)
T exp(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Log)
T log(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Exp2)
T exp2(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Log2)
T log2(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Sqrt)
T sqrt(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.InverseSqrt)
T inverseSqrt(T)(T) if (FSV32!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.Determinant)
T.ElementType determinant(T)(T) if (Square!T);

@extendedFromGLSL(GLSLBuiltin.MatrixInverse)
T matrixInverse(T)(T) if (Square!T);

@extendedFromGLSL(GLSLBuiltin.Modf)
T mod(T)(T,T*) if (FSV!T);

// TODO: not yet implemented
//@extendedFromGLSL(GLSLBuiltin.ModStruct)

@extendedFromGLSL(GLSLBuiltin.FMin)
T min(T)(T,T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.UMin)
T min(T)(T,T) if (USV!T);

@extendedFromGLSL(GLSLBuiltin.SMin)
T min(T)(T,T) if (SSV!T);

@extendedFromGLSL(GLSLBuiltin.FMax)
T max(T)(T,T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.UMax)
T max(T)(T,T) if (USV!T);

@extendedFromGLSL(GLSLBuiltin.SMax)
T max(T)(T,T) if (SSV!T);

@extendedFromGLSL(GLSLBuiltin.FClamp)
T clamp(T)(T,T,T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.UClamp)
T clamp(T)(T,T,T) if (USV!T);

@extendedFromGLSL(GLSLBuiltin.SClamp)
T clamp(T)(T,T,T) if (SSV!T);

@extendedFromGLSL(GLSLBuiltin.FMix)
T mix(T)(T,T,T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.Step)
T step(T)(T,T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.SmoothStep)
T smoothStep(T)(T,T,T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.Fma)
T fma(T)(T,T,T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.Frexp)
T frexp(T,I)(T,I*) if (FSV!T && (USV!I || SSV!I));

// TODO: not yet implemented
// @extendedFromGLSL(GLSLBuiltin.FrexpStruct)

@extendedFromGLSL(GLSLBuiltin.Ldexp)
T ldexp(T,I)(T,I) if (FSV!T && (USV!I || SSV!I));

@extendedFromGLSL(GLSLBuiltin.PackSnorm4x8)
int packSnorm4x8(vec4);

@extendedFromGLSL(GLSLBuiltin.PackUnorm4x8)
uint packUnorm4x8(vec4);

@extendedFromGLSL(GLSLBuiltin.PackSnorm2x16)
int packSnorm2x16(vec2);

@extendedFromGLSL(GLSLBuiltin.PackUnorm2x16)
uint packUnorm2x16(vec2);

@extendedFromGLSL(GLSLBuiltin.PackHalf2x16)
int packHalf2x16(vec2);

// @necessary(Capability.Float64)
@extendedFromGLSL(GLSLBuiltin.PackDouble2x32)
double packDouble2x32(vec2);

@extendedFromGLSL(GLSLBuiltin.UnpackSnorm2x16)
vec2 unpackSnorm2x16(int);

@extendedFromGLSL(GLSLBuiltin.UnpackUnorm2x16)
vec2 unpackUnorm2x16(uint);

@extendedFromGLSL(GLSLBuiltin.UnpackHalf2x16)
vec2 unpackHalf2x16(int);

@extendedFromGLSL(GLSLBuiltin.UnpackSnorm4x8)
vec4 unpackSnorm4x8(int);

@extendedFromGLSL(GLSLBuiltin.UnpackUnorm4x8)
vec4 unpackUnorm4x8(uint);

// @necessary(Capability.Float64)
@extendedFromGLSL(GLSLBuiltin.UnpackDouble2x32)
vec2 unpackDouble2x32(double);

@extendedFromGLSL(GLSLBuiltin.Length)
T.ElementType length(T)(T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.Distance)
T.ElementType distance(T)(T,T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.Cross)
T cross(T)(T,T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.Normalize)
T normalize(T)(T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.FaceForward)
T faceForward(T)(T,T,T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.Reflect)
T reflect(T)(T,T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.Refract)
T refract(T)(T,T,float) if (FSV!T); // TODO: Handle 16bit float

@extendedFromGLSL(GLSLBuiltin.FindILsb)
T findILsb(T)(T) if (ISV!T);

@extendedFromGLSL(GLSLBuiltin.FindSMsb)
T findMsb(T)(T) if (SSV!T);

@extendedFromGLSL(GLSLBuiltin.FindUMsb)
T findMsb(T)(T) if (USV!T);

@extendedFromGLSL(GLSLBuiltin.InterpolateAtCentroid)
T interpolateAtCentroid(T)(T*) if (FSV32!T);

@extendedFromGLSL(GLSLBuiltin.InterpolateAtSample)
T interpolateAtSample(T)(T*, int) if (FSV32!T);

@extendedFromGLSL(GLSLBuiltin.InterpolateAtOffset)
T interpolateAtOffset(T)(T*, int) if (FSV32!T);

@extendedFromGLSL(GLSLBuiltin.NMin)
T nmin(T)(T,T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.NMax)
T nmax(T)(T,T) if (FSV!T);

@extendedFromGLSL(GLSLBuiltin.NClamp)
T nmax(T)(T,T,T) if (FSV!T);
