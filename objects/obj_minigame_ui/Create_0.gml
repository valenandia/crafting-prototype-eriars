
/// obj_minigame_ui - CREATE
/// CRAFTING V4.5

recipes = craft_v3_recipes();
groups = craft_v3_groups();
variant_counts = craft_v3_variant_counts();
group_colors = craft_v3_group_colors();
categories = craft_v4_categories();

selected_category = -1;
selected_group = 0;
selected_variant = 1;
selected_recipe = 0;
selected_preset = -1;
selected_module = 1;

book_open = true;
ingredients_open = false;
analyzer_open = true;
module_guide_open = true;

// Unified 3x3 grid:
// 0 BASE, 1 C, 2 M, 3 Y,
// 4 FAIL, 5 BACK, 6 FIND.
module_cells = array_create(9, 0);

vessel_stacks = [];
vessel_capacity = 100;
add_amount = 10;

craft_result = 0;
craft_note = "Choose a shape or build one yourself.";
last_quality = 0;
last_failure = 0;
last_recipe = -1;
result_until = 0;

drag_active = false;
drag_group = -1;
drag_variant = 1;
drag_start_x = 0;
drag_start_y = 0;

// All drawing and mouse interaction uses original
// coordinates; the whole crafting UI is shifted up.
ui_shift_y = -70;

ui = {
    pool_x:24,
    pool_y:185,
    pool_w:340,
    pool_h:625,

    preset_x:390,
    preset_y:225,
    preset_h:54,
    preset_step:61,

    upper_x:718,
    upper_y:268,
    upper_cell:62,

    analyzer_x:390,
    analyzer_y:480,
    analyzer_w:585,
    analyzer_h:118,

    vessel_x:390,
    vessel_y:640,
    vessel_w:585,
    vessel_h:165,

    random_x:390,
    random_y:812,
    random_w:165,
    random_h:48,

    craft_x:735,
    craft_y:812,
    craft_w:240,
    craft_h:48,

    book_x:1000,
    book_y:290,
    book_w:575
};

// GLOBALS

if (!variable_global_exists("ui_screen"))
    global.ui_screen = 1;

if (!variable_global_exists("material_pool"))
{
    global.material_pool = {
        stone:1000,
        polyester:800,
        tree:600,
        cloth:500,
        glass:450,
        jewels:300,
        mushrooms:150,
        blood:100
    };
}

if (!variable_global_exists("discovered_items"))
    global.discovered_items = [];

if (!variable_global_exists("craft_attempts"))
    global.craft_attempts = 0;

if (!variable_global_exists("craft_log"))
    global.craft_log = [];

craft_v3_ensure_inventory();

// RESOURCE POOL

get_pool = function(_group)
{
    if (!variable_struct_exists(global.material_pool, _group))
        return 0;

    return variable_struct_get(global.material_pool, _group);
};

change_pool = function(_group, _delta)
{
    variable_struct_set(
        global.material_pool,
        _group,
        max(0, get_pool(_group) + _delta)
    );
};

// VESSEL

get_vessel_total = function()
{
    return craft_v4_total(vessel_stacks);
};

find_stack = function(_group, _variant)
{
    for (var i = 0; i < array_length(vessel_stacks); i++)
    {
        if (vessel_stacks[i].group == _group
        && vessel_stacks[i].variant == _variant)
            return i;
    }

    return -1;
};

add_to_vessel = function(_group, _variant, _amount)
{
    if (_amount <= 0)
        return false;

    if (get_vessel_total() + _amount > vessel_capacity)
    {
        craft_note = "VESSEL FULL!";
        return false;
    }

    var idx = find_stack(_group, _variant);

    if (idx < 0)
    {
        array_push(vessel_stacks, {
            group:_group,
            variant:_variant,
            amount:_amount
        });
    }
    else
    {
        vessel_stacks[idx].amount += _amount;
    }

    craft_result = 0;
    craft_note = "MATERIAL ADDED";
    return true;
};

remove_from_vessel = function(_group, _variant, _amount)
{
    var idx = find_stack(_group, _variant);
    if (idx < 0) return false;

    vessel_stacks[idx].amount -= _amount;

    if (vessel_stacks[idx].amount <= 0)
        array_delete(vessel_stacks, idx, 1);

    craft_result = 0;
    craft_note = "MATERIAL REMOVED";
    return true;
};

clear_vessel = function()
{
    vessel_stacks = [];
    craft_result = 0;
    craft_note = "VESSEL CLEARED";
};

// UNIFIED MODULE SYSTEM

load_category_shape = function(_category)
{
    if (_category < 0
    || _category >= array_length(categories))
        return false;

    module_cells = array_create(9, 0);

    var pattern = craft_v4_category_pattern(_category);

    // Choose which row stays available for
    // Base modules or buffs.
    var omit_row = irandom(2);
    var src_row = 0;

    for (var row = 0; row < 3; row++)
    {
        if (row == omit_row)
            continue;

        for (var col = 0; col < 3; col++)
        {
            var v = pattern[src_row * 3 + col];

            module_cells[row * 3 + col] =
                v < 0 ? 0 : v + 1;
        }

        src_row++;
    }

    selected_category = _category;
    selected_preset = _category;
    craft_result = 0;

    craft_note = categories[_category]
        + " RANDOM SHAPE LOADED";

    return true;
};

update_detected_category = function()
{
    selected_category =
        craft_v45_pattern_category(module_cells);

    selected_preset = selected_category;
};

// ANALYZER

get_analysis = function()
{
    var category =
        craft_v45_pattern_category(module_cells);

    if (category < 0)
    {
        return {
            status:"UNSTABLE",
            recipe_index:-1,
            capacity:craft_v4_total(vessel_stacks),
            quality:0,
            tier:"UNKNOWN",
            completeness:0,
            fidelity:0,
            variants:0,
            structure:0,
            perfect:false,
            is_discovered:false,
            message:"INVALID MODULE COMBINATION"
        };
    }

    return craft_v4_analyze(category, vessel_stacks);
};

get_current_recipe = function()
{
    var category =
        craft_v45_pattern_category(module_cells);

    if (category < 0)
        return -1;

    return craft_v4_match(category, vessel_stacks);
};

get_quality = function()
{
    var ri = get_current_recipe();

    if (ri < 0)
        return 0;

    return craft_v4_quality(
        ri,
        vessel_stacks
    ).quality;
};

// BUFFS

get_buff_shape = function()
{
    var mask = array_create(9, -1);

    for (var i = 0; i < 9; i++)
    {
        if (module_cells[i] >= 4)
            mask[i] = module_cells[i] - 4;
    }

    return craft_v3_buff_shape(mask);
};

get_buff_rate = function(_type)
{
    var count = 0;

    for (var i = 0; i < 9; i++)
    {
        if (module_cells[i] == _type + 4)
            count++;
    }

    if (count == 0)
        return 0;

    var rate = 0;

    switch (_type)
    {
        case 0: rate = 10; break;
        case 1: rate = 30; break;
        case 2: rate = 2; break;
    }

    if (get_buff_shape() != -1)
        rate *= 1.25;

    return rate;
};

// FAILURE CHANCE

get_failure = function()
{
    var ri = get_current_recipe();

    if (ri < 0)
        return 100;

    var ingredient_count =
        array_length(recipes[ri].ingredients);

    var failure = 10 + ingredient_count * 6;

    failure -= array_length(global.discovered_items) * 2;
    failure -= max(0, (get_quality() - 50) * 0.15);
    failure -= get_buff_rate(0);

    var event_script =
        asset_get_index("market_event_get_failure_bonus");

    if (event_script != -1)
        failure += script_execute(event_script);

    return clamp(failure, 0, 100);
};

// LOAD DISCOVERED RECIPE

load_recipe = function(_ri, _perfect)
{
    if (_ri < 0 || _ri >= array_length(recipes))
        return false;

    if (!craft_v3_is_discovered(_ri))
    {
        craft_note = "DISCOVER FIRST!";
        return false;
    }

    selected_recipe = _ri;

    var category = craft_v4_category_of(_ri);
    load_category_shape(category);

    vessel_stacks = [];

    if (_perfect)
    {
        vessel_stacks = craft_v4_blueprint(_ri);
    }
    else
    {
        var recipe = recipes[_ri];

        for (var i = 0;
             i < array_length(recipe.ingredients);
             i++)
        {
            var ing = recipe.ingredients[i];

            array_push(vessel_stacks, {
                group:ing.group,
                variant:1,
                amount:ing.amount
            });
        }
    }

    craft_result = 0;

    craft_note = _perfect
        ? "PERFECT BLUEPRINT LOADED"
        : "BASIC RECIPE LOADED";

    return true;
};

// TRUE RANDOM MATERIAL MIX

randomize_craft = function()
{
    vessel_stacks = [];

    var order = [];

    for (var i = 0; i < array_length(groups); i++)
        array_push(order, i);

    for (var i = array_length(order) - 1; i > 0; i--)
    {
        var j = irandom(i);
        var temp = order[i];
        order[i] = order[j];
        order[j] = temp;
    }

    var count = irandom_range(1, 8);
    var remaining = 100;

    for (var i = 0; i < count; i++)
    {
        var gi = order[i];
        var amount = remaining;
        var groups_left = count - i - 1;

        if (groups_left > 0)
        {
            var max_tens =
                (remaining - groups_left * 10) div 10;

            amount = irandom_range(1, max_tens) * 10;
        }

        remaining -= amount;

        var max_parts = min(
            3,
            variant_counts[gi],
            amount div 10
        );

        var parts = irandom_range(1, max_parts);
        var available_variants = [];

        for (var v = 1; v <= variant_counts[gi]; v++)
            array_push(available_variants, v);

        for (var v = array_length(available_variants) - 1;
             v > 0; v--)
        {
            var j = irandom(v);
            var temp = available_variants[v];
            available_variants[v] = available_variants[j];
            available_variants[j] = temp;
        }

        var part_remaining = amount;

        for (var p = 0; p < parts; p++)
        {
            var left = parts - p - 1;
            var part_amount = part_remaining;

            if (left > 0)
            {
                var max_tens =
                    (part_remaining - left * 10) div 10;

                part_amount =
                    irandom_range(1, max_tens) * 10;
            }

            array_push(vessel_stacks, {
                group:groups[gi],
                variant:available_variants[p],
                amount:part_amount
            });

            part_remaining -= part_amount;
        }
    }

    craft_result = 0;
    craft_note = "TRUE RANDOM MIX GENERATED";
};

// CRAFT

craft_current = function()
{
    var analysis = get_analysis();
    var total = get_vessel_total();

    craft_result = 0;

    if (total <= 0)
    {
        craft_result = 4;
        craft_note = "EMPTY VESSEL!";
        result_until = current_time + 3500;
        return false;
    }

    var required = array_create(
        array_length(groups), 0
    );

    for (var i = 0;
         i < array_length(vessel_stacks);
         i++)
    {
        var stack = vessel_stacks[i];
        var gi = craft_v3_group_index(stack.group);

        if (gi >= 0)
            required[gi] += stack.amount;
    }

    for (var i = 0; i < array_length(groups); i++)
    {
        if (get_pool(groups[i]) < required[i])
        {
            craft_result = 5;
            craft_note = "NOT ENOUGH MATERIALS!";
            result_until = current_time + 3500;
            return false;
        }
    }

    var ri = analysis.recipe_index;
    var quality = analysis.quality;

    var failure = analysis.status == "CRAFTABLE"
        ? get_failure()
        : 100;

    for (var i = 0; i < array_length(groups); i++)
    {
        if (required[i] > 0)
            change_pool(groups[i], -required[i]);
    }

    global.craft_attempts++;

    last_recipe = ri;
    last_quality = quality;
    last_failure = failure;

    var success = false;

    if (analysis.status != "CRAFTABLE")
    {
        craft_result = 3;
        craft_note = "UNKNOWN MIX! MATERIALS LOST.";
    }
    else
    {
        success = random(100) >= failure;

        if (success)
        {
            craft_result = 1;

            craft_v3_add_item(ri, quality);
            craft_v3_discover(ri);

            craft_note = analysis.tier
                + " ITEM CREATED! Q"
                + string(quality);
        }
        else
        {
            craft_result = 2;
            craft_note = "CRAFT FAILED!";
        }
    }

    // BACK BUFF

    if (random(100) < get_buff_rate(1))
    {
        var available = [];

        for (var i = 0; i < array_length(groups); i++)
        {
            if (required[i] > 0)
                array_push(available, i);
        }

        if (array_length(available) > 0)
        {
            var gi = available[
                irandom(array_length(available) - 1)
            ];

            var refund = min(10, required[gi]);

            change_pool(groups[gi], refund);

            craft_note += " / BACK +"
                + string(refund);
        }
    }

    // FIND BUFF

    if (random(100) < get_buff_rate(2))
    {
        var unknown = [];

        for (var i = 0; i < array_length(recipes); i++)
        {
            if (!craft_v3_is_discovered(i))
                array_push(unknown, i);
        }

        if (array_length(unknown) > 0)
        {
            var found = unknown[
                irandom(array_length(unknown) - 1)
            ];

            craft_v3_discover(found);
            craft_note += " / DISCOVERY!";
        }
    }

    result_until = current_time + 3500;
    return success;
};


/// ==========================================
/// CRAFTING V4.8 - RANDOM PRESETS V2
/// Add at the very END of Create Event
/// ==========================================

random_preset_buffs = false;

load_category_shape = function(_category)
{
    if (_category < 0
    || _category >= array_length(categories))
        return false;

    var generated = craft_v48_generate(
        module_cells,
        _category,
        random_preset_buffs
    );

    if (!generated.success)
    {
        craft_note = "PRESET GENERATION FAILED";
        return false;
    }

    module_cells = generated.cells;

    selected_category = _category;
    selected_preset = _category;

    craft_result = 0;

    craft_note =
        categories[_category]
        + " / PRESERVED "
        + string(generated.preserved)
        + " / MOVED "
        + string(generated.moved)
        + " / DROPPED "
        + string(generated.dropped);

    return true;
};


/// ==========================================
/// CRAFTING V4.9 - BUFF BALANCING
/// Add to the END of Create Event
/// ==========================================            

// Unified buff rate calculation.
// Multiple modules of one type do not stack.

get_buff_rate = function(_type)
{
    return craft_v49_buff_rate(
        module_cells,
        _type
    );
};

// Full buff diagnostics.

get_buff_report = function()
{
    return craft_v49_buff_report(module_cells);
};
 