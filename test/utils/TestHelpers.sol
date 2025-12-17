// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IntentTypes} from "../../contracts/intents/IntentTypes.sol";
import {StatusCodes} from "../../contracts/intents/StatusCodes.sol";

library TestHelpers {
    function createIntent(
        address sender,
        address target,
        bytes memory data,
        uint256 value,
        uint256 nonce,
        uint256 validAfter,
        uint256 validBefore,
        bytes32 policyId
    ) internal pure returns (IntentTypes.Intent memory) {
        return IntentTypes.Intent({
            sender: sender,
            target: target,
            data: data,
            value: value,
            nonce: nonce,
            validAfter: validAfter,
            validBefore: validBefore,
            policyId: policyId
        });
    }

    function createIntentWithDefaults(address sender, address target, bytes32 policyId)
        internal
        view
        returns (IntentTypes.Intent memory)
    {
        return createIntent(
            sender,
            target,
            "",
            0,
            0,
            0,
            0,
            policyId
        );
    }

    function createPolicy(
        address owner,
        address[] memory allowedTargets,
        bytes4[] memory allowedSelectors,
        uint256 maxValuePerTx,
        uint256 maxAggregateValue,
        uint256 validAfter,
        uint256 validBefore,
        uint256[] memory allowedChains
    ) internal pure returns (IntentTypes.Policy memory) {
        return IntentTypes.Policy({
            owner: owner,
            allowedTargets: allowedTargets,
            allowedSelectors: allowedSelectors,
            maxValuePerTx: maxValuePerTx,
            maxAggregateValue: maxAggregateValue,
            validAfter: validAfter,
            validBefore: validBefore,
            allowedChains: allowedChains
        });
    }

    function createPolicyWithDefaults(address owner) internal view returns (IntentTypes.Policy memory) {
        return createPolicy(owner, new address[](0), new bytes4[](0), 0, 0, 0, 0, new uint256[](0));
    }

    function computeIntentHash(IntentTypes.Intent memory intent) internal pure returns (bytes32) {
        return keccak256(abi.encode(intent));
    }
}

