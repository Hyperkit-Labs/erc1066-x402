import { getRpcClient, getChainConfig } from "../config/chains";
import { ChainNotSupportedError } from "../utils/errors";
const EXECUTOR_ABI = [
    {
        name: "execute",
        type: "function",
        stateMutability: "payable",
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
        outputs: [{ name: "returnData", type: "bytes" }],
    },
];
export class IntentExecutor {
    validator;
    constructor(validator) {
        this.validator = validator;
    }
    async execute(intent, chainId, walletClient) {
        const status = await this.validator.canExecute(intent, chainId);
        if (status !== "0x01") {
            return { status };
        }
        const client = await getRpcClient(chainId);
        if (!client) {
            throw new ChainNotSupportedError(chainId);
        }
        const config = getChainConfig(chainId);
        if (!config) {
            throw new ChainNotSupportedError(chainId);
        }
        if (!walletClient) {
            throw new Error("Wallet client required for execution");
        }
        try {
            const hash = await walletClient.writeContract({
                chain: undefined,
                address: config.executorAddress,
                abi: EXECUTOR_ABI,
                functionName: "execute",
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
                value: BigInt(intent.value),
            });
            const receipt = await client.waitForTransactionReceipt({ hash });
            return {
                status: "0x01",
                returnData: receipt.status === "success" ? "0x" : undefined,
            };
        }
        catch (error) {
            return { status: "0x50" };
        }
    }
}
//# sourceMappingURL=executor.js.map