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
export function logIntentValidation(intentHash, statusCode, chainId, executionTime) {
    logger.info({
        intentHash,
        statusCode,
        chainId,
        executionTime,
        type: "intent_validation",
    }, "Intent validated");
}
export function logIntentExecution(intentHash, statusCode, chainId, policyId, executionTime) {
    logger.info({
        intentHash,
        statusCode,
        chainId,
        policyId,
        executionTime,
        type: "intent_execution",
    }, "Intent executed");
}
export function logError(error, context) {
    logger.error({
        ...context,
        error: error.message,
        stack: error.stack,
        type: "error",
    }, "Error occurred");
}
//# sourceMappingURL=logging.js.map