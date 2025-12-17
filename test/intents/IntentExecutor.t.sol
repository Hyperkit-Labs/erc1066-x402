// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {IntentExecutor} from "../../contracts/intents/IntentExecutor.sol";
import {IntentTypes} from "../../contracts/intents/IntentTypes.sol";
import {StatusCodes} from "../../contracts/intents/StatusCodes.sol";
import {MockValidator} from "../mocks/MockValidator.sol";
import {MockTarget} from "../mocks/MockTarget.sol";
import {TestHelpers} from "../utils/TestHelpers.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract IntentExecutorTest is Test {
    IntentExecutor public executor;
    MockValidator public validator;
    MockTarget public target;

    event IntentExecuted(bytes32 indexed intentHash, bytes1 status, address indexed executor, bytes returnData);

    function setUp() public {
        validator = new MockValidator(StatusCodes.STATUS_SUCCESS);
        executor = new IntentExecutor(validator);
        target = new MockTarget(false, hex"1234");
    }

    function test_execute_success() public {
        // Use non-empty data to trigger fallback which returns hex"1234"
        bytes memory callData = abi.encodeWithSignature("nonExistentFunction()");
        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(address(0x1), address(target), callData, 100, 0, 0, 0, bytes32(0));

        bytes32 intentHash = TestHelpers.computeIntentHash(intent);

        vm.expectEmit(true, true, false, false);
        emit IntentExecuted(intentHash, StatusCodes.STATUS_SUCCESS, address(this), hex"1234");

        executor.execute{value: 100}(intent);
    }

    function test_execute_denied() public {
        validator.setReturnStatus(StatusCodes.STATUS_DISALLOWED);

        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(address(0x1), address(target), "", 0, 0, 0, 0, bytes32(0));

        vm.expectRevert(abi.encodeWithSelector(IntentExecutor.ExecutionDenied.selector, StatusCodes.STATUS_DISALLOWED));
        executor.execute(intent);
    }

    function test_execute_transferFailed() public {
        target.setShouldRevert(true);

        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(address(0x1), address(target), "", 100, 0, 0, 0, bytes32(0));

        vm.expectRevert();
        executor.execute{value: 100}(intent);
    }

    function test_execute_withValue() public {
        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(address(0x1), address(target), "", 50, 0, 0, 0, bytes32(0));

        uint256 balanceBefore = address(target).balance;
        executor.execute{value: 50}(intent);
        uint256 balanceAfter = address(target).balance;

        assertEq(balanceAfter - balanceBefore, 50);
    }

    function test_execute_withData() public {
        bytes memory callData = abi.encodeWithSignature("setShouldRevert(bool)", true);
        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(address(0x1), address(target), callData, 0, 0, 0, 0, bytes32(0));

        executor.execute(intent);
        assertTrue(target.shouldRevert());
    }

    function test_setValidator() public {
        MockValidator newValidator = new MockValidator(StatusCodes.STATUS_SUCCESS);
        executor.setValidator(newValidator);
        assertEq(address(executor.validator()), address(newValidator));
    }

    function test_execute_reentrancyProtection() public {
        ReentrantTarget reentrantTarget = new ReentrantTarget(executor);
        validator.setReturnStatus(StatusCodes.STATUS_SUCCESS);

        // Use non-empty data to ensure fallback is triggered (not receive)
        bytes memory callData = abi.encodeWithSignature("nonExistentFunction()");
        IntentTypes.Intent memory intent =
            TestHelpers.createIntent(address(0x1), address(reentrantTarget), callData, 0, 0, 0, 0, bytes32(0));

        // When reentrancy occurs, the reentrant call reverts with ReentrancyGuardReentrantCall,
        // which is caught by the call() and wrapped as ExecutionFailed
        // The outer call should fail with ExecutionFailed
        // For errors with dynamic bytes, we need to encode manually
        bytes memory reentrancyErrorData = abi.encodeWithSelector(ReentrancyGuard.ReentrancyGuardReentrantCall.selector);
        bytes memory expectedError = abi.encodeWithSelector(
            IntentExecutor.ExecutionFailed.selector,
            StatusCodes.STATUS_TRANSFER_FAILED,
            reentrancyErrorData
        );
        vm.expectRevert(expectedError);
        executor.execute(intent);
    }
}

contract ReentrantTarget {
    IntentExecutor public executor;

    constructor(IntentExecutor _executor) {
        executor = _executor;
    }

    receive() external payable {}

    fallback() external payable {
        // Create a new intent that will trigger reentrancy
        // Use non-empty data to ensure fallback is triggered
        bytes memory callData = abi.encodeWithSignature("anotherNonExistentFunction()");
        IntentTypes.Intent memory intent = IntentTypes.Intent({
            sender: address(0x1),
            target: address(this),
            data: callData,
            value: 0,
            nonce: 0,
            validAfter: 0,
            validBefore: 0,
            policyId: bytes32(0)
        });
        // This should revert due to reentrancy guard
        executor.execute(intent);
    }
}

