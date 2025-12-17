# Deployment Guide

Step-by-step guide to deploy ERC-1066-x402 contracts to testnets.

## Prerequisites

1. **Foundry Installed**
   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   forge --version  # Verify installation
   ```

2. **Private Key with Testnet Tokens**
   - Export your private key as environment variable
   - Ensure the wallet has testnet tokens for gas fees

3. **Testnet Tokens**
   - Get testnet tokens from faucets:
     - **Hyperion Testnet**: Contact Metis DevOps
     - **Metis Sepolia**: Public faucet
     - **Mantle Testnet**: Mantle faucet
     - **Avalanche Fuji**: https://faucet.avalanche.network/

## Deployment Steps

### Step 1: Set Environment Variables

```bash
# Set your private key (NEVER commit this!)
# You can use with or without 0x prefix - both formats are supported
export PRIVATE_KEY=your_private_key_here
# OR
export PRIVATE_KEY=0xyour_private_key_here

# Verify it's set
echo $PRIVATE_KEY
```

**Security Note**: Never commit your private key. Use environment variables or a secure secret manager.

**Note**: The deployment scripts automatically handle PRIVATE_KEY with or without the `0x` prefix.

### Step 2: Choose Testnet

Select one of the supported testnets:

- **Hyperion Testnet** (Chain ID: 133717) - Recommended for Metis ecosystem
- **Metis Sepolia** (Chain ID: 59902) - Ethereum-compatible testnet
- **Mantle Testnet** (Chain ID: 5003) - Mantle ecosystem
- **Avalanche Fuji** (Chain ID: 43113) - Avalanche testnet

### Step 3: Deploy Contracts

#### Option A: Using NPM Scripts (Recommended)

```bash
# Deploy to Hyperion Testnet
npm run deploy:hyperion:testnet

# Deploy to Metis Sepolia
npm run deploy:metis:sepolia

# Deploy to Mantle Testnet
npm run deploy:mantle:testnet

# Deploy to Avalanche Fuji
npm run deploy:avalanche:fuji
```

#### Option B: Using Foundry Directly

```bash
# Hyperion Testnet
forge script script/Deploy.s.sol:Deploy \
  --rpc-url hyperion_testnet \
  --broadcast \
  --verify

# Metis Sepolia
forge script script/Deploy.s.sol:Deploy \
  --rpc-url metis_sepolia \
  --broadcast \
  --verify

# Mantle Testnet
forge script script/Deploy.s.sol:Deploy \
  --rpc-url mantle_testnet \
  --broadcast \
  --verify

# Avalanche Fuji
forge script script/Deploy.s.sol:Deploy \
  --rpc-url avalanche_fuji \
  --broadcast \
  --verify
```

### Step 4: Record Deployment Addresses

After deployment, you'll see output like:

```
PolicyRegistry deployed at: 0x1234567890123456789012345678901234567890
SimpleSpendingValidator deployed at: 0xabcdefabcdefabcdefabcdefabcdefabcdefabcd
IntentExecutor deployed at: 0x9876543210987654321098765432109876543210
Chain ID: 133717
```

**Save these addresses** - you'll need them for gateway configuration.

### Step 5: Update Deployment Registry

Update `deployments/registry.json` with your deployed addresses:

```json
{
  "133717": {
    "chainId": 133717,
    "name": "Hyperion Testnet",
    "policyRegistry": "0x1234567890123456789012345678901234567890",
    "validator": "0xabcdefabcdefabcdefabcdefabcdefabcdefabcd",
    "executor": "0x9876543210987654321098765432109876543210"
  }
}
```

### Step 6: Verify Deployment

1. **Check on Block Explorer**:
   - Hyperion: Check Metis explorer
   - Metis Sepolia: Check Sepolia explorer
   - Mantle: Check Mantle explorer
   - Avalanche Fuji: https://testnet.snowtrace.io

2. **Verify Contract Code**:
   - Contracts should be verified automatically if `--verify` flag was used
   - Check explorer for verified contract source code

3. **Test Contract Functions**:
   ```bash
   # Check PolicyRegistry owner
   cast call <REGISTRY_ADDRESS> "owner()" --rpc-url <RPC_URL>
   
   # Check IntentExecutor validator
   cast call <EXECUTOR_ADDRESS> "validator()" --rpc-url <RPC_URL>
   ```

## Quick Deployment Script

For quick deployment and registry update:

```bash
# Deploy and get JSON output
forge script script/helpers/UpdateRegistry.s.sol:UpdateRegistry \
  --rpc-url hyperion_testnet \
  --broadcast

# Copy the JSON output and update deployments/registry.json
```

## Multi-Chain Deployment

To deploy to multiple testnets:

```bash
# Deploy to each testnet separately
npm run deploy:hyperion:testnet
npm run deploy:metis:sepolia
npm run deploy:mantle:testnet
npm run deploy:avalanche:fuji
```

After each deployment, update `deployments/registry.json` with the addresses.

## Troubleshooting

### Error: "forge: command not found"
**Solution**: Install Foundry and ensure it's in your PATH
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### Error: "PRIVATE_KEY not set"
**Solution**: Export your private key
```bash
export PRIVATE_KEY=your_private_key
```

### Error: "Insufficient funds"
**Solution**: Get testnet tokens from faucets

### Error: "Contract verification failed"
**Solution**: 
- Check that the contract is deployed
- Verify RPC URL is correct
- Try manual verification on block explorer

### Error: "Nonce too high"
**Solution**: Reset nonce or wait for pending transactions

## Next Steps

After deployment:

1. **Configure Gateway**: Update `packages/gateway/.env` with contract addresses
2. **Create Policies**: Use PolicyRegistry to create test policies
3. **Test Validation**: Test intent validation via gateway
4. **Monitor**: Set up monitoring for contract events

See [Gateway Configuration](../integration/GATEWAY.md) for next steps.

