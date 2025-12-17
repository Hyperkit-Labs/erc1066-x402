import { getCustomNetwork } from "../config/customNetworks";
export async function getChainMetadata(chainId) {
    // Check custom networks first
    const customNetwork = getCustomNetwork(chainId);
    if (customNetwork) {
        return customNetwork;
    }
    // Fallback to Chainlist
    try {
        const response = await fetch("https://chainlist.org/rpcs.json");
        if (!response.ok) {
            return null;
        }
        const chains = (await response.json());
        const chain = chains.find((c) => c.chainId === chainId);
        if (!chain) {
            return null;
        }
        return {
            chainId: chain.chainId,
            name: chain.name,
            nativeCurrency: chain.nativeCurrency,
            rpcUrls: chain.rpc || [],
            explorers: chain.explorers?.map((e) => ({
                name: e.name,
                url: e.url,
            })),
        };
    }
    catch (error) {
        console.error(`Failed to fetch chain metadata for ${chainId}:`, error);
        return null;
    }
}
//# sourceMappingURL=chainlist.js.map