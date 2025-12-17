import { ERC1066Client, Intent, Action } from "../src";

const client = new ERC1066Client("https://gateway.example.com");

async function agentDecision(intent: Intent, chainId: number): Promise<void> {
  const validation = await client.validateIntent(intent, chainId);
  const action = client.mapStatusToAction(validation.status);

  switch (action) {
    case "execute":
      console.log("Executing intent immediately");
      await client.executeIntent(intent, chainId);
      break;

    case "retry":
      console.log("Intent too early, scheduling retry");
      setTimeout(() => agentDecision(intent, chainId), 60000);
      break;

    case "request_payment":
      console.log("Payment required, requesting payment");
      const execution = await client.executeIntent(intent, chainId);
      if (execution.paymentRequest) {
        console.log("Payment request:", execution.paymentRequest);
      }
      break;

    case "deny":
      console.log("Intent denied, informing user");
      break;
  }
}

export { agentDecision };

