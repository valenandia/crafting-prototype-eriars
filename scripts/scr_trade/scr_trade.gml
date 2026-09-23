/// scr_trade.gml


// =====================================================
// BASE BUY PRICE
// Цена за 100 единиц ресурса
// =====================================================

function trade_get_base_price(_tag)
{
    switch (_tag)
    {
        case "stone":     return 50;
        case "polyester": return 70;
        case "tree":      return 80;
        case "cloth":     return 100;
        case "glass":     return 120;
        case "jewels":    return 200;

        // Редкие ресурсы специально дорогие,
        // чтобы Quests оставались полезными
        case "mushrooms": return 300;
        case "blood":     return 450;
    }

    return 100;
}


// =====================================================
// DISPLAY NAME
// =====================================================

function trade_get_resource_name(_tag)
{
    switch (_tag)
    {
        case "stone":     return "Stone";
        case "polyester": return "Polyester";
        case "tree":      return "Tree";
        case "cloth":     return "Cloth";
        case "glass":     return "Glass";
        case "jewels":    return "Jewels";
        case "mushrooms": return "Mushrooms";
        case "blood":     return "Blood";
    }

    return _tag;
}


// =====================================================
// CHEAPEST WORLD
// =====================================================

function trade_get_cheapest_world(_tag)
{
    var fantasy =
        market_get_multiplier(
            "FANTASY",
            _tag
        );

    var cyber =
        market_get_multiplier(
            "CYBERPUNK",
            _tag
        );

    var steam =
        market_get_multiplier(
            "STEAMPUNK",
            _tag
        );


    var cheapest_world = "FANTASY";
    var cheapest_mult = fantasy;


    if (cyber < cheapest_mult)
    {
        cheapest_mult = cyber;
        cheapest_world = "CYBERPUNK";
    }


    if (steam < cheapest_mult)
    {
        cheapest_mult = steam;
        cheapest_world = "STEAMPUNK";
    }


    return cheapest_world;
}


// =====================================================
// CHEAPEST MULTIPLIER
// =====================================================

function trade_get_cheapest_multiplier(_tag)
{
    var fantasy =
        market_get_multiplier(
            "FANTASY",
            _tag
        );

    var cyber =
        market_get_multiplier(
            "CYBERPUNK",
            _tag
        );

    var steam =
        market_get_multiplier(
            "STEAMPUNK",
            _tag
        );


    return min(
        fantasy,
        min(cyber, steam)
    );
}


// =====================================================
// FINAL BUY PRICE
// =====================================================

function trade_get_buy_price(_tag)
{
    var base_price =
        trade_get_base_price(_tag);

    var mult =
        trade_get_cheapest_multiplier(_tag);


    return max(
        1,
        round(base_price * mult)
    );
}
// =====================================================
// BEST SELL WORLD
//
// Ищет мир с самым высоким multiplier
// =====================================================

function trade_get_best_sell_world(_tag)
{
    var best_world =
        global.market_worlds[0];

    var best_multiplier =
        market_get_multiplier(
            best_world,
            _tag
        );


    for (
        var i = 1;
        i < array_length(global.market_worlds);
        i++
    )
    {
        var world =
            global.market_worlds[i];

        var multiplier =
            market_get_multiplier(
                world,
                _tag
            );


        if (multiplier > best_multiplier)
        {
            best_multiplier =
                multiplier;

            best_world =
                world;
        }
    }


    return best_world;
}


// =====================================================
// SELL PRICE
//
// Цена продажи 100 units в самом дорогом мире
// =====================================================

function trade_get_sell_price(_tag)
{
    // Самый выгодный мир для продажи
    var world =
        trade_get_best_sell_world(_tag);


    // Та же базовая стоимость ресурса,
    // которая используется системой Trade
    var base_price =
        trade_get_base_price(_tag);


    // Рыночный multiplier этого мира
    var multiplier =
        market_get_multiplier(
            world,
            _tag
        );


    // Финальная цена продажи 100 units
    var price =
        round(
            base_price
            * multiplier
        );


    return max(
        1,
        price
    );
}