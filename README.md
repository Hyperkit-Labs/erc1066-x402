<div align="center">
  <img src="public/banner/ERC1066 X402.png" alt="ERC-1066-x402 Banner" width="800">
</div>

# ERC-1066-x402

<!-- Badges: start -->
![License](https://img.shields.io/badge/license-MIT-blue)
![Version](https://img.shields.io/badge/version-0.1.0-brightgreen)
![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
<!-- Badges: end -->

## What is this?

ERC-1066-x402 is a set of Ethereum-compatible smart contracts that standardize **status codes**, **policy checks**, and **intent validation** for Web3 transactions. It integrates with an HTTP/x402 gateway and agent layer to provide machine-readable status codes for autonomous decision-making.

**Key Features:**
- ✅ Standardized ERC-1066 status codes for intents/AA/payments
- ✅ Pre-flight validation (`canExecute`) with machine-readable status
- ✅ Policy-based access control (limits, permissions, chains, assets)
- ✅ Network-agnostic gateway using [Chainlist](https://chainlist.org) for automatic RPC discovery
- ✅ TypeScript and Python SDKs for easy integration
- ✅ Multi-chain support (7+ networks tested)

## Project Status

| Component | Status | Notes |
|-----------|--------|-------|
| Smart Contracts | ✅ Production-ready | Deployed to Hyperion Testnet |
| Gateway Service | ✅ Beta | Network-agnostic, Chainlist integration |
| Python SDK | ✅ Published | Available on PyPI |
| TypeScript SDK | ⏳ Ready | Pending npm publication |

## Quick Start

### 1. Clone and Install

```bash
git clone https://github.com/hyperkit-labs/erc1066-x402.git
cd erc1066-x402
npm install
forge install
```

### 2. Run Tests

```bash
npm test
```

### 3. Deploy Contracts

```bash
# Set your private key
export PRIVATE_KEY=your_private_key_here

# Deploy to Hyperion Testnet
npm run deploy:hyperion:testnet
```

### 4. Start Gateway

```bash
cd packages/gateway
cp env.template .env
# Edit .env with your contract addresses
npm run dev
```

**For detailed setup, see [GETTING_STARTED.md](./GETTING_STARTED.md)**

## Architecture

```mermaid
graph TB
    subgraph OffChain[Off-Chain Layer]
        Gateway[Gateway Service<br/>TypeScript/Fastify]
        SDK_TS[TypeScript SDK]
        SDK_PY[Python SDK]
        Agents[AI Agents/Wallets]
    end
    
    subgraph OnChain[On-Chain Layer]
        Executor[IntentExecutor]
        Validator[BaseIntentValidator]
        Registry[PolicyRegistry]
        StatusCodes[StatusCodes Library]
    end
    
    Agents --> SDK_TS
    Agents --> SDK_PY
    SDK_TS --> Gateway
    SDK_PY --> Gateway
    Gateway --> Executor
    Executor --> Validator
    Validator --> Registry
    Validator --> StatusCodes
```

**See [Architecture Overview](./docs/reference/Overview.md) for detailed diagrams.**

## Supported Networks

The gateway supports **any EVM-compatible chain** via Chainlist. Tested networks:

- **Hyperion Testnet** (Chain ID: 133717) ✅ Deployed
- **Metis Sepolia** (Chain ID: 59902)
- **Metis Andromeda Mainnet** (Chain ID: 1088)
- **Mantle Testnet** (Chain ID: 5003)
- **Mantle Mainnet** (Chain ID: 5000)
- **Avalanche Fuji** (Chain ID: 43113)
- **Avalanche C-Chain** (Chain ID: 43114)

See [Network Configuration](./docs/deployment/NETWORKS.md) for details.

## Documentation

📚 **[Complete Documentation Index](./docs/README.md)**

### Essential Guides

- **[Getting Started](./GETTING_STARTED.md)** - First-time setup guide
- **[Quick Start Guide](./docs/QUICK_START_COMPLETE.md)** - Complete step-by-step walkthrough
- **[Deployment Guide](./docs/deployment/DEPLOYMENT_GUIDE.md)** - Multi-chain deployment
- **[Network-Agnostic Architecture](./docs/architecture/NETWORK_AGNOSTIC.md)** - Chainlist integration

### Integration

- **[Gateway Integration](./docs/integration/GATEWAY.md)** - Gateway service setup
- **[Agent Integration](./docs/integration/AGENTS.md)** - AI agent integration
- **[Custom Networks](./docs/integration/CUSTOM_NETWORKS.md)** - Adding unlisted networks

### SDKs

- **[Python SDK](./docs/sdk/PYTHON_SDK_USAGE.md)** - Installation and usage
- **[TypeScript SDK](./packages/sdk-ts/README.md)** - Installation and usage

### Examples

- **[Basic Usage](./docs/examples/basic-usage.md)** - Simple examples
- **[Policy Setup](./docs/examples/policy-setup.md)** - Policy configuration

## Installation

### Smart Contracts

```bash
npm install
forge install
```

### Gateway Service

```bash
cd packages/gateway
npm install
```

### Python SDK

```bash
pip install hyperkitlabs-erc1066-x402
```

### TypeScript SDK

```bash
npm install @hyperkit/erc1066-x402-sdk
```

## Usage Example

### Python SDK

```python
from erc1066_x402 import ERC1066Client, Intent

client = ERC1066Client("http://localhost:3001")

intent = Intent(
    sender="0x...",
    target="0x...",
    data="0x...",
    value="0",
    nonce="1",
    policyId="0x..."
)

result = client.validate_intent(intent, chain_id=133717)
if result.status == "0x01":
    client.execute_intent(intent, chain_id=133717)
```

### TypeScript SDK

```typescript
import { ERC1066Client } from '@hyperkit/erc1066-x402-sdk';

const client = new ERC1066Client('http://localhost:3001');
const result = await client.validateIntent(intent, 133717);
```

## Development

### Branch Strategy

- **`main`** - Production-ready code (protected, requires PR + reviews)
- **`develop`** - Integration branch for feature development
- **`feature/*`** - Feature branches (merge to `develop`)

See [Development Guide](./docs/DEVELOPMENT.md) for details.

### Running Tests

```bash
# All tests
npm test

# Contract tests only
forge test

# With coverage
npm run test:coverage
```

### Contributing

We welcome contributions! See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

## Troubleshooting

### Common Issues

**Gateway won't start:**
- Check that port 3001 is available: `lsof -i :3001`
- Verify `.env` file exists and has correct contract addresses
- Ensure RPC URLs are accessible

**Contracts fail to deploy:**
- Verify `PRIVATE_KEY` has `0x` prefix (scripts handle this automatically)
- Check you have testnet tokens for gas
- Verify RPC endpoint is correct

**SDK import errors:**
- Python: Ensure virtual environment is activated
- TypeScript: Run `npm install` in SDK directory

**For more help:** See [Troubleshooting Guide](./docs/TROUBLESHOOTING.md)

## Status Codes

The system uses a canonical subset of ERC-1066 status codes:

- `0x01` SUCCESS - Execution allowed
- `0x10` DISALLOWED - Policy violation
- `0x54` INSUFFICIENT_FUNDS - Payment required
- `0x20` TOO_EARLY - Before valid time window
- `0x21` TOO_LATE - After valid time window

See [Status Codes Specification](./docs/spec/status-codes.md) for complete list.

## License

MIT License - see [LICENSE](./LICENSE) for details.

## Links

- **Documentation**: [docs/README.md](./docs/README.md)
- **Issues**: [GitHub Issues](https://github.com/hyperkit-labs/erc1066-x402/issues)
- **Contributing**: [CONTRIBUTING.md](./CONTRIBUTING.md)
- **Changelog**: [CHANGELOG.md](./CHANGELOG.md)

---

## Technical Details

For detailed technical specifications, see:

- [Functional Requirements](./docs/reference/architecture.md#functional-requirements)
- [Contract Breakdown](./docs/reference/architecture.md#contracts-breakdown)
- [Security Considerations](./docs/reference/architecture.md#security-considerations)
- [Testing Strategy](./docs/reference/architecture.md#testing-strategy)
