import { Intent, StatusCode, Action, ValidateResponse, ExecuteResponse } from "./types";

export class ERC1066Client {
  constructor(private gatewayUrl: string) {}

  async validateIntent(
    intent: Intent,
    chainId: number
  ): Promise<ValidateResponse> {
    const response = await fetch(`${this.gatewayUrl}/intents/validate`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-Chain-Id": chainId.toString(),
      },
      body: JSON.stringify(intent),
    });

    const data = await response.json() as { status: StatusCode; intentHash: string };
    return {
      status: data.status,
      httpCode: response.status,
      intentHash: data.intentHash,
    };
  }

  async executeIntent(
    intent: Intent,
    chainId: number
  ): Promise<ExecuteResponse> {
    const response = await fetch(`${this.gatewayUrl}/intents/execute`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-Chain-Id": chainId.toString(),
      },
      body: JSON.stringify(intent),
    });

    return await response.json() as ExecuteResponse;
  }

  mapStatusToAction(status: StatusCode): Action {
    switch (status) {
      case "0x01":
        return "execute";
      case "0x20":
        return "retry";
      case "0x54":
        return "request_payment";
      default:
        return "deny";
    }
  }
}

