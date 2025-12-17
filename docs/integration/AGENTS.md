# Agent Integration Guide

## Overview

Agents can integrate with ERC-1066-x402 using the TypeScript or Python SDKs.

## TypeScript SDK

```typescript
import { ERC1066Client } from '@hyperkit/erc1066-x402-sdk';

const client = new ERC1066Client('https://gateway.example.com');

const intent = {
  sender: '0x...',
  target: '0x...',
  data: '0x...',
  value: '0',
  nonce: '0',
  validAfter: '0',
  validBefore: '0',
  policyId: '0x...'
};

const result = await client.validateIntent(intent, 1);
const action = client.mapStatusToAction(result.status);
```

## Python SDK

```python
from erc1066_x402 import ERC1066Client

client = ERC1066Client('https://gateway.example.com')

intent = {
    'sender': '0x...',
    'target': '0x...',
    'data': '0x...',
    'value': '0',
    'nonce': '0',
    'validAfter': '0',
    'validBefore': '0',
    'policyId': '0x...'
}

result = client.validate_intent(intent, 1)
action = client.map_status_to_action(result['status'])
```

## Status Code Mapping

- `0x01` (SUCCESS): Execute immediately
- `0x20` (TOO_EARLY): Retry later
- `0x54` (INSUFFICIENT_FUNDS): Request payment
- `0x10` (DISALLOWED): Deny and inform user
- Other codes: Handle based on application logic

