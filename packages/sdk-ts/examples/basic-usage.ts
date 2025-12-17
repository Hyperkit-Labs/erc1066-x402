import { ERC1066Client, computeIntentHash } from "../src";

const client = new ERC1066Client("https://gateway.example.com");

const intent = {
  sender: "0x1234567890123456789012345678901234567890",
  target: "0xabcdefabcdefabcdefabcdefabcdefabcdefabcd",
  data: "0x",
  value: "1000000000000000000",
  nonce: "0",
  validAfter: "0",
  validBefore: "0",
  policyId: "0x0000000000000000000000000000000000000000000000000000000000000000",
};

async function main() {
  const intentHash = computeIntentHash(intent);
  console.log("Intent hash:", intentHash);

  const validation = await client.validateIntent(intent, 1);
  console.log("Validation status:", validation.status);
  console.log("HTTP code:", validation.httpCode);

  const action = client.mapStatusToAction(validation.status);
  console.log("Action:", action);

  if (action === "execute") {
    const execution = await client.executeIntent(intent, 1);
    console.log("Execution result:", execution);
  }
}

main().catch(console.error);

