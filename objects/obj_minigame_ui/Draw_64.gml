/// obj_minigame_ui - Draw GUI Event

if (global.ui_screen != 1) exit;

draw_set_font(fnt_ui_small);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var bg = make_color_rgb(24, 29, 38);
var panel = make_color_rgb(37, 44, 56);
var panel_light = make_color_rgb(61, 73, 90);
var border = make_color_rgb(100, 115, 135);
var purple = make_color_rgb(124, 86, 170);
var green = make_color_rgb(100, 220, 140);
var red = make_color_rgb(236, 75, 91);
var yellow = make_color_rgb(235, 203, 81);
var muted = make_color_rgb(160, 170, 185);

var module_colors = [
    make_color_rgb(80,207,225),
    make_color_rgb(224,91,196),
    make_color_rgb(235,203,81)
];

var module_names = ["C", "M", "Y"];
var buff_labels = ["FAIL", "BACK", "FIND"];


// =====================================================
// BACKGROUND
// =====================================================

draw_set_color(bg);
draw_rectangle(0, 0, 1600, 900, false);

draw_set_color(c_white);
draw_text(40, 70, "CRAFTING SYSTEM V2");

draw_set_color(muted);
draw_text(40, 98, "SHAPE + MATERIALS + BUFF GEOMETRY");


// =====================================================
// RESOURCES
// =====================================================

draw_set_color(panel);
draw_rectangle(
    ui.pool_x, ui.pool_y,
    ui.pool_x + ui.pool_w, 815, false
);

draw_set_color(c_white);
draw_text(ui.pool_x + 18, ui.pool_y + 18, "RESOURCES");

draw_set_color(muted);
draw_text(ui.pool_x + 18, ui.pool_y + 43, "CLICK OR DRAG");

for (var row_i = 0; row_i < visible_rows; row_i++)
{
    var resource_index = resource_scroll + row_i;

    if (resource_index >= array_length(resources)) break;

    var row_y = ui.resource_y + row_i * ui.resource_step;

    var selected =
        selected_kind == 2 &&
        selected_value == resource_index;

    if (selected)
        draw_set_color(purple);
    else
        draw_set_color(panel_light);

    draw_rectangle(
        ui.pool_x + 15, row_y,
        ui.pool_x + ui.pool_w - 15,
        row_y + 40, false
    );

    draw_set_color(resource_colors[resource_index]);

    draw_rectangle(
        ui.pool_x + 15, row_y,
        ui.pool_x + 21, row_y + 40, false
    );

    draw_text(
        ui.pool_x + 32,
        row_y + 11,
        resources[resource_index]
    );

    draw_set_color(c_white);

    draw_text(
        ui.pool_x + ui.pool_w - 75,
        row_y + 11,
        string(get_pool_amount(resource_groups[resource_index]))
    );
}

draw_set_color(muted);
draw_text(ui.pool_x + 18, 635, "MOUSE WHEEL TO SCROLL");
draw_text(ui.pool_x + 18, 660, "1 CELL = 10 MATERIALS");
draw_text(ui.pool_x + 18, 685, "RMB = REMOVE");
draw_text(ui.pool_x + 18, 710, "DRAG TO MOVE / SWAP");


// =====================================================
// PRESETS
// =====================================================

draw_set_color(c_white);
draw_text(ui.preset_x, 210, "SHAPE PRESETS");

for (var preset_i = 0; preset_i < array_length(presets); preset_i++)
{
    var preset_y =
        ui.preset_y + preset_i * (ui.preset_h + 8);

    var active =
        craft_v2_match_preset(upper_modules) == preset_i;

    if (active)
        draw_set_color(purple);
    else
        draw_set_color(panel_light);

    draw_rectangle(
        ui.preset_x, preset_y,
        ui.preset_x + ui.preset_w,
        preset_y + ui.preset_h, false
    );

    draw_set_color(c_white);
    draw_text(
        ui.preset_x + 15,
        preset_y + 12,
        presets[preset_i].name
    );
}


// =====================================================
// MODULES
// =====================================================

draw_set_color(c_white);
draw_text(ui.module_x, 530, "MODULES");

for (var module_i = 0; module_i < 3; module_i++)
{
    var module_y =
        ui.module_y + module_i * ui.module_step;

    var selected_module =
        selected_kind == 1 &&
        selected_value == module_i;

    if (selected_module)
        draw_set_color(purple);
    else
        draw_set_color(panel_light);

    draw_rectangle(
        ui.module_x, module_y,
        ui.module_x + 120,
        module_y + 44, false
    );

    draw_set_color(module_colors[module_i]);

    draw_rectangle(
        ui.module_x + 12,
        module_y + 10,
        ui.module_x + 36,
        module_y + 34,
        false
    );

    draw_set_color(c_white);
    draw_text(
        ui.module_x + 55,
        module_y + 13,
        module_names[module_i]
    );
}


// =====================================================
// BUFFS
// =====================================================

draw_set_color(c_white);
draw_text(405, 730, "BUFFS");

for (var buff_i = 0; buff_i < 3; buff_i++)
{
    var buff_x = 405 + buff_i * 58;
    var buff_code = -2 - buff_i;

    var selected_buff =
        selected_kind == 3 &&
        selected_value == buff_code;

    if (selected_buff)
        draw_set_color(purple);
    else
        draw_set_color(panel_light);

    draw_rectangle(
        buff_x, ui.buff_y,
        buff_x + 52,
        ui.buff_y + 42, false
    );

    draw_set_color(red);
    draw_text(
        buff_x + 5,
        ui.buff_y + 12,
        buff_labels[buff_i]
    );
}


// =====================================================
// UPPER GRID
// =====================================================

draw_set_color(c_white);
draw_text(ui.upper_x, 210, "UPPER GRID");

draw_set_color(muted);
draw_text(ui.upper_x, 232, "PRODUCT SHAPE / 6 MODULES");

for (var upper_i = 0; upper_i < 6; upper_i++)
{
    var upper_col = upper_i mod 3;
    var upper_row = upper_i div 3;

    var cell_x = ui.upper_x + upper_col * ui.upper_cell;
    var cell_y = ui.upper_y + upper_row * ui.upper_cell;

    var module_type = upper_modules[upper_i];

    draw_set_color(panel_light);

    draw_rectangle(
        cell_x + 3, cell_y + 3,
        cell_x + ui.upper_cell - 3,
        cell_y + ui.upper_cell - 3, false
    );

    draw_set_color(border);

    draw_rectangle(
        cell_x + 3, cell_y + 3,
        cell_x + ui.upper_cell - 3,
        cell_y + ui.upper_cell - 3, true
    );

    if (module_type >= 0 && module_type <= 2)
    {
        draw_set_color(module_colors[module_type]);

        draw_rectangle(
            cell_x + 16, cell_y + 16,
            cell_x + ui.upper_cell - 16,
            cell_y + ui.upper_cell - 16, false
        );

        draw_set_color(bg);
        draw_set_halign(fa_center);

        draw_text(
            cell_x + ui.upper_cell * 0.5,
            cell_y + 29,
            module_names[module_type]
        );

        draw_set_halign(fa_left);
    }
}


// =====================================================
// CONNECTIONS
// =====================================================

var occupied = get_lower_occupied();

var connection_count = craft_v2_connections(
    upper_modules, occupied
);

draw_set_color(green);

draw_text(
    ui.upper_x,
    425,
    "ACTIVE LINKS: " + string(connection_count) + "/6"
);

draw_set_color(muted);
draw_text(
    ui.upper_x,
    447,
    "LINKS MATCH BY CELL POSITION"
);


// =====================================================
// LOWER GRID
// =====================================================

draw_set_color(c_white);
draw_text(ui.lower_x, 492, "LOWER GRID");

draw_set_color(muted);
draw_text(ui.lower_x, 514, "INGREDIENTS + BUFF GEOMETRY");

var shape_index = get_shape();

for (var lower_i = 0; lower_i < 9; lower_i++)
{
    var lower_col = lower_i mod 3;
    var lower_row = lower_i div 3;

    var lower_x = ui.lower_x + lower_col * ui.lower_cell;
    var lower_y = ui.lower_y + lower_row * ui.lower_cell;

    var lower_value = lower_cells[lower_i];

    if (shape_index != -1 && lower_value != -1)
        draw_set_color(purple);
    else
        draw_set_color(panel_light);

    draw_rectangle(
        lower_x + 3, lower_y + 3,
        lower_x + ui.lower_cell - 3,
        lower_y + ui.lower_cell - 3, false
    );

    draw_set_color(border);

    draw_rectangle(
        lower_x + 3, lower_y + 3,
        lower_x + ui.lower_cell - 3,
        lower_y + ui.lower_cell - 3, true
    );

    if (lower_value >= 0)
    {
        draw_set_color(resource_colors[lower_value]);

        draw_text(
            lower_x + 8,
            lower_y + 25,
            resources[lower_value]
        );

        draw_set_color(muted);

        draw_text(
            lower_x + 8,
            lower_y + 48,
            "10 units"
        );
    }
    else if (lower_value <= -2)
    {
        var buff_index = -2 - lower_value;

        if (buff_index >= 0 && buff_index < 3)
        {
            draw_set_color(red);
            draw_set_halign(fa_center);

            draw_text(
                lower_x + ui.lower_cell * 0.5,
                lower_y + 28,
                buff_labels[buff_index]
            );

            draw_set_halign(fa_left);
        }
    }
}

// =====================================================
// RECIPE INGREDIENTS
// =====================================================

var book_recipe = recipe_catalog[selected_item];

draw_set_color(c_white);
draw_text(ui.book_x + 20, 545, "REQUIRED MATERIALS");

for (var ing_i = 0;
     ing_i < array_length(book_recipe.ingredients);
     ing_i++)
{
    var ingredient = book_recipe.ingredients[ing_i];

    draw_set_color(muted);

    draw_text(
        ui.book_x + 20,
        575 + ing_i * 25,
        string_upper(ingredient.group) +
        " - " +
        string(ingredient.amount) + "%"
    );
}
// =====================================================
// CRAFT PREVIEW
// =====================================================

draw_set_color(panel);
draw_rectangle(1010, 135, 1550, 270, false);

draw_set_color(c_white);
draw_text(1030, 153, "CRAFT PREVIEW");

var current_item = get_current_item();
var matched_preset = craft_v2_match_preset(upper_modules);

if (matched_preset == -1)
{
    draw_set_color(red);
    draw_text(1030, 182, "SHAPE: INVALID");
}
else
{
    draw_set_color(green);

    draw_text(
        1030, 182,
        "SHAPE: " + presets[matched_preset].name
    );
}

if (current_item != -1)
{
    draw_set_color(yellow);

    draw_text(
        1030, 207,
        "RESULT: " + item_names[current_item]
    );
}
else
{
    draw_set_color(muted);
    draw_text(1030, 207, "RESULT: --");
}

draw_set_color(c_white);

draw_text(
    1030, 235,
    "FAIL CHANCE: " + string(get_failure()) + "%"
);


// =====================================================
// ITEM BOOK
// =====================================================

draw_set_color(panel);

draw_rectangle(
    ui.book_x, ui.book_y + 85,
    ui.book_x + ui.book_w, 710, false
);

draw_set_color(c_white);
draw_text(
    ui.book_x + 20,
    ui.book_y + 103,
    "ITEM BOOK"
);

var book_item_id =
    "item_" + string_format(selected_item + 1, 2, 0);

var discovered = false;

for (var known_i = 0;
     known_i < array_length(global.discovered_items);
     known_i++)
{
    if (global.discovered_items[known_i] == book_item_id)
    {
        discovered = true;
        break;
    }
}

draw_set_color(panel_light);

draw_rectangle(
    ui.book_x + 20, ui.book_y + 145,
    ui.book_x + ui.book_w - 20,
    ui.book_y + 195, false
);

draw_set_color(c_white);

draw_text(
    ui.book_x + 35,
    ui.book_y + 162,
    item_names[selected_item]
);

if (discovered)
    draw_set_color(green);
else
    draw_set_color(muted);

draw_text(
    ui.book_x + 20,
    ui.book_y + 215,
    discovered ? "DISCOVERED" : "NOT DISCOVERED"
);

draw_set_color(c_white);

draw_text(
    ui.book_x + 20,
    ui.book_y + 255,
    "PRODUCT CATEGORY"
);

var category_index = selected_item div 4;

draw_set_color(yellow);

draw_text(
    ui.book_x + 20,
    ui.book_y + 282,
    presets[category_index].name
);

draw_set_color(muted);

draw_text(
    ui.book_x + 20,
    ui.book_y + 330,
    "Use the corresponding upper preset."
);

draw_text(
    ui.book_x + 20,
    ui.book_y + 354,
    "Dominant material determines the variant."
);

draw_text(
    ui.book_x + 20,
    ui.book_y + 378,
    "Buffs affect crafting and discovery."
);

// =====================================================
// LOAD RECIPE BUTTON
// =====================================================

draw_set_color(purple);

draw_rectangle(
    ui.book_x + 20,
    665,
    ui.book_x + ui.book_w - 20,
    700,
    false
);

draw_set_color(c_white);
draw_set_halign(fa_center);

draw_text(
    ui.book_x + ui.book_w * 0.5,
    675,
    "LOAD RECIPE"
);

draw_set_halign(fa_left);
// =====================================================
// BOOK NAVIGATION
// =====================================================

draw_set_color(panel_light);

draw_rectangle(
    ui.book_x, 730,
    ui.book_x + ui.book_w, 775, false
);

draw_set_color(c_white);
draw_text(ui.book_x + 35, 745, "< PREV");

draw_text(
    ui.book_x + 240,
    745,
    string(selected_item + 1) + " / 20"
);

draw_text(
    ui.book_x + ui.book_w - 100,
    745,
    "NEXT >"
);


// =====================================================
// BUFF / CONNECTION INFO
// =====================================================

draw_set_color(panel);

draw_rectangle(
    ui.book_x, 795,
    ui.book_x + ui.book_w, 880, false
);

draw_set_color(c_white);

draw_text(
    ui.book_x + 20,
    807,
    "CONNECTIONS: " + string(connection_count) + "/6"
);

var shape_status = "OFF";

if (shape_index != -1)
    shape_status = "ON";

draw_text(
    ui.book_x + 20,
    831,
    "SHAPE BONUS: " + shape_status
);

draw_set_color(red);

draw_text(
    ui.book_x + 20, 855,
    "FAIL -" + string(get_buff_rate(0)) + "%"
);

draw_text(
    ui.book_x + 180, 855,
    "BACK " + string(get_buff_rate(1)) + "%"
);

draw_text(
    ui.book_x + 360, 855,
    "FIND " + string(get_buff_rate(2)) + "%"
);


// =====================================================
// RESET / CRAFT
// =====================================================

draw_set_color(panel_light);
draw_rectangle(430, 835, 550, 877, false);

draw_set_color(c_white);
draw_text(467, 848, "RESET");

draw_set_color(purple);

draw_rectangle(
    ui.craft_x, ui.craft_y,
    ui.craft_x + ui.craft_w,
    ui.craft_y + ui.craft_h, false
);

draw_set_color(c_white);

draw_text(
    ui.craft_x + 59,
    ui.craft_y + 13,
    "CRAFT"
);


// =====================================================
// CRAFT NOTE
// =====================================================

var note_color = yellow;

if (craft_result == 1)
    note_color = green;
else if (craft_result == 2)
    note_color = red;

draw_set_color(note_color);
draw_text(ui.lower_x, 793, craft_note);


// =====================================================
// DRAG PREVIEW
// =====================================================

if (drag_active && drag_started)
{
    var mouse_gui_x = device_mouse_x_to_gui(0);
    var mouse_gui_y = device_mouse_y_to_gui(0);

    draw_set_alpha(0.85);
    draw_set_color(panel_light);

    draw_rectangle(
        mouse_gui_x + 12, mouse_gui_y + 12,
        mouse_gui_x + 135, mouse_gui_y + 52,
        false
    );

    draw_set_color(c_white);

    var preview_text = "";

    if (drag_kind == 1)
        preview_text = module_names[drag_value];
    else if (drag_kind == 2)
        preview_text = resources[drag_value];
    else if (drag_kind == 3)
        preview_text = buff_labels[-2 - drag_value];

    draw_text(
        mouse_gui_x + 23,
        mouse_gui_y + 25,
        preview_text
    );

    draw_set_alpha(1);
}


// =====================================================
// DRAW RESET
// =====================================================

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
draw_set_color(c_white);
draw_set_alpha(1);