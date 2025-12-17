# Basic Usage Examples

## Creating a Policy

```solidity
PolicyRegistry registry = PolicyRegistry(registryAddress);

bytes32 policyId = keccak256("my-policy");
Policy memory policy = Policy({
    owner: msg.sender,
    allowedTargets: [targetAddress],
    allowedSelectors: [],
    maxValuePerTx: 1 ether,
    maxAggregateValue: 0,
    validAfter: 0,
    validBefore: 0,
    allowedChains: []
});

registry.setPolicy(policyId, policy);
```

## Creating an Intent

```solidity
Intent memory intent = Intent({
    sender: userAddress,
    target: targetContract,
    data: callData,
    value: 0.5 ether,
    nonce: 0,
    validAfter: block.timestamp,
    validBefore: block.timestamp + 1 days,
    policyId: policyId
});
```

## Validating an Intent

```solidity
bytes1 status = validator.canExecute(intent);
require(status == StatusCodes.STATUS_SUCCESS, "Intent validation failed");
```

## Executing an Intent

```solidity
executor.execute{value: intent.value}(intent);
```

