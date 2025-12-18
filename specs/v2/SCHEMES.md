# Payment Schemes Specification

This document defines the payment fulfillment schemes supported by the ERC-1066-x402 gateway.

## 1. The `exact` Scheme

The `exact` scheme is the primary payment method for ERC-1066-x402. It requires the payer to fulfill a specific amount to a target address or contract.

### 1.1 Requirements

- **Precision**: The amount must be the exact value requested in the `amount` field.
- **Atomic Validation**: The gateway should verify the payment on-chain before marking the intent as "Allowed".

### 1.2 Execution Flow

1. **Validation**: Agent calls `/intents/validate`.
2. **Challenge**: Gateway returns `402` with the `exact` scheme requirements.
3. **Payment**: Agent or user executes the payment on the specified network.
4. **Finalization**: Agent calls `/intents/execute`.
5. **Success**: Gateway verifies the balance/payment and executes the original intent.

## 2. The `onchain` Scheme (EVM Extensions)

For EVM-compatible chains, the gateway may also support the `onchain` scheme, which leverages EIP-712 signatures or ERC-4337 user operations.

### 2.1 EIP-712 Signing

If the network supports it, the `extra` field will include a `domain` and `types` object for the agent to sign a permit or intent.

```json
{
  "scheme": "onchain",
  "extra": {
    "signatureType": "eip712",
    "domain": { ... },
    "message": { ... }
  }
}
```

## 3. Scheme Selection Logic

If multiple schemes are provided in the `accepts` array, the agent should prioritize them in the following order:
1. `onchain` (lowest friction)
2. `exact` (standard)
3. `direct` (legacy)

