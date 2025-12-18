# x402 V2 Transport Specification

This specification defines the HTTP-based transport layer for ERC-1066-x402, aligned with the Coinbase x402 v2 standard.

## 1. Overview

The transport layer handles the communication between an AI agent (the requester) and a gateway (the responder). When an intent requires payment or validation fails, the gateway returns a machine-readable response.

## 2. HTTP Status Codes

| Code | Meaning | Usage |
| :--- | :--- | :--- |
| **200** | OK | Intent validated or executed successfully. |
| **202** | Accepted | Intent is pending (e.g., `TOO_EARLY`). |
| **402** | Payment Required | Intent requires payment to proceed (`INSUFFICIENT_FUNDS`). |
| **403** | Forbidden | Intent explicitly disallowed by policy (`DISALLOWED`). |
| **410** | Gone | Intent has expired (`TOO_LATE`). |
| **421** | Misdirected | Unsupported chain or network (`UNSUPPORTED_CHAIN`). |

## 3. Headers

All responses must include these custom headers for on-chain context:

- `X-ERC1066-Status`: The raw hex status code (e.g., `0x11`).
- `X-Intent-Hash`: The Keccak256 hash of the intent payload.
- `X-Chain-Type`: The runtime environment (`evm`, `solana`, `sui`).
- `X-Chain-Id`: The unique identifier for the network.

## 4. JSON Response Body (402 Payment Required)

The response body follows the x402 v2 "envelope" format.

### 4.1 structure

```json
{
  "accepts": [
    {
      "paymentRequirements": {
        "scheme": "exact",
        "version": 2,
        "amount": "string",
        "asset": "string",
        "network": "string",
        "extra": {
          "policyId": "string"
        }
      }
    }
  ]
}
```

### 4.2 Field Definitions

- **scheme**: The payment method required. ERC-1066-x402 defaults to `exact`.
- **amount**: The precise value required in the smallest unit (e.g., wei).
- **asset**: The asset identifier (e.g., `native`, `0x...`).
- **network**: Formatted as `chainType:chainId` (e.g., `evm:59902`).
- **extra**: Optional metadata, such as the `policyId` associated with the request.

