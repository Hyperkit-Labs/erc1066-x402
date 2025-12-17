import { keccak256, encodeAbiParameters, parseAbiParameters } from "viem";
export function computeIntentHash(intent) {
    const encoded = encodeAbiParameters(parseAbiParameters("address, address, bytes, uint256, uint256, uint256, uint256, bytes32"), [
        intent.sender,
        intent.target,
        intent.data,
        BigInt(intent.value),
        BigInt(intent.nonce),
        BigInt(intent.validAfter || "0"),
        BigInt(intent.validBefore || "0"),
        intent.policyId,
    ]);
    return keccak256(encoded);
}
//# sourceMappingURL=chain.js.map