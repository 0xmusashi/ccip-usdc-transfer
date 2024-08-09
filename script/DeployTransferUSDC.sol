// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {TransferUSDC} from "../src/TransferUSDC.sol";
import "./Helper.sol";

contract DeployTransferUSDC is Script, Helper {
    function run(SupportedNetworks network) public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        (
            address routerAddress,
            address linkTokenAddress,
            ,

        ) = getConfigFromNetwork(network);

        address usdcAddress = getUsdcAddressFromNetwork(network);

        TransferUSDC transferUSDC = new TransferUSDC(
            routerAddress,
            linkTokenAddress,
            usdcAddress
        );

        console.log(
            "TransferUSDC contract deployed to ",
            address(transferUSDC)
        );

        vm.stopBroadcast();
    }
}
/**
forge script script/DeployTransferUSDC.sol -vvv --broadcast --rpc-url avalancheFuji --sig "run(uint8)" -- 1
export transferUsdc=0xa221d1f02c095F4a8f9bdc5A0Dc191D5Caafd0fe
export account=0x7bB341488d5E6838Bb9C1fD521543f83066Dc9Bd
cast send $transferUsdc "allowlistDestinationChain(uint64,bool)" 16015286601757825753 true --rpc-url avalancheFuji --private-key $PRIVATE_KEY
export usdc=0x5425890298aed601595a70AB815c96711a31Bc65
cast send $usdc "approve(address,uint256)" $transferUsdc 1000000 --rpc-url avalancheFuji --private-key $PRIVATE_KEY
cast call $usdc "allowance(address,address)" $account $transferUsdc --rpc-url avalancheFuji
cast send $transferUsdc "transferUsdc(uint64,address,uint256,uint64)" 16015286601757825753 $account 1000000 0 --rpc-url avalancheFuji --private-key $PRIVATE_KEY
 */
