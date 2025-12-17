import { PublicClient } from "viem";
interface ChainlistChain {
    name: string;
    chain: string;
    rpc: string[];
    nativeCurrency: {
        name: string;
        symbol: string;
        decimals: number;
    };
    shortName: string;
    chainId: number;
    networkId: number;
    slip44?: number;
    explorers?: Array<{
        name: string;
        url: string;
        standard: string;
    }>;
}
export declare function fetchChainlist(): Promise<Map<number, ChainlistChain>>;
export declare function getRpcUrlsFromChainlist(chainId: number): Promise<string[]>;
export declare function createRpcClientWithFallback(chainId: number, rpcUrls: string[]): PublicClient;
export declare function getBestRpcUrl(chainId: number, fallbackUrl?: string): Promise<string>;
export {};
//# sourceMappingURL=chainlist.d.ts.map