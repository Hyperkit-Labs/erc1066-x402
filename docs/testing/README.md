# Testing Documentation

This directory contains test results and testing documentation.

## Contents

- [Test Results](./TEST_RESULTS.md) - Complete system test results
- [Python SDK Tests](./PYTHON_SDK_TEST_RESULTS.md) - Python SDK installation and functionality tests

## Test Status

### System Tests
- ✅ Gateway endpoints functional
- ✅ Intent validation working
- ✅ Custom networks configured
- ✅ Contracts deployed successfully

### SDK Tests
- ✅ Python SDK: Published and tested
- ⏳ TypeScript SDK: Builds successfully, pending publication

## Running Tests

### Gateway Tests
```bash
cd packages/gateway
npm test
```

### SDK Tests
```bash
# Python
cd packages/sdk-python
python test_installed.py

# TypeScript
cd packages/sdk-ts
npm test
```

### Integration Tests
```bash
./script/test/IntegrationTest.sh
```

