# ERC-1066-x402 TypeScript SDK

TypeScript SDK for interacting with the ERC-1066-x402 gateway. Provides type-safe interfaces for validating and executing intents across multiple blockchain networks.

## Installation

```bash
npm install @hyperkitlab/erc1066-x402
```

## Quick Start

### Basic Usage

```typescript
import { ERC1066Client, Intent } from '@hyperkitlab/erc1066-x402';

// Initialize client
const client = new ERC1066Client('http://localhost:3000');

// Create an intent
const intent: Intent = {
  sender: '0xa43b752b6e941263eb5a7e3b96e2e0dea1a586ff',
  target: '0xf5cb11878b94c9cd0bfa2e87ce9d6e1768cea818',
  data: '0x',
  value: '0',
  nonce: '1',
  validAfter: '0',
  validBefore: '18446744073709551615',
  policyId: '0x0000000000000000000000000000000000000000000000000000000000000000'
};

// Validate intent
const result = await client.validateIntent(intent, 133717);
console.log(`Status: ${result.status}`);
console.log(`Intent Hash: ${result.intentHash}`);

// Map status to action
const action = client.mapStatusToAction(result.status);
console.log(`Action: ${action}`);

// Execute if valid
if (action === 'execute') {
  const execution = await client.executeIntent(intent, 133717);
  console.log(`Execution result:`, execution);
}
```

## API Reference

### ERC1066Client

Main client class for interacting with the gateway.

#### Constructor

```typescript
const client = new ERC1066Client(gatewayUrl: string);
```

- `gatewayUrl`: Base URL of the gateway service (e.g., `http://localhost:3000`)

#### Methods

**validateIntent(intent: Intent, chainId: number): Promise<ValidateResponse>**

Validates an intent without executing it.

- `intent`: Intent object to validate
- `chainId`: Chain ID to validate on
- Returns: Promise resolving to `ValidateResponse` with status, HTTP code, and intent hash

**executeIntent(intent: Intent, chainId: number): Promise<ExecuteResponse>**

Executes a validated intent.

- `intent`: Intent object to execute
- `chainId`: Chain ID to execute on
- Returns: Promise resolving to `ExecuteResponse` with status and result

**mapStatusToAction(status: StatusCode): Action**

Maps a status code to an action.

- `status`: Status code (e.g., `"0x01"`)
- Returns: Action string (`"execute"`, `"retry"`, `"request_payment"`, or `"deny"`)

## Complete Example

```typescript
import { ERC1066Client, Intent } from '@hyperkitlab/erc1066-x402';

async function main() {
  // Initialize client
  const client = new ERC1066Client('http://localhost:3000');

  // Create intent
  const intent: Intent = {
    sender: '0x...',
    target: '0x...',
    data: '0x...',
    value: '0',
    nonce: '1',
    validAfter: '0',
    validBefore: '18446744073709551615',
    policyId: '0x...'
  };

  // Validate
  const validation = await client.validateIntent(intent, 133717);
  const action = client.mapStatusToAction(validation.status);

  // Handle based on action
  switch (action) {
    case 'execute':
      const result = await client.executeIntent(intent, 133717);
      console.log('Executed:', result);
      break;
    case 'request_payment':
      console.log('Payment required');
      break;
    case 'retry':
      console.log('Retry later');
      break;
    default:
      console.log(`Denied: ${validation.status}`);
  }
}

main().catch(console.error);
```

## Types

### Intent

```typescript
interface Intent {
  sender: string;        // 0x-prefixed address
  target: string;        // 0x-prefixed address
  data: string;          // 0x-prefixed hex string
  value: string;         // Decimal string
  nonce: string;         // Decimal string
  validAfter?: string;  // Optional timestamp
  validBefore?: string; // Optional timestamp
  policyId: string;     // 0x-prefixed 32-byte hex string
}
```

### StatusCode

```typescript
type StatusCode =
  | "0x00" | "0x01" | "0x10" | "0x11"
  | "0x20" | "0x21" | "0x22"
  | "0x50" | "0x51" | "0x54"
  | "0xA0" | "0xA1" | "0xA2";
```

### Action

```typescript
type Action = "execute" | "retry" | "request_payment" | "deny";
```

## Status Codes

Common status codes:

- `0x01` - SUCCESS (execute allowed)
- `0x10` - DISALLOWED (policy violation)
- `0x54` - INSUFFICIENT_FUNDS (payment required)
- `0x20` - TOO_EARLY (before valid time)
- `0x21` - TOO_LATE (after valid time)

See [Status Codes Specification](../../docs/spec/status-codes.md) for complete list.

## Error Handling

```typescript
import { ERC1066Client } from '@hyperkitlab/erc1066-x402';

const client = new ERC1066Client('http://localhost:3000');

try {
  const result = await client.validateIntent(intent, 133717);
  console.log('Success:', result);
} catch (error) {
  if (error instanceof Error) {
    console.error('Request failed:', error.message);
  } else {
    console.error('Unknown error:', error);
  }
}
```

## Utility Functions

```typescript
import { computeIntentHash, encodeIntent, decodeIntent } from '@hyperkitlab/erc1066-x402';

// Compute intent hash
const hash = computeIntentHash(intent);

// Encode intent to bytes
const encoded = encodeIntent(intent);

// Decode bytes to intent
const decoded = decodeIntent(encoded);
```

## More Examples

See [examples/](./examples/) directory for:
- Basic usage examples
- Agent integration examples
- Error handling patterns

## Troubleshooting

### Import Errors

```bash
# Ensure package is installed
npm install @hyperkitlab/erc1066-x402

# Verify installation
npm list @hyperkitlab/erc1066-x402
```

### Type Errors

Ensure TypeScript is configured correctly:
```json
{
  "compilerOptions": {
    "module": "ESNext",
    "target": "ES2022",
    "lib": ["ES2022"]
  }
}
```

### Connection Errors

- Verify gateway is running: `curl http://localhost:3000/health`
- Check gateway URL is correct
- Ensure network connectivity

See [Troubleshooting Guide](../../docs/TROUBLESHOOTING.md) for more help.

