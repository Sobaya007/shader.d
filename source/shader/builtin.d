module shader.builtin;

import ldc.attributes;

llvmAttr extended(string name, string from) {
    return llvmAttr("extend", from ~ ":" ~ name);
}

llvmAttr extendedFromGLSL(string name) {
    return extended(name, "GLSL.std.450");
}

llvmAttr operator(string name) {
    return llvmAttr("operator", name);
}

struct Vector(T, size_t N) {

    import std.format : format;

    this(T[N] e...);

    template opBinary(string op) {
        @operator(BinaryOperator!(T,op))
        Vector opBinary(Vector);
    }
        
    @extendedFromGLSL("Sqrt")
    void opOpAssign(string op)(Vector);
}

alias vec2 = Vector!(float, 2);
alias vec3 = Vector!(float, 3);
alias vec4 = Vector!(float, 4);
struct sampler2D {}

@extendedFromGLSL("Sqrt")
T sqrt(T)(T);

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
