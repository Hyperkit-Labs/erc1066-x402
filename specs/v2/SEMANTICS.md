# Semantic Layer Specification (ERC-1066)

This specification defines the unified "language" of status codes used by ERC-1066-x402 to enable machine-readable transaction feedback.

## 1. Global Status Id (ID)

Status codes are 1-byte identifiers (represented as hex `0xXX` in EVM and `u16` in Solana/Sui) that represent the outcome of an intent validation or execution.

## 2. Core Status Map

| ID | Hex | Name | Definition | HTTP Map |
| :--- | :--- | :--- | :--- | :--- |
| **1** | `0x01` | S_SUCCESS | Operation succeeded completely. | 200 |
| **16** | `0x10` | S_DISALLOWED | Denied due to policy (permissions). | 403 |
| **17** | `0x11` | S_ALLOWED | Validation passed, ready to execute. | 200 |
| **32** | `0x20` | S_TOO_EARLY | Request made before valid starting time. | 202 |
| **33** | `0x21` | S_TOO_LATE | Request made after expiration time. | 410 |
| **34** | `0x22` | S_NONCE_USED | Intent has already been executed. | 409 |
| **80** | `0x50` | S_TRANSFER_FAILED | Value transfer failed on-chain. | 500 |
| **81** | `0x51` | S_TRANSFER_SUCCESS| Value transfer confirmed. | 200 |
| **84** | `0x54` | S_INSUFFICIENT_FUNDS| Requires payment/funding to proceed. | 402 |
| **160** | `0xA0` | S_INVALID_FORMAT | Intent payload is malformed. | 400 |
| **161** | `0xA1` | S_UNSUPPORTED_ACTION| Method or target is not supported. | 501 |
| **162** | `0xA2` | S_UNSUPPORTED_CHAIN | Network or Chain ID not configured. | 421 |

## 3. Byte Encoding Rules

### 3.1 EVM (Solidity)
Implemented as `bytes1` in `StatusCodes.sol`. Return values from `canExecute` should be explicitly cast to `bytes1`.

### 3.2 Solana (Rust)
Implemented as `u16` constants in `status.rs`. Mapped to `ProgramError::Custom(status)`.

### 3.3 Sui (Move)
Implemented as `u64` constants in `intent_framework.move`. Mapped to module-specific `abort` codes.

## 4. Machine-Readable Branching

AI Agents must use these codes to determine their next action. For example:
- `0x11` -> Call `execute()`
- `0x54` -> Request funds from Facilitator
- `0x20` -> Wait and retry

