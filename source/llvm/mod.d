module llvm.mod;

import std;
import std.file : fread = read;
import llvm;
import llvm.func;
import llvm.var;

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
                this.func = func.get().next();
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

    auto globals() {
        struct GlobalRange {
            private Module mod;
            private Nullable!Variable var;

            Variable front() {
                return var.get();
            }

            bool empty() {
                return var.isNull;
            }

            void popFront() {
                if (this.empty) return;
                if (var.get() == mod.lastGlobal.get()) {
                    this.var.nullify();
                    return;
                }
                this.var = var.get().next();
            }
        }
        return GlobalRange(this, firstGlobal);
    }

    private Nullable!Variable firstGlobal() {
        auto v = LLVMGetFirstGlobal(mod);
        return v ? Variable(v).nullable : Nullable!Variable.init;
    }

    private Nullable!Variable lastGlobal() {
        auto v = LLVMGetLastGlobal(mod);
        return v ? Variable(v).nullable : Nullable!Variable.init;
    }
}
