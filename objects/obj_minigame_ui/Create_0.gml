/// obj_minigame_ui - Create Event

resources = [];
resource_groups = [];
resource_module_types = [];
resource_colors = [];

var groups = [
    "stone", "polyester", "tree", "cloth",
    "glass", "jewels", "mushrooms", "blood"
];

var counts = [1, 2, 3, 3, 3, 4, 4, 5];

var group_colors = [
    make_color_rgb(150,150,150),
    make_color_rgb(255,100,180),
    make_color_rgb(80,190,90),
    make_color_rgb(240,210,60),
    make_color_rgb(80,210,240),
    make_color_rgb(60,100,255),
    make_color_rgb(140,90,50),
    make_color_rgb(220,40,40)
];

var group_modules = [0,0,0,1,1,1,2,2];

for (var group_i = 0; group_i < 8; group_i++)
{
    for (var variant_i = 1;
         variant_i <= counts[group_i];
         variant_i++)
    {
        array_push(
            resources,
            groups[group_i] + "_" + string(variant_i)
        );

        array_push(resource_groups, groups[group_i]);
        array_push(resource_module_types, group_modules[group_i]);
        array_push(resource_colors, group_colors[group_i]);
    }
}


// =====================================================
// GRID STATE
// =====================================================

upper_modules = array_create(6, -1);

// Lower:
// -1 empty
// >=0 resource
// -2 FAIL
// -3 BACK
// -4 FIND

lower_cells = array_create(9, -1);

presets = craft_v2_presets();
item_names = craft_v2_item_names();

selected_preset = 0;
selected_item = 0;

resource_scroll = 0;
visible_rows = 6;

craft_result = 0;
craft_note = "Choose a preset and place ingredients.";


// =====================================================
// SELECTION
// =====================================================

selected_kind = 0;
selected_value = -1;


// =====================================================
// DRAG
// =====================================================

drag_active = false;
drag_started = false;

drag_kind = 0;
drag_value = -1;

drag_origin_panel = 0;
drag_origin_cell = -1;

drag_start_x = 0;
drag_start_y = 0;


// =====================================================
// UI LAYOUT
// =====================================================

ui = {
    upper_x: 650,
    upper_y: 260,
    upper_cell: 76,

    lower_x: 650,
    lower_y: 540,
    lower_cell: 76,

    pool_x: 40,
    pool_y: 205,
    pool_w: 330,

    resource_y: 270,
    resource_step: 50,

    preset_x: 405,
    preset_y: 245,
    preset_w: 160,
    preset_h: 40,

    module_x: 405,
    module_y: 560,
    module_step: 54,

    buff_y: 760,

    book_x: 1010,
    book_y: 205,
    book_w: 540,

    craft_x: 680,
    craft_y: 835,
    craft_w: 170,
    craft_h: 42
};


// =====================================================
// MATERIAL POOL
// =====================================================

get_pool_amount = function(_group)
{
    return variable_struct_get(global.material_pool, _group);
};

change_pool_amount = function(_group, _change)
{
    var amount = variable_struct_get(global.material_pool, _group);

    variable_struct_set(
        global.material_pool,
        _group,
        amount + _change
    );
};


// =====================================================
// CELL LOOKUP - WITH BOUNDS
// =====================================================

get_upper_cell = function(_mx, _my)
{
    if (
        _mx < ui.upper_x ||
        _mx >= ui.upper_x + ui.upper_cell * 3 ||
        _my < ui.upper_y ||
        _my >= ui.upper_y + ui.upper_cell * 2
    )
    {
        return -1;
    }

    var cell_col = floor((_mx - ui.upper_x) / ui.upper_cell);
    var cell_row = floor((_my - ui.upper_y) / ui.upper_cell);

    return cell_row * 3 + cell_col;
};

get_lower_cell = function(_mx, _my)
{
    if (
        _mx < ui.lower_x ||
        _mx >= ui.lower_x + ui.lower_cell * 3 ||
        _my < ui.lower_y ||
        _my >= ui.lower_y + ui.lower_cell * 3
    )
    {
        return -1;
    }

    var cell_col = floor((_mx - ui.lower_x) / ui.lower_cell);
    var cell_row = floor((_my - ui.lower_y) / ui.lower_cell);

    return cell_row * 3 + cell_col;
};


// =====================================================
// GEOMETRY
// =====================================================

get_lower_occupied = function()
{
    var occupied = array_create(9, -1);

    for (var cell_i = 0; cell_i < 9; cell_i++)
    {
        if (lower_cells[cell_i] != -1)
        {
            occupied[cell_i] = 1;
        }
    }

    return occupied;
};

get_shape = function()
{
    return craft_v2_buff_shape(get_lower_occupied());
};


// =====================================================
// BUFFS
// =====================================================

get_buff_rate = function(_buff_type)
{
    var code = -2 - _buff_type;
    var found = false;

    for (var cell_i = 0; cell_i < 9; cell_i++)
    {
        if (lower_cells[cell_i] == code)
        {
            found = true;
            break;
        }
    }

    if (!found) return 0;

    var base = 0;

    switch (_buff_type)
    {
        case 0: base = 10; break;
        case 1: base = 30; break;
        case 2: base = 2; break;
    }

    if (get_shape() != -1)
    {
        base *= 1.25;
    }

    return base;
};


// =====================================================
// PRESETS
// =====================================================

apply_preset = function(_index)
{
    selected_preset = _index;

    var pattern = presets[_index].pattern;

    for (var cell_i = 0; cell_i < 6; cell_i++)
    {
        upper_modules[cell_i] = pattern[cell_i];
    }

    craft_result = 0;
    craft_note = "PRESET: " + presets[_index].name;
};


// =====================================================
// DOMINANT MATERIAL
// =====================================================

get_dominant_group = function()
{
    var group_names = [
        "stone", "polyester", "tree", "cloth",
        "glass", "jewels", "mushrooms", "blood"
    ];

    var amounts = array_create(8, 0);

    for (var cell_i = 0; cell_i < 9; cell_i++)
    {
        var resource_index = lower_cells[cell_i];

        if (resource_index < 0) continue;

        var group = resource_groups[resource_index];

        for (var group_i = 0; group_i < 8; group_i++)
        {
            if (group_names[group_i] == group)
            {
                amounts[group_i]++;
                break;
            }
        }
    }

    var best_index = -1;
    var best_amount = 0;

    for (var check_i = 0; check_i < 8; check_i++)
    {
        if (amounts[check_i] > best_amount)
        {
            best_amount = amounts[check_i];
            best_index = check_i;
        }
    }

    if (best_index == -1) return "";

    return group_names[best_index];
};


// =====================================================
// CURRENT RESULT
// =====================================================

get_current_item = function()
{
    var preset_index = craft_v2_match_preset(upper_modules);

    if (preset_index == -1) return -1;

    var material_count = 0;

    for (var cell_i = 0; cell_i < 9; cell_i++)
    {
        if (lower_cells[cell_i] >= 0)
        {
            material_count++;
        }
    }

    if (material_count == 0) return -1;

    return craft_v2_result_id(
        preset_index,
        get_dominant_group()
    );
};


// =====================================================
// FAILURE
// =====================================================

get_failure = function()
{
    if (get_current_item() == -1) return 100;

    var material_count = 0;

    for (var cell_i = 0; cell_i < 9; cell_i++)
    {
        if (lower_cells[cell_i] >= 0)
        {
            material_count++;
        }
    }

    var base = 40;

    switch (material_count)
    {
        case 1: base = 1; break;
        case 2: base = 10; break;
        case 3: base = 20; break;
        case 4: base = 30; break;
        default: base = 40; break;
    }

    base -= array_length(global.discovered_items) * 2;

    var market_bonus = 0;

    if (script_exists(asset_get_index("scr_events")))
    {
        market_bonus = market_event_get_failure_bonus();
    }

    var connection_count = craft_v2_connections(
        upper_modules,
        get_lower_occupied()
    );

    base -= connection_count;
    base += market_bonus;
    base -= get_buff_rate(0);

    return clamp(base, 0, 100);
};


// =====================================================
// INITIAL PRESET
// =====================================================

apply_preset(0);
// =====================================================
// UNIFIED RECIPES
// =====================================================

recipe_catalog = craft_v2_recipes();


// =====================================================
// CURRENT RECIPE
// =====================================================

get_current_item = function()
{
    var category = craft_v2_match_preset(upper_modules);

    return craft_v2_find_recipe(
        category,
        lower_cells,
        resource_groups
    );
};


// =====================================================
// LOAD RECIPE FROM BOOK
// =====================================================

load_book_recipe = function()
{
    var recipe = recipe_catalog[selected_item];

    // Load upper shape.
    apply_preset(recipe.category);

    // Preserve existing buffs where possible.
    var saved_buffs = [];

    for (var cell_i = 0; cell_i < 9; cell_i++)
    {
        if (lower_cells[cell_i] <= -2)
        {
            array_push(saved_buffs, lower_cells[cell_i]);
        }
    }

    lower_cells = array_create(9, -1);

    var ingredient_total = 0;

    for (var ing_i = 0; ing_i < array_length(recipe.ingredients); ing_i++)
    {
        ingredient_total += recipe.ingredients[ing_i].amount;
    }

    // Use 8 resource slots for the ratio where possible.
    var desired_slots = 8;
    var used_slots = 0;

    for (var ing_i = 0; ing_i < array_length(recipe.ingredients); ing_i++)
    {
        var ingredient = recipe.ingredients[ing_i];

        var slots = round(
            ingredient.amount / ingredient_total * desired_slots
        );

        slots = max(1, slots);

        if (ing_i == array_length(recipe.ingredients) - 1)
        {
            slots = max(1, desired_slots - used_slots);
        }

        var resource_index = -1;

        for (var resource_i = 0; resource_i < array_length(resources); resource_i++)
        {
            if (resource_groups[resource_i] == ingredient.group)
            {
                resource_index = resource_i;
                break;
            }
        }

        if (resource_index == -1) continue;

        for (var slot_i = 0; slot_i < slots; slot_i++)
        {
            if (used_slots >= 9) break;

            lower_cells[used_slots] = resource_index;
            used_slots++;
        }
    }

    // Place saved buffs in remaining free slots.
    var buff_cursor = 8;

    for (var buff_i = 0; buff_i < array_length(saved_buffs); buff_i++)
    {
        while (buff_cursor >= 0 && lower_cells[buff_cursor] != -1)
        {
            buff_cursor--;
        }

        if (buff_cursor < 0) break;

        lower_cells[buff_cursor] = saved_buffs[buff_i];
        buff_cursor--;
    }

    craft_result = 0;
    craft_note = "LOADED: " + recipe.name;
};