// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {PolicyRegistry} from "../../contracts/intents/PolicyRegistry.sol";
import {SimpleSpendingValidator} from "../../contracts/intents/validators/SimpleSpendingValidator.sol";
import {IntentExecutor} from "../../contracts/intents/IntentExecutor.sol";
import {IntentTypes} from "../../contracts/intents/IntentTypes.sol";
import {StatusCodes} from "../../contracts/intents/StatusCodes.sol";
import {TestHelpers} from "../utils/TestHelpers.sol";

contract SimpleSpendingValidatorTest is Test {
    PolicyRegistry public registry;
    SimpleSpendingValidator public validator;
    IntentExecutor public executor;
    address public owner;
    address public sender;

    function setUp() public {
        owner = address(this);
        sender = address(0x1);
        registry = new PolicyRegistry();
        validator = new SimpleSpendingValidator(registry);
        executor = new IntentExecutor(validator);
    }

    function test_checkFunds_sufficientBalance() public {
        bytes32 policyId = keccak256("test-policy");
        IntentTypes.Policy memory policy = TestHelpers.createPolicyWithDefaults(owner);
        registry.setPolicy(policyId, policy);

        vm.deal(sender, 100 ether);

        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(sender, address(0x2), "", 50 ether, 0, 0, 0, policyId);

        bytes1 status = validator.canExecute(intent);
        assertEq(status, StatusCodes.STATUS_SUCCESS);
    }

    function test_checkFunds_insufficientBalance() public {
        bytes32 policyId = keccak256("test-policy");
        IntentTypes.Policy memory policy = TestHelpers.createPolicyWithDefaults(owner);
        registry.setPolicy(policyId, policy);

        vm.deal(sender, 10 ether);

        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(sender, address(0x2), "", 50 ether, 0, 0, 0, policyId);

        bytes1 status = validator.canExecute(intent);
        assertEq(status, StatusCodes.STATUS_INSUFFICIENT_FUNDS);
    }

    function test_checkFunds_zeroValue() public {
        bytes32 policyId = keccak256("test-policy");
        IntentTypes.Policy memory policy = TestHelpers.createPolicyWithDefaults(owner);
        registry.setPolicy(policyId, policy);

        IntentTypes.Intent memory intent = TestHelpers.createIntent(sender, address(0x2), "", 0, 0, 0, 0, policyId);

        bytes1 status = validator.canExecute(intent);
        assertEq(status, StatusCodes.STATUS_SUCCESS);
    }

    function test_checkFunds_exactBalance() public {
        bytes32 policyId = keccak256("test-policy");
        IntentTypes.Policy memory policy = TestHelpers.createPolicyWithDefaults(owner);
        registry.setPolicy(policyId, policy);

        vm.deal(sender, 100 ether);

        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(sender, address(0x2), "", 100 ether, 0, 0, 0, policyId);

        bytes1 status = validator.canExecute(intent);
        assertEq(status, StatusCodes.STATUS_SUCCESS);
    }

    function test_integrationWithExecutor() public {
        bytes32 policyId = keccak256("test-policy");
        IntentTypes.Policy memory policy = TestHelpers.createPolicyWithDefaults(owner);
        registry.setPolicy(policyId, policy);

        vm.deal(sender, 100 ether);

        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(sender, address(0x2), "", 50 ether, 0, 0, 0, policyId);

        vm.prank(sender);
        executor.execute{value: 50 ether}(intent);
    }
}

