/// <reference types="node" />

declare global {
  // Node.js 18+ has global fetch
  // eslint-disable-next-line no-var
  var fetch: (
    input: RequestInfo | URL,
    init?: RequestInit
  ) => Promise<Response>;
}

export {};

