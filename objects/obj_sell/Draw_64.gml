/// obj_sell - Draw GUI Event

draw_set_font(fnt_ui_small);

var sx = sell_x;
var sy = sell_y;


// =====================================================
// CURRENT ITEM
// =====================================================

var recipe =
    global.recipes[global.selected_recipe];

var item_key =
    recipe.id;


// =====================================================
// INVENTORY
// =====================================================

var item_amount = 0;

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
// MARKET DATA
// =====================================================

var fantasy_mult =
    market_get_item_multiplier(
        recipe,
        "FANTASY"
    );

var cyber_mult =
    market_get_item_multiplier(
        recipe,
        "CYBERPUNK"
    );

var steam_mult =
    market_get_item_multiplier(
        recipe,
        "STEAMPUNK"
    );


var fantasy_price =
    get_item_world_sell_price(
        recipe,
        "FANTASY"
    );

var cyber_price =
    get_item_world_sell_price(
        recipe,
        "CYBERPUNK"
    );

var steam_price =
    get_item_world_sell_price(
        recipe,
        "STEAMPUNK"
    );


// =====================================================
// TITLE
// =====================================================

draw_set_color(c_white);

draw_text(
    sx,
    sy,
    "SELL ITEM"
);


// =====================================================
// ITEM + OWNED
// =====================================================

draw_text(
    sx,
    sy + 25,
    recipe.name
);

draw_set_color(c_gray);

draw_text(
    sx + 120,
    sy + 25,
    "OWNED: " + string(item_amount)
);


// =====================================================
// FANTASY
// =====================================================

draw_set_color(c_white);

draw_text(
    sx,
    sy + 65,
    "FANTASY"
);

draw_text(
    sx + 110,
    sy + 65,
    "x" + string(fantasy_mult)
);

draw_set_color(c_yellow);

draw_text(
    sx + 190,
    sy + 65,
    string(fantasy_price)
);


// Button

if (item_amount > 0)
{
    draw_set_color(c_white);
}
else
{
    draw_set_color(c_gray);
}

draw_rectangle(
    fantasy_button_x1,
    fantasy_button_y1,
    fantasy_button_x2,
    fantasy_button_y2,
    false
);

draw_set_color(c_black);

draw_text(
    fantasy_button_x1 + 22,
    fantasy_button_y1 + 9,
    "SELL"
);


// =====================================================
// CYBERPUNK
// =====================================================

draw_set_color(c_white);

draw_text(
    sx,
    sy + 110,
    "CYBERPUNK"
);

draw_text(
    sx + 110,
    sy + 110,
    "x" + string(cyber_mult)
);

draw_set_color(c_yellow);

draw_text(
    sx + 190,
    sy + 110,
    string(cyber_price)
);


// Button

if (item_amount > 0)
{
    draw_set_color(c_white);
}
else
{
    draw_set_color(c_gray);
}

draw_rectangle(
    cyber_button_x1,
    cyber_button_y1,
    cyber_button_x2,
    cyber_button_y2,
    false
);

draw_set_color(c_black);

draw_text(
    cyber_button_x1 + 22,
    cyber_button_y1 + 9,
    "SELL"
);


// =====================================================
// STEAMPUNK
// =====================================================

draw_set_color(c_white);

draw_text(
    sx,
    sy + 155,
    "STEAMPUNK"
);

draw_text(
    sx + 110,
    sy + 155,
    "x" + string(steam_mult)
);

draw_set_color(c_yellow);

draw_text(
    sx + 190,
    sy + 155,
    string(steam_price)
);


// Button

if (item_amount > 0)
{
    draw_set_color(c_white);
}
else
{
    draw_set_color(c_gray);
}

draw_rectangle(
    steam_button_x1,
    steam_button_y1,
    steam_button_x2,
    steam_button_y2,
    false
);

draw_set_color(c_black);

draw_text(
    steam_button_x1 + 22,
    steam_button_y1 + 9,
    "SELL"
);


// =====================================================
// RESULT
// =====================================================

draw_set_color(c_white);

draw_text(
    sx,
    sy + 205,
    sell_result
);


// =====================================================
// RESET
// =====================================================

draw_set_font(-1);
draw_set_color(c_white);