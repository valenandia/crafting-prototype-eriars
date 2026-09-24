/// scr_market


// =====================================================
// GENERATE MARKET
// =====================================================

function market_generate_prices()
{
    global.market_prices = {};

    for (
        var world_i = 0;
        world_i < array_length(global.market_worlds);
        world_i++
    )
    {
        var world =
            global.market_worlds[world_i];

        var world_prices = {};


        for (
            var material_i = 0;
            material_i < array_length(global.market_materials);
            material_i++
        )
        {
            var material_group =
                global.market_materials[material_i];


            var multiplier =
                market_generate_multiplier(
                    world,
                    material_group
                );


            variable_struct_set(
                world_prices,
                material_group,
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
            {
                min_value = 1.10;
                max_value = 1.80;
            }
            break;


            case "polyester":
            {
                min_value = 0.60;
                max_value = 1.00;
            }
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
            {
                min_value = 1.10;
                max_value = 1.80;
            }
            break;


            case "tree":
            case "mushrooms":
            {
                min_value = 0.60;
                max_value = 1.00;
            }
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
            {
                min_value = 1.05;
                max_value = 1.60;
            }
            break;


            case "blood":
            {
                min_value = 0.60;
                max_value = 1.00;
            }
            break;
        }
    }


    // =================================================
    // RANDOM PRICE
    // =================================================

    var generated_value =
        random_range(
            min_value,
            max_value
        );


    return
        round(generated_value * 100)
        / 100;
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


    if (is_undefined(world_prices))
    {
        return 1;
    }


    if (!variable_struct_exists(
        world_prices,
        _tag
    ))
    {
        return 1;
    }


    return variable_struct_get(
        world_prices,
        _tag
    );
}


// =====================================================
// ITEM MARKET MULTIPLIER
// =====================================================
//
// IMPORTANT:
//
// Recipe material:
//
// {
//     tag: "tree_3",
//     group: "tree",
//     percentage: 40
// }
//
// MARKET uses GROUP.
// CRAFTING uses TAG.
//
// =====================================================

function market_get_item_multiplier(_recipe, _world)
{
    var total =
        0;

    var total_percentage =
        0;


    for (
        var ingredient_i = 0;
        ingredient_i < array_length(_recipe.materials);
        ingredient_i++
    )
    {
        var ingredient =
            _recipe.materials[ingredient_i];


        // ---------------------------------------------
        // MARKET RESOURCE GROUP
        // ---------------------------------------------

        var market_group =
            ingredient.group;


        // ---------------------------------------------
        // SAFETY FALLBACK
        //
        // Если вдруг какой-то старый рецепт ещё
        // не имеет group, определяем group по tag.
        // ---------------------------------------------

        if (is_undefined(market_group))
        {
            var ingredient_tag =
                ingredient.tag;


            if (string_pos("stone_", ingredient_tag) == 1)
            {
                market_group = "stone";
            }
            else if (string_pos("polyester_", ingredient_tag) == 1)
            {
                market_group = "polyester";
            }
            else if (string_pos("tree_", ingredient_tag) == 1)
            {
                market_group = "tree";
            }
            else if (string_pos("cloth_", ingredient_tag) == 1)
            {
                market_group = "cloth";
            }
            else if (string_pos("glass_", ingredient_tag) == 1)
            {
                market_group = "glass";
            }
            else if (string_pos("jewels_", ingredient_tag) == 1)
            {
                market_group = "jewels";
            }
            else if (string_pos("mushrooms_", ingredient_tag) == 1)
            {
                market_group = "mushrooms";
            }
            else if (string_pos("blood_", ingredient_tag) == 1)
            {
                market_group = "blood";
            }
            else
            {
                market_group =
                    ingredient_tag;
            }
        }


        // ---------------------------------------------
        // WORLD MULTIPLIER
        // ---------------------------------------------

        var ingredient_multiplier =
            market_get_multiplier(
                _world,
                market_group
            );


        // ---------------------------------------------
        // WEIGHT
        // ---------------------------------------------

        var ingredient_percentage =
            ingredient.percentage;


        if (is_undefined(ingredient_percentage))
        {
            ingredient_percentage =
                0;
        }


        total +=
            ingredient_multiplier
            * ingredient_percentage;


        total_percentage +=
            ingredient_percentage;
    }


    // =================================================
    // SAFETY
    // =================================================

    if (total_percentage <= 0)
    {
        return 1;
    }


    // =================================================
    // FINAL ITEM MULTIPLIER
    // =================================================

    var final_multiplier =
        total
        / total_percentage;


    return
        round(final_multiplier * 100)
        / 100;
}


// =====================================================
// MARKET EVENTS
//
// NEGATIVE:
//
// Supply Delays       +3%   120 sec
// Material Shortage   +7%    60 sec
// Market Panic       +15%    30 sec
// World Disruption   +35%    10 sec
//
// POSITIVE:
//
// Stable Supply       -3%   120 sec
// Material Boom       -7%    60 sec
// Golden Market      -15%    30 sec
// Perfect Conditions -30%    10 sec
//
// =====================================================


// =====================================================
// START RANDOM EVENT
// =====================================================

function market_event_start_random()
{
    var event_roll =
        irandom_range(
            0,
            7
        );


    // =================================================
    // EVENTS
    // =================================================

    switch (event_roll)
    {
        // ---------------------------------------------
        // NEGATIVE
        // ---------------------------------------------

        case 0:
        {
            global.market_event_name =
                "SUPPLY DELAYS";

            global.market_event_failure_bonus =
                3;

            global.market_event_duration =
                120;
        }
        break;


        case 1:
        {
            global.market_event_name =
                "MATERIAL SHORTAGE";

            global.market_event_failure_bonus =
                7;

            global.market_event_duration =
                60;
        }
        break;


        case 2:
        {
            global.market_event_name =
                "MARKET PANIC";

            global.market_event_failure_bonus =
                15;

            global.market_event_duration =
                30;
        }
        break;


        case 3:
        {
            global.market_event_name =
                "WORLD DISRUPTION";

            global.market_event_failure_bonus =
                35;

            global.market_event_duration =
                10;
        }
        break;


        // ---------------------------------------------
        // POSITIVE
        // ---------------------------------------------

        case 4:
        {
            global.market_event_name =
                "STABLE SUPPLY";

            global.market_event_failure_bonus =
                -3;

            global.market_event_duration =
                120;
        }
        break;


        case 5:
        {
            global.market_event_name =
                "MATERIAL BOOM";

            global.market_event_failure_bonus =
                -7;

            global.market_event_duration =
                60;
        }
        break;


        case 6:
        {
            global.market_event_name =
                "GOLDEN MARKET";

            global.market_event_failure_bonus =
                -15;

            global.market_event_duration =
                30;
        }
        break;


        case 7:
        {
            global.market_event_name =
                "PERFECT CONDITIONS";

            global.market_event_failure_bonus =
                -30;

            global.market_event_duration =
                10;
        }
        break;
    }


    // =================================================
    // ACTIVATE EVENT
    // =================================================

    global.market_event_active =
        true;


    global.market_event_timer =
        global.market_event_duration
        * room_speed;
}