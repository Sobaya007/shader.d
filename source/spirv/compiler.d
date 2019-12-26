module spirv.compiler;

import std;
import llvm.mod;
import spirv.spirv;
import spirv.spv;

void compileToLL(string file) {
    auto result = executeShell(format!"ldc2 %s --betterC --output-ll -Isource"(file));
    enforce(result.status == 0, result.output);
}

void compileToBC(string file) {
    auto result = executeShell(format!"ldc2 %s --betterC --output-bc -Isource"(file));
    enforce(result.status == 0, result.output);
}

class SpirvCompiler {

    Spirv compile(Module mod) {
        auto spirv = new Spirv;

        foreach (var; mod.globals) {
            spirv.addVariable(var);
        }

        foreach (func; mod.functions) {
            if (func.attributes.canFind!(a => a.isString && a.kindAsString == "extend")) continue;
            spirv.addFunction(func);
        }

        return spirv;
    }
}
