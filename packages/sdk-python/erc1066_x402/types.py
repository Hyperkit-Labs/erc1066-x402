from typing import Literal, Optional
from pydantic import BaseModel, Field

StatusCode = Literal[
    "0x00", "0x01", "0x10", "0x11", "0x20", "0x21", "0x22",
    "0x50", "0x51", "0x54", "0xA0", "0xA1", "0xA2"
]

Action = Literal["execute", "retry", "request_payment", "deny"]


class Intent(BaseModel):
    sender: str = Field(..., pattern=r"^0x[a-fA-F0-9]{40}$")
    target: str = Field(..., pattern=r"^0x[a-fA-F0-9]{40}$")
    data: str = Field(..., pattern=r"^0x[a-fA-F0-9]*$")
    value: str = Field(..., pattern=r"^\d+$")
    nonce: str = Field(..., pattern=r"^\d+$")
    validAfter: Optional[str] = Field(None, pattern=r"^\d+$")
    validBefore: Optional[str] = Field(None, pattern=r"^\d+$")
    policyId: str = Field(..., pattern=r"^0x[a-fA-F0-9]{64}$")


class ValidateResponse(BaseModel):
    status: StatusCode
    httpCode: int
    intentHash: str


class ExecuteResponse(BaseModel):
    status: StatusCode
    result: Optional[dict] = None
    paymentRequest: Optional[dict] = None
    error: Optional[str] = None

