import { PublicClient } from "viem";
export interface ChainConfig {
    chainId: number;
    rpcUrl?: string;
    rpcUrls?: string[];
    executorAddress: string;
    validatorAddress: string;
    policyRegistryAddress: string;
    useChainlist?: boolean;
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
export declare function getChainConfig(chainId: number): ChainConfig | undefined;
export declare function setChainConfig(config: ChainConfig): void;
export declare function getAllChainIds(): number[];
export declare function getRpcClient(chainId: number): Promise<PublicClient | undefined>;
export declare function initializeChains(configs: ChainConfig[]): Promise<void>;
//# sourceMappingURL=chains.d.ts.map