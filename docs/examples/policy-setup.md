# Policy Setup Guide

## Common Policy Patterns

### 1. Basic Spending Policy

Allows spending up to 1 ETH per transaction:

```solidity
Policy memory policy = Policy({
    owner: msg.sender,
    allowedTargets: [],
    allowedSelectors: [],
    maxValuePerTx: 1 ether,
    maxAggregateValue: 0,
    validAfter: 0,
    validBefore: 0,
    allowedChains: []
});
```

### 2. Target-Restricted Policy

Only allows calls to specific contracts:

```solidity
address[] memory targets = new address[](2);
targets[0] = uniswapRouter;
targets[1] = aavePool;

Policy memory policy = Policy({
    owner: msg.sender,
    allowedTargets: targets,
    allowedSelectors: [],
    maxValuePerTx: 5 ether,
    maxAggregateValue: 0,
    validAfter: 0,
    validBefore: 0,
    allowedChains: []
});
```

### 3. Time-Limited Policy

Policy valid only for 30 days:

```solidity
Policy memory policy = Policy({
    owner: msg.sender,
    allowedTargets: [],
    allowedSelectors: [],
    maxValuePerTx: 1 ether,
    maxAggregateValue: 0,
    validAfter: block.timestamp,
    validBefore: block.timestamp + 30 days,
    allowedChains: []
});
```

### 4. Chain-Specific Policy

Only valid on specific chains:

```solidity
uint256[] memory chains = new uint256[](2);
chains[0] = 1; // Ethereum
chains[1] = 137; // Polygon

Policy memory policy = Policy({
    owner: msg.sender,
    allowedTargets: [],
    allowedSelectors: [],
    maxValuePerTx: 1 ether,
    maxAggregateValue: 0,
    validAfter: 0,
    validBefore: 0,
    allowedChains: chains
});
```

## Best Practices

1. Start with restrictive policies and relax as needed
2. Use time windows to limit exposure
3. Set reasonable value caps
4. Document policy purposes
5. Version policies by creating new policyIds

