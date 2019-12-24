module spirv.instructionmanager;

import std;
import spirv.instruction;
import spirv.writer;
import spirv.spv;

class InstructionManager {

    private CapabilityInstruction[] cis;
    private ExtensionInstruction[] eis;
    private ExtInstImportInstruction[] eiis;
    private const MemoryModelInstuction mis;
    private EntryPointInstruction[] epis;
    private ExecutionModeInstruction[] exis;

    this() {
        this.mis = MemoryModelInstuction(AddressingModel.Logical, MemoryModel.Vulkan);
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
        }
    }
}
