contract C {
    uint public i;
    constructor(uint newI) {
        i = newI;
    }
}
contract D {
    C c;
    constructor(uint v) {
        c = new C{salt: "abc"}(v);
    }
    function f() public returns (uint r) {
        return c.i();
    }
}
// ====
// EVMVersion: >=constantinople
// ----
// constructor(): 2 ->
// gas irOptimized: 139066
// gas irOptimized code: 53800
// gas legacy: 146006
// gas legacy code: 95600
// gas legacyOptimized: 138593
// gas legacyOptimized code: 54600
// f() -> 2
