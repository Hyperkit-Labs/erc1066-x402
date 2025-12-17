# Mantle Deployment Guide

## Network Details

### Mantle Testnet
- **Chain ID**: 5003
- **RPC URL**: https://rpc.sepolia.mantle.xyz
- **Currency**: MNT
- **Explorer**: TBD

### Mantle Mainnet
- **Chain ID**: 5000
- **RPC URL**: https://rpc.mantle.xyz
- **Currency**: MNT
- **Explorer**: TBD

## Prerequisites

- Foundry installed
- Mantle RPC URL
- Private key with testnet/mainnet MNT

## Deployment Steps

### Testnet

1. Set environment variables:
```bash
export PRIVATE_KEY=your_private_key_here
```

2. Deploy contracts:
```bash
npm run deploy:mantle:testnet
```

Or using Foundry directly:
```bash
forge script script/Deploy.s.sol:Deploy --rpc-url mantle_testnet --broadcast --verify
```

### Mainnet

1. Set environment variables:
```bash
export PRIVATE_KEY=your_private_key_here
```

2. Deploy contracts:
```bash
npm run deploy:mantle:mainnet
```

Or using Foundry directly:
```bash
forge script script/Deploy.s.sol:Deploy --rpc-url mantle_mainnet --broadcast --verify
```

3. Verify deployment addresses in console output

## Verification

After deployment, verify contracts on Mantle explorer:
- PolicyRegistry
- SimpleSpendingValidator
- IntentExecutor

## Configuration

Update gateway configuration with deployed addresses in `packages/gateway/.env`:
- Add RPC URLs for chain IDs 5003 (testnet) and 5000 (mainnet)
- Add contract addresses for executor, validator, and registry

## Gas Settings

- Gas Price: 1 gwei (1000000000)
- Gas Limit: 8000000
- Timeout: 120000 (2 minutes)

