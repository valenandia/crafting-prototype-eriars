/// obj_minigame_ui - Draw GUI

draw_set_font(-1);

var ui_scale = 0.76;

var draw_label = function(_x, _y, _text) {
    draw_text_transformed(
        _x, _y, _text,
        0.76, 0.76, 0
    );
};

draw_set_color(make_color_rgb(24, 29, 38));
draw_rectangle(0, 0, 960, 540, false);

// Рисование одного модуля.
var draw_module = function(_type, _x, _y, _size) {
    var cx = _x + _size * 0.5;
    var cy = _y + _size * 0.5;

    if (_type == 0) {
        draw_set_color(
            make_color_rgb(80, 207, 225)
        );

        draw_rectangle(
            _x + 4, _y + 4,
            _x + _size - 4,
            _y + _size - 4,
            true
        );

        draw_line(
            _x + 13, _y + 16,
            _x + _size - 13, _y + 16
        );

        draw_line(
            _x + 13, _y + 16,
            cx, _y + _size - 13
        );

        draw_line(
            _x + _size - 13, _y + 16,
            cx, _y + _size - 13
        );
    }
    else if (_type == 1) {
        draw_set_color(
            make_color_rgb(224, 91, 196)
        );

        draw_rectangle(
            _x + 4, _y + 4,
            _x + _size - 4,
            _y + _size - 4,
            true
        );

        var edge = _size * 0.32;

        draw_line(
            _x + 8, _y + edge,
            _x + edge, _y + 8
        );

        draw_line(
            _x + _size - 8, _y + edge,
            _x + _size - edge, _y + 8
        );

        draw_line(
            _x + 8, _y + _size - edge,
            _x + edge, _y + _size - 8
        );

        draw_line(
            _x + _size - 8,
            _y + _size - edge,
            _x + _size - edge,
            _y + _size - 8
        );
    }
    else if (_type == 2) {
        draw_set_color(
            make_color_rgb(235, 203, 81)
        );

        draw_rectangle(
            _x + 4, _y + 4,
            _x + _size - 4,
            _y + _size - 4,
            true
        );

        draw_circle(
            cx, cy,
            _size * 0.28,
            true
        );
    }
    else {
        // Типы 3, 4, 5 — красные звёзды.
        draw_set_color(
            make_color_rgb(236, 75, 91)
        );

        draw_rectangle(
            _x + 3, _y + 3,
            _x + _size - 3,
            _y + _size - 3,
            true
        );

        for (var ray = 0; ray < 10; ray++) {
            var a1 =
                -90 + ray * 36;

            var a2 =
                -90 + (ray + 1) * 36;

            var r1 =
                (ray mod 2 == 0)
                ? _size * 0.34
                : _size * 0.15;

            var r2 =
                ((ray + 1) mod 2 == 0)
                ? _size * 0.34
                : _size * 0.15;

            draw_line(
                cx + lengthdir_x(r1, a1),
                cy + lengthdir_y(r1, a1),
                cx + lengthdir_x(r2, a2),
                cy + lengthdir_y(r2, a2)
            );
        }
    }
};

// Верхняя полоса модулей.
draw_set_color(c_white);
draw_label(30, 13, "CRAFT MINI-GAME");
draw_label(95, 34, "MODUL_C");
draw_label(320, 34, "MODUL_M");
draw_label(545, 34, "MODUL_Y");
draw_label(762, 34, "MODUL_BUFF");

var tag_labels = [
    "stone", "polyester", "tree",
    "cloth", "glass", "jewels",
    "mushrooms", "blood",
    "-10% FAIL", "30% BACK", "2% FIND"
];

var tag_x = [
    38, 103, 188,
    263, 330, 400,
    488, 590,
    708, 783, 858
];

var tag_colors = [
    make_color_rgb(150, 150, 150),
    make_color_rgb(255, 100, 180),
    make_color_rgb(80, 190, 90),
    make_color_rgb(240, 210, 60),
    make_color_rgb(80, 210, 240),
    make_color_rgb(60, 100, 255),
    make_color_rgb(140, 90, 50),
    make_color_rgb(220, 40, 40),
    make_color_rgb(236, 75, 91),
    make_color_rgb(236, 75, 91),
    make_color_rgb(236, 75, 91)
];

for (var t = 0;
     t < array_length(tag_labels);
     t++) {

    draw_set_color(tag_colors[t]);

    if (t >= 8) {
        draw_text_transformed(
            tag_x[t], 59,
            tag_labels[t],
            0.57, 0.57, 0
        );
    }
    else {
        draw_label(
            tag_x[t], 58,
            tag_labels[t]
        );
    }
}

draw_set_color(make_color_rgb(37, 44, 56));
draw_rectangle(28, 79, 924, 159, false);

draw_set_color(make_color_rgb(115, 128, 146));
draw_line(253, 79, 253, 159);
draw_line(478, 79, 478, 159);
draw_line(703, 79, 703, 159);

for (var s = 0; s < 12; s++) {
    var sx =
        ui.module_x +
        s * ui.module_gap;

    draw_set_color(
        make_color_rgb(48, 57, 70)
    );

    draw_rectangle(
        sx, ui.module_y,
        sx + ui.module_size,
        ui.module_y + ui.module_size,
        false
    );

    draw_module(
        s < 9 ? s div 3 : 3,
        sx + 4,
        ui.module_y + 4,
        47
    );

    if (s >= 9) {
        draw_set_color(c_white);

        draw_label(
            sx + 41,
            ui.module_y + 39,
            string(s - 8)
        );
    }
}

// Ресурсы слева.
draw_set_color(make_color_rgb(37, 44, 56));

draw_rectangle(
    ui.pool_x1, ui.pool_y1,
    ui.pool_x2, ui.pool_y2,
    false
);

draw_set_color(c_white);
draw_label(45, 189, "RESOURCES");

// Иконка контейнера.
draw_rectangle(256, 191, 272, 205, true);
draw_line(260, 191, 260, 187);
draw_line(260, 187, 268, 187);
draw_line(268, 187, 268, 191);

for (var list_row = 0;
     list_row < ui.visible_rows;
     list_row++) {

    var r =
        resource_scroll +
        list_row;

    if (r >= array_length(resources)) {
        break;
    }

    var ry =
        ui.resource_y +
        list_row * ui.resource_gap;

    draw_set_color(
        make_color_rgb(61, 73, 90)
    );

    draw_rectangle(
        ui.resource_x1,
        ry,
        ui.resource_x2,
        ry + ui.resource_height,
        false
    );

    draw_set_color(resource_colors[r]);

    draw_rectangle(
        ui.resource_x1,
        ry,
        ui.resource_x1 + 5,
        ry + ui.resource_height,
        false
    );

    draw_label(
        53, ry + 7,
        resource_tags[r]
    );

    draw_set_color(c_white);

    draw_label(
        198, ry + 7,
        "_" + string(resource_variants[r])
    );

    draw_label(
        248, ry + 7,
        string(get_resource_count(r))
    );
}

// PREV / NEXT ресурсов.
draw_set_color(make_color_rgb(61, 73, 90));

draw_rectangle(
    ui.resource_x1,
    ui.pool_nav_y1,
    ui.resource_x2,
    ui.pool_nav_y2,
    false
);

draw_set_color(c_white);
draw_label(50, 413, "< PREV");

draw_label(
    127,
    413,
    string(resource_scroll + 1)
    + "-"
    + string(min(
        resource_scroll +
        ui.visible_rows,
        array_length(resources)
    ))
);

draw_label(208, 413, "NEXT >");

// Фраза над сеткой.
draw_set_color(make_color_rgb(37, 44, 56));
draw_rectangle(340, 175, 596, 219, false);

draw_set_color(make_color_rgb(124, 86, 170));
draw_rectangle(340, 175, 375, 219, false);

draw_set_color(c_white);
draw_circle(357, 197, 10, true);

var status_line_1 = "";
var status_line_2 = "";
var status_line_3 = "";

if (craft_result == 1) {
    status_line_1 = "Davay po novoy,";
    status_line_2 = "duraley!";
}
else if (craft_result == 2) {
    status_line_1 = "Ne vyshlo, braza :(";
}
else {
    var module_count = 0;

    for (var cell = 0; cell < 9; cell++) {
        if (grid_modules[cell] != -1) {
            module_count++;
        }
    }

    if (module_count == 0) {
        status_line_1 = "Delayu deyliki";
        status_line_2 = "v svoih gachah,";
        status_line_3 = "poka ty tupish.";
    }
    else if (find_grid_recipe() != -1) {
        if (get_buff() != -1) {
            status_line_1 =
                "Vot zh nakurolesil!";
        }
        else {
            status_line_1 =
                "Ono pytalos...";
        }
    }
    else {
        status_line_1 = "Nu i huynya!";
    }
}

draw_set_color(c_white);
draw_label(382, 177, status_line_1);
draw_label(382, 191, status_line_2);
draw_label(382, 205, status_line_3);

// Сетка.
var active_buff = get_buff();

for (var grid_row = 0; grid_row < 3; grid_row++) {
    for (var grid_col = 0; grid_col < 3; grid_col++) {
        var index = grid_row * 3 + grid_col;

        var x1 =
            grid_x + grid_col * cell_size;

        var y1 =
            grid_y + grid_row * cell_size;

        if (active_buff != -1 &&
            (
                grid_items[index] != -1 ||
                grid_modules[index] >= 3
            )) {

            draw_set_color(
                make_color_rgb(124, 86, 170)
            );
        }
        else {
            draw_set_color(
                make_color_rgb(52, 61, 76)
            );
        }

        draw_rectangle(
            x1 + 2, y1 + 2,
            x1 + cell_size - 2,
            y1 + cell_size - 2,
            false
        );

        draw_set_color(
            make_color_rgb(135, 150, 170)
        );

        draw_rectangle(
            x1 + 2, y1 + 2,
            x1 + cell_size - 2,
            y1 + cell_size - 2,
            true
        );

        if (grid_modules[index] != -1) {
            draw_module(
                grid_modules[index],
                x1 + 7,
                y1 + 7,
                cell_size - 14
            );
        }

        if (grid_modules[index] >= 3) {
            draw_set_color(c_white);

            draw_label(
                x1 + cell_size - 19,
                y1 + cell_size - 22,
                string(
                    grid_modules[index] - 2
                )
            );
        }

        if (grid_items[index] != -1) {
            var item = grid_items[index];

            draw_set_color(
                resource_colors[item]
            );

            var item_scale = min(
                ui_scale,
                0.92 * (cell_size - 12) /
                max(
                    1,
                    string_width(
                        resources[item]
                    )
                )
            );

            draw_text_transformed(
                x1 + 6,
                y1 + 30,
                resources[item],
                item_scale,
                item_scale,
                0
            );
        }
    }
}

// Кнопки.
draw_set_color(make_color_rgb(64, 77, 94));

draw_rectangle(
    ui.reset_x1, ui.button_y1,
    ui.reset_x2, ui.button_y2,
    false
);

draw_rectangle(
    ui.random_x1, ui.button_y1,
    ui.random_x2, ui.button_y2,
    false
);

draw_set_color(make_color_rgb(124, 86, 170));

draw_rectangle(
    ui.craft_x1, ui.button_y1,
    ui.craft_x2, ui.button_y2,
    false
);

draw_set_color(c_white);
draw_label(63, 481, "RESET");
draw_label(178, 481, "RANDOM");
draw_label(427, 481, "CRAFT");

// Книга.
draw_set_color(make_color_rgb(64, 77, 94));

draw_rectangle(
    ui.book_x1,
    ui.book_y1,
    ui.book_x2,
    ui.book_header_y2,
    false
);

draw_set_color(c_white);

draw_label(
    620, 185,
    book_open
        ? "HIDE BOOK"
        : "OPEN BOOK"
);

if (book_open) {
    draw_set_color(
        make_color_rgb(37, 44, 56)
    );

    draw_rectangle(
        ui.book_x1,
        ui.book_header_y2,
        ui.book_x2,
        ui.book_y2,
        false
    );

    var book_recipe =
        recipes[book_index];

    draw_set_color(c_white);
    draw_label(621, 216, "RECIPE BOOK");

    draw_set_color(
        make_color_rgb(61, 73, 90)
    );

    draw_rectangle(
        618, 238,
        921, 265,
        false
    );

    draw_set_color(c_white);
    draw_label(626, 243, book_recipe.name);

    if (discovered[book_index]) {
        draw_set_color(
            make_color_rgb(100, 220, 140)
        );

        draw_label(
            620, 269,
            "DISCOVERED"
        );
    }
    else {
        draw_set_color(
            make_color_rgb(160, 170, 185)
        );

        draw_label(
            620, 269,
            "NOT DISCOVERED"
        );
    }

    draw_set_color(c_white);
    draw_label(620, 291, "INGREDIENTS");

    for (var k = 0;
         k < array_length(
             book_recipe.materials
         );
         k++) {

        var ingredient =
            book_recipe.materials[k];

        var line_y =
            313 + k * 18;

        var ingredient_color =
            c_white;

        for (var r = 0;
             r < array_length(resources);
             r++) {

            if (resources[r] == ingredient.tag) {
                ingredient_color =
                    resource_colors[r];

                break;
            }
        }

        draw_set_color(ingredient_color);

        draw_rectangle(
            620,
            line_y + 2,
            625,
            line_y + 14,
            false
        );

        draw_label(
            632,
            line_y,
            ingredient.tag
        );

        draw_set_color(c_white);

        draw_label(
            883,
            line_y,
            string(
                ingredient.percentage
            ) + "%"
        );
    }

    draw_set_color(
        make_color_rgb(61, 73, 90)
    );

    draw_rectangle(
        618,
        ui.book_nav_y1,
        921,
        ui.book_nav_y2,
        false
    );

    draw_set_color(c_white);
    draw_label(630, 413, "<");

    draw_label(
        735,
        413,
        string(book_index + 1)
        + "/"
        + string(array_length(recipes))
    );

    draw_label(905, 413, ">");
}

// Текущий шанс ошибки.
var chance_recipe =
    find_grid_recipe();

var chance_text = "--";

if (chance_recipe != -1) {
    chance_text =
        string(
            get_craft_failure(
                chance_recipe
            )
        )
        + "%";
}

draw_set_color(
    make_color_rgb(37, 44, 56)
);

draw_rectangle(
    605, 443,
    935, 465,
    false
);

draw_set_color(c_white);
draw_label(620, 447, "FAIL CHANCE");

draw_set_color(
    make_color_rgb(235, 203, 81)
);

draw_label(869, 447, chance_text);

// Вернувшийся ресурс или открытый рецепт.
if (craft_note != "" &&
    craft_result != 0) {

    draw_set_color(
        make_color_rgb(236, 75, 91)
    );

    draw_label(620, 476, craft_note);
}

// Эффекты установленных звёзд.
draw_set_color(
    make_color_rgb(236, 75, 91)
);

draw_label(
    620,
    496,
    "BUFF: -"
    + string(get_buff_rate(0))
    + "%  BACK "
    + string(get_buff_rate(1))
    + "%  FIND "
    + string(get_buff_rate(2))
    + "%"
);

// Предпросмотр перетаскивания.
if (drag_kind != 0) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    if (drag_kind == 1) {
        draw_module(
            drag_value,
            mx + 12,
            my + 12,
            48
        );

        if (drag_value >= 3) {
            draw_set_color(c_white);

            draw_label(
                mx + 47,
                my + 45,
                string(drag_value - 2)
            );
        }
    }
    else {
        draw_set_color(
            make_color_rgb(61, 73, 90)
        );

        draw_rectangle(
            mx + 12,
            my + 12,
            mx + 145,
            my + 43,
            false
        );

        draw_set_color(
            resource_colors[drag_value]
        );

        var preview_scale = min(
            ui_scale,
            118 /
            max(
                1,
                string_width(
                    resources[drag_value]
                )
            )
        );

        draw_text_transformed(
            mx + 18,
            my + 19,
            resources[drag_value],
            preview_scale,
            preview_scale,
            0
        );
    }
}

draw_set_color(c_white);