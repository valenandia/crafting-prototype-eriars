/// obj_tabs - Draw GUI Event


// =====================================================
// CRAFTING TAB
// =====================================================

if (global.ui_tab == 0)
{
    draw_set_color(c_white);
    draw_rectangle(
        tab_craft_x1,
        tab_y1,
        tab_craft_x2,
        tab_y2,
        false
    );

    draw_set_color(c_black);
}
else
{
    draw_set_color(c_gray);
    draw_rectangle(
        tab_craft_x1,
        tab_y1,
        tab_craft_x2,
        tab_y2,
        false
    );

    draw_set_color(c_white);
}

draw_text(
    tab_craft_x1 + 45,
    tab_y1 + 13,
    "CRAFTING"
);


// =====================================================
// MARKET TAB
// =====================================================

if (global.ui_tab == 1)
{
    draw_set_color(c_white);
    draw_rectangle(
        tab_market_x1,
        tab_y1,
        tab_market_x2,
        tab_y2,
        false
    );

    draw_set_color(c_black);
}
else
{
    draw_set_color(c_gray);
    draw_rectangle(
        tab_market_x1,
        tab_y1,
        tab_market_x2,
        tab_y2,
        false
    );

    draw_set_color(c_white);
}

draw_text(
    tab_market_x1 + 55,
    tab_y1 + 13,
    "MARKET"
);


// =====================================================
// RESOURCES TAB
// =====================================================

if (global.ui_tab == 2)
{
    draw_set_color(c_white);
    draw_rectangle(
        tab_resources_x1,
        tab_y1,
        tab_resources_x2,
        tab_y2,
        false
    );

    draw_set_color(c_black);
}
else
{
    draw_set_color(c_gray);
    draw_rectangle(
        tab_resources_x1,
        tab_y1,
        tab_resources_x2,
        tab_y2,
        false
    );

    draw_set_color(c_white);
}

draw_text(
    tab_resources_x1 + 42,
    tab_y1 + 13,
    "RESOURCES"
);

draw_set_color(c_white);