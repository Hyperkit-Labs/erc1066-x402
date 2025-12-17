# Gateway Integration Guide

## Overview

The gateway service provides HTTP endpoints for intent validation and execution, mapping onchain status codes to HTTP responses.

## Endpoints

### POST /intents/validate

Validates an intent without executing it.

**Request:**
```json
{
  "sender": "0x...",
  "target": "0x...",
  "data": "0x...",
  "value": "0",
  "nonce": "0",
  "validAfter": "0",
  "validBefore": "0",
  "policyId": "0x..."
}
```

**Response:**
- Status 200: Intent is valid
- Status 403: Intent is disallowed
- Status 402: Insufficient funds (x402 payment required)
- Other status codes based on validation result

### POST /intents/execute

Executes a validated intent.

**Request:** Same as validate endpoint

**Response:**
- Status 200: Execution successful
- Status 402: Payment required (x402 flow)
- Status 403: Execution denied
- Other status codes based on execution result

## Headers

- `X-Chain-Id`: Chain ID for the request
- `X-Status-Code`: Onchain status code (bytes1)
- `X-Payment-Required`: Set to "true" when payment is required

## Configuration

Configure gateway with:
- RPC URLs for each chain
- Contract addresses per chain
- x402 facilitator settings

