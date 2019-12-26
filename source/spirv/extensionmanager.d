module spirv.extensionmanager;

import std;
import spirv.spv;
import spirv.instruction;
import spirv.writer;

class ExtensionManager {

    private string[] extensions;

    void requstExtension(string ext) {
        if (extensions.canFind(ext)) return;
        extensions ~= ext;
    }

    void writeAllInstructions(Writer writer) const {
        foreach (ext; extensions) {
            writer.writeInstruction(ExtensionInstruction(ext));
        }
    }
}
