from typing import Literal, Optional, List, Dict, Any
from pydantic import BaseModel, Field

StatusCode = Literal[
    "0x00", "0x01", "0x10", "0x11", "0x20", "0x21", "0x22",
    "0x50", "0x51", "0x54", "0xA0", "0xA1", "0xA2"
]

Action = Literal["execute", "retry", "request_payment", "deny"]


class Intent(BaseModel):
    sender: str
    target: str
    data: str = Field(..., pattern=r"^0x[a-fA-F0-9]*$")
    value: str = Field(..., pattern=r"^\d+$")
    nonce: str = Field(..., pattern=r"^\d+$")
    validAfter: Optional[str] = Field(None, pattern=r"^\d+$")
    validBefore: Optional[str] = Field(None, pattern=r"^\d+$")
    policyId: str
    chainType: Literal["evm", "solana", "sui"]


class ValidateResponse(BaseModel):
    status: StatusCode
    httpCode: int
    intentHash: str
    chainType: str
    chainId: int
    accepts: Optional[List[Dict[str, Any]]] = None


class ExecuteResponse(BaseModel):
    status: StatusCode
    result: Optional[dict] = None
    paymentRequest: Optional[dict] = None
    error: Optional[str] = None
    intentHash: str
    chainType: str
    chainId: int
