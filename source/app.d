import std.file : fwrite = write, fread = read;
import spirv.compiler;
import spirv.spirv;
import spirv.spirvwriter;
import std;
import llvm;
import llvm.mod;
import ldc.attributes;

void main() {
    auto compiler = new SpirvCompiler;
    auto spirv = compiler.compile("kernel.d");

    auto writer = new SpirvWriter;
    fwrite("kernel.spv", writer.write(spirv));
}
