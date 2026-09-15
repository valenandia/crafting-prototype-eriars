/// obj_market - Step Event


// =====================================================
// MARKET TIMER
// =====================================================

market_timer--;

if (market_timer <= 0)
{
    market_generate_prices();

    market_timer =
        market_update_seconds * room_speed;
}