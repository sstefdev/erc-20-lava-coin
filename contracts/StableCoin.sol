// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {ERC20} from "./ERC20.sol";
import {DepositorCoin} from "./DepositorCoin.sol";

contract StableCoin is ERC20 {
    DepositorCoin public depositorCoin;

    uint256 public freeRatePercentage;
    uint256 constant ETH_IN_USD_PRICE = 2000;

    constructor(uint256 _freeRatePercentage) ERC20("StableLava", "SLA") {
        freeRatePercentage = _freeRatePercentage;
    }

    function mint() external payable {
        uint256 fee = _getFee(msg.value);
        uint256 remainingEth = msg.value - fee;
        uint256 mintStableCoin = remainingEth * ETH_IN_USD_PRICE;
        _mint(msg.sender, mintStableCoin);
    }

    function burn(uint256 burnStableCoin) external {
        _burn(msg.sender, burnStableCoin);

        uint256 burnEth = burnStableCoin / ETH_IN_USD_PRICE;
        uint256 fee = _getFee(burnEth);
        uint256 remainingEth = burnEth - fee;

        (bool success, ) = msg.sender.call{value: remainingEth}("");
        require(success, "SLA: Burn refund transaction failed.");
    }

    function _getFee(uint256 ethAmount) private view returns (uint256) {
        bool hasDepositors = address(depositorCoin) != address(0) &&
            depositorCoin.totalSupply() > 0;
        if (!hasDepositors) return 0;

        return (freeRatePercentage * ethAmount) / 100;
    }
}
