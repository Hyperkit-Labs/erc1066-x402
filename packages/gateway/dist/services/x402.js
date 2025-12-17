export class X402Service {
    async createPaymentRequest(intent, chainId) {
        const requestId = `x402-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
        return {
            id: requestId,
            amount: intent.value,
            token: "native",
            chainId,
            headers: {
                "X-Payment-Request-Id": requestId,
                "X-Payment-Amount": intent.value,
                "X-Payment-Token": "native",
                "X-Payment-Chain-Id": chainId.toString(),
            },
        };
    }
    async getPaymentStatus(requestId) {
        return { status: "pending" };
    }
}
//# sourceMappingURL=x402.js.map