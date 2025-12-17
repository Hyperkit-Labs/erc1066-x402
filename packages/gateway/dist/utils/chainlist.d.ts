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
export declare function getChainMetadata(chainId: number): Promise<ChainMetadata | null>;
//# sourceMappingURL=chainlist.d.ts.map