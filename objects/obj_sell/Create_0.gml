/// obj_sell - Create Event
/// UNIFIED ITEM SELL SYSTEM V3.3

// =====================================================
// PANEL SETTINGS
// =====================================================

panel_x = 1010;
panel_y = 470;
panel_w = 550;
panel_h = 370;

// =====================================================
// SELECTION
// =====================================================

selected_item = 0;
selected_stack = 0;

stack_scroll = 0;
visible_stacks = 5;

// =====================================================
// UI
// =====================================================

sell_message = "SELECT AN ITEM AND QUALITY STACK";

sell_result_timer = 0;

// =====================================================
// DATA
// =====================================================

recipes = craft_v3_recipes();

craft_v3_ensure_inventory();

if (!variable_global_exists("credits"))
{
    global.credits = 0;
}

// =====================================================
// HELPERS
// =====================================================

get_selected_stacks = function()
{
    craft_v3_sync_inventory(selected_item);

    return craft_v3_get_quality_stacks(selected_item);
};

get_selected_owned = function()
{
    var item_id = recipes[selected_item].id;

    if (!variable_struct_exists(global.item_inventory, item_id))
    {
        return 0;
    }

    return variable_struct_get(global.item_inventory, item_id);
};

sell_selected = function()
{
    var stacks = get_selected_stacks();

    if (array_length(stacks) <= 0)
    {
        sell_message = "NO ITEMS TO SELL";
        return false;
    }

    selected_stack = clamp(
        selected_stack,
        0,
        array_length(stacks) - 1
    );

    var quality = stacks[selected_stack].quality;

    var earned = craft_v3_sell_item(
        selected_item,
        quality
    );

    if (earned <= 0)
    {
        sell_message = "SELL FAILED";
        return false;
    }

    sell_message =
        "SOLD " + recipes[selected_item].name +
        " | Q" + string(quality) +
        " | +" + string(earned) + " CR";

    var remaining = get_selected_stacks();

    if (selected_stack >= array_length(remaining))
    {
        selected_stack = max(
            0,
            array_length(remaining) - 1
        );
    }

    if (stack_scroll > selected_stack)
    {
        stack_scroll = selected_stack;
    }

    sell_result_timer = room_speed * 3;

    return true;
};