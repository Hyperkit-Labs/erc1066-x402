export interface Intent {
    sender: string;
    target: string;
    data: string;
    value: string;
    nonce: string;
    validAfter?: string;
    validBefore?: string;
    policyId: string;
}
export type StatusCode = "0x00" | "0x01" | "0x10" | "0x11" | "0x20" | "0x21" | "0x22" | "0x50" | "0x51" | "0x54" | "0xA0" | "0xA1" | "0xA2";
export type Action = "execute" | "retry" | "request_payment" | "deny";
export interface ValidateResponse {
    status: StatusCode;
    httpCode: number;
    intentHash: string;
}
export interface ExecuteResponse {
    status: StatusCode;
    result?: any;
    paymentRequest?: any;
    error?: string;
}
//# sourceMappingURL=types.d.ts.map