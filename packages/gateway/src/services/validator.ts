import { Intent } from "../types/intent";
import { StatusCode } from "../types/status";
import { mapStatusToHttp } from "../utils/status";
import { EvmAdapter } from "../adapters/EvmAdapter";
import { SolanaAdapter } from "../adapters/SolanaAdapter";
import { SuiAdapter } from "../adapters/SuiAdapter";
import { IChainAdapter } from "../adapters/IChainAdapter";

export class IntentValidator {
  private adapters: Record<string, IChainAdapter> = {
    evm: new EvmAdapter(),
    solana: new SolanaAdapter(),
    sui: new SuiAdapter(),
  };

  private getChainType(chainId: number): string {
    // Solana chain IDs are usually strings (genesis hashes), but we use numbers for now
    // This logic would be expanded to handle different chain types
    if (chainId > 1000000) return "solana"; // Dummy check
    if (chainId === 0) return "sui"; // Dummy check
    return "evm";
  }

  async canExecute(intent: Intent, chainId: number): Promise<StatusCode> {
    const chainType = intent.chainType || this.getChainType(chainId);
    const adapter = this.adapters[chainType];

    if (!adapter) {
      return "0xA2"; // S_UNSUPPORTED_CHAIN
    }

    return adapter.validate(intent, chainId);
  }

  mapStatusToHttp(status: StatusCode) {
    return mapStatusToHttp(status);
  }
}
