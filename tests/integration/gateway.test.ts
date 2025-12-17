import { describe, it, expect, beforeAll } from "vitest";
import { ERC1066Client } from "../../packages/sdk-ts/src";

describe("Gateway Integration Tests", () => {
  const client = new ERC1066Client("http://localhost:3000");

  beforeAll(() => {
    // Wait for gateway to be ready
  });

  it("should validate intent successfully", async () => {
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
    expect(result.status).toBeDefined();
    expect(result.intentHash).toBeDefined();
  });

  it("should handle insufficient funds status", async () => {
    const intent = {
      sender: "0x1234567890123456789012345678901234567890",
      target: "0xabcdefabcdefabcdefabcdefabcdefabcdefabcd",
      data: "0x",
      value: "1000000000000000000000",
      nonce: "0",
      validAfter: "0",
      validBefore: "0",
      policyId: "0x0000000000000000000000000000000000000000000000000000000000000000",
    };

    const result = await client.validateIntent(intent, 1);
    const action = client.mapStatusToAction(result.status);
    expect(["request_payment", "deny"]).toContain(action);
  });

  it("should map status codes correctly", () => {
    expect(client.mapStatusToAction("0x01")).toBe("execute");
    expect(client.mapStatusToAction("0x20")).toBe("retry");
    expect(client.mapStatusToAction("0x54")).toBe("request_payment");
    expect(client.mapStatusToAction("0x10")).toBe("deny");
  });
});

