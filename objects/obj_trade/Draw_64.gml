/// obj_trade - Draw GUI Event

draw_set_font(fnt_ui_small);

var tx = trade_x;
var ty = trade_y;


// =====================================================
// TITLE
// =====================================================

draw_set_color(c_white);

draw_text(
    tx,
    ty,
    "TRADE"
);


// =====================================================
// CREDITS
// =====================================================

draw_set_color(c_yellow);

draw_text(
    tx,
    ty + 25,
    "CREDITS: "
    + string(global.credits)
);


// =====================================================
// HEADERS
// =====================================================

draw_set_color(c_gray);

draw_text(
    tx,
    ty + 55,
    "RESOURCE"
);

draw_text(
    tx + 85,
    ty + 55,
    "WORLD"
);

draw_text(
    tx + 155,
    ty + 55,
    "PRICE"
);


// =====================================================
// RESOURCES
// =====================================================

for (
    var i = 0;
    i < array_length(trade_resources);
    i++
)
{
    var tag =
        trade_resources[i];

    var resource_name =
        trade_get_resource_name(tag);

    var world =
        trade_get_cheapest_world(tag);

    var price =
        trade_get_buy_price(tag);


    var yy =
        ty + 80 + (i * 27);


    // =================================================
    // RESOURCE COLOR
    // =================================================

    switch (tag)
    {
        case "stone":
            draw_set_color(c_gray);
        break;

        case "polyester":
            draw_set_color(c_fuchsia);
        break;

        case "tree":
            draw_set_color(c_lime);
        break;

        case "cloth":
            draw_set_color(c_yellow);
        break;

        case "glass":
            draw_set_color(c_aqua);
        break;

        case "jewels":
            draw_set_color(c_blue);
        break;

        case "mushrooms":
            draw_set_color(
                make_color_rgb(150, 90, 30)
            );
        break;

        case "blood":
            draw_set_color(c_red);
        break;
    }


    draw_text(
        tx,
        yy,
        resource_name
    );


    // =================================================
    // WORLD
    // =================================================

    draw_set_color(c_white);

    var short_world = "";

    switch (world)
    {
        case "FANTASY":
            short_world = "FAN";
        break;

        case "CYBERPUNK":
            short_world = "CYB";
        break;

        case "STEAMPUNK":
            short_world = "STM";
        break;
    }


    draw_text(
        tx + 85,
        yy,
        short_world
    );


    // =================================================
    // PRICE
    // =================================================

    draw_set_color(c_yellow);

    draw_text(
        tx + 155,
        yy,
        string(price)
    );


    // =================================================
    // BUY BUTTON
    // =================================================

    var bx1 = tx + 205;
    var by1 = yy - 5;

    var bx2 =
        bx1 + button_w;

    var by2 =
        by1 + button_h;


    if (global.credits >= price)
    {
        draw_set_color(c_white);
    }
    else
    {
        draw_set_color(c_gray);
    }


    draw_rectangle(
        bx1,
        by1,
        bx2,
        by2,
        false
    );


    draw_set_color(c_black);

    draw_text(
        bx1 + 16,
        by1 + 6,
        "BUY"
    );
}


// =====================================================
// INFO
// =====================================================

draw_set_color(c_gray);

draw_text(
    tx,
    ty + 305,
    "+100 units / cheapest world"
);


// =====================================================
// RESULT
// =====================================================

draw_set_color(c_white);

draw_text(
    tx,
    ty + 330,
    trade_result
);


// =====================================================
// RESET
// =====================================================

draw_set_font(-1);
draw_set_color(c_white);