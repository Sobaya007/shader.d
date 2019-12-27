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
        auto storageClass = getStorageClass(var);
        instructions ~= VariableInstruction(type, id, storageClass);
        return id;
    }

    void writeAllInstructions(Writer writer) const {
        foreach (i; instructions) {
            writer.writeInstruction(i);
        }
    }

    private StorageClass getStorageClass(Variable var) {
        auto attr = var.attributes
            .filter!(a => a.isString)
            .filter!(a => a.kindAsString == "storageClass")
            .map!(a => a.valueAsString)
            .map!(a => a.to!StorageClass)
            .array;
        enforce(attr.length <= 1, format!"Too many storage class has detected at '%s'"(var.name));
        enforce(attr.length == 1, format!"No storage class are specified at '%s'"(var.name));

        return attr.front;
    }
}
