// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {BaseIntentValidator} from "../BaseIntentValidator.sol";
import {IntentTypes} from "../IntentTypes.sol";
import {PolicyRegistry} from "../PolicyRegistry.sol";
import {StatusCodes} from "../StatusCodes.sol";

/// @title SimpleSpendingValidator
/// @notice Example validator that relies on PolicyRegistry for target/value checks
contract SimpleSpendingValidator is BaseIntentValidator {
    constructor(PolicyRegistry registry) BaseIntentValidator(registry) {}

    /// @inheritdoc BaseIntentValidator
    function _checkFunds(IntentTypes.Intent calldata intent) internal view override returns (bytes1) {
        // For demo purposes, only check that the sender has enough native balance
        if (intent.value > 0 && intent.sender.balance < intent.value) {
            return StatusCodes.STATUS_INSUFFICIENT_FUNDS;
        }
        return StatusCodes.STATUS_SUCCESS;
    }
}
