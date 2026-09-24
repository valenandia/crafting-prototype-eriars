/// obj_trade - Draw GUI Event

if (global.ui_screen != 0)
{
    exit;
}


draw_set_font(fnt_ui_small);


var panel_color =
    make_color_rgb(37, 44, 56);

var row_color =
    make_color_rgb(70, 84, 103);

var header_color =
    make_color_rgb(78, 92, 112);

var purple_color =
    make_color_rgb(124, 86, 170);

var disabled_color =
    make_color_rgb(70, 75, 85);

var muted_color =
    make_color_rgb(170, 180, 195);


// =====================================================
// PANEL
// =====================================================

draw_set_color(panel_color);

draw_rectangle(
    trade_x,
    trade_y,
    trade_x + trade_panel_w,
    trade_y + trade_panel_h,
    false
);


// =====================================================
// TITLE
// =====================================================

draw_set_color(c_white);

draw_text(
    trade_x + 20,
    trade_y + 17,
    "RESOURCE TRADE"
);


draw_set_color(c_yellow);

draw_text(
    trade_x + 365,
    trade_y + 17,
    "CREDITS: "
    + string(global.credits)
);


// =====================================================
// HEADER
// =====================================================

draw_set_color(header_color);

draw_rectangle(
    trade_x + 20,
    trade_y + 50,
    trade_x + 530,
    trade_y + 80,
    false
);


draw_set_color(muted_color);

draw_text(
    trade_x + 30,
    trade_y + 58,
    "RESOURCE"
);

draw_text(
    trade_x + 145,
    trade_y + 58,
    "OWNED"
);

draw_text(
    trade_x + 210,
    trade_y + 58,
    "BUY"
);

draw_text(
    trade_x + 385,
    trade_y + 58,
    "SELL"
);


// =====================================================
// RESOURCES
// =====================================================

for (
    var trade_i = 0;
    trade_i < array_length(trade_resources);
    trade_i++
)
{
    var trade_tag =
        trade_resources[trade_i];

    var trade_row_y =
        trade_y + 93 + trade_i * 30;


    // =================================================
    // OWNED
    // =================================================

    var owned_amount = 0;


    switch (trade_tag)
    {
        case "stone":
            owned_amount = global.material_pool.stone;
        break;

        case "polyester":
            owned_amount = global.material_pool.polyester;
        break;

        case "tree":
            owned_amount = global.material_pool.tree;
        break;

        case "cloth":
            owned_amount = global.material_pool.cloth;
        break;

        case "glass":
            owned_amount = global.material_pool.glass;
        break;

        case "jewels":
            owned_amount = global.material_pool.jewels;
        break;

        case "mushrooms":
            owned_amount = global.material_pool.mushrooms;
        break;

        case "blood":
            owned_amount = global.material_pool.blood;
        break;
    }


    // =================================================
    // ROW BACKGROUND
    // =================================================

    draw_set_color(row_color);

    draw_rectangle(
        trade_x + 20,
        trade_row_y - 5,
        trade_x + 530,
        trade_row_y + 22,
        false
    );


    // =================================================
    // COLOR BAR + NAME
    // =================================================

    switch (trade_tag)
    {
        case "stone":
            draw_set_color(
                make_color_rgb(150,150,150)
            );
        break;

        case "polyester":
            draw_set_color(
                make_color_rgb(255,100,180)
            );
        break;

        case "tree":
            draw_set_color(
                make_color_rgb(80,190,90)
            );
        break;

        case "cloth":
            draw_set_color(
                make_color_rgb(240,210,60)
            );
        break;

        case "glass":
            draw_set_color(
                make_color_rgb(80,210,240)
            );
        break;

        case "jewels":
            draw_set_color(
                make_color_rgb(60,100,255)
            );
        break;

        case "mushrooms":
            draw_set_color(
                make_color_rgb(170,100,35)
            );
        break;

        case "blood":
            draw_set_color(
                make_color_rgb(235,55,55)
            );
        break;
    }


    draw_rectangle(
        trade_x + 20,
        trade_row_y - 5,
        trade_x + 26,
        trade_row_y + 22,
        false
    );


    draw_text(
        trade_x + 35,
        trade_row_y,
        trade_get_resource_name(trade_tag)
    );


    // =================================================
    // OWNED
    // =================================================

    draw_set_color(c_white);

    draw_text(
        trade_x + 150,
        trade_row_y,
        string(owned_amount)
    );


    // =================================================
    // BUY DATA
    // =================================================

    var buy_world =
        trade_get_cheapest_world(trade_tag);

    var buy_price =
        trade_get_buy_price(trade_tag);

    var buy_short =
        "";

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


    // BUY WORLD

    draw_set_color(c_white);

    draw_text(
        trade_x + 210,
        trade_row_y,
        buy_short
    );


    // BUY PRICE

    draw_set_color(c_yellow);

    draw_text(
        trade_x + 250,
        trade_row_y,
        string(buy_price)
    );


    // BUY BUTTON

    if (global.credits >= buy_price)
    {
        draw_set_color(purple_color);
    }
    else
    {
        draw_set_color(disabled_color);
    }


    draw_rectangle(
        trade_x + 290,
        trade_row_y - 5,
        trade_x + 344,
        trade_row_y + 20,
        false
    );


    draw_set_color(c_white);

    draw_text(
        trade_x + 304,
        trade_row_y,
        "BUY"
    );


    // =================================================
    // SELL DATA
    // =================================================

    var sell_world =
        trade_get_best_sell_world(trade_tag);

    var sell_price =
        trade_get_sell_price(trade_tag);

    var sell_short =
        "";

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


    // SELL WORLD

    draw_set_color(c_white);

    draw_text(
        trade_x + 385,
        trade_row_y,
        sell_short
    );


    // SELL PRICE

    draw_set_color(c_lime);

    draw_text(
        trade_x + 425,
        trade_row_y,
        string(sell_price)
    );


    // SELL BUTTON

    if (owned_amount >= trade_amount)
    {
        draw_set_color(purple_color);
    }
    else
    {
        draw_set_color(disabled_color);
    }


    draw_rectangle(
        trade_x + 470,
        trade_row_y - 5,
        trade_x + 524,
        trade_row_y + 20,
        false
    );


    draw_set_color(c_white);

    draw_text(
        trade_x + 480,
        trade_row_y,
        "SELL"
    );
}


// =====================================================
// FOOTER
// =====================================================

draw_set_color(muted_color);

draw_text(
    trade_x + 20,
    trade_y + 338,
    "BUY CHEAPEST / SELL HIGHEST / 100 UNITS"
);


draw_set_color(c_white);

draw_text(
    trade_x + 20,
    trade_y + 356,
    trade_result
);


// =====================================================
// RESET
// =====================================================

draw_set_font(-1);
draw_set_color(c_white);
draw_set_alpha(1);