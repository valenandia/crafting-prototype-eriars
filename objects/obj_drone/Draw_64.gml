/// obj_drone - Draw GUI Event

if (global.ui_screen != 0)
{
    exit;
}


draw_set_font(fnt_ui_small);


var panel_color =
    make_color_rgb(37,44,56);

var card_color =
    make_color_rgb(70,84,103);

var purple_color =
    make_color_rgb(124,86,170);

var muted_color =
    make_color_rgb(170,180,195);

var green_color =
    make_color_rgb(100,220,140);


// =====================================================
// PANEL
// =====================================================

draw_set_color(panel_color);

draw_rectangle(
    drone_x,
    drone_y,
    drone_x + drone_panel_w,
    drone_y + drone_panel_h,
    false
);


draw_set_color(c_white);

draw_text(
    drone_x + 20,
    drone_y + 17,
    "DRONES"
);


// =====================================================
// DRONE A
// =====================================================

draw_set_color(card_color);

draw_rectangle(
    drone_x + 20,
    drone_y + 52,
    drone_x + 430,
    drone_y + 135,
    false
);


draw_set_color(c_white);

draw_text(
    drone_x + 35,
    drone_y + 66,
    "DRONE A"
);


draw_set_color(muted_color);

draw_text(
    drone_x + 35,
    drone_y + 89,
    "10s / +20..60 NORMAL RESOURCE"
);


if (drone_a_active)
{
    draw_set_color(c_yellow);

    draw_text(
        drone_x + 315,
        drone_y + 66,
        string(ceil(drone_a_time / room_speed)) + "s"
    );
}
else
{
    draw_set_color(green_color);

    draw_text(
        drone_x + 315,
        drone_y + 66,
        "READY"
    );
}


draw_set_color(muted_color);

draw_text(
    drone_x + 35,
    drone_y + 112,
    drone_a_result
);


if (drone_a_active)
    draw_set_color(make_color_rgb(70,75,85));
else
    draw_set_color(purple_color);


draw_rectangle(
    drone_a_button_x1,
    drone_a_button_y1,
    drone_a_button_x2,
    drone_a_button_y2,
    false
);


draw_set_color(c_white);

draw_text(
    drone_a_button_x1 + 39,
    drone_a_button_y1 + 9,
    "SEND"
);


// =====================================================
// DRONE B
// =====================================================

draw_set_color(card_color);

draw_rectangle(
    drone_x + 20,
    drone_y + 152,
    drone_x + 430,
    drone_y + 235,
    false
);


draw_set_color(c_white);

draw_text(
    drone_x + 35,
    drone_y + 166,
    "DRONE B"
);


draw_set_color(muted_color);

draw_text(
    drone_x + 35,
    drone_y + 189,
    "15s / +35..75 NORMAL RESOURCE"
);


if (drone_b_active)
{
    draw_set_color(c_yellow);

    draw_text(
        drone_x + 315,
        drone_y + 166,
        string(ceil(drone_b_time / room_speed)) + "s"
    );
}
else
{
    draw_set_color(green_color);

    draw_text(
        drone_x + 315,
        drone_y + 166,
        "READY"
    );
}


draw_set_color(muted_color);

draw_text(
    drone_x + 35,
    drone_y + 212,
    drone_b_result
);


if (drone_b_active)
    draw_set_color(make_color_rgb(70,75,85));
else
    draw_set_color(purple_color);


draw_rectangle(
    drone_b_button_x1,
    drone_b_button_y1,
    drone_b_button_x2,
    drone_b_button_y2,
    false
);


draw_set_color(c_white);

draw_text(
    drone_b_button_x1 + 39,
    drone_b_button_y1 + 9,
    "SEND"
);


// =====================================================
// SCOUT
// =====================================================

draw_set_color(card_color);

draw_rectangle(
    drone_x + 20,
    drone_y + 252,
    drone_x + 430,
    drone_y + 350,
    false
);


draw_set_color(c_aqua);

draw_text(
    drone_x + 35,
    drone_y + 266,
    "SCOUT [LOW]"
);


draw_set_color(muted_color);

draw_text(
    drone_x + 35,
    drone_y + 289,
    "25s / +50 LOWEST NORMAL RESOURCE"
);


if (!scout_active)
{
    var preview_name =
        "Stone";

    var preview_amount =
        global.material_pool.stone;


    if (global.material_pool.polyester < preview_amount)
    {
        preview_name = "Polyester";
        preview_amount = global.material_pool.polyester;
    }

    if (global.material_pool.tree < preview_amount)
    {
        preview_name = "Tree";
        preview_amount = global.material_pool.tree;
    }

    if (global.material_pool.cloth < preview_amount)
    {
        preview_name = "Cloth";
        preview_amount = global.material_pool.cloth;
    }

    if (global.material_pool.glass < preview_amount)
    {
        preview_name = "Glass";
        preview_amount = global.material_pool.glass;
    }

    if (global.material_pool.jewels < preview_amount)
    {
        preview_name = "Jewels";
        preview_amount = global.material_pool.jewels;
    }


    draw_set_color(c_yellow);

    draw_text(
        drone_x + 35,
        drone_y + 314,
        "LOW: "
        + preview_name
        + " ("
        + string(preview_amount)
        + ")"
    );
}
else
{
    draw_set_color(c_yellow);

    draw_text(
        drone_x + 35,
        drone_y + 314,
        scout_target_name
        + " / "
        + string(ceil(scout_time / room_speed))
        + "s"
    );
}


if (scout_active)
    draw_set_color(make_color_rgb(70,75,85));
else
    draw_set_color(purple_color);


draw_rectangle(
    scout_button_x1,
    scout_button_y1,
    scout_button_x2,
    scout_button_y2,
    false
);


draw_set_color(c_white);

draw_text(
    scout_button_x1 + 22,
    scout_button_y1 + 9,
    "FIND LOW"
);


draw_set_font(-1);
draw_set_color(c_white);
draw_set_alpha(1);