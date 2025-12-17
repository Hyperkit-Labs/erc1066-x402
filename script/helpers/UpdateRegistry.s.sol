// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {PolicyRegistry} from "../../contracts/intents/PolicyRegistry.sol";
import {SimpleSpendingValidator} from "../../contracts/intents/validators/SimpleSpendingValidator.sol";
import {IntentExecutor} from "../../contracts/intents/IntentExecutor.sol";
import {KeyHelper} from "../helpers/KeyHelper.sol";

/// @notice Helper script to deploy and output addresses in JSON format for registry
contract UpdateRegistry is Script, KeyHelper {
    function run() external {
        uint256 deployerPrivateKey = KeyHelper.getPrivateKey();
        vm.startBroadcast(deployerPrivateKey);

        PolicyRegistry registry = new PolicyRegistry();
        SimpleSpendingValidator validator = new SimpleSpendingValidator(registry);
        IntentExecutor executor = new IntentExecutor(validator);

        console.log("=== DEPLOYMENT ADDRESSES ===");
        console.log("Chain ID:", block.chainid);
        console.log("PolicyRegistry:", address(registry));
        console.log("SimpleSpendingValidator:", address(validator));
        console.log("IntentExecutor:", address(executor));
        console.log("\n=== JSON FOR REGISTRY ===");
        console.log("{");
        console.log('  "', block.chainid, '": {');
        console.log('    "chainId": ', block.chainid, ',');
        console.log('    "name": "Chain ', block.chainid, '",');
        console.log('    "policyRegistry": "', vm.toString(address(registry)), '",');
        console.log('    "validator": "', vm.toString(address(validator)), '",');
        console.log('    "executor": "', vm.toString(address(executor)), '"');
        console.log("  }");
        console.log("}");

        vm.stopBroadcast();
    }
}

