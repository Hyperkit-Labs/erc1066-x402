#!/bin/bash

# Test Intent Validation Script
# Uses the provided EIP7702 addresses

GATEWAY_URL="http://localhost:3001"
CHAIN_ID="133717"

# Policy ID from CreatePolicy script (keccak256("test-policy-1"))
# Calculate: cast keccak "test-policy-1"
POLICY_ID="0x0000000000000000000000000000000000000000000000000000000000000000"

# Addresses provided
SENDER="0xa43b752b6e941263eb5a7e3b96e2e0dea1a586ff"
TARGET="0xf5cb11878b94c9cd0bfa2e87ce9d6e1768cea818"

echo "Testing Intent Validation..."
echo "Gateway: $GATEWAY_URL"
echo "Chain ID: $CHAIN_ID"
echo "Sender: $SENDER"
echo "Target: $TARGET"
echo ""

# Test 1: Validate intent with no policy (should fail or use default)
echo "=== Test 1: Validate Intent (No Policy) ==="
curl -X POST "$GATEWAY_URL/intents/validate" \
  -H "Content-Type: application/json" \
  -H "X-Chain-Id: $CHAIN_ID" \
  -d "{
    \"sender\": \"$SENDER\",
    \"target\": \"$TARGET\",
    \"data\": \"0x\",
    \"value\": \"0\",
    \"nonce\": \"1\",
    \"validAfter\": \"0\",
    \"validBefore\": \"18446744073709551615\",
    \"policyId\": \"$POLICY_ID\"
  }" | jq .

echo ""
echo ""

# Test 2: Check chain info
echo "=== Test 2: Get Chain Info ==="
curl -s "$GATEWAY_URL/chains/$CHAIN_ID" | jq .

echo ""
echo ""

# Test 3: Health check
echo "=== Test 3: Health Check ==="
curl -s "$GATEWAY_URL/health" | jq .

