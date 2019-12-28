module spirv.globalvarmanager;

import std;
import spirv.annotationmanager;
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
    private AnnotationManager annotationManager;
    private TypeConstManager typeConstManager;
    private Id[LLVMValueRef] vars;
    private VariableInstruction[] instructions;

    this(IdManager idManager, AnnotationManager annotationManager, TypeConstManager typeConstManager) {
        this.idManager = idManager;
        this.annotationManager = annotationManager;
        this.typeConstManager = typeConstManager;
    }

    Id addGlobalVar(Variable var) {
        enforce(var.type.kind == LLVMPointerTypeKind);
        auto type = typeConstManager.requestType(var.type.elementType);
        Id id = idManager.requestId(var.name);
        auto storageClass = getStorageClass(var);
        auto decoration = getDecoration(var);
        decoration.each!(d => annotationManager.notifyDecoration(id, d));
        instructions ~= VariableInstruction(type, id, storageClass);
        vars[var.var] = id;
        return id;
    }

    Nullable!Id getGlobalVar(LLVMValueRef val) {
        if (auto r = val in vars) return (*r).nullable;
        return Nullable!Id.init;
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

    private auto getDecoration(Variable var) {
        return var.attributes
            .filter!(a => a.isString)
            .filter!(a => a.kindAsString == "decoration")
            .map!(a => a.valueAsString)
            .map!(a => a.to!Decoration);
    }
}
