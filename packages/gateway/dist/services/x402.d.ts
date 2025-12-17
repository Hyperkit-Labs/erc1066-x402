import { Intent } from "../types/intent";
export interface PaymentRequest {
    id: string;
    amount: string;
    token: string;
    chainId: number;
    headers: Record<string, string>;
}
export declare class X402Service {
    createPaymentRequest(intent: Intent, chainId: number): Promise<PaymentRequest>;
    getPaymentStatus(requestId: string): Promise<{
        status: "pending" | "completed" | "failed";
    }>;
}
//# sourceMappingURL=x402.d.ts.map