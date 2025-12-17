#!/bin/bash

# Complete Test Flow Script
# Tests intent validation with provided EIP7702 addresses

GATEWAY_URL="http://localhost:3001"
CHAIN_ID="133717"

SENDER="0xa43b752b6e941263eb5a7e3b96e2e0dea1a586ff"
TARGET="0xf5cb11878b94c9cd0bfa2e87ce9d6e1768cea818"

echo "=========================================="
echo "ERC-1066-x402 Complete Test Flow"
echo "=========================================="
echo ""

# Test 1: Health Check
echo "1. Testing Gateway Health..."
HEALTH=$(curl -s "$GATEWAY_URL/health")
echo "Response: $HEALTH"
echo ""

# Test 2: Get Chain Info
echo "2. Getting Chain Info for Chain ID $CHAIN_ID..."
CHAIN_INFO=$(curl -s "$GATEWAY_URL/chains/$CHAIN_ID")
echo "Response: $CHAIN_INFO"
echo ""

# Test 3: Validate Intent (No Policy - should be disallowed)
echo "3. Testing Intent Validation (No Policy)..."
VALIDATE_RESPONSE=$(curl -s -X POST "$GATEWAY_URL/intents/validate" \
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
    \"policyId\": \"0x0000000000000000000000000000000000000000000000000000000000000000\"
  }")
echo "Response: $VALIDATE_RESPONSE"
echo ""

# Test 4: Validate Intent with a test policy ID
echo "4. Testing Intent Validation (With Test Policy)..."
# Using keccak256("test-policy-1") as policy ID
TEST_POLICY_ID="0x0000000000000000000000000000000000000000000000000000000000000000"
VALIDATE_WITH_POLICY=$(curl -s -X POST "$GATEWAY_URL/intents/validate" \
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
    \"policyId\": \"$TEST_POLICY_ID\"
  }")
echo "Response: $VALIDATE_WITH_POLICY"
echo ""

echo "=========================================="
echo "Test Complete!"
echo "=========================================="

