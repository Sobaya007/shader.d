module llvm.value;

mixin template ImplValue(alias mem) {

    import llvm.attr;
    import llvm.type;
    import llvm.operand;
    import llvm.use;

    string name() {
        size_t len;
        auto res = LLVMGetValueName2(mem, &len);
        return res[0..len].to!string;
    }

    Type type() {
        return Type(LLVMTypeOf(mem));
    }

    string toString() {
        return LLVMPrintValueToString(mem).fromStringz.to!string;
    }

    Operand[] operands() {
        auto cnt = LLVMGetNumOperands(mem);
        auto res = new Operand[cnt];
        foreach (i; 0..cnt) {
            res[i] = Operand(LLVMGetOperand(mem, i));
        }
        return res;
    }

    auto uses() {
        struct Result {
            private Nullable!Use use;
            Use front() { return use.get(); }
            void popFront() { use = use.get().next(); }
            bool empty() { return use.isNull; }
        }
        auto firstUse = LLVMGetFirstUse(mem);
        return Result(firstUse ? Use(firstUse).nullable : Nullable!Use.init);
    }

    bool isConstant() {
        return LLVMIsConstant(mem) > 0;
    }
}
