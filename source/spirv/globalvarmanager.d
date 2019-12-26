module spirv.globalvarmanager;

import std;
import spirv.spv;
import spirv.typeconstmanager;
import spirv.idmanager;
import spirv.instruction;
import spirv.writer;
import llvm;
import llvm.type;
import llvm.var;

class GlobalVarManager {

    private IdManager idManager;
    private TypeConstManager typeConstManager;
    private VariableInstruction[] instructions;

    this(IdManager idManager, TypeConstManager typeConstManager) {
        this.idManager = idManager;
        this.typeConstManager = typeConstManager;
    }

    Id addGlobalVar(Variable var) {
        auto type = typeConstManager.requestType(var.type);
        Id id = idManager.requestId(var.name);
        // TODO: Currenty I cannot retrive attribute from GlobalVariable via C-API of LLVM!
        instructions ~= VariableInstruction(type, id, StorageClass.Private);
        return id;
    }

    void writeAllInstructions(Writer writer) const {
        foreach (i; instructions) {
            writer.writeInstruction(i);
        }
    }
}
