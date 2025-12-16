# HyperStatus Onchain Architecture

## Layer Model

```
┌─────────────────────────────────────────────────────────┐
│  Off-chain: Gateway / x402 / HTTP Layer                 │
│  ┌──────────────────────────────────────────────────┐   │
│  │ Maps ERC-1066 codes → HTTP/x402 responses       │   │
│  │ Headers: X-Status-Code, X-Payment-Required      │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
           ▲                                        ▼
           │                                        │
     [Intent JSON]                          [Status Code]
           │                                        │
           │                                        │
┌─────────────────────────────────────────────────────────┐
│  Onchain: Smart Contract Layer (HyperStatus)            │
│                                                          │
│  ┌──────────────────┐      ┌─────────────────────┐     │
│  │ StatusCodes.sol  │      │  IntentTypes.sol    │     │
│  │                  │      │                     │     │
│  │ bytes1 codes:    │      │ struct Intent       │     │
│  │ 0x01 SUCCESS     │      │ struct Policy       │     │
│  │ 0x10 DISALLOWED  │      │ intentHash()        │     │
│  │ 0x20 TOO_EARLY   │      │                     │     │
│  │ 0x54 INSUFFICIENT│      │                     │     │
│  │ ... (11 total)   │      │                     │     │
│  └──────────────────┘      └─────────────────────┘     │
│           ▲                          ▲                   │
│           │                          │                   │
│           └──────────────┬───────────┘                   │
│                          │                               │
│          ┌───────────────────────────┐                  │
│          │ IIntentValidator (I)      │                  │
│          │                           │                  │
│          │ canExecute(Intent)        │                  │
│          │   → bytes1 status         │                  │
│          └───────────────┬───────────┘                  │
│                          ▲                               │
│        ┌─────────────────┼──────────────────┐           │
│        │                 │                  │           │
│  ┌──────────────┐  ┌─────────────────┐  ┌──────────┐   │
│  │PolicyRegistry│  │BaseIntentValidator│ │SimpleSpending
│  │              │  │                 │  │Validator │   │
│  │mapping       │  │_checkIntentTime │  │          │   │
│  │ policyId →   │  │_checkPolicy     │  │_checkFunds  │
│  │ Policy       │  │_checkFunds      │  │(sender.bal) │
│  │              │  │                 │  │          │   │
│  │setPolicy()   │  │Implementation   │  │Concrete  │   │
│  │getPolicy()   │  │example          │  │validator │   │
│  └──────────────┘  └────────┬────────┘  └──────────┘   │
│                             │                           │
│                    ┌────────▼──────────┐                │
│                    │ IntentExecutor    │                │
│                    │                   │                │
│                    │ execute(Intent)   │                │
│                    │  1. canExecute()  │                │
│                    │  2. Verify status │                │
│                    │  3. target.call() │                │
│                    │  4. Emit event    │                │
│                    │                   │                │
│                    │ canExecute()      │                │
│                    │  (preflight check)                │
│                    └───────────────────┘                │
│                                                          │
└─────────────────────────────────────────────────────────┘
           ▲                                        ▼
           │                                        │
    [Intent calldata]                      [IntentExecuted event]
           │                                        │
           │                                        │
┌─────────────────────────────────────────────────────────┐
│  Target Contracts                                        │
│  (Uniswap, Curve, DEX routers, AA entrypoints, etc)    │
└─────────────────────────────────────────────────────────┘
```

---

## Data Flow

### Validation Flow (Read-only)

```
Client/Agent
     ↓
Create Intent (off-chain)
     ↓
Call IntentExecutor.canExecute(intent)
     ↓
IntentExecutor delegates to validator
     ↓
Validator.canExecute(intent):
  ├─ _checkIntentTime(intent)
  │   └─ block.timestamp in [validAfter, validBefore]?
  ├─ _checkPolicy(intent.policyId):
  │   ├─ PolicyRegistry.getPolicy(policyId)
  │   ├─ Policy time valid?
  │   ├─ Target in allowedTargets?
  │   ├─ Selector in allowedSelectors?
  │   ├─ Value ≤ maxValuePerTx?
  │   └─ Chain in allowedChains?
  └─ _checkFunds(intent):
      └─ (Override in concrete validator)
     ↓
Returns bytes1 status code
     ↓
Client receives status:
  - 0x01 (SUCCESS) → Safe to execute
  - 0x10 (DISALLOWED) → Policy violation
  - 0x20 (TOO_EARLY) → Retry later
  - 0x54 (INSUFFICIENT_FUNDS) → Trigger x402 payment
  - etc.
```

### Execution Flow

```
Client/Agent
     ↓
Call IntentExecutor.execute(intent)
     ↓
IntentExecutor:
  1. validator.canExecute(intent)
  2. If status != SUCCESS:
       └─ revert ExecutionDenied(status)
  3. If status == SUCCESS:
       ├─ Compute intentHash
       ├─ Call target.call{value}(data)
       ├─ If call fails:
       │   └─ revert ExecutionFailed(STATUS_TRANSFER_FAILED, ret)
       └─ On success:
           └─ emit IntentExecuted(hash, status, executor, ret, gasUsed)
     ↓
Returns (status, returnData)
     ↓
Client/Agent handles result
```

---

## Policy Lifecycle

```
1. Admin creates a Policy struct:
   ┌────────────────────────────────┐
   │ owner: 0xAdmin                 │
   │ allowedTargets: [Uniswap, ...]  │
   │ maxValuePerTx: 1 ether          │
   │ validAfter: now                 │
   │ validBefore: now + 90 days      │
   └────────────────────────────────┘
   
2. Admin calls PolicyRegistry.setPolicy(policyId, policy)
   └─ Stored immutably in registry
   └─ Emits PolicySet event
   
3. Intent references this policyId
   ┌────────────────────────────────┐
   │ sender: 0xUser                 │
   │ target: Uniswap                │
   │ policyId: 0xabc...             │
   │ value: 0.5 ether               │
   └────────────────────────────────┘
   
4. Validator looks up policy and enforces it
   └─ Checks all policy constraints
   └─ Returns appropriate status code
   
5. Update policy? Create new policyId with new Policy
   └─ Old policyId remains immutable
   └─ New intents use new policyId
```

---

## Status Code Semantics

```
StatusCodes Library
    ↓
Used by:
    ├─ Validators: return from canExecute()
    ├─ Executor: check if execution allowed
    └─ Events: emitted with IntentExecuted/ExecutionDenied

Mapped to HTTP/x402 (gateway layer):
    ├─ 0x01 SUCCESS        → 200 OK
    ├─ 0x10 DISALLOWED     → 403 Forbidden
    ├─ 0x20 TOO_EARLY      → 202 Accepted (retry later)
    ├─ 0x21 TOO_LATE       → 410 Gone (expired)
    ├─ 0x54 INSUFFICIENT   → 402 Payment Required (x402)
    ├─ 0xA2 UNSUPPORTED    → 421 Misdirected Request
    └─ Other failures      → 400/500
    
    Plus custom header:
    X-Status-Code: 0x54
    X-Payment-Required: true
```

---

## Validator Hierarchy

```
IIntentValidator (Interface)
    ↓
BaseIntentValidator (Abstract)
    ├─ Implements common checks:
    │   ├─ _checkIntentTime()
    │   ├─ _checkPolicy()
    │   ├─ _checkFunds() [virtual hook]
    │   └─ Helpers: _isTargetAllowed, _isSelectorAllowed, _isChainAllowed
    │
    └─ Subclasses (concrete):
        ├─ SimpleSpendingValidator (example)
        │   └─ _checkFunds(): verify sender.balance >= intent.value
        │
        ├─ AAIntentValidator (AA-style nonce + policy)
        ├─ DexIntentValidator (slippage + oracle checks)
        ├─ CrossChainValidator (bridge + destination checks)
        └─ ... (custom validators per domain)
```

---

## Integration Points

### 1. With x402 Gateway

```
Gateway receives Intent JSON (off-chain)
    ↓
Calls IntentExecutor.canExecute(intent) [view call]
    ↓
Returns bytes1 status
    ↓
Gateway maps to HTTP/x402:
    ├─ status = 0x01 → return 200 OK
    ├─ status = 0x54 → return 402 Payment Required
    │   ├─ Add X-Payment-Required header
    │   └─ Include payment details (amount, token, chain)
    ├─ status = 0x20 → return 202 Accepted
    └─ etc.
    ↓
Client receives HTTP response + status code header
```

### 2. With AI Agents

```
Agent evaluates Intent
    ↓
Calls canExecute() to preflight
    ↓
Reads status code:
    ├─ SUCCESS → Execute immediately
    ├─ TOO_EARLY → Schedule retry
    ├─ INSUFFICIENT_FUNDS → Request payment
    ├─ DISALLOWED → Inform user
    └─ etc.
    ↓
Agent makes autonomous decision
```

### 3. With AA / Session Keys

```
Session Key policy stored as Intent
    ↓
User creates Intent referencing session key's policyId
    ↓
BaseIntentValidator enforces limits:
    ├─ Value cap
    ├─ Allowed targets/selectors
    ├─ Time window
    └─ Chain
    ↓
AA bundler verifies and executes
```

---

## Extensibility

```
New Validator? → Extend BaseIntentValidator
                └─ Override _checkFunds()
                └─ Implement canExecute() if needed
                
New Status Codes? → Use reserved ranges (0x30–0x9F, 0xB0–0xFF)
                └─ Document in StatusCodes.sol
                └─ Update gateway mapping
                
New Policy Fields? → Create IntentTypesV2.sol
                  └─ Deploy new PolicyRegistryV2
                  └─ Validators can check both versions
                  
Multi-chain? → Keep allowedChains field in Policy
           └─ Validators check block.chainid
           └─ Deploy same IntentExecutor on all chains
```

---

## Security Model

```
On-chain:
  ├─ PolicyRegistry: Only owner can setPolicy (immutable per policyId)
  ├─ IntentExecutor: ReentrancyGuard on execute()
  ├─ Validators: View functions, no state mutations
  └─ Status codes: Deterministic, no side effects

Off-chain:
  ├─ Intent signatures: Can be added by client (not in current version)
  ├─ x402 payment: Handled by facilitator (Coinbase, etc.)
  └─ Gateway: Standard HTTPS + TLS

Trust model:
  ├─ Smart contracts: Auditable, on-chain logic
  ├─ Policies: Owned by delegating authority
  ├─ Gateway: Trusted intermediary for x402 + status mapping
  └─ Agent: Autonomous but constrained by policies
```

---

## Next: Adding Tests

Create `test/intents/` with:

```
test/
├── StatusCodes.t.sol
│   └─ Test: isSuccess(), isFailure() helpers
│
├── PolicyRegistry.t.sol
│   └─ Test: setPolicy, getPolicy, immutability, events
│
├── BaseIntentValidator.t.sol
│   └─ Test: all checks (time, policy, funds, chain, etc.)
│
├── IntentExecutor.t.sol
│   └─ Test: canExecute, execute, events, reverts
│
└── SimpleSpendingValidator.t.sol
    └─ Test: balance checks, integration with executor
```

Run: `forge test`