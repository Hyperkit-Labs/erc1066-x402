import { createPublicClient, http, fallback } from "viem";
let chainlistCache = null;
const CACHE_TTL = 3600000; // 1 hour
let lastFetchTime = 0;
export async function fetchChainlist() {
    const now = Date.now();
    if (chainlistCache && now - lastFetchTime < CACHE_TTL) {
        return chainlistCache;
    }
    try {
        const response = await fetch("https://chainlist.org/rpcs.json");
        if (!response.ok) {
            throw new Error(`Failed to fetch Chainlist: ${response.statusText}`);
        }
        const chains = (await response.json());
        chainlistCache = new Map();
        for (const chain of chains) {
            chainlistCache.set(chain.chainId, chain);
        }
        lastFetchTime = now;
        return chainlistCache;
    }
    catch (error) {
        console.error("Failed to fetch Chainlist, using cache or fallback:", error);
        if (chainlistCache) {
            return chainlistCache;
        }
        throw error;
    }
}
export async function getRpcUrlsFromChainlist(chainId) {
    const chainlist = await fetchChainlist();
    const chain = chainlist.get(chainId);
    if (!chain) {
        return [];
    }
    return chain.rpc || [];
}
export function createRpcClientWithFallback(chainId, rpcUrls) {
    if (rpcUrls.length === 0) {
        throw new Error(`No RPC URLs available for chain ${chainId}`);
    }
    const transports = rpcUrls.map((url) => http(url));
    return createPublicClient({
        transport: fallback(transports),
    });
}
export async function getBestRpcUrl(chainId, fallbackUrl) {
    try {
        const rpcUrls = await getRpcUrlsFromChainlist(chainId);
        if (rpcUrls.length > 0) {
            return rpcUrls[0];
        }
    }
    catch (error) {
        console.warn(`Failed to fetch RPC from Chainlist for chain ${chainId}:`, error);
    }
    if (fallbackUrl) {
        return fallbackUrl;
    }
    throw new Error(`No RPC URL available for chain ${chainId}`);
}
//# sourceMappingURL=chainlist.js.map