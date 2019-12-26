module spirv.constantmanager;

import std;
import spirv.spv;
import spirv.idmanager;
import spirv.instruction;
import spirv.writer;
import llvm;
import llvm.type;

alias ConstInstructions = AliasSeq!(
    ConstantTrueInstruction,
    ConstantFalseInstruction,
    ConstantInstruction!(uint),
    ConstantInstruction!(float),
    ConstantCompositeInstruction,
);

alias ConstInstruction = Algebraic!(ConstInstructions);

class ConstantManager {

    private IdManager idManager;
    private Id[Tuple!(string,string)] consts;
    private ConstInstruction[] instructions;

    this(IdManager idManager) {
        this.idManager = idManager;
    }

    Id requestConstant(T)(Id type, T value) {
        auto name = tuple(T.stringof, value.to!string);
        if (auto res = name in consts) return *res;

        static if (is(T == bool)) {
            if (value == true) return newConstant!(ConstantTrueInstruction)(type, name);
            else               return newConstant!(ConstantFalseInstruction)(type, name);
        } else static if (isScalarType!T) {
            return newConstant!(ConstantInstruction!(T), T)(type, name, value);
        } else {
            // TODO: handle vector or array
            static assert(false);
        }
    }

    void writeAllDeclarions(Writer writer) const {
        foreach (i; instructions) {
            static foreach (I; ConstInstructions) {
                if (auto r = i.peek!I) {
                    writer.writeInstruction(*r);
                }
            }
        }
    }

    private Id newConstant(Instruction, Args...)(Id type, Tuple!(string,string) name, Args args) {
        Id id = idManager.requestId(name);
        consts[name] = id;
        instructions ~= ConstInstruction(Instruction(type, id, args));
        return id;
    }
}
