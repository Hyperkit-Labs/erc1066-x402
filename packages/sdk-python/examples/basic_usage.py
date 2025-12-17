from erc1066_x402 import ERC1066Client, Intent, compute_intent_hash

client = ERC1066Client("https://gateway.example.com")

intent = Intent(
    sender="0x1234567890123456789012345678901234567890",
    target="0xabcdefabcdefabcdefabcdefabcdefabcdefabcd",
    data="0x",
    value="1000000000000000000",
    nonce="0",
    validAfter="0",
    validBefore="0",
    policyId="0x0000000000000000000000000000000000000000000000000000000000000000",
)

intent_hash = compute_intent_hash(intent)
print(f"Intent hash: {intent_hash}")

validation = client.validate_intent(intent, 1)
print(f"Validation status: {validation.status}")
print(f"HTTP code: {validation.httpCode}")

action = client.map_status_to_action(validation.status)
print(f"Action: {action}")

if action == "execute":
    execution = client.execute_intent(intent, 1)
    print(f"Execution result: {execution}")

