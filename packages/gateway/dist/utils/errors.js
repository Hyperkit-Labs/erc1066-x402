export class GatewayError extends Error {
    statusCode;
    headers;
    constructor(message, statusCode, headers = {}) {
        super(message);
        this.statusCode = statusCode;
        this.headers = headers;
        this.name = "GatewayError";
    }
}
export class ValidationError extends GatewayError {
    constructor(message) {
        super(message, 400);
    }
}
export class ChainNotSupportedError extends GatewayError {
    constructor(chainId) {
        super(`Chain ${chainId} is not supported`, 421);
    }
}
//# sourceMappingURL=errors.js.map