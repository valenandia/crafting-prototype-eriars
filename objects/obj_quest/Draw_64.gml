/// obj_quest - Draw GUI Event

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

var red_color =
    make_color_rgb(236,75,91);


// =====================================================
// PANEL
// =====================================================

draw_set_color(panel_color);

draw_rectangle(
    quest_x,
    quest_y,
    quest_x + quest_panel_w,
    quest_y + quest_panel_h,
    false
);


draw_set_color(c_white);

draw_text(
    quest_x + 20,
    quest_y + 17,
    "QUESTS"
);


if (quest_active)
{
    draw_set_color(c_yellow);

    draw_text(
        quest_x + 405,
        quest_y + 17,
        "ACTIVE"
    );
}
else
{
    draw_set_color(green_color);

    draw_text(
        quest_x + 405,
        quest_y + 17,
        "READY"
    );
}


// =====================================================
// MUSHROOM
// =====================================================

draw_set_color(card_color);

draw_rectangle(
    quest_x + 20,
    quest_y + 52,
    quest_x + 480,
    quest_y + 165,
    false
);


draw_set_color(c_white);

draw_text(
    quest_x + 35,
    quest_y + 68,
    "MUSHROOM EXPEDITION"
);


draw_set_color(muted_color);

draw_text(
    quest_x + 35,
    quest_y + 95,
    "DURATION"
);


draw_set_color(c_white);

draw_text(
    quest_x + 125,
    quest_y + 95,
    "10s"
);


draw_set_color(muted_color);

draw_text(
    quest_x + 35,
    quest_y + 120,
    "REWARD"
);


draw_set_color(
    make_color_rgb(170,100,35)
);

draw_text(
    quest_x + 125,
    quest_y + 120,
    "+30 MUSHROOMS"
);


if (quest_active)
    draw_set_color(make_color_rgb(70,75,85));
else
    draw_set_color(purple_color);


draw_rectangle(
    mushroom_button_x1,
    mushroom_button_y1,
    mushroom_button_x2,
    mushroom_button_y2,
    false
);


draw_set_color(c_white);

draw_text(
    mushroom_button_x1 + 34,
    mushroom_button_y1 + 9,
    "START"
);


// =====================================================
// BLOOD
// =====================================================

draw_set_color(card_color);

draw_rectangle(
    quest_x + 20,
    quest_y + 190,
    quest_x + 480,
    quest_y + 305,
    false
);


draw_set_color(c_white);

draw_text(
    quest_x + 35,
    quest_y + 206,
    "BLOOD HUNT"
);


draw_set_color(muted_color);

draw_text(
    quest_x + 35,
    quest_y + 233,
    "DURATION"
);


draw_set_color(c_white);

draw_text(
    quest_x + 125,
    quest_y + 233,
    "20s"
);


draw_set_color(muted_color);

draw_text(
    quest_x + 35,
    quest_y + 258,
    "REWARD"
);


draw_set_color(red_color);

draw_text(
    quest_x + 125,
    quest_y + 258,
    "+15 BLOOD"
);


if (quest_active)
    draw_set_color(make_color_rgb(70,75,85));
else
    draw_set_color(purple_color);


draw_rectangle(
    blood_button_x1,
    blood_button_y1,
    blood_button_x2,
    blood_button_y2,
    false
);


draw_set_color(c_white);

draw_text(
    blood_button_x1 + 34,
    blood_button_y1 + 9,
    "START"
);


// =====================================================
// STATUS
// =====================================================

if (quest_active)
{
    draw_set_color(c_yellow);

    draw_text(
        quest_x + 20,
        quest_y + 330,
        "RETURN: "
        + string(ceil(quest_timer / room_speed))
        + "s"
    );
}
else
{
    draw_set_color(muted_color);

    draw_text(
        quest_x + 20,
        quest_y + 330,
        quest_result
    );
}


draw_set_font(-1);
draw_set_color(c_white);
draw_set_alpha(1);