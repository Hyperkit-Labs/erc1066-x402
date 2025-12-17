import { mapStatusToHttp } from "../utils/status";
import { getRpcClient, getChainConfig } from "../config/chains";
import { ChainNotSupportedError } from "../utils/errors";
const EXECUTOR_ABI = [
    {
        name: "canExecute",
        type: "function",
        stateMutability: "view",
        inputs: [
            {
                name: "intent",
                type: "tuple",
                components: [
                    { name: "sender", type: "address" },
                    { name: "target", type: "address" },
                    { name: "data", type: "bytes" },
                    { name: "value", type: "uint256" },
                    { name: "nonce", type: "uint256" },
                    { name: "validAfter", type: "uint256" },
                    { name: "validBefore", type: "uint256" },
                    { name: "policyId", type: "bytes32" },
                ],
            },
        ],
        outputs: [{ name: "status", type: "bytes1" }],
    },
];
export class IntentValidator {
    async canExecute(intent, chainId) {
        const client = await getRpcClient(chainId);
        if (!client) {
            throw new ChainNotSupportedError(chainId);
        }
        const config = getChainConfig(chainId);
        if (!config) {
            throw new ChainNotSupportedError(chainId);
        }
        try {
            const status = await client.readContract({
                address: config.executorAddress,
                abi: EXECUTOR_ABI,
                functionName: "canExecute",
                args: [
                    {
                        sender: intent.sender,
                        target: intent.target,
                        data: intent.data,
                        value: BigInt(intent.value),
                        nonce: BigInt(intent.nonce),
                        validAfter: BigInt(intent.validAfter || "0"),
                        validBefore: BigInt(intent.validBefore || "0"),
                        policyId: intent.policyId,
                    },
                ],
            });
            return status;
        }
        catch (error) {
            return "0x00";
        }
    }
    mapStatusToHttp(status) {
        return mapStatusToHttp(status);
    }
}
//# sourceMappingURL=validator.js.map