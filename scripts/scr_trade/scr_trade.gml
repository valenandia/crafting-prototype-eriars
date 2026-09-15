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