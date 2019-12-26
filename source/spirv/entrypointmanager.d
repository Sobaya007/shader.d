module spirv.entrypointmanager;

import std;
import spirv.spv;
import spirv.instruction;
import spirv.idmanager;
import spirv.writer;

class EntryPoint {
    private Id id;
    private ExecutionModel model;
    private Id[] args;
    private EntryPointManager.ExecutionModeOption[] options;

    this(Id id, ExecutionModel model) {
        this.id = id;
        this.model = model;
    }

    void notifyUse(Id globalVar) {
        args ~= globalVar;
    }

    void addMode(ExecutionMode mode, uint[] extra...) {
        this.options ~= EntryPointManager.ExecutionModeOption(mode, extra);
    }
}

class EntryPointManager {

    struct ExecutionModeOption {
        private ExecutionMode mode;
        private uint[] extra;
    }

    private IdManager idManager;
    private EntryPoint[] entryPoints;

    this(IdManager idManager) {
        this.idManager = idManager;
    }

    EntryPoint addEntryPoint(Id entryPoint, ExecutionModel model) {
        auto e = new EntryPoint(entryPoint, model);
        entryPoints ~= e;
        return e;
    }

    void writeAllInstructions(Writer writer) const {
        foreach (ep; entryPoints) {
            writer.writeInstruction(const EntryPointInstruction(ep.model, ep.id, idManager.getName(ep.id), ep.args));
        }
        foreach (ep; entryPoints) {
            foreach (op; ep.options) {
                writer.writeInstruction(const ExecutionModeInstruction(ep.id, op.mode, op.extra));
            }
        }
    }
}
