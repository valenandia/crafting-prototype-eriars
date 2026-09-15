draw_set_font(fnt_ui_small);
/// obj_material_pool - Draw Event

var px = 1100;
var py = 100;


// =============================================
// TITLE
// =============================================

draw_set_color(c_white);

draw_text(
    px,
    py,
    "MATERIAL POOL"
);


// =============================================
// STONE
// =============================================

draw_set_color(global.materials[$ "stone"].color);

draw_text(
    px,
    py + 40,
    "Stone"
);

draw_set_color(c_white);

draw_text(
    px + 150,
    py + 40,
    string(global.material_pool.stone)
);


// =============================================
// POLYESTER
// =============================================

draw_set_color(global.materials[$ "polyester"].color);

draw_text(
    px,
    py + 70,
    "Polyester"
);

draw_set_color(c_white);

draw_text(
    px + 150,
    py + 70,
    string(global.material_pool.polyester)
);


// =============================================
// TREE
// =============================================

draw_set_color(global.materials[$ "tree"].color);

draw_text(
    px,
    py + 100,
    "Tree"
);

draw_set_color(c_white);

draw_text(
    px + 150,
    py + 100,
    string(global.material_pool.tree)
);


// =============================================
// CLOTH
// =============================================

draw_set_color(global.materials[$ "cloth"].color);

draw_text(
    px,
    py + 130,
    "Cloth"
);

draw_set_color(c_white);

draw_text(
    px + 150,
    py + 130,
    string(global.material_pool.cloth)
);


// =============================================
// GLASS
// =============================================

draw_set_color(global.materials[$ "glass"].color);

draw_text(
    px,
    py + 160,
    "Glass"
);

draw_set_color(c_white);

draw_text(
    px + 150,
    py + 160,
    string(global.material_pool.glass)
);


// =============================================
// JEWELS
// =============================================

draw_set_color(global.materials[$ "jewels"].color);

draw_text(
    px,
    py + 190,
    "Jewels"
);

draw_set_color(c_white);

draw_text(
    px + 150,
    py + 190,
    string(global.material_pool.jewels)
);


// =============================================
// MUSHROOMS
// =============================================

draw_set_color(global.materials[$ "mushrooms"].color);

draw_text(
    px,
    py + 220,
    "Mushrooms"
);

draw_set_color(c_white);

draw_text(
    px + 150,
    py + 220,
    string(global.material_pool.mushrooms)
);


// =============================================
// BLOOD
// =============================================

draw_set_color(global.materials[$ "blood"].color);

draw_text(
    px,
    py + 250,
    "Blood"
);

draw_set_color(c_white);

draw_text(
    px + 150,
    py + 250,
    string(global.material_pool.blood)
);


draw_set_font(-1);
draw_set_color(c_white);