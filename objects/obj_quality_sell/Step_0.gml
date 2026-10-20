/// obj_quality_sell - Step Event
/// CRAFTING V3.3

if (global.ui_screen != 0)
{
    exit;
}

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if (!mouse_check_button_pressed(mb_left))
{
    exit;
}

var recipes = craft_v3_recipes();

// =====================================================
// ITEM NAVIGATION
// =====================================================

if (
    mx >= panel_x + 20 &&
    mx <= panel_x + 120 &&
    my >= panel_y + 65 &&
    my <= panel_y + 100
)
{
    selected_item =
        (selected_item + array_length(recipes) - 1)
        mod array_length(recipes);

    selected_stack = 0;
    exit;
}

if (
    mx >= panel_x + 420 &&
    mx <= panel_x + 520 &&
    my >= panel_y + 65 &&
    my <= panel_y + 100
)
{
    selected_item =
        (selected_item + 1)
        mod array_length(recipes);

    selected_stack = 0;
    exit;
}

// =====================================================
// STACK SELECTION
// =====================================================

craft_v3_sync_inventory(selected_item);

var stacks = craft_v3_get_quality_stacks(selected_item);

for (var i = 0; i < min(4, array_length(stacks)); i++)
{
    var row_y = panel_y + 125 + i * 35;

    if (
        mx >= panel_x + 20 &&
        mx <= panel_x + 520 &&
        my >= row_y &&
        my <= row_y + 30
    )
    {
        selected_stack = i;
        exit;
    }
}

// =====================================================
// SELL
// =====================================================

if (
    mx >= panel_x + 20 &&
    mx <= panel_x + 520 &&
    my >= panel_y + 275 &&
    my <= panel_y + 310
)
{
    if (array_length(stacks) == 0)
    {
        sell_message = "NO ITEMS AVAILABLE";
        exit;
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

    if (earned > 0)
    {
        sell_message =
            "SOLD " +
            recipes[selected_item].name +
            " Q" + string(quality) +
            " / +" + string(earned) + " CR";

        var remaining = craft_v3_get_quality_stacks(
            selected_item
        );

        selected_stack = clamp(
            selected_stack,
            0,
            max(0, array_length(remaining) - 1)
        );
    }
    else
    {
        sell_message = "SELL FAILED";
    }
}