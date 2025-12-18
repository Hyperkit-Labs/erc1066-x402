# Multi-Chain Protocol Specification

This specification defines how the intent framework is implemented across different blockchain runtimes while maintaining semantic consistency.

## 1. Protocol Components

A complete implementation of the framework on any chain must provide:
1.  **Status Registry**: A library or module defining the standard status codes.
2.  **Policy Storage**: A way to register and store user-defined permissions.
3.  **Validation Engine**: A pre-flight function (`canExecute` or `validate_intent`) that returns a status code without committing state changes.
4.  **Execution Engine**: A function that performs the validation and then executes the intent logic.

## 2. Chain Implementation Details

### 2.1 EVM (Ethereum, Metis, Mantle, Avalanche)
- **Language**: Solidity 0.8.24+
- **Pattern**: Interface-driven with `IIntentValidator`.
- **Address Format**: 20-byte checksummed hex.
- **Error Handling**: Uses `require` with custom errors or returning `bytes1`.

### 2.2 Solana
- **Framework**: Anchor 0.30+
- **Pattern**: Instruction-based dispatch.
- **Address Format**: 32-byte Base58 string.
- **Error Handling**: Mapped to `ProgramError::Custom(u16)`.
- **Pre-flight**: Uses `simulateTransaction` to extract the custom error code.

### 2.3 Sui
- **Language**: Move (Sui Move 2024)
- **Pattern**: Module-based structs (`Intent`, `Policy`).
- **Address Format**: 32-byte long hex (`0x...`).
- **Error Handling**: Uses `abort` with constant values matching GlobalStatusId.
- **Pre-flight**: Uses `dryRunTransactionBlock` to extract the MoveAbort code.

## 3. Cross-Chain Hashing

To track intents across chains, the Gateway uses a normalized Keccak256 hash.

1.  **Normalization**: Non-EVM addresses (Solana/Sui) are converted to bytes and padded/truncated to 32 bytes.
2.  **Encoding**: The fields are ABI-encoded using the following signature:
    `keccak256(abi.encode(bytes32, bytes32, bytes, uint256, uint256, uint256, uint256, bytes32))`
3.  **ID**: This hash serves as the `X-Intent-Hash` across the entire ecosystem.

