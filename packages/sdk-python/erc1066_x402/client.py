from typing import Dict, Any
import requests
from .types import Intent, StatusCode, Action, ValidateResponse, ExecuteResponse


class ERC1066Client:
    def __init__(self, gateway_url: str):
        self.gateway_url = gateway_url

    def validate_intent(self, intent: Intent, chain_id: int) -> ValidateResponse:
        response = requests.post(
            f"{self.gateway_url}/intents/validate",
            json=intent.model_dump(),
            headers={"X-Chain-Id": str(chain_id)},
        )
        response.raise_for_status()
        data = response.json()
        return ValidateResponse(
            status=data["status"],
            httpCode=response.status_code,
            intentHash=data["intentHash"],
            chainType=data["chainType"],
            chainId=data["chainId"],
            accepts=data.get("accepts"),
        )

    def execute_intent(self, intent: Intent, chain_id: int) -> ExecuteResponse:
        response = requests.post(
            f"{self.gateway_url}/intents/execute",
            json=intent.model_dump(),
            headers={"X-Chain-Id": str(chain_id)},
        )
        response.raise_for_status()
        data = response.json()
        return ExecuteResponse(**data)

    def map_status_to_action(self, status: StatusCode) -> Action:
        status_map: Dict[StatusCode, Action] = {
            "0x01": "execute",
            "0x20": "retry",
            "0x54": "request_payment",
        }
        return status_map.get(status, "deny")

