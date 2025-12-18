import { keccak256, encodeAbiParameters, parseAbiParameters, isAddress, stringToHex, pad } from "viem";
import { Intent } from "../types/intent";

export function computeIntentHash(intent: Intent): string {
  // Helper to normalize addresses for hashing
  const normalizeAddr = (addr: string) => {
    if (isAddress(addr)) return addr;
    // For non-EVM (Solana/Sui), convert to hex and pad/truncate to 32 bytes for a consistent hash input
    return pad(stringToHex(addr).slice(0, 66) as `0x${string}`, { size: 32 });
  };

  try {
    const encoded = encodeAbiParameters(
      parseAbiParameters(
        "bytes32, bytes32, bytes, uint256, uint256, uint256, uint256, bytes32"
      ),
      [
        normalizeAddr(intent.sender),
        normalizeAddr(intent.target),
        intent.data as `0x${string}`,
        BigInt(intent.value),
        BigInt(intent.nonce),
        BigInt(intent.validAfter || "0"),
        BigInt(intent.validBefore || "0"),
        intent.policyId.startsWith("0x") ? (intent.policyId as `0x${string}`) : pad(stringToHex(intent.policyId).slice(0, 66) as `0x${string}`, { size: 32 }),
      ]
    );
    return keccak256(encoded);
  } catch (error) {
    // Fallback simple hash if ABI encoding fails
    return keccak256(stringToHex(JSON.stringify(intent)));
  }
}

