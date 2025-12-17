import { WalletClient } from "viem";
import { Intent } from "../types/intent";
import { StatusCode } from "../types/status";
import { IntentValidator } from "./validator";
export declare class IntentExecutor {
    private validator;
    constructor(validator: IntentValidator);
    execute(intent: Intent, chainId: number, walletClient?: WalletClient): Promise<{
        status: StatusCode;
        returnData?: string;
    }>;
}
//# sourceMappingURL=executor.d.ts.map