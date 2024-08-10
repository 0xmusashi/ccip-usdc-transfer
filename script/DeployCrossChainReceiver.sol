// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {CrossChainReceiver} from "../src/CrossChainReceiver.sol";
import "./Helper.sol";

contract DeployCrossChainReceiver is Script, Helper {
    function run(
        SupportedNetworks network,
        address swapContractAddress
    ) public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address COMET_ADDRESS = 0xAec1F48e02Cfb822Be958B68C7957156EB3F0b6e;
        vm.startBroadcast(deployerPrivateKey);

        (address routerAddress, , , ) = getConfigFromNetwork(network);

        CrossChainReceiver crossChainReceiver = new CrossChainReceiver(
            routerAddress,
            COMET_ADDRESS,
            swapContractAddress
        );

        console.log(
            "CrossChainReceiver contract deployed to ",
            address(crossChainReceiver)
        );

        vm.stopBroadcast();
    }
}
/**
export transferUsdc=0xa221d1f02c095F4a8f9bdc5A0Dc191D5Caafd0fe
export swapContract=0x67B80092b86d313Bd84583ED19a979dc35036d13
forge script script/DeployCrossChainReceiver.sol -vvv --broadcast --rpc-url ethereumSepolia --sig "run(uint8,address)" -- 0 $swapContract
export crossChainReceiver=0xF65714d49D5497104A0e6Ed28220F7364069831d
export account=0x7bB341488d5E6838Bb9C1fD521543f83066Dc9Bd
cast send $crossChainReceiver "allowlistSourceChain(uint64,bool)" 14767482510784806043 true --rpc-url ethereumSepolia --private-key $PRIVATE_KEY
cast send $crossChainReceiver "allowlistSender(address,bool)" $transferUsdc true --rpc-url ethereumSepolia --private-key $PRIVATE_KEY
cast send $usdc "approve(address,uint256)" $transferUsdc 10000000 --rpc-url avalancheFuji --private-key $PRIVATE_KEY
cast call $usdc "allowance(address,address)" $account $transferUsdc --rpc-url avalancheFuji
export gasLimit=366000
cast send $transferUsdc "transferUsdc(uint64,address,uint256,uint64)" 16015286601757825753 $crossChainReceiver 100000 $gasLimit --rpc-url avalancheFuji --private-key $PRIVATE_KEY
 */
