/// obj_minigame_ui - Step

// Не принимаем клики, пока открыт ECONOMY
if (global.ui_screen != 1) exit;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

/// obj_game - Step Event


// ---------------------------------
// Previous recipe
// ---------------------------------

if (keyboard_check_pressed(vk_left))
{
    global.selected_recipe--;

    if (global.selected_recipe < 0)
    {
        global.selected_recipe =
            array_length(global.recipes) - 1;
    }
}


// ---------------------------------
// Next recipe
// ---------------------------------

if (keyboard_check_pressed(vk_right))
{
    global.selected_recipe++;

    if (global.selected_recipe >= array_length(global.recipes))
    {
        global.selected_recipe = 0;
    }
}


// ---------------------------------
// Craft with SPACE
// ---------------------------------

if (keyboard_check_pressed(vk_space))
{
    var recipe =
        global.recipes[global.selected_recipe];

    var result =
        craft_item(
            recipe,
            array_length(global.discovered_items)
        );


    if (result.success)
    {
        global.craft_result =
            "SUCCESS! " + result.item_name;


        // Check if already discovered

        var already_discovered = false;

        for (
            var i = 0;
            i < array_length(global.discovered_items);
            i++
        )
        {
            if (
                global.discovered_items[i]
                == result.item_id
            )
            {
                already_discovered = true;
                break;
            }
        }


        // Add to book

        if (!already_discovered)
        {
            array_push(
                global.discovered_items,
                result.item_id
            );
        }
    }
    else
    {
        global.craft_result =
            "FAILED! " + result.item_name;
    }
}
/// obj_game - Step Event

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var bx = 650;
var by = 10;

var bw = 140;
var bh = 32;
var gap = 10;

var craft_x = bx + bw + gap;


// =============================================
// SCREEN SWITCHER
// =============================================

if (mouse_check_button_pressed(mb_left))
{
    // ECONOMY
    if (mx >= bx &&
        mx <= bx + bw &&
        my >= by &&
        my <= by + bh)
    {
        global.ui_screen = 0;
    }

    // CRAFTING
    if (mx >= craft_x &&
        mx <= craft_x + bw &&
        my >= by &&
        my <= by + bh)
    {
        global.ui_screen = 1;
    }
}