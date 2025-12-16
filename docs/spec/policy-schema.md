# HyperKit Policy Schema (Onchain View)

This file documents the onchain `Policy` schema used by `PolicyRegistry` and validators.
The off‑chain / agent representation can be richer, but MUST be compatible with this shape.

## Solidity Struct

```solidity
struct Policy {
    address owner;              // authority that controls the policy
    address[] allowedTargets;   // list of callable contracts
    bytes4[] allowedSelectors;  // optional restriction to specific function selectors
    uint256 maxValuePerTx;      // max value per execution
    uint256 maxAggregateValue;  // optional rolling cap per period (reserved for v2)
    uint256 validAfter;         // policy-level start time (0 = no lower bound)
    uint256 validBefore;        // policy-level end time (0 = no upper bound)
    uint256[] allowedChains;    // allowed chain IDs; empty = any
}
```

Notes:

- `owner` is the account (EOA, multisig, or governance contract) that conceptually owns the policy.
  The `PolicyRegistry` itself is `Ownable` and only its owner may set new policies.
- `allowedTargets` and `allowedSelectors` are optional. Empty arrays mean “no additional restrictions”
  at that dimension.
- `maxAggregateValue` is present in the struct for forward compatibility but is not enforced in
  `BaseIntentValidator` v1.

## JSON Representation (Example)

```json
{
  "policyId": "0x8e9f...abcd",
  "owner": "0xOwnerAddress...",
  "allowedTargets": [
    "0xDexContract...",
    "0xEntryPoint..."
  ],
  "allowedSelectors": [
    "0x38ed1739",
    "0x095ea7b3"
  ],
  "maxValuePerTx": "100000000000000000", 
  "maxAggregateValue": "0",
  "validAfter": 1734300000,
  "validBefore": 0,
  "allowedChains": [ 1, 5000 ]
}
```

### Field Semantics

- `policyId`  
  - Off‑chain identifier (bytes32 onchain) used to look up the policy in `PolicyRegistry`.
- `owner`  
  - Human‑readable mirror of the onchain `owner` field.
- `allowedTargets`  
  - Contracts that intents may target when referencing this policy.
- `allowedSelectors`  
  - Optional list of function selectors allowed on the targets. Empty means “any selector”.
- `maxValuePerTx`  
  - Maximum value (in wei or token base units) allowed per executed intent.
- `maxAggregateValue`  
  - Reserved for future use (rolling windows / quotas). Ignored in v1.
- `validAfter` / `validBefore`  
  - Optional policy‑level time window. If both are zero, only the intent‑level window applies.
- `allowedChains`  
  - List of supported `chainId`s. Empty means “any chain”.

## Registry Behaviour

- `setPolicy(policyId, policy)`:
  - May only be called once per `policyId` (policy immutability).
  - Emits `PolicySet(policyId, setter)` where `setter` is the `PolicyRegistry` owner.

- `getPolicy(policyId)`:
  - Reverts with `PolicyNotFound(policyId)` if no policy exists.

## Validator Expectations

- Validators SHOULD:
  - Enforce target and selector restrictions from `Policy`.
  - Enforce `maxValuePerTx` when `intent.value` is non‑zero.
  - Enforce `validAfter` / `validBefore` at both intent and policy levels.
  - Enforce `allowedChains` using `chainid()`.

- Validators MUST:
  - Return canonical `StatusCodes` values for all failures, per `status-codes.md`.


