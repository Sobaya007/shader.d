module spirv.spirv;

import spirv.idmanager;
import spirv.instructionmanager;
import spirv.instruction;

class Spirv {
    private IdManager _idManager;
    private InstructionManager _instructionManager;

    this() {
        this._idManager = new IdManager;
        this._instructionManager = new InstructionManager;
    }

    const(InstructionManager) instructionManager() const {
        return _instructionManager;
    }

    const(IdManager) idManager() const{
        return _idManager;
    }

    void addinstruction(Instruction)(Instruction inst) {
        _instructionManager.addInstruction(inst);
    }
}
