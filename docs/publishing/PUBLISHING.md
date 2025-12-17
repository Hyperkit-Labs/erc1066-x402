# Publishing SDKs

## Prerequisites

### For npm (TypeScript SDK)
1. npm account with access to `@hyperkit` organization
2. npm login: `npm login`
3. Verify: `npm whoami`

### For PyPI (Python SDK)
1. PyPI account: `hyperkitlabs`
2. API token from PyPI
3. Install build tools: `pip install build twine`

## Publishing TypeScript SDK

```bash
cd packages/sdk-ts

# Build the package
npm run build

# Verify package contents
npm pack --dry-run

# Publish to npm
npm publish --access public
```

**Package Name**: `@hyperkit/erc1066-x402-sdk`  
**Version**: `0.1.0`  
**Registry**: https://www.npmjs.com/package/@hyperkit/erc1066-x402-sdk

## Publishing Python SDK

```bash
cd packages/sdk-python

# Build the package
python -m build

# Verify package
python -m twine check dist/*

# Upload to PyPI (test first)
python -m twine upload --repository testpypi dist/*

# Upload to PyPI (production)
python -m twine upload dist/*
```

**Package Name**: `hyperkitlabs-erc1066-x402`  
**Version**: `0.1.0`  
**Registry**: https://pypi.org/project/hyperkitlabs-erc1066-x402/

## Verification After Publishing

### TypeScript SDK
```bash
npm install @hyperkit/erc1066-x402-sdk
```

### Python SDK
```bash
pip install hyperkitlabs-erc1066-x402
```

## Version Management

- Update version in `package.json` (TypeScript) or `setup.py`/`pyproject.toml` (Python)
- Follow semantic versioning: MAJOR.MINOR.PATCH
- Update CHANGELOG.md with changes

