from web3 import Web3
from .types import Intent


def compute_intent_hash(intent: Intent) -> str:
    encoded = Web3.solidity_keccak(
        ["address", "address", "bytes", "uint256", "uint256", "uint256", "uint256", "bytes32"],
        [
            intent.sender,
            intent.target,
            bytes.fromhex(intent.data[2:]),
            int(intent.value),
            int(intent.nonce),
            int(intent.validAfter or "0"),
            int(intent.validBefore or "0"),
            bytes.fromhex(intent.policyId[2:]),
        ],
    )
    return Web3.to_hex(encoded)

