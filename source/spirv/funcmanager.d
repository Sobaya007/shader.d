module spirv.funcmanager;

import std;
import spirv.entrypointmanager;
import spirv.spv;
import spirv.typeconstmanager;
import spirv.idmanager;
import spirv.instruction;
import spirv.writer;
import llvm;
import llvm.inst;
import llvm.type;
import llvm.func;

alias BodyInstructions = AliasSeq!(
    LabelInstruction,
);
alias BodyInstruction = Algebraic!(BodyInstructions);

class FunctionManager {

    struct Fn {
        FunctionInstruction decl;
        FunctionParameterInstruction[] ps;
        BodyInstruction[] bs;
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

        addLabel(fn, "start of " ~ func.name);
        foreach (b; func.basicBlocks) {
            foreach (i; b.instructions) {
                add(fn, i);
            }
        }

        auto epAttr = func.attributes.find!(a => a.isString && a.kindAsString == "entryPoint");
        if (epAttr.empty is false) {
            auto model = epAttr.front.valueAsString.to!ExecutionModel;
            auto e = entryPointManager.addEntryPoint(funcId, model);
            foreach (a; func.attributes.filter!(a => a.isString && a.kindAsString == "execMode")) {
                e.addMode(a.valueAsString.to!ExecutionMode);
            }
            fn.ep = e;
        }

        fns ~= fn;

        return funcId;
    }

    void writeAllInstructions(Writer writer) const {
        foreach (fn; fns) {
            writer.writeInstruction(fn.decl);
            foreach (p; fn.ps) writer.writeInstruction(p);
body: foreach (b; fn.bs) {
                static foreach (I; BodyInstructions) {
                    if (auto r = b.peek!I) {
                        writer.writeInstruction(*r);
                        continue body;
                    }
                }
                assert(false);
            }
            writer.writeInstruction(fn.end);
        }
    }

    private Id addLabel(ref Fn fn, string name) {
        auto id = idManager.requestId(name);
        fn.bs ~= BodyInstruction(LabelInstruction(id));
        return id;
    }

    private void add(ref Fn fn, Instruction i) {
    }
}
