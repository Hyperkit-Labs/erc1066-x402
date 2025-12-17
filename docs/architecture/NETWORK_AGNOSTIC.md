# Network-Agnostic Architecture

ERC-1066-x402 is designed to be network-agnostic, supporting any EVM-compatible chain without hardcoding network-specific configurations.

## Chainlist Integration

The gateway service uses [Chainlist](https://chainlist.org) for dynamic RPC discovery, eliminating the need to hardcode RPC URLs for each network.

### How It Works

1. **Dynamic RPC Discovery**: The gateway fetches RPC endpoints from Chainlist's public API (`https://chainlist.org/rpcs.json`)
2. **Automatic Failover**: Multiple RPC providers per chain are used with automatic failover
3. **Fallback Support**: Custom RPC URLs can still be provided as fallbacks
4. **Caching**: Chainlist data is cached for 1 hour to reduce API calls

### Benefits

- **No Hardcoded RPCs**: Support new chains by just adding the chain ID
- **Automatic Updates**: RPC endpoints update automatically as Chainlist updates
- **Resilience**: Multiple RPC providers per chain provide redundancy
- **Network Discovery**: Chain metadata (name, currency, explorers) fetched automatically

## Configuration

### Gateway Configuration

The gateway supports three modes:

1. **Chainlist-Only** (Recommended):
   ```env
   USE_CHAINLIST=true
   EXECUTOR_ADDRESSES={"133717":"0x...","59902":"0x..."}
   ```
   RPC URLs are automatically discovered from Chainlist.

2. **Chainlist with Fallbacks**:
   ```env
   USE_CHAINLIST=true
   RPC_URLS={"133717":"https://fallback-rpc.example.com"}
   EXECUTOR_ADDRESSES={"133717":"0x..."}
   ```
   Uses Chainlist first, falls back to custom RPCs if needed.

3. **Custom RPCs Only**:
   ```env
   USE_CHAINLIST=false
   RPC_URLS={"133717":"https://custom-rpc.example.com"}
   EXECUTOR_ADDRESSES={"133717":"0x..."}
   ```
   Uses only custom RPC URLs (legacy mode).

### Multiple RPC URLs

For maximum resilience, provide multiple RPC URLs per chain:

```env
RPC_URLS_ARRAY={
  "133717":["https://rpc1.example.com","https://rpc2.example.com"],
  "59902":["https://rpc1.example.com","https://rpc2.example.com"]
}
```

The gateway will use all provided URLs plus Chainlist URLs with automatic failover.

## Adding New Networks

To add support for a new network:

1. **Deploy Contracts**: Deploy to the new chain using Foundry
   ```bash
   forge script script/Deploy.s.sol:Deploy --rpc-url <custom_rpc> --broadcast
   ```

2. **Update Registry**: Add chain ID and contract addresses to `deployments/registry.json`
   ```json
   {
     "NEW_CHAIN_ID": {
       "chainId": NEW_CHAIN_ID,
       "name": "New Network",
       "policyRegistry": "0x...",
       "validator": "0x...",
       "executor": "0x..."
     }
   }
   ```

3. **Configure Gateway**: Add executor addresses to environment
   ```env
   EXECUTOR_ADDRESSES={"NEW_CHAIN_ID":"0x..."}
   ```

4. **Done**: RPC URLs are automatically discovered from Chainlist if the network is listed there.

## Chainlist API

The gateway uses Chainlist's public JSON API:
- **Endpoint**: `https://chainlist.org/rpcs.json`
- **Format**: Array of chain objects with `chainId`, `rpc`, `name`, `nativeCurrency`, etc.
- **Caching**: Responses cached for 1 hour
- **Fallback**: If Chainlist is unavailable, uses configured fallback RPCs

## Supported Networks

Any EVM-compatible chain listed on Chainlist is automatically supported. The system has been tested with:

- Hyperion Testnet (133717)
- Metis Sepolia (59902)
- Metis Andromeda (1088)
- Mantle Testnet (5003)
- Mantle Mainnet (5000)
- Avalanche Fuji (43113)
- Avalanche C-Chain (43114)

## API Endpoints

### GET /chains

Returns all configured chains with metadata from Chainlist:

```json
{
  "chains": [
    {
      "chainId": 133717,
      "name": "Hyperion Testnet",
      "nativeCurrency": {
        "name": "METIS",
        "symbol": "METIS",
        "decimals": 18
      },
      "rpcUrls": ["https://..."],
      "explorers": [...],
      "contracts": {
        "executor": "0x...",
        "validator": "0x...",
        "policyRegistry": "0x..."
      }
    }
  ]
}
```

### GET /chains/:chainId

Returns metadata for a specific chain.

## References

- [Chainlist](https://chainlist.org) - Public RPC endpoint registry
- [Chainlist API](https://chainlist.org/rpcs.json) - JSON API for chain data
- [Chainlink Functions](https://docs.chain.link/chainlink-functions) - For advanced off-chain computation needs

