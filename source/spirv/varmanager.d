module spirv.varmanager;

import std;
import spirv.spv;
import spirv.typeconstmanager;
import spirv.idmanager;
import spirv.instruction;
import spirv.writer;
import llvm;
import llvm.type;
import llvm.var;

class VarManager {

    private IdManager idManager;
    private TypeConstManager typeConstManager;
    private Id[string] vars;
    private VariableInstruction[] instructions;

    this(IdManager idManager, TypeConstManager typeConstManager) {
        this.idManager = idManager;
        this.typeConstManager = typeConstManager;
    }

    Id requestVar(Variable var) {
        auto name = var.name;
        if (auto res = name in vars) return *res;
        auto type = typeConstManager.requestType(var.type);
        return newVar(name, type);
    }

    void writeAllDeclarions(Writer writer) const {
        foreach (i; instructions) {
            writer.writeInstruction(i);
        }
    }

    private Id newVar(string name, Id type) {
        Id id = idManager.requestId(name);
        vars[name] = id;
        // TODO: Currenty I cannot retrive attribute from GlobalVariable via C-API of LLVM!
        instructions ~= VariableInstruction(type, id, StorageClass.Private);
        return id;
    }
}
