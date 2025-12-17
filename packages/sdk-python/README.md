# ERC-1066-x402 Python SDK

Python SDK for interacting with the ERC-1066-x402 gateway. Provides a simple interface for validating and executing intents across multiple blockchain networks.

## Installation

```bash
pip install hyperkitlabs-erc1066-x402
```

## Quick Start

### Basic Usage

```python
from erc1066_x402 import ERC1066Client, Intent

# Initialize client
client = ERC1066Client('http://localhost:3000')

# Create an intent
intent = Intent(
    sender='0xa43b752b6e941263eb5a7e3b96e2e0dea1a586ff',
    target='0xf5cb11878b94c9cd0bfa2e87ce9d6e1768cea818',
    data='0x',
    value='0',
    nonce='1',
    validAfter='0',
    validBefore='18446744073709551615',
    policyId='0x0000000000000000000000000000000000000000000000000000000000000000'
)

# Validate intent
result = client.validate_intent(intent, chain_id=133717)
print(f"Status: {result.status}")
print(f"Intent Hash: {result.intentHash}")

# Map status to action
action = client.map_status_to_action(result.status)
print(f"Action: {action}")

# Execute if valid
if action == 'execute':
    execution = client.execute_intent(intent, chain_id=133717)
    print(f"Execution result: {execution}")
```

## API Reference

### ERC1066Client

Main client class for interacting with the gateway.

#### Constructor

```python
client = ERC1066Client(gateway_url: str)
```

- `gateway_url`: Base URL of the gateway service (e.g., `http://localhost:3000`)

#### Methods

**validate_intent(intent: Intent, chain_id: int) -> ValidateResponse**

Validates an intent without executing it.

- `intent`: Intent object to validate
- `chain_id`: Chain ID to validate on
- Returns: `ValidateResponse` with status, HTTP code, and intent hash

**execute_intent(intent: Intent, chain_id: int) -> ExecuteResponse**

Executes a validated intent.

- `intent`: Intent object to execute
- `chain_id`: Chain ID to execute on
- Returns: `ExecuteResponse` with status and result

**map_status_to_action(status: StatusCode) -> Action**

Maps a status code to an action.

- `status`: Status code (e.g., `"0x01"`)
- Returns: Action string (`"execute"`, `"retry"`, `"request_payment"`, or `"deny"`)

## Complete Example

```python
from erc1066_x402 import ERC1066Client, Intent

# Initialize
client = ERC1066Client("http://localhost:3000")

# Create intent
intent = Intent(
    sender="0x...",
    target="0x...",
    data="0x...",
    value="0",
    nonce="1",
    validAfter="0",
    validBefore="18446744073709551615",
    policyId="0x..."
)

# Validate
validation = client.validate_intent(intent, chain_id=133717)
action = client.map_status_to_action(validation.status)

# Handle based on action
if action == "execute":
    result = client.execute_intent(intent, chain_id=133717)
    print(f"Executed: {result}")
elif action == "request_payment":
    print("Payment required")
elif action == "retry":
    print("Retry later")
else:
    print(f"Denied: {validation.status}")
```

## Status Codes

Common status codes:

- `0x01` - SUCCESS (execute allowed)
- `0x10` - DISALLOWED (policy violation)
- `0x54` - INSUFFICIENT_FUNDS (payment required)
- `0x20` - TOO_EARLY (before valid time)
- `0x21` - TOO_LATE (after valid time)

See [Status Codes Specification](../../docs/spec/status-codes.md) for complete list.

## Error Handling

```python
from erc1066_x402 import ERC1066Client, Intent
import requests

client = ERC1066Client("http://localhost:3000")

try:
    result = client.validate_intent(intent, chain_id=133717)
except requests.exceptions.RequestException as e:
    print(f"Request failed: {e}")
except Exception as e:
    print(f"Error: {e}")
```

## More Examples

See [examples/](./examples/) directory for:
- Basic usage examples
- Agent integration examples
- Error handling patterns

## Troubleshooting

### Import Errors

```bash
# Ensure package is installed
pip install hyperkitlabs-erc1066-x402

# Verify installation
python -c "from erc1066_x402 import ERC1066Client; print('OK')"
```

### Connection Errors

- Verify gateway is running: `curl http://localhost:3000/health`
- Check gateway URL is correct
- Ensure network connectivity

See [Troubleshooting Guide](../../docs/TROUBLESHOOTING.md) for more help.

