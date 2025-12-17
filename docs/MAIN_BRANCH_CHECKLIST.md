# Main Branch Readiness Checklist

Use this checklist before merging `develop` to `main` to ensure production-ready code.

## Pre-Merge Verification

### 1. Tests & Quality

- [ ] **All tests pass:**
  ```bash
  forge test
  npm test
  ```

- [ ] **Code formatting:**
  ```bash
  forge fmt --check
  npm run lint
  ```

- [ ] **No compilation errors:**
  ```bash
  forge build
  npm run build
  ```

- [ ] **Security scans pass:**
  - Slither analysis (if configured)
  - Dependabot alerts resolved
  - No known vulnerabilities

### 2. Build Artifacts

- [ ] **No build artifacts committed:**
  ```bash
  git ls-files | grep -E "(dist/|out/|cache/|node_modules/|\.egg-info|__pycache__)"
  ```
  Should return nothing or only intentionally tracked files.

- [ ] **Build outputs excluded in .gitignore:**
  - `packages/*/dist/`
  - `packages/*/build/`
  - `packages/*/*.egg-info/`
  - `packages/*/__pycache__/`
  - `out/`, `cache/`, `broadcast/`

### 3. Secrets & Environment

- [ ] **No .env files committed:**
  ```bash
  git ls-files | grep "\.env"
  ```
  Should return nothing.

- [ ] **No API keys or tokens:**
  - Check `.npmrc` files (should be in .gitignore)
  - Check configuration files for hardcoded secrets
  - Verify all secrets use environment variables

### 4. Documentation

- [ ] **README.md updated:**
  - Current features documented
  - Installation instructions accurate
  - Examples work

- [ ] **CHANGELOG.md updated:**
  - All changes since last release documented
  - Version number updated
  - Breaking changes highlighted

- [ ] **API documentation current:**
  - Gateway API endpoints documented
  - SDK usage examples updated
  - Contract interfaces documented

### 5. Version Numbers

- [ ] **Version numbers updated:**
  - `package.json` (root)
  - `packages/gateway/package.json`
  - `packages/sdk-ts/package.json`
  - `packages/sdk-python/setup.py`
  - `packages/sdk-python/pyproject.toml`
  - `CHANGELOG.md`

### 6. CI/CD

- [ ] **All CI checks pass:**
  - Tests pass in CI
  - Linting passes
  - Security scans pass
  - Build succeeds

- [ ] **GitHub Actions workflows:**
  - CI workflow runs successfully
  - Release workflow configured (if applicable)
  - Deployment workflows tested

### 7. Dependencies

- [ ] **Dependencies up to date:**
  - `foundry.lock` committed (Foundry dependencies)
  - `package-lock.json` in .gitignore (as configured)
  - Submodules initialized (`lib/openzeppelin-contracts`)

- [ ] **No vulnerable dependencies:**
  - Run `npm audit` (if applicable)
  - Check Dependabot alerts

### 8. Code Review

- [ ] **2+ code reviews approved:**
  - All requested reviewers approved
  - All review comments addressed
  - No blocking issues

- [ ] **PR description complete:**
  - Changes summarized
  - Breaking changes documented
  - Testing performed

## Required Files on Main

### ✅ Must Have

**Source Code:**
- `contracts/` - All smart contracts
- `test/` - Contract tests
- `tests/` - Integration tests
- `script/` - Deployment scripts
- `packages/gateway/src/` - Gateway source
- `packages/sdk-ts/src/` - TypeScript SDK source
- `packages/sdk-python/erc1066_x402/` - Python SDK source

**Configuration:**
- `foundry.toml` - Foundry config
- `foundry.lock` - Foundry lock file
- `package.json` - Root package.json
- `.gitignore` - Git ignore rules
- `.gitmodules` - Submodule config

**Documentation:**
- `README.md` - Main README
- `GETTING_STARTED.md` - Getting started guide
- `CONTRIBUTING.md` - Contribution guidelines
- `CHANGELOG.md` - Changelog
- `LICENSE` - License file
- `docs/` - All documentation

**CI/CD:**
- `.github/workflows/` - GitHub Actions
- `.github/CODEOWNERS` - Code ownership
- `.github/pull_request_template.md` - PR template

**Deployment:**
- `deployments/registry.json` - Deployment addresses

**Assets:**
- `public/banner/` - Banner images

### ❌ Must NOT Have

**Build Artifacts:**
- `out/` - Foundry build output
- `cache/` - Foundry cache
- `broadcast/` - Deployment artifacts
- `packages/*/dist/` - Compiled JavaScript
- `packages/*/build/` - Build outputs
- `packages/*/*.egg-info/` - Python build info
- `packages/*/__pycache__/` - Python cache

**Dependencies:**
- `node_modules/` - NPM packages
- `lib/` - Foundry libs (except submodules)

**Secrets:**
- `.env` - Environment variables
- `.env.*` - Any env files
- `**/.npmrc` - NPM config with tokens

**IDE:**
- `.vscode/` - VS Code settings
- `.idea/` - IntelliJ settings
- `.cursor/` - Cursor AI (optional)

**Temporary:**
- `*.log` - Log files
- `*.tmp` - Temporary files
- `.DS_Store` - OS files
- `Thumbs.db` - OS files

## Quick Verification Commands

```bash
# Check for build artifacts
git ls-files | grep -E "(dist/|out/|cache/|node_modules/|\.egg-info|__pycache__)"

# Check for secrets
git ls-files | grep "\.env"

# Check for IDE files
git ls-files | grep -E "(\.vscode|\.idea|\.cursor)"

# Verify tests pass
forge test
npm test

# Check formatting
forge fmt --check

# Verify no uncommitted changes
git status
```

## Pre-Merge Script

Run this before creating PR:

```bash
#!/bin/bash
# Pre-merge verification script

echo "🔍 Checking build artifacts..."
if git ls-files | grep -qE "(dist/|out/|cache/|node_modules/)"; then
    echo "❌ Build artifacts found in git!"
    exit 1
fi

echo "🔍 Checking for secrets..."
if git ls-files | grep -q "\.env"; then
    echo "❌ .env files found in git!"
    exit 1
fi

echo "🔍 Running tests..."
forge test || exit 1

echo "🔍 Checking formatting..."
forge fmt --check || exit 1

echo "✅ All checks passed!"
```

## After Merge to Main

1. **Tag the release:**
   ```bash
   git tag v1.0.0
   git push --tags
   ```

2. **Update deployment registry:**
   - Update `deployments/registry.json` with new addresses
   - Commit to main

3. **Publish packages (if applicable):**
   - TypeScript SDK: `npm publish`
   - Python SDK: `twine upload dist/*`

4. **Create GitHub release:**
   - Use tag as release
   - Include changelog
   - Attach release notes

## Emergency Rollback

If issues found after merge:

```bash
# Revert last commit
git revert HEAD

# Or reset to previous commit (if no one has pulled)
git reset --hard HEAD~1
git push --force-with-lease origin main
```

**Warning:** Only use `--force` if you're certain no one has pulled the changes.

