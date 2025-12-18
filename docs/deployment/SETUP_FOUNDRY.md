# Foundry Setup for Deployment

## Installing Foundry on Windows

### Option 1: Using Git Bash (Recommended)

```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash

# Add to PATH (add this to your ~/.bashrc or ~/.bash_profile)
export PATH="$HOME/.foundry/bin:$PATH"

# Reload shell or run:
source ~/.bashrc

# Verify installation
forge --version
```

### Option 2: Using WSL (Windows Subsystem for Linux)

```bash
# In WSL terminal
curl -L https://foundry.paradigm.xyz | bash
source $HOME/.bashrc
foundryup
forge --version
```

### Option 3: Manual Installation

1. Download Foundry from: https://github.com/foundry-rs/foundry/releases
2. Extract to a directory (e.g., `C:\foundry`)
3. Add to PATH:
   - Open System Properties → Environment Variables
   - Add `C:\foundry\bin` to PATH
4. Restart terminal

## Verify Installation

```bash
forge --version
cast --version
anvil --version
```

Expected output:
```
forge 0.2.0 (abc123 2024-01-01T00:00:00.000000000Z)
```

## Troubleshooting

### "forge: command not found"

**Solution 1**: Add Foundry to PATH
```bash
# In Git Bash
export PATH="$HOME/.foundry/bin:$PATH"

# Make permanent (add to ~/.bashrc)
echo 'export PATH="$HOME/.foundry/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Solution 2**: Use full path
```bash
# If Foundry is installed but not in PATH
~/.foundry/bin/forge --version
```

**Solution 3**: Reinstall Foundry
```bash
foundryup
```

### "Permission denied"

```bash
chmod +x ~/.foundry/bin/forge
```

## After Installation

Once Foundry is installed, you can proceed with deployments:

```bash
# Set your private key
export PRIVATE_KEY=your_private_key_here

# Deploy to networks
npm run deploy:metis:sepolia
npm run deploy:mantle:testnet
npm run deploy:avalanche:fuji
```

