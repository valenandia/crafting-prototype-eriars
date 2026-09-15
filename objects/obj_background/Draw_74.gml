/// obj_background - Draw GUI Begin Event

var gui_w = 1600;
var gui_h = 900;

var spr_w = sprite_get_width(spr_background);
var spr_h = sprite_get_height(spr_background);

// Масштаб, чтобы картинка полностью закрыла экран
var scale = max(
    gui_w / spr_w,
    gui_h / spr_h
);

var final_w = spr_w * scale;
var final_h = spr_h * scale;

// Центрируем
var bx = (gui_w - final_w) * 0.5;
var by = (gui_h - final_h) * 0.5;


// BACKGROUND
draw_sprite_ext(
    spr_background,
    0,
    bx,
    by,
    scale,
    scale,
    0,
    c_white,
    1
);


// DARK OVERLAY
draw_set_alpha(0.85);
draw_set_color(c_black);

draw_rectangle(
    0,
    0,
    gui_w,
    gui_h,
    false
);

draw_set_alpha(1);
draw_set_color(c_white);