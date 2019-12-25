module spirv.spirv;

import std;
import spirv.spv;
import spirv.constantmanager;
import spirv.idmanager;
import spirv.instruction;
import spirv.typemanager;
import spirv.writer;
import llvm;
import llvm.func;

class Spirv {
    struct FunctionDeclaration {
        FunctionInstruction f;
        FunctionParameterInstruction[] ps;
    }

    private IdManager _idManager;
    private ConstantManager constantManager;
    private TypeManager typeManager;
    private CapabilityInstruction[] cis;
    private ExtensionInstruction[] eis;
    private ExtInstImportInstruction[] eiis;
    private const MemoryModelInstuction mis;
    private EntryPointInstruction[] epis;
    private ExecutionModeInstruction[] exis;
    private FunctionDeclaration[] funcs;

    this() {
        this._idManager = new IdManager;
        this.constantManager = new ConstantManager(_idManager);
        this.typeManager = new TypeManager(_idManager, constantManager);
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
            constantManager.writeAllDeclarions(writer);
            typeManager.writeAllDeclarions(writer);
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

    void addFunction(Function func) {
        enforce(func.type.kind == LLVMPointerTypeKind);
        auto ft = func.type.elementType;
        auto returnType = typeManager.requestType(ft.returnType);
        auto funcId = _idManager.requestId(func.name);
        auto funcType = typeManager.requestType(ft);
        FunctionDeclaration decl;
        /* TODO: Correctly handle control mask */
        decl.f = FunctionInstruction(returnType, funcId, FunctionControlMask.MaskNone, funcType);

        foreach (i, p; func.params.enumerate) {
            auto paramType = typeManager.requestType(p.type);
            auto paramId = _idManager.requestId(format!"%s.__param__%d"(func.name, i));
            decl.ps ~= FunctionParameterInstruction(paramType, paramId);
        }
        funcs ~= decl;

        foreach (b; func.basicBlocks) {
            foreach (inst; b.instructions) {
                /*
                if (inst.opcode == LLVMAlloca) {
                    writeln(inst.opcode, ": ", inst.allocatedType);
                } else {
                    writeln(inst.opcode);
                }
                */
            }
        }
    }
}
