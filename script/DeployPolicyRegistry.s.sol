// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {PolicyRegistry} from "../contracts/intents/PolicyRegistry.sol";
import {KeyHelper} from "./helpers/KeyHelper.sol";

contract DeployPolicyRegistry is Script, KeyHelper {
    function run() external {
        uint256 deployerPrivateKey = KeyHelper.getPrivateKey();
        vm.startBroadcast(deployerPrivateKey);

        PolicyRegistry registry = new PolicyRegistry();
        console.log("PolicyRegistry deployed at:", address(registry));
        console.log("Owner:", registry.owner());

        vm.stopBroadcast();
    }
}

