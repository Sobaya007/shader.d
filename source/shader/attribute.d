module shader.attribute;

import ldc.attributes;
import spirv.spv;

llvmAttr storageClass(StorageClass sc) {
    return llvmAttr("storageClass", toString(sc));
}

llvmAttr decoration(Decoration dc) {
    return llvmAttr("decoration", toString(dc));
}

llvmAttr entryPoint(ExecutionModel model) {
    return llvmAttr("entryPoint", toString(model));
}

llvmAttr execMode(ExecutionMode mode) {
    return llvmAttr("execMode", toString(mode));
}

enum input = storageClass(StorageClass.Input);
enum output = storageClass(StorageClass.Output);
enum uniform = storageClass(StorageClass.Uniform);
enum block = decoration(Decoration.Block);
enum noperspective = decoration(Decoration.NoPerspective);

string toString(E)(E e) {
    static foreach (e2; __traits(allMembers, E)) {
        if (e == mixin(E.stringof, ".", e2)) return e2.stringof[1..$-1];
    }
    assert(false);
}
