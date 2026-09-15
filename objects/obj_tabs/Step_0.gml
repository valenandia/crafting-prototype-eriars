/// obj_tabs - Step Event

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if (mouse_check_button_pressed(mb_left))
{
    // CRAFTING
    if (
        mx >= tab_craft_x1 &&
        mx <= tab_craft_x2 &&
        my >= tab_y1 &&
        my <= tab_y2
    )
    {
        global.ui_tab = 0;
    }

    // MARKET
    else if (
        mx >= tab_market_x1 &&
        mx <= tab_market_x2 &&
        my >= tab_y1 &&
        my <= tab_y2
    )
    {
        global.ui_tab = 1;
    }

    // RESOURCES
    else if (
        mx >= tab_resources_x1 &&
        mx <= tab_resources_x2 &&
        my >= tab_y1 &&
        my <= tab_y2
    )
    {
        global.ui_tab = 2;
    }
}