/// obj_market - Draw GUI Event

if (global.ui_screen != 0)
{
    exit;
}


draw_set_font(fnt_ui_small);


var panel_color =
    make_color_rgb(37,44,56);

var header_color =
    make_color_rgb(78,92,112);

var muted_color =
    make_color_rgb(170,180,195);


// =====================================================
// PANEL
// =====================================================

draw_set_color(panel_color);

draw_rectangle(
    market_x,
    market_y,
    market_x + market_panel_w,
    market_y + market_panel_h,
    false
);


// =====================================================
// TITLE
// =====================================================

draw_set_color(c_white);

draw_text(
    market_x + 20,
    market_y + 17,
    "WORLD MARKET"
);


draw_set_color(muted_color);

draw_text(
    market_x + 360,
    market_y + 17,
    "UPDATE: "
    + string(ceil(market_timer / room_speed))
    + "s"
);


// =====================================================
// HEADER
// =====================================================

draw_set_color(header_color);

draw_rectangle(
    market_x + 20,
    market_y + 48,
    market_x + 480,
    market_y + 78,
    false
);


draw_set_color(muted_color);

draw_text(market_x + 30,  market_y + 56, "RESOURCE");
draw_text(market_x + 220, market_y + 56, "FANTASY");
draw_text(market_x + 310, market_y + 56, "CYBER");
draw_text(market_x + 390, market_y + 56, "STEAM");


// =====================================================
// MATERIALS
// =====================================================

for (
    var market_i = 0;
    market_i < array_length(global.market_materials);
    market_i++
)
{
    var market_tag =
        global.market_materials[market_i];


    var market_row_y =
        market_y + 92 + market_i * 25;


    switch (market_tag)
    {
        case "stone":
            draw_set_color(make_color_rgb(150,150,150));
        break;

        case "polyester":
            draw_set_color(make_color_rgb(255,100,180));
        break;

        case "tree":
            draw_set_color(make_color_rgb(80,190,90));
        break;

        case "cloth":
            draw_set_color(make_color_rgb(240,210,60));
        break;

        case "glass":
            draw_set_color(make_color_rgb(80,210,240));
        break;

        case "jewels":
            draw_set_color(make_color_rgb(60,100,255));
        break;

        case "mushrooms":
            draw_set_color(make_color_rgb(170,100,35));
        break;

        case "blood":
            draw_set_color(make_color_rgb(235,55,55));
        break;
    }


    draw_text(
        market_x + 30,
        market_row_y,
        trade_get_resource_name(market_tag)
    );


    var fantasy_value =
        market_get_multiplier(
            "FANTASY",
            market_tag
        );

    var cyber_value =
        market_get_multiplier(
            "CYBERPUNK",
            market_tag
        );

    var steam_value =
        market_get_multiplier(
            "STEAMPUNK",
            market_tag
        );


    // FANTASY

    if (fantasy_value >= 1.25)
        draw_set_color(c_lime);
    else if (fantasy_value <= 0.80)
        draw_set_color(c_red);
    else
        draw_set_color(c_white);


    draw_text(
        market_x + 230,
        market_row_y,
        "x" + string(fantasy_value)
    );


    // CYBER

    if (cyber_value >= 1.25)
        draw_set_color(c_lime);
    else if (cyber_value <= 0.80)
        draw_set_color(c_red);
    else
        draw_set_color(c_white);


    draw_text(
        market_x + 320,
        market_row_y,
        "x" + string(cyber_value)
    );


    // STEAM

    if (steam_value >= 1.25)
        draw_set_color(c_lime);
    else if (steam_value <= 0.80)
        draw_set_color(c_red);
    else
        draw_set_color(c_white);


    draw_text(
        market_x + 400,
        market_row_y,
        "x" + string(steam_value)
    );
}


// =====================================================
// EVENT
// =====================================================

draw_set_color(header_color);

draw_rectangle(
    market_x + 20,
    market_y + 300,
    market_x + 480,
    market_y + 328,
    false
);


if (global.market_event_active)
{
    var event_seconds =
        ceil(
            global.market_event_timer /
            room_speed
        );


    if (global.market_event_failure_bonus > 0)
        draw_set_color(c_red);
    else
        draw_set_color(c_lime);


    draw_text(
        market_x + 30,
        market_y + 307,
        "EVENT: "
        + global.market_event_name
    );


    if (global.market_event_failure_bonus > 0)
    {
        draw_text(
            market_x + 330,
            market_y + 307,
            "+"
            + string(global.market_event_failure_bonus)
            + "% / "
            + string(event_seconds)
            + "s"
        );
    }
    else
    {
        draw_text(
            market_x + 330,
            market_y + 307,
            string(global.market_event_failure_bonus)
            + "% / "
            + string(event_seconds)
            + "s"
        );
    }
}
else
{
    draw_set_color(muted_color);

    draw_text(
        market_x + 30,
        market_y + 307,
        "EVENT: NONE"
    );
}


draw_set_font(-1);
draw_set_color(c_white);
draw_set_alpha(1);