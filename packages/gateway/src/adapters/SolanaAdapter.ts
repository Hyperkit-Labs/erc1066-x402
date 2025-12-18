import { Intent } from "../types/intent";
import { StatusCode } from "../types/status";
import { IChainAdapter, ExecutionResult } from "./IChainAdapter";
import { Connection, PublicKey, Transaction, TransactionInstruction } from "@solana/web3.js";
import * as borsh from "borsh";

export class SolanaAdapter implements IChainAdapter {
  private rpcUrl = process.env.SOLANA_RPC_URL || "https://api.devnet.solana.com";
  private programId = process.env.SOLANA_PROGRAM_ID || "B5fwL2MnnGTsJzShmJYjdVGSDwduyr3Guan9XNAF7Vbb";

  async validate(intent: Intent, _chainId: number): Promise<StatusCode> {
    try {
      const connection = new Connection(this.rpcUrl, "confirmed");
      const progId = new PublicKey(this.programId);

      // Construct instruction data (Borsh)
      // Variant 0 = ValidateIntent
      const data = this.encodeInstruction(0, intent);

      const ix = new TransactionInstruction({
        programId: progId,
        keys: [
          { pubkey: new PublicKey(intent.policyId), isSigner: false, isWritable: false },
          { pubkey: new PublicKey(intent.sender), isSigner: false, isWritable: false },
        ],
        data: Buffer.from(data),
      });

      const tx = new Transaction().add(ix);
      tx.feePayer = new PublicKey(intent.sender);
      tx.recentBlockhash = (await connection.getLatestBlockhash()).blockhash;

      const sim = await connection.simulateTransaction(tx);

      if (sim.value.err) {
        const err: any = sim.value.err;
        // Parse ProgramError::Custom(status)
        if (err.InstructionError && err.InstructionError[1]?.Custom !== undefined) {
          const code = err.InstructionError[1].Custom;
          // Convert custom error back to hex status (e.g., 32 -> 0x20)
          return `0x${code.toString(16).padStart(2, "0")}` as StatusCode;
        }
        return "0x00"; // General failure
      }

      return "0x01"; // S_SUCCESS
    } catch (error: any) {
      console.error("Solana Validation Error:", error);
      return "0x00";
    }
  }

  async execute(intent: Intent, _chainId: number): Promise<ExecutionResult> {
    return {
      status: "0x00",
      error: "Solana Execution via Gateway relayer not implemented. Use client-side signing.",
    };
  }

  private encodeInstruction(variant: number, intent: Intent): Uint8Array {
    // Simplified encoding for demonstration
    // In a production app, use the actual Anchor IDL or a robust Borsh schema
    const buffer = Buffer.alloc(1000);
    let offset = 0;
    
    // Variant
    buffer.writeUInt8(variant, offset++);
    
    // Intent fields
    const sender = new PublicKey(intent.sender).toBuffer();
    sender.copy(buffer, offset); offset += 32;
    
    const target = new PublicKey(intent.target).toBuffer();
    target.copy(buffer, offset); offset += 32;
    
    // Data (Vec<u8>)
    const intentData = Buffer.from(intent.data.replace("0x", ""), "hex");
    buffer.writeUInt32LE(intentData.length, offset); offset += 4;
    intentData.copy(buffer, offset); offset += intentData.length;
    
    buffer.writeBigUInt64LE(BigInt(intent.value), offset); offset += 8;
    buffer.writeBigUInt64LE(BigInt(intent.nonce), offset); offset += 8;
    buffer.writeBigUInt64LE(BigInt(intent.validAfter || 0), offset); offset += 8;
    buffer.writeBigUInt64LE(BigInt(intent.validBefore || 0), offset); offset += 8;
    
    const policyId = Buffer.from(intent.policyId.replace("0x", ""), "hex");
    if (policyId.length === 32) {
        policyId.copy(buffer, offset); offset += 32;
    } else {
        // Fallback for non-hex policy IDs
        Buffer.alloc(32).copy(buffer, offset); offset += 32;
    }

    return buffer.subarray(0, offset);
  }
}
