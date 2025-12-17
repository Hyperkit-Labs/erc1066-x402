import { keccak256, encodeAbiParameters, parseAbiParameters, decodeAbiParameters } from "viem";
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
export function encodeIntent(intent) {
    return encodeAbiParameters(parseAbiParameters("address, address, bytes, uint256, uint256, uint256, uint256, bytes32"), [
        intent.sender,
        intent.target,
        intent.data,
        BigInt(intent.value),
        BigInt(intent.nonce),
        BigInt(intent.validAfter || "0"),
        BigInt(intent.validBefore || "0"),
        intent.policyId,
    ]);
}
export function decodeIntent(data) {
    const abiParams = parseAbiParameters("address, address, bytes, uint256, uint256, uint256, uint256, bytes32");
    const decoded = decodeAbiParameters(abiParams, data);
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
//# sourceMappingURL=utils.js.map