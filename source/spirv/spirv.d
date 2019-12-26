module spirv.spirv;

import std;
import spirv.spv;
import spirv.idmanager;
import spirv.instruction;
import spirv.typeconstmanager;
import spirv.varmanager;
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
    private TypeConstManager typeConstManager;
    private VarManager varManager;
    private CapabilityInstruction[] cis;
    private ExtensionInstruction[] eis;
    private ExtInstImportInstruction[] eiis;
    private const MemoryModelInstuction mis;
    private EntryPointInstruction[] epis;
    private ExecutionModeInstruction[] exis;
    private FunctionDeclaration[] funcs;

    this() {
        this._idManager = new IdManager;
        this.typeConstManager = new TypeConstManager(_idManager);
        this.varManager = new VarManager(_idManager, typeConstManager);
        this.mis = MemoryModelInstuction(AddressingModel.Logical, MemoryModel.Vulkan);
    }

    const(IdManager) idManager() const{
        return _idManager;
    }

    void write(Writer writer) const {
        with (writer) {
            foreach (i; cis) {
                writeInstruction(i);
            }
            foreach (i; eis) {
                writeInstruction(i);
            }

            foreach (i; eiis) {
                writeInstruction(i);
            }
            writeInstruction(mis);
            foreach (i; epis) {
                writeInstruction(i);
            }
            foreach (i; exis) {
                writeInstruction(i);
            }
            _idManager.writeAllDeclarions(writer);
            // annotation insruction
            typeConstManager.writeAllDeclarions(writer);
            varManager.writeAllDeclarions(writer);
            foreach (f; funcs) {
                writeInstruction(f.f);
                foreach (p; f.ps) {
                    writeInstruction(p);
                }
                writeInstruction(FunctionEndInstruction());
            }
            // function definition
        }
    }

    void addVariable(Variable var) {
        enforce(var.type.kind == LLVMPointerTypeKind);
        varManager.requestVar(var);
    }

    void addFunction(Function func) {
        enforce(func.type.kind == LLVMPointerTypeKind);
        auto ft = func.type.elementType;
        auto returnType = typeConstManager.requestType(ft.returnType);
        auto funcId = _idManager.requestId(func.name);
        auto funcType = typeConstManager.requestType(ft);
        FunctionDeclaration decl;
        /* TODO: Correctly handle control mask */
        decl.f = FunctionInstruction(returnType, funcId, FunctionControlMask.MaskNone, funcType);

        foreach (i, p; func.params.enumerate) {
            auto paramType = typeConstManager.requestType(p.type);
            auto paramId = _idManager.requestId(format!"%s.__param__%d"(func.name, i));
            decl.ps ~= FunctionParameterInstruction(paramType, paramId);
        }
        funcs ~= decl;

        foreach (b; func.basicBlocks) {
            foreach (inst; b.instructions) {
                if (inst.opcode == LLVMAlloca) {
                    // writeln(inst.opcode, ": ", inst.allocatedType);
                } else {
                }
            }
        }
    }
}
