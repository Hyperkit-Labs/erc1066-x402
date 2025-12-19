# Getting Started with ERC-1066-x402

This guide will help you get up and running with ERC-1066-x402 in under 10 minutes.

## Prerequisites Checklist

Before you begin, ensure you have:

- [ ] **Node.js 18+** installed (`node --version`)
- [ ] **Foundry** installed (`forge --version`)
- [ ] **Solana Toolchain** installed (`solana --version`, `anchor --version`)
- [ ] **Sui Toolchain** installed (`sui --version`)
- [ ] **Git** installed (`git --version`)
- [ ] **A wallet** with testnet tokens (for deployment)

### Installing Prerequisites

**Node.js:**
```bash
# Using nvm (recommended)
nvm install 18
nvm use 18
```

**Foundry (EVM):**
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

**Solana & Anchor (Rust):**
```bash
# Installs Rust, Solana CLI, and Anchor in one go
curl --proto '=https' --tlsv1.2 -sSfL https://solana-install.solana.workers.dev | bash
```

**Sui (Move):**
```bash
# 1. Install suiup
curl -sSfL https://raw.githubusercontent.com/Mystenlabs/suiup/main/install.sh | sh

# 2. Install Sui Testnet binaries
suiup install sui@testnet
```

## Step 1: Clone and Setup

```bash
# Clone the repository
git clone https://github.com/hyperkit-labs/erc1066-x402.git
cd erc1066-x402

# Install dependencies
npm install
forge install
```

**Expected output:**
```
✓ Installed dependencies
✓ OpenZeppelin contracts installed
```

## Step 2: Run Tests

Verify everything works:

```bash
npm test
```

**Expected output:**
```
Running 10 tests for IntentExecutorTest...
[PASS] test_execute_success()
[PASS] test_execute_revertsWhenValidationFails()
...
Test result: ok. 10 passed
```

## Step 3: Configure Environment

Create a `.env` file in the root (or use environment variables):

```bash
# For deployment scripts
export PRIVATE_KEY=your_private_key_here
# Note: 0x prefix is optional, scripts handle it automatically
```

**Security Note:** Never commit your private key. It's already in `.gitignore`.

## Step 4: Deploy Contracts (Optional)

Deploy to Hyperion Testnet for testing:

```bash
# Set your private key
export PRIVATE_KEY=your_private_key_here

# Deploy
npm run deploy:hyperion:testnet
```

**Expected output:**
```
PolicyRegistry deployed at: 0x...
SimpleSpendingValidator deployed at: 0x...
IntentExecutor deployed at: 0x...
```

**Save these addresses** - you'll need them for the gateway.

## Step 5: Start Gateway Service

```bash
cd packages/gateway

# Copy environment template
cp env.template .env

# Edit .env with your deployed addresses
# EXECUTOR_ADDRESSES={"133717":"0x..."}
# VALIDATOR_ADDRESSES={"133717":"0x..."}
# REGISTRY_ADDRESSES={"133717":"0x..."}

# Install dependencies
npm install

# Start gateway
npm run dev
```

**Expected output:**
```
Server listening on http://0.0.0.0:3001
```

## Step 6: Test Gateway

In another terminal:

```bash
# Health check
curl http://localhost:3001/health

# List chains
curl http://localhost:3001/chains

# Validate an intent
curl -X POST http://localhost:3001/intents/validate \
  -H "Content-Type: application/json" \
  -H "X-Chain-Id: 133717" \
  -d '{
    "sender": "0xa43b752b6e941263eb5a7e3b96e2e0dea1a586ff",
    "target": "0xf5cb11878b94c9cd0bfa2e87ce9d6e1768cea818",
    "data": "0x",
    "value": "0",
    "nonce": "1",
    "validAfter": "0",
    "validBefore": "18446744073709551615",
    "policyId": "0x0000000000000000000000000000000000000000000000000000000000000000"
  }'
```

## Step 7: Install and Use SDK

### Python SDK

```bash
pip install hyperkitlabs-erc1066-x402
```

```python
from erc1066_x402 import ERC1066Client, Intent

client = ERC1066Client("http://localhost:3001")
intent = Intent(
    sender="0x...",
    target="0x...",
    data="0x",
    value="0",
    nonce="1",
    policyId="0x..."
)
result = client.validate_intent(intent, chain_id=133717)
print(f"Status: {result.status}")
```

### TypeScript SDK

```bash
npm install @hyperkitlab/erc1066-x402
```

```typescript
import { ERC1066Client } from '@hyperkitlab/erc1066-x402';

const client = new ERC1066Client('http://localhost:3001');
const result = await client.validateIntent(intent, 133717);
```

## Next Steps

1. **Read the Documentation**
   - [Architecture Overview](./docs/reference/Overview.md)
   - [Deployment Guide](./docs/deployment/DEPLOYMENT_GUIDE.md)
   - [Integration Guides](./docs/integration/)

2. **Explore Examples**
   - [Basic Usage](./docs/examples/basic-usage.md)
   - [Policy Setup](./docs/examples/policy-setup.md)

3. **Deploy to More Networks**
   - See [Network Configuration](./docs/deployment/NETWORKS.md)

4. **Create Your First Policy**
   - Use the [Policy Creation Script](./script/test/CreatePolicy.s.sol)

## Common Issues

### "forge: command not found"
- Install Foundry: `curl -L https://foundry.paradigm.xyz | bash && foundryup`

### "Port 3001 already in use"
- Change port in `packages/gateway/.env`: `PORT=3002`
- Or kill the process: `lsof -ti:3001 | xargs kill`

### "PRIVATE_KEY not set"
- Export it: `export PRIVATE_KEY=your_key`
- Or add to `.env` file (ensure it's in `.gitignore`)

### "Insufficient funds"
- Get testnet tokens from faucets:
  - Hyperion: Contact Metis DevOps
  - Metis Sepolia: Public faucet
  - Avalanche Fuji: https://faucet.avalanche.network/

## Getting Help

- **Documentation**: [docs/README.md](./docs/README.md)
- **Issues**: [GitHub Issues](https://github.com/hyperkit-labs/erc1066-x402/issues)
- **Troubleshooting**: [Troubleshooting Guide](./docs/TROUBLESHOOTING.md)

## What's Next?

Once you're comfortable with the basics:

1. **Understand the Architecture**: Read [Architecture Overview](./docs/reference/Overview.md)
2. **Deploy to Production**: Follow [Deployment Guide](./docs/deployment/DEPLOYMENT_GUIDE.md)
3. **Integrate with Your App**: See [Integration Guides](./docs/integration/)
4. **Contribute**: Read [CONTRIBUTING.md](./CONTRIBUTING.md)

Happy building! 🚀

