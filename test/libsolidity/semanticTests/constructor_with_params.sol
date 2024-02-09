contract C {
    uint public i;
    uint public k;

    constructor(uint newI, uint newK) {
        i = newI;
        k = newK;
    }
}
// ----
// constructor(): 2, 0 ->
// gas irOptimized: 81190
// gas irOptimized code: 20200
// gas legacy: 83678
// gas legacy code: 32000
// i() -> 2
// k() -> 0
