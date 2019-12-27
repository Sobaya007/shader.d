module spirv.spirv;

import std;
import spirv.annotationmanager;
import spirv.capabilitymanager;
import spirv.entrypointmanager;
import spirv.extensionmanager;
import spirv.extinstimportmanager;
import spirv.funcmanager;
import spirv.spv;
import spirv.idmanager;
import spirv.instruction;
import spirv.typeconstmanager;
import spirv.globalvarmanager;
import spirv.writer;
import llvm;
import llvm.func;
import llvm.var;

class Spirv {
    struct FunctionDeclaration {
        FunctionInstruction f;
        FunctionParameterInstruction[] ps;
    }

    private IdManager _idManager;
    private CapabilityManager capabilityManager;
    private ExtensionManager extensionManager;
    private ExtInstImportManager extInstImportManager;
    private EntryPointManager entryPointManager;
    private AnnotationManager annotationManager;
    private TypeConstManager typeConstManager;
    private FunctionManager funcManager;
    private GlobalVarManager globalvarManager;
    private MemoryModelInstuction mis;

    this() {
        this._idManager = new IdManager;
        this.capabilityManager = new CapabilityManager;
        this.extensionManager = new ExtensionManager;
        this.extInstImportManager = new ExtInstImportManager(_idManager);
        this.entryPointManager = new EntryPointManager(_idManager);
        this.annotationManager = new AnnotationManager;
        this.typeConstManager = new TypeConstManager(_idManager, annotationManager);
        this.funcManager = new FunctionManager(_idManager, entryPointManager, typeConstManager);
        this.globalvarManager = new GlobalVarManager(_idManager, typeConstManager);
        this.mis = MemoryModelInstuction(AddressingModel.Logical, MemoryModel.Vulkan);
    }

    const(IdManager) idManager() const{
        return _idManager;
    }

    void write(Writer writer) const {
        with (writer) {
            capabilityManager.writeAllInstructions(writer);
            extensionManager.writeAllInstructions(writer);
            extInstImportManager.writeAllInstructions(writer);
            writeInstruction(mis);
            entryPointManager.writeAllInstructions(writer);
            _idManager.writeAllInstructions(writer);
            annotationManager.writeAllInstructions(writer);
            typeConstManager.writeAllInstructions(writer);
            globalvarManager.writeAllInstructions(writer);
            funcManager.writeAllInstructions(writer);
        }
    }

    void addVariable(Variable globalvar) {
        enforce(globalvar.type.kind == LLVMPointerTypeKind);
        globalvarManager.addGlobalVar(globalvar);
    }

    void addFunction(Function func) {
        enforce(func.type.kind == LLVMPointerTypeKind);
        funcManager.addFunction(func);
    }
}
