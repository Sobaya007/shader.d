module llvm.use;

import std;
import llvm;
import llvm.func;

struct Use {
    private LLVMUseRef use;

    package Nullable!Use next() {
        auto u = LLVMGetNextUse(use);
        return u ? Use(u).nullable : Nullable!Use.init;
    }

    Function user() {
        return Function(LLVMGetUser(use));
    }

    Function usedValue() {
        return Function(LLVMGetUsedValue(use));
    }
}
