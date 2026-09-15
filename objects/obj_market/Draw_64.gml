draw_set_font(fnt_ui_small);
/// obj_market - Draw GUI Event

var mx = market_x;
var my = market_y;


// =====================================================
// TITLE
// =====================================================

draw_set_color(c_white);

draw_text(
    mx,
    my,
    "WORLD MARKET"
);
/// obj_market - Draw GUI Event

draw_set_font(fnt_ui_small);

var mx = market_x;
var my = market_y;


// =====================================================
// TITLE
// =====================================================

draw_set_color(c_white);

draw_text(
    mx,
    my,
    "WORLD MARKET"
);


// Timer

var seconds_left =
    ceil(market_timer / room_speed);

draw_set_color(c_gray);

draw_text(
    mx + 160,
    my,
    "UPDATE: "
    + string(seconds_left)
    + "s"
);


// =====================================================
// HEADERS
// =====================================================

draw_set_color(c_gray);

draw_text(mx,       my + 30, "RESOURCE");
draw_text(mx + 110, my + 30, "F");
draw_text(mx + 165, my + 30, "C");
draw_text(mx + 220, my + 30, "S");


// =====================================================
// MATERIALS
// =====================================================

for (
    var i = 0;
    i < array_length(global.market_materials);
    i++
)
{
    var tag =
        global.market_materials[i];

    var yy =
        my + 55 + (i * 27);


    // -------------------------------------------------
    // RESOURCE
    // -------------------------------------------------

    draw_set_color(c_white);

    draw_text(
        mx,
        yy,
        tag
    );


    // -------------------------------------------------
    // FANTASY
    // -------------------------------------------------

    var fantasy =
        market_get_multiplier(
            "FANTASY",
            tag
        );

    if (fantasy >= 1.25)
        draw_set_color(c_lime);
    else if (fantasy <= 0.80)
        draw_set_color(c_red);
    else
        draw_set_color(c_white);

    draw_text(
        mx + 110,
        yy,
        string(fantasy)
    );


    // -------------------------------------------------
    // CYBERPUNK
    // -------------------------------------------------

    var cyber =
        market_get_multiplier(
            "CYBERPUNK",
            tag
        );

    if (cyber >= 1.25)
        draw_set_color(c_lime);
    else if (cyber <= 0.80)
        draw_set_color(c_red);
    else
        draw_set_color(c_white);

    draw_text(
        mx + 165,
        yy,
        string(cyber)
    );


    // -------------------------------------------------
    // STEAMPUNK
    // -------------------------------------------------

    var steam =
        market_get_multiplier(
            "STEAMPUNK",
            tag
        );

    if (steam >= 1.25)
        draw_set_color(c_lime);
    else if (steam <= 0.80)
        draw_set_color(c_red);
    else
        draw_set_color(c_white);

    draw_text(
        mx + 220,
        yy,
        string(steam)
    );
}


// =====================================================
// LEGEND
// =====================================================

draw_set_color(c_gray);

draw_text(
    mx,
    my + 285,
    "F Fantasy   C Cyber   S Steam"
);


// =====================================================
// RESET
// =====================================================

draw_set_font(-1);
draw_set_color(c_white);