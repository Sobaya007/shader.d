module llvm.mod;

import std;
import std.file : fread = read;
import llvm;
import llvm.func;

struct Module {

    private LLVMModuleRef mod;

    static readBC(string filename, string buffername) {
        auto data = fread(filename);
        auto MB = LLVMCreateMemoryBufferWithMemoryRangeCopy(cast(char*)data.ptr, data.length, buffername.ptr);
        LLVMModuleRef mod;
        auto result = LLVMParseBitcode2(MB, &mod);
        enforce(result == 0);
        return Module(mod);
    }

    string identifier() {
        size_t len;
        auto res = LLVMGetModuleIdentifier(mod, &len);
        return res[0..len].to!string;
    }

    auto functions() {
        struct FunctionRange {
            private Module mod;
            private Nullable!Function func;

            Function front() {
                return func.get();
            }

            bool empty() {
                return func.isNull;
            }

            void popFront() {
                if (this.empty) return;
                if (func.get() == mod.lastFunction) {
                    this.func.nullify();
                    return;
                }
                this.func = Function(LLVMGetNextFunction(func.get().func));
            }
        }
        return FunctionRange(this, firstFunction.nullable);
    }

    private Function firstFunction() {
        return Function(LLVMGetFirstFunction(mod));
    }

    private Function lastFunction() {
        return Function(LLVMGetLastFunction(mod));
    }
}
