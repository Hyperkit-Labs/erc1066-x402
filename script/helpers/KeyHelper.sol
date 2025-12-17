// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";

/// @notice Helper contract for parsing private keys from environment
/// @dev Must be used within a Script contract context
abstract contract KeyHelper is Script {
    /// @notice Get private key from environment, handling both 0x-prefixed and non-prefixed formats
    function getPrivateKey() internal view returns (uint256) {
        string memory keyStr = vm.envOr("PRIVATE_KEY", string(""));
        require(bytes(keyStr).length > 0, "PRIVATE_KEY not set");

        // Check if it starts with 0x
        bytes memory keyBytes = bytes(keyStr);
        if (keyBytes.length >= 2 && keyBytes[0] == "0" && (keyBytes[1] == "x" || keyBytes[1] == "X")) {
            // Already has 0x prefix, use directly
            return vm.envUint("PRIVATE_KEY");
        } else {
            // No 0x prefix, add it
            string memory prefixed = string.concat("0x", keyStr);
            // Parse as bytes32 then convert to uint256
            return uint256(vm.parseBytes32(prefixed));
        }
    }
}

