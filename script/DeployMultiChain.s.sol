// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {PolicyRegistry} from "../contracts/intents/PolicyRegistry.sol";
import {SimpleSpendingValidator} from "../contracts/intents/validators/SimpleSpendingValidator.sol";
import {IntentExecutor} from "../contracts/intents/IntentExecutor.sol";
import {DeploymentConfig} from "./helpers/DeploymentConfig.sol";
import {KeyHelper} from "./helpers/KeyHelper.sol";

/// @notice Deploy to multiple testnets
/// @dev Run this script separately for each chain with the appropriate --rpc-url flag
/// Example: forge script script/DeployMultiChain.s.sol:DeployMultiChain --rpc-url hyperion_testnet --broadcast
contract DeployMultiChain is Script, KeyHelper {
    struct Deployment {
        uint256 chainId;
        address policyRegistry;
        address validator;
        address executor;
    }

    function run() external {
        uint256 deployerPrivateKey = KeyHelper.getPrivateKey();
        vm.startBroadcast(deployerPrivateKey);

        Deployment[] memory deployments = new Deployment[](4);

        DeploymentConfig.ChainConfig memory hyperion = DeploymentConfig.getHyperionTestnet();
        deployments[0] = _deployChain(hyperion);

        DeploymentConfig.ChainConfig memory metisSepolia = DeploymentConfig.getMetisSepolia();
        deployments[1] = _deployChain(metisSepolia);

        DeploymentConfig.ChainConfig memory mantle = DeploymentConfig.getMantleTestnet();
        deployments[2] = _deployChain(mantle);

        DeploymentConfig.ChainConfig memory avalanche = DeploymentConfig.getAvalancheFuji();
        deployments[3] = _deployChain(avalanche);

        console.log("=== Multi-Chain Deployment Summary ===");
        for (uint256 i = 0; i < deployments.length; i++) {
            console.log("Chain ID:", deployments[i].chainId);
            console.log("PolicyRegistry:", deployments[i].policyRegistry);
            console.log("SimpleSpendingValidator:", deployments[i].validator);
            console.log("IntentExecutor:", deployments[i].executor);
        }

        vm.stopBroadcast();
    }

    function _deployChain(DeploymentConfig.ChainConfig memory config) internal returns (Deployment memory) {
        console.log("Deploying to chain ID:", config.chainId);

        PolicyRegistry registry = new PolicyRegistry();
        console.log("PolicyRegistry deployed at:", address(registry));

        SimpleSpendingValidator validator = new SimpleSpendingValidator(registry);
        console.log("SimpleSpendingValidator deployed at:", address(validator));

        IntentExecutor executor = new IntentExecutor(validator);
        console.log("IntentExecutor deployed at:", address(executor));

        return Deployment({
            chainId: config.chainId,
            policyRegistry: address(registry),
            validator: address(validator),
            executor: address(executor)
        });
    }
}

