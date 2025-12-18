# Payment Schemes Specification (v1)

This document defines the original payment fulfillment scheme supported by the v1 gateway.

## 1. The `direct` Scheme

The `direct` scheme was the only fulfillment method in v1. It required a standard native asset transfer.

### 1.1 Requirements

- **Transfer**: The agent performs a simple transfer to the address specified in the `X-Payment-Target` header.
- **Verification**: The gateway verified the transaction by checking the target's balance increase or monitoring the mempool for the specific hash.

### 1.2 Limitations

- **Non-atomic**: There was no built-in way to link the payment to the intent validation atomically.
- **EVM Only**: Designed specifically for 20-byte Ethereum addresses.

