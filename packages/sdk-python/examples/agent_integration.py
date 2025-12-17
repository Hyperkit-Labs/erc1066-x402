import time
from erc1066_x402 import ERC1066Client, Intent, Action

client = ERC1066Client("https://gateway.example.com")


def agent_decision(intent: Intent, chain_id: int) -> None:
    validation = client.validate_intent(intent, chain_id)
    action = client.map_status_to_action(validation.status)

    if action == "execute":
        print("Executing intent immediately")
        client.execute_intent(intent, chain_id)
    elif action == "retry":
        print("Intent too early, scheduling retry")
        time.sleep(60)
        agent_decision(intent, chain_id)
    elif action == "request_payment":
        print("Payment required, requesting payment")
        execution = client.execute_intent(intent, chain_id)
        if execution.paymentRequest:
            print(f"Payment request: {execution.paymentRequest}")
    elif action == "deny":
        print("Intent denied, informing user")


if __name__ == "__main__":
    intent = Intent(
        sender="0x1234567890123456789012345678901234567890",
        target="0xabcdefabcdefabcdefabcdefabcdefabcdefabcd",
        data="0x",
        value="0",
        nonce="0",
        policyId="0x0000000000000000000000000000000000000000000000000000000000000000",
    )
    agent_decision(intent, 1)

