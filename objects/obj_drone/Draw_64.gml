if (global.ui_screen != 0) exit;

/// obj_drone - Draw GUI Event

draw_set_font(fnt_ui_small);

var dx = drone_x;
var dy = drone_y;


// =====================================================
// TITLE
// =====================================================

draw_set_color(c_white);

draw_text(
    dx,
    dy,
    "DRONES"
);


// =====================================================
// DRONE A
// =====================================================

draw_set_color(c_white);

draw_text(
    dx,
    dy + 30,
    "DRONE A"
);


if (drone_a_active)
{
    var seconds_a =
        ceil(drone_a_time / room_speed);

    draw_set_color(c_yellow);

    draw_text(
        dx + 70,
        dy + 30,
        string(seconds_a) + "s"
    );
}
else
{
    draw_set_color(c_lime);

    draw_text(
        dx + 70,
        dy + 30,
        "READY"
    );
}


// BUTTON

if (drone_a_active)
{
    draw_set_color(c_gray);
}
else
{
    draw_set_color(c_white);
}


draw_rectangle(
    drone_a_button_x1,
    drone_a_button_y1,
    drone_a_button_x2,
    drone_a_button_y2,
    false
);


if (drone_a_active)
{
    draw_set_color(c_dkgray);
}
else
{
    draw_set_color(c_black);
}


draw_text(
    drone_a_button_x1 + 55,
    drone_a_button_y1 + 8,
    "SEND"
);


draw_set_color(c_gray);

draw_text(
    dx,
    dy + 105,
    drone_a_result
);


// =====================================================
// DRONE B
// =====================================================

draw_set_color(c_white);

draw_text(
    dx,
    dy + 135,
    "DRONE B"
);


if (drone_b_active)
{
    var seconds_b =
        ceil(drone_b_time / room_speed);

    draw_set_color(c_yellow);

    draw_text(
        dx + 70,
        dy + 135,
        string(seconds_b) + "s"
    );
}
else
{
    draw_set_color(c_lime);

    draw_text(
        dx + 70,
        dy + 135,
        "READY"
    );
}


// BUTTON

if (drone_b_active)
{
    draw_set_color(c_gray);
}
else
{
    draw_set_color(c_white);
}


draw_rectangle(
    drone_b_button_x1,
    drone_b_button_y1,
    drone_b_button_x2,
    drone_b_button_y2,
    false
);


if (drone_b_active)
{
    draw_set_color(c_dkgray);
}
else
{
    draw_set_color(c_black);
}


draw_text(
    drone_b_button_x1 + 55,
    drone_b_button_y1 + 8,
    "SEND"
);


draw_set_color(c_gray);

draw_text(
    dx,
    dy + 210,
    drone_b_result
);


// =====================================================
// SCOUT
// =====================================================

draw_set_color(c_aqua);

draw_text(
    dx,
    dy + 240,
    "SCOUT [LOW]"
);


// -----------------------------------------
// Current lowest resource preview
// -----------------------------------------

if (!scout_active)
{
    var preview_tag = "stone";
    var preview_amount =
        global.material_pool[$ "stone"];


    if (
        global.material_pool[$ "polyester"]
        < preview_amount
    )
    {
        preview_tag = "polyester";
        preview_amount =
            global.material_pool[$ "polyester"];
    }


    if (
        global.material_pool[$ "tree"]
        < preview_amount
    )
    {
        preview_tag = "tree";
        preview_amount =
            global.material_pool[$ "tree"];
    }


    if (
        global.material_pool[$ "cloth"]
        < preview_amount
    )
    {
        preview_tag = "cloth";
        preview_amount =
            global.material_pool[$ "cloth"];
    }


    if (
        global.material_pool[$ "glass"]
        < preview_amount
    )
    {
        preview_tag = "glass";
        preview_amount =
            global.material_pool[$ "glass"];
    }


    if (
        global.material_pool[$ "jewels"]
        < preview_amount
    )
    {
        preview_tag = "jewels";
        preview_amount =
            global.material_pool[$ "jewels"];
    }


    var preview_name =
        trade_get_resource_name(
            preview_tag
        );


    draw_set_color(c_yellow);

    draw_text(
        dx,
        dy + 265,
        "LOW: "
        + preview_name
        + " ("
        + string(preview_amount)
        + ")"
    );
}
else
{
    var scout_seconds =
        ceil(scout_time / room_speed);


    draw_set_color(c_yellow);

    draw_text(
        dx,
        dy + 265,
        scout_target_name
        + " / "
        + string(scout_seconds)
        + "s"
    );
}


// =====================================================
// SCOUT BUTTON
// =====================================================

if (scout_active)
{
    draw_set_color(c_gray);
}
else
{
    draw_set_color(c_white);
}


draw_rectangle(
    scout_button_x1,
    scout_button_y1,
    scout_button_x2,
    scout_button_y2,
    false
);


if (scout_active)
{
    draw_set_color(c_dkgray);
}
else
{
    draw_set_color(c_black);
}


draw_text(
    scout_button_x1 + 48,
    scout_button_y1 + 8,
    "FIND LOW"
);


// =====================================================
// SCOUT RESULT
// =====================================================

draw_set_color(c_gray);

draw_text(
    dx,
    dy + 325,
    scout_result
);


// =====================================================
// RESET
// =====================================================

draw_set_font(-1);
draw_set_color(c_white);