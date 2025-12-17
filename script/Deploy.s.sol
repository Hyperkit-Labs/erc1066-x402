// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {PolicyRegistry} from "../contracts/intents/PolicyRegistry.sol";
import {SimpleSpendingValidator} from "../contracts/intents/validators/SimpleSpendingValidator.sol";
import {IntentExecutor} from "../contracts/intents/IntentExecutor.sol";
import {KeyHelper} from "./helpers/KeyHelper.sol";

contract Deploy is Script, KeyHelper {
    function run() external {
        uint256 deployerPrivateKey = KeyHelper.getPrivateKey();
        vm.startBroadcast(deployerPrivateKey);

        console.log("Deploying ERC-1066-x402 contracts...");
        console.log("Deployer:", vm.addr(deployerPrivateKey));

        PolicyRegistry registry = new PolicyRegistry();
        console.log("PolicyRegistry deployed at:", address(registry));

        SimpleSpendingValidator validator = new SimpleSpendingValidator(registry);
        console.log("SimpleSpendingValidator deployed at:", address(validator));

        IntentExecutor executor = new IntentExecutor(validator);
        console.log("IntentExecutor deployed at:", address(executor));

        console.log("\n=== Deployment Summary ===");
        console.log("PolicyRegistry:", address(registry));
        console.log("SimpleSpendingValidator:", address(validator));
        console.log("IntentExecutor:", address(executor));
        console.log("Chain ID:", block.chainid);

        vm.stopBroadcast();
    }
}

