// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20 {
    uint256 public totalSupply;
    string public name;
    string public symbol;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function decimals() external pure returns (uint8) {
        return 18;
    }

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool) {
        return _transfer(msg.sender, recipient, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        uint256 currentAllowance = allowance[sender][msg.sender];
        require(
            currentAllowance >= amount,
            "ERC20: transfer amount exceeds allowance"
        );

        allowance[sender][msg.sender] = currentAllowance - amount;

        return _transfer(sender, recipient, amount);
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        require(spender != address(0), "ERC20: approve to the zero address");
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(
            balanceOf[sender] >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        return true;
    }
}
