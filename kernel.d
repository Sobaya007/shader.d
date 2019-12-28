import shader.builtin;
import shader.attribute;
import spirv.spv;
import ldc.attributes;

extern(C):

@input {
    vec4 color1;
    vec4 multiplier;
    @noperspective vec4 color2;
}
@output {
    vec4 color;
}

align(1)
struct S {
    bool b;
    vec4[5] v;
    int i;
}

@block
align(1)
struct BlockName {
    S s;
    bool cond;
}
@uniform BlockName* blockName;

@entryPoint(ExecutionModel.Fragment)
@execMode(ExecutionMode.OriginLowerLeft)
void main() {
    vec4 scale = vec4(1.0, 1.0, 2.0, 1.0);
    color = color1 + blockName.s.v[2];
    /*
    if (blockName.cond)
        color = color1 + blockName.s.v[2];
    else
        color = sqrt(color2) * scale;
    for (int i = 0; i < 4; ++i)
        color *= multiplier;
    */
}
