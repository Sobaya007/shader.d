module spirv.idmanager;

import std;
alias Id = uint;

class IdManager {
    private Id[string] ids;
    private Id _maxId;
    
    Id maxID() const {
        return _maxId;
    }

    Id requestId(string name) {
        if (auto res = name in ids) return *res;
        _maxId++;
        auto newId = _maxId;
        ids[name] = newId;
        return newId;
    }
}
