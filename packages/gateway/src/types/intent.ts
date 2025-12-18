export interface Intent {
  sender: string;
  target: string;
  data: string;
  value: string;
  nonce: string;
  validAfter?: string;
  validBefore?: string;
  policyId: string;
  chainType: "evm" | "solana" | "sui";
}

export interface Policy {
  owner: string;
  allowedTargets: string[];
  allowedSelectors: string[];
  maxValuePerTx: string;
  maxAggregateValue: string;
  validAfter: string;
  validBefore: string;
  allowedChains: string[];
}

