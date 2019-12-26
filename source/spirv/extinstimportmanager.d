module spirv.extinstimportmanager;

import std;
import spirv.spv;
import spirv.instruction;
import spirv.idmanager;
import spirv.writer;

class ExtInstImportManager {

    private IdManager idManager;
    private Id[string] extInstImports;

    this(IdManager idManager) {
        this.idManager = idManager;
    }

    Id requestExtInstImport(string name) {
        return extInstImports.require(name, idManager.requestId(name));
    }

    void writeAllInstructions(Writer writer) const {
        foreach (name, id; extInstImports) {
            writer.writeInstruction(ExtInstImportInstruction(id, name));
        }
    }
}
