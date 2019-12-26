module spirv.funcmanager;

import std;
import spirv.entrypointmanager;
import spirv.spv;
import spirv.typeconstmanager;
import spirv.idmanager;
import spirv.instruction;
import spirv.writer;
import llvm;
import llvm.type;
import llvm.func;

class FunctionManager {

    struct Fn {
        FunctionInstruction decl;
        FunctionParameterInstruction[] ps;
        FunctionEndInstruction end;
        EntryPoint ep;
    }

    private IdManager idManager;
    private EntryPointManager entryPointManager;
    private TypeConstManager typeConstManager;
    private Fn[] fns;

    this(IdManager idManager, EntryPointManager entryPointManager, TypeConstManager typeConstManager) {
        this.idManager = idManager;
        this.entryPointManager = entryPointManager;
        this.typeConstManager = typeConstManager;
    }

    Id addFunction(Function func) {
        auto ft = func.type.elementType;
        auto returnType = typeConstManager.requestType(ft.returnType);
        auto funcId = idManager.requestId(func.name);
        auto funcType = typeConstManager.requestType(ft);

        Fn fn;

        /* TODO: Correctly handle control mask */
        fn.decl = FunctionInstruction(returnType, funcId, FunctionControlMask.MaskNone, funcType);

        foreach (i, p; func.params.enumerate) {
            auto paramType = typeConstManager.requestType(p.type);
            auto paramId = idManager.requestId(format!"%s.__param__%d"(func.name, i));
            fn.ps ~= FunctionParameterInstruction(paramType, paramId);
        }

        if (func.name == "main") {
            // TODO: determine ExecutionModel via UDA
            auto e = entryPointManager.addEntryPoint(funcId, ExecutionModel.Fragment);
            fn.ep = e;
        }

        fns ~= fn;

        return funcId;
    }

    void writeAllInstructions(Writer writer) const {
        foreach (fn; fns) {
            writer.writeInstruction(fn.decl);
            foreach (p; fn.ps) writer.writeInstruction(p);
            writer.writeInstruction(fn.end);
        }
    }
}
