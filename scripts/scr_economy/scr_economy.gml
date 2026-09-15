/// scr_economy

function get_item_sell_price(_recipe)
{
    var tag_count =
        array_length(_recipe.materials);

    // Базовая цена
    var price = 50;

    // Каждый дополнительный материал повышает цену
    price += (tag_count - 1) * 50;

    return price;
}
function get_item_world_sell_price(_recipe, _world)
{
    var base_price =
        get_item_sell_price(_recipe);

    var market_multiplier =
        market_get_item_multiplier(
            _recipe,
            _world
        );

    return round(
        base_price
        * market_multiplier
    );
}