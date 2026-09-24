/// obj_market - Step Event

market_timer--;


if (market_timer <= 0)
{
    market_generate_prices();

    market_event_try_start();

    market_timer =
        market_update_seconds * room_speed;
}


market_event_update();