/// obj_ui - Draw GUI Event


// =====================================================
// SETUP
// =====================================================

draw_set_font(
    fnt_ui_small
);

draw_set_color(
    c_white
);


// =====================================================
// TITLE
// =====================================================

draw_text(
    40,
    30,
    "CRAFTING PROTOTYPE"
);


// =====================================================
// CURRENT RECIPE
// =====================================================

var recipe =
    global.recipes[
        global.selected_recipe
    ];


draw_set_color(
    c_white
);


draw_text(
    40,
    80,
    "ITEM: "
    + recipe.name
);


// =====================================================
// MATERIALS TITLE
// =====================================================

draw_set_color(
    c_white
);


draw_text(
    40,
    120,
    "MATERIALS:"
);


// =====================================================
// MATERIAL LIST
// =====================================================

for (
    var i = 0;
    i < array_length(recipe.materials);
    i++
)
{
    var material =
        recipe.materials[i];


var material_data =
    global.materials[$ material.tag];


    // Цвет конкретного материала
    draw_set_color(
        material_data.color
    );


    draw_text(
        60,
        150 + i * 25,

        material_data.name
        + "  "
        + string(
            material.percentage
        )
        + "%"
    );
}


// =====================================================
// TAG
//
// TAG = количество ингредиентов
// =====================================================

var tag_count =
    array_length(
        recipe.materials
    );


// =====================================================
// DISCOVERED COUNT
// =====================================================

var discovered_count =
    array_length(
        global.discovered_items
    );


// =====================================================
// BASE FAILURE
// =====================================================

var base_failure =
    get_final_failure_chance(
        tag_count,
        discovered_count
    );


// =====================================================
// EVENT FAILURE
// =====================================================

var event_failure =
    market_event_get_failure_bonus();


// =====================================================
// FINAL FAILURE
// =====================================================

var failure_chance =
    base_failure
    + event_failure;


failure_chance =
    clamp(
        failure_chance,
        0,
        95
    );


// =====================================================
// TAG INFO
// =====================================================

draw_set_color(
    c_white
);


draw_text(
    40,
    285,
    "TAG: "
    + string(tag_count)
);


// =====================================================
// INGREDIENT COUNT
// =====================================================

draw_set_color(
    c_gray
);


draw_text(
    40,
    310,
    "INGREDIENTS: "
    + string(tag_count)
);


// =====================================================
// BASE FAILURE
// =====================================================

draw_set_color(
    c_white
);


draw_text(
    40,
    335,
    "BASE FAILURE: "
    + string(base_failure)
    + "%"
);


// =====================================================
// FINAL FAILURE
// =====================================================

if (event_failure > 0)
{
    draw_set_color(
        c_red
    );
}
else
{
    draw_set_color(
        c_white
    );
}


draw_text(
    40,
    360,
    "FINAL FAILURE: "
    + string(failure_chance)
    + "%"
);


// =====================================================
// ACTIVE EVENT
// =====================================================

if (event_failure > 0)
{
    draw_set_color(
        c_yellow
    );


    draw_text(
        40,
        385,

        global.market_event_name
        + ": +"
        + string(event_failure)
        + "%"
    );
}


// =====================================================
// DISCOVERED
// =====================================================

draw_set_color(
    c_white
);


draw_text(
    40,
    410,
    "DISCOVERED: "
    + string(discovered_count)
);


// =====================================================
// CRAFT BUTTON
// =====================================================

draw_set_color(
    c_white
);


draw_rectangle(
    40,
    445,
    220,
    500,
    false
);


// =====================================================
// CRAFT BUTTON TEXT
// =====================================================

draw_set_color(
    c_black
);


draw_text(
    90,
    465,
    "CRAFT"
);


// =====================================================
// CRAFT RESULT
// =====================================================

draw_set_color(
    c_white
);


draw_text(
    40,
    520,
    global.craft_result
);


// =====================================================
// RESET
// =====================================================

draw_set_font(-1);
draw_set_color(c_white);
draw_set_alpha(1);