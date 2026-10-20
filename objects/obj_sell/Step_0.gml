/// obj_sell - Step Event
/// UNIFIED ITEM SELL SYSTEM V3.3

if (global.ui_screen != 0)
{
    exit;
}

// =====================================================
// TIMER
// =====================================================

if (sell_result_timer > 0)
{
    sell_result_timer--;
}

// =====================================================
// MOUSE
// =====================================================

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var click = mouse_check_button_pressed(mb_left);

var recipes_count = array_length(recipes);

// =====================================================
// SCROLL QUALITY STACKS
// =====================================================

var stacks = get_selected_stacks();

if (
    mx >= panel_x &&
    mx <= panel_x + panel_w &&
    my >= panel_y + 125 &&
    my <= panel_y + 285
)
{
    var wheel = 0;

    if (mouse_wheel_up())
    {
        wheel = -1;
    }

    if (mouse_wheel_down())
    {
        wheel = 1;
    }

    if (wheel != 0)
    {
        stack_scroll = clamp(
            stack_scroll + wheel,
            0,
            max(0, array_length(stacks) - visible_stacks)
        );
    }
}

// =====================================================
// CLICK
// =====================================================

if (!click)
{
    exit;
}

// =====================================================
// PREVIOUS ITEM
// =====================================================

if (
    mx >= panel_x + 20 &&
    mx <= panel_x + 125 &&
    my >= panel_y + 75 &&
    my <= panel_y + 110
)
{
    selected_item =
        (selected_item + recipes_count - 1)
        mod recipes_count;

    selected_stack = 0;
    stack_scroll = 0;

    sell_message = "SELECT A QUALITY STACK";

    exit;
}

// =====================================================
// NEXT ITEM
// =====================================================

if (
    mx >= panel_x + 425 &&
    mx <= panel_x + 530 &&
    my >= panel_y + 75 &&
    my <= panel_y + 110
)
{
    selected_item =
        (selected_item + 1)
        mod recipes_count;

    selected_stack = 0;
    stack_scroll = 0;

    sell_message = "SELECT A QUALITY STACK";

    exit;
}

// =====================================================
// SELECT QUALITY STACK
// =====================================================

for (var row_i = 0; row_i < visible_stacks; row_i++)
{
    var stack_index = stack_scroll + row_i;

    if (stack_index >= array_length(stacks))
    {
        break;
    }

    var row_y = panel_y + 130 + row_i * 31;

    if (
        mx >= panel_x + 20 &&
        mx <= panel_x + 530 &&
        my >= row_y &&
        my <= row_y + 27
    )
    {
        selected_stack = stack_index;
        exit;
    }
}

// =====================================================
// SELL BUTTON
// =====================================================

if (
    mx >= panel_x + 20 &&
    mx <= panel_x + 530 &&
    my >= panel_y + 300 &&
    my <= panel_y + 340
)
{
    sell_selected();
    exit;
}