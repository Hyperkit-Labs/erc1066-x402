# Hyperion Deployment Guide

## Network Details

- **Chain ID**: 133717
- **RPC URL**: https://hyperion-testnet.metisdevops.link
- **Currency**: METIS
- **Block Gas Limit**: 1100000000
- **Explorer**: TBD

## Prerequisites

- Foundry installed
- Hyperion testnet RPC URL
- Private key with testnet tokens

## Deployment Steps

1. Set environment variables:
```bash
export PRIVATE_KEY=your_private_key_here
```

2. Deploy contracts:
```bash
npm run deploy:hyperion:testnet
```

Or using Foundry directly:
```bash
forge script script/Deploy.s.sol:Deploy --rpc-url hyperion_testnet --broadcast --verify
```

3. Verify deployment addresses in console output

## Verification

After deployment, verify contracts on Hyperion explorer:
- PolicyRegistry
- SimpleSpendingValidator
- IntentExecutor

## Configuration

Update gateway configuration with deployed addresses in `packages/gateway/.env`:
- Add RPC URL for chain ID 133717
- Add contract addresses for executor, validator, and registry

## Gas Settings

- Gas Price: 1 gwei (1000000000)
- Gas Limit: 8000000
- Timeout: 120000 (2 minutes)
