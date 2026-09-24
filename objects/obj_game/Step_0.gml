/// obj_game - Step Event


var mouse_gui_x =
    device_mouse_x_to_gui(0);

var mouse_gui_y =
    device_mouse_y_to_gui(0);


// =====================================================
// TAB GEOMETRY
// Должно совпадать с Draw GUI End
// =====================================================

var tab_width =
    150;

var tab_height =
    38;

var tab_gap =
    12;


var total_width =
    tab_width * 2
    + tab_gap;


var economy_x =
    (1600 - total_width) * 0.5;


var crafting_x =
    economy_x
    + tab_width
    + tab_gap;


var tab_y =
    18;


// =====================================================
// CLICK
// =====================================================

if (mouse_check_button_pressed(mb_left))
{
    // =================================================
    // ECONOMY
    // =================================================

    if (
        mouse_gui_x >= economy_x &&
        mouse_gui_x <= economy_x + tab_width &&
        mouse_gui_y >= tab_y &&
        mouse_gui_y <= tab_y + tab_height
    )
    {
        global.ui_screen =
            0;
    }


    // =================================================
    // CRAFTING
    // =================================================

    else if (
        mouse_gui_x >= crafting_x &&
        mouse_gui_x <= crafting_x + tab_width &&
        mouse_gui_y >= tab_y &&
        mouse_gui_y <= tab_y + tab_height
    )
    {
        global.ui_screen =
            1;
    }
}


// =====================================================
// DEBUG HOTKEYS
// =====================================================

if (keyboard_check_pressed(vk_f1))
{
    global.ui_screen =
        0;
}


if (keyboard_check_pressed(vk_f2))
{
    global.ui_screen =
        1;
}