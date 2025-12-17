export interface ChainMetadata {
  chainId: number;
  name: string;
  nativeCurrency: {
    name: string;
    symbol: string;
    decimals: number;
  };
  rpcUrls: string[];
  explorers?: Array<{
    name: string;
    url: string;
  }>;
}

import { getCustomNetwork } from "../config/customNetworks";

export async function getChainMetadata(chainId: number): Promise<ChainMetadata | null> {
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

    const chains = (await response.json()) as any[];
    const chain = chains.find((c) => c.chainId === chainId);

    if (!chain) {
      return null;
    }

    return {
      chainId: chain.chainId,
      name: chain.name,
      nativeCurrency: chain.nativeCurrency,
      rpcUrls: chain.rpc || [],
      explorers: chain.explorers?.map((e: any) => ({
        name: e.name,
        url: e.url,
      })),
    };
  } catch (error) {
    console.error(`Failed to fetch chain metadata for ${chainId}:`, error);
    return null;
  }
}

