# Overview
This plan implements the complete ERC-1066-x402 system: onchain smart contracts with testing, TypeScript gateway service, TypeScript/Python SDKs, and multi-chain deployment infrastructure. The system standardizes status codes, policy checks, and intent validation for Web3 transactions with HTTP/x402 gateway integration.

**Network-Agnostic Design**: The gateway uses [Chainlist](https://chainlist.org) for automatic RPC discovery, supporting any EVM-compatible chain without hardcoding network configurations. See [Network-Agnostic Architecture](../architecture/NETWORK_AGNOSTIC.md) for details.

# Architecture Overview

```mermaid
graph TB
    subgraph OffChain[Off-Chain Layer]
        Gateway[Gateway Service<br/>TypeScript/Fastify]
        SDK_TS[TypeScript SDK]
        SDK_PY[Python SDK]
        Agents[AI Agents/Wallets]
    end
    
    subgraph OnChain[On-Chain Layer]
        Executor[IntentExecutor]
        Validator[BaseIntentValidator]
        Registry[PolicyRegistry]
        StatusCodes[StatusCodes Library]
    end
    
    subgraph Networks[Blockchain Networks]
        Hyperion[Hyperion Testnet<br/>Chain ID: 133717]
        MetisSepolia[Metis Sepolia<br/>Chain ID: 59902]
        MetisMainnet[Metis Andromeda<br/>Chain ID: 1088]
        MantleTestnet[Mantle Testnet<br/>Chain ID: 5003]
        MantleMainnet[Mantle Mainnet<br/>Chain ID: 5000]
        AvalancheFuji[Avalanche Fuji<br/>Chain ID: 43113]
        AvalancheMainnet[Avalanche C-Chain<br/>Chain ID: 43114]
    end
    
    Agents --> SDK_TS
    Agents --> SDK_PY
    SDK_TS --> Gateway
    SDK_PY --> Gateway
    Gateway --> Executor
    Executor --> Validator
    Validator --> Registry
    Validator --> StatusCodes
    Executor --> Hyperion
    Executor --> MetisSepolia
    Executor --> MetisMainnet
    Executor --> MantleTestnet
    Executor --> MantleMainnet
    Executor --> AvalancheFuji
    Executor --> AvalancheMainnet
```

# Dependencies Between Phases

```mermaid
graph LR
    P1[Phase 1<br/>Onchain Foundation] --> P2[Phase 2<br/>Infrastructure]
    P1 --> P3[Phase 3<br/>Gateway]
    P2 --> P3
    P3 --> P4[Phase 4<br/>SDKs]
    P3 --> P5[Phase 5<br/>Integration]
    P4 --> P5
```