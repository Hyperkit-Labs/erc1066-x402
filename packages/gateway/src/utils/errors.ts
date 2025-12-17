export class GatewayError extends Error {
  constructor(
    message: string,
    public statusCode: number,
    public headers: Record<string, string> = {}
  ) {
    super(message);
    this.name = "GatewayError";
  }
}

export class ValidationError extends GatewayError {
  constructor(message: string) {
    super(message, 400);
  }
}

export class ChainNotSupportedError extends GatewayError {
  constructor(chainId: number) {
    super(`Chain ${chainId} is not supported`, 421);
  }
}

