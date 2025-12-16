// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {IIntentValidator} from "./IIntentValidator.sol";
import {IntentTypes} from "./IntentTypes.sol";
import {StatusCodes} from "./StatusCodes.sol";

/// @title IntentExecutor
/// @notice Executes intents through a pluggable validator and forwards calls on success
contract IntentExecutor is ReentrancyGuard {
    IIntentValidator public validator;

    error ExecutionDenied(bytes1 status);
    error ExecutionFailed(bytes1 status, bytes data);

    event IntentExecuted(
        bytes32 indexed intentHash,
        bytes1 status,
        address indexed executor,
        bytes returnData
    );

    constructor(IIntentValidator _validator) {
        validator = _validator;
    }

    /// @notice Set a new validator
    /// @dev In production this should be protected by governance/ownership
    function setValidator(IIntentValidator _validator) external {
        validator = _validator;
    }

    /// @notice Execute an intent if the validator returns a success status
    /// @param intent The intent to execute
    /// @return returnData Return data from the target call
    function execute(IntentTypes.Intent calldata intent)
        external
        payable
        nonReentrant
        returns (bytes memory returnData)
    {
        bytes32 intentHash = keccak256(abi.encode(intent));
        bytes1 status = validator.canExecute(intent);

        if (!StatusCodes.isSuccess(status)) {
            revert ExecutionDenied(status);
        }

        (bool ok, bytes memory ret) = intent.target.call{value: intent.value}(intent.data);
        if (!ok) {
            revert ExecutionFailed(StatusCodes.STATUS_TRANSFER_FAILED, ret);
        }

        emit IntentExecuted(intentHash, status, msg.sender, ret);
        return ret;
    }
}

{
  "cells": [],
  "metadata": {
    "language_info": {
      "name": "python"
    }
  },
  "nbformat": 4,
  "nbformat_minor": 2
}