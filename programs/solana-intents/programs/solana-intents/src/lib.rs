use anchor_lang::prelude::*;
use anchor_lang::solana_program::clock::Clock;
use crate::state::*;
use crate::status::*;

pub mod state;
pub mod status;

declare_id!("B5fwL2MnnGTsJzShmJYjdVGSDwduyr3Guan9XNAF7Vbb");

#[program]
pub mod solana_intents {
    use super::*;

    pub fn initialize_policy(ctx: Context<InitializePolicy>, params: PolicyParams) -> Result<()> {
        let policy = &mut ctx.accounts.policy;
        policy.owner = ctx.accounts.owner.key();
        policy.allowed_targets = params.allowed_targets;
        policy.allowed_selectors = params.allowed_selectors;
        policy.max_value_per_tx = params.max_value_per_tx;
        policy.valid_after = params.valid_after;
        policy.valid_before = params.valid_before;
        policy.allowed_chains = params.allowed_chains;
        Ok(())
    }

    pub fn validate_intent(ctx: Context<ValidateIntent>, intent: Intent) -> Result<()> {
        let status = validate_logic(&intent, &ctx.accounts.policy)?;
        
        msg!("erc1066-x402: status={}", status);

        if status == S_SUCCESS || status == S_ALLOWED {
            Ok(())
        } else {
            return err!(IntentError::CustomStatus);
        }
    }

    pub fn execute_intent(ctx: Context<ExecuteIntent>, intent: Intent) -> Result<()> {
        let status = validate_logic(&intent, &ctx.accounts.policy)?;
        
        if status != S_SUCCESS && status != S_ALLOWED {
            return err!(IntentError::CustomStatus);
        }

        msg!("erc1066-x402: execution successful");
        
        Ok(())
    }
}

#[derive(Accounts)]
pub struct InitializePolicy<'info> {
    #[account(init, payer = owner, space = Policy::LEN)]
    pub policy: Account<'info, Policy>,
    #[account(mut)]
    pub owner: Signer<'info>,
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct ValidateIntent<'info> {
    pub policy: Account<'info, Policy>,
}

#[derive(Accounts)]
pub struct ExecuteIntent<'info> {
    pub policy: Account<'info, Policy>,
    #[account(mut)]
    pub sender: Signer<'info>,
    /// CHECK: Target program to be called
    pub target: AccountInfo<'info>,
}

#[derive(AnchorSerialize, AnchorDeserialize)]
pub struct PolicyParams {
    pub allowed_targets: Vec<Pubkey>,
    pub allowed_selectors: Vec<[u8; 4]>,
    pub max_value_per_tx: u64,
    pub valid_after: i64,
    pub valid_before: i64,
    pub allowed_chains: Vec<u64>,
}

fn validate_logic(intent: &Intent, policy: &Policy) -> Result<u16> {
    let now = Clock::get()?.unix_timestamp;

    if now < intent.valid_after || now < policy.valid_after {
        return Ok(S_TOO_EARLY);
    }
    if (intent.valid_before > 0 && now > intent.valid_before) || (policy.valid_before > 0 && now > policy.valid_before) {
        return Ok(S_TOO_LATE);
    }
    
    if !policy.allowed_targets.is_empty() && !policy.allowed_targets.contains(&intent.target) {
        return Ok(S_DISALLOWED);
    }

    if !policy.allowed_selectors.is_empty() {
        if intent.data.len() < 4 {
            return Ok(S_INTENT_INVALID_FORMAT);
        }
        let mut selector = [0u8; 4];
        selector.copy_from_slice(&intent.data[0..4]);
        if !policy.allowed_selectors.contains(&selector) {
            return Ok(S_UNSUPPORTED_ACTION);
        }
    }

    if intent.lamports > policy.max_value_per_tx {
        return Ok(S_INSUFFICIENT_FUNDS);
    }

    Ok(S_SUCCESS)
}

#[error_code]
pub enum IntentError {
    #[msg("ERC-1066 intent validation failed")]
    CustomStatus,
}

