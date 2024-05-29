module token::mission{
    use sui::coin::{Coin, Self, TreasuryCap};
    use sui::tx_context::{TxContext, Self};
    use sui::object::{UID};
    use sui::transfer;
    use sui::url::{Self, Url};
    use 0x0::wtoken::{WTOKEN, mint};
    use sui::balance::{Self, Balance};
    use std::string::{String};
    use sui::dynamic_object_field as dof;
    use sui::package;
    use sui::display;


    //dynamic object: missions (shared)
    //
    const INVALID_ID: u64 = 0;
    public struct GameMission has key {
        id: UID
    }

    public struct Work has key, store {
        id: UID,
        reward: u64,
        done: bool,
        process: u16,

    }

    public struct MyNFT has key, store  {
        id: UID,
        name: String,
        description: String,
        image_url: String,
        project_url: String,
        creator: String,
        link: String
    }

    public struct MISSION  has drop { }

    fun init(otw: MISSION, ctx: &mut TxContext) {
        let keys = vector[
            b"name".to_string(),
            b"description".to_string(),
            b"image_url".to_string(),
            b"project_url".to_string(),
            b"creator".to_string(),
            b"link".to_string()
        ];

        let values = vector[
            b"{name}".to_string(),
            b"{description}".to_string(),
            b"{image_url}".to_string(),
            b"{project_url}".to_string(),
            b"{creator}".to_string(),
            b"{link}".to_string(),
        ];

        let publisher = package::claim(otw, ctx);
        let mut display = display::new_with_fields<MyNFT>(
            &publisher, keys, values, ctx
        );
        transfer::share_object(GameMission{
            id: object::new(ctx)
        });
        display::update_version(&mut display);
        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::public_transfer(display, tx_context::sender(ctx));
    }

    public fun mint_work(
        _game_mission: &mut GameMission, 
        _work_id: String, 
        _reward: u64, 
        ctx: &mut TxContext) {
        let is_existed = dof::exists_<String>(&_game_mission.id, _work_id);
        assert!(!is_existed, INVALID_ID);
        let new_work = Work {
            id: object::new(ctx),
            reward: _reward,
            done: false,
            process: 0
        };
        dof::add(&mut _game_mission.id, _work_id, new_work); 
    }

    public fun mint_nft(
        _name: String,
        _description: String,
        _image_url: String,
        _project_url: String,
        _creator: String,
        _link: String,
        ctx: &mut TxContext) {
        transfer::public_transfer(
            MyNFT {
                id: object::new(ctx),
                name: _name,
                description: _description,
                image_url: _image_url,
                project_url: _project_url,
                creator: _creator,
                link: _link
            }, 
            tx_context::sender(ctx)
        );
    }
}