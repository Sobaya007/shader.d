module spirv.instruction;

import std;
import spirv.spv;
import spirv.idmanager;

struct CapabilityInstruction {
    enum op = Op.OpCapability;
    Capability cap;
}

struct ExtensionInstruction {
    enum op = Op.OpExtension;
    string name;
}

struct ExtInstImportInstruction {
    enum op = Op.OpExtInstImport;
    Id id;
    string name;
}

struct MemoryModelInstuction {
    enum op = Op.OpMemoryModel;
    AddressingModel addrModel;
    MemoryModel memoryModel;
}

struct EntryPointInstruction {
    enum op = Op.OpEntryPoint;
    ExecutionModel exModel;
    Id id;
    string name;
    Id[] args;
}

struct ExecutionModeInstruction {
    enum op = Op.OpExecutionMode;
    Id entryPoint;
    ExecutionMode mode;
    uint[] extra;
}
