// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {IntentTypes} from "../../contracts/intents/IntentTypes.sol";
import {TestHelpers} from "../utils/TestHelpers.sol";

contract IntentTypesTest is Test {
    using TestHelpers for IntentTypes.Intent;
    using TestHelpers for IntentTypes.Policy;

    function test_intentStructEncoding() public {
        IntentTypes.Intent memory intent = TestHelpers.createIntent(
            address(0x1),
            address(0x2),
            hex"1234",
            100,
            1,
            1000,
            2000,
            bytes32(uint256(0x123))
        );

        bytes memory encoded = abi.encode(intent);
        assertGt(encoded.length, 0);

        (IntentTypes.Intent memory decoded) = abi.decode(encoded, (IntentTypes.Intent));
        assertEq(decoded.sender, intent.sender);
        assertEq(decoded.target, intent.target);
        assertEq(decoded.value, intent.value);
        assertEq(decoded.nonce, intent.nonce);
        assertEq(decoded.validAfter, intent.validAfter);
        assertEq(decoded.validBefore, intent.validBefore);
        assertEq(decoded.policyId, intent.policyId);
    }

    function test_intentHashComputation() public {
        IntentTypes.Intent memory intent1 = TestHelpers.createIntent(
            address(0x1),
            address(0x2),
            hex"1234",
            100,
            1,
            1000,
            2000,
            bytes32(uint256(0x123))
        );

        IntentTypes.Intent memory intent2 = TestHelpers.createIntent(
            address(0x1),
            address(0x2),
            hex"1234",
            100,
            1,
            1000,
            2000,
            bytes32(uint256(0x123))
        );

        bytes32 hash1 = TestHelpers.computeIntentHash(intent1);
        bytes32 hash2 = TestHelpers.computeIntentHash(intent2);

        assertEq(hash1, hash2);
    }

    function test_intentHashUniqueness() public {
        IntentTypes.Intent memory intent1 = TestHelpers.createIntent(
            address(0x1),
            address(0x2),
            hex"1234",
            100,
            1,
            1000,
            2000,
            bytes32(uint256(0x123))
        );

        IntentTypes.Intent memory intent2 = TestHelpers.createIntent(
            address(0x1),
            address(0x2),
            hex"1234",
            101,
            1,
            1000,
            2000,
            bytes32(uint256(0x123))
        );

        bytes32 hash1 = TestHelpers.computeIntentHash(intent1);
        bytes32 hash2 = TestHelpers.computeIntentHash(intent2);

        assertNotEq(hash1, hash2);
    }

    function test_policyStructEncoding() public {
        address[] memory targets = new address[](2);
        targets[0] = address(0x1);
        targets[1] = address(0x2);

        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = bytes4(0x12345678);

        uint256[] memory chains = new uint256[](1);
        chains[0] = 1;

        IntentTypes.Policy memory policy = TestHelpers.createPolicy(
            address(0x3),
            targets,
            selectors,
            1000,
            10000,
            100,
            200,
            chains
        );

        bytes memory encoded = abi.encode(policy);
        assertGt(encoded.length, 0);

        (IntentTypes.Policy memory decoded) = abi.decode(encoded, (IntentTypes.Policy));
        assertEq(decoded.owner, policy.owner);
        assertEq(decoded.allowedTargets.length, policy.allowedTargets.length);
        assertEq(decoded.allowedSelectors.length, policy.allowedSelectors.length);
        assertEq(decoded.maxValuePerTx, policy.maxValuePerTx);
        assertEq(decoded.allowedChains.length, policy.allowedChains.length);
    }
}

