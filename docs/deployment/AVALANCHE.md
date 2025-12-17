# Avalanche Deployment Guide

## Network Details

### Avalanche Fuji Testnet
- **Chain ID**: 43113 (0xa869)
- **RPC URL**: https://api.avax-test.network/ext/bc/C/rpc
- **Currency**: AVAX
- **Block Gas Limit**: 15000000
- **Explorers**:
  - Etherscan: https://testnet.snowscan.xyz
  - Routescan: https://testnet.snowtrace.io
  - Avascan: https://testnet.avascan.info

### Avalanche C-Chain Mainnet
- **Chain ID**: 43114 (0xa86a)
- **RPC URL**: https://api.avax.network/ext/bc/C/rpc
- **Currency**: AVAX
- **Block Gas Limit**: 24000000
- **Explorers**:
  - Etherscan: https://snowscan.xyz
  - Routescan: https://snowtrace.io
  - Avascan: https://avascan.info

## Prerequisites

- Foundry installed
- Avalanche RPC URL
- Private key with testnet/mainnet AVAX

## Deployment Steps

### Testnet (Fuji)

1. Set environment variables:
```bash
export PRIVATE_KEY=your_private_key_here
```

2. Deploy contracts:
```bash
npm run deploy:avalanche:fuji
```

### Mainnet (C-Chain)

1. Set environment variables:
```bash
export PRIVATE_KEY=your_private_key_here
```

2. Deploy contracts:
```bash
npm run deploy:avalanche:mainnet
```

3. Verify deployment addresses in console output

## Verification

After deployment, verify contracts on Avalanche explorer:
- PolicyRegistry
- SimpleSpendingValidator
- IntentExecutor

## Configuration

Update gateway configuration with deployed addresses in `packages/gateway/.env`:
- Add RPC URLs for chain IDs 43113 (testnet) and 43114 (mainnet)
- Add contract addresses for executor, validator, and registry

