// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    uint256 constant INITIAL_SUPPLY = 1000000000000000000000000;

    constructor() ERC20("USDC", "USDC") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function mint(address to, uint256 value) public {
        _mint(to, value);
    }
}
