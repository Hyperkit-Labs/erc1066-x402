# Documentation Structure

This document describes the organization of all documentation files.

## Directory Structure

```
docs/
├── README.md                          # Main documentation index
├── QUICK_START_COMPLETE.md           # Complete step-by-step guide
│
├── architecture/                      # Architecture documentation
│   └── NETWORK_AGNOSTIC.md           # Network-agnostic design
│
├── api/                              # API documentation
│   └── README.md                     # API reference
│
├── changelog/                        # Changelog entries
│   ├── README.md                     # Changelog index
│   └── CHANGELOG_NETWORK_AGNOSTIC.md # Network-agnostic update
│
├── deployment/                       # Deployment guides
│   ├── DEPLOYMENT_GUIDE.md          # Main deployment guide
│   ├── DEPLOYED_ADDRESSES.md        # Contract addresses
│   ├── DEPLOYMENT_SUCCESS.md        # Deployment success summary
│   ├── NETWORKS.md                  # Network configuration
│   ├── HYPERION.md                  # Hyperion network guide
│   ├── METIS.md                     # Metis network guide
│   ├── MANTLE.md                    # Mantle network guide
│   └── AVALANCHE.md                 # Avalanche network guide
│
├── examples/                         # Usage examples
│   ├── basic-usage.md               # Basic usage examples
│   └── policy-setup.md              # Policy setup examples
│
├── integration/                      # Integration guides
│   ├── GATEWAY.md                   # Gateway integration
│   ├── CUSTOM_NETWORKS.md           # Custom networks guide
│   └── AGENTS.md                    # AI agent integration
│
├── publishing/                       # Publishing documentation
│   ├── README.md                    # Publishing index
│   ├── PUBLISHING.md                # General publishing guide
│   ├── PUBLISHING_STATUS.md         # Current publication status
│   └── NPM_PUBLISH_2FA.md           # npm 2FA solutions
│
├── reference/                        # Reference documentation
│   ├── Overview.md                  # Project overview
│   ├── architecture.md             # Detailed architecture
│   └── Stack.md                     # Technology stack
│
├── sdk/                              # SDK documentation
│   ├── README.md                    # SDK index
│   ├── PYTHON_SDK_USAGE.md          # Python SDK usage guide
│   └── PYTHON_SDK_SUCCESS.md         # Python SDK status
│
├── spec/                             # Specifications
│   ├── status-codes.md              # Status code definitions
│   └── policy-schema.md             # Policy schema
│
└── testing/                          # Testing documentation
    ├── README.md                    # Testing index
    ├── TEST_RESULTS.md              # System test results
    └── PYTHON_SDK_TEST_RESULTS.md   # Python SDK tests
```

## Categories

### Architecture
Documents system design, architecture decisions, and technical design patterns.

### Deployment
Step-by-step guides for deploying contracts to various networks.

### Integration
Guides for integrating the system with gateways, agents, and custom networks.

### Publishing
Documentation for publishing SDKs to npm and PyPI.

### SDK
SDK-specific documentation, usage guides, and examples.

### Testing
Test results, test procedures, and verification documentation.

### Changelog
Historical changes and major updates to the system.

## Quick Navigation

- **Getting Started**: [QUICK_START_COMPLETE.md](./QUICK_START_COMPLETE.md)
- **Deploying**: [deployment/DEPLOYMENT_GUIDE.md](./deployment/DEPLOYMENT_GUIDE.md)
- **Using SDKs**: [sdk/](./sdk/)
- **Publishing**: [publishing/](./publishing/)
- **Testing**: [testing/](./testing/)

