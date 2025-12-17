# Supported Networks

This document lists all supported blockchain networks for ERC-1066-x402 deployment.

## Testnets

### Hyperion Testnet
- **Chain ID**: 133717
- **RPC URL**: https://hyperion-testnet.metisdevops.link
- **Currency**: METIS
- **Block Gas Limit**: 1100000000
- **Gas Price**: 1 gwei
- **Deployment Command**: `npm run deploy:hyperion:testnet`

### Metis Sepolia
- **Chain ID**: 59902
- **RPC URL**: https://metis-sepolia-rpc.publicnode.com
- **Currency**: METIS
- **Gas Price**: 1 gwei
- **Deployment Command**: `npm run deploy:metis:sepolia`

### Mantle Testnet
- **Chain ID**: 5003
- **RPC URL**: https://rpc.sepolia.mantle.xyz
- **Currency**: MNT
- **Gas Price**: 1 gwei
- **Deployment Command**: `npm run deploy:mantle:testnet`

### Avalanche Fuji
- **Chain ID**: 43113 (0xa869)
- **RPC URL**: https://api.avax-test.network/ext/bc/C/rpc
- **Currency**: AVAX
- **Block Gas Limit**: 15000000
- **Explorers**:
  - https://testnet.snowscan.xyz
  - https://testnet.snowtrace.io
  - https://testnet.avascan.info
- **Deployment Command**: `npm run deploy:avalanche:fuji`

## Mainnets

### Metis Andromeda Mainnet
- **Chain ID**: 1088 (0x440)
- **RPC URL**: https://andromeda.metis.io/?owner=1088
- **Currency**: METIS
- **Block Gas Limit**: 1100000000
- **Explorer**: https://andromeda-explorer.metis.io
- **Deployment Command**: `npm run deploy:metis:mainnet`

### Mantle Mainnet
- **Chain ID**: 5000
- **RPC URL**: https://rpc.mantle.xyz
- **Currency**: MNT
- **Gas Price**: 1 gwei
- **Deployment Command**: `npm run deploy:mantle:mainnet`

### Avalanche C-Chain
- **Chain ID**: 43114 (0xa86a)
- **RPC URL**: https://api.avax.network/ext/bc/C/rpc
- **Currency**: AVAX
- **Block Gas Limit**: 24000000
- **Explorers**:
  - https://snowscan.xyz
  - https://snowtrace.io
  - https://avascan.info
- **Deployment Command**: `npm run deploy:avalanche:mainnet`

## Common Deployment Settings

All networks use the following default settings:
- **Gas Price**: 1 gwei (1000000000)
- **Gas Limit**: 8000000
- **Timeout**: 120000 (2 minutes)

## Multi-Chain Deployment

To deploy to all testnets, run the deployment script for each chain individually:

```bash
# Hyperion Testnet
forge script script/DeployMultiChain.s.sol:DeployMultiChain --rpc-url hyperion_testnet --broadcast

# Metis Sepolia
forge script script/DeployMultiChain.s.sol:DeployMultiChain --rpc-url metis_sepolia --broadcast

# Mantle Testnet
forge script script/DeployMultiChain.s.sol:DeployMultiChain --rpc-url mantle_testnet --broadcast

# Avalanche Fuji
forge script script/DeployMultiChain.s.sol:DeployMultiChain --rpc-url avalanche_fuji --broadcast
```

Or use the npm scripts:

```bash
npm run deploy:hyperion:testnet
npm run deploy:metis:sepolia
npm run deploy:mantle:testnet
npm run deploy:avalanche:fuji
```

Deployment addresses will be logged to console and should be recorded in `deployments/registry.json`.

