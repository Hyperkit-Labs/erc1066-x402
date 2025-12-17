# Branch Setup Guide

This guide explains how to set up the `develop` branch and configure branch protection rules.

## Creating the Develop Branch

### Step 1: Create Branch Locally

```bash
# Ensure you're on main and up to date
git checkout main
git pull origin main

# Create develop branch from main
git checkout -b develop

# Push to remote
git push -u origin develop
```

### Step 2: Set Default Branch (Optional)

If you want `develop` to be the default branch for new PRs:

1. Go to GitHub repository settings
2. Navigate to "Branches"
3. Set default branch to `develop` (or keep `main` as default)

## Branch Protection Rules

### Setting Up Protection Rules

#### Option 1: Using GitHub Web Interface

1. Go to repository **Settings** → **Branches**
2. Click **Add rule** or **Edit** existing rule

#### Option 2: Using GitHub CLI

```bash
# Install GitHub CLI if needed
# brew install gh (macOS)
# Or download from https://cli.github.com

# Authenticate
gh auth login

# Set branch protection for main
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["test","lint","security"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":2,"dismiss_stale_reviews":true}' \
  --field restrictions=null \
  --field required_linear_history=true

# Set branch protection for develop (less strict)
gh api repos/:owner/:repo/branches/develop/protection \
  --method PUT \
  --field required_status_checks='{"strict":false,"contexts":["test"]}' \
  --field enforce_admins=false \
  --field required_pull_request_reviews='{"required_approving_review_count":1}' \
  --field restrictions=null
```

### Recommended Protection Rules

#### Main Branch

```yaml
Protection Rules:
  ✅ Require pull request reviews before merging
    - Required approving reviewers: 2
    - Dismiss stale reviews: Yes
    - Require review from Code Owners: Yes
  
  ✅ Require status checks to pass before merging
    - Required checks:
      - test (contract tests)
      - lint (formatting check)
      - security (Slither scan)
    - Require branches to be up to date: Yes
  
  ✅ Require linear history
  ✅ Do not allow force pushes
  ✅ Do not allow deletions
  ✅ Include administrators: Yes
```

#### Develop Branch

```yaml
Protection Rules:
  ✅ Require pull request reviews before merging
    - Required approving reviewers: 1
    - Dismiss stale reviews: No
  
  ✅ Require status checks to pass before merging
    - Required checks:
      - test (non-blocking)
    - Require branches to be up to date: No
  
  ✅ Allow force pushes (for maintainers only)
  ✅ Do not allow deletions
  ✅ Include administrators: No
```

## Updating CI Workflow

The CI workflow (`.github/workflows/ci.yml`) already supports both `main` and `develop` branches. No changes needed.

However, you may want to add branch-specific behavior:

```yaml
# Example: Different test coverage requirements
- name: Check coverage
  run: |
    if [ "${{ github.ref }}" == "refs/heads/main" ]; then
      # Stricter coverage for main
      forge coverage --report lcov
      # Check coverage threshold
    else
      # Basic coverage for develop
      forge coverage
    fi
```

## CODEOWNERS File

Create or update `.github/CODEOWNERS` to require reviews from specific teams:

```
# Global owners
* @hyperkit-labs/core-team

# Contract-specific
/contracts/ @hyperkit-labs/solidity-team

# Gateway-specific
/packages/gateway/ @hyperkit-labs/backend-team

# SDK-specific
/packages/sdk-ts/ @hyperkit-labs/frontend-team
/packages/sdk-python/ @hyperkit-labs/backend-team

# Documentation
/docs/ @hyperkit-labs/core-team
```

## Verification

### Test Branch Protection

1. **Create a test PR:**
   ```bash
   git checkout -b test/protection
   # Make a small change
   git commit -m "test: verify branch protection"
   git push origin test/protection
   ```

2. **Create PR to main:**
   - Should require 2 approvals
   - Should require all CI checks to pass
   - Should not allow direct merge

3. **Create PR to develop:**
   - Should require 1 approval
   - Should allow merge with passing tests

### Verify CI Runs

Check that CI runs on:
- ✅ Pushes to `main`
- ✅ Pushes to `develop`
- ✅ PRs to `main`
- ✅ PRs to `develop`
- ✅ Feature branches

## Migration Checklist

- [ ] Create `develop` branch from `main`
- [ ] Push `develop` to remote
- [ ] Set up branch protection for `main`
- [ ] Set up branch protection for `develop`
- [ ] Update `.github/CODEOWNERS` (if needed)
- [ ] Verify CI runs on both branches
- [ ] Test PR process
- [ ] Update documentation links
- [ ] Notify team of new workflow

## Next Steps

After setting up branches:

1. **Update team workflow:**
   - Feature branches → `develop`
   - `develop` → `main` (after testing)

2. **Document workflow:**
   - See [Development Guide](./DEVELOPMENT.md)

3. **Set up release process:**
   - Use `release/*` branches for version releases
   - Tag releases on `main`

## Troubleshooting

### "Branch is not protected"

- Verify protection rules are set in GitHub Settings
- Check that you have admin access
- Ensure branch exists on remote

### "CI not running"

- Check `.github/workflows/ci.yml` includes branch
- Verify GitHub Actions is enabled
- Check workflow file syntax

### "Can't merge PR"

- Verify all required checks passed
- Ensure required reviewers approved
- Check branch is up to date with target

## Resources

- [GitHub Branch Protection Docs](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches)
- [Development Guide](./DEVELOPMENT.md)
- [Contributing Guide](../CONTRIBUTING.md)

