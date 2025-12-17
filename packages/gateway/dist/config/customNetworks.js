const customNetworks = new Map();
export function registerCustomNetwork(metadata) {
    customNetworks.set(metadata.chainId, metadata);
}
export function getCustomNetwork(chainId) {
    return customNetworks.get(chainId);
}
export function getAllCustomNetworks() {
    return Array.from(customNetworks.values());
}
export function loadCustomNetworksFromEnv() {
    const customNetworksJson = process.env.CUSTOM_NETWORKS;
    if (!customNetworksJson) {
        return;
    }
    try {
        const networks = JSON.parse(customNetworksJson);
        for (const network of networks) {
            registerCustomNetwork(network);
        }
        console.log(`Loaded ${networks.length} custom network(s) from environment`);
    }
    catch (error) {
        console.error("Failed to parse CUSTOM_NETWORKS from env:", error);
    }
}
//# sourceMappingURL=customNetworks.js.map