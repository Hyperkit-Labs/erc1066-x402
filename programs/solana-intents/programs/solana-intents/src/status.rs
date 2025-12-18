//! ERC-1066-x402 Status Codes for Solana
//! These constants match the global HyperKit specification.

pub const S_SUCCESS: u16               = 1;
pub const S_DISALLOWED: u16            = 16;
pub const S_ALLOWED: u16               = 17;
pub const S_TOO_EARLY: u16             = 32;
pub const S_TOO_LATE: u16              = 33;
pub const S_NONCE_USED: u16            = 34;
pub const S_TRANSFER_FAILED: u16       = 80;
pub const S_TRANSFER_SUCCESS: u16      = 81;
pub const S_INSUFFICIENT_FUNDS: u16    = 84;
pub const S_INTENT_INVALID_FORMAT: u16 = 160;
pub const S_UNSUPPORTED_ACTION: u16    = 161;
pub const S_UNSUPPORTED_CHAIN: u16     = 162;

