import shader.builtin;
import shader.attribute;
import spirv.spv;
import ldc.attributes;

@(StorageClass.Input) {
    @layout(0) vec4 color1;
    @layout(1) vec4 multiplier;
    @(Decoration.NoPerspective) @layout(2) vec4 color2;
}
@(StorageClass.Output) {
    @layout(0) vec4 color;
}

struct S {
    bool b;
    vec4[5] v;
    int i;
};

struct BlockName {
    S s;
    bool cond;
};
@(Decoration.Uniform) BlockName* blockName;

void main() {
    with (blockName) {
        vec4 scale = vec4(1.0, 1.0, 2.0, 1.0);
        if (cond)
            color = color1 + s.v[2];
        else
            color = sqrt(color2) * scale;
        for (int i = 0; i < 4; ++i)
            color *= multiplier;
    }
}
