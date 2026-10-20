/// obj_sell - Draw GUI Event
/// UNIFIED ITEM SELL SYSTEM V3.3

if (global.ui_screen != 0)
{
    exit;
}

draw_set_font(fnt_ui_small);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);

// =====================================================
// COLORS
// =====================================================

var panel_color = make_color_rgb(37,44,56);
var row_color = make_color_rgb(61,73,90);
var purple = make_color_rgb(124,86,170);
var green = make_color_rgb(100,220,140);
var yellow = make_color_rgb(235,203,81);
var muted = make_color_rgb(160,170,185);
var bg = make_color_rgb(24,29,38);

// =====================================================
// DATA
// =====================================================

var recipe = recipes[selected_item];
var stacks = get_selected_stacks();
var owned = get_selected_owned();

// =====================================================
// PANEL
// =====================================================

draw_set_color(panel_color);

draw_rectangle(
    panel_x,
    panel_y,
    panel_x + panel_w,
    panel_y + panel_h,
    false
);

// =====================================================
// HEADER
// =====================================================

draw_set_color(c_white);

draw_text(
    panel_x + 20,
    panel_y + 15,
    "ITEM MARKET - QUALITY TRADING"
);

draw_set_color(yellow);

draw_text(
    panel_x + 375,
    panel_y + 15,
    string(global.credits) + " CR"
);

// =====================================================
// SELECTED ITEM
// =====================================================

draw_set_color(c_white);

draw_text(
    panel_x + 20,
    panel_y + 47,
    recipe.name
);

draw_set_color(muted);

draw_text(
    panel_x + 370,
    panel_y + 47,
    "OWNED: " + string(owned)
);

// =====================================================
// NAVIGATION
// =====================================================

draw_set_color(row_color);

draw_rectangle(
    panel_x + 20,
    panel_y + 75,
    panel_x + 125,
    panel_y + 110,
    false
);

draw_rectangle(
    panel_x + 425,
    panel_y + 75,
    panel_x + 530,
    panel_y + 110,
    false
);

draw_set_color(c_white);
draw_text(panel_x + 44, panel_y + 86, "< PREV");
draw_text(panel_x + 447, panel_y + 86, "NEXT >");

draw_set_color(muted);

draw_text(
    panel_x + 230,
    panel_y + 86,
    string(selected_item + 1) +
    " / " + string(array_length(recipes))
);

// =====================================================
// STACK HEADERS
// =====================================================

draw_set_color(muted);

draw_text(panel_x + 30, panel_y + 116, "QUALITY");
draw_text(panel_x + 295, panel_y + 116, "OWNED");
draw_text(panel_x + 405, panel_y + 116, "PRICE");

// =====================================================
// STACK ROWS
// =====================================================

if (array_length(stacks) == 0)
{
    draw_set_color(muted);

    draw_text(
        panel_x + 30,
        panel_y + 160,
        "NO ITEMS AVAILABLE"
    );
}

for (var row_i = 0; row_i < visible_stacks; row_i++)
{
    var stack_index = stack_scroll + row_i;

    if (stack_index >= array_length(stacks))
    {
        break;
    }

    var stack = stacks[stack_index];
    var row_y = panel_y + 130 + row_i * 31;

    if (selected_stack == stack_index)
    {
        draw_set_color(purple);
    }
    else
    {
        draw_set_color(row_color);
    }

    draw_rectangle(
        panel_x + 20,
        row_y,
        panel_x + 530,
        row_y + 27,
        false
    );

    // Rarity
    draw_set_color(
        craft_v3_rarity_color(stack.quality)
    );

    draw_text(
        panel_x + 30,
        row_y + 7,
        craft_v3_rarity_name(stack.quality) +
        " Q" + string(stack.quality)
    );

    // Count
    draw_set_color(c_white);

    draw_text(
        panel_x + 300,
        row_y + 7,
        "x" + string(stack.amount)
    );

    // Price
    draw_set_color(green);

    draw_text(
        panel_x + 405,
        row_y + 7,
        string(
            craft_v3_sell_price(
                selected_item,
                stack.quality
            )
        ) + " CR"
    );
}

// =====================================================
// SELL BUTTON
// =====================================================

draw_set_color(purple);

draw_rectangle(
    panel_x + 20,
    panel_y + 300,
    panel_x + 530,
    panel_y + 340,
    false
);

draw_set_color(c_white);

draw_text(
    panel_x + 230,
    panel_y + 313,
    "SELL x1"
);

// =====================================================
// MESSAGE
// =====================================================

draw_set_color(yellow);

var display_message = sell_message;

if (string_length(display_message) > 65)
{
    display_message =
        string_copy(display_message,1,62) + "...";
}

draw_text(
    panel_x + 20,
    panel_y + 348,
    display_message
);

// =====================================================
// RESET
// =====================================================

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);