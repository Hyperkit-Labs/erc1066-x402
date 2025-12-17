# Python SDK Usage Guide

## Installation

The Python SDK is published to PyPI as `hyperkitlabs-erc1066-x402`.

### Install from PyPI

```bash
pip install hyperkitlabs-erc1066-x402
```

### Verify Installation

```bash
pip show hyperkitlabs-erc1066-x402
```

## Quick Start

```python
from erc1066_x402 import ERC1066Client

# Initialize client
client = ERC1066Client("http://localhost:3001")

# Create an intent
intent = {
    "sender": "0xa43b752b6e941263eb5a7e3b96e2e0dea1a586ff",
    "target": "0xf5cb11878b94c9cd0bfa2e87ce9d6e1768cea818",
    "data": "0x",
    "value": "0",
    "nonce": "1",
    "validAfter": "0",
    "validBefore": "18446744073709551615",
    "policyId": "0x0000000000000000000000000000000000000000000000000000000000000000",
}

# Validate intent
result = client.validate_intent(intent, chain_id=133717)
print(f"Status: {result['status']}")
print(f"Intent Hash: {result['intent_hash']}")

# Map status to action
action = client.map_status_to_action(result['status'])
print(f"Action: {action}")
```

## API Reference

### ERC1066Client

#### Constructor
```python
client = ERC1066Client(gateway_url: str)
```

#### Methods

**validate_intent(intent: dict, chain_id: int) -> dict**
- Validates an intent without executing it
- Returns: `{"status": str, "http_code": int, "intent_hash": str}`

**execute_intent(intent: dict, chain_id: int) -> dict**
- Executes a validated intent
- Returns: `{"status": str, "result": dict, ...}`

**map_status_to_action(status: str) -> str**
- Maps status code to action
- Returns: `"execute"`, `"retry"`, `"request_payment"`, or `"deny"`

## Example: Complete Workflow

```python
from erc1066_x402 import ERC1066Client

client = ERC1066Client("http://localhost:3001")

# Define intent
intent = {
    "sender": "0x...",
    "target": "0x...",
    "data": "0x...",
    "value": "0",
    "nonce": "1",
    "validAfter": "0",
    "validBefore": "18446744073709551615",
    "policyId": "0x...",
}

# Validate
validation = client.validate_intent(intent, chain_id=133717)
action = client.map_status_to_action(validation['status'])

if action == "execute":
    # Execute if valid
    execution = client.execute_intent(intent, chain_id=133717)
    print(f"Execution result: {execution}")
elif action == "request_payment":
    print("Payment required")
else:
    print(f"Intent denied: {validation['status']}")
```

## Testing

After installation, test the SDK:

```bash
# Install
pip install hyperkitlabs-erc1066-x402

# Test
python -c "from erc1066_x402 import ERC1066Client; print('✅ SDK works!')"
```

## Package Information

- **Package Name**: `hyperkitlabs-erc1066-x402`
- **Version**: `0.1.0`
- **PyPI URL**: https://pypi.org/project/hyperkitlabs-erc1066-x402/
- **Author**: HyperKit Labs
- **Email**: hyperkitdev@gmail.com

