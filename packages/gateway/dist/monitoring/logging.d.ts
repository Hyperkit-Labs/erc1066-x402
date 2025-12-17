import pino from "pino";
export declare const logger: pino.Logger<never, boolean>;
export interface LogContext {
    intentHash?: string;
    statusCode?: string;
    chainId?: number;
    policyId?: string;
    executionTime?: number;
    endpoint?: string;
    method?: string;
}
export declare function logIntentValidation(intentHash: string, statusCode: string, chainId: number, executionTime: number): void;
export declare function logIntentExecution(intentHash: string, statusCode: string, chainId: number, policyId: string, executionTime: number): void;
export declare function logError(error: Error, context: LogContext): void;
//# sourceMappingURL=logging.d.ts.map