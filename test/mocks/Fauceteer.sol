// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {ERC20} from "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Fauceteer {
    /// @notice Mapping of user address -> asset address -> last time the user
    /// received that asset
    mapping(address => mapping(address => uint)) public lastReceived;

    /* errors */
    error BalanceTooLow();
    error RequestedTooFrequently();
    error TransferFailed();

    function drip(address token) public {
        uint balance = ERC20(token).balanceOf(address(this));
        if (balance <= 0) revert BalanceTooLow();

        lastReceived[msg.sender][token] = block.timestamp;

        bool success = ERC20(token).transfer(msg.sender, balance / 10000); // 0.01%
        if (!success) revert TransferFailed();
    }
}
