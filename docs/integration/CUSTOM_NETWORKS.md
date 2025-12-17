# Custom Networks Support

The gateway supports custom networks that are not listed on Chainlist. This allows you to add networks like Hyperion Testnet (133717) that aren't yet available in the Chainlist registry.

## Configuration Methods

### Method 1: Environment Variable

Add custom network metadata to your `.env` file:

```env
CUSTOM_NETWORKS=[{"chainId":133717,"name":"Hyperion Testnet","nativeCurrency":{"name":"Metis","symbol":"METIS","decimals":18},"rpcUrls":["https://hyperion-testnet.metisdevops.link"],"explorers":[{"name":"blockscout","url":"https://explorer.hyperion-testnet.metisdevops.link"}]}]
```

### Method 2: API Registration

Register a custom network via the REST API:

```bash
curl -X POST http://localhost:3000/chains \
  -H "Content-Type: application/json" \
  -d '{
    "chainId": 133717,
    "name": "Hyperion Testnet",
    "nativeCurrency": {
      "name": "Metis",
      "symbol": "METIS",
      "decimals": 18
    },
    "rpcUrls": ["https://hyperion-testnet.metisdevops.link"],
    "explorers": [{
      "name": "blockscout",
      "url": "https://explorer.hyperion-testnet.metisdevops.link"
    }]
  }'
```

## Network Metadata Schema

```typescript
{
  chainId: number;           // Required: Chain ID
  name: string;               // Required: Network name
  nativeCurrency?: {          // Optional: Defaults to ETH
    name: string;
    symbol: string;
    decimals: number;
  };
  rpcUrls: string[];         // Required: Array of RPC URLs
  explorers?: Array<{        // Optional: Block explorers
    name: string;
    url: string;
  }>;
}
```

## RPC URL Priority

When a custom network is registered:

1. **Custom RPC URLs** (from `RPC_URLS` or `RPC_URLS_ARRAY` in `.env`) are used first
2. **Chainlist RPC URLs** are used as fallbacks (if `USE_CHAINLIST=true`)
3. **Custom network RPC URLs** (from `CUSTOM_NETWORKS`) are included in the metadata

## API Endpoints

### Register Custom Network

**POST** `/chains`

```json
{
  "chainId": 133717,
  "name": "Hyperion Testnet",
  "nativeCurrency": {
    "name": "Metis",
    "symbol": "METIS",
    "decimals": 18
  },
  "rpcUrls": ["https://hyperion-testnet.metisdevops.link"],
  "explorers": [{
    "name": "blockscout",
    "url": "https://explorer.hyperion-testnet.metisdevops.link"
  }]
}
```

**Response:**
```json
{
  "success": true,
  "message": "Custom network 133717 registered",
  "network": { ... }
}
```

### Get Custom Network

**GET** `/chains/:chainId/custom`

Returns the custom network metadata if registered.

**Response:**
```json
{
  "chainId": 133717,
  "name": "Hyperion Testnet",
  "nativeCurrency": { ... },
  "rpcUrls": [ ... ],
  "explorers": [ ... ]
}
```

## Example: Hyperion Testnet

Complete `.env` configuration:

```env
# Enable Chainlist (will use as fallback)
USE_CHAINLIST=true

# Custom RPC URL (takes priority)
RPC_URLS={"133717":"https://hyperion-testnet.metisdevops.link"}

# Custom network metadata
CUSTOM_NETWORKS=[{"chainId":133717,"name":"Hyperion Testnet","nativeCurrency":{"name":"Metis","symbol":"METIS","decimals":18},"rpcUrls":["https://hyperion-testnet.metisdevops.link"],"explorers":[{"name":"blockscout","url":"https://explorer.hyperion-testnet.metisdevops.link"}]}]

# Contract addresses from deployment registry
DEPLOYMENT_REGISTRY_PATH=../../deployments/registry.json
```

## Benefits

- **No Chainlist dependency**: Works with networks not yet on Chainlist
- **Flexible configuration**: Use environment variables or API
- **RPC failover**: Custom RPCs take priority, Chainlist as fallback
- **Complete metadata**: Includes name, currency, explorers for full chain info

