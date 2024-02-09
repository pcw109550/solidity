contract C {
    uint32[] s;
    constructor()
    {
        s.push();
        s.push();
    }
    function f() external returns (uint)
    {
        (s[1], s) = (4, [0]);
        s = [0];
        s.push();
        return s[1];
        // used to return 4 via IR.
    }
}
// ----
// constructor()
// gas irOptimized: 89149
// gas irOptimized code: 137200
// gas legacy: 89557
// gas legacy code: 126200
// gas legacyOptimized: 83560
// gas legacyOptimized code: 98200
// f() -> 0
