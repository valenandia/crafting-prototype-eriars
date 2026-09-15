/// obj_quest - Draw GUI Event

draw_set_font(fnt_ui_small);

var qx = quest_x;
var qy = quest_y;


// =====================================================
// TITLE
// =====================================================

draw_set_color(c_white);

draw_text(
    qx,
    qy,
    "QUESTS"
);


// =====================================================
// STATUS
// =====================================================

if (quest_active)
{
    draw_set_color(c_yellow);

    draw_text(
        qx,
        qy + 30,
        "STATUS: ACTIVE"
    );
}
else
{
    draw_set_color(c_lime);

    draw_text(
        qx,
        qy + 30,
        "STATUS: READY"
    );
}


// =====================================================
// MUSHROOM QUEST
// =====================================================

draw_set_color(c_white);

draw_text(
    qx,
    qy + 65,
    "MUSHROOM EXPEDITION"
);


// Time + reward on ONE compact line

draw_set_color(c_gray);

draw_text(
    qx,
    qy + 85,
    "10s"
);

draw_set_color(c_lime);

draw_text(
    qx + 55,
    qy + 85,
    "+30 Mushrooms"
);


// Button

if (!quest_active)
{
    draw_set_color(c_white);
}
else
{
    draw_set_color(c_gray);
}

draw_rectangle(
    mushroom_button_x1,
    mushroom_button_y1,
    mushroom_button_x2,
    mushroom_button_y2,
    false
);

if (!quest_active)
{
    draw_set_color(c_black);
}
else
{
    draw_set_color(c_dkgray);
}

draw_text(
    mushroom_button_x1 + 70,
    mushroom_button_y1 + 11,
    "START"
);


// =====================================================
// BLOOD QUEST
// =====================================================

draw_set_color(c_white);

draw_text(
    qx,
    qy + 185,
    "BLOOD HUNT"
);

draw_set_color(c_gray);

draw_text(
    qx,
    qy + 205,
    "20s"
);

draw_set_color(c_red);

draw_text(
    qx + 55,
    qy + 205,
    "+15 Blood"
);


// Button

if (!quest_active)
{
    draw_set_color(c_white);
}
else
{
    draw_set_color(c_gray);
}

draw_rectangle(
    blood_button_x1,
    blood_button_y1,
    blood_button_x2,
    blood_button_y2,
    false
);

if (!quest_active)
{
    draw_set_color(c_black);
}
else
{
    draw_set_color(c_dkgray);
}

draw_text(
    blood_button_x1 + 70,
    blood_button_y1 + 11,
    "START"
);


// =====================================================
// TIMER / RESULT
// =====================================================

if (quest_active)
{
    var seconds_left =
        ceil(quest_timer / room_speed);

    draw_set_color(c_yellow);

    draw_text(
        qx,
        qy + 285,
        "RETURN: "
        + string(seconds_left)
        + "s"
    );
}
else
{
    draw_set_color(c_gray);

    draw_text(
        qx,
        qy + 285,
        quest_result
    );
}


// =====================================================
// RESET
// =====================================================

draw_set_font(-1);
draw_set_color(c_white);