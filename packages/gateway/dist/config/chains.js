import { getRpcUrlsFromChainlist, createRpcClientWithFallback, } from "../services/chainlist";
const chainConfigs = {};
export function getChainConfig(chainId) {
    return chainConfigs[chainId];
}
export function setChainConfig(config) {
    chainConfigs[config.chainId] = config;
}
export function getAllChainIds() {
    return Object.keys(chainConfigs).map(Number);
}
const rpcClients = new Map();
export async function getRpcClient(chainId) {
    if (rpcClients.has(chainId)) {
        return rpcClients.get(chainId);
    }
    const config = getChainConfig(chainId);
    if (!config) {
        return undefined;
    }
    let client;
    let allUrls = [];
    // Try Chainlist first if enabled
    if (config.useChainlist !== false) {
        try {
            const chainlistUrls = await getRpcUrlsFromChainlist(chainId);
            allUrls.push(...chainlistUrls);
        }
        catch (error) {
            console.warn(`Failed to fetch RPC from Chainlist for chain ${chainId}, using fallback:`, error);
        }
    }
    // Add custom RPC URLs (these take priority as fallbacks)
    if (config.rpcUrls && config.rpcUrls.length > 0) {
        allUrls = [...config.rpcUrls, ...allUrls];
    }
    else if (config.rpcUrl) {
        allUrls = [config.rpcUrl, ...allUrls];
    }
    // If we have URLs, create client
    if (allUrls.length > 0) {
        client = createRpcClientWithFallback(chainId, allUrls);
    }
    else {
        // No RPC URLs available
        console.warn(`No RPC URLs available for chain ${chainId}`);
        return undefined;
    }
    rpcClients.set(chainId, client);
    return client;
}
export async function initializeChains(configs) {
    for (const config of configs) {
        setChainConfig(config);
        await getRpcClient(config.chainId);
    }
}
//# sourceMappingURL=chains.js.map