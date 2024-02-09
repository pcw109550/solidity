contract A {
    uint x = 42;
    function f() public returns(uint256) {
        return x;
    }
}
contract B is A {
    uint public y = f();
}
// ----
// constructor() ->
// gas irOptimized: 99440
// gas irOptimized code: 20200
// gas legacy: 100994
// gas legacy code: 32600
// gas legacyOptimized: 99141
// gas legacyOptimized code: 16200
// y() -> 42
