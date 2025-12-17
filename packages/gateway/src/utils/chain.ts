import { keccak256, encodeAbiParameters, parseAbiParameters } from "viem";
import { Intent } from "../types/intent";

export function computeIntentHash(intent: Intent): string {
  const encoded = encodeAbiParameters(
    parseAbiParameters(
      "address, address, bytes, uint256, uint256, uint256, uint256, bytes32"
    ),
    [
      intent.sender as `0x${string}`,
      intent.target as `0x${string}`,
      intent.data as `0x${string}`,
      BigInt(intent.value),
      BigInt(intent.nonce),
      BigInt(intent.validAfter || "0"),
      BigInt(intent.validBefore || "0"),
      intent.policyId as `0x${string}`,
    ]
  );
  return keccak256(encoded);
}

