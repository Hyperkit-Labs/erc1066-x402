// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {PolicyRegistry} from "../contracts/intents/PolicyRegistry.sol";
import {IntentTypes} from "../contracts/intents/IntentTypes.sol";
import {KeyHelper} from "../helpers/KeyHelper.sol";

contract CreatePolicy is Script, KeyHelper {
    function run() external {
        uint256 deployerPrivateKey = getPrivateKey();
        address registryAddress = vm.envAddress("POLICY_REGISTRY_ADDRESS");
        
        vm.startBroadcast(deployerPrivateKey);
        
        PolicyRegistry registry = PolicyRegistry(registryAddress);
        
        // Create a test policy
        bytes32 policyId = keccak256("test-policy-1");
        
        IntentTypes.Policy memory policy = IntentTypes.Policy({
            owner: vm.addr(deployerPrivateKey),
            allowedTargets: new address[](0), // Allow all targets
            allowedSelectors: new bytes4[](0), // Allow all selectors
            maxValuePerTx: 1 ether,
            maxAggregateValue: 10 ether,
            validAfter: 0,
            validBefore: type(uint256).max,
            allowedChains: new uint256[](0) // Allow all chains
        });
        
        registry.setPolicy(policyId, policy);
        console.log("Policy created with ID:", vm.toString(policyId));
        
        vm.stopBroadcast();
    }
}