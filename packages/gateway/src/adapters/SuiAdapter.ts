import { Intent } from "../types/intent";
import { StatusCode } from "../types/status";
import { IChainAdapter, ExecutionResult } from "./IChainAdapter";
import { SuiClient, getFullnodeUrl } from "@mysten/sui.js/client";
import { TransactionBlock } from "@mysten/sui.js/transactions";

export class SuiAdapter implements IChainAdapter {
  private rpcUrl = process.env.SUI_RPC_URL || getFullnodeUrl("testnet");
  private packageId = process.env.SUI_PACKAGE_ID || "0xf98be18dc82a4caa9dcdd08d6c49b76a67cf8ac7b33be3eab119dd0fb5f44c02";

  async validate(intent: Intent, _chainId: number): Promise<StatusCode> {
    try {
      const client = new SuiClient({ url: this.rpcUrl });
      const txb = new TransactionBlock();

      // Build the Intent struct as a pure argument
      // This matches the struct definition in intent_framework.move
      const intentArg = txb.pure({
        sender: intent.sender,
        target: intent.target,
        data: Array.from(Buffer.from(intent.data.replace("0x", ""), "hex")),
        value: intent.value,
        nonce: intent.nonce,
        valid_after: intent.validAfter || "0",
        valid_before: intent.validBefore || "0",
        policy_id: Array.from(Buffer.from(intent.policyId.replace("0x", ""), "hex")),
      });

      txb.moveCall({
        target: `${this.packageId}::intent_framework::validate_intent`,
        arguments: [
          txb.object(intent.policyId),
          intentArg,
          txb.pure(_chainId),
        ],
      });

      const res = await client.dryRunTransactionBlock({
        transactionBlock: await txb.build({ client }),
      });

      if (res.effects.status.status === "failure") {
        const error = res.effects.status.error || "";
        // Extract MoveAbort code: "MoveAbort(..., 84)"
        const match = error.match(/MoveAbort\(.*, (\d+)\)/);
        if (match) {
          const code = parseInt(match[1]);
          return `0x${code.toString(16).padStart(2, "0")}` as StatusCode;
        }
        return "0x00";
      }

      return "0x01"; // S_SUCCESS
    } catch (error: any) {
      console.error("Sui Validation Error:", error);
      return "0x00";
    }
  }

  async execute(intent: Intent, _chainId: number): Promise<ExecutionResult> {
    return {
      status: "0x00",
      error: "Sui Execution via Gateway relayer not implemented. Use client-side signing.",
    };
  }
}
