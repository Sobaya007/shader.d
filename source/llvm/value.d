module llvm.value;

mixin template ImplValue(alias mem) {

    import llvm.attr;
    import llvm.type;
    import llvm.operand;

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
}
