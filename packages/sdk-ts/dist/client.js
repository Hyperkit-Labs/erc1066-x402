export class ERC1066Client {
    gatewayUrl;
    constructor(gatewayUrl) {
        this.gatewayUrl = gatewayUrl;
    }
    async validateIntent(intent, chainId) {
        const response = await fetch(`${this.gatewayUrl}/intents/validate`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-Chain-Id": chainId.toString(),
            },
            body: JSON.stringify(intent),
        });
        const data = await response.json();
        return {
            status: data.status,
            httpCode: response.status,
            intentHash: data.intentHash,
        };
    }
    async executeIntent(intent, chainId) {
        const response = await fetch(`${this.gatewayUrl}/intents/execute`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-Chain-Id": chainId.toString(),
            },
            body: JSON.stringify(intent),
        });
        return await response.json();
    }
    mapStatusToAction(status) {
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
//# sourceMappingURL=client.js.map