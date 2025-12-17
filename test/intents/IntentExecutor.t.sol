// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {IntentExecutor} from "../../contracts/intents/IntentExecutor.sol";
import {IntentTypes} from "../../contracts/intents/IntentTypes.sol";
import {StatusCodes} from "../../contracts/intents/StatusCodes.sol";
import {MockValidator} from "../mocks/MockValidator.sol";
import {MockTarget} from "../mocks/MockTarget.sol";
import {TestHelpers} from "../utils/TestHelpers.sol";

contract IntentExecutorTest is Test {
    IntentExecutor public executor;
    MockValidator public validator;
    MockTarget public target;

    event IntentExecuted(
        bytes32 indexed intentHash,
        bytes1 status,
        address indexed executor,
        bytes returnData
    );

    function setUp() public {
        validator = new MockValidator(StatusCodes.STATUS_SUCCESS);
        executor = new IntentExecutor(validator);
        target = new MockTarget(false, hex"1234");
    }

    function test_execute_success() public {
        IntentTypes.Intent memory intent = TestHelpers.createIntent(
            address(0x1),
            address(target),
            "",
            100,
            0,
            0,
            0,
            bytes32(0)
        );

        bytes32 intentHash = TestHelpers.computeIntentHash(intent);

        vm.expectEmit(true, true, false, true);
        emit IntentExecuted(intentHash, StatusCodes.STATUS_SUCCESS, address(this), hex"1234");

        executor.execute{value: 100}(intent);
    }

    function test_execute_denied() public {
        validator.setReturnStatus(StatusCodes.STATUS_DISALLOWED);

        IntentTypes.Intent memory intent = TestHelpers.createIntent(
            address(0x1),
            address(target),
            "",
            0,
            0,
            0,
            0,
            bytes32(0)
        );

        vm.expectRevert(
            abi.encodeWithSelector(IntentExecutor.ExecutionDenied.selector, StatusCodes.STATUS_DISALLOWED)
        );
        executor.execute(intent);
    }

    function test_execute_transferFailed() public {
        target.setShouldRevert(true);

        IntentTypes.Intent memory intent = TestHelpers.createIntent(
            address(0x1),
            address(target),
            "",
            100,
            0,
            0,
            0,
            bytes32(0)
        );

        vm.expectRevert();
        executor.execute{value: 100}(intent);
    }

    function test_execute_withValue() public {
        IntentTypes.Intent memory intent = TestHelpers.createIntent(
            address(0x1),
            address(target),
            "",
            50,
            0,
            0,
            0,
            bytes32(0)
        );

        uint256 balanceBefore = address(target).balance;
        executor.execute{value: 50}(intent);
        uint256 balanceAfter = address(target).balance;

        assertEq(balanceAfter - balanceBefore, 50);
    }

    function test_execute_withData() public {
        bytes memory callData = abi.encodeWithSignature("setShouldRevert(bool)", true);
        IntentTypes.Intent memory intent = TestHelpers.createIntent(
            address(0x1),
            address(target),
            callData,
            0,
            0,
            0,
            0,
            bytes32(0)
        );

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

        IntentTypes.Intent memory intent = TestHelpers.createIntent(
            address(0x1),
            address(reentrantTarget),
            "",
            0,
            0,
            0,
            0,
            bytes32(0)
        );

        vm.expectRevert();
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
        IntentTypes.Intent memory intent = IntentTypes.Intent({
            sender: address(0x1),
            target: address(this),
            data: "",
            value: 0,
            nonce: 0,
            validAfter: 0,
            validBefore: 0,
            policyId: bytes32(0)
        });
        executor.execute(intent);
    }
}

