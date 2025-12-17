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
        assertEq(uint8(StatusCodes.STATUS_FAILURE), uint8(0x00));
        assertEq(uint8(StatusCodes.STATUS_SUCCESS), uint8(0x01));
        assertEq(uint8(StatusCodes.STATUS_DISALLOWED), uint8(0x10));
        assertEq(uint8(StatusCodes.STATUS_ALLOWED), uint8(0x11));
        assertEq(uint8(StatusCodes.STATUS_TOO_EARLY), uint8(0x20));
        assertEq(uint8(StatusCodes.STATUS_TOO_LATE), uint8(0x21));
        assertEq(uint8(StatusCodes.STATUS_NONCE_USED), uint8(0x22));
        assertEq(uint8(StatusCodes.STATUS_TRANSFER_FAILED), uint8(0x50));
        assertEq(uint8(StatusCodes.STATUS_TRANSFER_SUCCESS), uint8(0x51));
        assertEq(uint8(StatusCodes.STATUS_INSUFFICIENT_FUNDS), uint8(0x54));
        assertEq(uint8(StatusCodes.STATUS_INTENT_INVALID_FORMAT), uint8(0xA0));
        assertEq(uint8(StatusCodes.STATUS_UNSUPPORTED_ACTION), uint8(0xA1));
        assertEq(uint8(StatusCodes.STATUS_UNSUPPORTED_CHAIN), uint8(0xA2));
    }
}

