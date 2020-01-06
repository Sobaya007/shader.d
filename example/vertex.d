import shader.builtin;
import shader.attribute;
import spirv.spv;
import ldc.attributes;

extern(C):

@input vec2 pos;

@entryPoint(ExecutionModel.Vertex)
void vertMain() {
    vertexOut.gl_Position = vec4(pos[0], pos[1], 0.0, 1.0);
}
