// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {PolicyRegistry} from "../../contracts/intents/PolicyRegistry.sol";
import {BaseIntentValidator} from "../../contracts/intents/BaseIntentValidator.sol";
import {IntentTypes} from "../../contracts/intents/IntentTypes.sol";
import {StatusCodes} from "../../contracts/intents/StatusCodes.sol";
import {TestHelpers} from "../utils/TestHelpers.sol";

contract ConcreteValidator is BaseIntentValidator {
    constructor(PolicyRegistry registry) BaseIntentValidator(registry) {}
}

contract BaseIntentValidatorTest is Test {
    PolicyRegistry public registry;
    ConcreteValidator public validator;
    address public owner;

    function setUp() public {
        owner = address(this);
        registry = new PolicyRegistry();
        validator = new ConcreteValidator(registry);
    }

    function test_canExecute_tooEarly() public {
        bytes32 policyId = keccak256("test-policy");
        IntentTypes.Policy memory policy = TestHelpers.createPolicyWithDefaults(owner);
        registry.setPolicy(policyId, policy);

        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(address(0x1), address(0x2), "", 0, 0, block.timestamp + 100, 0, policyId);

        bytes1 status = validator.canExecute(intent);
        assertEq(status, StatusCodes.STATUS_TOO_EARLY);
    }

    function test_canExecute_tooLate() public {
        bytes32 policyId = keccak256("test-policy");
        IntentTypes.Policy memory policy = TestHelpers.createPolicyWithDefaults(owner);
        registry.setPolicy(policyId, policy);

        // Set block.timestamp to a known value, then use a validBefore that's in the past
        vm.warp(100);
        uint256 pastTimestamp = 99; // Definitely less than block.timestamp (100)
        
        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(address(0x1), address(0x2), "", 0, 0, 0, pastTimestamp, policyId);

        bytes1 status = validator.canExecute(intent);
        assertEq(uint8(status), uint8(StatusCodes.STATUS_TOO_LATE));
    }

    function test_canExecute_noPolicy() public {
        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(address(0x1), address(0x2), "", 0, 0, 0, 0, bytes32(0));

        bytes1 status = validator.canExecute(intent);
        assertEq(status, StatusCodes.STATUS_DISALLOWED);
    }

    function test_canExecute_policyTimeWindow() public {
        bytes32 policyId = keccak256("test-policy");
        IntentTypes.Policy memory policy = TestHelpers.createPolicy(
            owner, new address[](0), new bytes4[](0), 0, 0, block.timestamp + 100, 0, new uint256[](0)
        );
        registry.setPolicy(policyId, policy);

        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(address(0x1), address(0x2), "", 0, 0, 0, 0, policyId);

        bytes1 status = validator.canExecute(intent);
        assertEq(status, StatusCodes.STATUS_TOO_EARLY);
    }

    function test_canExecute_targetNotAllowed() public {
        bytes32 policyId = keccak256("test-policy");
        address[] memory targets = new address[](1);
        targets[0] = address(0x3);

        IntentTypes.Policy memory policy =
            TestHelpers.createPolicy(owner, targets, new bytes4[](0), 0, 0, 0, 0, new uint256[](0));
        registry.setPolicy(policyId, policy);

        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(address(0x1), address(0x2), "", 0, 0, 0, 0, policyId);

        bytes1 status = validator.canExecute(intent);
        assertEq(status, StatusCodes.STATUS_DISALLOWED);
    }

    function test_canExecute_targetAllowed() public {
        bytes32 policyId = keccak256("test-policy");
        address[] memory targets = new address[](1);
        targets[0] = address(0x2);

        IntentTypes.Policy memory policy =
            TestHelpers.createPolicy(owner, targets, new bytes4[](0), 0, 0, 0, 0, new uint256[](0));
        registry.setPolicy(policyId, policy);

        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(address(0x1), address(0x2), "", 0, 0, 0, 0, policyId);

        bytes1 status = validator.canExecute(intent);
        assertEq(status, StatusCodes.STATUS_SUCCESS);
    }

    function test_canExecute_selectorNotAllowed() public {
        bytes32 policyId = keccak256("test-policy");
        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = bytes4(0x12345678);

        IntentTypes.Policy memory policy =
            TestHelpers.createPolicy(owner, new address[](0), selectors, 0, 0, 0, 0, new uint256[](0));
        registry.setPolicy(policyId, policy);

        bytes memory data = abi.encodeWithSelector(bytes4(0x87654321));
        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(address(0x1), address(0x2), data, 0, 0, 0, 0, policyId);

        bytes1 status = validator.canExecute(intent);
        assertEq(status, StatusCodes.STATUS_DISALLOWED);
    }

    function test_canExecute_valueExceedsMax() public {
        bytes32 policyId = keccak256("test-policy");
        IntentTypes.Policy memory policy =
            TestHelpers.createPolicy(owner, new address[](0), new bytes4[](0), 100, 0, 0, 0, new uint256[](0));
        registry.setPolicy(policyId, policy);

        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(address(0x1), address(0x2), "", 200, 0, 0, 0, policyId);

        bytes1 status = validator.canExecute(intent);
        assertEq(status, StatusCodes.STATUS_INSUFFICIENT_FUNDS);
    }

    function test_canExecute_chainNotAllowed() public {
        bytes32 policyId = keccak256("test-policy");
        uint256[] memory chains = new uint256[](1);
        chains[0] = 999;

        IntentTypes.Policy memory policy =
            TestHelpers.createPolicy(owner, new address[](0), new bytes4[](0), 0, 0, 0, 0, chains);
        registry.setPolicy(policyId, policy);

        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(address(0x1), address(0x2), "", 0, 0, 0, 0, policyId);

        bytes1 status = validator.canExecute(intent);
        assertEq(status, StatusCodes.STATUS_UNSUPPORTED_CHAIN);
    }

    function test_canExecute_success() public {
        bytes32 policyId = keccak256("test-policy");
        IntentTypes.Policy memory policy = TestHelpers.createPolicyWithDefaults(owner);
        registry.setPolicy(policyId, policy);

        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(address(0x1), address(0x2), "", 0, 0, 0, 0, policyId);

        bytes1 status = validator.canExecute(intent);
        assertEq(status, StatusCodes.STATUS_SUCCESS);
    }
}

