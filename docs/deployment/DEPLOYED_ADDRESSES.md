# Deployed Contract Addresses

This document tracks deployed contract addresses across all networks.

## Hyperion Testnet (Chain ID: 133717)

**Deployment Date**: 2025-12-17  
**Deployer**: 0xa43B752B6E941263eb5A7E3b96e2e0DEA1a586Ff  
**Block**: 9956913

### Contracts

- **PolicyRegistry**: `0x92C73F9f972Bb0bdC8e3c5411345695F2E3710D0`
  - Transaction: `0x13bb282e1c38df09db65e05fdd28a95acb0534c18e881d72bc0340f116e8123f`
  - Gas Used: 654,553
  
- **SimpleSpendingValidator**: `0xE754b6Ce911511A0D7b3A5d2d367dB305B7a7f24`
  - Transaction: `0x2e9367e25816a64fd06930a29b81651be34f52c5a5e99940bf9f2cfde816c8d7`
  - Gas Used: 556,754
  - Constructor Arg: PolicyRegistry address
  
- **IntentExecutor**: `0xb078FaFE12dd9A9F2429b921Fe0fF5365AbA3cF7`
  - Transaction: `0xaafd3516dc712d0698e8457395223186bb4408d9ff36563ca0164dd95391b359`
  - Gas Used: 454,467
  - Constructor Arg: SimpleSpendingValidator address

### Verification Status

⚠️ **Note**: Contract verification failed because Sourcify doesn't support Chain 133717 yet. Contracts are deployed and functional. Manual verification can be done later when the chain is added to Sourcify or via the block explorer.

### Gateway Configuration

Update `packages/gateway/.env`:

```env
EXECUTOR_ADDRESSES={"133717":"0xb078FaFE12dd9A9F2429b921Fe0fF5365AbA3cF7"}
VALIDATOR_ADDRESSES={"133717":"0xE754b6Ce911511A0D7b3A5d2d367dB305B7a7f24"}
REGISTRY_ADDRESSES={"133717":"0x92C73F9f972Bb0bdC8e3c5411345695F2E3710D0"}
```

Or use the deployment registry:

```env
DEPLOYMENT_REGISTRY_PATH=./deployments/registry.json
```

## Other Networks

Deployments to other testnets will be added here as they are completed.

