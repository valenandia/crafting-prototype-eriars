
/// obj_sell - Step Event

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);


// =====================================================
// MOUSE CLICK
// =====================================================

if (mouse_check_button_pressed(mb_left))
{
    var recipe =
        global.recipes[global.selected_recipe];

    var item_key =
        recipe.id;


    // =================================================
    // INVENTORY
    // =================================================

    var item_amount = 0;

    if (
        variable_struct_exists(
            global.item_inventory,
            item_key
        )
    )
    {
        item_amount =
            variable_struct_get(
                global.item_inventory,
                item_key
            );
    }


    // =================================================
    // FANTASY
    // =================================================

    if (
        mx >= fantasy_button_x1 &&
        mx <= fantasy_button_x2 &&
        my >= fantasy_button_y1 &&
        my <= fantasy_button_y2
    )
    {
        if (item_amount > 0)
        {
            var price =
                get_item_world_sell_price(
                    recipe,
                    "FANTASY"
                );

            variable_struct_set(
                global.item_inventory,
                item_key,
                item_amount - 1
            );

            global.credits += price;

            sell_result =
                "SOLD TO FANTASY: +"
                + string(price)
                + " cr";
        }
        else
        {
            sell_result =
                "NO ITEMS TO SELL";
        }
    }


    // =================================================
    // CYBERPUNK
    // =================================================

    else if (
        mx >= cyber_button_x1 &&
        mx <= cyber_button_x2 &&
        my >= cyber_button_y1 &&
        my <= cyber_button_y2
    )
    {
        if (item_amount > 0)
        {
            var price =
                get_item_world_sell_price(
                    recipe,
                    "CYBERPUNK"
                );

            variable_struct_set(
                global.item_inventory,
                item_key,
                item_amount - 1
            );

            global.credits += price;

            sell_result =
                "SOLD TO CYBERPUNK: +"
                + string(price)
                + " cr";
        }
        else
        {
            sell_result =
                "NO ITEMS TO SELL";
        }
    }


    // =================================================
    // STEAMPUNK
    // =================================================

    else if (
        mx >= steam_button_x1 &&
        mx <= steam_button_x2 &&
        my >= steam_button_y1 &&
        my <= steam_button_y2
    )
    {
        if (item_amount > 0)
        {
            var price =
                get_item_world_sell_price(
                    recipe,
                    "STEAMPUNK"
                );

            variable_struct_set(
                global.item_inventory,
                item_key,
                item_amount - 1
            );

            global.credits += price;

            sell_result =
                "SOLD TO STEAMPUNK: +"
                + string(price)
                + " cr";
        }
        else
        {
            sell_result =
                "NO ITEMS TO SELL";
        }
    }
}