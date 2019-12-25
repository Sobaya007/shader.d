module spirv.compiler;

import std;
import llvm.mod;
import spirv.spirv;
import spirv.spv;

void compileToLL(string file) {
    auto result =executeShell(format!"ldc2 %s --output-ll -Isource"(file));
    enforce(result.status == 0, result.output);
}

void compileToBC(string file) {
    auto result =executeShell(format!"ldc2 %s --output-bc -Isource"(file));
    enforce(result.status == 0, result.output);
}

class SpirvCompiler {

    Spirv compile(Module mod) {
        auto spirv = new Spirv;

        foreach (func; mod.functions) {
            spirv.addFunction(func);
        }

        return spirv;
    }
}
