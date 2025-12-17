// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";

contract VerifyHyperion is Script {
    function run() external {
        // Note: forge verify-contract must be run manually with proper flags
        // This script is for reference only
        
        console.log("To verify contracts, run:");
        console.log("");
        console.log("1. PolicyRegistry:");
        console.log("forge verify-contract \\");
        console.log("  --rpc-url https://hyperion-testnet.metisdevops.link \\");
        console.log("  --verifier blockscout \\");
        console.log("  --verifier-url 'https://hyperion-testnet-explorer-api.metisdevops.link/api/' \\");
        console.log("  0x92C73F9f972Bb0bdC8e3c5411345695F2E3710D0 \\");
        console.log("  contracts/intents/PolicyRegistry.sol:PolicyRegistry");
        console.log("");
        console.log("2. SimpleSpendingValidator:");
        console.log("forge verify-contract \\");
        console.log("  --rpc-url https://hyperion-testnet.metisdevops.link \\");
        console.log("  --verifier blockscout \\");
        console.log("  --verifier-url 'https://hyperion-testnet-explorer-api.metisdevops.link/api/' \\");
        console.log("  0xE754b6Ce911511A0D7b3A5d2d367dB305B7a7f24 \\");
        console.log("  contracts/intents/validators/SimpleSpendingValidator.sol:SimpleSpendingValidator \\");
        console.log("  --constructor-args $(cast abi-encode 'constructor(address)' 0x92C73F9f972Bb0bdC8e3c5411345695F2E3710D0)");
        console.log("");
        console.log("3. IntentExecutor:");
        console.log("forge verify-contract \\");
        console.log("  --rpc-url https://hyperion-testnet.metisdevops.link \\");
        console.log("  --verifier blockscout \\");
        console.log("  --verifier-url 'https://hyperion-testnet-explorer-api.metisdevops.link/api/' \\");
        console.log("  0xb078FaFE12dd9A9F2429b921Fe0fF5365AbA3cF7 \\");
        console.log("  contracts/intents/IntentExecutor.sol:IntentExecutor \\");
        console.log("  --constructor-args $(cast abi-encode 'constructor(address)' 0xE754b6Ce911511A0D7b3A5d2d367dB305B7a7f24)");
    }
}
