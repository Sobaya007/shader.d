import std.file : fwrite = write, fread = read;
import spirv.compiler;
import spirv.spirv;
import spirv.spirvwriter;
import std;
import llvm;
import llvm.mod;
import ldc.attributes;

void main() {
    compileToLL("kernel.d");
    compileToBC("kernel.d");

    auto mod = Module.readBC("kernel.bc", "buffername");

    auto compiler = new SpirvCompiler;
    auto spirv = compiler.compile(mod);

    auto writer = new SpirvWriter;
    fwrite("kernel.spv", writer.write(spirv));
}
