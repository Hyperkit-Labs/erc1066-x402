// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IIntentValidator} from "./IIntentValidator.sol";
import {IntentTypes} from "./IntentTypes.sol";
import {PolicyRegistry} from "./PolicyRegistry.sol";
import {StatusCodes} from "./StatusCodes.sol";

/// @title BaseIntentValidator
/// @notice Abstract base implementing common checks for intent validation
abstract contract BaseIntentValidator is IIntentValidator {
    PolicyRegistry public immutable policyRegistry;

    constructor(PolicyRegistry _policyRegistry) {
        policyRegistry = _policyRegistry;
    }

    /// @inheritdoc IIntentValidator
    function canExecute(IntentTypes.Intent calldata intent) public view virtual override returns (bytes1) {
        // Time window check
        if (intent.validAfter != 0 && block.timestamp < intent.validAfter) {
            return StatusCodes.STATUS_TOO_EARLY;
        }
        if (intent.validBefore != 0 && block.timestamp > intent.validBefore) {
            return StatusCodes.STATUS_TOO_LATE;
        }

        // Policy check
        bytes1 policyStatus = _checkPolicy(intent);
        if (!StatusCodes.isSuccess(policyStatus)) {
            return policyStatus;
        }

        // Funds check
        bytes1 fundsStatus = _checkFunds(intent);
        if (!StatusCodes.isSuccess(fundsStatus)) {
            return fundsStatus;
        }

        return StatusCodes.STATUS_SUCCESS;
    }

    /// @notice Policy-level checks, including allowed targets/selectors and value caps
    function _checkPolicy(IntentTypes.Intent calldata intent) internal view virtual returns (bytes1) {
        if (intent.policyId == bytes32(0)) {
            // No policy means disallowed by default
            return StatusCodes.STATUS_DISALLOWED;
        }

        IntentTypes.Policy memory policy = policyRegistry.getPolicy(intent.policyId);

        // Time window at policy level (optional)
        if (policy.validAfter != 0 && block.timestamp < policy.validAfter) {
            return StatusCodes.STATUS_TOO_EARLY;
        }
        if (policy.validBefore != 0 && block.timestamp > policy.validBefore) {
            return StatusCodes.STATUS_TOO_LATE;
        }

        // Chain ID check (if configured)
        if (policy.allowedChains.length > 0) {
            bool chainAllowed = false;
            uint256 currentChainId;
            assembly {
                currentChainId := chainid()
            }
            for (uint256 i = 0; i < policy.allowedChains.length; i++) {
                if (policy.allowedChains[i] == currentChainId) {
                    chainAllowed = true;
                    break;
                }
            }
            if (!chainAllowed) {
                return StatusCodes.STATUS_UNSUPPORTED_CHAIN;
            }
        }

        // Target check
        if (policy.allowedTargets.length > 0) {
            bool targetAllowed = false;
            for (uint256 i = 0; i < policy.allowedTargets.length; i++) {
                if (policy.allowedTargets[i] == intent.target) {
                    targetAllowed = true;
                    break;
                }
            }
            if (!targetAllowed) {
                return StatusCodes.STATUS_DISALLOWED;
            }
        }

        // Selector check (if any)
        if (policy.allowedSelectors.length > 0 && intent.data.length >= 4) {
            bytes4 selector;
            // read first 4 bytes of calldata for intent.data
            assembly {
                selector := calldataload(intent.data.offset)
            }

            bool selectorAllowed = false;
            for (uint256 i = 0; i < policy.allowedSelectors.length; i++) {
                if (policy.allowedSelectors[i] == selector) {
                    selectorAllowed = true;
                    break;
                }
            }

            if (!selectorAllowed) {
                return StatusCodes.STATUS_DISALLOWED;
            }
        }

        // Value caps
        if (policy.maxValuePerTx != 0 && intent.value > policy.maxValuePerTx) {
            // Treat as insufficient funds / limit exceeded
            return StatusCodes.STATUS_INSUFFICIENT_FUNDS;
        }

        return StatusCodes.STATUS_ALLOWED;
    }

    /// @notice Funds-related checks, default implementation returns success
    /// @dev Override in concrete validators to perform balance/allowance checks
    function _checkFunds(IntentTypes.Intent calldata /*intent*/) internal view virtual returns (bytes1) {
        return StatusCodes.STATUS_SUCCESS;
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