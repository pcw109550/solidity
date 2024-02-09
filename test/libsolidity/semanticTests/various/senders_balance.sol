contract C {
    function f() public view returns (uint256) {
        return msg.sender.balance;
    }
}


contract D {
    C c = new C();

    constructor() payable {}

    function f() public view returns (uint256) {
        return c.f();
    }
}
// ----
// constructor(), 27 wei ->
// gas irOptimized: 114065
// gas irOptimized code: 53800
// gas legacy: 117859
// gas legacy code: 100600
// gas legacyOptimized: 113692
// gas legacyOptimized code: 53600
// f() -> 27
