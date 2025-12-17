import { describe, it, expect } from "vitest";
import { ERC1066Client } from "../../packages/sdk-ts/src";

describe("SDK Integration Tests", () => {
  const gatewayUrl = process.env.GATEWAY_URL || "http://localhost:3000";
  const client = new ERC1066Client(gatewayUrl);

  it("should connect to gateway", async () => {
    const response = await fetch(`${gatewayUrl}/health`);
    expect(response.status).toBeLessThan(500);
  });

  it("should validate intent via SDK", async () => {
    const intent = {
      sender: "0x1234567890123456789012345678901234567890",
      target: "0xabcdefabcdefabcdefabcdefabcdefabcdefabcd",
      data: "0x",
      value: "0",
      nonce: "0",
      validAfter: "0",
      validBefore: "0",
      policyId: "0x0000000000000000000000000000000000000000000000000000000000000000",
    };

    const result = await client.validateIntent(intent, 1);
    expect(result).toHaveProperty("status");
    expect(result).toHaveProperty("intentHash");
  });

  it("should handle all status codes", async () => {
    const statusCodes: Array<"0x01" | "0x10" | "0x20" | "0x54"> = [
      "0x01",
      "0x10",
      "0x20",
      "0x54",
    ];

    for (const status of statusCodes) {
      const action = client.mapStatusToAction(status);
      expect(["execute", "retry", "request_payment", "deny"]).toContain(
        action
      );
    }
  });
});

