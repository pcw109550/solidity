contract helper {
    function getBalance() public payable returns (uint256 myBalance) {
        return address(this).balance;
    }
}


contract test {
    helper h;

    constructor() payable {
        h = new helper();
    }

    function sendAmount(uint256 amount) public payable returns (uint256 bal) {
        uint256 someStackElement = 20;
        return h.getBalance{value: amount + 3, gas: 1000}();
    }
}
// ----
// constructor(), 20 wei ->
// gas irOptimized: 114407
// gas irOptimized code: 58000
// gas legacy: 120096
// gas legacy code: 132200
// gas legacyOptimized: 114552
// gas legacyOptimized code: 65800
// sendAmount(uint256): 5 -> 8
