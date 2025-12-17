# ERC-1066-x402 Gateway

HTTP/x402 gateway service for intent validation and execution. Provides a REST API for validating and executing intents across multiple blockchain networks.

## Quick Start

### Installation

```bash
npm install
```

### First-Time Setup

1. **Copy environment template:**
   ```bash
   cp env.template .env
   ```

2. **Configure contract addresses:**
   Edit `.env` with your deployed contract addresses:
   ```env
   EXECUTOR_ADDRESSES={"133717":"0x..."}
   VALIDATOR_ADDRESSES={"133717":"0x..."}
   REGISTRY_ADDRESSES={"133717":"0x..."}
   ```

3. **Start the gateway:**
   ```bash
   npm run dev
   ```

The gateway will start on `http://localhost:3000` (or port specified in `.env`).

### Verify It's Working

```bash
# Health check
curl http://localhost:3000/health

# List configured chains
curl http://localhost:3000/chains
```

## Development

```bash
npm run dev
```

## Build

```bash
npm run build
```

## Start (Production)

```bash
npm start
```

## Configuration

The gateway uses **Chainlist** for automatic RPC discovery, making it network-agnostic. You only need to provide contract addresses.

### Minimal Configuration (Chainlist-Only)

```env
PORT=3000
HOST=0.0.0.0

# Enable Chainlist for automatic RPC discovery (default: true)
USE_CHAINLIST=true

# Executor contract addresses per chain (JSON format)
EXECUTOR_ADDRESSES={"133717":"0x...","59902":"0x...","1088":"0x..."}

# Validator contract addresses per chain (JSON format)
VALIDATOR_ADDRESSES={"133717":"0x...","59902":"0x...","1088":"0x..."}

# Policy Registry contract addresses per chain (JSON format)
REGISTRY_ADDRESSES={"133717":"0x...","59902":"0x...","1088":"0x..."}
```

RPC URLs are automatically discovered from [Chainlist](https://chainlist.org).

### With Custom RPC Fallbacks

```env
# Optional: Custom RPC URLs as fallbacks (JSON format)
RPC_URLS={"133717":"https://custom-rpc.example.com"}

# Optional: Multiple RPC URLs per chain for failover
RPC_URLS_ARRAY={"133717":["https://rpc1.example.com","https://rpc2.example.com"]}
```

### Legacy Mode (No Chainlist)

```env
USE_CHAINLIST=false
RPC_URLS={"133717":"https://rpc.example.com","59902":"https://rpc2.example.com"}
EXECUTOR_ADDRESSES={"133717":"0x...","59902":"0x..."}
```

### Supported Networks

The gateway supports **any EVM-compatible chain** listed on Chainlist. Tested networks include:

- **Hyperion Testnet**: Chain ID 133717
- **Metis Sepolia**: Chain ID 59902
- **Metis Andromeda Mainnet**: Chain ID 1088
- **Mantle Testnet**: Chain ID 5003
- **Mantle Mainnet**: Chain ID 5000
- **Avalanche Fuji**: Chain ID 43113
- **Avalanche C-Chain**: Chain ID 43114

See [Network-Agnostic Architecture](./docs/architecture/NETWORK_AGNOSTIC.md) for details.

## API Endpoints

### Health Check

```bash
GET /health
```

Returns gateway status and metrics.

**Example:**
```bash
curl http://localhost:3000/health
```

**Response:**
```json
{
  "status": "healthy",
  "uptime": 3600,
  "chains": 7
}
```

### List Chains

```bash
GET /chains
GET /chains/:chainId
```

Returns configured chains and their metadata.

**Example:**
```bash
# List all chains
curl http://localhost:3000/chains

# Get specific chain
curl http://localhost:3000/chains/133717
```

### Validate Intent

```bash
POST /intents/validate
Headers: X-Chain-Id: <chainId>
```

Validates an intent without executing it.

**Example:**
```bash
curl -X POST http://localhost:3000/intents/validate \
  -H "Content-Type: application/json" \
  -H "X-Chain-Id: 133717" \
  -d '{
    "sender": "0x...",
    "target": "0x...",
    "data": "0x",
    "value": "0",
    "nonce": "1",
    "validAfter": "0",
    "validBefore": "18446744073709551615",
    "policyId": "0x..."
  }'
```

**Response:**
```json
{
  "status": "0x01",
  "intentHash": "0x..."
}
```

### Execute Intent

```bash
POST /intents/execute
Headers: X-Chain-Id: <chainId>
```

Executes a validated intent (requires wallet client).

**Example:**
```bash
curl -X POST http://localhost:3000/intents/execute \
  -H "Content-Type: application/json" \
  -H "X-Chain-Id: 133717" \
  -d '{...intent...}'
```

## Usage Examples

### Using the SDK

```python
from erc1066_x402 import ERC1066Client, Intent

client = ERC1066Client("http://localhost:3000")

intent = Intent(
    sender="0x...",
    target="0x...",
    data="0x",
    value="0",
    nonce="1",
    policyId="0x..."
)

# Validate
result = client.validate_intent(intent, chain_id=133717)
print(f"Status: {result.status}")

# Execute if valid
if result.status == "0x01":
    execution = client.execute_intent(intent, chain_id=133717)
```

### Custom Networks

Register networks not listed on Chainlist:

```bash
POST /chains
Content-Type: application/json

{
  "chainId": 9999,
  "name": "Custom Network",
  "nativeCurrency": {
    "name": "Ether",
    "symbol": "ETH",
    "decimals": 18
  },
  "rpcUrls": ["https://rpc.example.com"],
  "explorers": [{"name": "Explorer", "url": "https://explorer.example.com"}]
}
```

## Troubleshooting

### Port Already in Use

```bash
# Change port in .env
PORT=3001
```

### Chain Not Found

Ensure chain is configured in `.env`:
```env
EXECUTOR_ADDRESSES={"133717":"0x..."}
```

### RPC Timeout

Add custom RPC URLs:
```env
RPC_URLS={"133717":"https://custom-rpc.com"}
```

See [Troubleshooting Guide](../../docs/TROUBLESHOOTING.md) for more help.

