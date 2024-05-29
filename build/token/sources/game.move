module token::game{
    use sui::coin::{Coin, Self, TreasuryCap};
    use sui::tx_context::{TxContext, Self};
    use sui::object::{UID};
    use sui::transfer;
    use sui::url::{Self, Url};
    use 0x0::wtoken::{WTOKEN, mint};
    use sui::balance::{Self, Balance};

    public struct GamePool has key {
        id: UID,
        balance: Balance<WTOKEN>
    }

    const ENOBALANCE: u64 = 0;

    fun init(ctx: &mut TxContext) {
        let game_pool = GamePool {
            id: object::new(ctx),
            balance: balance::zero<WTOKEN>()
        };

        transfer::share_object(game_pool);
    }

    public fun mint_and_stake(
        game_pool: &mut GamePool, 
        treasury_cap: &mut TreasuryCap<WTOKEN>, 
        amount: u64, 
        ctx: &mut TxContext
    ) {
        let coin = mint(treasury_cap, amount, ctx);
        coin::put(&mut game_pool.balance, coin);
    }

    public entry fun cal_reward(amount: u64, game_pool: &mut GamePool, ctx: &mut TxContext) {
        //thong tin nguoi choi
        //dieu kien
        //
        let sender = tx_context::sender(ctx);
        let balance  = balance::value<WTOKEN>(&game_pool.balance);
        assert!(balance>=amount, ENOBALANCE);
        let reward = coin::take<WTOKEN>(&mut game_pool.balance, amount, ctx);
        transfer::public_transfer(reward, sender);
    }
}