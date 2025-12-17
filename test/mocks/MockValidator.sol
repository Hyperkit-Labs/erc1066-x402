// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IIntentValidator} from "../../contracts/intents/IIntentValidator.sol";
import {IntentTypes} from "../../contracts/intents/IntentTypes.sol";
import {StatusCodes} from "../../contracts/intents/StatusCodes.sol";

contract MockValidator is IIntentValidator {
    bytes1 public returnStatus;

    constructor(bytes1 _returnStatus) {
        returnStatus = _returnStatus;
    }

    function setReturnStatus(bytes1 _returnStatus) external {
        returnStatus = _returnStatus;
    }

    function canExecute(IntentTypes.Intent calldata) external view override returns (bytes1) {
        return returnStatus;
    }
}

