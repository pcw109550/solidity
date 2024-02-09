contract C {
    uint public i;
    constructor(uint newI) {
        i = newI;
    }
}
contract D {
    C c;
    constructor(uint v) {
        c = new C(v);
    }
    function f() public returns (uint r) {
        return c.i();
    }
}
// ----
// constructor(): 2 ->
// gas irOptimized: 138903
// gas irOptimized code: 53800
// gas legacy: 145634
// gas legacy code: 95600
// gas legacyOptimized: 138361
// gas legacyOptimized code: 54600
// f() -> 2
