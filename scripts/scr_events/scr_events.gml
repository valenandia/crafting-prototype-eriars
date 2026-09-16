/// scr_events.gml


// =====================================================
// TRY TO START MARKET EVENT
// =====================================================

function market_event_try_start()
{
    // Если уже идёт событие,
    // новое событие не запускаем
    if (global.market_event_active)
    {
        return;
    }


    // =================================================
    // EVENT CHANCE
    //
    // На каждом обновлении рынка:
    // 45% шанс события
    // =================================================

    var event_roll =
        random(100);


    if (event_roll >= 45)
    {
        global.market_event_active = false;

        global.market_event_name =
            "NO EVENT";

        global.market_event_failure_bonus =
            0;

        global.market_event_timer =
            0;

        return;
    }


    // =================================================
    // SELECT EVENT
    // =================================================

    var roll =
        random(100);


    // =================================================
    // 1. SUPPLY DELAYS
    //
    // Частый
    // Очень долгий
    // Слабый
    //
    // +3%
    // 120 seconds
    // =================================================

    if (roll < 40)
    {
        global.market_event_name =
            "SUPPLY DELAYS";

        global.market_event_failure_bonus =
            3;

        global.market_event_timer =
            120 * room_speed;
    }


    // =================================================
    // 2. MATERIAL SHORTAGE
    //
    // Средний
    //
    // +7%
    // 60 seconds
    // =================================================

    else if (roll < 70)
    {
        global.market_event_name =
            "MATERIAL SHORTAGE";

        global.market_event_failure_bonus =
            7;

        global.market_event_timer =
            60 * room_speed;
    }


    // =================================================
    // 3. MARKET PANIC
    //
    // Короткий
    // Сильный
    //
    // +15%
    // 30 seconds
    // =================================================

    else if (roll < 90)
    {
        global.market_event_name =
            "MARKET PANIC";

        global.market_event_failure_bonus =
            15;

        global.market_event_timer =
            30 * room_speed;
    }


    // =================================================
    // 4. WORLD DISRUPTION
    //
    // Очень редкий
    // Очень короткий
    // Очень мощный
    //
    // +35%
    // 10 seconds
    // =================================================

    else
    {
        global.market_event_name =
            "WORLD DISRUPTION";

        global.market_event_failure_bonus =
            35;

        global.market_event_timer =
            10 * room_speed;
    }


    global.market_event_active =
        true;
}


// =====================================================
// UPDATE MARKET EVENT
// =====================================================

function market_event_update()
{
    if (!global.market_event_active)
    {
        return;
    }


    global.market_event_timer--;


    // =================================================
    // EVENT FINISHED
    // =================================================

    if (global.market_event_timer <= 0)
    {
        global.market_event_active =
            false;

        global.market_event_name =
            "NO EVENT";

        global.market_event_failure_bonus =
            0;

        global.market_event_timer =
            0;
    }
}


// =====================================================
// GET EVENT FAILURE BONUS
// =====================================================

function market_event_get_failure_bonus()
{
    if (!variable_global_exists("market_event_active"))
    {
        return 0;
    }


    if (!global.market_event_active)
    {
        return 0;
    }


    return global.market_event_failure_bonus;
}