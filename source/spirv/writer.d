module spirv.writer;

import std;
import spirv.instruction;
import spirv.idmanager;
import spirv.spv;

class Writer {
    private ubyte[] _data;

    ubyte[] data() {
        return _data;
    }

    void writeWord(float f) {
        debug auto sizeBefore = _data.length;
        debug scope (exit) assert(_data.length == sizeBefore + 4);

        float[] x = [f];
        _data ~= cast(ubyte[])(x);
    }

    void writeWord(uint i) {
        debug auto sizeBefore = _data.length;
        debug scope (exit) assert(_data.length == sizeBefore + 4);

        uint[] x = [i];
        _data ~= cast(ubyte[])(x);
    }

    void writeHalfWord(ushort s) {
        debug auto sizeBefore = _data.length;
        debug scope (exit) assert(_data.length == sizeBefore + 2);

        ushort[] x = [s];
        _data ~= cast(ubyte[])(x);
    }

    void writeDoubleWord(ulong l) {
        debug auto sizeBefore = _data.length;
        debug scope (exit) assert(_data.length == sizeBefore + 8);

        ulong[] x = [l];
        _data ~= cast(ubyte[])(x);
    }

    void writeString(string str) {
        foreach (char c; str) {
            _data ~= c;
        }
        if (str.length % 4 == 0) {
            writeWord(0);
        } else {
            foreach (i; 0..4-str.length % 4) {
                _data ~= cast(ubyte)0;
            }
        }
    }

    void writeInstruction(Instruction)(const Instruction i) {
        auto wc = getWordCount(i);

        debug auto sizeBefore = _data.length;
        debug scope (exit) assert(_data.length == sizeBefore + wc * 4, Instruction.stringof);

        writeHalfWord(cast(ushort)i.op);
        writeHalfWord(wc);

        void writeLocal(T)(T t) {
            static if (isInstanceOf!(Nullable, T)) {
                if (!t.isNull) writeLocal(t.get());
            } else static if (isInstanceOf!(VariantN, T)) {
                static foreach (S; T.AllowedTypes) {
                    if (auto r = t.peek!S) {
                        writeLocal(*r);
                        return;
                    }
                }
                assert(false);
            } else static if (isInstanceOf!(Tuple, T)) {
                foreach (e; t) writeLocal(e);
            } else static if (is(T : uint)) {
                writeWord(t);
            } else static if (is(T : ulong)) {
                writeDoubleWord(t);
            } else static if (is(T : float)) {
                writeWord(t);
            } else static if (is(T == string)) {
                writeString(t);
            } else static if (is(T == E[], E)) {
                foreach (e; t) writeLocal(e);
            } else {
                static assert(false);
            }
        }
        static foreach (mem; __traits(allMembers, Instruction)) {
            static if (mem != "op") {
                writeLocal(__traits(getMember, i, mem));
            }
        }
    }

    private ushort getWordCount(Instruction)(const Instruction i) {
        ushort result = 0;

        ushort wc(T)(T t) {
            static if (isInstanceOf!(Nullable, T)) {
                return t.isNull ? 0 : wc(t.get());
            } else static if (isInstanceOf!(VariantN, T)) {
                static foreach (S; T.AllowedTypes) {
                    if (auto r = t.peek!S) {
                        return wc(*r);
                    }
                }
                assert(false);
            } else static if (isInstanceOf!(Tuple, T)) {
                ushort r = 0;
                foreach (e; t) r += wc(e);
                return r;
            } else static if (is(T : uint)) {
                return 1;
            } else static if (is(T : ulong)) {
                return 2;
            } else static if (is(T : float)) {
                return 1;
            } else static if (is(T == string)) {
                return cast(ushort)(t.length/4 + 1);
            } else static if (is(T == E[], E)) {
                ushort r = 0;
                foreach (e; t) r += wc(e);
                return r;
            } else {
                static assert(false);
            }
        }
        static foreach (mem; __traits(allMembers, Instruction)) {
            result += wc(__traits(getMember, i, mem));
        }
        return result;
    }
}
