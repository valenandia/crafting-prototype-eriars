/// obj_quality_sell - Draw GUI Event

if (global.ui_screen != 0)
{
    exit;
}

draw_set_font(fnt_ui_small);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var panel_color = make_color_rgb(37,44,56);
var row_color = make_color_rgb(61,73,90);
var purple = make_color_rgb(124,86,170);
var muted = make_color_rgb(160,170,185);

var recipes = craft_v3_recipes();
var recipe = recipes[selected_item];

var stacks = craft_v3_get_quality_stacks(selected_item);

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

draw_set_color(c_white);
draw_text(panel_x + 20, panel_y + 15, "QUALITY ITEM MARKET");

draw_set_color(muted);
draw_text(
    panel_x + 20,
    panel_y + 40,
    recipe.name
);

// =====================================================
// NAVIGATION
// =====================================================

draw_set_color(row_color);

draw_rectangle(
    panel_x + 20,
    panel_y + 65,
    panel_x + 120,
    panel_y + 100,
    false
);

draw_rectangle(
    panel_x + 420,
    panel_y + 65,
    panel_x + 520,
    panel_y + 100,
    false
);

draw_set_color(c_white);
draw_text(panel_x + 40, panel_y + 75, "< PREV");
draw_text(panel_x + 440, panel_y + 75, "NEXT >");

// =====================================================
// QUALITY STACKS
// =====================================================

if (array_length(stacks) == 0)
{
    draw_set_color(muted);
    draw_text(
        panel_x + 20,
        panel_y + 140,
        "NO CRAFTED ITEMS IN QUALITY INVENTORY"
    );
}

for (var i = 0; i < min(4, array_length(stacks)); i++)
{
    var stack = stacks[i];
    var row_y = panel_y + 125 + i * 35;

    if (selected_stack == i)
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
        panel_x + 520,
        row_y + 30,
        false
    );

    draw_set_color(craft_v3_rarity_color(stack.quality));

    draw_text(
        panel_x + 30,
        row_y + 8,
        craft_v3_rarity_name(stack.quality) +
        " Q" + string(stack.quality)
    );

    draw_set_color(c_white);

    draw_text(
        panel_x + 270,
        row_y + 8,
        "x" + string(stack.amount)
    );

    draw_text(
        panel_x + 365,
        row_y + 8,
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
    panel_y + 275,
    panel_x + 520,
    panel_y + 310,
    false
);

draw_set_color(c_white);
draw_text(
    panel_x + 225,
    panel_y + 286,
    "SELL x1"
);

// =====================================================
// MESSAGE
// =====================================================

draw_set_color(muted);
draw_text(
    panel_x + 20,
    panel_y + 325,
    sell_message
);

// =====================================================
// RESET
// =====================================================

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);