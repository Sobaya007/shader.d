module llvm.block;

import std;
import llvm;
import llvm.inst;

struct BasicBlock {
    LLVMBasicBlockRef block;

    string name() {
        return fromStringz(LLVMGetBasicBlockName(block)).to!string;
    }

    auto instructions() {
        struct InstructionRange {
            private BasicBlock block;
            private Nullable!Instruction inst;

            Instruction front() {
                return inst.get();
            }

            bool empty() {
                return inst.isNull;
            }

            void popFront() {
                if (this.empty) return;
                if (inst.get() == block.lastInstruction) {
                    this.inst.nullify();
                    return;
                }
                this.inst = this.inst.get().next();
            }
        }
        return InstructionRange(this, firstInstruction.nullable);
    }

    private Instruction firstInstruction() {
        return Instruction(LLVMGetFirstInstruction(block));
    }

    private Instruction lastInstruction() {
        return Instruction(LLVMGetLastInstruction(block));
    }
}
