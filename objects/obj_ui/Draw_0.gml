/// obj_ui - Draw Event

draw_set_color(c_white);

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


for (var i = 0; i < array_length(recipe.materials); i++) {
    
    var material = recipe.materials[i];
    
    var material_data =
        global.materials[$ material.tag];
    
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
// Craft button placeholder
// ---------------------------------

draw_set_color(c_white);

draw_rectangle(
    40,
    410,
    220,
    465,
    false
);

draw_text(
    90,
    430,
    "CRAFT"
);


// ---------------------------------
// Result
// ---------------------------------

draw_text(
    40,
    500,
    global.craft_result
);


// ---------------------------------
// Book
// ---------------------------------

draw_text(
    400,
    80,
    "ITEM BOOK"
);

draw_text(
    400,
    105,
    "Discovered: "
    + string(discovered_count)
);


for (var j = 0; j < discovered_count; j++) {
    
    var discovered_id =
        global.discovered_items[j];
    
    var discovered_name = discovered_id;
    
    // Находим красивое имя предмета
    for (var k = 0; k < array_length(global.recipes); k++) {
        
        if (global.recipes[k].id == discovered_id) {
            discovered_name =
                global.recipes[k].name;
            break;
        }
    }
    
    draw_text(
        420,
        140 + j * 25,
        "✓ " + discovered_name
    );
}