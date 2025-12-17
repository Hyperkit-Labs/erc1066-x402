// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {StatusCodes} from "../../contracts/intents/StatusCodes.sol";

contract StatusCodesTest is Test {
    function test_isSuccess_returnsTrueForSuccessCodes() public {
        assertTrue(StatusCodes.isSuccess(StatusCodes.STATUS_SUCCESS));
        assertTrue(StatusCodes.isSuccess(StatusCodes.STATUS_ALLOWED));
        assertTrue(StatusCodes.isSuccess(StatusCodes.STATUS_TRANSFER_SUCCESS));
    }

    function test_isSuccess_returnsFalseForFailureCodes() public {
        assertFalse(StatusCodes.isSuccess(StatusCodes.STATUS_FAILURE));
        assertFalse(StatusCodes.isSuccess(StatusCodes.STATUS_DISALLOWED));
        assertFalse(StatusCodes.isSuccess(StatusCodes.STATUS_INSUFFICIENT_FUNDS));
        assertFalse(StatusCodes.isSuccess(StatusCodes.STATUS_TOO_EARLY));
        assertFalse(StatusCodes.isSuccess(StatusCodes.STATUS_TOO_LATE));
        assertFalse(StatusCodes.isSuccess(StatusCodes.STATUS_NONCE_USED));
        assertFalse(StatusCodes.isSuccess(StatusCodes.STATUS_TRANSFER_FAILED));
        assertFalse(StatusCodes.isSuccess(StatusCodes.STATUS_INTENT_INVALID_FORMAT));
        assertFalse(StatusCodes.isSuccess(StatusCodes.STATUS_UNSUPPORTED_ACTION));
        assertFalse(StatusCodes.isSuccess(StatusCodes.STATUS_UNSUPPORTED_CHAIN));
    }

    function test_isFailure_inverseOfIsSuccess() public {
        assertTrue(StatusCodes.isFailure(StatusCodes.STATUS_FAILURE));
        assertFalse(StatusCodes.isFailure(StatusCodes.STATUS_SUCCESS));
        assertTrue(StatusCodes.isFailure(StatusCodes.STATUS_DISALLOWED));
        assertFalse(StatusCodes.isFailure(StatusCodes.STATUS_ALLOWED));
    }

    function test_allStatusCodesAreDefined() public {
        assertEq(StatusCodes.STATUS_FAILURE, 0x00);
        assertEq(StatusCodes.STATUS_SUCCESS, 0x01);
        assertEq(StatusCodes.STATUS_DISALLOWED, 0x10);
        assertEq(StatusCodes.STATUS_ALLOWED, 0x11);
        assertEq(StatusCodes.STATUS_TOO_EARLY, 0x20);
        assertEq(StatusCodes.STATUS_TOO_LATE, 0x21);
        assertEq(StatusCodes.STATUS_NONCE_USED, 0x22);
        assertEq(StatusCodes.STATUS_TRANSFER_FAILED, 0x50);
        assertEq(StatusCodes.STATUS_TRANSFER_SUCCESS, 0x51);
        assertEq(StatusCodes.STATUS_INSUFFICIENT_FUNDS, 0x54);
        assertEq(StatusCodes.STATUS_INTENT_INVALID_FORMAT, 0xA0);
        assertEq(StatusCodes.STATUS_UNSUPPORTED_ACTION, 0xA1);
        assertEq(StatusCodes.STATUS_UNSUPPORTED_CHAIN, 0xA2);
    }
}

