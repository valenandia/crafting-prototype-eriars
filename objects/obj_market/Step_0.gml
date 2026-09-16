/// obj_market - Step Event


// =====================================================
// MARKET TIMER
// =====================================================

market_timer--;


if (market_timer <= 0)
{
    // Новые цены
    market_generate_prices();


    // Попытка запустить событие
    market_event_try_start();


    // Reset market timer
    market_timer =
        market_update_seconds * room_speed;
}


// =====================================================
// ACTIVE EVENT TIMER
// =====================================================

market_event_update();