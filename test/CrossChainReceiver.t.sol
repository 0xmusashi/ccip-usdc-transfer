// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {MockCCIPRouter} from "@chainlink/contracts-ccip/src/v0.8/ccip/test/mocks/MockRouter.sol";
import {BurnMintERC677} from "@chainlink/contracts-ccip/src/v0.8/shared/token/ERC677/BurnMintERC677.sol";
import {CrossChainReceiver} from "src/CrossChainReceiver.sol";
import {TransferUSDC} from "src/TransferUSDC.sol";
import {SwapTestnetUSDC} from "src/SwapTestnetUSDC.sol";
import {Test, console, Vm} from "forge-std/Test.sol";
import {MockERC20} from "./mocks/MockERC20.sol";
import {Fauceteer} from "./mocks/Fauceteer.sol";

contract CrossChainReceiverTest is Test {
    TransferUSDC public sender;
    CrossChainReceiver public receiver;
    MockCCIPRouter public router;
    BurnMintERC677 public link;
    SwapTestnetUSDC public swapContract;
    MockERC20 public usdc;
    MockERC20 public compUsdc;
    Fauceteer public fauceteer;

    uint64 public chainSelector = 16015286601757825753; // Sepolia Chain Selector
    uint256 public transferAmount = 1 ether; // 1 USDC;
    uint256 public allowanceAmount = 10 ether;
    uint256 public mintAmount = 1000 ether;

    function setUp() public {
        router = new MockCCIPRouter();
        link = new BurnMintERC677("ChainLink Token", "LINK", 18, 10 ** 27);
        usdc = new MockERC20();
        compUsdc = new MockERC20();
        fauceteer = new Fauceteer();
        // mint test compound usdc to fauceteer
        compUsdc.mint(address(fauceteer), mintAmount);
        swapContract = new SwapTestnetUSDC(
            address(usdc),
            address(compUsdc),
            address(fauceteer)
        );

        sender = new TransferUSDC(
            address(router),
            address(link),
            address(usdc)
        );

        receiver = new CrossChainReceiver(
            address(router),
            address(compUsdc),
            address(swapContract)
        );

        // config allowlist settings for testing cross-chain interactions
        sender.allowlistDestinationChain(chainSelector, true);
        receiver.allowlistSourceChain(chainSelector, true);
        receiver.allowlistSender(address(sender), true);

        usdc.approve(address(sender), allowanceAmount);
    }

    function test_transferUsdc() public {
        vm.recordLogs(); // Starts recording logs to capture events.
        sender.transferUsdc(
            chainSelector,
            address(receiver),
            transferAmount,
            500000 // A predefined gas limit for the transaction.
        );
        // Fetches recorded logs to check for specific events and their outcomes.
        Vm.Log[] memory logs = vm.getRecordedLogs();
        bytes32 msgExecutedSignature = keccak256(
            "MsgExecuted(bool,bytes,uint256)"
        );

        for (uint i = 0; i < logs.length; i++) {
            if (logs[i].topics[0] == msgExecutedSignature) {
                (, , uint256 gasUsed) = abi.decode(
                    logs[i].data,
                    (bool, bytes, uint256)
                );
                console.log("Gas used: %d", gasUsed);
            }
        }
    }
}
