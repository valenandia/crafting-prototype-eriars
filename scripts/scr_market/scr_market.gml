/// scr_market


// =====================================================
// GENERATE MARKET
// =====================================================

function market_generate_prices()
{
    global.market_prices = {};

    for (
        var w = 0;
        w < array_length(global.market_worlds);
        w++
    )
    {
        var world =
            global.market_worlds[w];

        var world_prices = {};

        for (
            var m = 0;
            m < array_length(global.market_materials);
            m++
        )
        {
            var tag =
                global.market_materials[m];

            var multiplier =
                market_generate_multiplier(
                    world,
                    tag
                );

            variable_struct_set(
                world_prices,
                tag,
                multiplier
            );
        }

        variable_struct_set(
            global.market_prices,
            world,
            world_prices
        );
    }
}


// =====================================================
// WORLD BIAS
// =====================================================

function market_generate_multiplier(_world, _tag)
{
    var min_value = 0.75;
    var max_value = 1.25;


    // =================================================
    // FANTASY
    // =================================================

    if (_world == "FANTASY")
    {
        switch (_tag)
        {
            case "jewels":
            case "mushrooms":
            case "blood":

                min_value = 1.10;
                max_value = 1.80;

            break;


            case "polyester":

                min_value = 0.60;
                max_value = 1.00;

            break;
        }
    }


    // =================================================
    // CYBERPUNK
    // =================================================

    else if (_world == "CYBERPUNK")
    {
        switch (_tag)
        {
            case "polyester":
            case "glass":
            case "jewels":

                min_value = 1.10;
                max_value = 1.80;

            break;


            case "tree":
            case "mushrooms":

                min_value = 0.60;
                max_value = 1.00;

            break;
        }
    }


    // =================================================
    // STEAMPUNK
    // =================================================

    else if (_world == "STEAMPUNK")
    {
        switch (_tag)
        {
            case "stone":
            case "tree":
            case "cloth":
            case "glass":

                min_value = 1.05;
                max_value = 1.60;

            break;


            case "blood":

                min_value = 0.60;
                max_value = 1.00;

            break;
        }
    }


    // =================================================
    // RANDOM PRICE
    // =================================================

    var value =
        random_range(
            min_value,
            max_value
        );

    return round(value * 100) / 100;
}


// =====================================================
// GET MULTIPLIER
// =====================================================

function market_get_multiplier(_world, _tag)
{
    var world_prices =
        variable_struct_get(
            global.market_prices,
            _world
        );

    return variable_struct_get(
        world_prices,
        _tag
    );
}

// =====================================================
// ITEM MARKET MULTIPLIER
// =====================================================

function market_get_item_multiplier(_recipe, _world)
{
    var total = 0;
    var total_percentage = 0;

    for (
        var i = 0;
        i < array_length(_recipe.materials);
        i++
    )
    {
        var material =
            _recipe.materials[i];

        var multiplier =
            market_get_multiplier(
                _world,
                material.tag
            );

        total +=
            multiplier
            * material.percentage;

        total_percentage +=
            material.percentage;
    }

    if (total_percentage <= 0)
    {
        return 1;
    }

    return total / total_percentage;
}