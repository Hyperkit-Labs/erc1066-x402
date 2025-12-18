# Main Branch Preparation Guide

Follow these steps to synchronize the `develop` branch with the production `main` branch.

## 1. Final Synchronization
Before merging, ensure your local `develop` branch is up to date and clean.

```bash
git checkout develop
git pull origin develop
```

## 2. The Quality Sweep
Run the final validation suite to catch any regressions.

```bash
# Contract verification
forge test
forge fmt --check

# Gateway verification
cd packages/gateway
npm run build
npm run lint
```

## 3. Artifact Verification
Ensure no unwanted files have slipped into the staging area.

```bash
# Should return zero lines of build artifacts
git ls-files | grep -E "(target/|build/|dist/|__pycache__/)"
```

## 4. Documentation Freeze
Verify that all technical specifications in `specs/v2/` match the code implementation in:
- `contracts/intents/` (Solidity)
- `programs/solana-intents/` (Rust)
- `move/intent_framework/` (Move)

## 5. Merge Protocol
1. **Push**: `git push origin develop`
2. **PR**: Create Pull Request on GitHub.
3. **Review**: Wait for 2+ reviews and passing status checks.
4. **Merge**: Squash and merge into `main`.
5. **Tag**: `git tag -a v0.3.0 -m "Release v0.3.0: Multi-chain Expansion"`
