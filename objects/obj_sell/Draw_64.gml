/// obj_sell - Draw GUI Event


// =====================================================
// ONLY DRAW ON ECONOMY SCREEN
// =====================================================

if (global.ui_screen != 0)
{
    exit;
}


draw_set_font(fnt_ui_small);
draw_set_alpha(1);


// =====================================================
// COLORS
// =====================================================

var panel_color =
    make_color_rgb(
        37,
        44,
        56
    );

var card_color =
    make_color_rgb(
        70,
        84,
        103
    );

var purple_color =
    make_color_rgb(
        124,
        86,
        170
    );

var disabled_color =
    make_color_rgb(
        70,
        75,
        85
    );

var muted_color =
    make_color_rgb(
        170,
        180,
        195
    );

var green_color =
    make_color_rgb(
        100,
        220,
        140
    );


// =====================================================
// DATA
// =====================================================

var recipe_count =
    array_length(
        global.recipes
    );


if (recipe_count <= 0)
{
    draw_set_font(-1);
    draw_set_color(c_white);
    draw_set_alpha(1);
    exit;
}


sell_item_index =
    clamp(
        sell_item_index,
        0,
        recipe_count - 1
    );


var sell_recipe =
    global.recipes[
        sell_item_index
    ];


var item_key =
    sell_recipe.id;


var item_amount =
    0;


if (
    variable_struct_exists(
        global.item_inventory,
        item_key
    )
)
{
    item_amount =
        variable_struct_get(
            global.item_inventory,
            item_key
        );
}


// =====================================================
// MARKET VALUES
// =====================================================

var fantasy_mult =
    market_get_item_multiplier(
        sell_recipe,
        "FANTASY"
    );


var cyber_mult =
    market_get_item_multiplier(
        sell_recipe,
        "CYBERPUNK"
    );


var steam_mult =
    market_get_item_multiplier(
        sell_recipe,
        "STEAMPUNK"
    );


var fantasy_price =
    get_item_world_sell_price(
        sell_recipe,
        "FANTASY"
    );


var cyber_price =
    get_item_world_sell_price(
        sell_recipe,
        "CYBERPUNK"
    );


var steam_price =
    get_item_world_sell_price(
        sell_recipe,
        "STEAMPUNK"
    );


// =====================================================
// PANEL
// =====================================================

draw_set_color(
    panel_color
);

draw_rectangle(
    sell_x,
    sell_y,
    sell_x + sell_panel_w,
    sell_y + sell_panel_h,
    false
);


draw_set_color(c_white);

draw_text(
    sell_x + 20,
    sell_y + 17,
    "SELL CRAFTED ITEM"
);


// =====================================================
// ITEM HEADER
// =====================================================

draw_set_color(
    card_color
);

draw_rectangle(
    sell_x + 20,
    sell_y + 52,
    sell_x + 430,
    sell_y + 100,
    false
);


// =====================================================
// ITEM NAME
// =====================================================

draw_set_color(c_white);

draw_text(
    sell_x + 35,
    sell_y + 68,
    sell_recipe.name
);


// =====================================================
// OWNED
// =====================================================

if (item_amount > 0)
{
    draw_set_color(
        green_color
    );
}
else
{
    draw_set_color(
        muted_color
    );
}


draw_text(
    sell_x + 300,
    sell_y + 68,

    "OWNED: "
    +
    string(
        item_amount
    )
);


// =====================================================
// ITEM NUMBER / NAVIGATION HINT
// =====================================================

draw_set_color(
    muted_color
);

draw_text(
    sell_x + 35,
    sell_y + 87,

    "< "
    +
    string(
        sell_item_index + 1
    )
    +
    " / "
    +
    string(
        recipe_count
    )
    +
    " >"
);


// =====================================================
// FANTASY
// =====================================================

draw_set_color(
    card_color
);

draw_rectangle(
    sell_x + 20,
    sell_y + 115,
    sell_x + 430,
    sell_y + 175,
    false
);


draw_set_color(c_white);

draw_text(
    sell_x + 35,
    sell_y + 137,
    "FANTASY"
);


draw_set_color(
    muted_color
);

draw_text(
    sell_x + 150,
    sell_y + 137,

    "x"
    +
    string(
        fantasy_mult
    )
);


draw_set_color(
    c_yellow
);

draw_text(
    sell_x + 230,
    sell_y + 137,

    string(
        fantasy_price
    )
);


if (item_amount > 0)
{
    draw_set_color(
        purple_color
    );
}
else
{
    draw_set_color(
        disabled_color
    );
}


draw_rectangle(
    fantasy_button_x1,
    fantasy_button_y1,
    fantasy_button_x2,
    fantasy_button_y2,
    false
);


draw_set_color(c_white);

draw_text(
    fantasy_button_x1 + 30,
    fantasy_button_y1 + 10,
    "SELL"
);


// =====================================================
// CYBERPUNK
// =====================================================

draw_set_color(
    card_color
);

draw_rectangle(
    sell_x + 20,
    sell_y + 180,
    sell_x + 430,
    sell_y + 240,
    false
);


draw_set_color(c_white);

draw_text(
    sell_x + 35,
    sell_y + 202,
    "CYBERPUNK"
);


draw_set_color(
    muted_color
);

draw_text(
    sell_x + 150,
    sell_y + 202,

    "x"
    +
    string(
        cyber_mult
    )
);


draw_set_color(
    c_yellow
);

draw_text(
    sell_x + 230,
    sell_y + 202,

    string(
        cyber_price
    )
);


if (item_amount > 0)
{
    draw_set_color(
        purple_color
    );
}
else
{
    draw_set_color(
        disabled_color
    );
}


draw_rectangle(
    cyber_button_x1,
    cyber_button_y1,
    cyber_button_x2,
    cyber_button_y2,
    false
);


draw_set_color(c_white);

draw_text(
    cyber_button_x1 + 30,
    cyber_button_y1 + 10,
    "SELL"
);


// =====================================================
// STEAMPUNK
// =====================================================

draw_set_color(
    card_color
);

draw_rectangle(
    sell_x + 20,
    sell_y + 245,
    sell_x + 430,
    sell_y + 305,
    false
);


draw_set_color(c_white);

draw_text(
    sell_x + 35,
    sell_y + 267,
    "STEAMPUNK"
);


draw_set_color(
    muted_color
);

draw_text(
    sell_x + 150,
    sell_y + 267,

    "x"
    +
    string(
        steam_mult
    )
);


draw_set_color(
    c_yellow
);

draw_text(
    sell_x + 230,
    sell_y + 267,

    string(
        steam_price
    )
);


if (item_amount > 0)
{
    draw_set_color(
        purple_color
    );
}
else
{
    draw_set_color(
        disabled_color
    );
}


draw_rectangle(
    steam_button_x1,
    steam_button_y1,
    steam_button_x2,
    steam_button_y2,
    false
);


draw_set_color(c_white);

draw_text(
    steam_button_x1 + 30,
    steam_button_y1 + 10,
    "SELL"
);


// =====================================================
// RESULT
// =====================================================

draw_set_color(
    green_color
);

draw_text(
    sell_x + 20,
    sell_y + 315,
    sell_result
);


// =====================================================
// RESET DRAW STATE
// =====================================================

draw_set_font(-1);
draw_set_color(c_white);
draw_set_alpha(1);