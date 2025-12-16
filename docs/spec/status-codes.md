# HyperKit Status Codes (ERC‑1066 / x402 Subset)

This file defines the canonical onchain status codes used by the HyperKit intent semantics layer.
Codes are represented as `bytes1` and are intended to map cleanly to x402 / HTTP semantics.

## Generic

- `0x00` `STATUS_FAILURE`  
  Generic failure. Used when no more specific code is available.

- `0x01` `STATUS_SUCCESS`  
  Generic success.

## Authorization / Policy

- `0x10` `STATUS_DISALLOWED`  
  Policy, role, or registry denies the requested operation or target.

- `0x11` `STATUS_ALLOWED`  
  Policy and time window checks pass for the requested operation.

## Timing / State

- `0x20` `STATUS_TOO_EARLY`  
  Current timestamp is before `validAfter` or policy start time.

- `0x21` `STATUS_TOO_LATE`  
  Current timestamp is after `validBefore` or policy expiry.

- `0x22` `STATUS_NONCE_USED`  
  Nonce has already been consumed for this sender / domain.

## Funds / Payment

- `0x50` `STATUS_TRANSFER_FAILED`  
  Low‑level call or token transfer reverted.

- `0x51` `STATUS_TRANSFER_SUCCESS`  
  Transfer or value movement succeeded.

- `0x54` `STATUS_INSUFFICIENT_FUNDS`  
  Balance or allowance is insufficient to honour the requested value.

## Application / Routing

- `0xA0` `STATUS_INTENT_INVALID_FORMAT`  
  Intent is malformed or fails basic structural validation.

- `0xA1` `STATUS_UNSUPPORTED_ACTION`  
  Validator or executor does not recognise the requested action.

- `0xA2` `STATUS_UNSUPPORTED_CHAIN`  
  Intent or policy targets an unsupported chain ID.

## Usage Guidelines

- All validator contracts MUST return one of these codes from `canExecute`.
- `IntentExecutor` uses `StatusCodes.isSuccess(status)` to decide whether to proceed.
- Gateways and off‑chain agents map these codes to x402 / HTTP responses, but the
  onchain layer only cares about the codes themselves.


