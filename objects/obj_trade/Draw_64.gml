if (global.ui_screen != 0) exit;

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
    tx + 80,
    ty + 55,
    "OWNED"
);

draw_text(
    tx + 130,
    ty + 55,
    "BUY"
);

draw_text(
    tx + 300,
    ty + 55,
    "SELL"
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

    var owned =
        global.material_pool[$ tag];


    // =================================================
    // BUY DATA
    // =====================================================

    var buy_world =
        trade_get_cheapest_world(tag);

    var buy_price =
        trade_get_buy_price(tag);


    // =================================================
    // SELL DATA
    // =====================================================

    var sell_world =
        trade_get_best_sell_world(tag);

    var sell_price =
        trade_get_sell_price(tag);


    var yy =
        ty + 80 + (i * 27);


    // =================================================
    // RESOURCE COLOR
    // =====================================================

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
    // OWNED
    // =====================================================

    draw_set_color(c_white);

    draw_text(
        tx + 80,
        yy,
        string(owned)
    );


    // =================================================
    // BUY WORLD SHORT NAME
    // =====================================================

    var buy_short = "";

    switch (buy_world)
    {
        case "FANTASY":
            buy_short = "FAN";
        break;

        case "CYBERPUNK":
            buy_short = "CYB";
        break;

        case "STEAMPUNK":
            buy_short = "STM";
        break;
    }


    // =================================================
    // BUY WORLD
    // =====================================================

    draw_set_color(c_white);

    draw_text(
        tx + 130,
        yy,
        buy_short
    );


    // =================================================
    // BUY PRICE
    // =====================================================

    draw_set_color(c_yellow);

    draw_text(
        tx + 165,
        yy,
        string(buy_price)
    );


    // =================================================
    // BUY BUTTON
    // =====================================================

    var buy_x1 =
        tx + 195;

    var buy_y1 =
        yy - 5;

    var buy_x2 =
        buy_x1 + button_w;

    var buy_y2 =
        buy_y1 + button_h;


    if (global.credits >= buy_price)
    {
        draw_set_color(c_white);
    }
    else
    {
        draw_set_color(c_gray);
    }


    draw_rectangle(
        buy_x1,
        buy_y1,
        buy_x2,
        buy_y2,
        false
    );


    draw_set_color(c_black);

    draw_text(
        buy_x1 + 10,
        buy_y1 + 6,
        "BUY"
    );


    // =================================================
    // SELL WORLD SHORT NAME
    // =====================================================

    var sell_short = "";

    switch (sell_world)
    {
        case "FANTASY":
            sell_short = "FAN";
        break;

        case "CYBERPUNK":
            sell_short = "CYB";
        break;

        case "STEAMPUNK":
            sell_short = "STM";
        break;
    }


    // =================================================
    // SELL WORLD
    // =====================================================

    draw_set_color(c_white);

    draw_text(
        tx + 300,
        yy,
        sell_short
    );


    // =================================================
    // SELL PRICE
    // =====================================================

    draw_set_color(c_lime);

    draw_text(
        tx + 335,
        yy,
        string(sell_price)
    );


    // =================================================
    // SELL BUTTON
    // =====================================================

    var sell_x1 =
        tx + 365;

    var sell_y1 =
        yy - 5;

    var sell_x2 =
        sell_x1 + button_w;

    var sell_y2 =
        sell_y1 + button_h;


    if (owned >= trade_amount)
    {
        draw_set_color(c_white);
    }
    else
    {
        draw_set_color(c_gray);
    }


    draw_rectangle(
        sell_x1,
        sell_y1,
        sell_x2,
        sell_y2,
        false
    );


    draw_set_color(c_black);

    draw_text(
        sell_x1 + 5,
        sell_y1 + 6,
        "SELL"
    );
}


// =====================================================
// INFO
// =====================================================

draw_set_color(c_gray);

draw_text(
    tx,
    ty + 305,
    "BUY cheapest / SELL highest / 100 units"
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