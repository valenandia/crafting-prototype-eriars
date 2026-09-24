/// obj_game - Draw GUI End Event

draw_set_font(-1);
draw_set_alpha(1);


// =====================================================
// COLORS
// =====================================================

var tab_normal =
    make_color_rgb(
        55,
        64,
        78
    );


var tab_active =
    make_color_rgb(
        124,
        86,
        170
    );


var tab_border =
    make_color_rgb(
        115,
        128,
        146
    );


// =====================================================
// POSITION
// =====================================================

var tab_width =
    150;

var tab_height =
    38;

var tab_gap =
    12;


// Центр 1600px GUI

var total_width =
    tab_width * 2
    + tab_gap;


var economy_x =
    (1600 - total_width) * 0.5;


var crafting_x =
    economy_x
    + tab_width
    + tab_gap;


var tab_y =
    18;


// =====================================================
// TOP BACKGROUND
// =====================================================

draw_set_color(
    make_color_rgb(
        24,
        29,
        38
    )
);


draw_rectangle(
    economy_x - 12,
    tab_y - 8,
    crafting_x + tab_width + 12,
    tab_y + tab_height + 8,
    false
);


// =====================================================
// ECONOMY TAB
// =====================================================

if (global.ui_screen == 0)
{
    draw_set_color(
        tab_active
    );
}
else
{
    draw_set_color(
        tab_normal
    );
}


draw_rectangle(
    economy_x,
    tab_y,
    economy_x + tab_width,
    tab_y + tab_height,
    false
);


// Border

draw_set_color(
    tab_border
);


draw_rectangle(
    economy_x,
    tab_y,
    economy_x + tab_width,
    tab_y + tab_height,
    true
);


// Text

draw_set_color(
    c_white
);


draw_text_transformed(
    economy_x + 34,
    tab_y + 12,
    "ECONOMY",
    0.82,
    0.82,
    0
);


// =====================================================
// CRAFTING TAB
// =====================================================

if (global.ui_screen == 1)
{
    draw_set_color(
        tab_active
    );
}
else
{
    draw_set_color(
        tab_normal
    );
}


draw_rectangle(
    crafting_x,
    tab_y,
    crafting_x + tab_width,
    tab_y + tab_height,
    false
);


// Border

draw_set_color(
    tab_border
);


draw_rectangle(
    crafting_x,
    tab_y,
    crafting_x + tab_width,
    tab_y + tab_height,
    true
);


// Text

draw_set_color(
    c_white
);


draw_text_transformed(
    crafting_x + 29,
    tab_y + 12,
    "CRAFTING",
    0.82,
    0.82,
    0
);


// =====================================================
// RESET DRAW STATE
// =====================================================

draw_set_color(
    c_white
);

draw_set_alpha(1);