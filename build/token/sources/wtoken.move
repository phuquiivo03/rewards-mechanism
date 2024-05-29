
/// Module: token
module token::wtoken {
    use sui::coin::{Coin, Self, TreasuryCap};
    use sui::tx_context::{TxContext, Self};
    use sui::object::{UID};
    use sui::transfer;
    use sui::url::{Self, Url};

    public struct WTOKEN has drop {}

    fun init(otw: WTOKEN, ctx: &mut TxContext) {
        let url = url::new_unsafe_from_bytes(b"https://c0.klipartz.com/pngpicture/526/429/gratis-png-dogecoin-cryptocurrency-litecoin-blockcoin-blockchain-lakshmi-gold-coin-thumbnail.png");
        let (treasury_cap, metadata) = coin::create_currency<WTOKEN>(
            otw,
            6,                // decimals
            b"WC",           // symbol
            b"WTOKEN",       // name
            b"Coin for wecatle game", // description
            option::some<Url>(url),   // icon url
            ctx
        );

        transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
        transfer::public_freeze_object(metadata);
    }

    public fun mint(treasury_cap: &mut TreasuryCap<WTOKEN>, amount: u64, ctx: &mut TxContext): Coin<WTOKEN> {
        // let coin = coin::mint(treasury_cap, amount, ctx);
        // transfer::public_transfer(coin, receipent);
        coin::mint(treasury_cap, amount, ctx)
    }
}


