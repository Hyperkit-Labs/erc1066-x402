// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {IIntentValidator} from "../contracts/intents/IIntentValidator.sol";
import {IntentExecutor} from "../contracts/intents/IntentExecutor.sol";
import {KeyHelper} from "./helpers/KeyHelper.sol";

contract DeployExecutor is Script, KeyHelper {
    function run() external {
        uint256 deployerPrivateKey = KeyHelper.getPrivateKey();
        address validatorAddress = vm.envAddress("VALIDATOR_ADDRESS");
        vm.startBroadcast(deployerPrivateKey);

        IIntentValidator validator = IIntentValidator(validatorAddress);
        IntentExecutor executor = new IntentExecutor(validator);
        console.log("IntentExecutor deployed at:", address(executor));
        console.log("Validator:", address(validator));

        vm.stopBroadcast();
    }
}

