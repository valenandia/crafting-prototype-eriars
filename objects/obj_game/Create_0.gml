/// obj_game - Create Event

display_set_gui_size(1600, 900);
window_set_size(1600, 900);
window_center();

global.materials = create_materials();
global.recipes = create_recipes();

global.v3_recipes = craft_v3_recipes();

global.discovered_items = [];

global.item_inventory = {};

for (var i = 0; i < 20; i++)
{
    var item_id =
        "item_" + string_format(i + 1, 2, 0);

    variable_struct_set(global.item_inventory, item_id, 0);
}

for (var i = 0; i < 10; i++)
{
    global.recipes[i].name = global.v3_recipes[i].name;
}

global.material_pool = {
    stone: 1000,
    polyester: 800,
    tree: 600,
    cloth: 500,
    glass: 450,
    jewels: 300,
    mushrooms: 150,
    blood: 100
};

global.credits = 1000;

global.craft_attempts = 0;
global.craft_log = [];

global.selected_recipe = 0;
global.craft_result = "";

global.ui_screen = 1;