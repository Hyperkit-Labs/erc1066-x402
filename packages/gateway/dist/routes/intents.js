import { z } from "zod";
import { IntentValidator } from "../services/validator";
import { IntentExecutor } from "../services/executor";
import { X402Service } from "../services/x402";
import { computeIntentHash } from "../utils/chain";
import { ValidationError } from "../utils/errors";
const IntentSchema = z.object({
    sender: z.string().regex(/^0x[a-fA-F0-9]{40}$/),
    target: z.string().regex(/^0x[a-fA-F0-9]{40}$/),
    data: z.string().regex(/^0x[a-fA-F0-9]*$/),
    value: z.string().regex(/^\d+$/),
    nonce: z.string().regex(/^\d+$/),
    validAfter: z.string().regex(/^\d+$/).optional(),
    validBefore: z.string().regex(/^\d+$/).optional(),
    policyId: z.string().regex(/^0x[a-fA-F0-9]{64}$/),
});
export async function intentRoutes(fastify) {
    const validator = new IntentValidator();
    const executor = new IntentExecutor(validator);
    const x402 = new X402Service();
    fastify.post("/intents/validate", async (request, reply) => {
        try {
            const intent = IntentSchema.parse(request.body);
            const chainId = Number(request.headers["x-chain-id"] || "1");
            const status = await validator.canExecute(intent, chainId);
            const httpResponse = validator.mapStatusToHttp(status);
            reply.code(httpResponse.code);
            reply.headers({
                "X-Status-Code": status,
                ...httpResponse.headers,
            });
            return {
                status,
                intentHash: computeIntentHash(intent),
            };
        }
        catch (error) {
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
            const status = await validator.canExecute(intent, chainId);
            if (status === "0x54") {
                const paymentRequest = await x402.createPaymentRequest(intent, chainId);
                reply.code(402);
                reply.headers({
                    "X-Payment-Required": "true",
                    "X-Payment-Request-Id": paymentRequest.id,
                    ...paymentRequest.headers,
                });
                return {
                    status,
                    paymentRequest,
                };
            }
            if (status !== "0x01") {
                const httpResponse = validator.mapStatusToHttp(status);
                reply.code(httpResponse.code);
                reply.headers({ "X-Status-Code": status });
                return {
                    status,
                    error: "Execution denied",
                };
            }
            const result = await executor.execute(intent, chainId);
            reply.code(200);
            return {
                status: "0x01",
                result,
            };
        }
        catch (error) {
            if (error instanceof z.ZodError) {
                throw new ValidationError(error.message);
            }
            throw error;
        }
    });
}
//# sourceMappingURL=intents.js.map