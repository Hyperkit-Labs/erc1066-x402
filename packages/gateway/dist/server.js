import Fastify from "fastify";
import { intentRoutes } from "./routes/intents";
import { healthRoutes } from "./routes/health";
import { chainRoutes } from "./routes/chains";
import { initializeChains } from "./config/chains";
import { loadCustomNetworksFromEnv } from "./config/customNetworks";
export async function createServer() {
    const fastify = Fastify({
        logger: {
            transport: {
                target: "pino-pretty",
                options: {
                    translateTime: "HH:MM:ss Z",
                    ignore: "pid,hostname",
                },
            },
        },
    });
    fastify.setErrorHandler((error, request, reply) => {
        fastify.log.error(error);
        reply.status(error.statusCode || 500).send({
            error: error.message,
            statusCode: error.statusCode || 500,
        });
    });
    fastify.register(healthRoutes);
    fastify.register(intentRoutes);
    fastify.register(chainRoutes);
    // Load custom networks from environment
    loadCustomNetworksFromEnv();
    const useChainlist = process.env.USE_CHAINLIST !== "false";
    let chainConfigs = [];
    if (process.env.DEPLOYMENT_REGISTRY_PATH) {
        const fs = await import("fs");
        const path = await import("path");
        // Resolve path relative to project root or absolute path
        const registryPath = path.isAbsolute(process.env.DEPLOYMENT_REGISTRY_PATH)
            ? process.env.DEPLOYMENT_REGISTRY_PATH
            : path.resolve(process.cwd(), process.env.DEPLOYMENT_REGISTRY_PATH);
        const registry = JSON.parse(fs.readFileSync(registryPath, "utf-8"));
        const rpcUrls = JSON.parse(process.env.RPC_URLS || "{}");
        const rpcUrlsArray = JSON.parse(process.env.RPC_URLS_ARRAY || "{}");
        chainConfigs = Object.entries(registry).map(([chainId, config]) => ({
            chainId: Number(chainId),
            rpcUrl: rpcUrls[chainId] || undefined,
            rpcUrls: rpcUrlsArray[chainId] || undefined,
            executorAddress: config.executor || "",
            validatorAddress: config.validator || "",
            policyRegistryAddress: config.policyRegistry || "",
            useChainlist,
        }));
    }
    else {
        const rpcUrls = JSON.parse(process.env.RPC_URLS || "{}");
        const rpcUrlsArray = JSON.parse(process.env.RPC_URLS_ARRAY || "{}");
        const executorAddresses = JSON.parse(process.env.EXECUTOR_ADDRESSES || "{}");
        const validatorAddresses = JSON.parse(process.env.VALIDATOR_ADDRESSES || "{}");
        const registryAddresses = JSON.parse(process.env.REGISTRY_ADDRESSES || "{}");
        chainConfigs = Object.keys(executorAddresses).map((chainId) => ({
            chainId: Number(chainId),
            rpcUrl: rpcUrls[chainId] || undefined,
            rpcUrls: rpcUrlsArray[chainId] || undefined,
            executorAddress: executorAddresses[chainId] || "",
            validatorAddress: validatorAddresses[chainId] || "",
            policyRegistryAddress: registryAddresses[chainId] || "",
            useChainlist,
        }));
    }
    await initializeChains(chainConfigs);
    return fastify;
}
//# sourceMappingURL=server.js.map