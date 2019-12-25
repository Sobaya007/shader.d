module shader.builtin;

import ldc.attributes;

llvmAttr extended(string name, string from) {
    return llvmAttr("extend", from ~ ":" ~ name);
}

llvmAttr extendedFromGLSL(string name) {
    return extended(name, "GLSL.std.450");
}

struct Vector(T, size_t N) {
    @extendedFromGLSL("Sqrt")
        this(T[N] e...);

    @extendedFromGLSL("Sqrt")
        Vector opBinary(string op)(Vector);
    @extendedFromGLSL("Sqrt")
    void opOpAssign(string op)(Vector);
}

alias vec2 = Vector!(float, 2);
alias vec3 = Vector!(float, 3);
alias vec4 = Vector!(float, 4);
struct sampler2D {}

@extendedFromGLSL("Sqrt")
T sqrt(T)(T);
