# Troubleshooting Guide

Common issues and solutions for ERC-1066-x402.

## Installation Issues

### "forge: command not found"

**Problem:** Foundry is not installed or not in PATH.

**Solution:**
```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Verify installation
forge --version
```

**Windows:** Use Git Bash or WSL. Foundry doesn't support native Windows yet.

### "node: command not found"

**Problem:** Node.js is not installed or wrong version.

**Solution:**
```bash
# Using nvm (recommended)
nvm install 18
nvm use 18

# Or download from nodejs.org
# Verify version
node --version  # Should be 18.0.0 or higher
```

### "npm install" fails

**Problem:** Dependency installation issues.

**Solution:**
```bash
# Clear cache
npm cache clean --force

# Remove node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

## Deployment Issues

### "PRIVATE_KEY not set"

**Problem:** Environment variable not configured.

**Solution:**
```bash
# Option 1: Export in terminal
export PRIVATE_KEY=your_private_key_here

# Option 2: Create .env file (ensure it's in .gitignore)
echo "PRIVATE_KEY=your_private_key_here" > .env

# Note: 0x prefix is optional, scripts handle it automatically
```

### "Insufficient funds for gas"

**Problem:** Wallet doesn't have testnet tokens.

**Solution:**
- **Hyperion Testnet**: Contact Metis DevOps team
- **Metis Sepolia**: Use public faucet
- **Mantle Testnet**: Use Mantle faucet
- **Avalanche Fuji**: https://faucet.avalanche.network/

### "Transaction reverted"

**Problem:** Contract deployment failed.

**Solutions:**
1. **Check gas limit:**
   ```bash
   # Increase gas limit in foundry.toml
   [profile.default]
   gas_limit = 30000000
   ```

2. **Verify RPC endpoint:**
   ```bash
   # Test RPC connection
   cast block-number --rpc-url hyperion_testnet
   ```

3. **Check contract addresses:**
   - Ensure previous deployments are correct
   - Verify dependencies are deployed first

### "Nonce too high"

**Problem:** Transaction nonce mismatch.

**Solution:**
```bash
# Reset nonce (use with caution)
# Or wait for pending transactions to confirm
```

## Gateway Issues

### "Port 3001 already in use"

**Problem:** Another process is using port 3001.

**Solution:**
```bash
# Option 1: Find and kill process
lsof -ti:3001 | xargs kill

# Option 2: Use different port
# Edit packages/gateway/.env
PORT=3002
```

### "Gateway won't start"

**Problem:** Configuration or dependency issues.

**Solutions:**
1. **Check .env file exists:**
   ```bash
   cd packages/gateway
   ls -la .env  # Should exist
   ```

2. **Verify contract addresses:**
   ```bash
   # Check .env has valid JSON
   cat .env | grep EXECUTOR_ADDRESSES
   ```

3. **Check dependencies:**
   ```bash
   cd packages/gateway
   npm install
   ```

4. **Check logs:**
   ```bash
   npm run dev
   # Look for error messages
   ```

### "Chain not found" error

**Problem:** Chain ID not configured.

**Solution:**
```bash
# Add chain to .env
EXECUTOR_ADDRESSES={"133717":"0x...","59902":"0x..."}
VALIDATOR_ADDRESSES={"133717":"0x...","59902":"0x..."}
REGISTRY_ADDRESSES={"133717":"0x...","59902":"0x..."}
```

### "RPC endpoint unreachable"

**Problem:** RPC URL is incorrect or network is down.

**Solution:**
1. **Check Chainlist:**
   - Visit https://chainlist.org
   - Verify chain ID and RPC URLs

2. **Use custom RPC:**
   ```bash
   # Add to .env
   RPC_URLS={"133717":"https://custom-rpc.example.com"}
   ```

3. **Disable Chainlist:**
   ```bash
   # In .env
   USE_CHAINLIST=false
   RPC_URLS={"133717":"https://rpc.example.com"}
   ```

## SDK Issues

### Python: "Module not found"

**Problem:** Package not installed or wrong environment.

**Solution:**
```bash
# Install package
pip install hyperkitlabs-erc1066-x402

# Or install from source
cd packages/sdk-python
pip install -e .

# Verify installation
python -c "from erc1066_x402 import ERC1066Client; print('OK')"
```

### TypeScript: "Cannot find module"

**Problem:** Package not installed or TypeScript not configured.

**Solution:**
```bash
# Install dependencies
cd packages/sdk-ts
npm install

# Build package
npm run build

# Verify
npm test
```

### "TypeError: Cannot read property"

**Problem:** SDK version mismatch or incorrect usage.

**Solution:**
1. **Update SDK:**
   ```bash
   pip install --upgrade hyperkitlabs-erc1066-x402
   npm update @hyperkit/erc1066-x402-sdk
   ```

2. **Check API usage:**
   - Review [SDK Documentation](./sdk/)
   - Check examples

## Testing Issues

### "Tests fail locally but pass in CI"

**Problem:** Environment differences.

**Solution:**
```bash
# Use same Node version as CI
nvm use 18

# Clear cache
npm cache clean --force
rm -rf node_modules
npm install

# Run tests
npm test
```

### "Forge test fails"

**Problem:** Foundry configuration or dependency issues.

**Solution:**
```bash
# Update Foundry
foundryup

# Reinstall dependencies
forge install

# Clean and rebuild
forge clean
forge build
forge test
```

## Network Issues

### "RPC timeout"

**Problem:** RPC endpoint is slow or overloaded.

**Solution:**
1. **Use multiple RPCs:**
   ```bash
   # In .env
   RPC_URLS_ARRAY={"133717":["https://rpc1.com","https://rpc2.com"]}
   ```

2. **Increase timeout:**
   - Edit gateway configuration
   - Or use faster RPC provider

### "Chain ID mismatch"

**Problem:** Wrong chain ID in configuration.

**Solution:**
```bash
# Verify chain ID
cast chain-id --rpc-url hyperion_testnet

# Update configuration with correct chain ID
```

## Build Issues

### "TypeScript compilation errors"

**Problem:** Type errors or missing types.

**Solution:**
```bash
# Install types
npm install --save-dev @types/node

# Check tsconfig.json
# Ensure all dependencies are installed
npm install
```

### "Solidity compilation errors"

**Problem:** Version mismatch or missing imports.

**Solution:**
```bash
# Check Solidity version in foundry.toml
# Update if needed

# Reinstall dependencies
forge install

# Clean and rebuild
forge clean
forge build
```

## Getting More Help

If you're still stuck:

1. **Check Documentation:**
   - [Getting Started](../GETTING_STARTED.md)
   - [Deployment Guide](./deployment/DEPLOYMENT_GUIDE.md)
   - [API Reference](./api/README.md)

2. **Search Issues:**
   - [GitHub Issues](https://github.com/hyperkit-labs/erc1066-x402/issues)
   - Search for similar problems

3. **Ask for Help:**
   - Open a GitHub Discussion
   - Create a new Issue with:
     - Error message
     - Steps to reproduce
     - Environment details (OS, Node version, etc.)

4. **Check Logs:**
   - Gateway logs: `packages/gateway/logs/`
   - Test output: Run with `--verbose` flag

