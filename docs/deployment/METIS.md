# Metis Deployment Guide

## Network Details

### Metis Sepolia Testnet
- **Chain ID**: 59902
- **RPC URL**: https://metis-sepolia-rpc.publicnode.com
- **Currency**: METIS
- **Explorer**: TBD

### Metis Andromeda Mainnet
- **Chain ID**: 1088 (0x440)
- **RPC URL**: https://andromeda.metis.io/?owner=1088
- **Currency**: METIS
- **Block Gas Limit**: 1100000000
- **Explorer**: https://andromeda-explorer.metis.io

## Prerequisites

- Foundry installed
- Metis RPC URL
- Private key with testnet/mainnet METIS

## Deployment Steps

### Testnet (Sepolia)

1. Set environment variables:
```bash
export PRIVATE_KEY=your_private_key_here
```

2. Deploy contracts:
```bash
npm run deploy:metis:sepolia
```

### Mainnet (Andromeda)

1. Set environment variables:
```bash
export PRIVATE_KEY=your_private_key_here
```

2. Deploy contracts:
```bash
npm run deploy:metis:mainnet
```

3. Verify deployment addresses in console output

## Verification

After deployment, verify contracts on Metis explorer:
- PolicyRegistry
- SimpleSpendingValidator
- IntentExecutor

## Configuration

Update gateway configuration with deployed addresses in `packages/gateway/.env`:
- Add RPC URLs for chain IDs 59902 (testnet) and 1088 (mainnet)
- Add contract addresses for executor, validator, and registry

## Gas Settings

- Gas Price: 1 gwei (1000000000)
- Gas Limit: 8000000
- Timeout: 120000 (2 minutes)

