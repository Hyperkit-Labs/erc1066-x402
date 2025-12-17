import { ChainMetadata } from "../utils/chainlist";

const customNetworks: Map<number, ChainMetadata> = new Map();

export function registerCustomNetwork(metadata: ChainMetadata): void {
  customNetworks.set(metadata.chainId, metadata);
}

export function getCustomNetwork(chainId: number): ChainMetadata | undefined {
  return customNetworks.get(chainId);
}

export function getAllCustomNetworks(): ChainMetadata[] {
  return Array.from(customNetworks.values());
}

export function loadCustomNetworksFromEnv(): void {
  const customNetworksJson = process.env.CUSTOM_NETWORKS;
  if (!customNetworksJson) {
    return;
  }

  try {
    const networks: ChainMetadata[] = JSON.parse(customNetworksJson);
    for (const network of networks) {
      registerCustomNetwork(network);
    }
    console.log(`Loaded ${networks.length} custom network(s) from environment`);
  } catch (error) {
    console.error("Failed to parse CUSTOM_NETWORKS from env:", error);
  }
}

