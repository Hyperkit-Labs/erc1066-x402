import { Intent } from "../types/intent";
import { StatusCode } from "../types/status";

export interface ExecutionResult {
  status: StatusCode;
  txHash?: string;
  error?: string;
}

export interface IChainAdapter {
  validate(intent: Intent, chainId: number): Promise<StatusCode>;
  execute(intent: Intent, chainId: number): Promise<ExecutionResult>;
}

