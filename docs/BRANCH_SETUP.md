# Branch Setup & Governance

This guide documents the branch strategy and governance rules for the ERC-1066-x402 project.

## 1. Branch Strategy

We follow a structured branch strategy to ensure `main` is always production-ready.

### `main` Branch
- **Purpose**: Stable, production-ready code.
- **Protection**: 
  - Direct pushes forbidden.
  - Requires PR from `develop`.
  - Requires 2+ approvals.
  - All CI checks must pass (tests, lint, security).

### `develop` Branch
- **Purpose**: Integration branch for new features.
- **Protection**:
  - Requires PR from `feature/*` or `fix/*`.
  - Requires 1+ approval.
  - All unit tests must pass.

### `feature/*` and `fix/*` Branches
- **Purpose**: Short-lived branches for development.
- **Workflow**: Created from `develop`, merged back to `develop` via PR.

## 2. Setup Commands

### Create Develop Branch
```bash
git checkout main
git pull origin main
git checkout -b develop
git push -u origin develop
```

## 3. GitHub Protection Rules (YAML Example)

```yaml
# main branch rules
protection:
  required_pull_request_reviews:
    required_approving_review_count: 2
    dismiss_stale_reviews: true
  required_status_checks:
    strict: true
    contexts:
      - "test (contract)"
      - "lint"
      - "security (slither)"
  enforce_admins: true
```

## 4. CODEOWNERS

We use a `.github/CODEOWNERS` file to automate review requests.

```text
# Core Architecture
* @Hyperkit-Labs/core-team

# Smart Contracts
/contracts/ @Hyperkit-Labs/solidity-leads

# Multi-Chain Adapters
/packages/gateway/src/adapters/ @Hyperkit-Labs/integration-team
```
