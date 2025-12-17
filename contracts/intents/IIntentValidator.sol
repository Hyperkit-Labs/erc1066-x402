// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IntentTypes} from "./IntentTypes.sol";

/// @title IIntentValidator
/// @notice Standard interface for pre-flight intent validation
interface IIntentValidator {
    /// @notice Validate whether an intent can be executed
    /// @param intent The intent to validate
    /// @return status ERC-1066 style status code
    function canExecute(IntentTypes.Intent calldata intent) external view returns (bytes1 status);
}
