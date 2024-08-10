// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {SwapTestnetUSDC} from "../src/SwapTestnetUSDC.sol";
import "./Helper.sol";

contract DeploySwapTestnetUSDC is Script, Helper {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address USDC_SEPOLIA_ADDRESS = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238;
        address COMPOUND_USDC_TOKEN = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238;
        address FAUCETEER = 0x68793eA49297eB75DFB4610B68e076D2A5c7646C;

        vm.startBroadcast(deployerPrivateKey);

        SwapTestnetUSDC swapContract = new SwapTestnetUSDC(
            USDC_SEPOLIA_ADDRESS,
            COMPOUND_USDC_TOKEN,
            FAUCETEER
        );

        console.log(
            "SwapTestnetUSDC contract deployed to ",
            address(swapContract)
        );

        vm.stopBroadcast();
    }
}
/* 
forge script script/DeploySwapTestnetUSDC.sol -vvv --broadcast --rpc-url ethereumSepolia
*/
