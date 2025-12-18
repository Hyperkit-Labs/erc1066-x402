# x402 V1 Transport Specification (Legacy)

This specification defines the original HTTP-based transport layer for ERC-1066-x402.

## 1. Overview

The v1 transport layer was designed for simple AI agent payments using flat JSON responses and custom HTTP headers. It is now considered **Legacy** and replaced by the v2 standard.

## 2. HTTP Status Codes

| Code | Meaning | Usage |
| :--- | :--- | :--- |
| **200** | OK | Intent validated or executed successfully. |
| **402** | Payment Required | Intent requires payment to proceed. |
| **403** | Forbidden | Intent explicitly disallowed. |

## 3. Headers (v1)

V1 relied on custom headers to communicate payment requirements:

- `X-Payment-Required`: `true` or `false`.
- `X-Payment-Amount`: The value required in the smallest unit (e.g., wei).
- `X-Payment-Target`: The address where the payment must be sent.

## 4. JSON Response Body (402 Payment Required)

In v1, the response was a flat object:

```json
{
  "status": "0x54",
  "intentHash": "0x...",
  "message": "Insufficient funds"
}
```

