module spirv.spirvwriter;

import spirv.spv;
import spirv.spirv;
import spirv.writer;
import std;

class SpirvWriter {

    private enum GeneratorMagicNumber = 114514;

    private Writer writer;

    this() {
        this.writer = new Writer;
    }

    ubyte[] write(const Spirv spirv) {
        with (writer) {
            writeWord(MagicNumber);
            writeWord(Version);
            writeWord(GeneratorMagicNumber);
            writeWord(spirv.idManager.maxID + 1);
            writeWord(0); // reserved area
            spirv.instructionManager.write(writer);
            return writer.data;
        }
    }
}
