import { PublicClient } from "viem";
import { Intent } from "../types/intent";
import { StatusCode } from "../types/status";
import { mapStatusToHttp } from "../utils/status";
import { getRpcClient, getChainConfig } from "../config/chains";
import { ChainNotSupportedError } from "../utils/errors";

const EXECUTOR_ABI = [
  {
    name: "canExecute",
    type: "function",
    stateMutability: "view",
    inputs: [
      {
        name: "intent",
        type: "tuple",
        components: [
          { name: "sender", type: "address" },
          { name: "target", type: "address" },
          { name: "data", type: "bytes" },
          { name: "value", type: "uint256" },
          { name: "nonce", type: "uint256" },
          { name: "validAfter", type: "uint256" },
          { name: "validBefore", type: "uint256" },
          { name: "policyId", type: "bytes32" },
        ],
      },
    ],
    outputs: [{ name: "status", type: "bytes1" }],
  },
] as const;

export class IntentValidator {
  async canExecute(intent: Intent, chainId: number): Promise<StatusCode> {
    const client = await getRpcClient(chainId);
    if (!client) {
      throw new ChainNotSupportedError(chainId);
    }

    const config = getChainConfig(chainId);
    if (!config) {
      throw new ChainNotSupportedError(chainId);
    }

    try {
      const status = await client.readContract({
        address: config.executorAddress as `0x${string}`,
        abi: EXECUTOR_ABI,
        functionName: "canExecute",
        args: [
          {
            sender: intent.sender as `0x${string}`,
            target: intent.target as `0x${string}`,
            data: intent.data as `0x${string}`,
            value: BigInt(intent.value),
            nonce: BigInt(intent.nonce),
            validAfter: BigInt(intent.validAfter || "0"),
            validBefore: BigInt(intent.validBefore || "0"),
            policyId: intent.policyId as `0x${string}`,
          },
        ],
      });

      return status as StatusCode;
    } catch (error) {
      return "0x00";
    }
  }

  mapStatusToHttp(status: StatusCode) {
    return mapStatusToHttp(status);
  }
}

