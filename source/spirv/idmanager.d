module spirv.idmanager;

import std;
import spirv.instruction;
import spirv.writer;

alias Id = uint;

alias DebugInstructions = AliasSeq!(
    NameInstruction,
    MemberNameInstruction,
);

alias DebugInstruction = Algebraic!(DebugInstructions);

class IdManager {
    private Id[string] ids;
    private Id _maxId;
    private DebugInstruction[] instructions;
    
    Id maxID() const {
        return _maxId;
    }

    Id requestId(string name) {
        if (auto res = name in ids) return *res;
        _maxId++;
        auto newId = _maxId;
        ids[name] = newId;
        instructions ~= DebugInstruction(NameInstruction(newId, name));
        return newId;
    }

    void writeAllDeclarions(Writer writer) const {
        foreach (i; instructions) {
            static foreach (I; DebugInstructions) {
                if (auto r = i.peek!I) {
                    writer.writeInstruction(*r);
                }
            }
        }
    }
}
