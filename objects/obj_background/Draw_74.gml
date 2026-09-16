/// obj_background - Draw GUI Begin Event

// Красивый тёмный лиловый фон
draw_set_color(
     make_color_rgb(25, 0, 51)
);

draw_rectangle(
    0,
    0,
    1600,
    900,
    false
);

// Reset
draw_set_color(c_white);
draw_set_alpha(1);