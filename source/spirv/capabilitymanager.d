module spirv.capabilitymanager;

import std;
import spirv.spv;
import spirv.instruction;
import spirv.writer;

class CapabilityManager {

    private Capability[] capabilities;

    void requestCapability(Capability cap) {
        if (capabilities.canFind(cap)) return;
        capabilities ~= cap;
    }

    void writeAllInstructions(Writer writer) const {
        foreach (cap; capabilities) {
            writer.writeInstruction(CapabilityInstruction(cap));
        }
    }
}
