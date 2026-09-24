/// obj_minigame_ui - Step

// Мини-игра принимает управление только на CRAFTING screen.
if (global.ui_screen != 1) exit;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);


// =====================================================
// RESOURCE SCROLL
// =====================================================

if (mx >= ui.pool_x1 && mx <= ui.pool_x2 &&
    my >= ui.pool_y1 && my <= ui.pool_y2)
{
    var max_scroll = max(
        0,
        array_length(resources) - ui.visible_rows
    );

    if (mouse_wheel_down())
    {
        resource_scroll = min(
            max_scroll,
            resource_scroll + 1
        );
    }

    if (mouse_wheel_up())
    {
        resource_scroll = max(
            0,
            resource_scroll - 1
        );
    }
}


// =====================================================
// BOOK SCROLL
// =====================================================

if (book_open &&
    mx >= ui.book_x1 && mx <= ui.book_x2 &&
    my >= ui.book_header_y2 && my <= ui.book_y2)
{
    if (mouse_wheel_down())
    {
        book_index = min(
            array_length(recipes) - 1,
            book_index + 1
        );
    }

    if (mouse_wheel_up())
    {
        book_index = max(
            0,
            book_index - 1
        );
    }
}


// =====================================================
// MOUSE PRESS
// =====================================================

if (mouse_check_button_pressed(mb_left))
{
    drag_kind = 0;
    drag_value = -1;
    drag_from = -1;


    // -------------------------------------------------
    // OPEN / CLOSE BOOK
    // -------------------------------------------------

    if (mx >= ui.book_x1 && mx <= ui.book_x2 &&
        my >= ui.book_y1 && my < ui.book_header_y2)
    {
        book_open = !book_open;
    }
    else if (
        book_open &&
        mx >= ui.book_x1 + 10 &&
        mx <= ui.book_x2 - 10 &&
        my >= ui.book_nav_y1 &&
        my <= ui.book_nav_y2
    )
    {
        if (mx < (ui.book_x1 + ui.book_x2) * 0.5)
        {
            book_index = max(
                0,
                book_index - 1
            );
        }
        else
        {
            book_index = min(
                array_length(recipes) - 1,
                book_index + 1
            );
        }
    }


// -------------------------------------------------
// MODULE BAR
// -------------------------------------------------

if (drag_kind == 0)
{
    for (var s = 0; s < 12; s++)
    {
        var sx = ui.module_x + s * ui.module_gap;

        if (mx >= sx &&
            mx < sx + ui.module_size &&
            my >= ui.module_y &&
            my < ui.module_y + ui.module_size)
        {
            drag_kind = 1;
            drag_from = -1;

            if (s < 9)
            {
                // 0 = MODUL_C
                // 1 = MODUL_M
                // 2 = MODUL_Y
                drag_value = s div 3;
            }
            else
            {
                // 3 = -10% FAIL
                // 4 = 30% BACK
                // 5 = 2% FIND
                drag_value = 3 + (s - 9);
            }

            break;
        }
    }
}

    // -------------------------------------------------
    // RESOURCE PREV / NEXT
    // -------------------------------------------------

    if (drag_kind == 0 &&
        mx >= ui.resource_x1 &&
        mx <= ui.resource_x2 &&
        my >= ui.pool_nav_y1 &&
        my <= ui.pool_nav_y2)
    {
        var max_scroll_nav = max(
            0,
            array_length(resources) - ui.visible_rows
        );

        var middle =
            (ui.resource_x1 + ui.resource_x2) * 0.5;

        if (mx < middle)
        {
            resource_scroll = max(
                0,
                resource_scroll - ui.visible_rows
            );
        }
        else
        {
            resource_scroll = min(
                max_scroll_nav,
                resource_scroll + ui.visible_rows
            );
        }
    }


    // -------------------------------------------------
    // PICK RESOURCE FROM LIST
    // -------------------------------------------------

    if (drag_kind == 0 &&
        mx >= ui.resource_x1 &&
        mx <= ui.resource_x2)
    {
        for (var list_row = 0;
             list_row < ui.visible_rows;
             list_row++)
        {
            var r =
                resource_scroll +
                list_row;

            var ry =
                ui.resource_y +
                list_row * ui.resource_gap;

            if (
                r < array_length(resources) &&
                my >= ry &&
                my < ry + ui.resource_height &&
                get_resource_count(r) > 0
            )
            {
                drag_kind = 2;
                drag_value = r;

                break;
            }
        }
    }


    // -------------------------------------------------
    // PICK FROM GRID
    // -------------------------------------------------

    if (drag_kind == 0 &&
        mx >= grid_x &&
        mx < grid_x + cell_size * 3 &&
        my >= grid_y &&
        my < grid_y + cell_size * 3)
    {
        var grid_col =
            floor((mx - grid_x) / cell_size);

        var grid_row =
            floor((my - grid_y) / cell_size);

        var grid_index =
            grid_row * 3 + grid_col;

        if (grid_items[grid_index] != -1)
        {
            drag_kind = 2;
            drag_value = grid_items[grid_index];
            drag_from = grid_index;
        }
        else if (grid_modules[grid_index] != -1)
        {
            drag_kind = 1;
            drag_value = grid_modules[grid_index];
            drag_from = grid_index;
        }
    }


    // =================================================
    // RESET
    // =================================================

    if (mx >= ui.reset_x1 &&
        mx <= ui.reset_x2 &&
        my >= ui.button_y1 &&
        my <= ui.button_y2)
    {
        for (var i = 0; i < 9; i++)
        {
            if (grid_items[i] != -1)
            {
                return_resource(
                    grid_items[i],
                    1
                );
            }

            grid_items[i] = -1;
            grid_modules[i] = -1;
        }

        drag_kind = 0;
        drag_value = -1;
        drag_from = -1;

        craft_result = 0;
        craft_note = "";
    }


    // =================================================
    // RANDOM
    // =================================================

    if (mx >= ui.random_x1 &&
        mx <= ui.random_x2 &&
        my >= ui.button_y1 &&
        my <= ui.button_y2)
    {
        // Сначала возвращаем всё, что уже лежит
        // в сетке, обратно в GLOBAL material pool.

        for (var i = 0; i < 9; i++)
        {
            if (grid_items[i] != -1)
            {
                return_resource(
                    grid_items[i],
                    1
                );
            }

            grid_items[i] = -1;
            grid_modules[i] = -1;
        }


        // ---------------------------------------------
        // 1-5 обычных ресурсов
        // ---------------------------------------------

        var amount = irandom_range(1, 5);
        var placed = 0;

        while (placed < amount)
        {
            var random_cell = irandom(8);

            if (grid_modules[random_cell] == -1)
            {
                var module_type = irandom(2);

                var available = [];

                for (var rr = 0;
                     rr < array_length(resources);
                     rr++)
                {
                    if (
                        resource_modules[rr] == module_type &&
                        get_resource_count(rr) > 0
                    )
                    {
                        array_push(
                            available,
                            rr
                        );
                    }
                }

                // Есть подходящий ресурс.
                if (array_length(available) > 0)
                {
                    var choice =
                        available[
                            irandom(
                                array_length(available) - 1
                            )
                        ];

                    grid_modules[random_cell] =
                        module_type;

                    grid_items[random_cell] =
                        choice;

                    spend_resource(
                        choice,
                        1
                    );

                    placed++;
                }
                else
                {
                    // Для этого типа сейчас нет ресурсов.
                    // Ничего в клетку не ставим.
                }
            }
        }


        // ---------------------------------------------
        // 1-3 разные BUFF-звезды
        // ---------------------------------------------

        var buff_amount =
            irandom_range(
                1,
                min(3, 9 - placed)
            );

        var buff_types = [3, 4, 5];

        repeat (buff_amount)
        {
            var buff_pick =
                irandom(
                    array_length(buff_types) - 1
                );

            var buff_type =
                buff_types[buff_pick];

            array_delete(
                buff_types,
                buff_pick,
                1
            );

            var buff_cell =
                irandom(8);

            while (grid_modules[buff_cell] != -1)
            {
                buff_cell = irandom(8);
            }

            grid_modules[buff_cell] =
                buff_type;

            // BUFF не содержит ресурс.
            grid_items[buff_cell] = -1;
        }

        drag_kind = 0;
        drag_value = -1;
        drag_from = -1;

        craft_result = 0;
        craft_note = "";
    }


    // =================================================
    // CRAFT
    // =================================================

    if (mx >= ui.craft_x1 &&
        mx <= ui.craft_x2 &&
        my >= ui.button_y1 &&
        my <= ui.button_y2)
    {
        var found_recipe =
            find_grid_recipe();

        if (found_recipe == -1)
        {
            craft_result = 0;
            craft_note = "";
        }
        else
        {
            // Эффекты считаем ДО очистки поля.

            var failure =
                get_craft_failure(
                    found_recipe
                );

            var return_chance =
                get_buff_rate(1);

            var discover_chance =
                get_buff_rate(2);


            // Запоминаем потраченные ресурсы.

            var spent = [];

            for (var cell = 0;
                 cell < 9;
                 cell++)
            {
                if (grid_items[cell] != -1)
                {
                    array_push(
                        spent,
                        grid_items[cell]
                    );
                }

                // Ресурс уже был списан в момент
                // помещения в сетку.
                // Поэтому здесь НЕ возвращаем его.
                grid_items[cell] = -1;
            }


            var failed =
                random(100) < failure;

            craft_result =
                failed ? 2 : 1;

            craft_note = "";


            // -----------------------------------------
            // DISCOVER CURRENT RECIPE
            // -----------------------------------------

            if (!failed &&
                !discovered[found_recipe])
            {
                discovered[found_recipe] = true;
                discovered_count++;
            }


            // -----------------------------------------
            // RESOURCE BACK BUFF
            // -----------------------------------------

            if (array_length(spent) > 0 &&
                random(100) < return_chance)
            {
                var returned =
                    spent[
                        irandom(
                            array_length(spent) - 1
                        )
                    ];

                return_resource(
                    returned,
                    1
                );

                craft_note =
                    "+" +
                    resources[returned];
            }


            // -----------------------------------------
            // RANDOM RECIPE DISCOVERY BUFF
            // -----------------------------------------

            if (!failed &&
                random(100) < discover_chance)
            {
                var unknown = [];

                for (var p = 0;
                     p < array_length(recipes);
                     p++)
                {
                    if (!discovered[p])
                    {
                        array_push(
                            unknown,
                            p
                        );
                    }
                }

                if (array_length(unknown) > 0)
                {
                    var unlocked =
                        unknown[
                            irandom(
                                array_length(unknown) - 1
                            )
                        ];

                    discovered[unlocked] = true;
                    discovered_count++;

                    book_index =
                        unlocked;

                    craft_note +=
                        " +" +
                        recipes[unlocked].name;
                }
            }
        }
    }
}


// =====================================================
// MOUSE RELEASE
// =====================================================

if (mouse_check_button_released(mb_left) &&
    drag_kind != 0)
{
    var over_grid =
        mx >= grid_x &&
        mx < grid_x + cell_size * 3 &&
        my >= grid_y &&
        my < grid_y + cell_size * 3;


    if (over_grid)
    {
        var target_col =
            floor((mx - grid_x) / cell_size);

        var target_row =
            floor((my - grid_y) / cell_size);

        var target =
            target_row * 3 + target_col;


// =============================================
// PLACE MODULE
// =============================================

if (drag_kind == 1)
{
    var ordinary_count = 0;
    var already_used = false;

    for (var i = 0; i < 9; i++)
    {
        // Обычные модули
        if (grid_modules[i] >= 0 &&
            grid_modules[i] <= 2)
        {
            ordinary_count++;
        }

        // Каждая BUFF-звезда может быть
        // на поле только один раз.
        if (drag_value >= 3 &&
            grid_modules[i] == drag_value &&
            i != drag_from)
        {
            already_used = true;
        }
    }

    var can_place = true;

    // Нельзя бросать поверх другого модуля.
    if (grid_modules[target] != -1 &&
        target != drag_from)
    {
        can_place = false;
    }

    // Нельзя иметь две одинаковые BUFF-звезды.
    if (drag_value >= 3 && already_used)
    {
        can_place = false;
    }

    // С верхней панели разрешено максимум
    // 5 обычных модулей.
    if (drag_value <= 2 &&
        drag_from == -1 &&
        ordinary_count >= 5)
    {
        can_place = false;
    }

    if (can_place && target != drag_from)
    {
        grid_modules[target] = drag_value;

        // Если двигаем модуль внутри сетки,
        // очищаем старую клетку.
        if (drag_from != -1)
        {
            grid_modules[drag_from] = -1;
        }

        craft_result = 0;
        craft_note = "";
    }
}
        // =============================================
        // PLACE RESOURCE
        // =============================================

        if (drag_kind == 2)
        {
            // Нельзя класть ресурс в пустую клетку.
            if (grid_modules[target] == -1)
            {
                // Ничего.
            }

            // Ресурс должен соответствовать
            // обычному модулю.
            // BUFF 3-5 автоматически сюда не подходит.
            else if (
                grid_modules[target] !=
                resource_modules[drag_value]
            )
            {
                // Ничего.
            }

            else if (target != drag_from)
            {
                // Если в target уже лежал ресурс,
                // возвращаем его в экономику.

                if (grid_items[target] != -1)
                {
                    return_resource(
                        grid_items[target],
                        1
                    );
                }


                grid_items[target] =
                    drag_value;


                // Ресурс пришёл из списка.
                if (drag_from == -1)
                {
                    spend_resource(
                        drag_value,
                        1
                    );
                }

                // Ресурс перемещён из другой
                // клетки сетки.
                else
                {
                    grid_items[drag_from] =
                        -1;
                }

                craft_result = 0;
                craft_note = "";
            }
        }
    }

    // =================================================
    // DROPPED OUTSIDE GRID
    // =================================================

    else if (drag_from != -1)
    {
        if (drag_kind == 2)
        {
            // Ресурс был уже списан при первоначальном
            // помещении в сетку — возвращаем его.

            return_resource(
                drag_value,
                1
            );

            grid_items[drag_from] =
                -1;
        }
        else
        {
            grid_modules[drag_from] =
                -1;
        }

        craft_result = 0;
        craft_note = "";
    }


    drag_kind = 0;
    drag_value = -1;
    drag_from = -1;
}