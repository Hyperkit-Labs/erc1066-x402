export declare class GatewayError extends Error {
    statusCode: number;
    headers: Record<string, string>;
    constructor(message: string, statusCode: number, headers?: Record<string, string>);
}
export declare class ValidationError extends GatewayError {
    constructor(message: string);
}
export declare class ChainNotSupportedError extends GatewayError {
    constructor(chainId: number);
}
//# sourceMappingURL=errors.d.ts.map