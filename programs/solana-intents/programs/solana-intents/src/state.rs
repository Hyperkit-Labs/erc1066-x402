use anchor_lang::prelude::*;

#[derive(AnchorSerialize, AnchorDeserialize, Clone, Debug)]
pub struct Intent {
    pub sender: Pubkey,
    pub target: Pubkey,
    pub data: Vec<u8>,
    pub lamports: u64,
    pub nonce: u64,
    pub valid_after: i64,
    pub valid_before: i64,
    pub policy_id: [u8; 32],
}

#[account]
pub struct Policy {
    pub owner: Pubkey,
    pub allowed_targets: Vec<Pubkey>,
    pub allowed_selectors: Vec<[u8; 4]>,
    pub max_value_per_tx: u64,
    pub valid_after: i64,
    pub valid_before: i64,
    pub allowed_chains: Vec<u64>,
}

impl Policy {
    pub const LEN: usize = 8 + // discriminator
        32 + // owner
        4 + (32 * 10) + // allowed_targets (max 10)
        4 + (4 * 10) + // allowed_selectors (max 10)
        8 + // max_value_per_tx
        8 + // valid_after
        8 + // valid_before
        4 + (8 * 10); // allowed_chains (max 10)
}

