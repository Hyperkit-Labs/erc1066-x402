# Main Branch Readiness Checklist

Use this checklist before merging `develop` into `main` to ensure the project meets all quality and security standards.

## 1. Automated Quality Gates
- [x] **Contract Tests**: All 38 Foundry tests pass (`forge test`).
- [x] **Gateway Tests**: Integration tests for EVM, Solana, and Sui pass.
- [x] **Formatting**: All files pass linting (`forge fmt --check`, `npm run lint`).
- [x] **Security**: Slither scan shows zero critical vulnerabilities.

## 2. Multi-Chain Verification
- [x] **Solana Program**: Compiled with Anchor 0.30.1 and deployed to Devnet.
- [x] **Sui Module**: Published to Testnet and verified with dry-runs.
- [x] **Gateway Adapters**: Verified simulation logic for all three runtimes.

## 3. Documentation & Specs
- [x] **Specs**: `specs/v1` and `specs/v2` are complete and accurate.
- [x] **README**: High-level overview, status mapping, and quick start are updated.
- [x] **Getting Started**: Toolchain prerequisites (Solana/Sui) are documented.

## 4. Final Review
- [x] **Build Artifacts**: Verified `.gitignore` blocks `target/`, `build/`, and `dist/`.
- [x] **Secrets**: Verified no `.env` or private keys are committed.
- [x] **Versioning**: Root `package.json` and SDK manifests match release targets.

## 5. Pre-Merge Command
```bash
# Final local check
forge test && forge fmt --check && npm run lint
```
