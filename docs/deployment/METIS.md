# Metis Deployment Guide

## Network Details

### Metis Sepolia Testnet
- **Chain ID**: 59902 (0xe9fe)
- **RPC URL**: https://metis-sepolia-rpc.publicnode.com
- **Currency**: tMETIS
- **Block Gas Limit**: Unknown
- **Explorer**: blockscout - https://sepolia-explorer.metisdevops.link

### Metis Andromeda Mainnet
- **Chain ID**: 1088 (0x440)
- **RPC URL**: https://andromeda.metis.io/?owner=1088
- **Currency**: METIS
- **Block Gas Limit**: 1100000000
- **Explorer**: https://andromeda-explorer.metis.io

## Prerequisites

- Foundry installed
- Metis RPC URL
- Private key with testnet tMETIS or mainnet METIS

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
# Fix: Metis Sepolia Deployment Not Broadcasting

## Problem

When deploying to Metis Sepolia, you see:
- Script runs successfully
- Addresses are printed
- But error: `Failed to get EIP-1559 fees; server returned an error response: error code -32601: the method eth_feeHistory does not exist/is not available`
- **Result**: Contracts are simulated but NOT actually deployed on-chain

## Root Cause

Metis Sepolia doesn't support `eth_feeHistory` (EIP-1559 fee history). Foundry tries to use EIP-1559 transactions by default, which fails on this network.

## Solution: Use Legacy Transactions

Deploy using legacy (non-EIP-1559) transactions with manual gas price:

### Option 1: Deploy with Legacy Gas (Recommended)

```bash
forge script script/Deploy.s.sol:Deploy \
  --rpc-url metis_sepolia \
  --broadcast \
  --legacy \
  --gas-price 1000000000 \
  --verify
```

### Option 2: Update NPM Script

Update `package.json`:

```json
{
  "scripts": {
    "deploy:metis:sepolia": "forge script script/Deploy.s.sol:Deploy --rpc-url metis_sepolia --broadcast --legacy --gas-price 1000000000 --verify"
  }
}
```

Then run:
```bash
npm run deploy:metis:sepolia
```

### Option 3: Use Foundry Config

Add to `foundry.toml`:

```toml
[profile.metis_sepolia]
gas_price = 1000000000  # 1 gwei
legacy = true
```

Then deploy:
```bash
forge script script/Deploy.s.sol:Deploy \
  --rpc-url metis_sepolia \
  --broadcast \
  --verify \
  --with-gas-price 1000000000 \
  --legacy
```

## Verify Deployment

After deploying, verify contracts exist:

```bash
# Check if contract has code
cast code 0xc11E8CA852f945FfCb11e3ff9F1E677867E1E7a8 --rpc-url metis_sepolia

# Should return bytecode (not "0x")
```

## Gas Price Reference

- **1 gwei** = 1000000000 wei (recommended for Metis Sepolia)
- Check current gas price: `cast gas-price --rpc-url metis_sepolia`

## Expected Output

After successful deployment, you should see:

```
## Setting up 1 EVM.
==========================
Chain 59902
Estimated gas price: 1.0 gwei
Estimated total gas used for script: ...
Estimated amount required: ... tMETIS
==========================

##### metis-sepolia
✅  [Success] Hash: 0x...
Contract Address: 0x...
Block: ...
Paid: ... tMETIS (... gas * ... gwei)
```

## Notes

- Legacy transactions work on all EVM chains
- Gas price of 1 gwei is typically sufficient for testnets
- Verification may still fail (expected), but contracts will be deployed
- Check explorer to confirm: https://sepolia-explorer.metisdevops.link



