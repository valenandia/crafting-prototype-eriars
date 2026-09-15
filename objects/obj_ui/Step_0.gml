
/// obj_ui - Step Event

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);


// =====================================================
// CRAFT BUTTON
// =====================================================

if (mouse_check_button_pressed(mb_left))
{
    if (
        mx >= 40 &&
        mx <= 220 &&
        my >= 410 &&
        my <= 465
    )
    {
        var recipe =
            global.recipes[global.selected_recipe];

        var result =
            craft_item(
                recipe,
                array_length(global.discovered_items)
            );


        // =================================================
        // NOT ENOUGH MATERIALS
        // =================================================

        if (!result.can_craft)
        {
            global.craft_result =
                "NOT ENOUGH MATERIALS";

            add_craft_log(
                "NO MATERIALS  "
                + result.item_name
            );
        }


        // =================================================
        // SUCCESS
        // =================================================

        else if (result.success)
        {
            // ---------------------------------------------
            // ADD CRAFTED ITEM TO INVENTORY
            // ---------------------------------------------

            var item_key = result.item_id;

            var current_amount = 0;

            if (
                variable_struct_exists(
                    global.item_inventory,
                    item_key
                )
            )
            {
                current_amount =
                    variable_struct_get(
                        global.item_inventory,
                        item_key
                    );
            }

            variable_struct_set(
                global.item_inventory,
                item_key,
                current_amount + 1
            );


            // ---------------------------------------------
            // CHECK DISCOVERY
            // ---------------------------------------------

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


            // ---------------------------------------------
            // NEW DISCOVERY
            // ---------------------------------------------

            if (!already_discovered)
            {
                array_push(
                    global.discovered_items,
                    result.item_id
                );

                global.craft_result =
                    "SUCCESS! "
                    + result.item_name
                    + " - NEW DISCOVERY!";

                add_craft_log(
                    "SUCCESS  "
                    + result.item_name
                    + "  [NEW]"
                );
            }


            // ---------------------------------------------
            // ALREADY DISCOVERED
            // ---------------------------------------------

            else
            {
                global.craft_result =
                    "SUCCESS! "
                    + result.item_name;

                add_craft_log(
                    "SUCCESS  "
                    + result.item_name
                );
            }
        }


        // =================================================
        // FAILED
        // =================================================

        else
        {
            global.craft_result =
                "FAILED! "
                + result.item_name;

            add_craft_log(
                "FAILED  "
                + result.item_name
            );
        }
    }
}