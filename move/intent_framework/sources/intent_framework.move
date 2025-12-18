#[allow(unused_const, unused_field)]
module intent_framework::intent_framework {
    use sui::event;
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};

    // Global status codes (u64 == GlobalStatusId)
    const E_SUCCESS: u64               = 1;
    const E_DISALLOWED: u64            = 16;
    const E_ALLOWED: u64               = 17;
    const E_TOO_EARLY: u64             = 32;
    const E_TOO_LATE: u64              = 33;
    const E_NONCE_USED: u64            = 34;
    const E_TRANSFER_FAILED: u64       = 80;
    const E_TRANSFER_SUCCESS: u64      = 81;
    const E_INSUFFICIENT_FUNDS: u64    = 84;
    const E_INTENT_INVALID_FORMAT: u64 = 160;
    const E_UNSUPPORTED_ACTION: u64    = 161;
    const E_UNSUPPORTED_CHAIN: u64     = 162;

    public struct Intent has copy, drop {
        sender: address,
        target: address,
        data: vector<u8>,
        value: u64,
        nonce: u64,
        valid_after: u64,
        valid_before: u64,
        policy_id: vector<u8>,
    }

    public struct Policy has key {
        id: UID,
        owner: address,
        allowed_targets: vector<address>,
        allowed_selectors: vector<vector<u8>>,
        max_value_per_tx: u64,
        valid_after: u64,
        valid_before: u64,
        allowed_chains: vector<u64>,
    }

    public struct StatusEvent has copy, drop {
        intent_sender: address,
        status: u64,
    }

    public fun create_policy(
        owner: address,
        allowed_targets: vector<address>,
        allowed_selectors: vector<vector<u8>>,
        max_value_per_tx: u64,
        valid_after: u64,
        valid_before: u64,
        allowed_chains: vector<u64>,
        ctx: &mut TxContext
    ) {
        let policy = Policy {
            id: object::new(ctx),
            owner,
            allowed_targets,
            allowed_selectors,
            max_value_per_tx,
            valid_after,
            valid_before,
            allowed_chains,
        };
        sui::transfer::share_object(policy);
    }

    public fun validate_intent(
        policy: &Policy,
        intent: &Intent,
        _chain_id: u64,
        ctx: &mut TxContext
    ): u64 {
        let now = tx_context::epoch_timestamp_ms(ctx) / 1000;

        if (now < intent.valid_after || now < policy.valid_after) {
            return E_TOO_EARLY
        };
        if ((intent.valid_before > 0 && now > intent.valid_before) || (policy.valid_before > 0 && now > policy.valid_before)) {
            return E_TOO_LATE
        };

        if (!std::vector::is_empty(&policy.allowed_targets) && !std::vector::contains(&policy.allowed_targets, &intent.target)) {
            return E_DISALLOWED
        };

        if (!std::vector::is_empty(&policy.allowed_selectors)) {
            if (std::vector::length(&intent.data) < 4) {
                return E_INTENT_INVALID_FORMAT
            };
            let mut selector = std::vector::empty<u8>();
            let mut i = 0;
            while (i < 4) {
                std::vector::push_back(&mut selector, *std::vector::borrow(&intent.data, i));
                i = i + 1;
            };
            if (!std::vector::contains(&policy.allowed_selectors, &selector)) {
                return E_UNSUPPORTED_ACTION
            };
        };

        if (intent.value > policy.max_value_per_tx) {
            return E_INSUFFICIENT_FUNDS
        };

        E_SUCCESS
    }

    public fun execute_intent(
        policy: &Policy,
        intent: &Intent,
        chain_id: u64,
        ctx: &mut TxContext
    ) {
        let status = validate_intent(policy, intent, chain_id, ctx);
        
        if (status != E_SUCCESS && status != E_ALLOWED) {
            event::emit(StatusEvent { intent_sender: intent.sender, status });
            abort status
        };

        // TODO: Perform actual action (e.g., call into another module)
        event::emit(StatusEvent { intent_sender: intent.sender, status: E_TRANSFER_SUCCESS });
    }
}
