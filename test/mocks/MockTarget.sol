// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract MockTarget {
    bool public shouldRevert;
    bytes public returnData;

    event MockCall(address indexed caller, uint256 value, bytes data);

    constructor(bool _shouldRevert, bytes memory _returnData) {
        shouldRevert = _shouldRevert;
        returnData = _returnData;
    }

    function setShouldRevert(bool _shouldRevert) external {
        shouldRevert = _shouldRevert;
    }

    function setReturnData(bytes memory _returnData) external {
        returnData = _returnData;
    }

    fallback() external payable {
        emit MockCall(msg.sender, msg.value, msg.data);
        if (shouldRevert) {
            revert("MockTarget: intentional revert");
        }
        bytes memory data = returnData;
        assembly {
            let ptr := mload(0x40)
            let len := mload(data)
            mstore(ptr, len)
            let dataPtr := add(data, 0x20)
            for {
                let i := 0
            } lt(i, len) {
                i := add(i, 0x20)
            } {
                mstore(add(ptr, add(0x20, i)), mload(add(dataPtr, i)))
            }
            return(ptr, add(0x20, len))
        }
    }

    receive() external payable {
        emit MockCall(msg.sender, msg.value, "");
        if (shouldRevert) {
            revert("MockTarget: intentional revert");
        }
    }
}

