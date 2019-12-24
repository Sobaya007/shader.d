module spirv.idmanager;

alias Id = uint;

class IdManager {
    private Id _maxID;
    
    Id maxID() const {
        return _maxID;
    }
}
