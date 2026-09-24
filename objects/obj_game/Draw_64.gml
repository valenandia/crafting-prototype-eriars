// Рисуем мини-игру только на экране CRAFTING
if (global.ui_screen != 1) exit;

/// obj_game - Draw GUI Event

draw_set_font(-1);

// =============================================
// TOP SCREEN SWITCHER
// =============================================

var bx = 650;
var by = 10;

var bw = 140;
var bh = 32;
var gap = 10;


// ---------------------------------------------
// ECONOMY
// ---------------------------------------------

if (global.ui_screen == 0)
{
    draw_set_color(make_color_rgb(124, 86, 170));
}
else
{
    draw_set_color(make_color_rgb(55, 64, 78));
}

draw_rectangle(
    bx,
    by,
    bx + bw,
    by + bh,
    false
);

draw_set_color(c_white);
draw_text(bx + 29, by + 8, "ECONOMY");


// ---------------------------------------------
// CRAFTING
// ---------------------------------------------

var craft_x = bx + bw + gap;

if (global.ui_screen == 1)
{
    draw_set_color(make_color_rgb(124, 86, 170));
}
else
{
    draw_set_color(make_color_rgb(55, 64, 78));
}

draw_rectangle(
    craft_x,
    by,
    craft_x + bw,
    by + bh,
    false
);

draw_set_color(c_white);
draw_text(craft_x + 24, by + 8, "CRAFTING");

draw_set_color(c_white);