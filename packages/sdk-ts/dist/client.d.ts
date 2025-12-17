import { Intent, StatusCode, Action, ValidateResponse, ExecuteResponse } from "./types";
export declare class ERC1066Client {
    private gatewayUrl;
    constructor(gatewayUrl: string);
    validateIntent(intent: Intent, chainId: number): Promise<ValidateResponse>;
    executeIntent(intent: Intent, chainId: number): Promise<ExecuteResponse>;
    mapStatusToAction(status: StatusCode): Action;
}
//# sourceMappingURL=client.d.ts.map