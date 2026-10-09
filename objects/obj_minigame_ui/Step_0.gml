/// obj_minigame_ui - Step Event

if (global.ui_screen != 1) exit;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var left_pressed = mouse_check_button_pressed(mb_left);
var left_released = mouse_check_button_released(mb_left);
var right_pressed = mouse_check_button_pressed(mb_right);


// =====================================================
// SCROLL
// =====================================================

if (
    mx >= ui.pool_x &&
    mx <= ui.pool_x + ui.pool_w &&
    my >= ui.pool_y &&
    my <= 815
)
{
    var max_scroll = max(
        0,
        array_length(resources) - visible_rows
    );

    if (mouse_wheel_down())
        resource_scroll = min(max_scroll, resource_scroll + 1);

    if (mouse_wheel_up())
        resource_scroll = max(0, resource_scroll - 1);
}


// =====================================================
// RIGHT CLICK REMOVE
// =====================================================

if (right_pressed)
{
    var clear_upper = get_upper_cell(mx, my);
    var clear_lower = get_lower_cell(mx, my);

    if (clear_upper != -1)
    {
        upper_modules[clear_upper] = -1;
        craft_result = 0;
    }

    if (clear_lower != -1)
    {
        lower_cells[clear_lower] = -1;
        craft_result = 0;
    }
}


// =====================================================
// START LEFT CLICK
// =====================================================

if (left_pressed)
{
    drag_active = false;
    drag_started = false;
    drag_origin_panel = 0;
    drag_origin_cell = -1;

    drag_start_x = mx;
    drag_start_y = my;

    var handled = false;


    // PRESETS

    for (var preset_i = 0; preset_i < array_length(presets); preset_i++)
    {
        var preset_y =
            ui.preset_y +
            preset_i * (ui.preset_h + 8);

        if (
            mx >= ui.preset_x &&
            mx <= ui.preset_x + ui.preset_w &&
            my >= preset_y &&
            my <= preset_y + ui.preset_h
        )
        {
            apply_preset(preset_i);
            handled = true;
            break;
        }
    }


    // MODULE SOURCE

    if (!handled)
    {
        for (var module_i = 0; module_i < 3; module_i++)
        {
            var module_y =
                ui.module_y + module_i * ui.module_step;

            if (
                mx >= ui.module_x &&
                mx <= ui.module_x + 120 &&
                my >= module_y &&
                my <= module_y + 44
            )
            {
                selected_kind = 1;
                selected_value = module_i;

                drag_active = true;
                drag_kind = 1;
                drag_value = module_i;

                handled = true;
                break;
            }
        }
    }


    // BUFF SOURCE

    if (!handled)
    {
        for (var buff_i = 0; buff_i < 3; buff_i++)
        {
            var buff_x = 405 + buff_i * 58;

            if (
                mx >= buff_x &&
                mx <= buff_x + 52 &&
                my >= ui.buff_y &&
                my <= ui.buff_y + 42
            )
            {
                selected_kind = 3;
                selected_value = -2 - buff_i;

                drag_active = true;
                drag_kind = 3;
                drag_value = selected_value;

                handled = true;
                break;
            }
        }
    }


    // RESOURCE SOURCE

    if (!handled)
    {
        for (var row_i = 0; row_i < visible_rows; row_i++)
        {
            var resource_index = resource_scroll + row_i;

            if (resource_index >= array_length(resources)) break;

            var row_y = ui.resource_y + row_i * ui.resource_step;

            if (
                mx >= ui.pool_x + 15 &&
                mx <= ui.pool_x + ui.pool_w - 15 &&
                my >= row_y &&
                my <= row_y + 40
            )
            {
                selected_kind = 2;
                selected_value = resource_index;

                drag_active = true;
                drag_kind = 2;
                drag_value = resource_index;

                handled = true;
                break;
            }
        }
    }


    // UPPER GRID

    if (!handled)
    {
        var upper_cell = get_upper_cell(mx, my);

        if (upper_cell != -1)
        {
            if (upper_modules[upper_cell] != -1)
            {
                drag_active = true;
                drag_kind = 1;
                drag_value = upper_modules[upper_cell];

                drag_origin_panel = 1;
                drag_origin_cell = upper_cell;
            }
            else if (selected_kind == 1)
            {
                upper_modules[upper_cell] = selected_value;
            }

            handled = true;
        }
    }


    // LOWER GRID

    if (!handled)
    {
        var lower_cell = get_lower_cell(mx, my);

        if (lower_cell != -1)
        {
            if (lower_cells[lower_cell] != -1)
            {
                drag_active = true;

                drag_value = lower_cells[lower_cell];

                if (drag_value >= 0)
                    drag_kind = 2;
                else
                    drag_kind = 3;

                drag_origin_panel = 2;
                drag_origin_cell = lower_cell;
            }
            else if (selected_kind == 2 || selected_kind == 3)
            {
                if (selected_kind == 3)
                {
                    for (var unique_i = 0; unique_i < 9; unique_i++)
                    {
                        if (lower_cells[unique_i] == selected_value)
                            lower_cells[unique_i] = -1;
                    }
                }

                lower_cells[lower_cell] = selected_value;
            }

            handled = true;
        }
    }


    // RESET

    if (
        !handled &&
        mx >= 430 && mx <= 550 &&
        my >= 835 && my <= 877
    )
    {
        upper_modules = array_create(6, -1);
        lower_cells = array_create(9, -1);

        selected_kind = 0;
        selected_value = -1;

        craft_result = 0;
        craft_note = "GRID RESET";

        handled = true;
    }


    // BOOK NAVIGATION

    if (
        !handled &&
        my >= 730 && my <= 775 &&
        mx >= ui.book_x &&
        mx <= ui.book_x + ui.book_w
    )
    {
        if (mx < ui.book_x + ui.book_w * 0.5)
            selected_item = (selected_item + 19) mod 20;
        else
            selected_item = (selected_item + 1) mod 20;

        handled = true;
    }

// =====================================================
// LOAD RECIPE BUTTON
// =====================================================

if (
    !handled &&
    mx >= ui.book_x + 20 &&
    mx <= ui.book_x + ui.book_w - 20 &&
    my >= 665 &&
    my <= 700
)
{
    load_book_recipe();
    handled = true;
}
    // CRAFT

    if (
        !handled &&
        mx >= ui.craft_x &&
        mx <= ui.craft_x + ui.craft_w &&
        my >= ui.craft_y &&
        my <= ui.craft_y + ui.craft_h
    )
    {
        var item_index = get_current_item();

        if (item_index == -1)
        {
            craft_result = 0;
            craft_note = "INVALID COMBINATION";
        }
        else
        {
            var group_names = [
                "stone", "polyester", "tree", "cloth",
                "glass", "jewels", "mushrooms", "blood"
            ];

            var requirements = array_create(8, 0);

            for (var cell_i = 0; cell_i < 9; cell_i++)
            {
                var resource_index = lower_cells[cell_i];

                if (resource_index < 0) continue;

                var resource_group = resource_groups[resource_index];

                for (var group_i = 0; group_i < 8; group_i++)
                {
                    if (group_names[group_i] == resource_group)
                    {
                        requirements[group_i] += 10;
                        break;
                    }
                }
            }

            var enough = true;

            for (var check_i = 0; check_i < 8; check_i++)
            {
                if (
                    get_pool_amount(group_names[check_i]) <
                    requirements[check_i]
                )
                {
                    enough = false;
                    break;
                }
            }

            if (!enough)
            {
                craft_result = 0;
                craft_note = "NOT ENOUGH MATERIALS";
            }
            else
            {
                for (var spend_i = 0; spend_i < 8; spend_i++)
                {
                    if (requirements[spend_i] > 0)
                    {
                        change_pool_amount(
                            group_names[spend_i],
                            -requirements[spend_i]
                        );
                    }
                }

                global.craft_attempts++;

                var failure_chance = get_failure();

                if (random(100) < failure_chance)
                {
                    craft_result = 2;
                    craft_note = "CRAFT FAILED";
                }
                else
                {
                    craft_result = 1;

                    craft_v2_add_item(item_index);

                    var item_id =
                        "item_" +
                        string_format(item_index + 1, 2, 0);

                    var already_known = false;

                    for (var known_i = 0;
                         known_i < array_length(global.discovered_items);
                         known_i++)
                    {
                        if (global.discovered_items[known_i] == item_id)
                        {
                            already_known = true;
                            break;
                        }
                    }

                    if (!already_known)
                        array_push(global.discovered_items, item_id);

                    craft_note = "+1 " + item_names[item_index];
                }

                // BACK

                if (random(100) < get_buff_rate(1))
                {
                    var available_groups = [];

                    for (var back_i = 0; back_i < 8; back_i++)
                    {
                        if (requirements[back_i] > 0)
                            array_push(available_groups, back_i);
                    }

                    if (array_length(available_groups) > 0)
                    {
                        var chosen_group = available_groups[
                            irandom(array_length(available_groups) - 1)
                        ];

                        change_pool_amount(
                            group_names[chosen_group],
                            10
                        );

                        craft_note += " | BACK +10";
                    }
                }

                // FIND

                if (random(100) < get_buff_rate(2))
                {
                    var unknown_items = [];

                    for (var find_i = 0; find_i < 20; find_i++)
                    {
                        var find_id =
                            "item_" +
                            string_format(find_i + 1, 2, 0);

                        var known = false;

                        for (var discovered_i = 0;
                             discovered_i < array_length(global.discovered_items);
                             discovered_i++)
                        {
                            if (global.discovered_items[discovered_i] == find_id)
                            {
                                known = true;
                                break;
                            }
                        }

                        if (!known)
                            array_push(unknown_items, find_i);
                    }

                    if (array_length(unknown_items) > 0)
                    {
                        var found_index = unknown_items[
                            irandom(array_length(unknown_items) - 1)
                        ];

                        var found_id =
                            "item_" +
                            string_format(found_index + 1, 2, 0);

                        array_push(global.discovered_items, found_id);

                        selected_item = found_index;

                        craft_note +=
                            " | FOUND: " + item_names[found_index];
                    }
                }
            }
        }

        handled = true;
    }
}


// =====================================================
// DRAG DETECTION
// =====================================================

if (drag_active && mouse_check_button(mb_left))
{
    if (point_distance(mx, my, drag_start_x, drag_start_y) > 8)
        drag_started = true;
}


// =====================================================
// DROP / SWAP
// =====================================================

if (left_released && drag_active)
{
    if (drag_started)
    {
        var drop_upper = get_upper_cell(mx, my);
        var drop_lower = get_lower_cell(mx, my);

        if (drag_kind == 1 && drop_upper != -1)
        {
            if (drag_origin_panel == 1)
            {
                var old_module = upper_modules[drop_upper];

                upper_modules[drop_upper] =
                    upper_modules[drag_origin_cell];

                upper_modules[drag_origin_cell] =
                    old_module;
            }
            else
            {
                upper_modules[drop_upper] = drag_value;
            }
        }

        if (
            (drag_kind == 2 || drag_kind == 3) &&
            drop_lower != -1
        )
        {
            if (drag_origin_panel == 2)
            {
                var old_lower = lower_cells[drop_lower];

                lower_cells[drop_lower] =
                    lower_cells[drag_origin_cell];

                lower_cells[drag_origin_cell] =
                    old_lower;
            }
            else
            {
                if (drag_kind == 3)
                {
                    for (var buff_clear_i = 0;
                         buff_clear_i < 9;
                         buff_clear_i++)
                    {
                        if (lower_cells[buff_clear_i] == drag_value)
                            lower_cells[buff_clear_i] = -1;
                    }
                }

                lower_cells[drop_lower] = drag_value;
            }
        }

        craft_result = 0;
    }

    drag_active = false;
    drag_started = false;
    drag_origin_panel = 0;
    drag_origin_cell = -1;
}