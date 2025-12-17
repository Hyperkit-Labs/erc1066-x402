import { ERC1066Client } from "./src/index";

async function testSDK() {
  const client = new ERC1066Client("http://localhost:3001");
  
  const intent = {
    sender: "0xa43b752b6e941263eb5a7e3b96e2e0dea1a586ff",
    target: "0xf5cb11878b94c9cd0bfa2e87ce9d6e1768cea818",
    data: "0x",
    value: "0",
    nonce: "1",
    validAfter: "0",
    validBefore: "18446744073709551615",
    policyId: "0x0000000000000000000000000000000000000000000000000000000000000000",
  };

  try {
    const result = await client.validateIntent(intent, 133717);
    console.log("✅ SDK Test Successful!");
    console.log("Status:", result.status);
    console.log("HTTP Code:", result.httpCode);
    console.log("Intent Hash:", result.intentHash);
    console.log("Action:", client.mapStatusToAction(result.status));
    return true;
  } catch (error) {
    console.error("❌ SDK Test Failed:", error);
    return false;
  }
}

testSDK().then(success => {
  process.exit(success ? 0 : 1);
});

