// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {PolicyRegistry} from "../contracts/intents/PolicyRegistry.sol";
import {SimpleSpendingValidator} from "../contracts/intents/validators/SimpleSpendingValidator.sol";
import {KeyHelper} from "./helpers/KeyHelper.sol";

contract DeployValidator is Script, KeyHelper {
    function run() external {
        uint256 deployerPrivateKey = KeyHelper.getPrivateKey();
        address policyRegistryAddress = vm.envAddress("POLICY_REGISTRY_ADDRESS");
        vm.startBroadcast(deployerPrivateKey);

        PolicyRegistry registry = PolicyRegistry(policyRegistryAddress);
        SimpleSpendingValidator validator = new SimpleSpendingValidator(registry);
        console.log("SimpleSpendingValidator deployed at:", address(validator));
        console.log("PolicyRegistry:", address(registry));

        vm.stopBroadcast();
    }
}

