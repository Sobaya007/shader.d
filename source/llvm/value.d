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

    auto attributes() {
        return getAttributes(LLVMAttributeFunctionIndex);
    }

    private auto getAttributes(LLVMAttributeIndex idx) {
        uint cnt = LLVMGetAttributeCountAtIndex(mem, idx);
        auto res = new LLVMAttributeRef[cnt];
        LLVMGetAttributesAtIndex(mem, idx, res.ptr);
        return res.map!(a => Attribute(a));
    }

    LLVMAttributeRef enumAttribute(LLVMAttributeIndex idx, uint kindID) {
        return LLVMGetEnumAttributeAtIndex(mem, idx, kindID);
    }

    LLVMAttributeRef stringAttribute(LLVMAttributeIndex idx, string str) {
        return LLVMGetStringAttributeAtIndex(mem, idx, str.ptr, cast(uint)str.length);
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
