module 0xface729284ae5729100b3a9ad7f7cc025ea09739cd6e7252aff0beb53619cafe::emojicoin_dot_fun {
    struct Chat has copy, drop, store {
        market_metadata: MarketMetadata,
        emit_time: u64,
        emit_market_nonce: u64,
        user: address,
        message: 0x1::string::String,
        user_emojicoin_balance: u64,
        circulating_supply: u64,
        balance_as_fraction_of_circulating_supply_q64: u128,
    }
    
    struct CumulativeStats has copy, drop, store {
        base_volume: u128,
        quote_volume: u128,
        integrator_fees: u128,
        pool_fees_base: u128,
        pool_fees_quote: u128,
        n_swaps: u64,
        n_chat_messages: u64,
    }
    
    struct GlobalState has drop, store {
        emit_time: u64,
        registry_nonce: 0x1::aggregator_v2::AggregatorSnapshot<u64>,
        trigger: u8,
        cumulative_quote_volume: 0x1::aggregator_v2::AggregatorSnapshot<u128>,
        total_quote_locked: 0x1::aggregator_v2::AggregatorSnapshot<u128>,
        total_value_locked: 0x1::aggregator_v2::AggregatorSnapshot<u128>,
        market_cap: 0x1::aggregator_v2::AggregatorSnapshot<u128>,
        fully_diluted_value: 0x1::aggregator_v2::AggregatorSnapshot<u128>,
        cumulative_integrator_fees: 0x1::aggregator_v2::AggregatorSnapshot<u128>,
        cumulative_swaps: 0x1::aggregator_v2::AggregatorSnapshot<u64>,
        cumulative_chat_messages: 0x1::aggregator_v2::AggregatorSnapshot<u64>,
    }
    
    struct GlobalStats has drop, store {
        cumulative_quote_volume: 0x1::aggregator_v2::Aggregator<u128>,
        total_quote_locked: 0x1::aggregator_v2::Aggregator<u128>,
        total_value_locked: 0x1::aggregator_v2::Aggregator<u128>,
        market_cap: 0x1::aggregator_v2::Aggregator<u128>,
        fully_diluted_value: 0x1::aggregator_v2::Aggregator<u128>,
        cumulative_integrator_fees: 0x1::aggregator_v2::Aggregator<u128>,
        cumulative_swaps: 0x1::aggregator_v2::Aggregator<u64>,
        cumulative_chat_messages: 0x1::aggregator_v2::Aggregator<u64>,
    }
    
    struct InstantaneousStats has copy, drop, store {
        total_quote_locked: u64,
        total_value_locked: u128,
        market_cap: u128,
        fully_diluted_value: u128,
    }
    
    struct LPCoinCapabilities<phantom T0, phantom T1> has key {
        burn: 0x1::coin::BurnCapability<T1>,
        mint: 0x1::coin::MintCapability<T1>,
    }
    
    struct LastSwap has copy, drop, store {
        is_sell: bool,
        avg_execution_price_q64: u128,
        base_volume: u64,
        quote_volume: u64,
        nonce: u64,
        time: u64,
    }
    
    struct Liquidity has copy, drop, store {
        market_id: u64,
        time: u64,
        market_nonce: u64,
        provider: address,
        base_amount: u64,
        quote_amount: u64,
        lp_coin_amount: u64,
        liquidity_provided: bool,
        base_donation_claim_amount: u64,
        quote_donation_claim_amount: u64,
    }
    
    struct Market has key {
        metadata: MarketMetadata,
        sequence_info: SequenceInfo,
        extend_ref: 0x1::object::ExtendRef,
        clamm_virtual_reserves: Reserves,
        cpamm_real_reserves: Reserves,
        lp_coin_supply: u128,
        cumulative_stats: CumulativeStats,
        last_swap: LastSwap,
        periodic_state_trackers: vector<PeriodicStateTracker>,
    }
    
    struct MarketMetadata has copy, drop, store {
        market_id: u64,
        market_address: address,
        emoji_bytes: vector<u8>,
    }
    
    struct MarketRegistration has copy, drop, store {
        market_metadata: MarketMetadata,
        time: u64,
        registrant: address,
        integrator: address,
        integrator_fee: u64,
    }
    
    struct MarketView has copy, drop, store {
        metadata: MarketMetadata,
        sequence_info: SequenceInfo,
        clamm_virtual_reserves: Reserves,
        cpamm_real_reserves: Reserves,
        lp_coin_supply: u128,
        in_bonding_curve: bool,
        cumulative_stats: CumulativeStats,
        instantaneous_stats: InstantaneousStats,
        last_swap: LastSwap,
        periodic_state_trackers: vector<PeriodicStateTracker>,
        aptos_coin_balance: u64,
        emojicoin_balance: u64,
        emojicoin_lp_balance: u64,
    }
    
    struct ParallelizableSequenceInfo has drop, store {
        nonce: 0x1::aggregator_v2::Aggregator<u64>,
        last_bump_time: u64,
    }
    
    struct PeriodicState has copy, drop, store {
        market_metadata: MarketMetadata,
        periodic_state_metadata: PeriodicStateMetadata,
        open_price_q64: u128,
        high_price_q64: u128,
        low_price_q64: u128,
        close_price_q64: u128,
        volume_base: u128,
        volume_quote: u128,
        integrator_fees: u128,
        pool_fees_base: u128,
        pool_fees_quote: u128,
        n_swaps: u64,
        n_chat_messages: u64,
        starts_in_bonding_curve: bool,
        ends_in_bonding_curve: bool,
        tvl_per_lp_coin_growth_q64: u128,
    }
    
    struct PeriodicStateMetadata has copy, drop, store {
        start_time: u64,
        period: u64,
        emit_time: u64,
        emit_market_nonce: u64,
        trigger: u8,
    }
    
    struct PeriodicStateTracker has copy, drop, store {
        start_time: u64,
        period: u64,
        open_price_q64: u128,
        high_price_q64: u128,
        low_price_q64: u128,
        close_price_q64: u128,
        volume_base: u128,
        volume_quote: u128,
        integrator_fees: u128,
        pool_fees_base: u128,
        pool_fees_quote: u128,
        n_swaps: u64,
        n_chat_messages: u64,
        starts_in_bonding_curve: bool,
        ends_in_bonding_curve: bool,
        tvl_to_lp_coin_ratio_start: TVLtoLPCoinRatio,
        tvl_to_lp_coin_ratio_end: TVLtoLPCoinRatio,
    }
    
    struct RegistrantDeposit has key {
        market_registrant: address,
        deposit: 0x1::coin::Coin<0x1::aptos_coin::AptosCoin>,
    }
    
    struct RegistrantGracePeriodFlag has drop, key {
        market_registrant: address,
        market_registration_time: u64,
    }
    
    struct Registry has key {
        registry_address: address,
        sequence_info: ParallelizableSequenceInfo,
        coin_symbol_emojis: 0x1::table::Table<vector<u8>, u8>,
        supplemental_chat_emojis: 0x1::table::Table<vector<u8>, u8>,
        markets_by_emoji_bytes: 0x1::smart_table::SmartTable<vector<u8>, address>,
        markets_by_market_id: 0x1::smart_table::SmartTable<u64, address>,
        extend_ref: 0x1::object::ExtendRef,
        global_stats: GlobalStats,
    }
    
    struct RegistryAddress has key {
        registry_address: address,
    }
    
    struct RegistryView has drop, store {
        registry_address: address,
        nonce: 0x1::aggregator_v2::AggregatorSnapshot<u64>,
        last_bump_time: u64,
        n_markets: u64,
        cumulative_quote_volume: 0x1::aggregator_v2::AggregatorSnapshot<u128>,
        total_quote_locked: 0x1::aggregator_v2::AggregatorSnapshot<u128>,
        total_value_locked: 0x1::aggregator_v2::AggregatorSnapshot<u128>,
        market_cap: 0x1::aggregator_v2::AggregatorSnapshot<u128>,
        fully_diluted_value: 0x1::aggregator_v2::AggregatorSnapshot<u128>,
        cumulative_integrator_fees: 0x1::aggregator_v2::AggregatorSnapshot<u128>,
        cumulative_swaps: 0x1::aggregator_v2::AggregatorSnapshot<u64>,
        cumulative_chat_messages: 0x1::aggregator_v2::AggregatorSnapshot<u64>,
    }
    
    struct Reserves has copy, drop, store {
        base: u64,
        quote: u64,
    }
    
    struct SequenceInfo has copy, drop, store {
        nonce: u64,
        last_bump_time: u64,
    }
    
    struct State has copy, drop, store {
        market_metadata: MarketMetadata,
        state_metadata: StateMetadata,
        clamm_virtual_reserves: Reserves,
        cpamm_real_reserves: Reserves,
        lp_coin_supply: u128,
        cumulative_stats: CumulativeStats,
        instantaneous_stats: InstantaneousStats,
        last_swap: LastSwap,
    }
    
    struct StateMetadata has copy, drop, store {
        market_nonce: u64,
        bump_time: u64,
        trigger: u8,
    }
    
    struct Swap has copy, drop, store {
        market_id: u64,
        time: u64,
        market_nonce: u64,
        swapper: address,
        input_amount: u64,
        is_sell: bool,
        integrator: address,
        integrator_fee_rate_bps: u8,
        net_proceeds: u64,
        base_volume: u64,
        quote_volume: u64,
        avg_execution_price_q64: u128,
        integrator_fee: u64,
        pool_fee: u64,
        starts_in_bonding_curve: bool,
        results_in_state_transition: bool,
        balance_as_fraction_of_circulating_supply_before_q64: u128,
        balance_as_fraction_of_circulating_supply_after_q64: u128,
    }
    
    struct TVLtoLPCoinRatio has copy, drop, store {
        tvl: u128,
        lp_coins: u128,
    }
    
    public entry fun swap<T0, T1>(arg0: &signer, arg1: address, arg2: u64, arg3: bool, arg4: address, arg5: u8, arg6: u64) acquires LPCoinCapabilities, Market, RegistrantDeposit, RegistrantGracePeriodFlag, Registry, RegistryAddress {
        assert!(exists<Market>(arg1), 2);
        let v0 = borrow_global_mut<Market>(arg1);
        let v1 = 0x1::object::generate_signer_for_extending(&v0.extend_ref);
        assert!(arg6 > 0, 18);
        let v2 = 0x1::signer::address_of(arg0);
        let v3 = simulate_swap_inner<T0, T1>(v2, arg2, arg3, arg4, arg5, v0);
        assert!(v3.net_proceeds >= arg6, 19);
        if (exists<RegistrantGracePeriodFlag>(arg1)) {
            let v4 = borrow_global<RegistrantGracePeriodFlag>(arg1);
            assert!(v3.time > v4.market_registration_time + 300000000 || v2 == v4.market_registrant, 16);
            move_from<RegistrantGracePeriodFlag>(arg1);
        };
        let v5 = if (v3.starts_in_bonding_curve) {
            let v6 = v0.clamm_virtual_reserves;
            let v7 = v6.quote;
            let v8 = v7 - 40000000000;
            let v9 = if (v8 == 0) {
                0
            } else {
                let v10 = v6.base;
                (v8 as u128) + (v7 as u128) * ((v10 - 1400000000000000 + 1000000000000000) as u128) / (v10 as u128)
            };
            v9
        } else {
            2 * (v0.cpamm_real_reserves.quote as u128)
        };
        let v11 = borrow_global_mut<Registry>(borrow_global<RegistryAddress>(@0xface729284ae5729100b3a9ad7f7cc025ea09739cd6e7252aff0beb53619cafe).registry_address);
        let v12 = v3.time;
        let v13 = if (arg3) {
            3
        } else {
            2
        };
        trigger_periodic_state(v0, v11, v12, v13, v5);
        let v14 = v3.quote_volume as u128;
        let v15 = v3.base_volume as u128;
        let v16 = &mut v0.cumulative_stats;
        let v17 = &mut v11.global_stats;
        let v18 = 0;
        let v19 = 0;
        let v20 = v3.results_in_state_transition;
        let v21 = v86 && !v20;
        if (!0x1::account::exists_at(v2)) {
            0x1::aptos_account::create_account(v2);
        };
        0x1::coin::register<0x1::aptos_coin::AptosCoin>(arg0);
        let (v22, v23, v24, v25, v26) = if (arg3) {
            0x1::coin::register<T0>(arg0);
            0x1::coin::transfer<T0>(arg0, arg1, arg2);
            let v27 = v3.quote_volume + v3.integrator_fee;
            let v26 = 0x1::coin::withdraw<0x1::aptos_coin::AptosCoin>(&v1, v27);
            0x1::aptos_account::deposit_coins<0x1::aptos_coin::AptosCoin>(v2, 0x1::coin::extract<0x1::aptos_coin::AptosCoin>(&mut v26, v3.quote_volume));
            let (v28, v29) = if (v86) {
                (4900000000000000, &mut v0.clamm_virtual_reserves)
            } else {
                (4500000000000000, &mut v0.cpamm_real_reserves)
            };
            let v30 = *v29;
            let v31 = v30;
            v31.base = v31.base + v3.input_amount;
            v31.quote = v31.quote - v27;
            *v29 = v31;
            let v32 = v30;
            let v33 = v32.base;
            let v34 = v32.quote;
            let v35 = v31;
            let v36 = v35.base;
            let v37 = v35.quote;
            0x1::aggregator_v2::try_sub<u128>(&mut v17.total_quote_locked, v27 as u128);
            let v38 = &mut v16.pool_fees_quote;
            let v39 = v3.pool_fee as u128;
            v19 = v39;
            *v38 = *v38 + v39;
            ((v37 as u128) * (4500000000000000 as u128) / (v36 as u128), (v34 as u128) * (4500000000000000 as u128) / (v33 as u128), (v37 as u128) * ((v28 - v36) as u128) / (v36 as u128), (v34 as u128) * ((v28 - v33) as u128) / (v33 as u128), v26)
        } else {
            let v26 = 0x1::coin::withdraw<0x1::aptos_coin::AptosCoin>(arg0, arg2);
            0x1::coin::deposit<0x1::aptos_coin::AptosCoin>(arg1, 0x1::coin::extract<0x1::aptos_coin::AptosCoin>(&mut v26, v3.quote_volume));
            0x1::aptos_account::transfer_coins<T0>(&v1, v2, v3.base_volume);
            let (v22, v23, v24, v25) = if (v20) {
                0x1::coin::deposit<T1>(arg1, 0x1::coin::mint<T1>(10000000000000, &borrow_global<LPCoinCapabilities<T0, T1>>(arg1).mint));
                v0.lp_coin_supply = 10000000000000 as u128;
                let v40 = &mut v0.clamm_virtual_reserves;
                let v41 = *v40;
                let v42 = Reserves{
                    base  : 0, 
                    quote : 0,
                };
                *v40 = v42;
                let v43 = Reserves{
                    base  : 1000000000000000 - v3.base_volume - v41.base - 1400000000000000, 
                    quote : 100000000000 + v3.quote_volume - 140000000000 - v41.quote,
                };
                v0.cpamm_real_reserves = v43;
                let v44 = v41;
                let v45 = v44.base;
                let v46 = v44.quote;
                let v47 = v43;
                let v48 = v47.base;
                let v49 = v47.quote;
                let RegistrantDeposit {
                    market_registrant : v50,
                    deposit           : v51,
                } = move_from<RegistrantDeposit>(arg1);
                0x1::coin::deposit<0x1::aptos_coin::AptosCoin>(v50, v51);
                ((v49 as u128) * (4500000000000000 as u128) / (v48 as u128), (v46 as u128) * (4500000000000000 as u128) / (v45 as u128), (v49 as u128) * ((4500000000000000 - v48) as u128) / (v48 as u128), (v46 as u128) * ((4900000000000000 - v45) as u128) / (v45 as u128))
            } else {
                let (v52, v53) = if (v86) {
                    (4900000000000000, &mut v0.clamm_virtual_reserves)
                } else {
                    (4500000000000000, &mut v0.cpamm_real_reserves)
                };
                let v54 = *v53;
                let v55 = v54;
                v55.base = v55.base - v3.base_volume;
                v55.quote = v55.quote + v3.quote_volume;
                *v53 = v55;
                let v56 = v54;
                let v57 = v56.base;
                let v58 = v56.quote;
                let v59 = v55;
                let v60 = v59.base;
                let v61 = v59.quote;
                ((v61 as u128) * (4500000000000000 as u128) / (v60 as u128), (v58 as u128) * (4500000000000000 as u128) / (v57 as u128), (v61 as u128) * ((v52 - v60) as u128) / (v60 as u128), (v58 as u128) * ((v52 - v57) as u128) / (v57 as u128))
            };
            0x1::aggregator_v2::try_add<u128>(&mut v17.total_quote_locked, v14);
            let v62 = &mut v16.pool_fees_base;
            let v63 = v3.pool_fee as u128;
            v18 = v63;
            *v62 = *v62 + v63;
            (v22, v23, v24, v25, v26)
        };
        0x1::aptos_account::deposit_coins<0x1::aptos_coin::AptosCoin>(arg4, v26);
        let v64 = &mut v16.base_volume;
        let v65 = &mut v16.quote_volume;
        *v64 = *v64 + v15;
        *v65 = *v65 + v14;
        0x1::aggregator_v2::try_add<u128>(&mut v17.cumulative_quote_volume, v14);
        let v66 = v3.integrator_fee as u128;
        let v67 = &mut v16.integrator_fees;
        *v67 = *v67 + v66;
        0x1::aggregator_v2::try_add<u128>(&mut v17.cumulative_integrator_fees, v66);
        let v68 = &mut v16.n_swaps;
        *v68 = *v68 + 1;
        0x1::aggregator_v2::try_add<u64>(&mut v17.cumulative_swaps, 1);
        let v69 = if (v21) {
            let v70 = v0.clamm_virtual_reserves;
            let v71 = v70.quote;
            let v72 = v71 - 40000000000;
            let v73 = if (v72 == 0) {
                0
            } else {
                let v74 = v70.base;
                (v72 as u128) + (v71 as u128) * ((v74 - 1400000000000000 + 1000000000000000) as u128) / (v74 as u128)
            };
            v73
        } else {
            2 * (v0.cpamm_real_reserves.quote as u128)
        };
        if (v69 > v5) {
            0x1::aggregator_v2::try_add<u128>(&mut v17.total_value_locked, v69 - v5);
        } else {
            0x1::aggregator_v2::try_sub<u128>(&mut v17.total_value_locked, v5 - v69);
        };
        if (v22 > v23) {
            0x1::aggregator_v2::try_add<u128>(&mut v17.fully_diluted_value, v22 - v23);
        } else {
            0x1::aggregator_v2::try_sub<u128>(&mut v17.fully_diluted_value, v23 - v22);
        };
        if (v24 > v25) {
            0x1::aggregator_v2::try_add<u128>(&mut v17.market_cap, v24 - v25);
        } else {
            0x1::aggregator_v2::try_sub<u128>(&mut v17.market_cap, v25 - v24);
        };
        let v75 = v3.avg_execution_price_q64;
        let v76 = LastSwap{
            is_sell                 : arg3, 
            avg_execution_price_q64 : v75, 
            base_volume             : v3.base_volume, 
            quote_volume            : v3.quote_volume, 
            nonce                   : v3.market_nonce, 
            time                    : v12,
        };
        v0.last_swap = v76;
        let v77 = &mut v0.periodic_state_trackers;
        let v78 = 0;
        while (v78 < 0x1::vector::length<PeriodicStateTracker>(v77)) {
            let v79 = 0x1::vector::borrow_mut<PeriodicStateTracker>(v77, v78);
            if (v79.open_price_q64 == 0) {
                v79.open_price_q64 = v75;
            };
            if (v75 > v79.high_price_q64) {
                v79.high_price_q64 = v75;
            };
            if (v79.low_price_q64 == 0 || v75 < v79.low_price_q64) {
                v79.low_price_q64 = v75;
            };
            v79.close_price_q64 = v75;
            v79.volume_base = v79.volume_base + v15;
            v79.volume_quote = v79.volume_quote + v14;
            v79.integrator_fees = v79.integrator_fees + v66;
            v79.pool_fees_base = v79.pool_fees_base + v18;
            v79.pool_fees_quote = v79.pool_fees_quote + v19;
            v79.tvl_to_lp_coin_ratio_end.tvl = v69;
            v79.tvl_to_lp_coin_ratio_end.lp_coins = v0.lp_coin_supply;
            v79.n_swaps = v79.n_swaps + 1;
            v79.ends_in_bonding_curve = v21;
            v78 = v78 + 1;
        };
        0x1::event::emit<Swap>(v3);
        let v80 = if (v21) {
            v0.clamm_virtual_reserves.quote - 40000000000
        } else {
            v0.cpamm_real_reserves.quote
        };
        let v81 = v0;
        let v82 = InstantaneousStats{
            total_quote_locked  : v80, 
            total_value_locked  : v69, 
            market_cap          : v24, 
            fully_diluted_value : v22,
        };
        let v83 = &v81.sequence_info;
        let v84 = StateMetadata{
            market_nonce : v83.nonce, 
            bump_time    : v83.last_bump_time, 
            trigger      : v13,
        };
        let v85 = State{
            market_metadata        : v81.metadata, 
            state_metadata         : v84, 
            clamm_virtual_reserves : v81.clamm_virtual_reserves, 
            cpamm_real_reserves    : v81.cpamm_real_reserves, 
            lp_coin_supply         : v81.lp_coin_supply, 
            cumulative_stats       : v81.cumulative_stats, 
            instantaneous_stats    : v82, 
            last_swap              : v81.last_swap,
        };
        0x1::event::emit<State>(v85);
    }
    
    public entry fun chat<T0, T1>(arg0: &signer, arg1: address, arg2: vector<vector<u8>>, arg3: vector<u8>) acquires Market, Registry, RegistryAddress {
        assert!(exists<Market>(arg1), 2);
        let v0 = borrow_global_mut<Market>(arg1);
        let v1 = 0x1::object::generate_signer_for_extending(&v0.extend_ref);
        let v2 = v0;
        let v3 = &v1;
        if (!exists<LPCoinCapabilities<T0, T1>>(arg1)) {
            let v4 = 0x1::type_info::type_of<T0>();
            let v5 = &v4;
            let v6 = 0x1::type_info::type_of<T1>();
            let v7 = &v6;
            assert!(0x1::type_info::account_address(v5) == arg1 && 0x1::type_info::account_address(v7) == arg1 && 0x1::type_info::module_name(v5) == b"coin_factory" && 0x1::type_info::module_name(v7) == b"coin_factory" && 0x1::type_info::struct_name(v5) == b"Emojicoin" && 0x1::type_info::struct_name(v7) == b"EmojicoinLP", 6);
            let v8 = 0x1::string::utf8(v2.metadata.emoji_bytes);
            let v9 = v8;
            0x1::string::append(&mut v9, 0x1::string::utf8(b" emojicoin"));
            let (v10, v11, v12) = 0x1::coin::initialize<T0>(v3, v9, v8, 8, true);
            let v13 = v12;
            0x1::aptos_account::deposit_coins<T0>(arg1, 0x1::coin::mint<T0>(4500000000000000, &v13));
            0x1::coin::destroy_freeze_cap<T0>(v11);
            0x1::coin::destroy_mint_cap<T0>(v13);
            0x1::coin::destroy_burn_cap<T0>(v10);
            let v14 = 0x1::string::utf8(b"LP-");
            0x1::string::append(&mut v14, 0x1::string_utils::to_string<u64>(&v2.metadata.market_id));
            let v15 = v8;
            0x1::string::append(&mut v15, 0x1::string::utf8(b" emojicoin LP"));
            let (v16, v17, v18) = 0x1::coin::initialize<T1>(v3, v15, v14, 8, true);
            0x1::coin::register<T1>(v3);
            0x1::coin::destroy_freeze_cap<T1>(v17);
            let v19 = LPCoinCapabilities<T0, T1>{
                burn : v16, 
                mint : v18,
            };
            move_to<LPCoinCapabilities<T0, T1>>(v3, v19);
        };
        let v20 = 0x1::vector::length<u8>(&arg3);
        assert!(v20 <= 100, 12);
        assert!(v20 > 0, 13);
        let v21 = 0x1::string::utf8(b"");
        let v22 = arg3;
        0x1::vector::reverse<u8>(&mut v22);
        let v23 = v22;
        let v24 = 0x1::vector::length<u8>(&v23);
        while (v24 > 0) {
            let v25 = 0x1::vector::pop_back<u8>(&mut v23);
            assert!((v25 as u64) < 0x1::vector::length<vector<u8>>(&arg2), 14);
            let v26 = *0x1::vector::borrow<vector<u8>>(&arg2, v25 as u64);
            assert!(is_a_supported_chat_emoji(v26), 11);
            0x1::string::append_utf8(&mut v21, v26);
            v24 = v24 - 1;
        };
        0x1::vector::destroy_empty<u8>(v23);
        let v27 = 0x1::signer::address_of(arg0);
        let v28 = borrow_global_mut<Registry>(borrow_global<RegistryAddress>(@0xface729284ae5729100b3a9ad7f7cc025ea09739cd6e7252aff0beb53619cafe).registry_address);
        let v29 = v0.lp_coin_supply == 0;
        let v30 = 0x1::timestamp::now_microseconds();
        let v31 = if (v29) {
            let v32 = v0.clamm_virtual_reserves;
            let v33 = v32.quote;
            let v34 = v33 - 40000000000;
            let v35 = if (v34 == 0) {
                0
            } else {
                let v36 = v32.base;
                (v34 as u128) + (v33 as u128) * ((v36 - 1400000000000000 + 1000000000000000) as u128) / (v36 as u128)
            };
            v35
        } else {
            2 * (v0.cpamm_real_reserves.quote as u128)
        };
        let v37 = 6;
        trigger_periodic_state(v0, v28, v30, v37, v31);
        let v38 = &mut v0.cumulative_stats.n_chat_messages;
        *v38 = *v38 + 1;
        0x1::aggregator_v2::try_add<u64>(&mut v28.global_stats.cumulative_chat_messages, 1);
        let v39 = &mut v0.periodic_state_trackers;
        let v40 = 0;
        while (v40 < 0x1::vector::length<PeriodicStateTracker>(v39)) {
            let v41 = 0x1::vector::borrow_mut<PeriodicStateTracker>(v39, v40);
            v41.n_chat_messages = v41.n_chat_messages + 1;
            v40 = v40 + 1;
        };
        let (v42, v43) = if (v29) {
            (4900000000000000, &v0.clamm_virtual_reserves)
        } else {
            (4500000000000000, &v0.cpamm_real_reserves)
        };
        let v44 = v42 - v43.base;
        let v45 = if (!0x1::coin::is_account_registered<T0>(v27)) {
            if (!0x1::account::exists_at(v27)) {
                0x1::aptos_account::create_account(v27);
            };
            0x1::coin::register<T0>(arg0);
            0
        } else {
            0x1::coin::balance<T0>(v27)
        };
        let v46 = if (v44 == 0) {
            0
        } else {
            ((v45 as u128) << 64) / (v44 as u128)
        };
        let v47 = Chat{
            market_metadata                               : v0.metadata, 
            emit_time                                     : v30, 
            emit_market_nonce                             : v0.sequence_info.nonce, 
            user                                          : v27, 
            message                                       : v21, 
            user_emojicoin_balance                        : v45, 
            circulating_supply                            : v44, 
            balance_as_fraction_of_circulating_supply_q64 : v46,
        };
        0x1::event::emit<Chat>(v47);
        let v48 = *v43;
        let v49 = v48.base;
        let v50 = v48.quote;
        let v51 = if (v29) {
            v0.clamm_virtual_reserves.quote - 40000000000
        } else {
            v0.cpamm_real_reserves.quote
        };
        let v52 = v0;
        let v53 = InstantaneousStats{
            total_quote_locked  : v51, 
            total_value_locked  : v31, 
            market_cap          : (v50 as u128) * ((v42 - v49) as u128) / (v49 as u128), 
            fully_diluted_value : (v50 as u128) * (4500000000000000 as u128) / (v49 as u128),
        };
        let v54 = &v52.sequence_info;
        let v55 = StateMetadata{
            market_nonce : v54.nonce, 
            bump_time    : v54.last_bump_time, 
            trigger      : v37,
        };
        let v56 = State{
            market_metadata        : v52.metadata, 
            state_metadata         : v55, 
            clamm_virtual_reserves : v52.clamm_virtual_reserves, 
            cpamm_real_reserves    : v52.cpamm_real_reserves, 
            lp_coin_supply         : v52.lp_coin_supply, 
            cumulative_stats       : v52.cumulative_stats, 
            instantaneous_stats    : v53, 
            last_swap              : v52.last_swap,
        };
        0x1::event::emit<State>(v56);
    }
    
    fun init_module(arg0: &signer) {
        let v0 = 0x1::object::create_named_object(arg0, b"Registry");
        let v1 = 0x1::object::generate_signer(&v0);
        let v2 = 0x1::object::address_from_constructor_ref(&v0);
        let v3 = RegistryAddress{registry_address: v2};
        move_to<RegistryAddress>(arg0, v3);
        let v4 = 0x1::timestamp::now_microseconds();
        let v5 = 86400000000;
        let v6 = ParallelizableSequenceInfo{
            nonce          : 0x1::aggregator_v2::create_unbounded_aggregator<u64>(), 
            last_bump_time : v4 / v5 * v5,
        };
        let v7 = GlobalStats{
            cumulative_quote_volume    : 0x1::aggregator_v2::create_unbounded_aggregator<u128>(), 
            total_quote_locked         : 0x1::aggregator_v2::create_unbounded_aggregator<u128>(), 
            total_value_locked         : 0x1::aggregator_v2::create_unbounded_aggregator<u128>(), 
            market_cap                 : 0x1::aggregator_v2::create_unbounded_aggregator<u128>(), 
            fully_diluted_value        : 0x1::aggregator_v2::create_unbounded_aggregator<u128>(), 
            cumulative_integrator_fees : 0x1::aggregator_v2::create_unbounded_aggregator<u128>(), 
            cumulative_swaps           : 0x1::aggregator_v2::create_unbounded_aggregator<u64>(), 
            cumulative_chat_messages   : 0x1::aggregator_v2::create_unbounded_aggregator<u64>(),
        };
        let v8 = Registry{
            registry_address         : v2, 
            sequence_info            : v6, 
            coin_symbol_emojis       : 0x1::table::new<vector<u8>, u8>(), 
            supplemental_chat_emojis : 0x1::table::new<vector<u8>, u8>(), 
            markets_by_emoji_bytes   : 0x1::smart_table::new<vector<u8>, address>(), 
            markets_by_market_id     : 0x1::smart_table::new<u64, address>(), 
            extend_ref               : 0x1::object::generate_extend_ref(&v0), 
            global_stats             : v7,
        };
        0x1::aggregator_v2::try_add<u64>(&mut v8.sequence_info.nonce, 1);
        let v9 = vector[x"f09fa587", x"f09fa588", x"f09fa589", x"f09f85b0efb88f", x"f09f868e", x"f09f8fa7", x"f09fa7ae", x"f09faa97", x"f09fa9b9", x"f09f8e9fefb88f", x"f09f9aa1", x"e29c88efb88f", x"f09f9bac", x"f09f9bab", x"e28fb0", x"e29a97efb88f", x"f09f91bd", x"f09f91be", x"f09f9a91", x"f09f8f88", x"f09f8fba", x"f09fab80", x"e29a93", x"f09f92a2", x"f09f98a0", x"f09f91bf", x"f09f98a7", x"f09f909c", x"f09f93b6", x"f09f98b0", x"e29992", x"e29988", x"f09f9a9b", x"f09f8ea8", x"f09f98b2", x"e29a9befb88f", x"f09f9bba", x"f09f9a97", x"f09fa591", x"f09faa93", x"f09f85b1efb88f", x"f09f9499", x"f09f91b6", x"f09f91bc", x"f09f91bcf09f8fbf", x"f09f91bcf09f8fbb", x"f09f91bcf09f8fbd", x"f09f91bcf09f8fbe", x"f09f91bcf09f8fbc", x"f09f8dbc", x"f09f90a4", x"f09f9abc", x"f09f91b6f09f8fbf", x"f09f91b6f09f8fbb", x"f09f91b6f09f8fbd", x"f09f91b6f09f8fbe", x"f09f91b6f09f8fbc", x"f09f9187", x"f09f9187f09f8fbf", x"f09f9187f09f8fbb", x"f09f9187f09f8fbd", x"f09f9187f09f8fbe", x"f09f9187f09f8fbc", x"f09f9188", x"f09f9188f09f8fbf", x"f09f9188f09f8fbb", x"f09f9188f09f8fbd", x"f09f9188f09f8fbe", x"f09f9188f09f8fbc", x"f09f9189", x"f09f9189f09f8fbf", x"f09f9189f09f8fbb", x"f09f9189f09f8fbd", x"f09f9189f09f8fbe", x"f09f9189f09f8fbc", x"f09f9186", x"f09f9186f09f8fbf", x"f09f9186f09f8fbb", x"f09f9186f09f8fbd", x"f09f9186f09f8fbe", x"f09f9186f09f8fbc", x"f09f8e92", x"f09fa593", x"f09fa6a1", x"f09f8fb8", x"f09fa5af", x"f09f9b84", x"f09fa596", x"e29a96efb88f", x"f09fa9b0", x"f09f8e88", x"f09f97b3efb88f", x"f09f8d8c", x"f09faa95", x"f09f8fa6", x"f09f938a", x"f09f9288", x"e29abe", x"f09fa7ba", x"f09f8f80", x"f09fa687", x"f09f9b81", x"f09f948b", x"f09f8f96efb88f", x"f09f9881", x"f09fab98", x"f09f90bb", x"f09f9293", x"f09fa6ab", x"f09f9b8fefb88f", x"f09f8dba", x"f09faab2", x"f09f9494", x"f09fab91", x"f09f9495", x"f09f9b8eefb88f", x"f09f8db1", x"f09fa783", x"f09f9ab2", x"f09f9199", x"f09fa7a2", x"e298a3efb88f", x"f09f90a6", x"f09f8e82", x"f09fa6ac", x"f09faba6", x"f09f90a6e2808de2ac9b", x"f09f9088e2808de2ac9b", x"e29aab", x"f09f8fb4", x"f09f96a4", x"e2ac9b", x"e297bcefb88f", x"e297be", x"e29c92efb88f", x"e296aaefb88f", x"f09f94b2", x"f09f8cbc", x"f09f90a1", x"f09f9398", x"f09f94b5", x"f09f9299", x"f09f9fa6", x"f09fab90", x"f09f9097", x"f09f92a3", x"f09fa6b4", x"f09f9496", x"f09f9391", x"f09f939a", x"f09faa83", x"f09f8dbe", x"f09f9290", x"f09f8fb9", x"f09fa5a3", x"f09f8eb3", x"f09fa58a", x"f09f91a6", x"f09f91a6f09f8fbf", x"f09f91a6f09f8fbb", x"f09f91a6f09f8fbd", x"f09f91a6f09f8fbe", x"f09f91a6f09f8fbc", x"f09fa7a0", x"f09f8d9e", x"f09fa4b1", x"f09fa4b1f09f8fbf", x"f09fa4b1f09f8fbb", x"f09fa4b1f09f8fbd", x"f09fa4b1f09f8fbe", x"f09fa4b1f09f8fbc", x"f09fa7b1", x"f09f8c89", x"f09f92bc", x"f09fa9b2", x"f09f9486", x"f09fa5a6", x"f09f9294", x"f09fa7b9", x"f09f9fa4", x"f09fa48e", x"f09f9fab", x"f09fa78b", x"f09faba7", x"f09faaa3", x"f09f909b", x"f09f8f97efb88f", x"f09f9a85", x"f09f8eaf", x"f09f8caf", x"f09f9a8c", x"f09f9a8f", x"f09f91a4", x"f09f91a5", x"f09fa788", x"f09fa68b", x"f09f8691", x"f09f8692", x"f09f8cb5", x"f09f9385", x"f09fa499", x"f09fa499f09f8fbf", x"f09fa499f09f8fbb", x"f09fa499f09f8fbd", x"f09fa499f09f8fbe", x"f09fa499f09f8fbc", x"f09f90aa", x"f09f93b7", x"f09f93b8", x"f09f8f95efb88f", x"e2998b", x"f09f95afefb88f", x"f09f8dac", x"f09fa5ab", x"f09f9bb6", x"e29991", x"f09f9783efb88f", x"f09f9387", x"f09f9782efb88f", x"f09f8ea0", x"f09f8e8f", x"f09faa9a", x"f09fa595", x"f09f8fb0", x"f09f9088", x"f09f90b1", x"f09f98b9", x"f09f98bc", x"e29b93efb88f", x"f09faa91", x"f09f9389", x"f09f9388", x"f09f92b9", x"e29891efb88f", x"e29c94efb88f", x"e29c85", x"f09fa780", x"f09f8f81", x"f09f8d92", x"f09f8cb8", x"e2999fefb88f", x"f09f8cb0", x"f09f9094", x"f09fa792", x"f09fa792f09f8fbf", x"f09fa792f09f8fbb", x"f09fa792f09f8fbd", x"f09fa792f09f8fbe", x"f09fa792f09f8fbc", x"f09f9ab8", x"f09f90bfefb88f", x"f09f8dab", x"f09fa5a2", x"f09f8e84", x"e29baa", x"f09f9aac", x"f09f8ea6", x"e29382efb88f", x"f09f8eaa", x"f09f8f99efb88f", x"f09f8c86", x"f09f979cefb88f", x"f09f8eac", x"f09f918f", x"f09f918ff09f8fbf", x"f09f918ff09f8fbb", x"f09f918ff09f8fbd", x"f09f918ff09f8fbe", x"f09f918ff09f8fbc", x"f09f8f9befb88f", x"f09f8dbb", x"f09fa582", x"f09f938b", x"f09f9483", x"f09f9395", x"f09f93aa", x"f09f93ab", x"f09f8c82", x"e29881efb88f", x"f09f8ca9efb88f", x"e29b88efb88f", x"f09f8ca7efb88f", x"f09f8ca8efb88f", x"f09fa4a1", x"e299a3efb88f", x"f09f919d", x"f09fa7a5", x"f09faab3", x"f09f8db8", x"f09fa5a5", x"e29ab0efb88f", x"f09faa99", x"f09fa5b6", x"f09f92a5", x"e29884efb88f", x"f09fa7ad", x"f09f92bd", x"f09f96b1efb88f", x"f09f8e8a", x"f09f9896", x"f09f9895", x"f09f9aa7", x"f09f91b7", x"f09f91b7f09f8fbf", x"f09f91b7f09f8fbb", x"f09f91b7f09f8fbd", x"f09f91b7f09f8fbe", x"f09f91b7f09f8fbc", x"f09f8e9befb88f", x"f09f8faa", x"f09f8d9a", x"f09f8daa", x"f09f8db3", x"c2a9efb88f", x"f09faab8", x"f09f9b8befb88f", x"f09f9484", x"f09f9291", x"f09f9291f09f8fbf", x"f09f9291f09f8fbb", x"f09f9291f09f8fbd", x"f09f9291f09f8fbe", x"f09f9291f09f8fbc", x"f09f9084", x"f09f90ae", x"f09fa4a0", x"f09fa680", x"f09f968defb88f", x"f09f92b3", x"f09f8c99", x"f09fa697", x"f09f8f8f", x"f09f908a", x"f09fa590", x"e29d8c", x"e29d8e", x"f09fa49e", x"f09fa49ef09f8fbf", x"f09fa49ef09f8fbb", x"f09fa49ef09f8fbd", x"f09fa49ef09f8fbe", x"f09fa49ef09f8fbc", x"f09f8e8c", x"e29a94efb88f", x"f09f9191", x"f09fa9bc", x"f09f98bf", x"f09f98a2", x"f09f94ae", x"f09fa592", x"f09fa5a4", x"f09fa781", x"f09fa58c", x"e29eb0", x"f09f92b1", x"f09f8d9b", x"f09f8dae", x"f09f9b83", x"f09fa5a9", x"f09f8c80", x"f09f97a1efb88f", x"f09f8da1", x"f09f92a8", x"f09fa78f", x"f09fa78ff09f8fbf", x"f09fa78ff09f8fbb", x"f09fa78ff09f8fbd", x"f09fa78ff09f8fbe", x"f09fa78ff09f8fbc", x"f09f8cb3", x"f09fa68c", x"f09f9a9a", x"f09f8fac", x"f09f8f9aefb88f", x"f09f8f9cefb88f", x"f09f8f9defb88f", x"f09f96a5efb88f", x"f09f95b5efb88f", x"f09f95b5f09f8fbf", x"f09f95b5f09f8fbb", x"f09f95b5f09f8fbd", x"f09f95b5f09f8fbe", x"f09f95b5f09f8fbc", x"e299a6efb88f", x"f09f92a0", x"f09f9485", x"f09f989e", x"f09fa5b8", x"e29e97", x"f09fa4bf", x"f09faa94", x"f09f92ab", x"f09fa7ac", x"f09fa6a4", x"f09f9095", x"f09f90b6", x"f09f92b5", x"f09f90ac", x"f09fab8f", x"f09f9aaa", x"f09faba5", x"f09f94af", x"e29ebf", x"e280bcefb88f", x"f09f8da9", x"f09f958aefb88f", x"e2ac87efb88f", x"e28699efb88f", x"e28698efb88f", x"f09f9893", x"f09f94bd", x"f09f9089", x"f09f90b2", x"f09f9197", x"f09fa4a4", x"f09fa9b8", x"f09f92a7", x"f09fa581", x"f09fa686", x"f09fa59f", x"f09f9380", x"f09f93a7", x"f09f949a", x"f09fa685", x"f09f9182", x"f09f8cbd", x"f09fa6bb", x"f09fa6bbf09f8fbf", x"f09fa6bbf09f8fbb", x"f09fa6bbf09f8fbd", x"f09fa6bbf09f8fbe", x"f09fa6bbf09f8fbc", x"f09f9182f09f8fbf", x"f09f9182f09f8fbb", x"f09f9182f09f8fbd", x"f09f9182f09f8fbe", x"f09f9182f09f8fbc", x"f09fa59a", x"f09f8d86", x"f09f9597", x"e29cb4efb88f", x"e29cb3efb88f", x"f09f95a3", x"e28f8fefb88f", x"f09f948c", x"f09f9098", x"f09f9b97", x"f09f959a", x"f09f95a6", x"f09fa79d", x"f09fa79df09f8fbf", x"f09fa79df09f8fbb", x"f09fa79df09f8fbd", x"f09fa79df09f8fbe", x"f09fa79df09f8fbc", x"f09faab9", x"f09f98a1", x"e29c89efb88f", x"f09f93a9", x"f09f92b6", x"f09f8cb2", x"f09f9091", x"e28189efb88f", x"f09fa4af", x"f09f9891", x"f09f9181efb88f", x"f09f9180", x"f09f8693", x"f09f9898", x"f09fa5b9", x"f09f988b", x"f09f98b1", x"f09fa4ae", x"f09f98b5", x"f09faba4", x"f09fa4ad", x"f09fa495", x"f09f98b7", x"f09fa790", x"f09faba2", x"f09f98ae", x"f09faba3", x"f09fa4a8", x"f09f9984", x"f09f98a4", x"f09fa4ac", x"f09f9882", x"f09fa492", x"f09f989b", x"f09f98b6", x"f09f8fad", x"f09fa79a", x"f09fa79af09f8fbf", x"f09fa79af09f8fbb", x"f09fa79af09f8fbd", x"f09fa79af09f8fbe", x"f09fa79af09f8fbc", x"f09fa786", x"f09f8d82", x"f09f91aa", x"e28fac", x"e28faa", x"e28fab", x"e28fa9", x"f09f93a0", x"f09f98a8", x"f09faab6", x"e29980efb88f", x"f09f8ea1", x"e29bb4efb88f", x"f09f8f91", x"f09f9784efb88f", x"f09f9381", x"f09f8e9eefb88f", x"f09f93bdefb88f", x"f09f94a5", x"f09f9a92", x"f09fa7af", x"f09fa7a8", x"f09f8e86", x"f09f8c93", x"f09f8c9b", x"f09f909f", x"f09f8da5", x"f09f8ea3", x"f09f9594", x"f09f95a0", x"e29bb3", x"f09f87a6f09f87ab", x"f09f87a6f09f87bd", x"f09f87a6f09f87b1", x"f09f87a9f09f87bf", x"f09f87a6f09f87b8", x"f09f87a6f09f87a9", x"f09f87a6f09f87b4", x"f09f87a6f09f87ae", x"f09f87a6f09f87b6", x"f09f87a6f09f87ac", x"f09f87a6f09f87b7", x"f09f87a6f09f87b2", x"f09f87a6f09f87bc", x"f09f87a6f09f87a8", x"f09f87a6f09f87ba", x"f09f87a6f09f87b9", x"f09f87a6f09f87bf", x"f09f87a7f09f87b8", x"f09f87a7f09f87ad", x"f09f87a7f09f87a9", x"f09f87a7f09f87a7", x"f09f87a7f09f87be", x"f09f87a7f09f87aa", x"f09f87a7f09f87bf", x"f09f87a7f09f87af", x"f09f87a7f09f87b2", x"f09f87a7f09f87b9", x"f09f87a7f09f87b4", x"f09f87a7f09f87a6", x"f09f87a7f09f87bc", x"f09f87a7f09f87bb", x"f09f87a7f09f87b7", x"f09f87aef09f87b4", x"f09f87bbf09f87ac", x"f09f87a7f09f87b3", x"f09f87a7f09f87ac", x"f09f87a7f09f87ab", x"f09f87a7f09f87ae", x"f09f87b0f09f87ad", x"f09f87a8f09f87b2", x"f09f87a8f09f87a6", x"f09f87aef09f87a8", x"f09f87a8f09f87bb", x"f09f87a7f09f87b6", x"f09f87b0f09f87be", x"f09f87a8f09f87ab", x"f09f87aaf09f87a6", x"f09f87b9f09f87a9", x"f09f87a8f09f87b1", x"f09f87a8f09f87b3", x"f09f87a8f09f87bd", x"f09f87a8f09f87b5", x"f09f87a8f09f87a8", x"f09f87a8f09f87b4", x"f09f87b0f09f87b2", x"f09f87a8f09f87ac", x"f09f87a8f09f87a9", x"f09f87a8f09f87b0", x"f09f87a8f09f87b7", x"f09f87a8f09f87ae", x"f09f87adf09f87b7", x"f09f87a8f09f87ba", x"f09f87a8f09f87bc", x"f09f87a8f09f87be", x"f09f87a8f09f87bf", x"f09f87a9f09f87b0", x"f09f87a9f09f87ac", x"f09f87a9f09f87af", x"f09f87a9f09f87b2", x"f09f87a9f09f87b4", x"f09f87aaf09f87a8", x"f09f87aaf09f87ac", x"f09f87b8f09f87bb", x"f09f87acf09f87b6", x"f09f87aaf09f87b7", x"f09f87aaf09f87aa", x"f09f87b8f09f87bf", x"f09f87aaf09f87b9", x"f09f87aaf09f87ba", x"f09f87abf09f87b0", x"f09f87abf09f87b4", x"f09f87abf09f87af", x"f09f87abf09f87ae", x"f09f87abf09f87b7", x"f09f87acf09f87ab", x"f09f87b5f09f87ab", x"f09f87b9f09f87ab", x"f09f87acf09f87a6", x"f09f87acf09f87b2", x"f09f87acf09f87aa", x"f09f87a9f09f87aa", x"f09f87acf09f87ad", x"f09f87acf09f87ae", x"f09f87acf09f87b7", x"f09f87acf09f87b1", x"f09f87acf09f87a9", x"f09f87acf09f87b5", x"f09f87acf09f87ba", x"f09f87acf09f87b9", x"f09f87acf09f87ac", x"f09f87acf09f87b3", x"f09f87acf09f87bc", x"f09f87acf09f87be", x"f09f87adf09f87b9", x"f09f87adf09f87b2", x"f09f87adf09f87b3", x"f09f87adf09f87b0", x"f09f87adf09f87ba", x"f09f87aef09f87b8", x"f09f87aef09f87b3", x"f09f87aef09f87a9", x"f09f87aef09f87b7", x"f09f87aef09f87b6", x"f09f87aef09f87aa", x"f09f87aef09f87b2", x"f09f87aef09f87b1", x"f09f87aef09f87b9", x"f09f87aff09f87b2", x"f09f87aff09f87b5", x"f09f87aff09f87aa", x"f09f87aff09f87b4", x"f09f87b0f09f87bf", x"f09f87b0f09f87aa", x"f09f87b0f09f87ae", x"f09f87bdf09f87b0", x"f09f87b0f09f87bc", x"f09f87b0f09f87ac", x"f09f87b1f09f87a6", x"f09f87b1f09f87bb", x"f09f87b1f09f87a7", x"f09f87b1f09f87b8", x"f09f87b1f09f87b7", x"f09f87b1f09f87be", x"f09f87b1f09f87ae", x"f09f87b1f09f87b9", x"f09f87b1f09f87ba", x"f09f87b2f09f87b4", x"f09f87b2f09f87ac", x"f09f87b2f09f87bc", x"f09f87b2f09f87be", x"f09f87b2f09f87bb", x"f09f87b2f09f87b1", x"f09f87b2f09f87b9", x"f09f87b2f09f87ad", x"f09f87b2f09f87b6", x"f09f87b2f09f87b7", x"f09f87b2f09f87ba", x"f09f87bef09f87b9", x"f09f87b2f09f87bd", x"f09f87abf09f87b2", x"f09f87b2f09f87a9", x"f09f87b2f09f87a8", x"f09f87b2f09f87b3", x"f09f87b2f09f87aa", x"f09f87b2f09f87b8", x"f09f87b2f09f87a6", x"f09f87b2f09f87bf", x"f09f87b2f09f87b2", x"f09f87b3f09f87a6", x"f09f87b3f09f87b7", x"f09f87b3f09f87b5", x"f09f87b3f09f87b1", x"f09f87b3f09f87a8", x"f09f87b3f09f87bf", x"f09f87b3f09f87ae", x"f09f87b3f09f87aa", x"f09f87b3f09f87ac", x"f09f87b3f09f87ba", x"f09f87b3f09f87ab", x"f09f87b0f09f87b5", x"f09f87b2f09f87b0", x"f09f87b2f09f87b5", x"f09f87b3f09f87b4", x"f09f87b4f09f87b2", x"f09f87b5f09f87b0", x"f09f87b5f09f87bc", x"f09f87b5f09f87b8", x"f09f87b5f09f87a6", x"f09f87b5f09f87ac", x"f09f87b5f09f87be", x"f09f87b5f09f87aa", x"f09f87b5f09f87ad", x"f09f87b5f09f87b3", x"f09f87b5f09f87b1", x"f09f87b5f09f87b9", x"f09f87b5f09f87b7", x"f09f87b6f09f87a6", x"f09f87b7f09f87aa", x"f09f87b7f09f87b4", x"f09f87b7f09f87ba", x"f09f87b7f09f87bc", x"f09f87bcf09f87b8", x"f09f87b8f09f87b2", x"f09f87b8f09f87b9", x"f09f87b8f09f87a6", x"f09f87b8f09f87b3", x"f09f87b7f09f87b8", x"f09f87b8f09f87a8", x"f09f87b8f09f87b1", x"f09f87b8f09f87ac", x"f09f87b8f09f87bd", x"f09f87b8f09f87b0", x"f09f87b8f09f87ae", x"f09f87b8f09f87a7", x"f09f87b8f09f87b4", x"f09f87bff09f87a6", x"f09f87acf09f87b8", x"f09f87b0f09f87b7", x"f09f87b8f09f87b8", x"f09f87aaf09f87b8", x"f09f87b1f09f87b0", x"f09f87a7f09f87b1", x"f09f87b8f09f87ad", x"f09f87b0f09f87b3", x"f09f87b1f09f87a8", x"f09f87b2f09f87ab", x"f09f87b5f09f87b2", x"f09f87bbf09f87a8", x"f09f87b8f09f87a9", x"f09f87b8f09f87b7", x"f09f87b8f09f87af", x"f09f87b8f09f87aa", x"f09f87a8f09f87ad", x"f09f87b8f09f87be", x"f09f87b9f09f87bc", x"f09f87b9f09f87af", x"f09f87b9f09f87bf", x"f09f87b9f09f87ad", x"f09f87b9f09f87b1", x"f09f87b9f09f87ac", x"f09f87b9f09f87b0", x"f09f87b9f09f87b4", x"f09f87b9f09f87b9", x"f09f87b9f09f87a6", x"f09f87b9f09f87b3", x"f09f87b9f09f87b7", x"f09f87b9f09f87b2", x"f09f87b9f09f87a8", x"f09f87b9f09f87bb", x"f09f87baf09f87b2", x"f09f87bbf09f87ae", x"f09f87baf09f87ac", x"f09f87baf09f87a6", x"f09f87a6f09f87aa", x"f09f87acf09f87a7", x"f09f87baf09f87b3", x"f09f87baf09f87b8", x"f09f87baf09f87be", x"f09f87baf09f87bf", x"f09f87bbf09f87ba", x"f09f87bbf09f87a6", x"f09f87bbf09f87aa", x"f09f87bbf09f87b3", x"f09f87bcf09f87ab", x"f09f87aaf09f87ad", x"f09f87bef09f87aa", x"f09f87bff09f87b2", x"f09f87bff09f87bc", x"f09fa6a9", x"f09f94a6", x"f09fa5bf", x"f09fab93", x"e29a9cefb88f", x"f09f92aa", x"f09f92aaf09f8fbf", x"f09f92aaf09f8fbb", x"f09f92aaf09f8fbd", x"f09f92aaf09f8fbe", x"f09f92aaf09f8fbc", x"f09f92be", x"f09f8eb4", x"f09f98b3", x"f09faa88", x"f09faab0", x"f09fa58f", x"f09f9bb8", x"f09f8cabefb88f", x"f09f8c81", x"f09f998f", x"f09f998ff09f8fbf", x"f09f998ff09f8fbb", x"f09f998ff09f8fbd", x"f09f998ff09f8fbe", x"f09f998ff09f8fbc", x"f09faaad", x"f09fab95", x"f09fa6b6", x"f09fa6b6f09f8fbf", x"f09fa6b6f09f8fbb", x"f09fa6b6f09f8fbd", x"f09fa6b6f09f8fbe", x"f09fa6b6f09f8fbc", x"f09f91a3", x"f09f8db4", x"f09f8dbdefb88f", x"f09fa5a0", x"e29bb2", x"f09f968befb88f", x"f09f8d80", x"f09f9593", x"f09f959f", x"f09fa68a", x"f09f96bcefb88f", x"f09f8d9f", x"f09f8da4", x"f09f90b8", x"f09f90a5", x"e298b9efb88f", x"f09f98a6", x"e29bbd", x"f09f8c95", x"f09f8c9d", x"e29ab1efb88f", x"f09f8eb2", x"f09fa784", x"e29a99efb88f", x"f09f928e", x"e2998a", x"f09fa79e", x"f09f91bb", x"f09fab9a", x"f09fa692", x"f09f91a7", x"f09f91a7f09f8fbf", x"f09f91a7f09f8fbb", x"f09f91a7f09f8fbd", x"f09f91a7f09f8fbe", x"f09f91a7f09f8fbc", x"f09fa59b", x"f09f9193", x"f09f8c8e", x"f09f8c8f", x"f09f8c8d", x"f09f8c90", x"f09fa7a4", x"f09f8c9f", x"f09fa585", x"f09f9090", x"f09f91ba", x"f09fa5bd", x"f09faabf", x"f09fa68d", x"f09f8e93", x"f09f8d87", x"f09f8d8f", x"f09f9397", x"f09f9fa2", x"f09f929a", x"f09fa597", x"f09f9fa9", x"f09fa9b6", x"f09f98ac", x"f09f98ba", x"f09f98b8", x"f09f9880", x"f09f9883", x"f09f9884", x"f09f9885", x"f09f9886", x"f09f9297", x"f09f9282", x"f09f9282f09f8fbf", x"f09f9282f09f8fbb", x"f09f9282f09f8fbd", x"f09f9282f09f8fbe", x"f09f9282f09f8fbc", x"f09fa6ae", x"f09f8eb8", x"f09faaae", x"f09f8d94", x"f09f94a8", x"e29a92efb88f", x"f09f9ba0efb88f", x"f09faaac", x"f09f90b9", x"f09f9690efb88f", x"f09f9690f09f8fbf", x"f09f9690f09f8fbb", x"f09f9690f09f8fbd", x"f09f9690f09f8fbe", x"f09f9690f09f8fbc", x"f09fabb0", x"f09fabb0f09f8fbf", x"f09fabb0f09f8fbb", x"f09fabb0f09f8fbd", x"f09fabb0f09f8fbe", x"f09fabb0f09f8fbc", x"f09f919c", x"f09fa49d", x"f09fa49df09f8fbf", x"f09fa49df09f8fbb", x"f09fa49df09f8fbd", x"f09fa49df09f8fbe", x"f09fa49df09f8fbc", x"f09f90a3", x"f09f8ea7", x"f09faaa6", x"f09f9989", x"f09f929f", x"e29da3efb88f", x"f09fabb6", x"f09fabb6f09f8fbf", x"f09fabb6f09f8fbb", x"f09fabb6f09f8fbd", x"f09fabb6f09f8fbe", x"f09fabb6f09f8fbc", x"e299a5efb88f", x"f09f9298", x"f09f929d", x"f09f92b2", x"f09f9fb0", x"f09fa694", x"f09f9a81", x"f09f8cbf", x"f09f8cba", x"e29aa1", x"f09f91a0", x"f09f9a84", x"f09fa5be", x"f09f9b95", x"f09fa69b", x"f09f95b3efb88f", x"e2ad95", x"f09f8daf", x"f09f909d", x"f09faa9d", x"f09f9aa5", x"f09f908e", x"f09f90b4", x"f09f8f87", x"f09f8f87f09f8fbf", x"f09f8f87f09f8fbb", x"f09f8f87f09f8fbd", x"f09f8f87f09f8fbe", x"f09f8f87f09f8fbc", x"f09f8fa5", x"e29895", x"f09f8cad", x"f09fa5b5", x"f09f8cb6efb88f", x"e299a8efb88f", x"f09f8fa8", x"e28c9b", x"e28fb3", x"f09f8fa0", x"f09f8fa1", x"f09f8f98efb88f", x"f09f92af", x"f09f98af", x"f09f9b96", x"f09faabb", x"f09f8694", x"f09fa78a", x"f09f8da8", x"f09f8f92", x"e29bb8efb88f", x"f09faaaa", x"f09f93a5", x"f09f93a8", x"f09fabb5", x"f09fabb5f09f8fbf", x"f09fabb5f09f8fbb", x"f09fabb5f09f8fbd", x"f09fabb5f09f8fbe", x"f09fabb5f09f8fbc", x"e2989defb88f", x"e2989df09f8fbf", x"e2989df09f8fbb", x"e2989df09f8fbd", x"e2989df09f8fbe", x"e2989df09f8fbc", x"e299beefb88f", x"e284b9efb88f", x"f09f94a4", x"f09f94a1", x"f09f94a0", x"f09f94a2", x"f09f94a3", x"f09f8e83", x"f09f8991", x"f09f88b8", x"f09f8990", x"e38a97efb88f", x"f09f88b9", x"f09f889a", x"f09f8881", x"f09f88b7efb88f", x"f09f88b5", x"f09f88b6", x"f09f88ba", x"f09f88b4", x"f09f88b2", x"f09f88af", x"e38a99efb88f", x"f09f8882efb88f", x"f09f88b3", x"f09f8faf", x"f09f8e8e", x"f09f8fa3", x"f09f94b0", x"f09fab99", x"f09f9196", x"f09faabc", x"f09f838f", x"f09f95b9efb88f", x"f09f958b", x"f09fa698", x"f09f9491", x"e28ca8efb88f", x"23efb88fe283a3", x"2aefb88fe283a3", x"30efb88fe283a3", x"31efb88fe283a3", x"f09f949f", x"32efb88fe283a3", x"33efb88fe283a3", x"34efb88fe283a3", x"35efb88fe283a3", x"36efb88fe283a3", x"37efb88fe283a3", x"38efb88fe283a3", x"39efb88fe283a3", x"f09faaaf", x"f09f9bb4", x"f09f9198", x"f09f928f", x"f09f928b", x"f09f928ff09f8fbf", x"f09f928ff09f8fbb", x"f09f928ff09f8fbd", x"f09f928ff09f8fbe", x"f09f928ff09f8fbc", x"f09f98bd", x"f09f9897", x"f09f989a", x"f09f9899", x"f09f94aa", x"f09faa81", x"f09fa59d", x"f09faaa2", x"f09f90a8", x"f09fa5bc", x"f09f8fb7efb88f", x"f09fa58d", x"f09faa9c", x"f09f909e", x"f09f92bb", x"f09f94b7", x"f09f94b6", x"f09f8c97", x"f09f8c9c", x"e28faeefb88f", x"e29c9defb88f", x"f09f8d83", x"f09fa5ac", x"f09f9392", x"e2ac85efb88f", x"e286aaefb88f", x"f09f9b85", x"f09f97a8efb88f", x"f09fa49b", x"f09fa49bf09f8fbf", x"f09fa49bf09f8fbb", x"f09fa49bf09f8fbd", x"f09fa49bf09f8fbe", x"f09fa49bf09f8fbc", x"e28694efb88f", x"f09fabb2", x"f09fabb2f09f8fbf", x"f09fabb2f09f8fbb", x"f09fabb2f09f8fbd", x"f09fabb2f09f8fbe", x"f09fabb2f09f8fbc", x"f09fabb7", x"f09fabb7f09f8fbf", x"f09fabb7f09f8fbb", x"f09fabb7f09f8fbd", x"f09fabb7f09f8fbe", x"f09fabb7f09f8fbc", x"f09fa6b5", x"f09fa6b5f09f8fbf", x"f09fa6b5f09f8fbb", x"f09fa6b5f09f8fbd", x"f09fa6b5f09f8fbe", x"f09fa6b5f09f8fbc", x"f09f8d8b", x"e2998c", x"f09f9086", x"f09f8e9aefb88f", x"e2998e", x"f09fa9b5", x"f09f92a1", x"f09f9a88", x"f09f9497", x"f09f9687efb88f", x"f09fa681", x"f09f9284", x"f09f9aae", x"f09fa68e", x"f09fa699", x"f09fa69e", x"f09f9492", x"f09f9490", x"f09f948f", x"f09f9a82", x"f09f8dad", x"f09faa98", x"f09fa7b4", x"f09faab7", x"f09f98ad", x"f09f93a2", x"f09f8fa9", x"f09f928c", x"f09fa49f", x"f09fa49ff09f8fbf", x"f09fa49ff09f8fbb", x"f09fa49ff09f8fbd", x"f09fa49ff09f8fbe", x"f09fa49ff09f8fbc", x"f09faaab", x"f09fa7b3", x"f09fab81", x"f09fa4a5", x"f09fa799", x"f09fa799f09f8fbf", x"f09fa799f09f8fbb", x"f09fa799f09f8fbd", x"f09fa799f09f8fbe", x"f09fa799f09f8fbc", x"f09faa84", x"f09fa7b2", x"f09f948d", x"f09f948e", x"f09f8084", x"e29982efb88f", x"f09fa6a3", x"f09f91a8", x"f09f95ba", x"f09f95baf09f8fbf", x"f09f95baf09f8fbb", x"f09f95baf09f8fbd", x"f09f95baf09f8fbe", x"f09f95baf09f8fbc", x"f09f919e", x"f09f91a8f09f8fbf", x"f09f91a8f09f8fbb", x"f09f91a8f09f8fbd", x"f09f91a8f09f8fbe", x"f09f91a8f09f8fbc", x"f09fa5ad", x"f09f95b0efb88f", x"f09fa6bd", x"f09f97be", x"f09f8d81", x"f09faa87", x"f09fa58b", x"f09fa789", x"f09f8d96", x"f09fa6be", x"f09fa6bf", x"e29a95efb88f", x"f09f93a3", x"f09f8d88", x"f09faba0", x"f09f939d", x"f09f91ac", x"f09f91acf09f8fbf", x"f09f91acf09f8fbb", x"f09f91acf09f8fbd", x"f09f91acf09f8fbe", x"f09f91acf09f8fbc", x"f09f9ab9", x"f09f958e", x"f09fa79c", x"f09fa79cf09f8fbf", x"f09fa79cf09f8fbb", x"f09fa79cf09f8fbd", x"f09fa79cf09f8fbe", x"f09fa79cf09f8fbc", x"f09f9a87", x"f09fa6a0", x"f09f8ea4", x"f09f94ac", x"f09f9695", x"f09f9695f09f8fbf", x"f09f9695f09f8fbb", x"f09f9695f09f8fbd", x"f09f9695f09f8fbe", x"f09f9695f09f8fbc", x"f09faa96", x"f09f8e96efb88f", x"f09f8c8c", x"f09f9a90", x"e29e96", x"f09faa9e", x"f09faaa9", x"f09f97bf", x"f09f93b1", x"f09f93b4", x"f09f93b2", x"f09f92b0", x"f09f92b8", x"f09fa491", x"f09f9092", x"f09f90b5", x"f09f9a9d", x"f09fa5ae", x"f09f8e91", x"f09fab8e", x"f09f958c", x"f09fa69f", x"f09f9ba5efb88f", x"f09f9bb5", x"f09f8f8defb88f", x"f09fa6bc", x"f09f9ba3efb88f", x"f09f97bb", x"e29bb0efb88f", x"f09f9aa0", x"f09f9a9e", x"f09f9081", x"f09f90ad", x"f09faaa4", x"f09f9184", x"f09f8ea5", x"f09fa4b6", x"f09fa4b6f09f8fbf", x"f09fa4b6f09f8fbb", x"f09fa4b6f09f8fbd", x"f09fa4b6f09f8fbe", x"f09fa4b6f09f8fbc", x"e29c96efb88f", x"f09f8d84", x"f09f8eb9", x"f09f8eb5", x"f09f8eb6", x"f09f8ebc", x"f09f9487", x"f09f8695", x"f09f8696", x"f09f9285", x"f09f9285f09f8fbf", x"f09f9285f09f8fbb", x"f09f9285f09f8fbd", x"f09f9285f09f8fbe", x"f09f9285f09f8fbc", x"f09f939b", x"f09f8f9eefb88f", x"f09fa4a2", x"f09fa7bf", x"f09f9194", x"f09fa493", x"f09faaba", x"f09faa86", x"f09f9890", x"f09f8c91", x"f09f8c9a", x"f09f93b0", x"e28fadefb88f", x"f09f8c83", x"f09f9598", x"f09f95a4", x"f09fa5b7", x"f09fa5b7f09f8fbf", x"f09fa5b7f09f8fbb", x"f09fa5b7f09f8fbd", x"f09fa5b7f09f8fbe", x"f09fa5b7f09f8fbc", x"f09f9ab3", x"e29b94", x"f09f9aaf", x"f09f93b5", x"f09f949e", x"f09f9ab7", x"f09f9aad", x"f09f9ab1", x"f09f9183", x"f09f9183f09f8fbf", x"f09f9183f09f8fbb", x"f09f9183f09f8fbd", x"f09f9183f09f8fbe", x"f09f9183f09f8fbc", x"f09f9393", x"f09f9394", x"f09f94a9", x"f09f85beefb88f", x"f09f8697", x"f09f918c", x"f09f918cf09f8fbf", x"f09f918cf09f8fbb", x"f09f918cf09f8fbd", x"f09f918cf09f8fbe", x"f09f918cf09f8fbc", x"f09f949b", x"f09f9099", x"f09f8da2", x"f09f8fa2", x"f09f91b9", x"f09f9ba2efb88f", x"f09f979defb88f", x"f09f91b4", x"f09f91b4f09f8fbf", x"f09f91b4f09f8fbb", x"f09f91b4f09f8fbd", x"f09f91b4f09f8fbe", x"f09f91b4f09f8fbc", x"f09f91b5", x"f09f91b5f09f8fbf", x"f09f91b5f09f8fbb", x"f09f91b5f09f8fbd", x"f09f91b5f09f8fbe", x"f09f91b5f09f8fbc", x"f09fa793", x"f09fa793f09f8fbf", x"f09fa793f09f8fbb", x"f09fa793f09f8fbd", x"f09fa793f09f8fbe", x"f09fa793f09f8fbc", x"f09fab92", x"f09f9589efb88f", x"f09f9a98", x"f09f9a8d", x"f09f918a", x"f09f918af09f8fbf", x"f09f918af09f8fbb", x"f09f918af09f8fbd", x"f09f918af09f8fbe", x"f09f918af09f8fbc", x"f09f9a94", x"f09f9a96", x"f09f9590", x"f09fa9b1", x"f09f959c", x"f09fa785", x"f09f9396", x"f09f9382", x"f09f9190", x"f09f9190f09f8fbf", x"f09f9190f09f8fbb", x"f09f9190f09f8fbd", x"f09f9190f09f8fbe", x"f09f9190f09f8fbc", x"f09f93ad", x"f09f93ac", x"e29b8e", x"f09f92bf", x"f09f9399", x"f09f9fa0", x"f09fa7a1", x"f09f9fa7", x"f09fa6a7", x"e298a6efb88f", x"f09fa6a6", x"f09f93a4", x"f09fa689", x"f09f9082", x"f09fa6aa", x"f09f85bfefb88f", x"f09f93a6", x"f09f9384", x"f09f9383", x"f09f939f", x"f09f968cefb88f", x"f09fabb3", x"f09fabb3f09f8fbf", x"f09fabb3f09f8fbb", x"f09fabb3f09f8fbd", x"f09fabb3f09f8fbe", x"f09fabb3f09f8fbc", x"f09f8cb4", x"f09fabb4", x"f09fabb4f09f8fbf", x"f09fabb4f09f8fbb", x"f09fabb4f09f8fbd", x"f09fabb4f09f8fbe", x"f09fabb4f09f8fbc", x"f09fa4b2", x"f09fa4b2f09f8fbf", x"f09fa4b2f09f8fbb", x"f09fa4b2f09f8fbd", x"f09fa4b2f09f8fbe", x"f09fa4b2f09f8fbc", x"f09fa59e", x"f09f90bc", x"f09f938e", x"f09faa82", x"f09fa69c", x"e380bdefb88f", x"f09f8e89", x"f09fa5b3", x"f09f9bb3efb88f", x"f09f9b82", x"e28fb8efb88f", x"f09f90be", x"f09fab9b", x"e298aeefb88f", x"f09f8d91", x"f09fa69a", x"f09fa59c", x"f09f8d90", x"f09f968aefb88f", x"e29c8fefb88f", x"f09f90a7", x"f09f9894", x"f09fab82", x"f09f91af", x"f09fa4bc", x"f09f8ead", x"f09f98a3", x"f09fa791", x"f09f9ab4", x"f09f9ab4f09f8fbf", x"f09f9ab4f09f8fbb", x"f09f9ab4f09f8fbd", x"f09f9ab4f09f8fbe", x"f09f9ab4f09f8fbc", x"e29bb9efb88f", x"e29bb9f09f8fbf", x"e29bb9f09f8fbb", x"e29bb9f09f8fbd", x"e29bb9f09f8fbe", x"e29bb9f09f8fbc", x"f09f9987", x"f09f9987f09f8fbf", x"f09f9987f09f8fbb", x"f09f9987f09f8fbd", x"f09f9987f09f8fbe", x"f09f9987f09f8fbc", x"f09fa4b8", x"f09fa4b8f09f8fbf", x"f09fa4b8f09f8fbb", x"f09fa4b8f09f8fbd", x"f09fa4b8f09f8fbe", x"f09fa4b8f09f8fbc", x"f09fa797", x"f09fa797f09f8fbf", x"f09fa797f09f8fbb", x"f09fa797f09f8fbd", x"f09fa797f09f8fbe", x"f09fa797f09f8fbc", x"f09fa4a6", x"f09fa4a6f09f8fbf", x"f09fa4a6f09f8fbb", x"f09fa4a6f09f8fbd", x"f09fa4a6f09f8fbe", x"f09fa4a6f09f8fbc", x"f09fa4ba", x"f09f998d", x"f09f998df09f8fbf", x"f09f998df09f8fbb", x"f09f998df09f8fbd", x"f09f998df09f8fbe", x"f09f998df09f8fbc", x"f09f9985", x"f09f9985f09f8fbf", x"f09f9985f09f8fbb", x"f09f9985f09f8fbd", x"f09f9985f09f8fbe", x"f09f9985f09f8fbc", x"f09f9986", x"f09f9986f09f8fbf", x"f09f9986f09f8fbb", x"f09f9986f09f8fbd", x"f09f9986f09f8fbe", x"f09f9986f09f8fbc", x"f09f9287", x"f09f9287f09f8fbf", x"f09f9287f09f8fbb", x"f09f9287f09f8fbd", x"f09f9287f09f8fbe", x"f09f9287f09f8fbc", x"f09f9286", x"f09f9286f09f8fbf", x"f09f9286f09f8fbb", x"f09f9286f09f8fbd", x"f09f9286f09f8fbe", x"f09f9286f09f8fbc", x"f09f8f8cefb88f", x"f09f8f8cf09f8fbf", x"f09f8f8cf09f8fbb", x"f09f8f8cf09f8fbd", x"f09f8f8cf09f8fbe", x"f09f8f8cf09f8fbc", x"f09f9b8c", x"f09f9b8cf09f8fbf", x"f09f9b8cf09f8fbb", x"f09f9b8cf09f8fbd", x"f09f9b8cf09f8fbe", x"f09f9b8cf09f8fbc", x"f09fa798", x"f09fa798f09f8fbf", x"f09fa798f09f8fbb", x"f09fa798f09f8fbd", x"f09fa798f09f8fbe", x"f09fa798f09f8fbc", x"f09fa796", x"f09fa796f09f8fbf", x"f09fa796f09f8fbb", x"f09fa796f09f8fbd", x"f09fa796f09f8fbe", x"f09fa796f09f8fbc", x"f09f95b4efb88f", x"f09f95b4f09f8fbf", x"f09f95b4f09f8fbb", x"f09f95b4f09f8fbd", x"f09f95b4f09f8fbe", x"f09f95b4f09f8fbc", x"f09fa4b5", x"f09fa4b5f09f8fbf", x"f09fa4b5f09f8fbb", x"f09fa4b5f09f8fbd", x"f09fa4b5f09f8fbe", x"f09fa4b5f09f8fbc", x"f09fa4b9", x"f09fa4b9f09f8fbf", x"f09fa4b9f09f8fbb", x"f09fa4b9f09f8fbd", x"f09fa4b9f09f8fbe", x"f09fa4b9f09f8fbc", x"f09fa78e", x"f09fa78ef09f8fbf", x"f09fa78ef09f8fbb", x"f09fa78ef09f8fbd", x"f09fa78ef09f8fbe", x"f09fa78ef09f8fbc", x"f09f8f8befb88f", x"f09f8f8bf09f8fbf", x"f09f8f8bf09f8fbb", x"f09f8f8bf09f8fbd", x"f09f8f8bf09f8fbe", x"f09f8f8bf09f8fbc", x"f09f9ab5", x"f09f9ab5f09f8fbf", x"f09f9ab5f09f8fbb", x"f09f9ab5f09f8fbd", x"f09f9ab5f09f8fbe", x"f09f9ab5f09f8fbc", x"f09fa4be", x"f09fa4bef09f8fbf", x"f09fa4bef09f8fbb", x"f09fa4bef09f8fbd", x"f09fa4bef09f8fbe", x"f09fa4bef09f8fbc", x"f09fa4bd", x"f09fa4bdf09f8fbf", x"f09fa4bdf09f8fbb", x"f09fa4bdf09f8fbd", x"f09fa4bdf09f8fbe", x"f09fa4bdf09f8fbc", x"f09f998e", x"f09f998ef09f8fbf", x"f09f998ef09f8fbb", x"f09f998ef09f8fbd", x"f09f998ef09f8fbe", x"f09f998ef09f8fbc", x"f09f998b", x"f09f998bf09f8fbf", x"f09f998bf09f8fbb", x"f09f998bf09f8fbd", x"f09f998bf09f8fbe", x"f09f998bf09f8fbc", x"f09f9aa3", x"f09f9aa3f09f8fbf", x"f09f9aa3f09f8fbb", x"f09f9aa3f09f8fbd", x"f09f9aa3f09f8fbe", x"f09f9aa3f09f8fbc", x"f09f8f83", x"f09f8f83f09f8fbf", x"f09f8f83f09f8fbb", x"f09f8f83f09f8fbd", x"f09f8f83f09f8fbe", x"f09f8f83f09f8fbc", x"f09fa4b7", x"f09fa4b7f09f8fbf", x"f09fa4b7f09f8fbb", x"f09fa4b7f09f8fbd", x"f09fa4b7f09f8fbe", x"f09fa4b7f09f8fbc", x"f09fa78d", x"f09fa78df09f8fbf", x"f09fa78df09f8fbb", x"f09fa78df09f8fbd", x"f09fa78df09f8fbe", x"f09fa78df09f8fbc", x"f09f8f84", x"f09f8f84f09f8fbf", x"f09f8f84f09f8fbb", x"f09f8f84f09f8fbd", x"f09f8f84f09f8fbe", x"f09f8f84f09f8fbc", x"f09f8f8a", x"f09f8f8af09f8fbf", x"f09f8f8af09f8fbb", x"f09f8f8af09f8fbd", x"f09f8f8af09f8fbe", x"f09f8f8af09f8fbc", x"f09f9b80", x"f09f9b80f09f8fbf", x"f09f9b80f09f8fbb", x"f09f9b80f09f8fbd", x"f09f9b80f09f8fbe", x"f09f9b80f09f8fbc", x"f09f9281", x"f09f9281f09f8fbf", x"f09f9281f09f8fbb", x"f09f9281f09f8fbd", x"f09f9281f09f8fbe", x"f09f9281f09f8fbc", x"f09f9ab6", x"f09f9ab6f09f8fbf", x"f09f9ab6f09f8fbb", x"f09f9ab6f09f8fbd", x"f09f9ab6f09f8fbe", x"f09f9ab6f09f8fbc", x"f09f91b3", x"f09f91b3f09f8fbf", x"f09f91b3f09f8fbb", x"f09f91b3f09f8fbd", x"f09f91b3f09f8fbe", x"f09f91b3f09f8fbc", x"f09fab85", x"f09fab85f09f8fbf", x"f09fab85f09f8fbb", x"f09fab85f09f8fbd", x"f09fab85f09f8fbe", x"f09fab85f09f8fbc", x"f09f91b2", x"f09f91b2f09f8fbf", x"f09f91b2f09f8fbb", x"f09f91b2f09f8fbd", x"f09f91b2f09f8fbe", x"f09f91b2f09f8fbc", x"f09f91b0", x"f09f91b0f09f8fbf", x"f09f91b0f09f8fbb", x"f09f91b0f09f8fbd", x"f09f91b0f09f8fbe", x"f09f91b0f09f8fbc", x"f09fa794", x"f09f91b1", x"f09fa791f09f8fbf", x"f09fa794f09f8fbf", x"f09f91b1f09f8fbf", x"f09fa791f09f8fbb", x"f09fa794f09f8fbb", x"f09f91b1f09f8fbb", x"f09fa791f09f8fbd", x"f09fa794f09f8fbd", x"f09f91b1f09f8fbd", x"f09fa791f09f8fbe", x"f09fa794f09f8fbe", x"f09f91b1f09f8fbe", x"f09fa791f09f8fbc", x"f09fa794f09f8fbc", x"f09f91b1f09f8fbc", x"f09fa7ab", x"e29b8fefb88f", x"f09f9bbb", x"f09fa5a7", x"f09f9096", x"f09f90b7", x"f09f90bd", x"f09f92a9", x"f09f928a", x"f09faa85", x"f09fa48c", x"f09fa48cf09f8fbf", x"f09fa48cf09f8fbb", x"f09fa48cf09f8fbd", x"f09fa48cf09f8fbe", x"f09fa48cf09f8fbc", x"f09fa48f", x"f09fa48ff09f8fbf", x"f09fa48ff09f8fbb", x"f09fa48ff09f8fbd", x"f09fa48ff09f8fbe", x"f09fa48ff09f8fbc", x"f09f8e8d", x"f09f8d8d", x"f09f8f93", x"f09fa9b7", x"e29993", x"f09f8d95", x"f09faaa7", x"f09f9b90", x"e296b6efb88f", x"e28fafefb88f", x"f09f9b9d", x"f09fa5ba", x"f09faaa0", x"e29e95", x"f09f9a93", x"f09f9aa8", x"f09f91ae", x"f09f91aef09f8fbf", x"f09f91aef09f8fbb", x"f09f91aef09f8fbd", x"f09f91aef09f8fbe", x"f09f91aef09f8fbc", x"f09f90a9", x"f09f8eb1", x"f09f8dbf", x"f09f8fa4", x"f09f93af", x"f09f93ae", x"f09f8db2", x"f09f9ab0", x"f09fa594", x"f09faab4", x"f09f8d97", x"f09f92b7", x"f09fab97", x"f09f98be", x"f09f93bf", x"f09fab83", x"f09fab83f09f8fbf", x"f09fab83f09f8fbb", x"f09fab83f09f8fbd", x"f09fab83f09f8fbe", x"f09fab83f09f8fbc", x"f09fab84", x"f09fab84f09f8fbf", x"f09fab84f09f8fbb", x"f09fab84f09f8fbd", x"f09fab84f09f8fbe", x"f09fab84f09f8fbc", x"f09fa4b0", x"f09fa4b0f09f8fbf", x"f09fa4b0f09f8fbb", x"f09fa4b0f09f8fbd", x"f09fa4b0f09f8fbe", x"f09fa4b0f09f8fbc", x"f09fa5a8", x"f09fa4b4", x"f09fa4b4f09f8fbf", x"f09fa4b4f09f8fbb", x"f09fa4b4f09f8fbd", x"f09fa4b4f09f8fbe", x"f09fa4b4f09f8fbc", x"f09f91b8", x"f09f91b8f09f8fbf", x"f09f91b8f09f8fbb", x"f09f91b8f09f8fbd", x"f09f91b8f09f8fbe", x"f09f91b8f09f8fbc", x"f09f96a8efb88f", x"f09f9aab", x"f09f9fa3", x"f09f929c", x"f09f9faa", x"f09f919b", x"f09f938c", x"f09fa7a9", x"f09f9087", x"f09f90b0", x"f09fa69d", x"f09f8f8eefb88f", x"f09f93bb", x"f09f9498", x"e298a2efb88f", x"f09f9a83", x"f09f9ba4efb88f", x"f09f8c88", x"f09fa49a", x"f09fa49af09f8fbf", x"f09fa49af09f8fbb", x"f09fa49af09f8fbd", x"f09fa49af09f8fbe", x"f09fa49af09f8fbc", x"e29c8a", x"e29c8af09f8fbf", x"e29c8af09f8fbb", x"e29c8af09f8fbd", x"e29c8af09f8fbe", x"e29c8af09f8fbc", x"e29c8b", x"e29c8bf09f8fbf", x"e29c8bf09f8fbb", x"e29c8bf09f8fbd", x"e29c8bf09f8fbe", x"e29c8bf09f8fbc", x"f09f998c", x"f09f998cf09f8fbf", x"f09f998cf09f8fbb", x"f09f998cf09f8fbd", x"f09f998cf09f8fbe", x"f09f998cf09f8fbc", x"f09f908f", x"f09f9080", x"f09faa92", x"f09fa7be", x"e28fbaefb88f", x"e299bbefb88f", x"f09f8d8e", x"f09f94b4", x"f09fa7a7", x"e29d97", x"e29da4efb88f", x"f09f8fae", x"e29d93", x"f09f9fa5", x"f09f94bb", x"f09f94ba", x"c2aeefb88f", x"f09f988c", x"f09f8e97efb88f", x"f09f9481", x"f09f9482", x"e29b91efb88f", x"f09f9abb", x"e29780efb88f", x"f09f929e", x"f09fa68f", x"f09f8e80", x"f09f8d99", x"f09f8d98", x"f09f97afefb88f", x"e29ea1efb88f", x"e2a4b5efb88f", x"e286a9efb88f", x"e2a4b4efb88f", x"f09fa49c", x"f09fa49cf09f8fbf", x"f09fa49cf09f8fbb", x"f09fa49cf09f8fbd", x"f09fa49cf09f8fbe", x"f09fa49cf09f8fbc", x"f09fabb1", x"f09fabb1f09f8fbf", x"f09fabb1f09f8fbb", x"f09fabb1f09f8fbd", x"f09fabb1f09f8fbe", x"f09fabb1f09f8fbc", x"f09fabb8", x"f09fabb8f09f8fbf", x"f09fabb8f09f8fbb", x"f09fabb8f09f8fbd", x"f09fabb8f09f8fbe", x"f09fabb8f09f8fbc", x"f09f928d", x"f09f9b9f", x"f09faa90", x"f09f8da0", x"f09fa496", x"f09faaa8", x"f09f9a80", x"f09fa7bb", x"f09f979eefb88f", x"f09f8ea2", x"f09f9bbc", x"f09fa4a3", x"f09f9093", x"f09f8cb9", x"f09f8fb5efb88f", x"f09f938d", x"f09f8f89", x"f09f8ebd", x"f09f919f", x"f09f949c", x"f09f8698", x"f09f98a5", x"f09fa7b7", x"f09fa6ba", x"e29990", x"e29bb5", x"f09f8db6", x"f09fa782", x"f09faba1", x"f09fa5aa", x"f09f8e85", x"f09f8e85f09f8fbf", x"f09f8e85f09f8fbb", x"f09f8e85f09f8fbd", x"f09f8e85f09f8fbe", x"f09f8e85f09f8fbc", x"f09fa5bb", x"f09f9bb0efb88f", x"f09f93a1", x"f09fa695", x"f09f8eb7", x"f09fa7a3", x"f09f8fab", x"e29c82efb88f", x"e2998f", x"f09fa682", x"f09faa9b", x"f09f939c", x"f09fa6ad", x"f09f92ba", x"f09f9988", x"f09f8cb1", x"f09fa4b3", x"f09fa4b3f09f8fbf", x"f09fa4b3f09f8fbb", x"f09fa4b3f09f8fbd", x"f09fa4b3f09f8fbe", x"f09fa4b3f09f8fbc", x"f09f9596", x"f09f95a2", x"f09faaa1", x"f09faba8", x"f09fa598", x"e29898efb88f", x"f09fa688", x"f09f8da7", x"f09f8cbe", x"f09f9ba1efb88f", x"e29ba9efb88f", x"f09f9aa2", x"f09f8ca0", x"f09f9b8defb88f", x"f09f9b92", x"f09f8db0", x"f09fa9b3", x"f09f9abf", x"f09fa690", x"f09f9480", x"f09fa4ab", x"f09fa498", x"f09fa498f09f8fbf", x"f09fa498f09f8fbb", x"f09fa498f09f8fbd", x"f09fa498f09f8fbe", x"f09fa498f09f8fbc", x"f09f9595", x"f09f95a1", x"f09f9bb9", x"e29bb7efb88f", x"f09f8ebf", x"f09f9280", x"e298a0efb88f", x"f09fa6a8", x"f09f9bb7", x"f09f98b4", x"f09f98aa", x"f09f9981", x"f09f9982", x"f09f8eb0", x"f09fa6a5", x"f09f9ba9efb88f", x"f09f94b9", x"f09f94b8", x"f09f98bb", x"e298baefb88f", x"f09f9887", x"f09f988d", x"f09fa5b0", x"f09f9888", x"f09fa497", x"f09f988a", x"f09f988e", x"f09fa5b2", x"f09f988f", x"f09f908c", x"f09f908d", x"f09fa4a7", x"f09f8f94efb88f", x"f09f8f82", x"f09f8f82f09f8fbf", x"f09f8f82f09f8fbb", x"f09f8f82f09f8fbd", x"f09f8f82f09f8fbe", x"f09f8f82f09f8fbc", x"e29d84efb88f", x"e29883efb88f", x"e29b84", x"f09fa7bc", x"e29abd", x"f09fa7a6", x"f09f8da6", x"f09fa58e", x"e299a0efb88f", x"f09f8d9d", x"e29d87efb88f", x"f09f8e87", x"e29ca8", x"f09f9296", x"f09f998a", x"f09f948a", x"f09f9488", x"f09f9489", x"f09f97a3efb88f", x"f09f92ac", x"f09f9aa4", x"f09f95b7efb88f", x"f09f95b8efb88f", x"f09f9793efb88f", x"f09f9792efb88f", x"f09f909a", x"f09fa7bd", x"f09fa584", x"f09f9a99", x"f09f8f85", x"f09f90b3", x"f09fa691", x"f09f989d", x"f09f8f9fefb88f", x"e2ad90", x"e298aaefb88f", x"e29ca1efb88f", x"f09fa4a9", x"f09f9a89", x"f09f97bd", x"f09f8d9c", x"f09fa9ba", x"e28fb9efb88f", x"f09f9b91", x"e28fb1efb88f", x"f09f938f", x"f09f8d93", x"f09f8e99efb88f", x"f09fa599", x"e29880efb88f", x"e29b85", x"f09f8ca5efb88f", x"f09f8ca6efb88f", x"f09f8ca4efb88f", x"f09f8c9e", x"f09f8cbb", x"f09f95b6efb88f", x"f09f8c85", x"f09f8c84", x"f09f8c87", x"f09fa6b8", x"f09fa6b8f09f8fbf", x"f09fa6b8f09f8fbb", x"f09fa6b8f09f8fbd", x"f09fa6b8f09f8fbe", x"f09fa6b8f09f8fbc", x"f09fa6b9", x"f09fa6b9f09f8fbf", x"f09fa6b9f09f8fbb", x"f09fa6b9f09f8fbd", x"f09fa6b9f09f8fbe", x"f09fa6b9f09f8fbc", x"f09f8da3", x"f09f9a9f", x"f09fa6a2", x"f09f92a6", x"f09f958d", x"f09f9289", x"f09fa696", x"f09f9195", x"f09f949d", x"f09f8cae", x"f09fa5a1", x"f09fab94", x"f09f8e8b", x"f09f8d8a", x"e29989", x"f09f9a95", x"f09f8db5", x"f09fab96", x"f09f9386", x"f09fa7b8", x"e2988eefb88f", x"f09f939e", x"f09f94ad", x"f09f93ba", x"f09f9599", x"f09f95a5", x"f09f8ebe", x"e29bba", x"f09fa7aa", x"f09f8ca1efb88f", x"f09fa494", x"f09fa9b4", x"f09f92ad", x"f09fa7b5", x"f09f9592", x"f09f959e", x"f09f918e", x"f09f918ef09f8fbf", x"f09f918ef09f8fbb", x"f09f918ef09f8fbd", x"f09f918ef09f8fbe", x"f09f918ef09f8fbc", x"f09f918d", x"f09f918df09f8fbf", x"f09f918df09f8fbb", x"f09f918df09f8fbd", x"f09f918df09f8fbe", x"f09f918df09f8fbc", x"f09f8eab", x"f09f9085", x"f09f90af", x"e28fb2efb88f", x"f09f98ab", x"f09f9abd", x"f09f97bc", x"f09f8d85", x"f09f9185", x"f09fa7b0", x"f09fa6b7", x"f09faaa5", x"f09f8ea9", x"f09f8caaefb88f", x"f09f96b2efb88f", x"f09f9a9c", x"e284a2efb88f", x"f09f9a86", x"f09f9a8a", x"f09f9a8b", x"e29aa7efb88f", x"f09f9aa9", x"f09f9390", x"f09f94b1", x"f09fa78c", x"f09f9a8e", x"f09f8f86", x"f09f8db9", x"f09f90a0", x"f09f8eba", x"f09f8cb7", x"f09fa583", x"f09fa683", x"f09f90a2", x"f09f959b", x"f09f95a7", x"f09f9295", x"f09f9591", x"f09f90ab", x"f09f959d", x"f09f8699", x"e29882efb88f", x"e29bb1efb88f", x"e29894", x"f09f9892", x"f09fa684", x"f09f9493", x"e2ac86efb88f", x"e28695efb88f", x"e28696efb88f", x"e28697efb88f", x"f09f9983", x"f09f94bc", x"f09f869a", x"f09fa79b", x"f09fa79bf09f8fbf", x"f09fa79bf09f8fbb", x"f09fa79bf09f8fbd", x"f09fa79bf09f8fbe", x"f09fa79bf09f8fbc", x"f09f9aa6", x"f09f93b3", x"e29c8cefb88f", x"e29c8cf09f8fbf", x"e29c8cf09f8fbb", x"e29c8cf09f8fbd", x"e29c8cf09f8fbe", x"e29c8cf09f8fbc", x"f09f93b9", x"f09f8eae", x"f09f93bc", x"f09f8ebb", x"e2998d", x"f09f8c8b", x"f09f8f90", x"f09f9696", x"f09f9696f09f8fbf", x"f09f9696f09f8fbb", x"f09f9696f09f8fbd", x"f09f9696f09f8fbe", x"f09f9696f09f8fbc", x"f09fa787", x"f09f8c98", x"f09f8c96", x"e29aa0efb88f", x"f09f9791efb88f", x"e28c9a", x"f09f9083", x"f09f9abe", x"f09f94ab", x"f09f8c8a", x"f09f8d89", x"f09f918b", x"f09f918bf09f8fbf", x"f09f918bf09f8fbb", x"f09f918bf09f8fbd", x"f09f918bf09f8fbe", x"f09f918bf09f8fbc", x"e380b0efb88f", x"f09f8c92", x"f09f8c94", x"f09f9980", x"f09f98a9", x"f09f9292", x"f09f908b", x"f09f9b9e", x"e298b8efb88f", x"e299bf", x"f09fa6af", x"e29aaa", x"e29d95", x"f09f8fb3efb88f", x"f09f92ae", x"f09fa48d", x"e2ac9c", x"e297bbefb88f", x"e297bd", x"e29d94", x"e296abefb88f", x"f09f94b3", x"f09fa580", x"f09f8e90", x"f09f8cacefb88f", x"f09faa9f", x"f09f8db7", x"f09faabd", x"f09f9889", x"f09f989c", x"f09f9b9c", x"f09f90ba", x"f09f91a9", x"f09f91ab", x"f09f91abf09f8fbf", x"f09f91abf09f8fbb", x"f09f91abf09f8fbd", x"f09f91abf09f8fbe", x"f09f91abf09f8fbc", x"f09f9283", x"f09f9283f09f8fbf", x"f09f9283f09f8fbb", x"f09f9283f09f8fbd", x"f09f9283f09f8fbe", x"f09f9283f09f8fbc", x"f09fa795", x"f09fa795f09f8fbf", x"f09fa795f09f8fbb", x"f09fa795f09f8fbd", x"f09fa795f09f8fbe", x"f09fa795f09f8fbc", x"f09f91a2", x"f09f919a", x"f09f9192", x"f09f91a1", x"f09f91a9f09f8fbf", x"f09f91a9f09f8fbb", x"f09f91a9f09f8fbd", x"f09f91a9f09f8fbe", x"f09f91a9f09f8fbc", x"f09f91ad", x"f09f91adf09f8fbf", x"f09f91adf09f8fbb", x"f09f91adf09f8fbd", x"f09f91adf09f8fbe", x"f09f91adf09f8fbc", x"f09f9aba", x"f09faab5", x"f09fa5b4", x"f09f97baefb88f", x"f09faab1", x"f09f989f", x"f09f8e81", x"f09f94a7", x"e29c8defb88f", x"e29c8df09f8fbf", x"e29c8df09f8fbb", x"e29c8df09f8fbd", x"e29c8df09f8fbe", x"e29c8df09f8fbc", x"f09fa9bb", x"f09fa7b6", x"f09fa5b1", x"f09f9fa1", x"f09f929b", x"f09f9fa8", x"f09f92b4", x"e298afefb88f", x"f09faa80", x"f09f92a4", x"f09fa4aa", x"f09fa693", x"f09fa490", x"f09fa79f"];
        let v10 = &v9;
        let v11 = 0;
        while (v11 < 0x1::vector::length<vector<u8>>(v10)) {
            0x1::table::add<vector<u8>, u8>(&mut v8.coin_symbol_emojis, *0x1::vector::borrow<vector<u8>>(v10, v11), 0);
            v11 = v11 + 1;
        };
        move_to<Registry>(&v1, v8);
        let v12 = GlobalState{
            emit_time                  : v4, 
            registry_nonce             : 0x1::aggregator_v2::create_snapshot<u64>(1), 
            trigger                    : 0, 
            cumulative_quote_volume    : 0x1::aggregator_v2::create_snapshot<u128>(0), 
            total_quote_locked         : 0x1::aggregator_v2::create_snapshot<u128>(0), 
            total_value_locked         : 0x1::aggregator_v2::create_snapshot<u128>(0), 
            market_cap                 : 0x1::aggregator_v2::create_snapshot<u128>(0), 
            fully_diluted_value        : 0x1::aggregator_v2::create_snapshot<u128>(0), 
            cumulative_integrator_fees : 0x1::aggregator_v2::create_snapshot<u128>(0), 
            cumulative_swaps           : 0x1::aggregator_v2::create_snapshot<u64>(0), 
            cumulative_chat_messages   : 0x1::aggregator_v2::create_snapshot<u64>(0),
        };
        0x1::event::emit<GlobalState>(v12);
    }
    
    public fun is_a_supplemental_chat_emoji(arg0: vector<u8>) : bool acquires Registry, RegistryAddress {
        0x1::table::contains<vector<u8>, u8>(&borrow_global<Registry>(borrow_global<RegistryAddress>(@0xface729284ae5729100b3a9ad7f7cc025ea09739cd6e7252aff0beb53619cafe).registry_address).supplemental_chat_emojis, arg0)
    }
    
    public fun is_a_supported_chat_emoji(arg0: vector<u8>) : bool acquires Registry, RegistryAddress {
        let v0 = borrow_global<Registry>(borrow_global<RegistryAddress>(@0xface729284ae5729100b3a9ad7f7cc025ea09739cd6e7252aff0beb53619cafe).registry_address);
        0x1::table::contains<vector<u8>, u8>(&v0.coin_symbol_emojis, arg0) || 0x1::table::contains<vector<u8>, u8>(&v0.supplemental_chat_emojis, arg0)
    }
    
    public fun is_a_supported_symbol_emoji(arg0: vector<u8>) : bool acquires Registry, RegistryAddress {
        0x1::table::contains<vector<u8>, u8>(&borrow_global<Registry>(borrow_global<RegistryAddress>(@0xface729284ae5729100b3a9ad7f7cc025ea09739cd6e7252aff0beb53619cafe).registry_address).coin_symbol_emojis, arg0)
    }
    
    public fun market_metadata_by_emoji_bytes(arg0: vector<u8>) : 0x1::option::Option<MarketMetadata> acquires Market, Registry, RegistryAddress {
        let v0 = &borrow_global<Registry>(borrow_global<RegistryAddress>(@0xface729284ae5729100b3a9ad7f7cc025ea09739cd6e7252aff0beb53619cafe).registry_address).markets_by_emoji_bytes;
        if (0x1::smart_table::contains<vector<u8>, address>(v0, arg0)) {
            0x1::option::some<MarketMetadata>(borrow_global<Market>(*0x1::smart_table::borrow<vector<u8>, address>(v0, arg0)).metadata)
        } else {
            0x1::option::none<MarketMetadata>()
        }
    }
    
    public fun market_metadata_by_market_address(arg0: address) : 0x1::option::Option<MarketMetadata> acquires Market {
        if (exists<Market>(arg0)) {
            0x1::option::some<MarketMetadata>(borrow_global<Market>(arg0).metadata)
        } else {
            0x1::option::none<MarketMetadata>()
        }
    }
    
    public fun market_metadata_by_market_id(arg0: u64) : 0x1::option::Option<MarketMetadata> acquires Market, Registry, RegistryAddress {
        let v0 = &borrow_global<Registry>(borrow_global<RegistryAddress>(@0xface729284ae5729100b3a9ad7f7cc025ea09739cd6e7252aff0beb53619cafe).registry_address).markets_by_market_id;
        if (0x1::smart_table::contains<u64, address>(v0, arg0)) {
            0x1::option::some<MarketMetadata>(borrow_global<Market>(*0x1::smart_table::borrow<u64, address>(v0, arg0)).metadata)
        } else {
            0x1::option::none<MarketMetadata>()
        }
    }
    
    public fun market_view<T0, T1>(arg0: address) : MarketView acquires Market {
        assert!(exists<Market>(arg0), 2);
        let v0 = borrow_global<Market>(arg0);
        let v1 = 0x1::object::generate_signer_for_extending(&v0.extend_ref);
        let v2 = &v1;
        if (!exists<LPCoinCapabilities<T0, T1>>(arg0)) {
            let v3 = 0x1::type_info::type_of<T0>();
            let v4 = &v3;
            let v5 = 0x1::type_info::type_of<T1>();
            let v6 = &v5;
            assert!(0x1::type_info::account_address(v4) == arg0 && 0x1::type_info::account_address(v6) == arg0 && 0x1::type_info::module_name(v4) == b"coin_factory" && 0x1::type_info::module_name(v6) == b"coin_factory" && 0x1::type_info::struct_name(v4) == b"Emojicoin" && 0x1::type_info::struct_name(v6) == b"EmojicoinLP", 6);
            let v7 = 0x1::string::utf8(v0.metadata.emoji_bytes);
            let v8 = v7;
            0x1::string::append(&mut v8, 0x1::string::utf8(b" emojicoin"));
            let (v9, v10, v11) = 0x1::coin::initialize<T0>(v2, v8, v7, 8, true);
            let v12 = v11;
            0x1::aptos_account::deposit_coins<T0>(arg0, 0x1::coin::mint<T0>(4500000000000000, &v12));
            0x1::coin::destroy_freeze_cap<T0>(v10);
            0x1::coin::destroy_mint_cap<T0>(v12);
            0x1::coin::destroy_burn_cap<T0>(v9);
            let v13 = 0x1::string::utf8(b"LP-");
            0x1::string::append(&mut v13, 0x1::string_utils::to_string<u64>(&v0.metadata.market_id));
            let v14 = v7;
            0x1::string::append(&mut v14, 0x1::string::utf8(b" emojicoin LP"));
            let (v15, v16, v17) = 0x1::coin::initialize<T1>(v2, v14, v13, 8, true);
            0x1::coin::register<T1>(v2);
            0x1::coin::destroy_freeze_cap<T1>(v16);
            let v18 = LPCoinCapabilities<T0, T1>{
                burn : v15, 
                mint : v17,
            };
            move_to<LPCoinCapabilities<T0, T1>>(v2, v18);
        };
        let v19 = v0.lp_coin_supply;
        let v20 = if (v0.lp_coin_supply == 0) {
            v0.clamm_virtual_reserves.quote - 40000000000
        } else {
            v0.cpamm_real_reserves.quote
        };
        let v21 = if (v33) {
            let v22 = v0.clamm_virtual_reserves;
            let v23 = v22.quote;
            let v24 = v23 - 40000000000;
            let v25 = if (v24 == 0) {
                0
            } else {
                let v26 = v22.base;
                (v24 as u128) + (v23 as u128) * ((v26 - 1400000000000000 + 1000000000000000) as u128) / (v26 as u128)
            };
            v25
        } else {
            2 * (v0.cpamm_real_reserves.quote as u128)
        };
        let (v27, v28) = if (v33) {
            (4900000000000000, &v0.clamm_virtual_reserves)
        } else {
            (4500000000000000, &v0.cpamm_real_reserves)
        };
        let v29 = *v28;
        let v30 = v29.base;
        let v31 = v29.quote;
        let v32 = InstantaneousStats{
            total_quote_locked  : v20, 
            total_value_locked  : v21, 
            market_cap          : (v31 as u128) * ((v27 - v30) as u128) / (v30 as u128), 
            fully_diluted_value : (v31 as u128) * (4500000000000000 as u128) / (v30 as u128),
        };
        MarketView{
            metadata                : v0.metadata, 
            sequence_info           : v0.sequence_info, 
            clamm_virtual_reserves  : v0.clamm_virtual_reserves, 
            cpamm_real_reserves     : v0.cpamm_real_reserves, 
            lp_coin_supply          : v19, 
            in_bonding_curve        : v19 == 0, 
            cumulative_stats        : v0.cumulative_stats, 
            instantaneous_stats     : v32, 
            last_swap               : v0.last_swap, 
            periodic_state_trackers : v0.periodic_state_trackers, 
            aptos_coin_balance      : 0x1::coin::balance<0x1::aptos_coin::AptosCoin>(arg0), 
            emojicoin_balance       : 0x1::coin::balance<T0>(arg0), 
            emojicoin_lp_balance    : 0x1::coin::balance<T1>(arg0),
        }
    }
    
    public entry fun provide_liquidity<T0, T1>(arg0: &signer, arg1: address, arg2: u64, arg3: u64) acquires LPCoinCapabilities, Market, Registry, RegistryAddress {
        assert!(arg3 > 0, 20);
        assert!(exists<Market>(arg1), 2);
        let v0 = borrow_global_mut<Market>(arg1);
        assert!(exists<LPCoinCapabilities<T0, T1>>(arg1), 6);
        let v1 = 0x1::signer::address_of(arg0);
        let v2 = v0;
        assert!(v2.lp_coin_supply > 0, 3);
        assert!(arg2 > 0, 4);
        let v3 = v2.cpamm_real_reserves;
        let v4 = v3.quote as u128;
        let v5 = arg2 as u128;
        let v6 = (v3.base as u128) * v5;
        let v7 = Liquidity{
            market_id                   : v2.metadata.market_id, 
            time                        : 0x1::timestamp::now_microseconds(), 
            market_nonce                : v2.sequence_info.nonce + 1, 
            provider                    : v1, 
            base_amount                 : (v6 / v4 + 1 - (v6 % v4 ^ 340282366920938463463374607431768211455) / 340282366920938463463374607431768211455) as u64, 
            quote_amount                : arg2, 
            lp_coin_amount              : (v5 * v2.lp_coin_supply / v4) as u64, 
            liquidity_provided          : true, 
            base_donation_claim_amount  : 0, 
            quote_donation_claim_amount : 0,
        };
        assert!(v7.lp_coin_amount >= arg3, 21);
        let v8 = borrow_global_mut<Registry>(borrow_global<RegistryAddress>(@0xface729284ae5729100b3a9ad7f7cc025ea09739cd6e7252aff0beb53619cafe).registry_address);
        let v9 = 2 * (v0.cpamm_real_reserves.quote as u128);
        let v10 = 4;
        trigger_periodic_state(v0, v8, v7.time, v10, v9);
        0x1::coin::transfer<T0>(arg0, arg1, v7.base_amount);
        0x1::coin::transfer<0x1::aptos_coin::AptosCoin>(arg0, arg1, v7.quote_amount);
        0x1::aptos_account::deposit_coins<T1>(v1, 0x1::coin::mint<T1>(v7.lp_coin_amount, &borrow_global<LPCoinCapabilities<T0, T1>>(v0.metadata.market_address).mint));
        let v11 = &mut v0.cpamm_real_reserves;
        let v12 = &mut v11.quote;
        v11.base = v11.base + v7.base_amount;
        *v12 = *v12 + v7.quote_amount;
        let v13 = v0.lp_coin_supply + (v7.lp_coin_amount as u128);
        v0.lp_coin_supply = v13;
        let v14 = 2 * (*v12 as u128);
        let v15 = &mut v8.global_stats;
        0x1::aggregator_v2::try_add<u128>(&mut v15.total_quote_locked, v7.quote_amount as u128);
        0x1::aggregator_v2::try_add<u128>(&mut v15.total_value_locked, v14 - v9);
        let v16 = 4500000000000000;
        let v17 = v0.cpamm_real_reserves;
        let v18 = v17.base;
        let v19 = v17.quote;
        let v20 = (v19 as u128) * (4500000000000000 as u128) / (v18 as u128);
        let v21 = (v19 as u128) * ((v16 - v18) as u128) / (v18 as u128);
        let v22 = *v11;
        let v23 = v22.base;
        let v24 = v22.quote;
        let v25 = (v24 as u128) * (4500000000000000 as u128) / (v23 as u128);
        let v26 = (v24 as u128) * ((v16 - v23) as u128) / (v23 as u128);
        if (v25 > v20) {
            0x1::aggregator_v2::try_add<u128>(&mut v15.fully_diluted_value, v25 - v20);
        } else {
            0x1::aggregator_v2::try_sub<u128>(&mut v15.fully_diluted_value, v20 - v25);
        };
        if (v26 > v21) {
            0x1::aggregator_v2::try_add<u128>(&mut v15.market_cap, v26 - v21);
        } else {
            0x1::aggregator_v2::try_sub<u128>(&mut v15.market_cap, v21 - v26);
        };
        0x1::event::emit<Liquidity>(v7);
        let v27 = &mut v0.periodic_state_trackers;
        let v28 = 0;
        while (v28 < 0x1::vector::length<PeriodicStateTracker>(v27)) {
            let v29 = 0x1::vector::borrow_mut<PeriodicStateTracker>(v27, v28);
            v29.tvl_to_lp_coin_ratio_end.tvl = v14;
            v29.tvl_to_lp_coin_ratio_end.lp_coins = v13;
            v29.ends_in_bonding_curve = false;
            v28 = v28 + 1;
        };
        let v30 = v0;
        let v31 = InstantaneousStats{
            total_quote_locked  : v11.quote, 
            total_value_locked  : v14, 
            market_cap          : v26, 
            fully_diluted_value : v25,
        };
        let v32 = &v30.sequence_info;
        let v33 = StateMetadata{
            market_nonce : v32.nonce, 
            bump_time    : v32.last_bump_time, 
            trigger      : v10,
        };
        let v34 = State{
            market_metadata        : v30.metadata, 
            state_metadata         : v33, 
            clamm_virtual_reserves : v30.clamm_virtual_reserves, 
            cpamm_real_reserves    : v30.cpamm_real_reserves, 
            lp_coin_supply         : v30.lp_coin_supply, 
            cumulative_stats       : v30.cumulative_stats, 
            instantaneous_stats    : v31, 
            last_swap              : v30.last_swap,
        };
        0x1::event::emit<State>(v34);
    }
    
    public entry fun register_market(arg0: &signer, arg1: vector<vector<u8>>, arg2: address) acquires Market, Registry, RegistryAddress {
        register_market_inner(arg0, arg1, arg2, true);
    }
    
    fun register_market_inner(arg0: &signer, arg1: vector<vector<u8>>, arg2: address, arg3: bool) acquires Market, Registry, RegistryAddress {
        let v0 = borrow_global_mut<Registry>(borrow_global<RegistryAddress>(@0xface729284ae5729100b3a9ad7f7cc025ea09739cd6e7252aff0beb53619cafe).registry_address);
        let v1 = arg1;
        let v2 = b"";
        let v3 = 0;
        let v4 = false;
        loop {
            if (v4) {
                v3 = v3 + 1;
            } else {
                v4 = true;
            };
            if (v3 < 0x1::vector::length<vector<u8>>(&v1)) {
                let v5 = *0x1::vector::borrow<vector<u8>>(&v1, v3);
                assert!(0x1::table::contains<vector<u8>, u8>(&v0.coin_symbol_emojis, v5), 7);
                0x1::vector::append<u8>(&mut v2, v5);
                continue
            };
            break
        };
        assert!(!0x1::vector::is_empty<u8>(&v2), 15);
        assert!(0x1::vector::length<u8>(&v2) <= (10 as u64), 8);
        let v6 = v2;
        assert!(!0x1::smart_table::contains<vector<u8>, address>(&v0.markets_by_emoji_bytes, v6), 9);
        let v7 = 0x1::object::generate_signer_for_extending(&v0.extend_ref);
        let v8 = &mut v0.markets_by_emoji_bytes;
        let v9 = 0x1::object::create_named_object(&v7, v6);
        let v10 = 0x1::object::address_from_constructor_ref(&v9);
        let v11 = 0x1::object::generate_signer(&v9);
        let v12 = 1 + 0x1::smart_table::length<vector<u8>, address>(v8);
        let v13 = if (v12 == 1) {
            0
        } else {
            100000000 as u128
        };
        let v14 = MarketMetadata{
            market_id      : v12, 
            market_address : v10, 
            emoji_bytes    : v6,
        };
        let v15 = SequenceInfo{
            nonce          : 0, 
            last_bump_time : 0x1::timestamp::now_microseconds(),
        };
        let v16 = CumulativeStats{
            base_volume     : 0, 
            quote_volume    : 0, 
            integrator_fees : v13, 
            pool_fees_base  : 0, 
            pool_fees_quote : 0, 
            n_swaps         : 0, 
            n_chat_messages : 0,
        };
        let v17 = 0x1::vector::empty<PeriodicStateTracker>();
        let v18 = 0x1::vector::empty<u64>();
        let v19 = &mut v18;
        0x1::vector::push_back<u64>(v19, 60000000);
        0x1::vector::push_back<u64>(v19, 300000000);
        0x1::vector::push_back<u64>(v19, 900000000);
        0x1::vector::push_back<u64>(v19, 1800000000);
        0x1::vector::push_back<u64>(v19, 3600000000);
        0x1::vector::push_back<u64>(v19, 14400000000);
        0x1::vector::push_back<u64>(v19, 86400000000);
        let v20 = v18;
        0x1::vector::reverse<u64>(&mut v20);
        let v21 = v20;
        let v22 = 0x1::vector::length<u64>(&v21);
        while (v22 > 0) {
            let v23 = 0x1::vector::pop_back<u64>(&mut v21);
            let v24 = TVLtoLPCoinRatio{
                tvl      : 0, 
                lp_coins : 0,
            };
            let v25 = TVLtoLPCoinRatio{
                tvl      : 0, 
                lp_coins : 0,
            };
            let v26 = PeriodicStateTracker{
                start_time                 : 0x1::timestamp::now_microseconds() / v23 * v23, 
                period                     : v23, 
                open_price_q64             : 0, 
                high_price_q64             : 0, 
                low_price_q64              : 0, 
                close_price_q64            : 0, 
                volume_base                : 0, 
                volume_quote               : 0, 
                integrator_fees            : v13, 
                pool_fees_base             : 0, 
                pool_fees_quote            : 0, 
                n_swaps                    : 0, 
                n_chat_messages            : 0, 
                starts_in_bonding_curve    : true, 
                ends_in_bonding_curve      : true, 
                tvl_to_lp_coin_ratio_start : v24, 
                tvl_to_lp_coin_ratio_end   : v25,
            };
            0x1::vector::push_back<PeriodicStateTracker>(&mut v17, v26);
            v22 = v22 - 1;
        };
        0x1::vector::destroy_empty<u64>(v21);
        let v27 = Reserves{
            base  : 4900000000000000, 
            quote : 40000000000,
        };
        let v28 = Reserves{
            base  : 0, 
            quote : 0,
        };
        let v29 = LastSwap{
            is_sell                 : false, 
            avg_execution_price_q64 : 0, 
            base_volume             : 0, 
            quote_volume            : 0, 
            nonce                   : 0, 
            time                    : 0,
        };
        let v30 = Market{
            metadata                : v14, 
            sequence_info           : v15, 
            extend_ref              : 0x1::object::generate_extend_ref(&v9), 
            clamm_virtual_reserves  : v27, 
            cpamm_real_reserves     : v28, 
            lp_coin_supply          : 0, 
            cumulative_stats        : v16, 
            last_swap               : v29, 
            periodic_state_trackers : v17,
        };
        move_to<Market>(&v11, v30);
        0x1::smart_table::add<vector<u8>, address>(v8, v6, v10);
        0x1::smart_table::add<u64, address>(&mut v0.markets_by_market_id, v12, v10);
        let v31 = v11;
        let v32 = borrow_global_mut<Market>(v10);
        let v33 = 0x1::timestamp::now_microseconds();
        trigger_periodic_state(v32, v0, v33, 1, 0);
        if (arg3) {
            let v34 = v10;
            let v35 = vector[x"a11ceb0b0600000005010002020208070a2f0839200a590a000000010000000200000c636f696e5f666163746f727909456d6f6a69636f696e0b456d6f6a69636f696e4c500b64756d6d795f6669656c64", x"0002010301010201030100"];
            let v36 = 0x1::vector::pop_back<vector<u8>>(&mut v35);
            0x1::vector::append<u8>(&mut v36, 0x1::bcs::to_bytes<address>(&v34));
            0x1::vector::append<u8>(&mut v36, 0x1::vector::pop_back<vector<u8>>(&mut v35));
            let v37 = 0x1::vector::empty<vector<u8>>();
            0x1::vector::push_back<vector<u8>>(&mut v37, v36);
            0x1::code::publish_package_txn(&v31, x"1a456d6f6a69636f696e446f7446756e436f696e466163746f72790200000000000000004044444231324644444631333830363943363442343332433944354131333034424531363033373839414538323637373330423244393939373942363744363733d2011f8b08000000000002ff3d8fc14ec3301044effe8acaf73ae58ac40101f9892a8a36f6365d1a7bad5d3b88bfc7a685dbcce88d76e70c2108aaa24ec633a5f902beb07c1f5e0e76b6c69c03eec7801953c0e409d5bde6c23a0a44fc62b94d66a5d2e16b29599f87a1d96b5d9ce73840278f1b2cfa909e055d03ac11dc7b2902a584cd6b5d02498fee64e41d87cbdf9147fddff7bf32f81bac3899d4c25efc88fc497dc23b97b1a6b7a6c6fb166b6a5e0502ce9937f2bfdb28c65a60d9d09a1d4589534f9fdcc99dacf9019ac891a815010000010c636f696e5f666163746f72790000000000", v37);
        };
        let v38 = 0x1::signer::address_of(arg0);
        let v39 = &mut v0.supplemental_chat_emojis;
        let v40 = vector[x"f09fa791e2808df09f8ea8", x"f09fa791f09f8fbfe2808df09f8ea8", x"f09fa791f09f8fbbe2808df09f8ea8", x"f09fa791f09f8fbde2808df09f8ea8", x"f09fa791f09f8fbee2808df09f8ea8", x"f09fa791f09f8fbce2808df09f8ea8", x"f09fa791e2808df09f9a80", x"f09fa791f09f8fbfe2808df09f9a80", x"f09fa791f09f8fbbe2808df09f9a80", x"f09fa791f09f8fbde2808df09f9a80", x"f09fa791f09f8fbee2808df09f9a80", x"f09fa791f09f8fbce2808df09f9a80", x"e29b93efb88fe2808df09f92a5", x"f09f8d84e2808df09f9fab", x"f09fa791e2808df09f8db3", x"f09fa791f09f8fbfe2808df09f8db3", x"f09fa791f09f8fbbe2808df09f8db3", x"f09fa791f09f8fbde2808df09f8db3", x"f09fa791f09f8fbee2808df09f8db3", x"f09fa791f09f8fbce2808df09f8db3", x"f09f91a8e2808de29da4efb88fe2808df09f91a8", x"f09f91a9e2808de29da4efb88fe2808df09f91a8", x"f09f91a9e2808de29da4efb88fe2808df09f91a9", x"f09fa78fe2808de29982efb88f", x"f09fa78ff09f8fbfe2808de29982efb88f", x"f09fa78ff09f8fbbe2808de29982efb88f", x"f09fa78ff09f8fbde2808de29982efb88f", x"f09fa78ff09f8fbee2808de29982efb88f", x"f09fa78ff09f8fbce2808de29982efb88f", x"f09fa78fe2808de29980efb88f", x"f09fa78ff09f8fbfe2808de29980efb88f", x"f09fa78ff09f8fbbe2808de29980efb88f", x"f09fa78ff09f8fbde2808de29980efb88f", x"f09fa78ff09f8fbee2808de29980efb88f", x"f09fa78ff09f8fbce2808de29980efb88f", x"f09f9181efb88fe2808df09f97a8efb88f", x"f09f98aee2808df09f92a8", x"f09f98b6e2808df09f8cabefb88f", x"f09f98b5e2808df09f92ab", x"f09fa791e2808df09f8fad", x"f09fa791f09f8fbfe2808df09f8fad", x"f09fa791f09f8fbbe2808df09f8fad", x"f09fa791f09f8fbde2808df09f8fad", x"f09fa791f09f8fbee2808df09f8fad", x"f09fa791f09f8fbce2808df09f8fad", x"f09fa791e2808df09fa791e2808df09fa792", x"f09fa791e2808df09fa791e2808df09fa792e2808df09fa792", x"f09fa791e2808df09fa792", x"f09fa791e2808df09fa792e2808df09fa792", x"f09f91a8e2808df09f91a6", x"f09f91a8e2808df09f91a6e2808df09f91a6", x"f09f91a8e2808df09f91a7", x"f09f91a8e2808df09f91a7e2808df09f91a6", x"f09f91a8e2808df09f91a7e2808df09f91a7", x"f09f91a8e2808df09f91a8e2808df09f91a6", x"f09f91a8e2808df09f91a8e2808df09f91a6e2808df09f91a6", x"f09f91a8e2808df09f91a8e2808df09f91a7", x"f09f91a8e2808df09f91a8e2808df09f91a7e2808df09f91a6", x"f09f91a8e2808df09f91a8e2808df09f91a7e2808df09f91a7", x"f09f91a8e2808df09f91a9e2808df09f91a6", x"f09f91a8e2808df09f91a9e2808df09f91a6e2808df09f91a6", x"f09f91a8e2808df09f91a9e2808df09f91a7", x"f09f91a8e2808df09f91a9e2808df09f91a7e2808df09f91a6", x"f09f91a8e2808df09f91a9e2808df09f91a7e2808df09f91a7", x"f09f91a9e2808df09f91a6", x"f09f91a9e2808df09f91a6e2808df09f91a6", x"f09f91a9e2808df09f91a7", x"f09f91a9e2808df09f91a7e2808df09f91a6", x"f09f91a9e2808df09f91a7e2808df09f91a7", x"f09f91a9e2808df09f91a9e2808df09f91a6", x"f09f91a9e2808df09f91a9e2808df09f91a6e2808df09f91a6", x"f09f91a9e2808df09f91a9e2808df09f91a7", x"f09f91a9e2808df09f91a9e2808df09f91a7e2808df09f91a6", x"f09f91a9e2808df09f91a9e2808df09f91a7e2808df09f91a7", x"f09fa791e2808df09f8cbe", x"f09fa791f09f8fbfe2808df09f8cbe", x"f09fa791f09f8fbbe2808df09f8cbe", x"f09fa791f09f8fbde2808df09f8cbe", x"f09fa791f09f8fbee2808df09f8cbe", x"f09fa791f09f8fbce2808df09f8cbe", x"f09fa791e2808df09f9a92", x"f09fa791f09f8fbfe2808df09f9a92", x"f09fa791f09f8fbbe2808df09f9a92", x"f09fa791f09f8fbde2808df09f9a92", x"f09fa791f09f8fbee2808df09f9a92", x"f09fa791f09f8fbce2808df09f9a92", x"f09f8fb4f3a081a7f3a081a2f3a081a5f3a081aef3a081a7f3a081bf", x"f09f8fb4f3a081a7f3a081a2f3a081b3f3a081a3f3a081b4f3a081bf", x"f09f8fb4f3a081a7f3a081a2f3a081b7f3a081acf3a081b3f3a081bf", x"f09fabb1f09f8fbfe2808df09fabb2f09f8fbb", x"f09fabb1f09f8fbfe2808df09fabb2f09f8fbd", x"f09fabb1f09f8fbfe2808df09fabb2f09f8fbe", x"f09fabb1f09f8fbfe2808df09fabb2f09f8fbc", x"f09fabb1f09f8fbbe2808df09fabb2f09f8fbf", x"f09fabb1f09f8fbbe2808df09fabb2f09f8fbd", x"f09fabb1f09f8fbbe2808df09fabb2f09f8fbe", x"f09fabb1f09f8fbbe2808df09fabb2f09f8fbc", x"f09fabb1f09f8fbde2808df09fabb2f09f8fbf", x"f09fabb1f09f8fbde2808df09fabb2f09f8fbb", x"f09fabb1f09f8fbde2808df09fabb2f09f8fbe", x"f09fabb1f09f8fbde2808df09fabb2f09f8fbc", x"f09fabb1f09f8fbee2808df09fabb2f09f8fbf", x"f09fabb1f09f8fbee2808df09fabb2f09f8fbb", x"f09fabb1f09f8fbee2808df09fabb2f09f8fbd", x"f09fabb1f09f8fbee2808df09fabb2f09f8fbc", x"f09fabb1f09f8fbce2808df09fabb2f09f8fbf", x"f09fabb1f09f8fbce2808df09fabb2f09f8fbb", x"f09fabb1f09f8fbce2808df09fabb2f09f8fbd", x"f09fabb1f09f8fbce2808df09fabb2f09f8fbe", x"f09f9982e2808de28694efb88f", x"f09f9982e2808de28695efb88f", x"f09fa791e2808de29a95efb88f", x"f09fa791f09f8fbfe2808de29a95efb88f", x"f09fa791f09f8fbbe2808de29a95efb88f", x"f09fa791f09f8fbde2808de29a95efb88f", x"f09fa791f09f8fbee2808de29a95efb88f", x"f09fa791f09f8fbce2808de29a95efb88f", x"e29da4efb88fe2808df09f94a5", x"f09fa791e2808de29a96efb88f", x"f09fa791f09f8fbfe2808de29a96efb88f", x"f09fa791f09f8fbbe2808de29a96efb88f", x"f09fa791f09f8fbde2808de29a96efb88f", x"f09fa791f09f8fbee2808de29a96efb88f", x"f09fa791f09f8fbce2808de29a96efb88f", x"f09f8d8be2808df09f9fa9", x"f09f91a8e2808df09f8ea8", x"f09f91a8f09f8fbfe2808df09f8ea8", x"f09f91a8f09f8fbbe2808df09f8ea8", x"f09f91a8f09f8fbde2808df09f8ea8", x"f09f91a8f09f8fbee2808df09f8ea8", x"f09f91a8f09f8fbce2808df09f8ea8", x"f09f91a8e2808df09f9a80", x"f09f91a8f09f8fbfe2808df09f9a80", x"f09f91a8f09f8fbbe2808df09f9a80", x"f09f91a8f09f8fbde2808df09f9a80", x"f09f91a8f09f8fbee2808df09f9a80", x"f09f91a8f09f8fbce2808df09f9a80", x"f09f9ab4e2808de29982efb88f", x"f09f9ab4f09f8fbfe2808de29982efb88f", x"f09f9ab4f09f8fbbe2808de29982efb88f", x"f09f9ab4f09f8fbde2808de29982efb88f", x"f09f9ab4f09f8fbee2808de29982efb88f", x"f09f9ab4f09f8fbce2808de29982efb88f", x"e29bb9efb88fe2808de29982efb88f", x"e29bb9f09f8fbfe2808de29982efb88f", x"e29bb9f09f8fbbe2808de29982efb88f", x"e29bb9f09f8fbde2808de29982efb88f", x"e29bb9f09f8fbee2808de29982efb88f", x"e29bb9f09f8fbce2808de29982efb88f", x"f09f9987e2808de29982efb88f", x"f09f9987f09f8fbfe2808de29982efb88f", x"f09f9987f09f8fbbe2808de29982efb88f", x"f09f9987f09f8fbde2808de29982efb88f", x"f09f9987f09f8fbee2808de29982efb88f", x"f09f9987f09f8fbce2808de29982efb88f", x"f09fa4b8e2808de29982efb88f", x"f09fa4b8f09f8fbfe2808de29982efb88f", x"f09fa4b8f09f8fbbe2808de29982efb88f", x"f09fa4b8f09f8fbde2808de29982efb88f", x"f09fa4b8f09f8fbee2808de29982efb88f", x"f09fa4b8f09f8fbce2808de29982efb88f", x"f09fa797e2808de29982efb88f", x"f09fa797f09f8fbfe2808de29982efb88f", x"f09fa797f09f8fbbe2808de29982efb88f", x"f09fa797f09f8fbde2808de29982efb88f", x"f09fa797f09f8fbee2808de29982efb88f", x"f09fa797f09f8fbce2808de29982efb88f", x"f09f91b7e2808de29982efb88f", x"f09f91b7f09f8fbfe2808de29982efb88f", x"f09f91b7f09f8fbbe2808de29982efb88f", x"f09f91b7f09f8fbde2808de29982efb88f", x"f09f91b7f09f8fbee2808de29982efb88f", x"f09f91b7f09f8fbce2808de29982efb88f", x"f09f91a8e2808df09f8db3", x"f09f91a8f09f8fbfe2808df09f8db3", x"f09f91a8f09f8fbbe2808df09f8db3", x"f09f91a8f09f8fbde2808df09f8db3", x"f09f91a8f09f8fbee2808df09f8db3", x"f09f91a8f09f8fbce2808df09f8db3", x"f09f95b5efb88fe2808de29982efb88f", x"f09f95b5f09f8fbfe2808de29982efb88f", x"f09f95b5f09f8fbbe2808de29982efb88f", x"f09f95b5f09f8fbde2808de29982efb88f", x"f09f95b5f09f8fbee2808de29982efb88f", x"f09f95b5f09f8fbce2808de29982efb88f", x"f09fa79de2808de29982efb88f", x"f09fa79df09f8fbfe2808de29982efb88f", x"f09fa79df09f8fbbe2808de29982efb88f", x"f09fa79df09f8fbde2808de29982efb88f", x"f09fa79df09f8fbee2808de29982efb88f", x"f09fa79df09f8fbce2808de29982efb88f", x"f09fa4a6e2808de29982efb88f", x"f09fa4a6f09f8fbfe2808de29982efb88f", x"f09fa4a6f09f8fbbe2808de29982efb88f", x"f09fa4a6f09f8fbde2808de29982efb88f", x"f09fa4a6f09f8fbee2808de29982efb88f", x"f09fa4a6f09f8fbce2808de29982efb88f", x"f09f91a8e2808df09f8fad", x"f09f91a8f09f8fbfe2808df09f8fad", x"f09f91a8f09f8fbbe2808df09f8fad", x"f09f91a8f09f8fbde2808df09f8fad", x"f09f91a8f09f8fbee2808df09f8fad", x"f09f91a8f09f8fbce2808df09f8fad", x"f09fa79ae2808de29982efb88f", x"f09fa79af09f8fbfe2808de29982efb88f", x"f09fa79af09f8fbbe2808de29982efb88f", x"f09fa79af09f8fbde2808de29982efb88f", x"f09fa79af09f8fbee2808de29982efb88f", x"f09fa79af09f8fbce2808de29982efb88f", x"f09f91a8e2808df09f8cbe", x"f09f91a8f09f8fbfe2808df09f8cbe", x"f09f91a8f09f8fbbe2808df09f8cbe", x"f09f91a8f09f8fbde2808df09f8cbe", x"f09f91a8f09f8fbee2808df09f8cbe", x"f09f91a8f09f8fbce2808df09f8cbe", x"f09f91a8e2808df09f8dbc", x"f09f91a8f09f8fbfe2808df09f8dbc", x"f09f91a8f09f8fbbe2808df09f8dbc", x"f09f91a8f09f8fbde2808df09f8dbc", x"f09f91a8f09f8fbee2808df09f8dbc", x"f09f91a8f09f8fbce2808df09f8dbc", x"f09f91a8e2808df09f9a92", x"f09f91a8f09f8fbfe2808df09f9a92", x"f09f91a8f09f8fbbe2808df09f9a92", x"f09f91a8f09f8fbde2808df09f9a92", x"f09f91a8f09f8fbee2808df09f9a92", x"f09f91a8f09f8fbce2808df09f9a92", x"f09f998de2808de29982efb88f", x"f09f998df09f8fbfe2808de29982efb88f", x"f09f998df09f8fbbe2808de29982efb88f", x"f09f998df09f8fbde2808de29982efb88f", x"f09f998df09f8fbee2808de29982efb88f", x"f09f998df09f8fbce2808de29982efb88f", x"f09fa79ee2808de29982efb88f", x"f09f9985e2808de29982efb88f", x"f09f9985f09f8fbfe2808de29982efb88f", x"f09f9985f09f8fbbe2808de29982efb88f", x"f09f9985f09f8fbde2808de29982efb88f", x"f09f9985f09f8fbee2808de29982efb88f", x"f09f9985f09f8fbce2808de29982efb88f", x"f09f9986e2808de29982efb88f", x"f09f9986f09f8fbfe2808de29982efb88f", x"f09f9986f09f8fbbe2808de29982efb88f", x"f09f9986f09f8fbde2808de29982efb88f", x"f09f9986f09f8fbee2808de29982efb88f", x"f09f9986f09f8fbce2808de29982efb88f", x"f09f9287e2808de29982efb88f", x"f09f9287f09f8fbfe2808de29982efb88f", x"f09f9287f09f8fbbe2808de29982efb88f", x"f09f9287f09f8fbde2808de29982efb88f", x"f09f9287f09f8fbee2808de29982efb88f", x"f09f9287f09f8fbce2808de29982efb88f", x"f09f9286e2808de29982efb88f", x"f09f9286f09f8fbfe2808de29982efb88f", x"f09f9286f09f8fbbe2808de29982efb88f", x"f09f9286f09f8fbde2808de29982efb88f", x"f09f9286f09f8fbee2808de29982efb88f", x"f09f9286f09f8fbce2808de29982efb88f", x"f09f8f8cefb88fe2808de29982efb88f", x"f09f8f8cf09f8fbfe2808de29982efb88f", x"f09f8f8cf09f8fbbe2808de29982efb88f", x"f09f8f8cf09f8fbde2808de29982efb88f", x"f09f8f8cf09f8fbee2808de29982efb88f", x"f09f8f8cf09f8fbce2808de29982efb88f", x"f09f9282e2808de29982efb88f", x"f09f9282f09f8fbfe2808de29982efb88f", x"f09f9282f09f8fbbe2808de29982efb88f", x"f09f9282f09f8fbde2808de29982efb88f", x"f09f9282f09f8fbee2808de29982efb88f", x"f09f9282f09f8fbce2808de29982efb88f", x"f09f91a8e2808de29a95efb88f", x"f09f91a8f09f8fbfe2808de29a95efb88f", x"f09f91a8f09f8fbbe2808de29a95efb88f", x"f09f91a8f09f8fbde2808de29a95efb88f", x"f09f91a8f09f8fbee2808de29a95efb88f", x"f09f91a8f09f8fbce2808de29a95efb88f", x"f09fa798e2808de29982efb88f", x"f09fa798f09f8fbfe2808de29982efb88f", x"f09fa798f09f8fbbe2808de29982efb88f", x"f09fa798f09f8fbde2808de29982efb88f", x"f09fa798f09f8fbee2808de29982efb88f", x"f09fa798f09f8fbce2808de29982efb88f", x"f09f91a8e2808df09fa6bd", x"f09f91a8e2808df09fa6bde2808de29ea1efb88f", x"f09f91a8f09f8fbfe2808df09fa6bde2808de29ea1efb88f", x"f09f91a8f09f8fbbe2808df09fa6bde2808de29ea1efb88f", x"f09f91a8f09f8fbde2808df09fa6bde2808de29ea1efb88f", x"f09f91a8f09f8fbee2808df09fa6bde2808de29ea1efb88f", x"f09f91a8f09f8fbce2808df09fa6bde2808de29ea1efb88f", x"f09f91a8f09f8fbfe2808df09fa6bd", x"f09f91a8f09f8fbbe2808df09fa6bd", x"f09f91a8f09f8fbde2808df09fa6bd", x"f09f91a8f09f8fbee2808df09fa6bd", x"f09f91a8f09f8fbce2808df09fa6bd", x"f09f91a8e2808df09fa6bc", x"f09f91a8e2808df09fa6bce2808de29ea1efb88f", x"f09f91a8f09f8fbfe2808df09fa6bce2808de29ea1efb88f", x"f09f91a8f09f8fbbe2808df09fa6bce2808de29ea1efb88f", x"f09f91a8f09f8fbde2808df09fa6bce2808de29ea1efb88f", x"f09f91a8f09f8fbee2808df09fa6bce2808de29ea1efb88f", x"f09f91a8f09f8fbce2808df09fa6bce2808de29ea1efb88f", x"f09f91a8f09f8fbfe2808df09fa6bc", x"f09f91a8f09f8fbbe2808df09fa6bc", x"f09f91a8f09f8fbde2808df09fa6bc", x"f09f91a8f09f8fbee2808df09fa6bc", x"f09f91a8f09f8fbce2808df09fa6bc", x"f09fa796e2808de29982efb88f", x"f09fa796f09f8fbfe2808de29982efb88f", x"f09fa796f09f8fbbe2808de29982efb88f", x"f09fa796f09f8fbde2808de29982efb88f", x"f09fa796f09f8fbee2808de29982efb88f", x"f09fa796f09f8fbce2808de29982efb88f", x"f09fa4b5e2808de29982efb88f", x"f09fa4b5f09f8fbfe2808de29982efb88f", x"f09fa4b5f09f8fbbe2808de29982efb88f", x"f09fa4b5f09f8fbde2808de29982efb88f", x"f09fa4b5f09f8fbee2808de29982efb88f", x"f09fa4b5f09f8fbce2808de29982efb88f", x"f09f91a8e2808de29a96efb88f", x"f09f91a8f09f8fbfe2808de29a96efb88f", x"f09f91a8f09f8fbbe2808de29a96efb88f", x"f09f91a8f09f8fbde2808de29a96efb88f", x"f09f91a8f09f8fbee2808de29a96efb88f", x"f09f91a8f09f8fbce2808de29a96efb88f", x"f09fa4b9e2808de29982efb88f", x"f09fa4b9f09f8fbfe2808de29982efb88f", x"f09fa4b9f09f8fbbe2808de29982efb88f", x"f09fa4b9f09f8fbde2808de29982efb88f", x"f09fa4b9f09f8fbee2808de29982efb88f", x"f09fa4b9f09f8fbce2808de29982efb88f", x"f09fa78ee2808de29982efb88f", x"f09fa78ee2808de29982efb88fe2808de29ea1efb88f", x"f09fa78ef09f8fbfe2808de29982efb88fe2808de29ea1efb88f", x"f09fa78ef09f8fbbe2808de29982efb88fe2808de29ea1efb88f", x"f09fa78ef09f8fbde2808de29982efb88fe2808de29ea1efb88f", x"f09fa78ef09f8fbee2808de29982efb88fe2808de29ea1efb88f", x"f09fa78ef09f8fbce2808de29982efb88fe2808de29ea1efb88f", x"f09fa78ef09f8fbfe2808de29982efb88f", x"f09fa78ef09f8fbbe2808de29982efb88f", x"f09fa78ef09f8fbde2808de29982efb88f", x"f09fa78ef09f8fbee2808de29982efb88f", x"f09fa78ef09f8fbce2808de29982efb88f", x"f09f8f8befb88fe2808de29982efb88f", x"f09f8f8bf09f8fbfe2808de29982efb88f", x"f09f8f8bf09f8fbbe2808de29982efb88f", x"f09f8f8bf09f8fbde2808de29982efb88f", x"f09f8f8bf09f8fbee2808de29982efb88f", x"f09f8f8bf09f8fbce2808de29982efb88f", x"f09fa799e2808de29982efb88f", x"f09fa799f09f8fbfe2808de29982efb88f", x"f09fa799f09f8fbbe2808de29982efb88f", x"f09fa799f09f8fbde2808de29982efb88f", x"f09fa799f09f8fbee2808de29982efb88f", x"f09fa799f09f8fbce2808de29982efb88f", x"f09f91a8e2808df09f94a7", x"f09f91a8f09f8fbfe2808df09f94a7", x"f09f91a8f09f8fbbe2808df09f94a7", x"f09f91a8f09f8fbde2808df09f94a7", x"f09f91a8f09f8fbee2808df09f94a7", x"f09f91a8f09f8fbce2808df09f94a7", x"f09f9ab5e2808de29982efb88f", x"f09f9ab5f09f8fbfe2808de29982efb88f", x"f09f9ab5f09f8fbbe2808de29982efb88f", x"f09f9ab5f09f8fbde2808de29982efb88f", x"f09f9ab5f09f8fbee2808de29982efb88f", x"f09f9ab5f09f8fbce2808de29982efb88f", x"f09f91a8e2808df09f92bc", x"f09f91a8f09f8fbfe2808df09f92bc", x"f09f91a8f09f8fbbe2808df09f92bc", x"f09f91a8f09f8fbde2808df09f92bc", x"f09f91a8f09f8fbee2808df09f92bc", x"f09f91a8f09f8fbce2808df09f92bc", x"f09f91a8e2808de29c88efb88f", x"f09f91a8f09f8fbfe2808de29c88efb88f", x"f09f91a8f09f8fbbe2808de29c88efb88f", x"f09f91a8f09f8fbde2808de29c88efb88f", x"f09f91a8f09f8fbee2808de29c88efb88f", x"f09f91a8f09f8fbce2808de29c88efb88f", x"f09fa4bee2808de29982efb88f", x"f09fa4bef09f8fbfe2808de29982efb88f", x"f09fa4bef09f8fbbe2808de29982efb88f", x"f09fa4bef09f8fbde2808de29982efb88f", x"f09fa4bef09f8fbee2808de29982efb88f", x"f09fa4bef09f8fbce2808de29982efb88f", x"f09fa4bde2808de29982efb88f", x"f09fa4bdf09f8fbfe2808de29982efb88f", x"f09fa4bdf09f8fbbe2808de29982efb88f", x"f09fa4bdf09f8fbde2808de29982efb88f", x"f09fa4bdf09f8fbee2808de29982efb88f", x"f09fa4bdf09f8fbce2808de29982efb88f", x"f09f91aee2808de29982efb88f", x"f09f91aef09f8fbfe2808de29982efb88f", x"f09f91aef09f8fbbe2808de29982efb88f", x"f09f91aef09f8fbde2808de29982efb88f", x"f09f91aef09f8fbee2808de29982efb88f", x"f09f91aef09f8fbce2808de29982efb88f", x"f09f998ee2808de29982efb88f", x"f09f998ef09f8fbfe2808de29982efb88f", x"f09f998ef09f8fbbe2808de29982efb88f", x"f09f998ef09f8fbde2808de29982efb88f", x"f09f998ef09f8fbee2808de29982efb88f", x"f09f998ef09f8fbce2808de29982efb88f", x"f09f998be2808de29982efb88f", x"f09f998bf09f8fbfe2808de29982efb88f", x"f09f998bf09f8fbbe2808de29982efb88f", x"f09f998bf09f8fbde2808de29982efb88f", x"f09f998bf09f8fbee2808de29982efb88f", x"f09f998bf09f8fbce2808de29982efb88f", x"f09f9aa3e2808de29982efb88f", x"f09f9aa3f09f8fbfe2808de29982efb88f", x"f09f9aa3f09f8fbbe2808de29982efb88f", x"f09f9aa3f09f8fbde2808de29982efb88f", x"f09f9aa3f09f8fbee2808de29982efb88f", x"f09f9aa3f09f8fbce2808de29982efb88f", x"f09f8f83e2808de29982efb88f", x"f09f8f83e2808de29982efb88fe2808de29ea1efb88f", x"f09f8f83f09f8fbfe2808de29982efb88fe2808de29ea1efb88f", x"f09f8f83f09f8fbbe2808de29982efb88fe2808de29ea1efb88f", x"f09f8f83f09f8fbde2808de29982efb88fe2808de29ea1efb88f", x"f09f8f83f09f8fbee2808de29982efb88fe2808de29ea1efb88f", x"f09f8f83f09f8fbce2808de29982efb88fe2808de29ea1efb88f", x"f09f8f83f09f8fbfe2808de29982efb88f", x"f09f8f83f09f8fbbe2808de29982efb88f", x"f09f8f83f09f8fbde2808de29982efb88f", x"f09f8f83f09f8fbee2808de29982efb88f", x"f09f8f83f09f8fbce2808de29982efb88f", x"f09f91a8e2808df09f94ac", x"f09f91a8f09f8fbfe2808df09f94ac", x"f09f91a8f09f8fbbe2808df09f94ac", x"f09f91a8f09f8fbde2808df09f94ac", x"f09f91a8f09f8fbee2808df09f94ac", x"f09f91a8f09f8fbce2808df09f94ac", x"f09fa4b7e2808de29982efb88f", x"f09fa4b7f09f8fbfe2808de29982efb88f", x"f09fa4b7f09f8fbbe2808de29982efb88f", x"f09fa4b7f09f8fbde2808de29982efb88f", x"f09fa4b7f09f8fbee2808de29982efb88f", x"f09fa4b7f09f8fbce2808de29982efb88f", x"f09f91a8e2808df09f8ea4", x"f09f91a8f09f8fbfe2808df09f8ea4", x"f09f91a8f09f8fbbe2808df09f8ea4", x"f09f91a8f09f8fbde2808df09f8ea4", x"f09f91a8f09f8fbee2808df09f8ea4", x"f09f91a8f09f8fbce2808df09f8ea4", x"f09fa78de2808de29982efb88f", x"f09fa78df09f8fbfe2808de29982efb88f", x"f09fa78df09f8fbbe2808de29982efb88f", x"f09fa78df09f8fbde2808de29982efb88f", x"f09fa78df09f8fbee2808de29982efb88f", x"f09fa78df09f8fbce2808de29982efb88f", x"f09f91a8e2808df09f8e93", x"f09f91a8f09f8fbfe2808df09f8e93", x"f09f91a8f09f8fbbe2808df09f8e93", x"f09f91a8f09f8fbde2808df09f8e93", x"f09f91a8f09f8fbee2808df09f8e93", x"f09f91a8f09f8fbce2808df09f8e93", x"f09fa6b8e2808de29982efb88f", x"f09fa6b8f09f8fbfe2808de29982efb88f", x"f09fa6b8f09f8fbbe2808de29982efb88f", x"f09fa6b8f09f8fbde2808de29982efb88f", x"f09fa6b8f09f8fbee2808de29982efb88f", x"f09fa6b8f09f8fbce2808de29982efb88f", x"f09fa6b9e2808de29982efb88f", x"f09fa6b9f09f8fbfe2808de29982efb88f", x"f09fa6b9f09f8fbbe2808de29982efb88f", x"f09fa6b9f09f8fbde2808de29982efb88f", x"f09fa6b9f09f8fbee2808de29982efb88f", x"f09fa6b9f09f8fbce2808de29982efb88f", x"f09f8f84e2808de29982efb88f", x"f09f8f84f09f8fbfe2808de29982efb88f", x"f09f8f84f09f8fbbe2808de29982efb88f", x"f09f8f84f09f8fbde2808de29982efb88f", x"f09f8f84f09f8fbee2808de29982efb88f", x"f09f8f84f09f8fbce2808de29982efb88f", x"f09f8f8ae2808de29982efb88f", x"f09f8f8af09f8fbfe2808de29982efb88f", x"f09f8f8af09f8fbbe2808de29982efb88f", x"f09f8f8af09f8fbde2808de29982efb88f", x"f09f8f8af09f8fbee2808de29982efb88f", x"f09f8f8af09f8fbce2808de29982efb88f", x"f09f91a8e2808df09f8fab", x"f09f91a8f09f8fbfe2808df09f8fab", x"f09f91a8f09f8fbbe2808df09f8fab", x"f09f91a8f09f8fbde2808df09f8fab", x"f09f91a8f09f8fbee2808df09f8fab", x"f09f91a8f09f8fbce2808df09f8fab", x"f09f91a8e2808df09f92bb", x"f09f91a8f09f8fbfe2808df09f92bb", x"f09f91a8f09f8fbbe2808df09f92bb", x"f09f91a8f09f8fbde2808df09f92bb", x"f09f91a8f09f8fbee2808df09f92bb", x"f09f91a8f09f8fbce2808df09f92bb", x"f09f9281e2808de29982efb88f", x"f09f9281f09f8fbfe2808de29982efb88f", x"f09f9281f09f8fbbe2808de29982efb88f", x"f09f9281f09f8fbde2808de29982efb88f", x"f09f9281f09f8fbee2808de29982efb88f", x"f09f9281f09f8fbce2808de29982efb88f", x"f09fa79be2808de29982efb88f", x"f09fa79bf09f8fbfe2808de29982efb88f", x"f09fa79bf09f8fbbe2808de29982efb88f", x"f09fa79bf09f8fbde2808de29982efb88f", x"f09fa79bf09f8fbee2808de29982efb88f", x"f09fa79bf09f8fbce2808de29982efb88f", x"f09f9ab6e2808de29982efb88f", x"f09f9ab6e2808de29982efb88fe2808de29ea1efb88f", x"f09f9ab6f09f8fbfe2808de29982efb88fe2808de29ea1efb88f", x"f09f9ab6f09f8fbbe2808de29982efb88fe2808de29ea1efb88f", x"f09f9ab6f09f8fbde2808de29982efb88fe2808de29ea1efb88f", x"f09f9ab6f09f8fbee2808de29982efb88fe2808de29ea1efb88f", x"f09f9ab6f09f8fbce2808de29982efb88fe2808de29ea1efb88f", x"f09f9ab6f09f8fbfe2808de29982efb88f", x"f09f9ab6f09f8fbbe2808de29982efb88f", x"f09f9ab6f09f8fbde2808de29982efb88f", x"f09f9ab6f09f8fbee2808de29982efb88f", x"f09f9ab6f09f8fbce2808de29982efb88f", x"f09f91b3e2808de29982efb88f", x"f09f91b3f09f8fbfe2808de29982efb88f", x"f09f91b3f09f8fbbe2808de29982efb88f", x"f09f91b3f09f8fbde2808de29982efb88f", x"f09f91b3f09f8fbee2808de29982efb88f", x"f09f91b3f09f8fbce2808de29982efb88f", x"f09f91b0e2808de29982efb88f", x"f09f91b0f09f8fbfe2808de29982efb88f", x"f09f91b0f09f8fbbe2808de29982efb88f", x"f09f91b0f09f8fbde2808de29982efb88f", x"f09f91b0f09f8fbee2808de29982efb88f", x"f09f91b0f09f8fbce2808de29982efb88f", x"f09f91a8e2808df09fa6af", x"f09f91a8e2808df09fa6afe2808de29ea1efb88f", x"f09f91a8f09f8fbfe2808df09fa6afe2808de29ea1efb88f", x"f09f91a8f09f8fbbe2808df09fa6afe2808de29ea1efb88f", x"f09f91a8f09f8fbde2808df09fa6afe2808de29ea1efb88f", x"f09f91a8f09f8fbee2808df09fa6afe2808de29ea1efb88f", x"f09f91a8f09f8fbce2808df09fa6afe2808de29ea1efb88f", x"f09f91a8f09f8fbfe2808df09fa6af", x"f09f91a8f09f8fbbe2808df09fa6af", x"f09f91a8f09f8fbde2808df09fa6af", x"f09f91a8f09f8fbee2808df09fa6af", x"f09f91a8f09f8fbce2808df09fa6af", x"f09fa79fe2808de29982efb88f", x"f09f91a8e2808df09fa6b2", x"f09fa794e2808de29982efb88f", x"f09f91b1e2808de29982efb88f", x"f09f91a8e2808df09fa6b1", x"f09f91a8f09f8fbfe2808df09fa6b2", x"f09fa794f09f8fbfe2808de29982efb88f", x"f09f91b1f09f8fbfe2808de29982efb88f", x"f09f91a8f09f8fbfe2808df09fa6b1", x"f09f91a8f09f8fbfe2808df09fa6b0", x"f09f91a8f09f8fbfe2808df09fa6b3", x"f09f91a8f09f8fbbe2808df09fa6b2", x"f09fa794f09f8fbbe2808de29982efb88f", x"f09f91b1f09f8fbbe2808de29982efb88f", x"f09f91a8f09f8fbbe2808df09fa6b1", x"f09f91a8f09f8fbbe2808df09fa6b0", x"f09f91a8f09f8fbbe2808df09fa6b3", x"f09f91a8f09f8fbde2808df09fa6b2", x"f09fa794f09f8fbde2808de29982efb88f", x"f09f91b1f09f8fbde2808de29982efb88f", x"f09f91a8f09f8fbde2808df09fa6b1", x"f09f91a8f09f8fbde2808df09fa6b0", x"f09f91a8f09f8fbde2808df09fa6b3", x"f09f91a8f09f8fbee2808df09fa6b2", x"f09fa794f09f8fbee2808de29982efb88f", x"f09f91b1f09f8fbee2808de29982efb88f", x"f09f91a8f09f8fbee2808df09fa6b1", x"f09f91a8f09f8fbee2808df09fa6b0", x"f09f91a8f09f8fbee2808df09fa6b3", x"f09f91a8f09f8fbce2808df09fa6b2", x"f09fa794f09f8fbce2808de29982efb88f", x"f09f91b1f09f8fbce2808de29982efb88f", x"f09f91a8f09f8fbce2808df09fa6b1", x"f09f91a8f09f8fbce2808df09fa6b0", x"f09f91a8f09f8fbce2808df09fa6b3", x"f09f91a8e2808df09fa6b0", x"f09f91a8e2808df09fa6b3", x"f09fa791e2808df09f94a7", x"f09fa791f09f8fbfe2808df09f94a7", x"f09fa791f09f8fbbe2808df09f94a7", x"f09fa791f09f8fbde2808df09f94a7", x"f09fa791f09f8fbee2808df09f94a7", x"f09fa791f09f8fbce2808df09f94a7", x"f09f91afe2808de29982efb88f", x"f09fa4bce2808de29982efb88f", x"e29da4efb88fe2808df09fa9b9", x"f09fa79ce2808de29980efb88f", x"f09fa79cf09f8fbfe2808de29980efb88f", x"f09fa79cf09f8fbbe2808de29980efb88f", x"f09fa79cf09f8fbde2808de29980efb88f", x"f09fa79cf09f8fbee2808de29980efb88f", x"f09fa79cf09f8fbce2808de29980efb88f", x"f09fa79ce2808de29982efb88f", x"f09fa79cf09f8fbfe2808de29982efb88f", x"f09fa79cf09f8fbbe2808de29982efb88f", x"f09fa79cf09f8fbde2808de29982efb88f", x"f09fa79cf09f8fbee2808de29982efb88f", x"f09fa79cf09f8fbce2808de29982efb88f", x"f09fa791e2808df09f8e84", x"f09fa791f09f8fbfe2808df09f8e84", x"f09fa791f09f8fbbe2808df09f8e84", x"f09fa791f09f8fbde2808df09f8e84", x"f09fa791f09f8fbee2808df09f8e84", x"f09fa791f09f8fbce2808df09f8e84", x"f09fa791e2808df09f92bc", x"f09fa791f09f8fbfe2808df09f92bc", x"f09fa791f09f8fbbe2808df09f92bc", x"f09fa791f09f8fbde2808df09f92bc", x"f09fa791f09f8fbee2808df09f92bc", x"f09fa791f09f8fbce2808df09f92bc", x"f09fa791e2808df09fa49de2808df09fa791", x"f09fa791e2808df09f8dbc", x"f09fa791f09f8fbfe2808df09f8dbc", x"f09fa791f09f8fbbe2808df09f8dbc", x"f09fa791f09f8fbde2808df09f8dbc", x"f09fa791f09f8fbee2808df09f8dbc", x"f09fa791f09f8fbce2808df09f8dbc", x"f09fa791e2808df09fa6bd", x"f09fa791e2808df09fa6bde2808de29ea1efb88f", x"f09fa791f09f8fbfe2808df09fa6bde2808de29ea1efb88f", x"f09fa791f09f8fbbe2808df09fa6bde2808de29ea1efb88f", x"f09fa791f09f8fbde2808df09fa6bde2808de29ea1efb88f", x"f09fa791f09f8fbee2808df09fa6bde2808de29ea1efb88f", x"f09fa791f09f8fbce2808df09fa6bde2808de29ea1efb88f", x"f09fa791f09f8fbfe2808df09fa6bd", x"f09fa791f09f8fbbe2808df09fa6bd", x"f09fa791f09f8fbde2808df09fa6bd", x"f09fa791f09f8fbee2808df09fa6bd", x"f09fa791f09f8fbce2808df09fa6bd", x"f09fa791e2808df09fa6bc", x"f09fa791e2808df09fa6bce2808de29ea1efb88f", x"f09fa791f09f8fbfe2808df09fa6bce2808de29ea1efb88f", x"f09fa791f09f8fbbe2808df09fa6bce2808de29ea1efb88f", x"f09fa791f09f8fbde2808df09fa6bce2808de29ea1efb88f", x"f09fa791f09f8fbee2808df09fa6bce2808de29ea1efb88f", x"f09fa791f09f8fbce2808df09fa6bce2808de29ea1efb88f", x"f09fa791f09f8fbfe2808df09fa6bc", x"f09fa791f09f8fbbe2808df09fa6bc", x"f09fa791f09f8fbde2808df09fa6bc", x"f09fa791f09f8fbee2808df09fa6bc", x"f09fa791f09f8fbce2808df09fa6bc", x"f09fa78ee2808de29ea1efb88f", x"f09fa78ef09f8fbfe2808de29ea1efb88f", x"f09fa78ef09f8fbbe2808de29ea1efb88f", x"f09fa78ef09f8fbde2808de29ea1efb88f", x"f09fa78ef09f8fbee2808de29ea1efb88f", x"f09fa78ef09f8fbce2808de29ea1efb88f", x"f09f8f83e2808de29ea1efb88f", x"f09f8f83f09f8fbfe2808de29ea1efb88f", x"f09f8f83f09f8fbbe2808de29ea1efb88f", x"f09f8f83f09f8fbde2808de29ea1efb88f", x"f09f8f83f09f8fbee2808de29ea1efb88f", x"f09f8f83f09f8fbce2808de29ea1efb88f", x"f09f9ab6e2808de29ea1efb88f", x"f09f9ab6f09f8fbfe2808de29ea1efb88f", x"f09f9ab6f09f8fbbe2808de29ea1efb88f", x"f09f9ab6f09f8fbde2808de29ea1efb88f", x"f09f9ab6f09f8fbee2808de29ea1efb88f", x"f09f9ab6f09f8fbce2808de29ea1efb88f", x"f09fa791e2808df09fa6af", x"f09fa791e2808df09fa6afe2808de29ea1efb88f", x"f09fa791f09f8fbfe2808df09fa6afe2808de29ea1efb88f", x"f09fa791f09f8fbbe2808df09fa6afe2808de29ea1efb88f", x"f09fa791f09f8fbde2808df09fa6afe2808de29ea1efb88f", x"f09fa791f09f8fbee2808df09fa6afe2808de29ea1efb88f", x"f09fa791f09f8fbce2808df09fa6afe2808de29ea1efb88f", x"f09fa791f09f8fbfe2808df09fa6af", x"f09fa791f09f8fbbe2808df09fa6af", x"f09fa791f09f8fbde2808df09fa6af", x"f09fa791f09f8fbee2808df09fa6af", x"f09fa791f09f8fbce2808df09fa6af", x"f09fa791e2808df09fa6b2", x"f09fa791e2808df09fa6b1", x"f09fa791f09f8fbfe2808df09fa6b2", x"f09fa791f09f8fbfe2808df09fa6b1", x"f09fa791f09f8fbfe2808df09fa6b0", x"f09fa791f09f8fbfe2808df09fa6b3", x"f09fa791f09f8fbbe2808df09fa6b2", x"f09fa791f09f8fbbe2808df09fa6b1", x"f09fa791f09f8fbbe2808df09fa6b0", x"f09fa791f09f8fbbe2808df09fa6b3", x"f09fa791f09f8fbde2808df09fa6b2", x"f09fa791f09f8fbde2808df09fa6b1", x"f09fa791f09f8fbde2808df09fa6b0", x"f09fa791f09f8fbde2808df09fa6b3", x"f09fa791f09f8fbee2808df09fa6b2", x"f09fa791f09f8fbee2808df09fa6b1", x"f09fa791f09f8fbee2808df09fa6b0", x"f09fa791f09f8fbee2808df09fa6b3", x"f09fa791f09f8fbce2808df09fa6b2", x"f09fa791f09f8fbce2808df09fa6b1", x"f09fa791f09f8fbce2808df09fa6b0", x"f09fa791f09f8fbce2808df09fa6b3", x"f09fa791e2808df09fa6b0", x"f09fa791e2808df09fa6b3", x"f09f90a6e2808df09f94a5", x"f09fa791e2808de29c88efb88f", x"f09fa791f09f8fbfe2808de29c88efb88f", x"f09fa791f09f8fbbe2808de29c88efb88f", x"f09fa791f09f8fbde2808de29c88efb88f", x"f09fa791f09f8fbee2808de29c88efb88f", x"f09fa791f09f8fbce2808de29c88efb88f", x"f09f8fb4e2808de298a0efb88f", x"f09f90bbe2808de29d84efb88f", x"f09f8fb3efb88fe2808df09f8c88", x"f09fa791e2808df09f94ac", x"f09fa791f09f8fbfe2808df09f94ac", x"f09fa791f09f8fbbe2808df09f94ac", x"f09fa791f09f8fbde2808df09f94ac", x"f09fa791f09f8fbee2808df09f94ac", x"f09fa791f09f8fbce2808df09f94ac", x"f09f9095e2808df09fa6ba", x"f09fa791e2808df09f8ea4", x"f09fa791f09f8fbfe2808df09f8ea4", x"f09fa791f09f8fbbe2808df09f8ea4", x"f09fa791f09f8fbde2808df09f8ea4", x"f09fa791f09f8fbee2808df09f8ea4", x"f09fa791f09f8fbce2808df09f8ea4", x"f09fa791e2808df09f8e93", x"f09fa791f09f8fbfe2808df09f8e93", x"f09fa791f09f8fbbe2808df09f8e93", x"f09fa791f09f8fbde2808df09f8e93", x"f09fa791f09f8fbee2808df09f8e93", x"f09fa791f09f8fbce2808df09f8e93", x"f09fa791e2808df09f8fab", x"f09fa791f09f8fbfe2808df09f8fab", x"f09fa791f09f8fbbe2808df09f8fab", x"f09fa791f09f8fbde2808df09f8fab", x"f09fa791f09f8fbee2808df09f8fab", x"f09fa791f09f8fbce2808df09f8fab", x"f09fa791e2808df09f92bb", x"f09fa791f09f8fbfe2808df09f92bb", x"f09fa791f09f8fbbe2808df09f92bb", x"f09fa791f09f8fbde2808df09f92bb", x"f09fa791f09f8fbee2808df09f92bb", x"f09fa791f09f8fbce2808df09f92bb", x"f09f8fb3efb88fe2808de29aa7efb88f", x"f09f91a9f09f8fbfe2808df09fa49de2808df09f91a8f09f8fbb", x"f09f91a9f09f8fbfe2808df09fa49de2808df09f91a8f09f8fbd", x"f09f91a9f09f8fbfe2808df09fa49de2808df09f91a8f09f8fbe", x"f09f91a9f09f8fbfe2808df09fa49de2808df09f91a8f09f8fbc", x"f09f91a9f09f8fbbe2808df09fa49de2808df09f91a8f09f8fbf", x"f09f91a9f09f8fbbe2808df09fa49de2808df09f91a8f09f8fbd", x"f09f91a9f09f8fbbe2808df09fa49de2808df09f91a8f09f8fbe", x"f09f91a9f09f8fbbe2808df09fa49de2808df09f91a8f09f8fbc", x"f09f91a9f09f8fbde2808df09fa49de2808df09f91a8f09f8fbf", x"f09f91a9f09f8fbde2808df09fa49de2808df09f91a8f09f8fbb", x"f09f91a9f09f8fbde2808df09fa49de2808df09f91a8f09f8fbe", x"f09f91a9f09f8fbde2808df09fa49de2808df09f91a8f09f8fbc", x"f09f91a9f09f8fbee2808df09fa49de2808df09f91a8f09f8fbf", x"f09f91a9f09f8fbee2808df09fa49de2808df09f91a8f09f8fbb", x"f09f91a9f09f8fbee2808df09fa49de2808df09f91a8f09f8fbd", x"f09f91a9f09f8fbee2808df09fa49de2808df09f91a8f09f8fbc", x"f09f91a9f09f8fbce2808df09fa49de2808df09f91a8f09f8fbf", x"f09f91a9f09f8fbce2808df09fa49de2808df09f91a8f09f8fbb", x"f09f91a9f09f8fbce2808df09fa49de2808df09f91a8f09f8fbd", x"f09f91a9f09f8fbce2808df09fa49de2808df09f91a8f09f8fbe", x"f09f91a9e2808df09f8ea8", x"f09f91a9f09f8fbfe2808df09f8ea8", x"f09f91a9f09f8fbbe2808df09f8ea8", x"f09f91a9f09f8fbde2808df09f8ea8", x"f09f91a9f09f8fbee2808df09f8ea8", x"f09f91a9f09f8fbce2808df09f8ea8", x"f09f91a9e2808df09f9a80", x"f09f91a9f09f8fbfe2808df09f9a80", x"f09f91a9f09f8fbbe2808df09f9a80", x"f09f91a9f09f8fbde2808df09f9a80", x"f09f91a9f09f8fbee2808df09f9a80", x"f09f91a9f09f8fbce2808df09f9a80", x"f09f9ab4e2808de29980efb88f", x"f09f9ab4f09f8fbfe2808de29980efb88f", x"f09f9ab4f09f8fbbe2808de29980efb88f", x"f09f9ab4f09f8fbde2808de29980efb88f", x"f09f9ab4f09f8fbee2808de29980efb88f", x"f09f9ab4f09f8fbce2808de29980efb88f", x"e29bb9efb88fe2808de29980efb88f", x"e29bb9f09f8fbfe2808de29980efb88f", x"e29bb9f09f8fbbe2808de29980efb88f", x"e29bb9f09f8fbde2808de29980efb88f", x"e29bb9f09f8fbee2808de29980efb88f", x"e29bb9f09f8fbce2808de29980efb88f", x"f09f9987e2808de29980efb88f", x"f09f9987f09f8fbfe2808de29980efb88f", x"f09f9987f09f8fbbe2808de29980efb88f", x"f09f9987f09f8fbde2808de29980efb88f", x"f09f9987f09f8fbee2808de29980efb88f", x"f09f9987f09f8fbce2808de29980efb88f", x"f09fa4b8e2808de29980efb88f", x"f09fa4b8f09f8fbfe2808de29980efb88f", x"f09fa4b8f09f8fbbe2808de29980efb88f", x"f09fa4b8f09f8fbde2808de29980efb88f", x"f09fa4b8f09f8fbee2808de29980efb88f", x"f09fa4b8f09f8fbce2808de29980efb88f", x"f09fa797e2808de29980efb88f", x"f09fa797f09f8fbfe2808de29980efb88f", x"f09fa797f09f8fbbe2808de29980efb88f", x"f09fa797f09f8fbde2808de29980efb88f", x"f09fa797f09f8fbee2808de29980efb88f", x"f09fa797f09f8fbce2808de29980efb88f", x"f09f91b7e2808de29980efb88f", x"f09f91b7f09f8fbfe2808de29980efb88f", x"f09f91b7f09f8fbbe2808de29980efb88f", x"f09f91b7f09f8fbde2808de29980efb88f", x"f09f91b7f09f8fbee2808de29980efb88f", x"f09f91b7f09f8fbce2808de29980efb88f", x"f09f91a9e2808df09f8db3", x"f09f91a9f09f8fbfe2808df09f8db3", x"f09f91a9f09f8fbbe2808df09f8db3", x"f09f91a9f09f8fbde2808df09f8db3", x"f09f91a9f09f8fbee2808df09f8db3", x"f09f91a9f09f8fbce2808df09f8db3", x"f09f95b5efb88fe2808de29980efb88f", x"f09f95b5f09f8fbfe2808de29980efb88f", x"f09f95b5f09f8fbbe2808de29980efb88f", x"f09f95b5f09f8fbde2808de29980efb88f", x"f09f95b5f09f8fbee2808de29980efb88f", x"f09f95b5f09f8fbce2808de29980efb88f", x"f09fa79de2808de29980efb88f", x"f09fa79df09f8fbfe2808de29980efb88f", x"f09fa79df09f8fbbe2808de29980efb88f", x"f09fa79df09f8fbde2808de29980efb88f", x"f09fa79df09f8fbee2808de29980efb88f", x"f09fa79df09f8fbce2808de29980efb88f", x"f09fa4a6e2808de29980efb88f", x"f09fa4a6f09f8fbfe2808de29980efb88f", x"f09fa4a6f09f8fbbe2808de29980efb88f", x"f09fa4a6f09f8fbde2808de29980efb88f", x"f09fa4a6f09f8fbee2808de29980efb88f", x"f09fa4a6f09f8fbce2808de29980efb88f", x"f09f91a9e2808df09f8fad", x"f09f91a9f09f8fbfe2808df09f8fad", x"f09f91a9f09f8fbbe2808df09f8fad", x"f09f91a9f09f8fbde2808df09f8fad", x"f09f91a9f09f8fbee2808df09f8fad", x"f09f91a9f09f8fbce2808df09f8fad", x"f09fa79ae2808de29980efb88f", x"f09fa79af09f8fbfe2808de29980efb88f", x"f09fa79af09f8fbbe2808de29980efb88f", x"f09fa79af09f8fbde2808de29980efb88f", x"f09fa79af09f8fbee2808de29980efb88f", x"f09fa79af09f8fbce2808de29980efb88f", x"f09f91a9e2808df09f8cbe", x"f09f91a9f09f8fbfe2808df09f8cbe", x"f09f91a9f09f8fbbe2808df09f8cbe", x"f09f91a9f09f8fbde2808df09f8cbe", x"f09f91a9f09f8fbee2808df09f8cbe", x"f09f91a9f09f8fbce2808df09f8cbe", x"f09f91a9e2808df09f8dbc", x"f09f91a9f09f8fbfe2808df09f8dbc", x"f09f91a9f09f8fbbe2808df09f8dbc", x"f09f91a9f09f8fbde2808df09f8dbc", x"f09f91a9f09f8fbee2808df09f8dbc", x"f09f91a9f09f8fbce2808df09f8dbc", x"f09f91a9e2808df09f9a92", x"f09f91a9f09f8fbfe2808df09f9a92", x"f09f91a9f09f8fbbe2808df09f9a92", x"f09f91a9f09f8fbde2808df09f9a92", x"f09f91a9f09f8fbee2808df09f9a92", x"f09f91a9f09f8fbce2808df09f9a92", x"f09f998de2808de29980efb88f", x"f09f998df09f8fbfe2808de29980efb88f", x"f09f998df09f8fbbe2808de29980efb88f", x"f09f998df09f8fbde2808de29980efb88f", x"f09f998df09f8fbee2808de29980efb88f", x"f09f998df09f8fbce2808de29980efb88f", x"f09fa79ee2808de29980efb88f", x"f09f9985e2808de29980efb88f", x"f09f9985f09f8fbfe2808de29980efb88f", x"f09f9985f09f8fbbe2808de29980efb88f", x"f09f9985f09f8fbde2808de29980efb88f", x"f09f9985f09f8fbee2808de29980efb88f", x"f09f9985f09f8fbce2808de29980efb88f", x"f09f9986e2808de29980efb88f", x"f09f9986f09f8fbfe2808de29980efb88f", x"f09f9986f09f8fbbe2808de29980efb88f", x"f09f9986f09f8fbde2808de29980efb88f", x"f09f9986f09f8fbee2808de29980efb88f", x"f09f9986f09f8fbce2808de29980efb88f", x"f09f9287e2808de29980efb88f", x"f09f9287f09f8fbfe2808de29980efb88f", x"f09f9287f09f8fbbe2808de29980efb88f", x"f09f9287f09f8fbde2808de29980efb88f", x"f09f9287f09f8fbee2808de29980efb88f", x"f09f9287f09f8fbce2808de29980efb88f", x"f09f9286e2808de29980efb88f", x"f09f9286f09f8fbfe2808de29980efb88f", x"f09f9286f09f8fbbe2808de29980efb88f", x"f09f9286f09f8fbde2808de29980efb88f", x"f09f9286f09f8fbee2808de29980efb88f", x"f09f9286f09f8fbce2808de29980efb88f", x"f09f8f8cefb88fe2808de29980efb88f", x"f09f8f8cf09f8fbfe2808de29980efb88f", x"f09f8f8cf09f8fbbe2808de29980efb88f", x"f09f8f8cf09f8fbde2808de29980efb88f", x"f09f8f8cf09f8fbee2808de29980efb88f", x"f09f8f8cf09f8fbce2808de29980efb88f", x"f09f9282e2808de29980efb88f", x"f09f9282f09f8fbfe2808de29980efb88f", x"f09f9282f09f8fbbe2808de29980efb88f", x"f09f9282f09f8fbde2808de29980efb88f", x"f09f9282f09f8fbee2808de29980efb88f", x"f09f9282f09f8fbce2808de29980efb88f", x"f09f91a9e2808de29a95efb88f", x"f09f91a9f09f8fbfe2808de29a95efb88f", x"f09f91a9f09f8fbbe2808de29a95efb88f", x"f09f91a9f09f8fbde2808de29a95efb88f", x"f09f91a9f09f8fbee2808de29a95efb88f", x"f09f91a9f09f8fbce2808de29a95efb88f", x"f09fa798e2808de29980efb88f", x"f09fa798f09f8fbfe2808de29980efb88f", x"f09fa798f09f8fbbe2808de29980efb88f", x"f09fa798f09f8fbde2808de29980efb88f", x"f09fa798f09f8fbee2808de29980efb88f", x"f09fa798f09f8fbce2808de29980efb88f", x"f09f91a9e2808df09fa6bd", x"f09f91a9e2808df09fa6bde2808de29ea1efb88f", x"f09f91a9f09f8fbfe2808df09fa6bde2808de29ea1efb88f", x"f09f91a9f09f8fbbe2808df09fa6bde2808de29ea1efb88f", x"f09f91a9f09f8fbde2808df09fa6bde2808de29ea1efb88f", x"f09f91a9f09f8fbee2808df09fa6bde2808de29ea1efb88f", x"f09f91a9f09f8fbce2808df09fa6bde2808de29ea1efb88f", x"f09f91a9f09f8fbfe2808df09fa6bd", x"f09f91a9f09f8fbbe2808df09fa6bd", x"f09f91a9f09f8fbde2808df09fa6bd", x"f09f91a9f09f8fbee2808df09fa6bd", x"f09f91a9f09f8fbce2808df09fa6bd", x"f09f91a9e2808df09fa6bc", x"f09f91a9e2808df09fa6bce2808de29ea1efb88f", x"f09f91a9f09f8fbfe2808df09fa6bce2808de29ea1efb88f", x"f09f91a9f09f8fbbe2808df09fa6bce2808de29ea1efb88f", x"f09f91a9f09f8fbde2808df09fa6bce2808de29ea1efb88f", x"f09f91a9f09f8fbee2808df09fa6bce2808de29ea1efb88f", x"f09f91a9f09f8fbce2808df09fa6bce2808de29ea1efb88f", x"f09f91a9f09f8fbfe2808df09fa6bc", x"f09f91a9f09f8fbbe2808df09fa6bc", x"f09f91a9f09f8fbde2808df09fa6bc", x"f09f91a9f09f8fbee2808df09fa6bc", x"f09f91a9f09f8fbce2808df09fa6bc", x"f09fa796e2808de29980efb88f", x"f09fa796f09f8fbfe2808de29980efb88f", x"f09fa796f09f8fbbe2808de29980efb88f", x"f09fa796f09f8fbde2808de29980efb88f", x"f09fa796f09f8fbee2808de29980efb88f", x"f09fa796f09f8fbce2808de29980efb88f", x"f09fa4b5e2808de29980efb88f", x"f09fa4b5f09f8fbfe2808de29980efb88f", x"f09fa4b5f09f8fbbe2808de29980efb88f", x"f09fa4b5f09f8fbde2808de29980efb88f", x"f09fa4b5f09f8fbee2808de29980efb88f", x"f09fa4b5f09f8fbce2808de29980efb88f", x"f09f91a9e2808de29a96efb88f", x"f09f91a9f09f8fbfe2808de29a96efb88f", x"f09f91a9f09f8fbbe2808de29a96efb88f", x"f09f91a9f09f8fbde2808de29a96efb88f", x"f09f91a9f09f8fbee2808de29a96efb88f", x"f09f91a9f09f8fbce2808de29a96efb88f", x"f09fa4b9e2808de29980efb88f", x"f09fa4b9f09f8fbfe2808de29980efb88f", x"f09fa4b9f09f8fbbe2808de29980efb88f", x"f09fa4b9f09f8fbde2808de29980efb88f", x"f09fa4b9f09f8fbee2808de29980efb88f", x"f09fa4b9f09f8fbce2808de29980efb88f", x"f09fa78ee2808de29980efb88f", x"f09fa78ee2808de29980efb88fe2808de29ea1efb88f", x"f09fa78ef09f8fbfe2808de29980efb88fe2808de29ea1efb88f", x"f09fa78ef09f8fbbe2808de29980efb88fe2808de29ea1efb88f", x"f09fa78ef09f8fbde2808de29980efb88fe2808de29ea1efb88f", x"f09fa78ef09f8fbee2808de29980efb88fe2808de29ea1efb88f", x"f09fa78ef09f8fbce2808de29980efb88fe2808de29ea1efb88f", x"f09fa78ef09f8fbfe2808de29980efb88f", x"f09fa78ef09f8fbbe2808de29980efb88f", x"f09fa78ef09f8fbde2808de29980efb88f", x"f09fa78ef09f8fbee2808de29980efb88f", x"f09fa78ef09f8fbce2808de29980efb88f", x"f09f8f8befb88fe2808de29980efb88f", x"f09f8f8bf09f8fbfe2808de29980efb88f", x"f09f8f8bf09f8fbbe2808de29980efb88f", x"f09f8f8bf09f8fbde2808de29980efb88f", x"f09f8f8bf09f8fbee2808de29980efb88f", x"f09f8f8bf09f8fbce2808de29980efb88f", x"f09fa799e2808de29980efb88f", x"f09fa799f09f8fbfe2808de29980efb88f", x"f09fa799f09f8fbbe2808de29980efb88f", x"f09fa799f09f8fbde2808de29980efb88f", x"f09fa799f09f8fbee2808de29980efb88f", x"f09fa799f09f8fbce2808de29980efb88f", x"f09f91a9e2808df09f94a7", x"f09f91a9f09f8fbfe2808df09f94a7", x"f09f91a9f09f8fbbe2808df09f94a7", x"f09f91a9f09f8fbde2808df09f94a7", x"f09f91a9f09f8fbee2808df09f94a7", x"f09f91a9f09f8fbce2808df09f94a7", x"f09f9ab5e2808de29980efb88f", x"f09f9ab5f09f8fbfe2808de29980efb88f", x"f09f9ab5f09f8fbbe2808de29980efb88f", x"f09f9ab5f09f8fbde2808de29980efb88f", x"f09f9ab5f09f8fbee2808de29980efb88f", x"f09f9ab5f09f8fbce2808de29980efb88f", x"f09f91a9e2808df09f92bc", x"f09f91a9f09f8fbfe2808df09f92bc", x"f09f91a9f09f8fbbe2808df09f92bc", x"f09f91a9f09f8fbde2808df09f92bc", x"f09f91a9f09f8fbee2808df09f92bc", x"f09f91a9f09f8fbce2808df09f92bc", x"f09f91a9e2808de29c88efb88f", x"f09f91a9f09f8fbfe2808de29c88efb88f", x"f09f91a9f09f8fbbe2808de29c88efb88f", x"f09f91a9f09f8fbde2808de29c88efb88f", x"f09f91a9f09f8fbee2808de29c88efb88f", x"f09f91a9f09f8fbce2808de29c88efb88f", x"f09fa4bee2808de29980efb88f", x"f09fa4bef09f8fbfe2808de29980efb88f", x"f09fa4bef09f8fbbe2808de29980efb88f", x"f09fa4bef09f8fbde2808de29980efb88f", x"f09fa4bef09f8fbee2808de29980efb88f", x"f09fa4bef09f8fbce2808de29980efb88f", x"f09fa4bde2808de29980efb88f", x"f09fa4bdf09f8fbfe2808de29980efb88f", x"f09fa4bdf09f8fbbe2808de29980efb88f", x"f09fa4bdf09f8fbde2808de29980efb88f", x"f09fa4bdf09f8fbee2808de29980efb88f", x"f09fa4bdf09f8fbce2808de29980efb88f", x"f09f91aee2808de29980efb88f", x"f09f91aef09f8fbfe2808de29980efb88f", x"f09f91aef09f8fbbe2808de29980efb88f", x"f09f91aef09f8fbde2808de29980efb88f", x"f09f91aef09f8fbee2808de29980efb88f", x"f09f91aef09f8fbce2808de29980efb88f", x"f09f998ee2808de29980efb88f", x"f09f998ef09f8fbfe2808de29980efb88f", x"f09f998ef09f8fbbe2808de29980efb88f", x"f09f998ef09f8fbde2808de29980efb88f", x"f09f998ef09f8fbee2808de29980efb88f", x"f09f998ef09f8fbce2808de29980efb88f", x"f09f998be2808de29980efb88f", x"f09f998bf09f8fbfe2808de29980efb88f", x"f09f998bf09f8fbbe2808de29980efb88f", x"f09f998bf09f8fbde2808de29980efb88f", x"f09f998bf09f8fbee2808de29980efb88f", x"f09f998bf09f8fbce2808de29980efb88f", x"f09f9aa3e2808de29980efb88f", x"f09f9aa3f09f8fbfe2808de29980efb88f", x"f09f9aa3f09f8fbbe2808de29980efb88f", x"f09f9aa3f09f8fbde2808de29980efb88f", x"f09f9aa3f09f8fbee2808de29980efb88f", x"f09f9aa3f09f8fbce2808de29980efb88f", x"f09f8f83e2808de29980efb88f", x"f09f8f83e2808de29980efb88fe2808de29ea1efb88f", x"f09f8f83f09f8fbfe2808de29980efb88fe2808de29ea1efb88f", x"f09f8f83f09f8fbbe2808de29980efb88fe2808de29ea1efb88f", x"f09f8f83f09f8fbde2808de29980efb88fe2808de29ea1efb88f", x"f09f8f83f09f8fbee2808de29980efb88fe2808de29ea1efb88f", x"f09f8f83f09f8fbce2808de29980efb88fe2808de29ea1efb88f", x"f09f8f83f09f8fbfe2808de29980efb88f", x"f09f8f83f09f8fbbe2808de29980efb88f", x"f09f8f83f09f8fbde2808de29980efb88f", x"f09f8f83f09f8fbee2808de29980efb88f", x"f09f8f83f09f8fbce2808de29980efb88f", x"f09f91a9e2808df09f94ac", x"f09f91a9f09f8fbfe2808df09f94ac", x"f09f91a9f09f8fbbe2808df09f94ac", x"f09f91a9f09f8fbde2808df09f94ac", x"f09f91a9f09f8fbee2808df09f94ac", x"f09f91a9f09f8fbce2808df09f94ac", x"f09fa4b7e2808de29980efb88f", x"f09fa4b7f09f8fbfe2808de29980efb88f", x"f09fa4b7f09f8fbbe2808de29980efb88f", x"f09fa4b7f09f8fbde2808de29980efb88f", x"f09fa4b7f09f8fbee2808de29980efb88f", x"f09fa4b7f09f8fbce2808de29980efb88f", x"f09f91a9e2808df09f8ea4", x"f09f91a9f09f8fbfe2808df09f8ea4", x"f09f91a9f09f8fbbe2808df09f8ea4", x"f09f91a9f09f8fbde2808df09f8ea4", x"f09f91a9f09f8fbee2808df09f8ea4", x"f09f91a9f09f8fbce2808df09f8ea4", x"f09fa78de2808de29980efb88f", x"f09fa78df09f8fbfe2808de29980efb88f", x"f09fa78df09f8fbbe2808de29980efb88f", x"f09fa78df09f8fbde2808de29980efb88f", x"f09fa78df09f8fbee2808de29980efb88f", x"f09fa78df09f8fbce2808de29980efb88f", x"f09f91a9e2808df09f8e93", x"f09f91a9f09f8fbfe2808df09f8e93", x"f09f91a9f09f8fbbe2808df09f8e93", x"f09f91a9f09f8fbde2808df09f8e93", x"f09f91a9f09f8fbee2808df09f8e93", x"f09f91a9f09f8fbce2808df09f8e93", x"f09fa6b8e2808de29980efb88f", x"f09fa6b8f09f8fbfe2808de29980efb88f", x"f09fa6b8f09f8fbbe2808de29980efb88f", x"f09fa6b8f09f8fbde2808de29980efb88f", x"f09fa6b8f09f8fbee2808de29980efb88f", x"f09fa6b8f09f8fbce2808de29980efb88f", x"f09fa6b9e2808de29980efb88f", x"f09fa6b9f09f8fbfe2808de29980efb88f", x"f09fa6b9f09f8fbbe2808de29980efb88f", x"f09fa6b9f09f8fbde2808de29980efb88f", x"f09fa6b9f09f8fbee2808de29980efb88f", x"f09fa6b9f09f8fbce2808de29980efb88f", x"f09f8f84e2808de29980efb88f", x"f09f8f84f09f8fbfe2808de29980efb88f", x"f09f8f84f09f8fbbe2808de29980efb88f", x"f09f8f84f09f8fbde2808de29980efb88f", x"f09f8f84f09f8fbee2808de29980efb88f", x"f09f8f84f09f8fbce2808de29980efb88f", x"f09f8f8ae2808de29980efb88f", x"f09f8f8af09f8fbfe2808de29980efb88f", x"f09f8f8af09f8fbbe2808de29980efb88f", x"f09f8f8af09f8fbde2808de29980efb88f", x"f09f8f8af09f8fbee2808de29980efb88f", x"f09f8f8af09f8fbce2808de29980efb88f", x"f09f91a9e2808df09f8fab", x"f09f91a9f09f8fbfe2808df09f8fab", x"f09f91a9f09f8fbbe2808df09f8fab", x"f09f91a9f09f8fbde2808df09f8fab", x"f09f91a9f09f8fbee2808df09f8fab", x"f09f91a9f09f8fbce2808df09f8fab", x"f09f91a9e2808df09f92bb", x"f09f91a9f09f8fbfe2808df09f92bb", x"f09f91a9f09f8fbbe2808df09f92bb", x"f09f91a9f09f8fbde2808df09f92bb", x"f09f91a9f09f8fbee2808df09f92bb", x"f09f91a9f09f8fbce2808df09f92bb", x"f09f9281e2808de29980efb88f", x"f09f9281f09f8fbfe2808de29980efb88f", x"f09f9281f09f8fbbe2808de29980efb88f", x"f09f9281f09f8fbde2808de29980efb88f", x"f09f9281f09f8fbee2808de29980efb88f", x"f09f9281f09f8fbce2808de29980efb88f", x"f09fa79be2808de29980efb88f", x"f09fa79bf09f8fbfe2808de29980efb88f", x"f09fa79bf09f8fbbe2808de29980efb88f", x"f09fa79bf09f8fbde2808de29980efb88f", x"f09fa79bf09f8fbee2808de29980efb88f", x"f09fa79bf09f8fbce2808de29980efb88f", x"f09f9ab6e2808de29980efb88f", x"f09f9ab6e2808de29980efb88fe2808de29ea1efb88f", x"f09f9ab6f09f8fbfe2808de29980efb88fe2808de29ea1efb88f", x"f09f9ab6f09f8fbbe2808de29980efb88fe2808de29ea1efb88f", x"f09f9ab6f09f8fbde2808de29980efb88fe2808de29ea1efb88f", x"f09f9ab6f09f8fbee2808de29980efb88fe2808de29ea1efb88f", x"f09f9ab6f09f8fbce2808de29980efb88fe2808de29ea1efb88f", x"f09f9ab6f09f8fbfe2808de29980efb88f", x"f09f9ab6f09f8fbbe2808de29980efb88f", x"f09f9ab6f09f8fbde2808de29980efb88f", x"f09f9ab6f09f8fbee2808de29980efb88f", x"f09f9ab6f09f8fbce2808de29980efb88f", x"f09f91b3e2808de29980efb88f", x"f09f91b3f09f8fbfe2808de29980efb88f", x"f09f91b3f09f8fbbe2808de29980efb88f", x"f09f91b3f09f8fbde2808de29980efb88f", x"f09f91b3f09f8fbee2808de29980efb88f", x"f09f91b3f09f8fbce2808de29980efb88f", x"f09f91b0e2808de29980efb88f", x"f09f91b0f09f8fbfe2808de29980efb88f", x"f09f91b0f09f8fbbe2808de29980efb88f", x"f09f91b0f09f8fbde2808de29980efb88f", x"f09f91b0f09f8fbee2808de29980efb88f", x"f09f91b0f09f8fbce2808de29980efb88f", x"f09f91a9e2808df09fa6af", x"f09f91a9e2808df09fa6afe2808de29ea1efb88f", x"f09f91a9f09f8fbfe2808df09fa6afe2808de29ea1efb88f", x"f09f91a9f09f8fbbe2808df09fa6afe2808de29ea1efb88f", x"f09f91a9f09f8fbde2808df09fa6afe2808de29ea1efb88f", x"f09f91a9f09f8fbee2808df09fa6afe2808de29ea1efb88f", x"f09f91a9f09f8fbce2808df09fa6afe2808de29ea1efb88f", x"f09f91a9f09f8fbfe2808df09fa6af", x"f09f91a9f09f8fbbe2808df09fa6af", x"f09f91a9f09f8fbde2808df09fa6af", x"f09f91a9f09f8fbee2808df09fa6af", x"f09f91a9f09f8fbce2808df09fa6af", x"f09fa79fe2808de29980efb88f", x"f09f91a9e2808df09fa6b2", x"f09fa794e2808de29980efb88f", x"f09f91b1e2808de29980efb88f", x"f09f91a9e2808df09fa6b1", x"f09f91a9f09f8fbfe2808df09fa6b2", x"f09fa794f09f8fbfe2808de29980efb88f", x"f09f91b1f09f8fbfe2808de29980efb88f", x"f09f91a9f09f8fbfe2808df09fa6b1", x"f09f91a9f09f8fbfe2808df09fa6b0", x"f09f91a9f09f8fbfe2808df09fa6b3", x"f09f91a9f09f8fbbe2808df09fa6b2", x"f09fa794f09f8fbbe2808de29980efb88f", x"f09f91b1f09f8fbbe2808de29980efb88f", x"f09f91a9f09f8fbbe2808df09fa6b1", x"f09f91a9f09f8fbbe2808df09fa6b0", x"f09f91a9f09f8fbbe2808df09fa6b3", x"f09f91a9f09f8fbde2808df09fa6b2", x"f09fa794f09f8fbde2808de29980efb88f", x"f09f91b1f09f8fbde2808de29980efb88f", x"f09f91a9f09f8fbde2808df09fa6b1", x"f09f91a9f09f8fbde2808df09fa6b0", x"f09f91a9f09f8fbde2808df09fa6b3", x"f09f91a9f09f8fbee2808df09fa6b2", x"f09fa794f09f8fbee2808de29980efb88f", x"f09f91b1f09f8fbee2808de29980efb88f", x"f09f91a9f09f8fbee2808df09fa6b1", x"f09f91a9f09f8fbee2808df09fa6b0", x"f09f91a9f09f8fbee2808df09fa6b3", x"f09f91a9f09f8fbce2808df09fa6b2", x"f09fa794f09f8fbce2808de29980efb88f", x"f09f91b1f09f8fbce2808de29980efb88f", x"f09f91a9f09f8fbce2808df09fa6b1", x"f09f91a9f09f8fbce2808df09fa6b0", x"f09f91a9f09f8fbce2808df09fa6b3", x"f09f91a9e2808df09fa6b0", x"f09f91a9e2808df09fa6b3", x"f09f91afe2808de29980efb88f", x"f09fa4bce2808de29980efb88f"];
        let v41 = if (0x1::table::contains<vector<u8>, u8>(v39, *0x1::vector::borrow<vector<u8>>(&v40, 0))) {
            false
        } else {
            let v42 = v40;
            0x1::vector::reverse<vector<u8>>(&mut v42);
            let v43 = v42;
            let v44 = 0x1::vector::length<vector<u8>>(&v43);
            while (v44 > 0) {
                0x1::table::add<vector<u8>, u8>(v39, 0x1::vector::pop_back<vector<u8>>(&mut v43), 0);
                v44 = v44 - 1;
            };
            0x1::vector::destroy_empty<vector<u8>>(v43);
            true
        };
        let v45 = if (v41) {
            0
        } else {
            let v46 = 100000000;
            assert!(0x1::coin::is_account_registered<0x1::aptos_coin::AptosCoin>(v38) && 0x1::coin::balance<0x1::aptos_coin::AptosCoin>(v38) >= v46, 10);
            0x1::aptos_account::transfer(arg0, arg2, v46);
            0x1::aggregator_v2::try_add<u128>(&mut v0.global_stats.cumulative_integrator_fees, v46 as u128);
            v46
        };
        assert!(0x1::coin::is_account_registered<0x1::aptos_coin::AptosCoin>(v38) && 0x1::coin::balance<0x1::aptos_coin::AptosCoin>(v38) >= 100000000, 17);
        let v47 = RegistrantDeposit{
            market_registrant : v38, 
            deposit           : 0x1::coin::withdraw<0x1::aptos_coin::AptosCoin>(arg0, 100000000),
        };
        move_to<RegistrantDeposit>(&v31, v47);
        let v48 = RegistrantGracePeriodFlag{
            market_registrant        : v38, 
            market_registration_time : v33,
        };
        move_to<RegistrantGracePeriodFlag>(&v31, v48);
        let v49 = v32.clamm_virtual_reserves;
        let v50 = (v49.quote as u128) * (4500000000000000 as u128) / (v49.base as u128);
        0x1::aggregator_v2::try_add<u128>(&mut v0.global_stats.fully_diluted_value, v50);
        let v51 = MarketRegistration{
            market_metadata : v32.metadata, 
            time            : v33, 
            registrant      : v38, 
            integrator      : arg2, 
            integrator_fee  : v45,
        };
        0x1::event::emit<MarketRegistration>(v51);
        let v52 = v32;
        let v53 = InstantaneousStats{
            total_quote_locked  : 0, 
            total_value_locked  : 0, 
            market_cap          : 0, 
            fully_diluted_value : v50,
        };
        let v54 = &v52.sequence_info;
        let v55 = StateMetadata{
            market_nonce : v54.nonce, 
            bump_time    : v54.last_bump_time, 
            trigger      : 1,
        };
        let v56 = State{
            market_metadata        : v52.metadata, 
            state_metadata         : v55, 
            clamm_virtual_reserves : v52.clamm_virtual_reserves, 
            cpamm_real_reserves    : v52.cpamm_real_reserves, 
            lp_coin_supply         : v52.lp_coin_supply, 
            cumulative_stats       : v52.cumulative_stats, 
            instantaneous_stats    : v53, 
            last_swap              : v52.last_swap,
        };
        0x1::event::emit<State>(v56);
    }
    
    public fun registry_address() : address acquires RegistryAddress {
        borrow_global<RegistryAddress>(@0xface729284ae5729100b3a9ad7f7cc025ea09739cd6e7252aff0beb53619cafe).registry_address
    }
    
    public fun registry_view() : RegistryView acquires Registry, RegistryAddress {
        let v0 = borrow_global<Registry>(borrow_global<RegistryAddress>(@0xface729284ae5729100b3a9ad7f7cc025ea09739cd6e7252aff0beb53619cafe).registry_address);
        RegistryView{
            registry_address           : v0.registry_address, 
            nonce                      : 0x1::aggregator_v2::snapshot<u64>(&v0.sequence_info.nonce), 
            last_bump_time             : v0.sequence_info.last_bump_time, 
            n_markets                  : 0x1::smart_table::length<u64, address>(&v0.markets_by_market_id), 
            cumulative_quote_volume    : 0x1::aggregator_v2::snapshot<u128>(&v0.global_stats.cumulative_quote_volume), 
            total_quote_locked         : 0x1::aggregator_v2::snapshot<u128>(&v0.global_stats.total_quote_locked), 
            total_value_locked         : 0x1::aggregator_v2::snapshot<u128>(&v0.global_stats.total_value_locked), 
            market_cap                 : 0x1::aggregator_v2::snapshot<u128>(&v0.global_stats.market_cap), 
            fully_diluted_value        : 0x1::aggregator_v2::snapshot<u128>(&v0.global_stats.fully_diluted_value), 
            cumulative_integrator_fees : 0x1::aggregator_v2::snapshot<u128>(&v0.global_stats.cumulative_integrator_fees), 
            cumulative_swaps           : 0x1::aggregator_v2::snapshot<u64>(&v0.global_stats.cumulative_swaps), 
            cumulative_chat_messages   : 0x1::aggregator_v2::snapshot<u64>(&v0.global_stats.cumulative_chat_messages),
        }
    }
    
    public entry fun remove_liquidity<T0, T1>(arg0: &signer, arg1: address, arg2: u64, arg3: u64) acquires LPCoinCapabilities, Market, Registry, RegistryAddress {
        assert!(arg3 > 0, 22);
        assert!(exists<Market>(arg1), 2);
        let v0 = borrow_global_mut<Market>(arg1);
        let v1 = 0x1::object::generate_signer_for_extending(&v0.extend_ref);
        assert!(exists<LPCoinCapabilities<T0, T1>>(arg1), 6);
        let v2 = 0x1::signer::address_of(arg0);
        let v3 = v0;
        let v4 = v3.lp_coin_supply;
        let v5 = arg2 as u128;
        assert!(v4 > 0, 3);
        assert!(arg2 > 0, 5);
        let v6 = v3.cpamm_real_reserves;
        let v7 = v6.base;
        let v8 = v6.quote;
        let v9 = (v5 * (v7 as u128) / v4) as u64;
        assert!(v9 > 0, 25);
        let v10 = (v5 * (v8 as u128) / v4) as u64;
        assert!(v10 > 0, 26);
        let v11 = v3.metadata.market_address;
        let v12 = Liquidity{
            market_id                   : v3.metadata.market_id, 
            time                        : 0x1::timestamp::now_microseconds(), 
            market_nonce                : v3.sequence_info.nonce + 1, 
            provider                    : v2, 
            base_amount                 : v9, 
            quote_amount                : v10, 
            lp_coin_amount              : arg2, 
            liquidity_provided          : false, 
            base_donation_claim_amount  : 0x1::coin::balance<T0>(v11) - v7, 
            quote_donation_claim_amount : 0x1::coin::balance<0x1::aptos_coin::AptosCoin>(v11) - v8,
        };
        assert!(v12.quote_amount >= arg3, 23);
        let v13 = borrow_global_mut<Registry>(borrow_global<RegistryAddress>(@0xface729284ae5729100b3a9ad7f7cc025ea09739cd6e7252aff0beb53619cafe).registry_address);
        let v14 = 5;
        trigger_periodic_state(v0, v13, v12.time, v14, 2 * (v0.cpamm_real_reserves.quote as u128));
        0x1::coin::transfer<T0>(&v1, v2, v12.base_amount + v12.base_donation_claim_amount);
        0x1::coin::transfer<0x1::aptos_coin::AptosCoin>(&v1, v2, v12.quote_amount + v12.quote_donation_claim_amount);
        0x1::coin::burn<T1>(0x1::coin::withdraw<T1>(arg0, v12.lp_coin_amount), &borrow_global<LPCoinCapabilities<T0, T1>>(v0.metadata.market_address).burn);
        let v15 = &mut v0.cpamm_real_reserves;
        let v16 = &mut v15.quote;
        let v17 = *v16;
        v15.base = v15.base - v12.base_amount;
        *v16 = v17 - v12.quote_amount;
        let v18 = v0.lp_coin_supply - (v12.lp_coin_amount as u128);
        v0.lp_coin_supply = v18;
        let v19 = 2 * (*v16 as u128);
        let v20 = &mut v13.global_stats;
        0x1::aggregator_v2::try_sub<u128>(&mut v20.total_quote_locked, v12.quote_amount as u128);
        0x1::aggregator_v2::try_sub<u128>(&mut v20.total_value_locked, 2 * (v17 as u128) - v19);
        let v21 = 4500000000000000;
        let v22 = v0.cpamm_real_reserves;
        let v23 = v22.base;
        let v24 = v22.quote;
        let v25 = (v24 as u128) * (4500000000000000 as u128) / (v23 as u128);
        let v26 = (v24 as u128) * ((v21 - v23) as u128) / (v23 as u128);
        let v27 = *v15;
        let v28 = v27.base;
        let v29 = v27.quote;
        let v30 = (v29 as u128) * (4500000000000000 as u128) / (v28 as u128);
        let v31 = (v29 as u128) * ((v21 - v28) as u128) / (v28 as u128);
        if (v30 > v25) {
            0x1::aggregator_v2::try_add<u128>(&mut v20.fully_diluted_value, v30 - v25);
        } else {
            0x1::aggregator_v2::try_sub<u128>(&mut v20.fully_diluted_value, v25 - v30);
        };
        if (v31 > v26) {
            0x1::aggregator_v2::try_add<u128>(&mut v20.market_cap, v31 - v26);
        } else {
            0x1::aggregator_v2::try_sub<u128>(&mut v20.market_cap, v26 - v31);
        };
        0x1::event::emit<Liquidity>(v12);
        let v32 = &mut v0.periodic_state_trackers;
        let v33 = 0;
        while (v33 < 0x1::vector::length<PeriodicStateTracker>(v32)) {
            let v34 = 0x1::vector::borrow_mut<PeriodicStateTracker>(v32, v33);
            v34.tvl_to_lp_coin_ratio_end.tvl = v19;
            v34.tvl_to_lp_coin_ratio_end.lp_coins = v18;
            v34.ends_in_bonding_curve = false;
            v33 = v33 + 1;
        };
        let v35 = v0;
        let v36 = InstantaneousStats{
            total_quote_locked  : v15.quote, 
            total_value_locked  : v19, 
            market_cap          : v31, 
            fully_diluted_value : v30,
        };
        let v37 = &v35.sequence_info;
        let v38 = StateMetadata{
            market_nonce : v37.nonce, 
            bump_time    : v37.last_bump_time, 
            trigger      : v14,
        };
        let v39 = State{
            market_metadata        : v35.metadata, 
            state_metadata         : v38, 
            clamm_virtual_reserves : v35.clamm_virtual_reserves, 
            cpamm_real_reserves    : v35.cpamm_real_reserves, 
            lp_coin_supply         : v35.lp_coin_supply, 
            cumulative_stats       : v35.cumulative_stats, 
            instantaneous_stats    : v36, 
            last_swap              : v35.last_swap,
        };
        0x1::event::emit<State>(v39);
    }
    
    public fun simulate_provide_liquidity(arg0: address, arg1: address, arg2: u64) : Liquidity acquires Market {
        assert!(exists<Market>(arg1), 2);
        let v0 = borrow_global<Market>(arg1);
        assert!(v0.lp_coin_supply > 0, 3);
        assert!(arg2 > 0, 4);
        let v1 = v0.cpamm_real_reserves;
        let v2 = v1.quote as u128;
        let v3 = arg2 as u128;
        let v4 = (v1.base as u128) * v3;
        Liquidity{
            market_id                   : v0.metadata.market_id, 
            time                        : 0x1::timestamp::now_microseconds(), 
            market_nonce                : v0.sequence_info.nonce + 1, 
            provider                    : arg0, 
            base_amount                 : (v4 / v2 + 1 - (v4 % v2 ^ 340282366920938463463374607431768211455) / 340282366920938463463374607431768211455) as u64, 
            quote_amount                : arg2, 
            lp_coin_amount              : (v3 * v0.lp_coin_supply / v2) as u64, 
            liquidity_provided          : true, 
            base_donation_claim_amount  : 0, 
            quote_donation_claim_amount : 0,
        }
    }
    
    public fun simulate_remove_liquidity<T0>(arg0: address, arg1: address, arg2: u64) : Liquidity acquires Market {
        assert!(exists<Market>(arg1), 2);
        let v0 = borrow_global<Market>(arg1);
        let v1 = v0.lp_coin_supply;
        let v2 = arg2 as u128;
        assert!(v1 > 0, 3);
        assert!(arg2 > 0, 5);
        let v3 = v0.cpamm_real_reserves;
        let v4 = v3.base;
        let v5 = v3.quote;
        let v6 = (v2 * (v4 as u128) / v1) as u64;
        assert!(v6 > 0, 25);
        let v7 = (v2 * (v5 as u128) / v1) as u64;
        assert!(v7 > 0, 26);
        let v8 = v0.metadata.market_address;
        Liquidity{
            market_id                   : v0.metadata.market_id, 
            time                        : 0x1::timestamp::now_microseconds(), 
            market_nonce                : v0.sequence_info.nonce + 1, 
            provider                    : arg0, 
            base_amount                 : v6, 
            quote_amount                : v7, 
            lp_coin_amount              : arg2, 
            liquidity_provided          : false, 
            base_donation_claim_amount  : 0x1::coin::balance<T0>(v8) - v4, 
            quote_donation_claim_amount : 0x1::coin::balance<0x1::aptos_coin::AptosCoin>(v8) - v5,
        }
    }
    
    public fun simulate_swap<T0, T1>(arg0: address, arg1: address, arg2: u64, arg3: bool, arg4: address, arg5: u8) : Swap acquires Market {
        assert!(exists<Market>(arg1), 2);
        simulate_swap_inner<T0, T1>(arg0, arg2, arg3, arg4, arg5, borrow_global<Market>(arg1))
    }
    
    fun simulate_swap_inner<T0, T1>(arg0: address, arg1: u64, arg2: bool, arg3: address, arg4: u8, arg5: &Market) : Swap {
        assert!(arg1 > 0, 1);
        let v0 = 0x1::object::generate_signer_for_extending(&arg5.extend_ref);
        let v1 = &v0;
        let v2 = arg5.metadata.market_address;
        if (!exists<LPCoinCapabilities<T0, T1>>(v2)) {
            let v3 = 0x1::type_info::type_of<T0>();
            let v4 = &v3;
            let v5 = 0x1::type_info::type_of<T1>();
            let v6 = &v5;
            assert!(0x1::type_info::account_address(v4) == v2 && 0x1::type_info::account_address(v6) == v2 && 0x1::type_info::module_name(v4) == b"coin_factory" && 0x1::type_info::module_name(v6) == b"coin_factory" && 0x1::type_info::struct_name(v4) == b"Emojicoin" && 0x1::type_info::struct_name(v6) == b"EmojicoinLP", 6);
            let v7 = 0x1::string::utf8(arg5.metadata.emoji_bytes);
            let v8 = v7;
            0x1::string::append(&mut v8, 0x1::string::utf8(b" emojicoin"));
            let (v9, v10, v11) = 0x1::coin::initialize<T0>(v1, v8, v7, 8, true);
            let v12 = v11;
            0x1::aptos_account::deposit_coins<T0>(v2, 0x1::coin::mint<T0>(4500000000000000, &v12));
            0x1::coin::destroy_freeze_cap<T0>(v10);
            0x1::coin::destroy_mint_cap<T0>(v12);
            0x1::coin::destroy_burn_cap<T0>(v9);
            let v13 = 0x1::string::utf8(b"LP-");
            0x1::string::append(&mut v13, 0x1::string_utils::to_string<u64>(&arg5.metadata.market_id));
            let v14 = v7;
            0x1::string::append(&mut v14, 0x1::string::utf8(b" emojicoin LP"));
            let (v15, v16, v17) = 0x1::coin::initialize<T1>(v1, v14, v13, 8, true);
            0x1::coin::register<T1>(v1);
            0x1::coin::destroy_freeze_cap<T1>(v16);
            let v18 = LPCoinCapabilities<T0, T1>{
                burn : v15, 
                mint : v17,
            };
            move_to<LPCoinCapabilities<T0, T1>>(v1, v18);
        };
        let v19 = arg5.lp_coin_supply == 0;
        let v20 = 0;
        let v21 = false;
        let (v22, v23) = if (v19) {
            (4900000000000000, &arg5.clamm_virtual_reserves)
        } else {
            (4500000000000000, &arg5.cpamm_real_reserves)
        };
        let v24 = v22 - v23.base;
        let v25 = if (0x1::coin::is_account_registered<T0>(arg0)) {
            0x1::coin::balance<T0>(arg0)
        } else {
            0
        };
        let v26 = if (v24 == 0) {
            0
        } else {
            ((v25 as u128) << 64) / (v24 as u128)
        };
        let (v27, v28, v29, v30, v31, v32) = if (arg2) {
            let v33 = if (v19) {
                let v34 = arg5.clamm_virtual_reserves;
                let (v35, v36) = if (arg2) {
                    (v34.quote, v34.base)
                } else {
                    (v34.base, v34.quote)
                };
                let v37 = (arg1 as u128) + (v36 as u128);
                assert!(v37 > 0, 0);
                let v38 = (arg1 as u128) * (v35 as u128) / v37;
                assert!(v38 > 0, 24);
                v38 as u64
            } else {
                let v39 = arg5.cpamm_real_reserves;
                let (v40, v41) = if (arg2) {
                    (v39.quote, v39.base)
                } else {
                    (v39.base, v39.quote)
                };
                let v42 = (arg1 as u128) + (v41 as u128);
                assert!(v42 > 0, 0);
                let v43 = (arg1 as u128) * (v40 as u128) / v42;
                assert!(v43 > 0, 24);
                let v44 = v43 as u64;
                v20 = ((v44 as u128) * (25 as u128) / 10000) as u64;
                v44
            };
            let v45 = ((v33 as u128) * (arg4 as u128) / 10000) as u64;
            let v46 = v33 - v20 - v45;
            assert!(arg1 <= v25, 27);
            (v27, arg1, v29, v45, v46, v46)
        } else {
            let v47 = ((arg1 as u128) * (arg4 as u128) / 10000) as u64;
            let v48 = arg1 - v47;
            let v28 = if (v19) {
                let v49 = 140000000000 - arg5.clamm_virtual_reserves.quote;
                if (v48 < v49) {
                    let v50 = arg5.clamm_virtual_reserves;
                    let (v51, v52) = if (arg2) {
                        (v50.quote, v50.base)
                    } else {
                        (v50.base, v50.quote)
                    };
                    let v53 = (v48 as u128) + (v52 as u128);
                    assert!(v53 > 0, 0);
                    let v54 = (v48 as u128) * (v51 as u128) / v53;
                    assert!(v54 > 0, 24);
                    v54 as u64
                } else {
                    v21 = true;
                    let v55 = arg5.clamm_virtual_reserves.base - 1400000000000000;
                    let v28 = v55;
                    let v56 = v48 - v49;
                    if (v56 > 0) {
                        let v57 = Reserves{
                            base  : 1000000000000000, 
                            quote : 100000000000,
                        };
                        let (v58, v59) = if (arg2) {
                            (v57.quote, v57.base)
                        } else {
                            (v57.base, v57.quote)
                        };
                        let v60 = (v56 as u128) + (v59 as u128);
                        assert!(v60 > 0, 0);
                        let v61 = (v56 as u128) * (v58 as u128) / v60;
                        assert!(v61 > 0, 24);
                        let v62 = v61 as u64;
                        let v63 = ((v62 as u128) * (25 as u128) / 10000) as u64;
                        v20 = v63;
                        v28 = v55 + v62 - v63;
                    };
                    v28
                }
            } else {
                let v64 = arg5.cpamm_real_reserves;
                let (v65, v66) = if (arg2) {
                    (v64.quote, v64.base)
                } else {
                    (v64.base, v64.quote)
                };
                let v67 = (v48 as u128) + (v66 as u128);
                assert!(v67 > 0, 0);
                let v68 = (v48 as u128) * (v65 as u128) / v67;
                assert!(v68 > 0, 24);
                let v69 = v68 as u64;
                let v70 = ((v69 as u128) * (25 as u128) / 10000) as u64;
                v20 = v70;
                v69 - v70
            };
            (v25 + v28, v28, v24 + v28, v47, v28, v48)
        };
        let v71 = if (v29 == 0) {
            0
        } else {
            ((v27 as u128) << 64) / (v29 as u128)
        };
        Swap{
            market_id                                            : arg5.metadata.market_id, 
            time                                                 : 0x1::timestamp::now_microseconds(), 
            market_nonce                                         : arg5.sequence_info.nonce + 1, 
            swapper                                              : arg0, 
            input_amount                                         : arg1, 
            is_sell                                              : arg2, 
            integrator                                           : arg3, 
            integrator_fee_rate_bps                              : arg4, 
            net_proceeds                                         : v31, 
            base_volume                                          : v28, 
            quote_volume                                         : v32, 
            avg_execution_price_q64                              : ((v32 as u128) << 64) / (v28 as u128), 
            integrator_fee                                       : v30, 
            pool_fee                                             : v20, 
            starts_in_bonding_curve                              : v19, 
            results_in_state_transition                          : v21, 
            balance_as_fraction_of_circulating_supply_before_q64 : v26, 
            balance_as_fraction_of_circulating_supply_after_q64  : v71,
        }
    }
    
    fun trigger_periodic_state(arg0: &mut Market, arg1: &mut Registry, arg2: u64, arg3: u8, arg4: u128) {
        let v0 = &mut arg0.sequence_info;
        let v1 = v0.nonce + 1;
        v0.nonce = v1;
        v0.last_bump_time = arg2;
        let v2 = arg0.lp_coin_supply;
        let v3 = v2 == 0;
        let v4 = &mut arg0.periodic_state_trackers;
        let v5 = 0;
        while (v5 < 0x1::vector::length<PeriodicStateTracker>(v4)) {
            let v6 = 0x1::vector::borrow_mut<PeriodicStateTracker>(v4, v5);
            let v7 = v6.period;
            if (arg2 - v6.start_time >= v7) {
                let v8 = v6;
                let v9 = PeriodicStateMetadata{
                    start_time        : v8.start_time, 
                    period            : v8.period, 
                    emit_time         : arg2, 
                    emit_market_nonce : v1, 
                    trigger           : arg3,
                };
                let v10 = v8.tvl_to_lp_coin_ratio_end;
                let v11 = v8.tvl_to_lp_coin_ratio_start;
                let v12 = v11.tvl;
                let v13 = v10.lp_coins;
                let v14 = if (v12 == 0 || v13 == 0) {
                    0
                } else {
                    (((v11.lp_coins as u256) * (v10.tvl as u256) << 64) / (v12 as u256) * (v13 as u256)) as u128
                };
                let v15 = PeriodicState{
                    market_metadata            : arg0.metadata, 
                    periodic_state_metadata    : v9, 
                    open_price_q64             : v8.open_price_q64, 
                    high_price_q64             : v8.high_price_q64, 
                    low_price_q64              : v8.low_price_q64, 
                    close_price_q64            : v8.close_price_q64, 
                    volume_base                : v8.volume_base, 
                    volume_quote               : v8.volume_quote, 
                    integrator_fees            : v8.integrator_fees, 
                    pool_fees_base             : v8.pool_fees_base, 
                    pool_fees_quote            : v8.pool_fees_quote, 
                    n_swaps                    : v8.n_swaps, 
                    n_chat_messages            : v8.n_chat_messages, 
                    starts_in_bonding_curve    : v8.starts_in_bonding_curve, 
                    ends_in_bonding_curve      : v8.ends_in_bonding_curve, 
                    tvl_per_lp_coin_growth_q64 : v14,
                };
                0x1::event::emit<PeriodicState>(v15);
                v6.start_time = arg2 / v7 * v7;
                v6.open_price_q64 = 0;
                v6.high_price_q64 = 0;
                v6.low_price_q64 = 0;
                v6.close_price_q64 = 0;
                v6.volume_base = 0;
                v6.volume_quote = 0;
                v6.integrator_fees = 0;
                v6.pool_fees_base = 0;
                v6.pool_fees_quote = 0;
                v6.n_swaps = 0;
                v6.n_chat_messages = 0;
                v6.starts_in_bonding_curve = v3;
                v6.ends_in_bonding_curve = v3;
                v6.tvl_to_lp_coin_ratio_start.tvl = arg4;
                v6.tvl_to_lp_coin_ratio_start.lp_coins = v2;
                v6.tvl_to_lp_coin_ratio_end.tvl = arg4;
                v6.tvl_to_lp_coin_ratio_end.lp_coins = v2;
            };
            v5 = v5 + 1;
        };
        let v16 = &mut arg1.sequence_info;
        let v17 = &mut v16.nonce;
        0x1::aggregator_v2::try_add<u64>(v17, 1);
        if (arg2 - v16.last_bump_time >= 86400000000) {
            v16.last_bump_time = arg2;
            let v18 = &arg1.global_stats;
            let v19 = GlobalState{
                emit_time                  : arg2, 
                registry_nonce             : 0x1::aggregator_v2::snapshot<u64>(v17), 
                trigger                    : arg3, 
                cumulative_quote_volume    : 0x1::aggregator_v2::snapshot<u128>(&v18.cumulative_quote_volume), 
                total_quote_locked         : 0x1::aggregator_v2::snapshot<u128>(&v18.total_quote_locked), 
                total_value_locked         : 0x1::aggregator_v2::snapshot<u128>(&v18.total_value_locked), 
                market_cap                 : 0x1::aggregator_v2::snapshot<u128>(&v18.market_cap), 
                fully_diluted_value        : 0x1::aggregator_v2::snapshot<u128>(&v18.fully_diluted_value), 
                cumulative_integrator_fees : 0x1::aggregator_v2::snapshot<u128>(&v18.cumulative_integrator_fees), 
                cumulative_swaps           : 0x1::aggregator_v2::snapshot<u64>(&v18.cumulative_swaps), 
                cumulative_chat_messages   : 0x1::aggregator_v2::snapshot<u64>(&v18.cumulative_chat_messages),
            };
            0x1::event::emit<GlobalState>(v19);
        };
    }
    
    public fun tvl_per_lp_coin_growth_q64(arg0: TVLtoLPCoinRatio, arg1: TVLtoLPCoinRatio) : u128 {
        let v0 = arg1;
        let v1 = arg0;
        let v2 = v1.tvl;
        let v3 = v0.lp_coins;
        if (v2 == 0 || v3 == 0) {
            0
        } else {
            (((v1.lp_coins as u256) * (v0.tvl as u256) << 64) / (v2 as u256) * (v3 as u256)) as u128
        }
    }
    
    public fun unpack_cumulative_stats(arg0: CumulativeStats) : (u128, u128, u128, u128, u128, u64, u64) {
        let CumulativeStats {
            base_volume     : v0,
            quote_volume    : v1,
            integrator_fees : v2,
            pool_fees_base  : v3,
            pool_fees_quote : v4,
            n_swaps         : v5,
            n_chat_messages : v6,
        } = arg0;
        (v0, v1, v2, v3, v4, v5, v6)
    }
    
    public fun unpack_instantaneous_stats(arg0: InstantaneousStats) : (u64, u128, u128, u128) {
        let InstantaneousStats {
            total_quote_locked  : v0,
            total_value_locked  : v1,
            market_cap          : v2,
            fully_diluted_value : v3,
        } = arg0;
        (v0, v1, v2, v3)
    }
    
    public fun unpack_last_swap(arg0: LastSwap) : (bool, u128, u64, u64, u64, u64) {
        let LastSwap {
            is_sell                 : v0,
            avg_execution_price_q64 : v1,
            base_volume             : v2,
            quote_volume            : v3,
            nonce                   : v4,
            time                    : v5,
        } = arg0;
        (v0, v1, v2, v3, v4, v5)
    }
    
    public fun unpack_liquidity(arg0: Liquidity) : (u64, u64, u64, address, u64, u64, u64, bool, u64, u64) {
        let Liquidity {
            market_id                   : v0,
            time                        : v1,
            market_nonce                : v2,
            provider                    : v3,
            base_amount                 : v4,
            quote_amount                : v5,
            lp_coin_amount              : v6,
            liquidity_provided          : v7,
            base_donation_claim_amount  : v8,
            quote_donation_claim_amount : v9,
        } = arg0;
        (v0, v1, v2, v3, v4, v5, v6, v7, v8, v9)
    }
    
    public fun unpack_market_metadata(arg0: MarketMetadata) : (u64, address, vector<u8>) {
        let MarketMetadata {
            market_id      : v0,
            market_address : v1,
            emoji_bytes    : v2,
        } = arg0;
        (v0, v1, v2)
    }
    
    public fun unpack_market_view(arg0: MarketView) : (MarketMetadata, SequenceInfo, Reserves, Reserves, u128, bool, CumulativeStats, InstantaneousStats, LastSwap, vector<PeriodicStateTracker>, u64, u64, u64) {
        let MarketView {
            metadata                : v0,
            sequence_info           : v1,
            clamm_virtual_reserves  : v2,
            cpamm_real_reserves     : v3,
            lp_coin_supply          : v4,
            in_bonding_curve        : v5,
            cumulative_stats        : v6,
            instantaneous_stats     : v7,
            last_swap               : v8,
            periodic_state_trackers : v9,
            aptos_coin_balance      : v10,
            emojicoin_balance       : v11,
            emojicoin_lp_balance    : v12,
        } = arg0;
        (v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12)
    }
    
    public fun unpack_periodic_state_tracker(arg0: PeriodicStateTracker) : (u64, u64, u128, u128, u128, u128, u128, u128, u128, u128, u128, u64, u64, bool, bool, TVLtoLPCoinRatio, TVLtoLPCoinRatio) {
        let PeriodicStateTracker {
            start_time                 : v0,
            period                     : v1,
            open_price_q64             : v2,
            high_price_q64             : v3,
            low_price_q64              : v4,
            close_price_q64            : v5,
            volume_base                : v6,
            volume_quote               : v7,
            integrator_fees            : v8,
            pool_fees_base             : v9,
            pool_fees_quote            : v10,
            n_swaps                    : v11,
            n_chat_messages            : v12,
            starts_in_bonding_curve    : v13,
            ends_in_bonding_curve      : v14,
            tvl_to_lp_coin_ratio_start : v15,
            tvl_to_lp_coin_ratio_end   : v16,
        } = arg0;
        (v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16)
    }
    
    public fun unpack_registry_view(arg0: RegistryView) : (address, 0x1::aggregator_v2::AggregatorSnapshot<u64>, u64, u64, 0x1::aggregator_v2::AggregatorSnapshot<u128>, 0x1::aggregator_v2::AggregatorSnapshot<u128>, 0x1::aggregator_v2::AggregatorSnapshot<u128>, 0x1::aggregator_v2::AggregatorSnapshot<u128>, 0x1::aggregator_v2::AggregatorSnapshot<u128>, 0x1::aggregator_v2::AggregatorSnapshot<u128>, 0x1::aggregator_v2::AggregatorSnapshot<u64>, 0x1::aggregator_v2::AggregatorSnapshot<u64>) {
        let RegistryView {
            registry_address           : v0,
            nonce                      : v1,
            last_bump_time             : v2,
            n_markets                  : v3,
            cumulative_quote_volume    : v4,
            total_quote_locked         : v5,
            total_value_locked         : v6,
            market_cap                 : v7,
            fully_diluted_value        : v8,
            cumulative_integrator_fees : v9,
            cumulative_swaps           : v10,
            cumulative_chat_messages   : v11,
        } = arg0;
        (v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11)
    }
    
    public fun unpack_reserves(arg0: Reserves) : (u64, u64) {
        let Reserves {
            base  : v0,
            quote : v1,
        } = arg0;
        (v0, v1)
    }
    
    public fun unpack_sequence_info(arg0: SequenceInfo) : (u64, u64) {
        let SequenceInfo {
            nonce          : v0,
            last_bump_time : v1,
        } = arg0;
        (v0, v1)
    }
    
    public fun unpack_swap(arg0: Swap) : (u64, u64, u64, address, u64, bool, address, u8, u64, u64, u64, u128, u64, u64, bool, bool, u128, u128) {
        let Swap {
            market_id                                            : v0,
            time                                                 : v1,
            market_nonce                                         : v2,
            swapper                                              : v3,
            input_amount                                         : v4,
            is_sell                                              : v5,
            integrator                                           : v6,
            integrator_fee_rate_bps                              : v7,
            net_proceeds                                         : v8,
            base_volume                                          : v9,
            quote_volume                                         : v10,
            avg_execution_price_q64                              : v11,
            integrator_fee                                       : v12,
            pool_fee                                             : v13,
            starts_in_bonding_curve                              : v14,
            results_in_state_transition                          : v15,
            balance_as_fraction_of_circulating_supply_before_q64 : v16,
            balance_as_fraction_of_circulating_supply_after_q64  : v17,
        } = arg0;
        (v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17)
    }
    
    public fun unpack_tvl_to_lp_coin_ratio(arg0: TVLtoLPCoinRatio) : (u128, u128) {
        let TVLtoLPCoinRatio {
            tvl      : v0,
            lp_coins : v1,
        } = arg0;
        (v0, v1)
    }
    
    public fun verified_symbol_emoji_bytes(arg0: vector<vector<u8>>) : vector<u8> acquires Registry, RegistryAddress {
        let v0 = arg0;
        let v1 = b"";
        let v2 = 0;
        let v3 = false;
        loop {
            if (v3) {
                v2 = v2 + 1;
            } else {
                v3 = true;
            };
            if (v2 < 0x1::vector::length<vector<u8>>(&v0)) {
                let v4 = *0x1::vector::borrow<vector<u8>>(&v0, v2);
                assert!(0x1::table::contains<vector<u8>, u8>(&borrow_global<Registry>(borrow_global<RegistryAddress>(@0xface729284ae5729100b3a9ad7f7cc025ea09739cd6e7252aff0beb53619cafe).registry_address).coin_symbol_emojis, v4), 7);
                0x1::vector::append<u8>(&mut v1, v4);
                continue
            };
            break
        };
        assert!(!0x1::vector::is_empty<u8>(&v1), 15);
        assert!(0x1::vector::length<u8>(&v1) <= (10 as u64), 8);
        v1
    }
    
    // decompiled from Move bytecode v6
}

