draw_set_font(fnt_ui_small);
/// obj_ui - Draw Event

draw_set_color(c_white);


// ---------------------------------
// Title
// ---------------------------------

draw_text(
    40,
    30,
    "CRAFTING PROTOTYPE"
);


// ---------------------------------
// Current recipe
// ---------------------------------

var recipe = global.recipes[global.selected_recipe];

draw_text(
    40,
    80,
    "ITEM: " + recipe.name
);


// ---------------------------------
// Materials
// ---------------------------------

draw_text(
    40,
    120,
    "MATERIALS:"
);


for (var i = 0; i < array_length(recipe.materials); i++)
{
    var material = recipe.materials[i];

    var material_data =
        global.materials[$ material.tag];

    // Цвет материала
    draw_set_color(material_data.color);

    draw_text(
        60,
        150 + i * 25,
        material_data.name
        + "  "
        + string(material.percentage)
        + "%"
    );
}


// ---------------------------------
// Craft chance
// ---------------------------------

var tag_count = array_length(recipe.materials);

var discovered_count =
    array_length(global.discovered_items);

var failure_chance =
    get_final_failure_chance(
        tag_count,
        discovered_count
    );


draw_set_color(c_white);

draw_text(
    40,
    310,
    "TAGS: " + string(tag_count)
);

draw_text(
    40,
    335,
    "FAILURE CHANCE: "
    + string(failure_chance)
    + "%"
);

draw_text(
    40,
    360,
    "DISCOVERED: "
    + string(discovered_count)
);


// ---------------------------------
// Craft button
// ---------------------------------

draw_set_color(c_white);

draw_rectangle(
    40,
    410,
    220,
    465,
    false
);


// Текст кнопки должен быть чёрным,
// потому что сама кнопка белая

draw_set_color(c_black);

draw_text(
    90,
    430,
    "CRAFT"
);


// ---------------------------------
// Result
// ---------------------------------

draw_set_color(c_white);

draw_text(
    40,
    500,
    global.craft_result
);


// ---------------------------------
// Reset draw color
// ---------------------------------

draw_set_color(c_white);
draw_set_font(-1);
draw_set_color(c_white);