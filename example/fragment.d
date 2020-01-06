import shader.builtin;
import shader.attribute;
import spirv.spv;
import ldc.attributes;

extern(C):

@output {
    vec4 color;
}

@entryPoint(ExecutionModel.Fragment)
@execMode(ExecutionMode.OriginUpperLeft)
void fragMain() {
    color = vec4(1.0, 1.0, 1.0, 1.0);
}
