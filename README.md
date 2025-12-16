## 1. Documentation
### 1.1. Overview
A set of Ethereum-compatible smart contracts that standardize **status codes**, **policy checks**, and **intent validation** for Web3 transactions, designed to integrate cleanly with an HTTP/x402 gateway and agent layer.

High‑level goals:

- Provide a **small, opinionated subset of ERC‑1066** status codes tailored to intents/AA/payments.  
- Standardize **pre-flight validation** (`canExecute`) for intents/txs with machine‑readable status.  
- Define **policy objects** (limits, permissions, chains, assets) enforceable at the contract level.  
- Be **modular** and **composable** with existing protocols: no lock‑in to specific chains or gateways.

***

### 1.2. Primary personas

1. **Protocol Devs / Integrators**
   - Want: simple interface to check if an intent/operation is allowed, and why it fails.
   - Outcome: fewer unexpected reverts, better UX, easier agent integrations.

2. **Agent / Wallet / AA Frameworks**
   - Want: machine-readable codes to decide: pay, retry, route elsewhere, ask user.
   - Outcome: more autonomous behavior and predictable flows.

3. **x402 / HTTP Gateway Developers**
   - Want: a direct mapping from onchain status → HTTP/x402 responses.
   - Outcome: consistent error/payment semantics across chains and services.

***

### 1.3. Core concepts

#### 1.3.1. Status codes (ERC‑1066–derived)

Define a **canonical subset** of ERC‑1066 codes for intents:

- **Generic**
  - `0x00` FAILURE  
  - `0x01` SUCCESS  

- **Authorization / Policy**
  - `0x10` DISALLOWED (policy or role denies)  
  - `0x11` ALLOWED (policy permits)  

- **Funds / Payment**
  - `0x54` INSUFFICIENT_FUNDS  
  - `0x50` TRANSFER_FAILED  
  - `0x51` TRANSFER_SUCCESSFUL  

- **Timing / State**
  - `0x20` TOO_EARLY (before start time / epoch)  
  - `0x21` TOO_LATE (after deadline / expiry)  

- **Application‑reserved**
  - `0xA0` INTENT_INVALID_FORMAT  
  - `0xA1` UNSUPPORTED_ACTION  
  - `0xA2` UNSUPPORTED_CHAIN  

These codes MUST be:

- Exposed as `bytes1` constants in a base contract.
- Returned by all validator functions and used in `revert` paths where appropriate.

***

#### 1.3.2. Intent model (onchain view)

Onchain contracts only need a **minimal, stable intent shape**, represented as a struct:

```solidity
struct Intent {
    address sender;          // original user / session key
    address target;          // contract to call
    bytes   data;            // calldata for target
    uint256 value;           // msg.value or token value
    uint256 nonce;           // replay protection
    uint256 validAfter;      // earliest timestamp
    uint256 validBefore;     // latest timestamp
    bytes32 policyId;        // reference to policy definition
}
```

The full off-chain/agent intent can be richer; the onchain layer just needs these fields.

***

#### 1.3.3. Policy model

Policies describe **who may do what, where, and how much**:

- `allowedTargets`: list / bitmap / registry of callable contracts.  
- `allowedSelectors`: optional restriction to specific function selectors.  
- `maxValuePerTx`: max ETH/token value per execution.  
- `maxAggregateValue`: optional rolling cap per period.  
- `allowedChains`: set of chain IDs (if relevant in cross-chain context).  
- `role` / `owner`: authority that can update / revoke policy.

Policies live as:

- Onchain storage in a `PolicyRegistry` contract, keyed by `policyId` (bytes32).
- Optionally, minimal hash references to off-chain expanded definitions (for future extension).

***

### 1.4. Functional requirements

#### FR1. Status code base

- FR1.1: Provide a `StatusCodes` contract exposing a set of `bytes1` constants representing the canonical subset (sec 1.3.1).
- FR1.2: Status codes MUST be used consistently across:
  - Intent validation,
  - Policy checks,
  - Execution wrappers.

#### FR2. Intent validation interface

- FR2.1: Define a standard interface:

```solidity
interface IIntentValidator {
    function canExecute(Intent calldata intent)
        external
        view
        returns (bytes1 status);
}
```

- FR2.2: `canExecute` MUST:
  - Validate time window (`validAfter`, `validBefore`).
  - Validate nonce (via an internal nonce manager or AA framework).
  - Validate policy via `PolicyRegistry`.
  - Optionally, simulate balance/allowance if applicable.
- FR2.3: If ANY check fails, `canExecute` MUST return a specific status code from the canonical set.

#### FR3. Policy registry

- FR3.1: Provide a `PolicyRegistry` contract with:
  - `function setPolicy(bytes32 policyId, Policy calldata policy)` only callable by admin/owner.
  - `function getPolicy(bytes32 policyId) external view returns (Policy memory)`.
- FR3.2: Policies MUST include at least:
  - Allowed targets / selectors,
  - Value caps,
  - Time constraints (optional, if different from intent’s).
- FR3.3: Policies MUST be immutable per `policyId` or versioned (e.g., new `policyId`) to avoid breaking intent signatures.

#### FR4. Execution wrapper

- FR4.1: Provide an `IntentExecutor` contract that:
  - Calls `canExecute(intent)` on a configured validator.
  - If status != `SUCCESS`, reverts with encoded status (e.g., custom error `ExecutionDenied(bytes1 status)`).
  - If status == `SUCCESS`, forwards call to `intent.target` with `intent.data` and `intent.value`.
- FR4.2: `IntentExecutor` MUST emit an event including:
  - `intentHash`,
  - `status`,
  - gasUsed (best effort),
  - any relevant metadata (chain ID, policyId).

#### FR5. Extensibility and composability

- FR5.1: The system MUST be deployable standalone (no hard dependency on specific AA framework).
- FR5.2: Validator MUST be pluggable:
  - Different deployments can swap validators (e.g., ERC‑4337, custom DEX policies).
- FR5.3: Contracts MUST be ERC‑165‑compatible for feature detection where appropriate.

***

### 1.5. Non-functional requirements

- NFR1: **Gas efficiency** validation and status checks should be cheaper than a failed onchain execution wherever possible.
- NFR2: **Auditability** code must be structured and documented with audits in mind; minimal complexity, clear separation between policy, status, and execution.
- NFR3: **Upgrade pattern** favor:
  - Versioned contracts or
  - Minimal proxies behind immutable interfaces, with careful upgrade governance.

***

## 2. Technical — Design & Implementation Notes

### 2.1. Contracts breakdown

**2.1.1. `StatusCodes.sol`**

- Pure library or abstract contract:
  - `bytes1 constant STATUS_SUCCESS = 0x01;`
  - `bytes1 constant STATUS_FAILURE = 0x00;`
  - etc.
- Optionally, helper functions:
  - `function isSuccess(bytes1 status) internal pure returns (bool)`
  - `function isFailure(bytes1 status) internal pure returns (bool)`

***

**2.1.2. `IntentTypes.sol`**

- Define `struct Intent` and `struct Policy`.
- Keep ABI stable; any change → new versioned file (`IntentTypesV2.sol`).

***

**2.1.3. `PolicyRegistry.sol`**

- Mapping: `mapping(bytes32 => Policy) private policies;`
- Access control:
  - `Ownable` or `AccessControl` (minimal) for admin.
- Events:
  - `event PolicySet(bytes32 indexed policyId, address indexed setter);`

***

**2.1.4. `BaseIntentValidator.sol`**

- Abstract contract implementing common checks:
  - Time window validation.
  - Chain ID / domain separation if relevant.
- Internal hooks:
  - `_checkPolicy(Intent calldata intent) internal view returns (bytes1);`
  - `_checkFunds(Intent calldata intent) internal view returns (bytes1);`
- Concrete validators (`AAIntentValidator.sol`, `DexIntentValidator.sol`) override hooks.

***

**2.1.5. `IntentExecutor.sol`**

- Holds reference to:
  - `IIntentValidator validator;`
- Flow:
  1. Compute `bytes32 intentHash = keccak256(abi.encode(intent));`
  2. Call `validator.canExecute(intent)`.
  3. If not success: `revert ExecutionDenied(status);`
  4. Execute low-level call:

     ```solidity
     (bool ok, bytes memory ret) = intent.target.call{value: intent.value}(intent.data);
     if (!ok) {
         revert ExecutionFailed(STATUS_TRANSFER_FAILED, ret);
     }
     ```

  5. Emit `IntentExecuted(intentHash, status, msg.sender);`

***

### 2.2. Status ↔ Behavior mapping

- `0x01` (SUCCESS): Execution allowed; gateway can treat as `200 OK` or app‑specific success.
- `0x54` (INSUFFICIENT_FUNDS): Contracts MUST NOT attempt execution; gateway maps to x402‑style “Payment Required / Insufficient balance”.
- `0x10` (DISALLOWED): Policy violation; gateway can show “Forbidden” (like HTTP 403).
- `0x20` (TOO_EARLY) & `0x21` (TOO_LATE): Gateway can indicate scheduling or expiry problems.

This mapping is explicitly documented in the off-chain spec, but the **onchain contracts only care about codes**.

***

### 2.3. Security considerations

- Nonces:
  - Either integrate with ERC‑4337 nonce semantics or maintain own `mapping(address => uint256) nonces`.
  - Validation MUST reject reused nonces with a dedicated status (consider `0x22 NONCE_USED`).

- Reentrancy:
  - `IntentExecutor` should use `nonReentrant` guard if it holds funds / complex state.
  - External target calls must be carefully sandboxed (no assumption about target behavior).

- Upgradability:
  - Treat validator/executor as versioned; don’t over‑engineer proxies at v1.
  - Emit clear events for version changes.

***

### 2.4. Testing strategy

- Unit tests (Foundry/Hardhat):
  - Status code correctness and invariants.
  - All branches of `canExecute` (per code path).
  - Policy changes and enforcement.
  - Executor behavior: success, each failure type, event emission.

- Integration tests:
  - Full flow: construct intent → `canExecute` → `execute` → verify onchain and emitted status.
  - Mock gateway that reads status and asserts expected HTTP/x402 mapping (even if off-chain, just to lock semantics).

***
