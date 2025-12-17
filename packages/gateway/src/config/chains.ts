import { PublicClient } from "viem";
import {
  getRpcUrlsFromChainlist,
  createRpcClientWithFallback,
  getBestRpcUrl,
} from "../services/chainlist";
import { createPublicClient, http, fallback } from "viem";

export interface ChainConfig {
  chainId: number;
  rpcUrl?: string;
  rpcUrls?: string[];
  executorAddress: string;
  validatorAddress: string;
  policyRegistryAddress: string;
  useChainlist?: boolean;
  // Custom network metadata (for networks not on Chainlist)
  customMetadata?: {
    name: string;
    nativeCurrency?: {
      name: string;
      symbol: string;
      decimals: number;
    };
    explorers?: Array<{
      name: string;
      url: string;
    }>;
  };
}

const chainConfigs: Record<number, ChainConfig> = {};

export function getChainConfig(chainId: number): ChainConfig | undefined {
  return chainConfigs[chainId];
}

export function setChainConfig(config: ChainConfig): void {
  chainConfigs[config.chainId] = config;
}

export function getAllChainIds(): number[] {
  return Object.keys(chainConfigs).map(Number);
}

const rpcClients: Map<number, PublicClient> = new Map();

export async function getRpcClient(chainId: number): Promise<PublicClient | undefined> {
  if (rpcClients.has(chainId)) {
    return rpcClients.get(chainId);
  }

  const config = getChainConfig(chainId);
  if (!config) {
    return undefined;
  }

  let client: PublicClient;
  let allUrls: string[] = [];

  // Try Chainlist first if enabled
  if (config.useChainlist !== false) {
    try {
      const chainlistUrls = await getRpcUrlsFromChainlist(chainId);
      allUrls.push(...chainlistUrls);
    } catch (error) {
      console.warn(
        `Failed to fetch RPC from Chainlist for chain ${chainId}, using fallback:`,
        error
      );
    }
  }

  // Add custom RPC URLs (these take priority as fallbacks)
  if (config.rpcUrls && config.rpcUrls.length > 0) {
    allUrls = [...config.rpcUrls, ...allUrls];
  } else if (config.rpcUrl) {
    allUrls = [config.rpcUrl, ...allUrls];
  }

  // If we have URLs, create client
  if (allUrls.length > 0) {
    client = createRpcClientWithFallback(chainId, allUrls);
  } else {
    // No RPC URLs available
    console.warn(`No RPC URLs available for chain ${chainId}`);
    return undefined;
  }

  rpcClients.set(chainId, client);
  return client;
}

export async function initializeChains(configs: ChainConfig[]): Promise<void> {
  for (const config of configs) {
    setChainConfig(config);
    await getRpcClient(config.chainId);
  }
}

