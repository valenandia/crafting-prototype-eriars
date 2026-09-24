/// obj_minigame_ui - Create Event


// =====================================================
// UI LAYOUT
// =====================================================
//
// GUI = 1600x900
//
// LEFT   = resources
// CENTER = crafting grid
// RIGHT  = recipe book
//
// =====================================================

ui = {
    // -------------------------------------------------
    // MODULE BAR
    // -------------------------------------------------

    module_x: 145,
    module_y: 140,
    module_gap: 115,
    module_size: 70,


    // -------------------------------------------------
    // RESOURCES
    // -------------------------------------------------

    pool_x1: 60,
    pool_y1: 285,
    pool_x2: 400,
    pool_y2: 815,

    resource_x1: 80,
    resource_x2: 380,
    resource_y: 345,

    resource_gap: 52,
    resource_height: 42,
    visible_rows: 6,

    pool_nav_y1: 665,
    pool_nav_y2: 705,


    // -------------------------------------------------
    // GRID
    // -------------------------------------------------

    grid_x: 592,
    grid_y: 390,
    cell_size: 105,


    // -------------------------------------------------
    // BUTTONS
    // -------------------------------------------------

    reset_x1: 80,
    reset_x2: 215,

    random_x1: 225,
    random_x2: 380,

    craft_x1: 650,
    craft_x2: 850,

    button_y1: 750,
    button_y2: 800,


    // -------------------------------------------------
    // RECIPE BOOK
    // -------------------------------------------------

    book_x1: 1080,
    book_x2: 1530,

    book_y1: 285,
    book_y2: 650,

    book_header_y2: 330,



    // -------------------------------------------------
    // TOP TABS
    // -------------------------------------------------

    craft_tab_x1: 800,
    craft_tab_x2: 940,

    economy_tab_x1: 650,
    economy_tab_x2: 790,

    tab_y1: 10,
    tab_y2: 42
};


// =====================================================
// RESOURCE DEFINITIONS
// =====================================================

resources = [];

resource_modules = [];
resource_tags = [];
resource_colors = [];
resource_variants = [];


// =====================================================
// RESOURCE GROUPS
// =====================================================

var groups = [
    "stone",
    "polyester",
    "tree",
    "cloth",
    "glass",
    "jewels",
    "mushrooms",
    "blood"
];


// =====================================================
// NUMBER OF VARIANTS
// =====================================================

var variant_counts = [
    1, // stone
    2, // polyester
    3, // tree
    3, // cloth
    3, // glass
    4, // jewels
    4, // mushrooms
    5  // blood
];


// =====================================================
// MODULE COMPATIBILITY
// =====================================================
//
// 0 = MODUL_C
// 1 = MODUL_M
// 2 = MODUL_Y
//
// BUFF:
// 3 = FAIL
// 4 = BACK
// 5 = FIND
//
// =====================================================

var module_types = [
    0, // stone
    0, // polyester
    0, // tree

    1, // cloth
    1, // glass
    1, // jewels

    2, // mushrooms
    2  // blood
];


// =====================================================
// RESOURCE COLORS
// =====================================================

var group_colors = [
    make_color_rgb(150, 150, 150), // stone
    make_color_rgb(255, 100, 180), // polyester
    make_color_rgb(80, 190, 90),   // tree
    make_color_rgb(240, 210, 60),  // cloth
    make_color_rgb(80, 210, 240),  // glass
    make_color_rgb(60, 100, 255),  // jewels
    make_color_rgb(140, 90, 50),   // mushrooms
    make_color_rgb(220, 40, 40)    // blood
];


// =====================================================
// CREATE RESOURCE VARIANTS
// =====================================================

for (var group_i = 0;
     group_i < array_length(groups);
     group_i++)
{
    for (var variant_i = 1;
         variant_i <= variant_counts[group_i];
         variant_i++)
    {
        array_push(
            resources,
            groups[group_i] + "_" + string(variant_i)
        );

        array_push(
            resource_modules,
            module_types[group_i]
        );

        array_push(
            resource_tags,
            groups[group_i]
        );

        array_push(
            resource_colors,
            group_colors[group_i]
        );

        array_push(
            resource_variants,
            variant_i
        );
    }
}


// =====================================================
// STATE
// =====================================================

resource_scroll = 0;

recipes = global.recipes;

book_index = 0;
book_open = true;


// =====================================================
// GRID
// =====================================================

grid_x = ui.grid_x;
grid_y = ui.grid_y;
cell_size = ui.cell_size;

grid_modules = array_create(9, -1);
grid_items = array_create(9, -1);


// =====================================================
// DRAG
//
// 0 = nothing
// 1 = module
// 2 = resource
// =====================================================

drag_kind = 0;
drag_value = -1;
drag_from = -1;


// =====================================================
// CRAFT RESULT
//
// 0 = neutral
// 1 = success
// 2 = fail
// =====================================================

craft_result = 0;
craft_note = "";


// =====================================================
// GET RESOURCE COUNT
// =====================================================

get_resource_count = function(_resource_index)
{
    if (_resource_index < 0)
    {
        return 0;
    }

    if (_resource_index >= array_length(resource_tags))
    {
        return 0;
    }


    var resource_group =
        resource_tags[_resource_index];


    switch (resource_group)
    {
        case "stone":
            return global.material_pool.stone;

        case "polyester":
            return global.material_pool.polyester;

        case "tree":
            return global.material_pool.tree;

        case "cloth":
            return global.material_pool.cloth;

        case "glass":
            return global.material_pool.glass;

        case "jewels":
            return global.material_pool.jewels;

        case "mushrooms":
            return global.material_pool.mushrooms;

        case "blood":
            return global.material_pool.blood;
    }


    return 0;
};


// =====================================================
// SPEND RESOURCE
// =====================================================

spend_resource = function(_resource_index, _amount)
{
    if (_resource_index < 0)
    {
        return false;
    }

    if (_resource_index >= array_length(resource_tags))
    {
        return false;
    }


    var resource_group =
        resource_tags[_resource_index];


    switch (resource_group)
    {
        case "stone":
        {
            if (global.material_pool.stone < _amount)
            {
                return false;
            }

            global.material_pool.stone -= _amount;

            return true;
        }


        case "polyester":
        {
            if (global.material_pool.polyester < _amount)
            {
                return false;
            }

            global.material_pool.polyester -= _amount;

            return true;
        }


        case "tree":
        {
            if (global.material_pool.tree < _amount)
            {
                return false;
            }

            global.material_pool.tree -= _amount;

            return true;
        }


        case "cloth":
        {
            if (global.material_pool.cloth < _amount)
            {
                return false;
            }

            global.material_pool.cloth -= _amount;

            return true;
        }


        case "glass":
        {
            if (global.material_pool.glass < _amount)
            {
                return false;
            }

            global.material_pool.glass -= _amount;

            return true;
        }


        case "jewels":
        {
            if (global.material_pool.jewels < _amount)
            {
                return false;
            }

            global.material_pool.jewels -= _amount;

            return true;
        }


        case "mushrooms":
        {
            if (global.material_pool.mushrooms < _amount)
            {
                return false;
            }

            global.material_pool.mushrooms -= _amount;

            return true;
        }


        case "blood":
        {
            if (global.material_pool.blood < _amount)
            {
                return false;
            }

            global.material_pool.blood -= _amount;

            return true;
        }
    }


    return false;
};


// =====================================================
// RETURN RESOURCE
// =====================================================

return_resource = function(_resource_index, _amount)
{
    if (_resource_index < 0)
    {
        return;
    }

    if (_resource_index >= array_length(resource_tags))
    {
        return;
    }


    var resource_group =
        resource_tags[_resource_index];


    switch (resource_group)
    {
        case "stone":
            global.material_pool.stone += _amount;
        break;


        case "polyester":
            global.material_pool.polyester += _amount;
        break;


        case "tree":
            global.material_pool.tree += _amount;
        break;


        case "cloth":
            global.material_pool.cloth += _amount;
        break;


        case "glass":
            global.material_pool.glass += _amount;
        break;


        case "jewels":
            global.material_pool.jewels += _amount;
        break;


        case "mushrooms":
            global.material_pool.mushrooms += _amount;
        break;


        case "blood":
            global.material_pool.blood += _amount;
        break;
    }
};


// =====================================================
// IS RECIPE DISCOVERED
// =====================================================

is_recipe_discovered = function(_recipe_index)
{
    if (_recipe_index < 0)
    {
        return false;
    }

    if (_recipe_index >= array_length(recipes))
    {
        return false;
    }


    var recipe_id =
        recipes[_recipe_index].id;


    for (var discovered_i = 0;
         discovered_i < array_length(global.discovered_items);
         discovered_i++)
    {
        if (
            global.discovered_items[discovered_i]
            ==
            recipe_id
        )
        {
            return true;
        }
    }


    return false;
};


// =====================================================
// DISCOVERED COUNT
// =====================================================

get_discovered_count = function()
{
    return array_length(
        global.discovered_items
    );
};


// =====================================================
// DISCOVER RECIPE
// =====================================================

discover_recipe = function(_recipe_index)
{
    if (_recipe_index < 0)
    {
        return false;
    }

    if (_recipe_index >= array_length(recipes))
    {
        return false;
    }


    if (is_recipe_discovered(_recipe_index))
    {
        return false;
    }


    array_push(
        global.discovered_items,
        recipes[_recipe_index].id
    );


    return true;
};


// =====================================================
// ADD CRAFTED ITEM
// =====================================================

add_crafted_item = function(_recipe_index, _amount)
{
    if (_recipe_index < 0)
    {
        return;
    }

    if (_recipe_index >= array_length(recipes))
    {
        return;
    }


    var item_id =
        recipes[_recipe_index].id;


    switch (item_id)
    {
        case "item_01":
            global.item_inventory.item_01 += _amount;
        break;

        case "item_02":
            global.item_inventory.item_02 += _amount;
        break;

        case "item_03":
            global.item_inventory.item_03 += _amount;
        break;

        case "item_04":
            global.item_inventory.item_04 += _amount;
        break;

        case "item_05":
            global.item_inventory.item_05 += _amount;
        break;

        case "item_06":
            global.item_inventory.item_06 += _amount;
        break;

        case "item_07":
            global.item_inventory.item_07 += _amount;
        break;

        case "item_08":
            global.item_inventory.item_08 += _amount;
        break;

        case "item_09":
            global.item_inventory.item_09 += _amount;
        break;

        case "item_10":
            global.item_inventory.item_10 += _amount;
        break;

        case "item_11":
            global.item_inventory.item_11 += _amount;
        break;

        case "item_12":
            global.item_inventory.item_12 += _amount;
        break;

        case "item_13":
            global.item_inventory.item_13 += _amount;
        break;

        case "item_14":
            global.item_inventory.item_14 += _amount;
        break;

        case "item_15":
            global.item_inventory.item_15 += _amount;
        break;

        case "item_16":
            global.item_inventory.item_16 += _amount;
        break;

        case "item_17":
            global.item_inventory.item_17 += _amount;
        break;

        case "item_18":
            global.item_inventory.item_18 += _amount;
        break;

        case "item_19":
            global.item_inventory.item_19 += _amount;
        break;

        case "item_20":
            global.item_inventory.item_20 += _amount;
        break;
    }
};


// =====================================================
// BUFF PATTERN
// =====================================================
//
// Активная клетка:
//
// RESOURCE
// или
// BUFF MODULE
//
// Пустой обычный модуль не считается частью фигуры.
//
// =====================================================

get_buff = function()
{
    var patterns = [
        [1, 4, 6, 7, 8],
        [1, 3, 4, 5, 7],
        [0, 2, 4, 6, 8],
        [0, 4, 8],
        [2, 4, 6],
        [0, 2, 4, 7],
        [4, 8],
        [0, 1]
    ];


    for (var pattern_i = 0;
         pattern_i < array_length(patterns);
         pattern_i++)
    {
        var same_pattern =
            true;


        for (var pattern_cell = 0;
             pattern_cell < 9;
             pattern_cell++)
        {
            var required_cell =
                false;


            for (var pattern_part = 0;
                 pattern_part < array_length(patterns[pattern_i]);
                 pattern_part++)
            {
                if (
                    patterns[pattern_i][pattern_part]
                    ==
                    pattern_cell
                )
                {
                    required_cell =
                        true;

                    break;
                }
            }


            var active_cell =
                false;


            if (
                grid_modules[pattern_cell]
                >= 3
            )
            {
                active_cell =
                    true;
            }


            if (
                grid_items[pattern_cell]
                != -1
            )
            {
                active_cell =
                    true;
            }


            if (
                active_cell
                !=
                required_cell
            )
            {
                same_pattern =
                    false;

                break;
            }
        }


        if (same_pattern)
        {
            return pattern_i;
        }
    }


    return -1;
};


// =====================================================
// FIND GRID RECIPE
// =====================================================

find_grid_recipe = function()
{
    var filled_count =
        0;


    // =================================================
    // VALIDATE GRID
    // =================================================

    for (var grid_check_cell = 0;
         grid_check_cell < 9;
         grid_check_cell++)
    {
        var check_module =
            grid_modules[
                grid_check_cell
            ];


        var check_item =
            grid_items[
                grid_check_cell
            ];


        // ---------------------------------------------
        // BUFF
        // ---------------------------------------------

        if (check_module >= 3)
        {
            // Buff cannot contain resource.

            if (check_item != -1)
            {
                return -1;
            }


            continue;
        }


        // ---------------------------------------------
        // EMPTY NORMAL MODULE
        // ---------------------------------------------

        if (
            check_module != -1
            &&
            check_item == -1
        )
        {
            return -1;
        }


        // ---------------------------------------------
        // RESOURCE
        // ---------------------------------------------

        if (check_item != -1)
        {
            if (check_module == -1)
            {
                return -1;
            }


            if (check_item < 0)
            {
                return -1;
            }


            if (
                check_item >=
                array_length(resources)
            )
            {
                return -1;
            }


            if (
                check_module
                !=
                resource_modules[
                    check_item
                ]
            )
            {
                return -1;
            }


            filled_count++;
        }
    }


    if (filled_count <= 0)
    {
        return -1;
    }


    // =================================================
    // FIND RECIPE
    // =================================================

    for (var recipe_search_i = 0;
         recipe_search_i < array_length(recipes);
         recipe_search_i++)
    {
        var recipe_ingredients =
            recipes[
                recipe_search_i
            ].materials;


        if (
            array_length(
                recipe_ingredients
            )
            !=
            filled_count
        )
        {
            continue;
        }


        var recipe_matches =
            true;


        // ---------------------------------------------
        // One grid cell cannot match twice.
        // ---------------------------------------------

        var used_cells =
            array_create(
                9,
                false
            );


        for (var ingredient_i = 0;
             ingredient_i < array_length(recipe_ingredients);
             ingredient_i++)
        {
            var ingredient_found =
                false;


            var wanted_tag =
                recipe_ingredients[
                    ingredient_i
                ].tag;


            for (var recipe_grid_cell = 0;
                 recipe_grid_cell < 9;
                 recipe_grid_cell++)
            {
                if (
                    used_cells[
                        recipe_grid_cell
                    ]
                )
                {
                    continue;
                }


                var recipe_resource =
                    grid_items[
                        recipe_grid_cell
                    ];


                if (recipe_resource == -1)
                {
                    continue;
                }


                if (
                    resources[
                        recipe_resource
                    ]
                    ==
                    wanted_tag
                )
                {
                    used_cells[
                        recipe_grid_cell
                    ] = true;


                    ingredient_found =
                        true;


                    break;
                }
            }


            if (!ingredient_found)
            {
                recipe_matches =
                    false;

                break;
            }
        }


        if (recipe_matches)
        {
            return recipe_search_i;
        }
    }


    return -1;
};


// =====================================================
// BUFF RATE
// =====================================================
//
// type 0 = FAIL
//          -10 percentage points
//
// type 1 = BACK
//          30% chance
//
// type 2 = FIND
//          2% chance
//
// Correct shape = x1.25
//
// =====================================================

get_buff_rate = function(_type)
{
    var base_rate =
        0;


    switch (_type)
    {
        case 0:
            base_rate = 10;
        break;


        case 1:
            base_rate = 30;
        break;


        case 2:
            base_rate = 2;
        break;


        default:
            return 0;
    }


    var required_module =
        _type + 3;


    var buff_exists =
        false;


    for (var buff_cell = 0;
         buff_cell < 9;
         buff_cell++)
    {
        if (
            grid_modules[
                buff_cell
            ]
            ==
            required_module
        )
        {
            buff_exists =
                true;

            break;
        }
    }


    if (!buff_exists)
    {
        return 0;
    }


    // Correct shape gives +25% buff strength.

    if (get_buff() != -1)
    {
        return base_rate * 1.25;
    }


    return base_rate;
};


// =====================================================
// MARKET FAILURE BONUS
// =====================================================
//
// Читаем ТО ЖЕ глобальное событие, которое использует
// экран ECONOMY.
//
// Примеры:
//
// MARKET PANIC
// +15 percentage points
//
// STABLE SUPPLY
// -3 percentage points
//
// Если event отсутствует / закончился = 0.
//
// =====================================================

get_market_failure_bonus = function()
{
    // -------------------------------------------------
    // Market system not initialized yet
    // -------------------------------------------------

    if (
        !variable_global_exists(
            "market_event_active"
        )
    )
    {
        return 0;
    }


    // -------------------------------------------------
    // No active event
    // -------------------------------------------------

    if (!global.market_event_active)
    {
        return 0;
    }


    // -------------------------------------------------
    // Safety
    // -------------------------------------------------

    if (
        !variable_global_exists(
            "market_event_failure_bonus"
        )
    )
    {
        return 0;
    }


    return global.market_event_failure_bonus;
};


// =====================================================
// MARKET EVENT NAME
// =====================================================
//
// Используется Draw GUI.
// Возвращает пустую строку, если события нет.
//
// =====================================================

get_market_event_name = function()
{
    if (
        !variable_global_exists(
            "market_event_active"
        )
    )
    {
        return "";
    }


    if (!global.market_event_active)
    {
        return "";
    }


    if (
        !variable_global_exists(
            "market_event_name"
        )
    )
    {
        return "";
    }


    return global.market_event_name;
};


// =====================================================
// MARKET EVENT TIME LEFT
// =====================================================
//
// Возвращает секунды.
//
// =====================================================

get_market_event_seconds = function()
{
    if (
        !variable_global_exists(
            "market_event_active"
        )
    )
    {
        return 0;
    }


    if (!global.market_event_active)
    {
        return 0;
    }


    if (
        !variable_global_exists(
            "market_event_timer"
        )
    )
    {
        return 0;
    }


    var seconds_left =
        ceil(
            global.market_event_timer
            /
            room_speed
        );


    if (seconds_left < 0)
    {
        seconds_left = 0;
    }


    return seconds_left;
};


// =====================================================
// FINAL FAILURE
// =====================================================
//
// FINAL =
//
// BASE
// - KNOWLEDGE
// + MARKET EVENT
// - FAIL BUFF
//
// Example:
//
// 5 ingredients
// Base                40
// 2 discovered        -4
// MARKET PANIC       +15
// FAIL buff          -10
//
// Final:
// 40 - 4 + 15 - 10 = 41%
//
// Clamp:
// 0% minimum
// 100% maximum
//
// =====================================================

get_craft_failure = function(_recipe_index)
{
    if (_recipe_index < 0)
    {
        return -1;
    }


    if (
        _recipe_index >=
        array_length(recipes)
    )
    {
        return -1;
    }


    var ingredient_count =
        array_length(
            recipes[
                _recipe_index
            ].materials
        );


    var known_count =
        get_discovered_count();


    // -------------------------------------------------
    // BASE - KNOWLEDGE
    // -------------------------------------------------

    var final_failure =
        get_final_failure_chance(
            ingredient_count,
            known_count
        );


    // -------------------------------------------------
    // MARKET EVENT
    // -------------------------------------------------

    final_failure +=
        get_market_failure_bonus();


    // -------------------------------------------------
    // FAIL BUFF
    // -------------------------------------------------

    final_failure -=
        get_buff_rate(0);


    // -------------------------------------------------
    // LIMIT 0..100
    // -------------------------------------------------

    if (final_failure < 0)
    {
        final_failure = 0;
    }


    if (final_failure > 100)
    {
        final_failure = 100;
    }


    return final_failure;
};