module spirv.spirvwriter;

import spirv.spv;
import spirv.spirv;
import spirv.writer;
import std;

class SpirvWriter {

    private enum Version = 0x00010000;
    private enum GeneratorMagicNumber = 114514;

    ubyte[] write(const Spirv spirv) {
        auto writer = new Writer;
        with (writer) {
            writeWord(MagicNumber);
            writeWord(Version);
            writeWord(GeneratorMagicNumber);
            writeWord(spirv.idManager.maxID + 1);
            writeWord(0); // reserved area
            spirv.write(writer);
            return writer.data;
        }
    }

    void write(string filename, in Spirv spirv) {
        import std.file : fwrite = write;
        fwrite(filename, write(spirv));
    }
}
