# SDK Documentation

This directory contains documentation for the ERC-1066-x402 SDKs.

## Python SDK

- [Usage Guide](./PYTHON_SDK_USAGE.md) - Installation, API reference, and examples
- [Publication Status](./PYTHON_SDK_SUCCESS.md) - Publication status and test results

## TypeScript SDK

- See [packages/sdk-ts/README.md](../../packages/sdk-ts/README.md) for TypeScript SDK documentation

## Installation

### Python
```bash
pip install hyperkitlabs-erc1066-x402
```

### TypeScript
```bash
npm install @hyperkit/erc1066-x402-sdk
```

## Quick Start

### Python
```python
from erc1066_x402 import ERC1066Client, Intent

client = ERC1066Client("http://localhost:3001")
intent = Intent(...)
result = client.validate_intent(intent, chain_id=133717)
```

### TypeScript
```typescript
import { ERC1066Client } from '@hyperkit/erc1066-x402-sdk';

const client = new ERC1066Client('http://localhost:3001');
const result = await client.validateIntent(intent, 133717);
```

