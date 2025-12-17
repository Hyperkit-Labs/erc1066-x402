// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IntentTypes} from "./IntentTypes.sol";

/// @title PolicyRegistry
/// @notice Stores versioned policies referenced by intents
contract PolicyRegistry is Ownable {
    constructor() Ownable(msg.sender) {}

    /// @dev Mapping from policyId to Policy data
    mapping(bytes32 => IntentTypes.Policy) private _policies;

    /// @dev Tracks whether a policyId has been set (to enforce immutability)
    mapping(bytes32 => bool) private _policyExists;

    event PolicySet(bytes32 indexed policyId, address indexed setter);

    error PolicyAlreadyExists(bytes32 policyId);
    error PolicyNotFound(bytes32 policyId);

    /// @notice Set a new policy; policies are immutable per policyId
    /// @param policyId Unique identifier for the policy
    /// @param policy Policy data
    function setPolicy(bytes32 policyId, IntentTypes.Policy calldata policy) external onlyOwner {
        if (_policyExists[policyId]) {
            revert PolicyAlreadyExists(policyId);
        }

        _policies[policyId] = policy;
        _policyExists[policyId] = true;

        emit PolicySet(policyId, _msgSender());
    }

    /// @notice Get a policy by id
    /// @param policyId Policy identifier
    /// @return policy Policy data
    function getPolicy(bytes32 policyId) external view returns (IntentTypes.Policy memory policy) {
        if (!_policyExists[policyId]) {
            revert PolicyNotFound(policyId);
        }
        return _policies[policyId];
    }

    /// @notice Check if a policy exists
    function policyExists(bytes32 policyId) external view returns (bool) {
        return _policyExists[policyId];
    }
}