import { StatusCode } from "../types/status";
import { Intent } from "../types/intent";

export interface X402V2Response {
  code: number;
  headers: Record<string, string>;
  body: any;
}

export function buildX402V2Response(
  status: StatusCode,
  intent: Intent,
  chainId: number,
  intentHash: string,
  executionResult?: any
): X402V2Response {
  const headers: Record<string, string> = {
    "X-ERC1066-Status": status,
    "X-Intent-Hash": intentHash,
    "X-Chain-Type": intent.chainType,
    "X-Chain-Id": chainId.toString(),
  };

  // Status 0x54 (Insufficient Funds) -> 402 Payment Required
  if (status === "0x54") {
    return {
      code: 402,
      headers: {
        ...headers,
        "X-Payment-Required": "true",
      },
      body: {
        accepts: [
          {
            paymentRequirements: {
              scheme: "exact",
              version: 2,
              amount: intent.value,
              asset: "native",
              network: `${intent.chainType}:${chainId}`,
              extra: {
                policyId: intent.policyId,
              },
            },
          },
        ],
      },
    };
  }

  // Map other status codes to appropriate HTTP codes
  let code = 200;
  if (status === "0x00" || status === "0x50") code = 500;
  else if (status === "0x10") code = 403;
  else if (status === "0x20") {
    code = 202;
    headers["Retry-After"] = "60";
  } else if (status === "0x21") code = 410;
  else if (status === "0xA0") code = 400;
  else if (status === "0xA2") code = 421;

  return {
    code,
    headers,
    body: {
      status,
      intentHash,
      chainType: intent.chainType,
      chainId,
      ...(executionResult || {}),
    },
  };
}

