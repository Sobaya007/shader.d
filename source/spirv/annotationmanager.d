module spirv.annotationmanager;

import std;
import spirv.spv;
import spirv.idmanager;
import spirv.instruction;
import spirv.writer;

alias AnnotationInstructions = AliasSeq!(
    DecorateInstruction,
    MemberDecorateInstruction,
    GroupDecorateInstruction,
    // GroupMemberDecorateInstruction, //TODO: compile successfully
    DecorationGroupInstruction
);
alias AnnotationInstruction = Algebraic!(AnnotationInstructions);

class AnnotationManager {

    private AnnotationInstruction[] instructions;

    void notifyDecoration(Id target, Decoration decoration) {
        instructions ~= AnnotationInstruction(DecorateInstruction(target, decoration, Nullable!DecorationExtra.init));
    }

    void notifyDecoration(T)(Id target, Decoration decoration, T extra) {
        instructions ~= AnnotationInstruction(DecorateInstruction(target, decoration, DecorationExtra(extra).nullable));
    }

    void notifyMemberDecoration(Id target, uint index, Decoration decoration) {
        instructions ~= AnnotationInstruction(MemberDecorateInstruction(target, index, decoration, Nullable!DecorationExtra.init));
    }

    void notifyMemberDecoration(T)(Id target, uint index, Decoration decoration, T extra) {
        instructions ~= AnnotationInstruction(MemberDecorateInstruction(target, index, decoration, DecorationExtra(extra).nullable));
    }

    void writeAllInstructions(Writer writer) const {
        foreach (i; instructions) {
            static foreach (I; AnnotationInstructions) {
                if (auto r = i.peek!I) {
                    writer.writeInstruction(*r);
                }
            }
        }
    }
}
