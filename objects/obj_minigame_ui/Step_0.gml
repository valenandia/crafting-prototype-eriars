/// obj_minigame_ui - Step Event


// =====================================================
// ONLY CRAFT SCREEN
// =====================================================

if (global.ui_screen != 1)
{
    exit;
}


// =====================================================
// MOUSE
// =====================================================

var mouse_gui_x =
    device_mouse_x_to_gui(0);

var mouse_gui_y =
    device_mouse_y_to_gui(0);


// =====================================================
// RESOURCE SCROLL
// =====================================================

if (
    mouse_gui_x >= ui.pool_x1 &&
    mouse_gui_x <= ui.pool_x2 &&
    mouse_gui_y >= ui.pool_y1 &&
    mouse_gui_y <= ui.pool_y2
)
{
    var resource_max_scroll =
        max(
            0,
            array_length(resources) -
            ui.visible_rows
        );


    if (mouse_wheel_down())
    {
        resource_scroll =
            min(
                resource_max_scroll,
                resource_scroll + 1
            );
    }


    if (mouse_wheel_up())
    {
        resource_scroll =
            max(
                0,
                resource_scroll - 1
            );
    }
}


// =====================================================
// RECIPE BOOK NAVIGATION
//
// Wheel while mouse is over the book.
// Arrow keys work while the book is open.
//
// Navigation wraps:
// Item 20 -> Item 01
// Item 01 -> Item 20
// =====================================================

var mouse_over_book =
    mouse_gui_x >= ui.book_x1
    &&
    mouse_gui_x <= ui.book_x2
    &&
    mouse_gui_y >= ui.book_y1
    &&
    mouse_gui_y <= ui.book_y2;


// -----------------------------------------------------
// MOUSE WHEEL
// -----------------------------------------------------

if (
    book_open &&
    mouse_over_book
)
{
    if (mouse_wheel_up())
    {
        book_index--;


        if (book_index < 0)
        {
            book_index =
                array_length(recipes) - 1;
        }
    }


    if (mouse_wheel_down())
    {
        book_index++;


        if (
            book_index >=
            array_length(recipes)
        )
        {
            book_index = 0;
        }
    }
}


// -----------------------------------------------------
// KEYBOARD ARROWS
// -----------------------------------------------------

if (book_open)
{
    if (
        keyboard_check_pressed(
            vk_left
        )
    )
    {
        book_index--;


        if (book_index < 0)
        {
            book_index =
                array_length(recipes) - 1;
        }
    }


    if (
        keyboard_check_pressed(
            vk_right
        )
    )
    {
        book_index++;


        if (
            book_index >=
            array_length(recipes)
        )
        {
            book_index = 0;
        }
    }
}


// =====================================================
// LEFT MOUSE PRESSED
// =====================================================

if (mouse_check_button_pressed(mb_left))
{
    // -------------------------------------------------
    // RESET DRAG
    // -------------------------------------------------

    drag_kind = 0;
    drag_value = -1;
    drag_from = -1;


    // =================================================
    // BOOK HEADER
    // =====================================================

    if (
        mouse_gui_x >= ui.book_x1 &&
        mouse_gui_x <= ui.book_x2 &&
        mouse_gui_y >= ui.book_y1 &&
        mouse_gui_y < ui.book_header_y2
    )
    {
        book_open =
            !book_open;
    }


    // =================================================
    // MODULE BAR
    // =====================================================

    for (var module_slot = 0;
         module_slot < 12;
         module_slot++)
    {
        var module_pos_x =
            ui.module_x +
            module_slot *
            ui.module_gap;


        if (
            mouse_gui_x >= module_pos_x &&
            mouse_gui_x <
            module_pos_x +
            ui.module_size &&
            mouse_gui_y >= ui.module_y &&
            mouse_gui_y <
            ui.module_y +
            ui.module_size
        )
        {
            drag_kind = 1;
            drag_from = -1;


            if (module_slot < 9)
            {
                drag_value =
                    module_slot div 3;
            }
            else
            {
                drag_value =
                    3 +
                    (module_slot - 9);
            }


            break;
        }
    }


    // =================================================
    // RESOURCE NAVIGATION
    // =====================================================

    if (
        drag_kind == 0 &&
        mouse_gui_x >= ui.resource_x1 &&
        mouse_gui_x <= ui.resource_x2 &&
        mouse_gui_y >= ui.pool_nav_y1 &&
        mouse_gui_y <= ui.pool_nav_y2
    )
    {
        var nav_max_scroll =
            max(
                0,
                array_length(resources) -
                ui.visible_rows
            );


        var resource_center =
            (
                ui.resource_x1 +
                ui.resource_x2
            )
            *
            0.5;


        if (mouse_gui_x < resource_center)
        {
            resource_scroll =
                max(
                    0,
                    resource_scroll -
                    ui.visible_rows
                );
        }
        else
        {
            resource_scroll =
                min(
                    nav_max_scroll,
                    resource_scroll +
                    ui.visible_rows
                );
        }
    }


    // =================================================
    // PICK RESOURCE FROM LIST
    // =====================================================

    if (
        drag_kind == 0 &&
        mouse_gui_x >= ui.resource_x1 &&
        mouse_gui_x <= ui.resource_x2
    )
    {
        for (var resource_row = 0;
             resource_row < ui.visible_rows;
             resource_row++)
        {
            var resource_pick_index =
                resource_scroll +
                resource_row;


            if (
                resource_pick_index >=
                array_length(resources)
            )
            {
                break;
            }


            var resource_pos_y =
                ui.resource_y +
                resource_row *
                ui.resource_gap;


            if (
                mouse_gui_y >= resource_pos_y &&
                mouse_gui_y <
                resource_pos_y +
                ui.resource_height
            )
            {
                if (
                    get_resource_count(
                        resource_pick_index
                    ) > 0
                )
                {
                    drag_kind = 2;

                    drag_value =
                        resource_pick_index;

                    drag_from = -1;
                }


                break;
            }
        }
    }


    // =================================================
    // PICK FROM GRID
    // =====================================================

    if (
        drag_kind == 0 &&
        mouse_gui_x >= grid_x &&
        mouse_gui_x <
        grid_x + cell_size * 3 &&
        mouse_gui_y >= grid_y &&
        mouse_gui_y <
        grid_y + cell_size * 3
    )
    {
        var pick_grid_col =
            floor(
                (mouse_gui_x - grid_x)
                /
                cell_size
            );


        var pick_grid_row =
            floor(
                (mouse_gui_y - grid_y)
                /
                cell_size
            );


        var pick_grid_index =
            pick_grid_row * 3 +
            pick_grid_col;


        // Resource has priority.

        if (
            grid_items[
                pick_grid_index
            ] != -1
        )
        {
            drag_kind = 2;

            drag_value =
                grid_items[
                    pick_grid_index
                ];

            drag_from =
                pick_grid_index;
        }
        else if (
            grid_modules[
                pick_grid_index
            ] != -1
        )
        {
            drag_kind = 1;

            drag_value =
                grid_modules[
                    pick_grid_index
                ];

            drag_from =
                pick_grid_index;
        }
    }


    // =================================================
    // RESET BUTTON
    // =====================================================

    if (
        mouse_gui_x >= ui.reset_x1 &&
        mouse_gui_x <= ui.reset_x2 &&
        mouse_gui_y >= ui.button_y1 &&
        mouse_gui_y <= ui.button_y2
    )
    {
        for (var reset_cell = 0;
             reset_cell < 9;
             reset_cell++)
        {
            grid_modules[
                reset_cell
            ] = -1;

            grid_items[
                reset_cell
            ] = -1;
        }


        drag_kind = 0;
        drag_value = -1;
        drag_from = -1;

        craft_result = 0;
        craft_note = "";
    }


    // =================================================
    // RANDOM BUTTON
    // =====================================================

    if (
        mouse_gui_x >= ui.random_x1 &&
        mouse_gui_x <= ui.random_x2 &&
        mouse_gui_y >= ui.button_y1 &&
        mouse_gui_y <= ui.button_y2
    )
    {
        // ---------------------------------------------
        // CLEAR GRID
        // ---------------------------------------------

        for (var random_clear_cell = 0;
             random_clear_cell < 9;
             random_clear_cell++)
        {
            grid_modules[
                random_clear_cell
            ] = -1;

            grid_items[
                random_clear_cell
            ] = -1;
        }


        // ---------------------------------------------
        // NUMBER OF NORMAL RESOURCES
        // ---------------------------------------------

        var random_resource_amount =
            irandom_range(1, 5);

        var random_placed =
            0;

        var random_attempts =
            0;


        // ---------------------------------------------
        // PLACE NORMAL RESOURCES
        // ---------------------------------------------

        while (
            random_placed <
            random_resource_amount &&
            random_attempts < 200
        )
        {
            random_attempts++;


            var random_grid_cell =
                irandom(8);


            if (
                grid_modules[
                    random_grid_cell
                ] != -1
            )
            {
                continue;
            }


            var random_module_type =
                irandom(2);


            // -----------------------------------------
            // COUNT COMPATIBLE AVAILABLE RESOURCES
            // -----------------------------------------

            var compatible_count =
                0;


            for (
                var random_resource_check = 0;
                random_resource_check <
                array_length(resources);
                random_resource_check++
            )
            {
                if (
                    resource_modules[
                        random_resource_check
                    ]
                    ==
                    random_module_type
                )
                {
                    if (
                        get_resource_count(
                            random_resource_check
                        ) > 0
                    )
                    {
                        compatible_count++;
                    }
                }
            }


            if (compatible_count <= 0)
            {
                continue;
            }


            // -----------------------------------------
            // PICK COMPATIBLE RESOURCE
            // -----------------------------------------

            var compatible_pick =
                irandom(
                    compatible_count - 1
                );

            var compatible_seen =
                0;

            var selected_resource =
                -1;


            for (
                var random_resource_find = 0;
                random_resource_find <
                array_length(resources);
                random_resource_find++
            )
            {
                if (
                    resource_modules[
                        random_resource_find
                    ]
                    ==
                    random_module_type
                )
                {
                    if (
                        get_resource_count(
                            random_resource_find
                        ) > 0
                    )
                    {
                        if (
                            compatible_seen ==
                            compatible_pick
                        )
                        {
                            selected_resource =
                                random_resource_find;

                            break;
                        }


                        compatible_seen++;
                    }
                }
            }


            if (selected_resource != -1)
            {
                grid_modules[
                    random_grid_cell
                ] =
                    random_module_type;


                grid_items[
                    random_grid_cell
                ] =
                    selected_resource;


                random_placed++;
            }
        }


        // ---------------------------------------------
        // PLACE 1-3 UNIQUE BUFF MODULES
        // ---------------------------------------------

        var random_free_cells =
            9 - random_placed;


        if (random_free_cells > 0)
        {
            var random_buff_amount =
                irandom_range(
                    1,
                    min(
                        3,
                        random_free_cells
                    )
                );


            var buff_available_0 =
                true;

            var buff_available_1 =
                true;

            var buff_available_2 =
                true;


            for (
                var random_buff_number = 0;
                random_buff_number <
                random_buff_amount;
                random_buff_number++
            )
            {
                var available_buff_count =
                    0;


                if (buff_available_0)
                {
                    available_buff_count++;
                }

                if (buff_available_1)
                {
                    available_buff_count++;
                }

                if (buff_available_2)
                {
                    available_buff_count++;
                }


                if (available_buff_count <= 0)
                {
                    break;
                }


                var random_buff_pick =
                    irandom(
                        available_buff_count - 1
                    );


                var selected_buff =
                    -1;

                var buff_seen =
                    0;


                if (buff_available_0)
                {
                    if (
                        buff_seen ==
                        random_buff_pick
                    )
                    {
                        selected_buff = 3;
                    }

                    buff_seen++;
                }


                if (
                    selected_buff == -1 &&
                    buff_available_1
                )
                {
                    if (
                        buff_seen ==
                        random_buff_pick
                    )
                    {
                        selected_buff = 4;
                    }

                    buff_seen++;
                }


                if (
                    selected_buff == -1 &&
                    buff_available_2
                )
                {
                    if (
                        buff_seen ==
                        random_buff_pick
                    )
                    {
                        selected_buff = 5;
                    }
                }


                if (selected_buff == 3)
                {
                    buff_available_0 =
                        false;
                }

                if (selected_buff == 4)
                {
                    buff_available_1 =
                        false;
                }

                if (selected_buff == 5)
                {
                    buff_available_2 =
                        false;
                }


                // -------------------------------------
                // FIND RANDOM EMPTY CELL
                // -------------------------------------

                var empty_count =
                    0;


                for (var empty_check = 0;
                     empty_check < 9;
                     empty_check++)
                {
                    if (
                        grid_modules[
                            empty_check
                        ] == -1
                        &&
                        grid_items[
                            empty_check
                        ] == -1
                    )
                    {
                        empty_count++;
                    }
                }


                if (empty_count <= 0)
                {
                    break;
                }


                var empty_pick =
                    irandom(
                        empty_count - 1
                    );

                var empty_seen =
                    0;

                var selected_empty_cell =
                    -1;


                for (var empty_find = 0;
                     empty_find < 9;
                     empty_find++)
                {
                    if (
                        grid_modules[
                            empty_find
                        ] == -1
                        &&
                        grid_items[
                            empty_find
                        ] == -1
                    )
                    {
                        if (
                            empty_seen ==
                            empty_pick
                        )
                        {
                            selected_empty_cell =
                                empty_find;

                            break;
                        }


                        empty_seen++;
                    }
                }


                if (
                    selected_empty_cell != -1
                    &&
                    selected_buff != -1
                )
                {
                    grid_modules[
                        selected_empty_cell
                    ] =
                        selected_buff;
                }
            }
        }


        drag_kind = 0;
        drag_value = -1;
        drag_from = -1;

        craft_result = 0;
        craft_note = "";
    }


    // =================================================
    // CRAFT BUTTON
    // =====================================================

    if (
        mouse_gui_x >= ui.craft_x1 &&
        mouse_gui_x <= ui.craft_x2 &&
        mouse_gui_y >= ui.button_y1 &&
        mouse_gui_y <= ui.button_y2
    )
    {
        var craft_recipe_index =
            find_grid_recipe();


        // ---------------------------------------------
        // INVALID RECIPE
        // ---------------------------------------------

        if (craft_recipe_index == -1)
        {
            craft_result = 0;
            craft_note = "NO RECIPE";
        }
        else
        {
            // =========================================
            // CHECK RESOURCES
            // =========================================

            var need_stone = 0;
            var need_polyester = 0;
            var need_tree = 0;
            var need_cloth = 0;
            var need_glass = 0;
            var need_jewels = 0;
            var need_mushrooms = 0;
            var need_blood = 0;


            for (
                var craft_check_cell = 0;
                craft_check_cell < 9;
                craft_check_cell++
            )
            {
                if (
                    grid_items[
                        craft_check_cell
                    ] != -1
                )
                {
                    var craft_resource_index =
                        grid_items[
                            craft_check_cell
                        ];


                    var craft_resource_group =
                        resource_tags[
                            craft_resource_index
                        ];


                    switch (craft_resource_group)
                    {
                        case "stone":
                            need_stone++;
                        break;


                        case "polyester":
                            need_polyester++;
                        break;


                        case "tree":
                            need_tree++;
                        break;


                        case "cloth":
                            need_cloth++;
                        break;


                        case "glass":
                            need_glass++;
                        break;


                        case "jewels":
                            need_jewels++;
                        break;


                        case "mushrooms":
                            need_mushrooms++;
                        break;


                        case "blood":
                            need_blood++;
                        break;
                    }
                }
            }


            var craft_has_resources =
                true;


            if (
                global.material_pool.stone <
                need_stone
            )
            {
                craft_has_resources = false;
            }


            if (
                global.material_pool.polyester <
                need_polyester
            )
            {
                craft_has_resources = false;
            }


            if (
                global.material_pool.tree <
                need_tree
            )
            {
                craft_has_resources = false;
            }


            if (
                global.material_pool.cloth <
                need_cloth
            )
            {
                craft_has_resources = false;
            }


            if (
                global.material_pool.glass <
                need_glass
            )
            {
                craft_has_resources = false;
            }


            if (
                global.material_pool.jewels <
                need_jewels
            )
            {
                craft_has_resources = false;
            }


            if (
                global.material_pool.mushrooms <
                need_mushrooms
            )
            {
                craft_has_resources = false;
            }


            if (
                global.material_pool.blood <
                need_blood
            )
            {
                craft_has_resources = false;
            }


            // =========================================
            // NOT ENOUGH RESOURCES
            // =========================================

            if (!craft_has_resources)
            {
                craft_result = 0;

                craft_note =
                    "NOT ENOUGH RESOURCES";
            }
            else
            {
                // =====================================
                // CALCULATE BEFORE MODIFYING GRID
                // =====================================

                var craft_failure_chance =
                    get_craft_failure(
                        craft_recipe_index
                    );


                var craft_return_chance =
                    get_buff_rate(1);


                var craft_discover_chance =
                    get_buff_rate(2);


                // =====================================
                // BUILD SPENT RESOURCE LIST
                // =====================================

                var spent_resources =
                    [];


                for (var spend_cell = 0;
                     spend_cell < 9;
                     spend_cell++)
                {
                    if (
                        grid_items[
                            spend_cell
                        ] != -1
                    )
                    {
                        array_push(
                            spent_resources,

                            grid_items[
                                spend_cell
                            ]
                        );
                    }
                }


                // =====================================
                // SPEND RESOURCES
                // =====================================

                for (
                    var spend_index = 0;
                    spend_index <
                    array_length(
                        spent_resources
                    );
                    spend_index++
                )
                {
                    spend_resource(
                        spent_resources[
                            spend_index
                        ],
                        1
                    );
                }


                // =====================================
                // CRAFT ROLL
                // =====================================

                var craft_failed =
                    random(100) <
                    craft_failure_chance;


                if (craft_failed)
                {
                    craft_result = 2;

                    craft_note =
                        "CRAFT FAILED";
                }
                else
                {
                    craft_result = 1;


                    // ---------------------------------
                    // DISCOVER CRAFTED RECIPE
                    // ---------------------------------

                    var craft_was_new =
                        discover_recipe(
                            craft_recipe_index
                        );


                    // ---------------------------------
                    // ADD ITEM
                    // ---------------------------------

                    add_crafted_item(
                        craft_recipe_index,
                        1
                    );


                    if (craft_was_new)
                    {
                        craft_note =
                            "DISCOVERED: "
                            +
                            recipes[
                                craft_recipe_index
                            ].name;
                    }
                    else
                    {
                        craft_note =
                            "+1 "
                            +
                            recipes[
                                craft_recipe_index
                            ].name;
                    }
                }


                // =====================================
                // BACK BUFF
                // =====================================

                if (
                    array_length(
                        spent_resources
                    ) > 0
                )
                {
                    if (
                        random(100) <
                        craft_return_chance
                    )
                    {
                        var returned_index =
                            irandom(
                                array_length(
                                    spent_resources
                                ) - 1
                            );


                        var returned_resource =
                            spent_resources[
                                returned_index
                            ];


                        return_resource(
                            returned_resource,
                            1
                        );


                        craft_note +=
                            " | BACK: "
                            +
                            resources[
                                returned_resource
                            ];
                    }
                }


                // =====================================
                // FIND BUFF
                // =====================================

                if (
                    random(100) <
                    craft_discover_chance
                )
                {
                    var unknown_recipe_count =
                        0;


                    for (
                        var unknown_count_i = 0;
                        unknown_count_i <
                        array_length(recipes);
                        unknown_count_i++
                    )
                    {
                        if (
                            !is_recipe_discovered(
                                unknown_count_i
                            )
                        )
                        {
                            unknown_recipe_count++;
                        }
                    }


                    if (unknown_recipe_count > 0)
                    {
                        var unknown_pick =
                            irandom(
                                unknown_recipe_count - 1
                            );


                        var unknown_seen =
                            0;

                        var unlocked_recipe =
                            -1;


                        for (
                            var unknown_find_i = 0;
                            unknown_find_i <
                            array_length(recipes);
                            unknown_find_i++
                        )
                        {
                            if (
                                !is_recipe_discovered(
                                    unknown_find_i
                                )
                            )
                            {
                                if (
                                    unknown_seen ==
                                    unknown_pick
                                )
                                {
                                    unlocked_recipe =
                                        unknown_find_i;

                                    break;
                                }


                                unknown_seen++;
                            }
                        }


                        if (unlocked_recipe != -1)
                        {
                            if (
                                discover_recipe(
                                    unlocked_recipe
                                )
                            )
                            {
                                book_index =
                                    unlocked_recipe;


                                craft_note +=
                                    " | FOUND: "
                                    +
                                    recipes[
                                        unlocked_recipe
                                    ].name;
                            }
                        }
                    }
                }


                // =====================================
                // CLEAR RESOURCES AFTER ATTEMPT
                // =====================================

                for (
                    var craft_clear_cell = 0;
                    craft_clear_cell < 9;
                    craft_clear_cell++
                )
                {
                    grid_items[
                        craft_clear_cell
                    ] = -1;
                }


                drag_kind = 0;
                drag_value = -1;
                drag_from = -1;
            }
        }
    }
}


// =====================================================
// LEFT MOUSE RELEASED
// =====================================================

if (
    mouse_check_button_released(
        mb_left
    )
    &&
    drag_kind != 0
)
{
    var mouse_over_grid =
        mouse_gui_x >= grid_x
        &&
        mouse_gui_x <
        grid_x + cell_size * 3
        &&
        mouse_gui_y >= grid_y
        &&
        mouse_gui_y <
        grid_y + cell_size * 3;


    // =================================================
    // DROP ON GRID
    // =====================================================

    if (mouse_over_grid)
    {
        var drop_col =
            floor(
                (mouse_gui_x - grid_x)
                /
                cell_size
            );


        var drop_row =
            floor(
                (mouse_gui_y - grid_y)
                /
                cell_size
            );


        var drop_cell =
            drop_row * 3 +
            drop_col;


        // =================================================
        // MODULE
        // =====================================================

        if (drag_kind == 1)
        {
            var normal_module_count =
                0;

            var same_buff_exists =
                false;


            for (
                var module_check_cell = 0;
                module_check_cell < 9;
                module_check_cell++
            )
            {
                var existing_module =
                    grid_modules[
                        module_check_cell
                    ];


                if (
                    existing_module >= 0 &&
                    existing_module <= 2
                )
                {
                    normal_module_count++;
                }


                if (
                    drag_value >= 3 &&
                    existing_module ==
                    drag_value &&
                    module_check_cell !=
                    drag_from
                )
                {
                    same_buff_exists =
                        true;
                }
            }


            var module_can_drop =
                true;


            // Same cell.

            if (drop_cell == drag_from)
            {
                module_can_drop =
                    false;
            }


            // Target occupied.

            if (
                grid_modules[
                    drop_cell
                ] != -1
                ||
                grid_items[
                    drop_cell
                ] != -1
            )
            {
                module_can_drop =
                    false;
            }


            // Duplicate buff.

            if (same_buff_exists)
            {
                module_can_drop =
                    false;
            }


            // Max 5 normal modules.

            if (
                drag_value >= 0 &&
                drag_value <= 2 &&
                drag_from == -1 &&
                normal_module_count >= 5
            )
            {
                module_can_drop =
                    false;
            }


            // Place / move.

            if (module_can_drop)
            {
                grid_modules[
                    drop_cell
                ] =
                    drag_value;


                if (drag_from != -1)
                {
                    grid_modules[
                        drag_from
                    ] = -1;
                }


                craft_result = 0;
                craft_note = "";
            }
        }


        // =================================================
        // RESOURCE
        // =====================================================

        if (drag_kind == 2)
        {
            var resource_can_drop =
                true;


            // Invalid index.

            if (
                drag_value < 0 ||
                drag_value >=
                array_length(resources)
            )
            {
                resource_can_drop =
                    false;
            }


            // Needs module.

            if (
                grid_modules[
                    drop_cell
                ] == -1
            )
            {
                resource_can_drop =
                    false;
            }


            // Cannot go into buff.

            if (
                grid_modules[
                    drop_cell
                ] >= 3
            )
            {
                resource_can_drop =
                    false;
            }


            // Compatibility.

            if (resource_can_drop)
            {
                if (
                    grid_modules[
                        drop_cell
                    ]
                    !=
                    resource_modules[
                        drag_value
                    ]
                )
                {
                    resource_can_drop =
                        false;
                }
            }


            // Same cell.

            if (drop_cell == drag_from)
            {
                resource_can_drop =
                    false;
            }


            // Place / move.

            if (resource_can_drop)
            {
                grid_items[
                    drop_cell
                ] =
                    drag_value;


                if (drag_from != -1)
                {
                    grid_items[
                        drag_from
                    ] = -1;
                }


                craft_result = 0;
                craft_note = "";
            }
        }
    }


    // =================================================
    // DROP OUTSIDE GRID
    // =====================================================

    else
    {
        // Existing resource removed.

        if (
            drag_kind == 2 &&
            drag_from != -1
        )
        {
            grid_items[
                drag_from
            ] = -1;

            craft_result = 0;
            craft_note = "";
        }


        // Existing module removed.

        if (
            drag_kind == 1 &&
            drag_from != -1
        )
        {
            grid_modules[
                drag_from
            ] = -1;

            craft_result = 0;
            craft_note = "";
        }
    }


    // =================================================
    // END DRAG
    // =====================================================

    drag_kind = 0;
    drag_value = -1;
    drag_from = -1;
}