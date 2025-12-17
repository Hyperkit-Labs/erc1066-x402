import pino from "pino";

export const logger = pino({
  level: process.env.LOG_LEVEL || "info",
  transport: {
    target: "pino-pretty",
    options: {
      translateTime: "HH:MM:ss Z",
      ignore: "pid,hostname",
    },
  },
});

export interface LogContext {
  intentHash?: string;
  statusCode?: string;
  chainId?: number;
  policyId?: string;
  executionTime?: number;
  endpoint?: string;
  method?: string;
}

export function logIntentValidation(
  intentHash: string,
  statusCode: string,
  chainId: number,
  executionTime: number
): void {
  logger.info(
    {
      intentHash,
      statusCode,
      chainId,
      executionTime,
      type: "intent_validation",
    },
    "Intent validated"
  );
}

export function logIntentExecution(
  intentHash: string,
  statusCode: string,
  chainId: number,
  policyId: string,
  executionTime: number
): void {
  logger.info(
    {
      intentHash,
      statusCode,
      chainId,
      policyId,
      executionTime,
      type: "intent_execution",
    },
    "Intent executed"
  );
}

export function logError(error: Error, context: LogContext): void {
  logger.error(
    {
      ...context,
      error: error.message,
      stack: error.stack,
      type: "error",
    },
    "Error occurred"
  );
}

