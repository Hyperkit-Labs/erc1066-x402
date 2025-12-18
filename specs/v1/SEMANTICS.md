# Semantic Layer Specification (v1)

The v1 semantic layer defined the initial set of ERC-1066 status codes for EVM chains.

## 1. Core Status Codes (v1)

| Hex | Name | Meaning |
| :--- | :--- | :--- |
| `0x01` | S_SUCCESS | Operation succeeded. |
| `0x10` | S_DISALLOWED | Denied by policy. |
| `0x54` | S_INSUFFICIENT_FUNDS | Payment required. |
| `0x20` | S_TOO_EARLY | Time-lock not met. |
| `0x21` | S_TOO_LATE | Intent expired. |

## 2. Implementation

Implemented as a simple Solidity library `StatusCodes.sol` providing `bytes1` constants.

