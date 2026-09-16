/// obj_ui - Step Event


// =====================================================
// GUI MOUSE POSITION
// =====================================================

var mx =
    device_mouse_x_to_gui(0);

var my =
    device_mouse_y_to_gui(0);


// =====================================================
// CURRENT RECIPE
// =====================================================

var recipe =
    global.recipes[
        global.selected_recipe
    ];


// =====================================================
// CRAFT BUTTON
// =====================================================

if (mouse_check_button_pressed(mb_left))
{
    if (
        mx >= 40 &&
        mx <= 220 &&
        my >= 445 &&
        my <= 500
    )
    {
        // =============================================
        // CRAFT
        // =============================================

        var discovered_count =
            array_length(
                global.discovered_items
            );


        var result =
            craft_item(
                recipe,
                discovered_count
            );


        // =============================================
        // NOT ENOUGH MATERIALS
        // =============================================

        if (!result.can_craft)
        {
            global.craft_result =
                "NOT ENOUGH MATERIALS";


            add_craft_log(
                recipe.name
                + " - NO MATERIALS"
            );
        }


        // =============================================
        // CRAFT SUCCESS
        // =============================================

        else if (result.success)
        {
            var item_key =
                recipe.id;


            // -----------------------------------------
            // INVENTORY
            // -----------------------------------------

            if (
                !variable_struct_exists(
                    global.item_inventory,
                    item_key
                )
            )
            {
                variable_struct_set(
                    global.item_inventory,
                    item_key,
                    0
                );
            }


            var current_amount =
                variable_struct_get(
                    global.item_inventory,
                    item_key
                );


            variable_struct_set(
                global.item_inventory,
                item_key,
                current_amount + 1
            );


            // -----------------------------------------
            // DISCOVERY CHECK
            // -----------------------------------------

            var already_discovered =
                false;


            for (
                var i = 0;
                i < array_length(
                    global.discovered_items
                );
                i++
            )
            {
                if (
                    global.discovered_items[i]
                    == recipe.id
                )
                {
                    already_discovered =
                        true;

                    break;
                }
            }


            // -----------------------------------------
            // NEW DISCOVERY
            // -----------------------------------------

            if (!already_discovered)
            {
                array_push(
                    global.discovered_items,
                    recipe.id
                );


                global.craft_result =
                    "SUCCESS! DISCOVERED "
                    + recipe.name;
            }
            else
            {
                global.craft_result =
                    "SUCCESS! "
                    + recipe.name;
            }


            // -----------------------------------------
            // LOG
            // -----------------------------------------

            add_craft_log(
                "SUCCESS "
                + recipe.name
                + " | "
                + string(
                    result.failure_chance
                )
                + "% fail"
            );
        }


        // =============================================
        // CRAFT FAILURE
        // =============================================

        else
        {
            global.craft_result =
                "CRAFT FAILED!";


            add_craft_log(
                "FAILED "
                + recipe.name
                + " | "
                + string(
                    result.failure_chance
                )
                + "% fail"
            );
        }
    }
}


// =====================================================
// CHANGE RECIPE
//
// LEFT / RIGHT
// =====================================================

if (
    keyboard_check_pressed(
        vk_left
    )
)
{
    global.selected_recipe--;


    if (
        global.selected_recipe < 0
    )
    {
        global.selected_recipe =
            array_length(
                global.recipes
            ) - 1;
    }
}


if (
    keyboard_check_pressed(
        vk_right
    )
)
{
    global.selected_recipe++;


    if (
        global.selected_recipe
        >= array_length(
            global.recipes
        )
    )
    {
        global.selected_recipe =
            0;
    }
}