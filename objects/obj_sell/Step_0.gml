/// obj_sell - Step Event


// =====================================================
// ONLY INTERACT ON ECONOMY SCREEN
// =====================================================

if (global.ui_screen == 0)
{
    var mouse_gui_x =
        device_mouse_x_to_gui(0);

    var mouse_gui_y =
        device_mouse_y_to_gui(0);


    var recipe_count =
        array_length(
            global.recipes
        );


    // =================================================
    // SAFETY
    // =====================================================

    if (recipe_count > 0)
    {
        sell_item_index =
            clamp(
                sell_item_index,
                0,
                recipe_count - 1
            );


        // =================================================
        // IS MOUSE OVER SELL PANEL?
        // =====================================================

        var mouse_over_sell_panel =
            mouse_gui_x >= sell_x
            &&
            mouse_gui_x <=
                sell_x + sell_panel_w
            &&
            mouse_gui_y >= sell_y
            &&
            mouse_gui_y <=
                sell_y + sell_panel_h;


        // =================================================
        // MOUSE WHEEL
        // =====================================================
        //
        // Wheel only changes Sell item while the cursor
        // is over the Sell Crafted Item panel.
        //
        // Wheel down = next
        // Wheel up   = previous
        //
        // Wraps:
        // Item 20 -> Item 01
        // Item 01 -> Item 20
        //
        // =================================================

        if (mouse_over_sell_panel)
        {
            if (mouse_wheel_down())
            {
                sell_item_index += 1;


                if (
                    sell_item_index >=
                    recipe_count
                )
                {
                    sell_item_index = 0;
                }


                sell_result =
                    "Choose a market.";
            }


            if (mouse_wheel_up())
            {
                sell_item_index -= 1;


                if (sell_item_index < 0)
                {
                    sell_item_index =
                        recipe_count - 1;
                }


                sell_result =
                    "Choose a market.";
            }
        }


        // =================================================
        // KEYBOARD NAVIGATION
        // =====================================================
        //
        // LEFT / UP  = previous item
        // RIGHT/DOWN = next item
        //
        // Only while Economy screen is open.
        //
        // =================================================

        if (
            keyboard_check_pressed(
                vk_right
            )
            ||
            keyboard_check_pressed(
                vk_down
            )
        )
        {
            sell_item_index += 1;


            if (
                sell_item_index >=
                recipe_count
            )
            {
                sell_item_index = 0;
            }


            sell_result =
                "Choose a market.";
        }


        if (
            keyboard_check_pressed(
                vk_left
            )
            ||
            keyboard_check_pressed(
                vk_up
            )
        )
        {
            sell_item_index -= 1;


            if (sell_item_index < 0)
            {
                sell_item_index =
                    recipe_count - 1;
            }


            sell_result =
                "Choose a market.";
        }


        // =================================================
        // CURRENT ITEM
        // =================================================

        var sell_recipe =
            global.recipes[
                sell_item_index
            ];


        var item_key =
            sell_recipe.id;


        var item_amount =
            0;


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
        // SELL BUTTONS
        // =================================================

        if (
            mouse_check_button_pressed(
                mb_left
            )
        )
        {
            // =============================================
            // FANTASY
            // =============================================

            if (
                mouse_gui_x >=
                    fantasy_button_x1
                &&
                mouse_gui_x <=
                    fantasy_button_x2
                &&
                mouse_gui_y >=
                    fantasy_button_y1
                &&
                mouse_gui_y <=
                    fantasy_button_y2
            )
            {
                if (item_amount > 0)
                {
                    var fantasy_sell_price =
                        get_item_world_sell_price(
                            sell_recipe,
                            "FANTASY"
                        );


                    variable_struct_set(
                        global.item_inventory,
                        item_key,
                        item_amount - 1
                    );


                    global.credits +=
                        fantasy_sell_price;


                    sell_result =
                        "SOLD "
                        +
                        sell_recipe.name
                        +
                        " TO FANTASY: +"
                        +
                        string(
                            fantasy_sell_price
                        )
                        +
                        " cr";
                }
                else
                {
                    sell_result =
                        "NO "
                        +
                        sell_recipe.name
                        +
                        " TO SELL";
                }
            }


            // =============================================
            // CYBERPUNK
            // =============================================

            else if (
                mouse_gui_x >=
                    cyber_button_x1
                &&
                mouse_gui_x <=
                    cyber_button_x2
                &&
                mouse_gui_y >=
                    cyber_button_y1
                &&
                mouse_gui_y <=
                    cyber_button_y2
            )
            {
                if (item_amount > 0)
                {
                    var cyber_sell_price =
                        get_item_world_sell_price(
                            sell_recipe,
                            "CYBERPUNK"
                        );


                    variable_struct_set(
                        global.item_inventory,
                        item_key,
                        item_amount - 1
                    );


                    global.credits +=
                        cyber_sell_price;


                    sell_result =
                        "SOLD "
                        +
                        sell_recipe.name
                        +
                        " TO CYBERPUNK: +"
                        +
                        string(
                            cyber_sell_price
                        )
                        +
                        " cr";
                }
                else
                {
                    sell_result =
                        "NO "
                        +
                        sell_recipe.name
                        +
                        " TO SELL";
                }
            }


            // =============================================
            // STEAMPUNK
            // =============================================

            else if (
                mouse_gui_x >=
                    steam_button_x1
                &&
                mouse_gui_x <=
                    steam_button_x2
                &&
                mouse_gui_y >=
                    steam_button_y1
                &&
                mouse_gui_y <=
                    steam_button_y2
            )
            {
                if (item_amount > 0)
                {
                    var steam_sell_price =
                        get_item_world_sell_price(
                            sell_recipe,
                            "STEAMPUNK"
                        );


                    variable_struct_set(
                        global.item_inventory,
                        item_key,
                        item_amount - 1
                    );


                    global.credits +=
                        steam_sell_price;


                    sell_result =
                        "SOLD "
                        +
                        sell_recipe.name
                        +
                        " TO STEAMPUNK: +"
                        +
                        string(
                            steam_sell_price
                        )
                        +
                        " cr";
                }
                else
                {
                    sell_result =
                        "NO "
                        +
                        sell_recipe.name
                        +
                        " TO SELL";
                }
            }
        }
    }
}