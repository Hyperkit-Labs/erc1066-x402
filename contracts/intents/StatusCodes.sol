// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title StatusCodes
/// @notice Canonical ERC-1066 / x402-style status codes for HyperKit intents
/// @dev Represented as bytes1 for compactness and easy mapping to x402/HTTP
library StatusCodes {
    // Generic
    bytes1 internal constant STATUS_FAILURE = 0x00; // Generic failure
    bytes1 internal constant STATUS_SUCCESS = 0x01; // Generic success

    // Authorization / Policy
    bytes1 internal constant STATUS_DISALLOWED = 0x10; // Policy or role denies
    bytes1 internal constant STATUS_ALLOWED = 0x11;    // Policy permits

    // Timing / State
    bytes1 internal constant STATUS_TOO_EARLY = 0x20; // Before start time / epoch
    bytes1 internal constant STATUS_TOO_LATE = 0x21;  // After deadline / expiry
    bytes1 internal constant STATUS_NONCE_USED = 0x22; // Nonce already used

    // Funds / Payment
    bytes1 internal constant STATUS_TRANSFER_FAILED = 0x50;
    bytes1 internal constant STATUS_TRANSFER_SUCCESS = 0x51;
    bytes1 internal constant STATUS_INSUFFICIENT_FUNDS = 0x54;

    // Application / Routing
    bytes1 internal constant STATUS_INTENT_INVALID_FORMAT = 0xA0;
    bytes1 internal constant STATUS_UNSUPPORTED_ACTION = 0xA1;
    bytes1 internal constant STATUS_UNSUPPORTED_CHAIN = 0xA2;

    /// @notice Returns true if the status represents success
    function isSuccess(bytes1 status) internal pure returns (bool) {
        return status == STATUS_SUCCESS
            || status == STATUS_ALLOWED
            || status == STATUS_TRANSFER_SUCCESS;
    }

    /// @notice Returns true if the status represents failure
    function isFailure(bytes1 status) internal pure returns (bool) {
        return !isSuccess(status);
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