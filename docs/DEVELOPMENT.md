# Development Guide

This guide explains the development workflow, branch strategy, and contribution process for ERC-1066-x402.

## Branch Strategy

We use a **Git Flow-inspired** workflow with protected branches:

```
main (production-ready)
  ↓ (only via PR after testing)
develop (integration branch)
  ↓ (feature branches merge here)
feature/* (individual work)
```

### Branch Types

#### `main` Branch
- **Purpose**: Production-ready code
- **Protection**: 
  - ✅ Requires 2+ code reviews
  - ✅ All CI checks must pass
  - ✅ No direct pushes allowed
  - ✅ Linear history required
- **Merge Policy**: Only from `develop` via Pull Request
- **Status**: Always deployable

#### `develop` Branch
- **Purpose**: Integration branch for feature development
- **Protection**: 
  - ✅ CI runs but doesn't block
  - ✅ Can be unstable during development
- **Merge Policy**: Feature branches merge here first
- **Status**: May be unstable

#### `feature/*` Branches
- **Purpose**: Individual feature development
- **Naming**: `feature/description` (e.g., `feature/custom-networks`)
- **Lifespan**: Short-lived (<2 weeks)
- **Merge Policy**: Merge to `develop` for integration testing
- **Examples**:
  - `feature/gateway-metrics`
  - `feature/multi-chain-support`
  - `feature/sdk-improvements`

#### `fix/*` Branches
- **Purpose**: Bug fixes
- **Naming**: `fix/description` (e.g., `fix/rpc-timeout`)
- **Merge Policy**: Can merge directly to `main` for hotfixes, or to `develop` for regular fixes

#### `release/*` Branches (Optional)
- **Purpose**: Release preparation
- **Naming**: `release/v1.0.0`
- **Merge Policy**: Merge to `main` when ready, then tag

## Development Workflow

### Starting a New Feature

1. **Create feature branch from `develop`:**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/your-feature-name
   ```

2. **Develop and commit:**
   ```bash
   # Make your changes
   git add .
   git commit -m "feat: add your feature"
   git push origin feature/your-feature-name
   ```

3. **Create Pull Request:**
   - Target: `develop`
   - Fill out PR template
   - Wait for CI to pass
   - Request reviews

4. **After approval, merge:**
   - Use "Squash and merge" for clean history
   - Delete feature branch after merge

### Merging to Main

1. **Ensure `develop` is stable:**
   ```bash
   git checkout develop
   git pull origin develop
   npm test  # Run all tests locally
   ```

2. **Create PR from `develop` to `main`:**
   - Target: `main`
   - Requires 2+ approvals
   - All CI checks must pass
   - Update CHANGELOG.md

3. **After merge:**
   - Tag release: `git tag v1.0.0`
   - Push tags: `git push --tags`

## Code Quality Standards

### Solidity

- Follow [Solidity Style Guide](https://docs.soliditylang.org/en/latest/style-guide.html)
- Use 4 spaces for indentation
- Maximum line length: 120 characters
- Add NatSpec comments for all public functions
- Test coverage: 90%+ for contracts

### TypeScript/JavaScript

- Follow [TypeScript style guide](https://google.github.io/styleguide/tsguide.html)
- Use 2 spaces for indentation
- Maximum line length: 100 characters
- Use ESLint and Prettier
- Test coverage: 80%+ for gateway/SDKs

### Python

- Follow [PEP 8](https://pep8.org/)
- Use 4 spaces for indentation
- Maximum line length: 100 characters
- Type hints for all functions
- Test coverage: 80%+

## Testing Requirements

### Before Submitting PR

- [ ] All existing tests pass: `npm test`
- [ ] New code has tests
- [ ] Test coverage meets requirements
- [ ] Integration tests pass (if applicable)
- [ ] Manual testing completed

### Running Tests

```bash
# All tests
npm test

# Contract tests only
forge test

# Gateway tests
cd packages/gateway && npm test

# SDK tests
cd packages/sdk-ts && npm test
cd packages/sdk-python && python -m pytest
```

## Commit Messages

We use [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc.)
- `refactor:` Code refactoring
- `test:` Adding or updating tests
- `chore:` Maintenance tasks
- `perf:` Performance improvements

**Examples:**
```
feat: add custom network support
fix: handle RPC timeout errors
docs: update deployment guide
test: add integration tests for gateway
```

## Pull Request Process

### PR Checklist

- [ ] Code follows style guidelines
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] CHANGELOG.md updated (if applicable)
- [ ] Commit messages follow convention
- [ ] Branch is up to date with target

### PR Template

When creating a PR, include:

1. **Description**: What does this PR do?
2. **Changes**: List of changes
3. **Testing**: How was this tested?
4. **Screenshots**: If UI changes
5. **Breaking Changes**: Any breaking changes?

### Review Process

1. **Automated Checks**: CI runs automatically
2. **Code Review**: 2+ reviewers required for `main`
3. **Approval**: All reviewers must approve
4. **Merge**: Squash merge preferred

## CI/CD Pipeline

### GitHub Actions Workflows

- **CI** (`.github/workflows/ci.yml`):
  - Runs on: `main`, `develop`, `feature/*`
  - Tests: Contract tests, linting, security scans
  - Coverage: Uploads to Codecov

- **Release** (`.github/workflows/release.yml`):
  - Runs on: Tags
  - Builds: Packages for npm/PyPI
  - Publishes: Automatically (if configured)

### Local CI Simulation

```bash
# Run all CI checks locally
npm run lint
npm test
npm run test:coverage
```

## Branch Protection Rules

### Main Branch

- ✅ Require pull request reviews (2+)
- ✅ Require status checks to pass
- ✅ Require branches to be up to date
- ✅ Require linear history
- ✅ Do not allow force pushes
- ✅ Do not allow deletions

### Develop Branch

- ✅ Require pull request reviews (1+)
- ✅ Require status checks to pass (non-blocking)
- ✅ Allow force pushes (for maintainers)

## Release Process

1. **Prepare Release:**
   ```bash
   git checkout develop
   git pull origin develop
   # Update version in package.json, setup.py, etc.
   # Update CHANGELOG.md
   ```

2. **Create Release Branch:**
   ```bash
   git checkout -b release/v1.0.0
   git push origin release/v1.0.0
   ```

3. **Test Release:**
   - Run full test suite
   - Deploy to testnet
   - Verify all components

4. **Merge to Main:**
   ```bash
   git checkout main
   git merge release/v1.0.0
   git tag v1.0.0
   git push origin main --tags
   ```

5. **Publish:**
   - SDKs publish automatically via CI
   - Or manually: `npm publish` / `twine upload`

## Getting Help

- **Questions**: Open a GitHub Discussion
- **Bugs**: Open a GitHub Issue
- **Features**: Open a GitHub Issue with "enhancement" label
- **Security**: Email security@hyperkit-labs.com (see CONTRIBUTING.md)

## Resources

- [Contributing Guide](../CONTRIBUTING.md)
- [Code of Conduct](../CODE_OF_CONDUCT.md)
- [Architecture Overview](./reference/Overview.md)
- [Testing Guide](./testing/README.md)

