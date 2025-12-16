// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title IntentTypes
/// @notice Core structs for intents and policies used by the semantics layer
library IntentTypes {
    /// @notice Minimal onchain view of an intent
    struct Intent {
        address sender;      // original user / session key
        address target;      // contract to call
        bytes data;          // calldata for target
        uint256 value;       // msg.value or token value
        uint256 nonce;       // replay protection
        uint256 validAfter;  // earliest timestamp
        uint256 validBefore; // latest timestamp
        bytes32 policyId;    // reference to policy definition in PolicyRegistry
    }

    /// @notice Policy describing who may call what, where, and how much
    struct Policy {
        address owner;              // authority that controls the policy
        address[] allowedTargets;   // list of callable contracts
        bytes4[] allowedSelectors;  // optional restriction to specific function selectors
        uint256 maxValuePerTx;      // max value per execution
        uint256 maxAggregateValue;  // optional rolling cap per period
        uint256 validAfter;         // policy-level start time (0 = no lower bound)
        uint256 validBefore;        // policy-level end time (0 = no upper bound)
        uint256[] allowedChains;    // allowed chain IDs; empty = any
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