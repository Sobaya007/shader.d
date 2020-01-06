module spirv.compiler;

import std;
import llvm.mod;
import llvm.func;
import spirv.spirv;
import spirv.spv;
import core.thread;

void compileToLL(string file) {
    auto result = executeShell(format!"ldc2 %s --betterC --output-ll -I%s"(file, __FILE_FULL_PATH__.dirName.dirName));
    enforce(result.status == 0, result.output);
}

void compileToBC(string file) {
    auto result = executeShell(format!"ldc2 %s --betterC --output-bc -I%s"(file, __FILE_FULL_PATH__.dirName.dirName));
    enforce(result.status == 0, result.output);
}

class SpirvCompiler {

    Spirv compile(string filename) {
        compileToLL(filename);
        compileToBC(filename);

        auto mod = Module.readBC(filename.setExtension("bc"), filename.stripExtension);
        return compile(mod);
    }

    Spirv compile(Module mod) {
        auto spirv = new Spirv;

        foreach (var; mod.globals) {
            // if (var.firstUse is null) continue;
            spirv.addVariable(var);
        }

        Function[] enumerateAllUsers(Function f) {
            Function[] result = f.uses.map!(u => u.user).array;
            while (true) {
                auto next = result.map!(f => f.uses.map!(u => u.user).array).join.sort!((a,b) => a.toString() < b.toString()).uniq.array;
                if (next == result) break;
                result = next;
            }
            return result;
        }

        bool hasEntryPoint(Function f) {
            return f.attributes.canFind!(a => a.isString && a.kindAsString == "entryPoint");
        }

        foreach (func; mod.functions) {
            const hasExtend = func.attributes.canFind!(a => a.isString && a.kindAsString == "extend");
            if (hasExtend) continue;
            if (!hasEntryPoint(func) && enumerateAllUsers(func).all!(f => !hasEntryPoint(f))) continue;

            spirv.addFunction(func);
        }

        return spirv;
    }
}
