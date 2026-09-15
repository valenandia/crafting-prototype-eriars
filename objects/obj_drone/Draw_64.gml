/// obj_drone - Draw GUI Event

draw_set_font(fnt_ui_small);

var panel_x = drone_x;
var panel_y = drone_y;


// =====================================================
// TITLE
// =====================================================

draw_set_color(c_white);

draw_text(
    panel_x,
    panel_y,
    "DRONE"
);


// =====================================================
// STATUS
// =====================================================

if (drone_active)
{
    draw_set_color(c_yellow);

    draw_text(
        panel_x,
        panel_y + 30,
        "STATUS: SEARCHING"
    );
}
else
{
    draw_set_color(c_lime);

    draw_text(
        panel_x,
        panel_y + 30,
        "STATUS: READY"
    );
}


// =====================================================
// TIMER
// =====================================================

if (drone_active)
{
    var seconds_left =
        ceil(drone_time / room_speed);

    draw_set_color(c_white);

    draw_text(
        panel_x,
        panel_y + 50,
        "RETURN: "
        + string(seconds_left)
        + "s"
    );
}


// =====================================================
// BUTTON
// =====================================================

if (!drone_active)
{
    draw_set_color(c_white);
}
else
{
    draw_set_color(c_gray);
}

draw_rectangle(
    drone_button_x1,
    drone_button_y1,
    drone_button_x2,
    drone_button_y2,
    false
);


if (!drone_active)
{
    draw_set_color(c_black);
}
else
{
    draw_set_color(c_dkgray);
}

draw_text(
    drone_button_x1 + 48,
    drone_button_y1 + 11,
    "SEND DRONE"
);


// =====================================================
// RESULT
// =====================================================

draw_set_color(c_gray);

draw_text(
    panel_x,
    panel_y + 130,
    drone_result
);


// =====================================================
// RESET
// =====================================================

draw_set_font(-1);
draw_set_color(c_white);