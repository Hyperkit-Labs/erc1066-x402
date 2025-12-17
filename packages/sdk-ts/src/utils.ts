import { keccak256, encodeAbiParameters, parseAbiParameters, decodeAbiParameters } from "viem";
import { Intent } from "./types";

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

export function encodeIntent(intent: Intent): string {
  return encodeAbiParameters(
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
}

export function decodeIntent(data: string): Intent {
  const abiParams = parseAbiParameters("address, address, bytes, uint256, uint256, uint256, uint256, bytes32");
  const decoded = decodeAbiParameters(abiParams, data as `0x${string}`);
  return {
    sender: String(decoded[0]),
    target: String(decoded[1]),
    data: String(decoded[2]),
    value: String(decoded[3]),
    nonce: String(decoded[4]),
    validAfter: String(decoded[5]),
    validBefore: String(decoded[6]),
    policyId: String(decoded[7]),
  };
}

