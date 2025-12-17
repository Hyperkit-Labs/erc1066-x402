import { Intent } from "../types/intent";
import { StatusCode } from "../types/status";
export declare class IntentValidator {
    canExecute(intent: Intent, chainId: number): Promise<StatusCode>;
    mapStatusToHttp(status: StatusCode): import("../types/status").HttpResponse;
}
//# sourceMappingURL=validator.d.ts.map