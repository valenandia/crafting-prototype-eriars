/// scr_events.gml


// =====================================================
// TRY TO START MARKET EVENT
// =====================================================

function market_event_try_start()
{
    // Если событие уже активно —
    // новое не запускаем
    if (global.market_event_active)
    {
        return;
    }


    // =================================================
    // EVENT CHANCE
    //
    // Каждые 30 секунд при обновлении рынка
    // 45% шанс получить событие
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
    // START RANDOM EVENT
    //
    // Выбор конкретного события теперь находится
    // в market_event_start_random()
    //
    // 0-3 = negative
    // 4-7 = positive
    // =================================================

    market_event_start_random();
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