import { FastifyInstance } from "fastify";
import { z } from "zod";
import { IntentValidator } from "../services/validator";
import { IntentExecutor } from "../services/executor";
import { X402Service } from "../services/x402";
import { computeIntentHash } from "../utils/chain";
import { ValidationError } from "../utils/errors";
import { buildX402V2Response } from "../utils/x402v2";

const IntentSchema = z.object({
  sender: z.string(), // Relaxed for multi-chain (EVM: 0x..., Solana: Base58, Sui: 0x...)
  target: z.string(),
  data: z.string().regex(/^0x[a-fA-F0-9]*$/),
  value: z.string().regex(/^\d+$/),
  nonce: z.string().regex(/^\d+$/),
  validAfter: z.string().regex(/^\d+$/).optional(),
  validBefore: z.string().regex(/^\d+$/).optional(),
  policyId: z.string(), // Relaxed
  chainType: z.enum(["evm", "solana", "sui"]),
});

export async function intentRoutes(fastify: FastifyInstance) {
  const validator = new IntentValidator();
  const executor = new IntentExecutor(validator);
  const x402 = new X402Service();

  fastify.post("/intents/validate", async (request, reply) => {
    try {
      const intent = IntentSchema.parse(request.body);
      const chainId = Number(request.headers["x-chain-id"] || "1");
      const intentHash = computeIntentHash(intent);

      const status = await validator.canExecute(intent, chainId);
      const v2Response = buildX402V2Response(status, intent, chainId, intentHash);

      reply.code(v2Response.code);
      reply.headers(v2Response.headers);
      return v2Response.body;
    } catch (error) {
      if (error instanceof z.ZodError) {
        throw new ValidationError(error.message);
      }
      throw error;
    }
  });

  fastify.post("/intents/execute", async (request, reply) => {
    try {
      const intent = IntentSchema.parse(request.body);
      const chainId = Number(request.headers["x-chain-id"] || "1");
      const intentHash = computeIntentHash(intent);

      const status = await validator.canExecute(intent, chainId);

      if (status === "0x54") {
        const v2Response = buildX402V2Response(status, intent, chainId, intentHash);
        reply.code(v2Response.code);
        reply.headers(v2Response.headers);
        return v2Response.body;
      }

      if (status !== "0x01") {
        const v2Response = buildX402V2Response(status, intent, chainId, intentHash);
        reply.code(v2Response.code);
        reply.headers(v2Response.headers);
        return v2Response.body;
      }

      const result = await executor.execute(intent, chainId);
      const v2Response = buildX402V2Response("0x01", intent, chainId, intentHash, { result });
      
      reply.code(v2Response.code);
      reply.headers(v2Response.headers);
      return v2Response.body;
    } catch (error) {
      if (error instanceof z.ZodError) {
        throw new ValidationError(error.message);
      }
      throw error;
    }
  });
}

