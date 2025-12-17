// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {PolicyRegistry} from "../../contracts/intents/PolicyRegistry.sol";
import {IntentTypes} from "../../contracts/intents/IntentTypes.sol";
import {TestHelpers} from "../utils/TestHelpers.sol";

contract PolicyRegistryTest is Test {
    PolicyRegistry public registry;
    address public owner;

    event PolicySet(bytes32 indexed policyId, address indexed setter);

    function setUp() public {
        owner = address(this);
        registry = new PolicyRegistry();
    }

    function test_setPolicy_success() public {
        bytes32 policyId = keccak256("test-policy");
        IntentTypes.Policy memory policy = TestHelpers.createPolicyWithDefaults(owner);

        vm.expectEmit(true, true, false, false);
        emit PolicySet(policyId, owner);

        registry.setPolicy(policyId, policy);
        assertTrue(registry.policyExists(policyId));
    }

    function test_setPolicy_immutability() public {
        bytes32 policyId = keccak256("test-policy");
        IntentTypes.Policy memory policy1 = TestHelpers.createPolicyWithDefaults(owner);
        IntentTypes.Policy memory policy2 = TestHelpers.createPolicy(owner, new address[](0), new bytes4[](0), 100, 0, 0, 0, new uint256[](0));

        registry.setPolicy(policyId, policy1);

        vm.expectRevert(abi.encodeWithSelector(PolicyRegistry.PolicyAlreadyExists.selector, policyId));
        registry.setPolicy(policyId, policy2);
    }

    function test_getPolicy_success() public {
        bytes32 policyId = keccak256("test-policy");
        address[] memory targets = new address[](1);
        targets[0] = address(0x1);

        IntentTypes.Policy memory policy = TestHelpers.createPolicy(
            owner,
            targets,
            new bytes4[](0),
            1000,
            0,
            0,
            0,
            new uint256[](0)
        );

        registry.setPolicy(policyId, policy);
        IntentTypes.Policy memory retrieved = registry.getPolicy(policyId);

        assertEq(retrieved.owner, policy.owner);
        assertEq(retrieved.allowedTargets.length, policy.allowedTargets.length);
        assertEq(retrieved.allowedTargets[0], policy.allowedTargets[0]);
        assertEq(retrieved.maxValuePerTx, policy.maxValuePerTx);
    }

    function test_getPolicy_notFound() public {
        bytes32 policyId = keccak256("non-existent");

        vm.expectRevert(abi.encodeWithSelector(PolicyRegistry.PolicyNotFound.selector, policyId));
        registry.getPolicy(policyId);
    }

    function test_policyExists_false() public {
        bytes32 policyId = keccak256("non-existent");
        assertFalse(registry.policyExists(policyId));
    }

    function test_policyExists_true() public {
        bytes32 policyId = keccak256("test-policy");
        IntentTypes.Policy memory policy = TestHelpers.createPolicyWithDefaults(owner);

        registry.setPolicy(policyId, policy);
        assertTrue(registry.policyExists(policyId));
    }

    function test_setPolicy_onlyOwner() public {
        bytes32 policyId = keccak256("test-policy");
        IntentTypes.Policy memory policy = TestHelpers.createPolicyWithDefaults(owner);
        address newOwner = address(0x999);

        registry.transferOwnership(newOwner);

        vm.prank(newOwner);
        registry.setPolicy(policyId, policy);
        assertTrue(registry.policyExists(policyId));
    }

    function test_setPolicy_notOwner() public {
        bytes32 policyId = keccak256("test-policy");
        IntentTypes.Policy memory policy = TestHelpers.createPolicyWithDefaults(owner);
        address attacker = address(0x999);

        vm.prank(attacker);
        vm.expectRevert();
        registry.setPolicy(policyId, policy);
    }
}

