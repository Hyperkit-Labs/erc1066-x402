import * as borsh from "borsh";
import { Intent } from "../types/intent";

export class IntentInstruction {
  variant: number;
  intent: any;

  constructor(fields: { variant: number; intent: any }) {
    this.variant = fields.variant;
    this.intent = fields.intent;
  }
}

export const IntentSchema = new Map([
  [
    IntentInstruction,
    {
      kind: "struct",
      fields: [
        ["variant", "u8"],
        ["intent", "IntentData"],
      ],
    },
  ],
  [
    Object, // IntentData
    {
      kind: "struct",
      fields: [
        ["sender", [32]],
        ["target", [32]],
        ["data", ["u8"]],
        ["value", "u64"],
        ["nonce", "u64"],
        ["valid_after", "u64"],
        ["valid_before", "u64"],
        ["policy_id", [32]],
      ],
    },
  ],
]);

// Note: This is a simplified version. In a real app, you'd use the actual Borsh schema 
// that matches your Rust Program's state.rs and instruction dispatch.

