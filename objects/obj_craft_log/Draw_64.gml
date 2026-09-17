/// obj_craft_log - Draw GUI Event

draw_set_font(fnt_ui_small);


// =====================================================
// POSITION
// =====================================================

var log_x = 30;
var log_y = 550;


// =====================================================
// TITLE
// =====================================================

draw_set_color(c_white);

draw_text(
    log_x,
    log_y,
    "CRAFT LOG"
);


// =====================================================
// ATTEMPTS
// =====================================================

draw_set_color(c_gray);

draw_text(
    log_x,
    log_y + 25,
    "Total attempts: "
    + string(global.craft_attempts)
);


// =====================================================
// EMPTY LOG
// =====================================================

if (array_length(global.craft_log) == 0)
{
    draw_set_color(c_gray);

    draw_text(
        log_x,
        log_y + 55,
        "No craft attempts yet."
    );
}


// =====================================================
// CRAFT LOG
// =====================================================

for (
    var i = 0;
    i < array_length(global.craft_log);
    i++
)
{
    var log_entry =
        global.craft_log[i];

    draw_set_color(c_white);

    draw_text(
        log_x,
        log_y + 55 + (i * 22),
        log_entry
    );
}


// =====================================================
// RESET
// =====================================================

draw_set_font(-1);
draw_set_color(c_white);