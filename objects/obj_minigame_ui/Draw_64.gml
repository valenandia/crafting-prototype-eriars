/// obj_minigame_ui - Draw GUI Event


// =====================================================
// DRAW ONLY ON CRAFT SCREEN
// =====================================================

if (global.ui_screen != 1)
{
    exit;
}


// =====================================================
// FONT
// =====================================================

draw_set_font(fnt_ui_small);
draw_set_alpha(1);


// =====================================================
// HELPERS
// =====================================================

var draw_label = function(_tx, _ty, _text)
{
    draw_text(
        _tx,
        _ty,
        _text
    );
};


var draw_small = function(_tx, _ty, _text)
{
    draw_text(
        _tx,
        _ty,
        _text
    );
};


// =====================================================
// COLORS
// =====================================================

var col_bg =
    make_color_rgb(
        24,
        29,
        38
    );


var col_panel =
    make_color_rgb(
        37,
        44,
        56
    );


var col_panel_light =
    make_color_rgb(
        61,
        73,
        90
    );


var col_border =
    make_color_rgb(
        100,
        115,
        135
    );


var col_purple =
    make_color_rgb(
        124,
        86,
        170
    );


var col_red =
    make_color_rgb(
        236,
        75,
        91
    );


var col_green =
    make_color_rgb(
        100,
        220,
        140
    );


var col_yellow =
    make_color_rgb(
        235,
        203,
        81
    );


var col_muted =
    make_color_rgb(
        160,
        170,
        185
    );


// =====================================================
// BACKGROUND
// =====================================================

draw_set_color(
    col_bg
);


draw_rectangle(
    0,
    0,
    1600,
    900,
    false
);


// =====================================================
// MODULE DRAW FUNCTION
// =====================================================

var draw_module =
function(_type, _tx, _ty, _size)
{
    var center_x =
        _tx +
        _size * 0.5;


    var center_y =
        _ty +
        _size * 0.5;


    // =================================================
    // MODUL_C
    // =====================================================

    if (_type == 0)
    {
        draw_set_color(
            make_color_rgb(
                80,
                207,
                225
            )
        );


        draw_rectangle(
            _tx + 5,
            _ty + 5,
            _tx + _size - 5,
            _ty + _size - 5,
            true
        );


        draw_line(
            _tx + 16,
            _ty + 19,
            _tx + _size - 16,
            _ty + 19
        );


        draw_line(
            _tx + 16,
            _ty + 19,
            center_x,
            _ty + _size - 16
        );


        draw_line(
            _tx + _size - 16,
            _ty + 19,
            center_x,
            _ty + _size - 16
        );
    }


    // =================================================
    // MODUL_M
    // =====================================================

    else if (_type == 1)
    {
        draw_set_color(
            make_color_rgb(
                224,
                91,
                196
            )
        );


        draw_rectangle(
            _tx + 5,
            _ty + 5,
            _tx + _size - 5,
            _ty + _size - 5,
            true
        );


        var edge =
            _size * 0.32;


        draw_line(
            _tx + 10,
            _ty + edge,
            _tx + edge,
            _ty + 10
        );


        draw_line(
            _tx + _size - 10,
            _ty + edge,
            _tx + _size - edge,
            _ty + 10
        );


        draw_line(
            _tx + 10,
            _ty + _size - edge,
            _tx + edge,
            _ty + _size - 10
        );


        draw_line(
            _tx + _size - 10,
            _ty + _size - edge,
            _tx + _size - 10,
            _ty + _size - 10
        );
    }


    // =================================================
    // MODUL_Y
    // =====================================================

    else if (_type == 2)
    {
        draw_set_color(
            make_color_rgb(
                235,
                203,
                81
            )
        );


        draw_rectangle(
            _tx + 5,
            _ty + 5,
            _tx + _size - 5,
            _ty + _size - 5,
            true
        );


        draw_circle(
            center_x,
            center_y,
            _size * 0.28,
            true
        );
    }


    // =================================================
    // BUFF
    // =====================================================

    else
    {
        draw_set_color(
            make_color_rgb(
                236,
                75,
                91
            )
        );


        draw_rectangle(
            _tx + 4,
            _ty + 4,
            _tx + _size - 4,
            _ty + _size - 4,
            true
        );


        for (var ray = 0;
             ray < 10;
             ray++)
        {
            var angle_1 =
                -90 +
                ray * 36;


            var angle_2 =
                -90 +
                (ray + 1) * 36;


            var radius_1 =
                0;


            var radius_2 =
                0;


            if (ray mod 2 == 0)
            {
                radius_1 =
                    _size * 0.34;
            }
            else
            {
                radius_1 =
                    _size * 0.15;
            }


            if (
                (ray + 1) mod 2 == 0
            )
            {
                radius_2 =
                    _size * 0.34;
            }
            else
            {
                radius_2 =
                    _size * 0.15;
            }


            draw_line(
                center_x +
                lengthdir_x(
                    radius_1,
                    angle_1
                ),

                center_y +
                lengthdir_y(
                    radius_1,
                    angle_1
                ),

                center_x +
                lengthdir_x(
                    radius_2,
                    angle_2
                ),

                center_y +
                lengthdir_y(
                    radius_2,
                    angle_2
                )
            );
        }
    }
};


// =====================================================
// TITLE
// =====================================================

draw_set_color(c_white);


draw_text(
    60,
    68,
    "CRAFTING"
);


// =====================================================
// MODULE BAR
// =====================================================

draw_set_color(
    col_panel
);


draw_rectangle(
    60,
    100,
    1530,
    235,
    false
);


// =====================================================
// GROUP LABELS
// =====================================================

draw_set_color(c_white);


draw_label(
    205,
    112,
    "MODUL_C"
);


draw_label(
    550,
    112,
    "MODUL_M"
);


draw_label(
    895,
    112,
    "MODUL_Y"
);


draw_label(
    1260,
    112,
    "MODUL_BUFF"
);


// =====================================================
// MODULES
// =====================================================

for (var module_slot = 0;
     module_slot < 12;
     module_slot++)
{
    var module_pos_x =
        ui.module_x +
        module_slot *
        ui.module_gap;


    var module_pos_y =
        ui.module_y;


    // =================================================
    // SELECTED BUFF BACKGROUND
    // =====================================================

    var module_selected =
        false;


    if (
        module_slot >= 9 &&
        drag_kind == 1
    )
    {
        var expected_buff =
            3 +
            (module_slot - 9);


        if (
            drag_value ==
            expected_buff
        )
        {
            module_selected =
                true;
        }
    }


    if (module_selected)
    {
        draw_set_color(
            col_purple
        );
    }
    else
    {
        draw_set_color(
            make_color_rgb(
                48,
                57,
                70
            )
        );
    }


    draw_rectangle(
        module_pos_x,
        module_pos_y,
        module_pos_x +
        ui.module_size,
        module_pos_y +
        ui.module_size,
        false
    );


    // =================================================
    // BORDER FOR SELECTED
    // =====================================================

    if (module_selected)
    {
        draw_set_color(
            c_white
        );


        draw_rectangle(
            module_pos_x - 3,
            module_pos_y - 3,
            module_pos_x +
            ui.module_size + 3,
            module_pos_y +
            ui.module_size + 3,
            true
        );
    }


    var module_type;


    if (module_slot < 9)
    {
        module_type =
            module_slot div 3;
    }
    else
    {
        module_type = 3;
    }


    draw_module(
        module_type,
        module_pos_x + 5,
        module_pos_y + 5,
        ui.module_size - 10
    );


    var module_text =
        "";


    var module_text_color =
        c_white;


    switch (module_slot)
    {
        case 0:
            module_text = "STONE";
            module_text_color =
                make_color_rgb(
                    150,
                    150,
                    150
                );
        break;


        case 1:
            module_text = "POLYESTER";
            module_text_color =
                make_color_rgb(
                    255,
                    100,
                    180
                );
        break;


        case 2:
            module_text = "TREE";
            module_text_color =
                make_color_rgb(
                    80,
                    190,
                    90
                );
        break;


        case 3:
            module_text = "CLOTH";
            module_text_color =
                make_color_rgb(
                    240,
                    210,
                    60
                );
        break;


        case 4:
            module_text = "GLASS";
            module_text_color =
                make_color_rgb(
                    80,
                    210,
                    240
                );
        break;


        case 5:
            module_text = "JEWELS";
            module_text_color =
                make_color_rgb(
                    60,
                    100,
                    255
                );
        break;


        case 6:
            module_text = "MUSHROOMS";
            module_text_color =
                make_color_rgb(
                    140,
                    90,
                    50
                );
        break;


        case 7:
            module_text = "BLOOD";
            module_text_color =
                make_color_rgb(
                    220,
                    40,
                    40
                );
        break;


        case 8:
            module_text = "";
        break;


        case 9:
            module_text = "-10% FAIL";
            module_text_color =
                col_red;
        break;


        case 10:
            module_text = "30% BACK";
            module_text_color =
                col_red;
        break;


        case 11:
            module_text = "2% FIND";
            module_text_color =
                col_red;
        break;
    }


    draw_set_color(
        module_text_color
    );


    draw_small(
        module_pos_x,
        215,
        module_text
    );


    if (module_slot >= 9)
    {
        draw_set_color(c_white);


        draw_small(
            module_pos_x + 53,
            module_pos_y + 53,
            string(
                module_slot - 8
            )
        );
    }
}


// =====================================================
// RESOURCES PANEL
// =====================================================

draw_set_color(
    col_panel
);


draw_rectangle(
    ui.pool_x1,
    ui.pool_y1,
    ui.pool_x2,
    ui.pool_y2,
    false
);


draw_set_color(c_white);


draw_label(
    ui.pool_x1 + 20,
    ui.pool_y1 + 18,
    "RESOURCES"
);


draw_set_color(
    col_muted
);


draw_small(
    ui.pool_x1 + 180,
    ui.pool_y1 + 20,
    "OWNED"
);


// =====================================================
// RESOURCE ROWS
// =====================================================

for (var resource_row = 0;
     resource_row <
     ui.visible_rows;
     resource_row++)
{
    var resource_index =
        resource_scroll +
        resource_row;


    if (
        resource_index >=
        array_length(resources)
    )
    {
        break;
    }


    var resource_row_y =
        ui.resource_y +
        resource_row *
        ui.resource_gap;


    // =================================================
    // SELECTED RESOURCE
    // =====================================================

    var resource_selected =
        drag_kind == 2
        &&
        drag_value ==
        resource_index;


    if (resource_selected)
    {
        draw_set_color(
            col_purple
        );
    }
    else
    {
        draw_set_color(
            col_panel_light
        );
    }


    draw_rectangle(
        ui.resource_x1,
        resource_row_y,
        ui.resource_x2,
        resource_row_y +
        ui.resource_height,
        false
    );


    if (resource_selected)
    {
        draw_set_color(c_white);


        draw_rectangle(
            ui.resource_x1 - 2,
            resource_row_y - 2,
            ui.resource_x2 + 2,
            resource_row_y +
            ui.resource_height + 2,
            true
        );
    }


    draw_set_color(
        resource_colors[
            resource_index
        ]
    );


    draw_rectangle(
        ui.resource_x1,
        resource_row_y,
        ui.resource_x1 + 6,
        resource_row_y +
        ui.resource_height,
        false
    );


    draw_label(
        ui.resource_x1 + 18,
        resource_row_y + 12,
        resources[
            resource_index
        ]
    );


    draw_set_color(c_white);


    draw_label(
        ui.resource_x2 - 58,
        resource_row_y + 12,
        string(
            get_resource_count(
                resource_index
            )
        )
    );
}


// =====================================================
// RESOURCE NAV
// =====================================================

draw_set_color(
    col_panel_light
);


draw_rectangle(
    ui.resource_x1,
    ui.pool_nav_y1,
    ui.resource_x2,
    ui.pool_nav_y2,
    false
);


draw_set_color(c_white);


draw_label(
    ui.resource_x1 + 18,
    ui.pool_nav_y1 + 10,
    "< PREV"
);


draw_label(
    ui.resource_x1 + 125,
    ui.pool_nav_y1 + 10,

    string(
        resource_scroll + 1
    )
    +
    "-"
    +
    string(
        min(
            resource_scroll +
            ui.visible_rows,
            array_length(resources)
        )
    )
);


draw_label(
    ui.resource_x2 - 72,
    ui.pool_nav_y1 + 10,
    "NEXT >"
);


// =====================================================
// RESET / RANDOM
// =====================================================

draw_set_color(
    col_panel_light
);


draw_rectangle(
    ui.reset_x1,
    ui.button_y1,
    ui.reset_x2,
    ui.button_y2,
    false
);


draw_rectangle(
    ui.random_x1,
    ui.button_y1,
    ui.random_x2,
    ui.button_y2,
    false
);


draw_set_color(c_white);


draw_label(
    ui.reset_x1 + 39,
    ui.button_y1 + 17,
    "RESET"
);


draw_label(
    ui.random_x1 + 43,
    ui.button_y1 + 17,
    "RANDOM"
);


// =====================================================
// CENTER PANEL
// =====================================================

draw_set_color(
    col_panel
);


draw_rectangle(
    500,
    285,
    1000,
    815,
    false
);


// =====================================================
// GRID TITLE
// =====================================================

draw_set_color(c_white);


draw_label(
    520,
    303,
    "CRAFTING GRID"
);


// =====================================================
// SELECTED DISPLAY
// =====================================================

var selected_text =
    "SELECTED: NONE";


var selected_color =
    col_muted;


if (drag_kind == 2)
{
    if (
        drag_value >= 0 &&
        drag_value <
        array_length(resources)
    )
    {
        selected_text =
            "SELECTED: "
            +
            resources[
                drag_value
            ];


        selected_color =
            resource_colors[
                drag_value
            ];
    }
}


if (drag_kind == 1)
{
    selected_color =
        col_red;


    switch (drag_value)
    {
        case 3:
            selected_text =
                "SELECTED: FAIL";
        break;


        case 4:
            selected_text =
                "SELECTED: BACK";
        break;


        case 5:
            selected_text =
                "SELECTED: FIND";
        break;
    }
}


draw_set_color(
    selected_color
);


draw_label(
    790,
    303,
    selected_text
);


// =====================================================
// STATUS
// =====================================================

var status_text =
    "";


var status_recipe =
    find_grid_recipe();


var status_buff =
    get_buff();


var status_has_anything =
    false;


for (var status_cell = 0;
     status_cell < 9;
     status_cell++)
{
    if (
        grid_modules[
            status_cell
        ] != -1
        ||
        grid_items[
            status_cell
        ] != -1
    )
    {
        status_has_anything =
            true;


        break;
    }
}


if (craft_result == 1)
{
    status_text =
        "Davay po novoy, duraley!";
}
else if (craft_result == 2)
{
    status_text =
        "Ne vyshlo, braza :(";
}
else if (!status_has_anything)
{
    status_text =
        "Delayu deyliki / v svoih gachah, / poka ty tupish.";
}
else if (status_buff != -1)
{
    status_text =
        "Vot zh nakurolesil!";
}
else if (status_recipe != -1)
{
    status_text =
        "Ono pytalos...";
}
else
{
    status_text =
        "Nu i huynya!";
}


draw_set_color(
    col_purple
);


draw_rectangle(
    520,
    335,
    980,
    375,
    false
);


draw_set_color(c_white);


draw_label(
    540,
    348,
    status_text
);


// =====================================================
// GRID
// =====================================================

var active_buff =
    get_buff();


for (var grid_row = 0;
     grid_row < 3;
     grid_row++)
{
    for (var grid_col = 0;
         grid_col < 3;
         grid_col++)
    {
        var grid_index =
            grid_row * 3 +
            grid_col;


        var grid_cell_x =
            grid_x +
            grid_col *
            cell_size;


        var grid_cell_y =
            grid_y +
            grid_row *
            cell_size;


        // =============================================
        // CELL BACKGROUND
        // =============================================

        if (
            active_buff != -1 &&
            (
                grid_items[
                    grid_index
                ] != -1
                ||
                grid_modules[
                    grid_index
                ] >= 3
            )
        )
        {
            draw_set_color(
                col_purple
            );
        }
        else
        {
            draw_set_color(
                make_color_rgb(
                    52,
                    61,
                    76
                )
            );
        }


        draw_rectangle(
            grid_cell_x + 2,
            grid_cell_y + 2,
            grid_cell_x +
            cell_size - 2,
            grid_cell_y +
            cell_size - 2,
            false
        );


        draw_set_color(
            col_border
        );


        draw_rectangle(
            grid_cell_x + 2,
            grid_cell_y + 2,
            grid_cell_x +
            cell_size - 2,
            grid_cell_y +
            cell_size - 2,
            true
        );


        // =============================================
        // MODULE
        // =============================================

        if (
            grid_modules[
                grid_index
            ] != -1
        )
        {
            draw_module(
                grid_modules[
                    grid_index
                ],
                grid_cell_x + 10,
                grid_cell_y + 10,
                cell_size - 20
            );
        }


        // =============================================
        // BUFF NUMBER
        // =============================================

        if (
            grid_modules[
                grid_index
            ] >= 3
        )
        {
            draw_set_color(c_white);


            draw_label(
                grid_cell_x +
                cell_size - 25,
                grid_cell_y +
                cell_size - 27,

                string(
                    grid_modules[
                        grid_index
                    ] - 2
                )
            );
        }


        // =============================================
        // RESOURCE
        // =============================================

        if (
            grid_items[
                grid_index
            ] != -1
        )
        {
            var grid_resource =
                grid_items[
                    grid_index
                ];


            draw_set_color(
                resource_colors[
                    grid_resource
                ]
            );


            draw_text(
                grid_cell_x + 12,
                grid_cell_y +
                cell_size * 0.43,

                resources[
                    grid_resource
                ]
            );
        }
    }
}


// =====================================================
// CRAFT BUTTON
// =====================================================

draw_set_color(
    col_purple
);


draw_rectangle(
    ui.craft_x1,
    ui.button_y1,
    ui.craft_x2,
    ui.button_y2,
    false
);


draw_set_color(c_white);


draw_text(
    ui.craft_x1 + 59,
    ui.button_y1 + 15,
    "CRAFT"
);


// =====================================================
// FAILURE CALCULATION
// =====================================================

var chance_recipe =
    find_grid_recipe();


var base_text =
    "--";


var market_text =
    "0%";


var buff_text =
    "0%";


var final_text =
    "--";


var failure_market =
    get_market_failure_bonus();


var failure_buff =
    get_buff_rate(0);


if (failure_buff > 0)
{
    buff_text =
        "-"
        +
        string(
            failure_buff
        )
        +
        "%";
}
else
{
    buff_text =
        "0%";
}


if (chance_recipe != -1)
{
    var failure_ingredient_count =
        array_length(
            recipes[
                chance_recipe
            ].materials
        );


    var failure_base =
        get_final_failure_chance(
            failure_ingredient_count,
            get_discovered_count()
        );


    var failure_final =
        get_craft_failure(
            chance_recipe
        );


    base_text =
        string(
            failure_base
        )
        +
        "%";


    final_text =
        string(
            failure_final
        )
        +
        "%";
}


if (failure_market > 0)
{
    market_text =
        "+"
        +
        string(
            failure_market
        )
        +
        "%";
}
else
{
    market_text =
        string(
            failure_market
        )
        +
        "%";
}


// =====================================================
// RECIPE BOOK HEADER
// =====================================================

draw_set_color(
    col_panel_light
);


draw_rectangle(
    ui.book_x1,
    ui.book_y1,
    ui.book_x2,
    ui.book_header_y2,
    false
);


draw_set_color(c_white);


if (book_open)
{
    draw_label(
        ui.book_x1 + 20,
        ui.book_y1 + 15,
        "HIDE BOOK"
    );
}
else
{
    draw_label(
        ui.book_x1 + 20,
        ui.book_y1 + 15,
        "OPEN BOOK"
    );
}


// =====================================================
// BOOK
// =====================================================

if (book_open)
{
    draw_set_color(
        col_panel
    );


    draw_rectangle(
        ui.book_x1,
        ui.book_header_y2,
        ui.book_x2,
        ui.book_y2,
        false
    );


    var book_recipe =
        recipes[
            book_index
        ];


    draw_set_color(c_white);


    draw_label(
        ui.book_x1 + 20,
        ui.book_header_y2 + 18,
        "RECIPE BOOK"
    );


    // =================================================
    // RECIPE NAME
    // =====================================================

    draw_set_color(
        col_panel_light
    );


    draw_rectangle(
        ui.book_x1 + 18,
        ui.book_header_y2 + 52,
        ui.book_x2 - 18,
        ui.book_header_y2 + 92,
        false
    );


    draw_set_color(c_white);


    draw_label(
        ui.book_x1 + 32,
        ui.book_header_y2 + 65,
        book_recipe.name
    );


    // =================================================
    // DISCOVERY
    // =====================================================

    if (
        is_recipe_discovered(
            book_index
        )
    )
    {
        draw_set_color(
            col_green
        );


        draw_label(
            ui.book_x1 + 20,
            ui.book_header_y2 + 112,
            "DISCOVERED"
        );
    }
    else
    {
        draw_set_color(
            col_muted
        );


        draw_label(
            ui.book_x1 + 20,
            ui.book_header_y2 + 112,
            "NOT DISCOVERED"
        );
    }


    // =================================================
    // LOAD BUTTON
    // =====================================================

    var load_x1 =
        ui.book_x2 - 120;


    var load_x2 =
        ui.book_x2 - 20;


    var load_y1 =
        ui.book_header_y2 + 102;


    var load_y2 =
        ui.book_header_y2 + 137;


    draw_set_color(
        col_purple
    );


    draw_rectangle(
        load_x1,
        load_y1,
        load_x2,
        load_y2,
        false
    );


    draw_set_color(c_white);


    draw_label(
        load_x1 + 28,
        load_y1 + 10,
        "LOAD"
    );


    // =================================================
    // INGREDIENTS
    // =====================================================

    draw_set_color(c_white);


    draw_label(
        ui.book_x1 + 20,
        ui.book_header_y2 + 145,
        "INGREDIENTS"
    );


    var ingredient_count =
        array_length(
            book_recipe.materials
        );


    var ingredients_start_y =
        ui.book_header_y2 + 180;


    var ingredients_end_y =
        ui.book_y2 - 20;


    var ingredient_gap =
        36;


    if (ingredient_count > 1)
    {
        ingredient_gap =
            (
                ingredients_end_y -
                ingredients_start_y
            )
            /
            (
                ingredient_count - 1
            );


        if (ingredient_gap > 36)
        {
            ingredient_gap = 36;
        }


        if (ingredient_gap < 25)
        {
            ingredient_gap = 25;
        }
    }


    for (var ingredient_i = 0;
         ingredient_i <
         ingredient_count;
         ingredient_i++)
    {
        var ingredient =
            book_recipe.materials[
                ingredient_i
            ];


        var ingredient_y =
            ingredients_start_y +
            ingredient_i *
            ingredient_gap;


        var ingredient_color =
            c_white;


        for (var color_i = 0;
             color_i <
             array_length(resources);
             color_i++)
        {
            if (
                resources[
                    color_i
                ] ==
                ingredient.tag
            )
            {
                ingredient_color =
                    resource_colors[
                        color_i
                    ];


                break;
            }
        }


        draw_set_color(
            ingredient_color
        );


        draw_rectangle(
            ui.book_x1 + 20,
            ingredient_y + 1,
            ui.book_x1 + 27,
            ingredient_y + 20,
            false
        );


        draw_label(
            ui.book_x1 + 40,
            ingredient_y,
            ingredient.tag
        );


        draw_set_color(c_white);


        draw_label(
            ui.book_x2 - 75,
            ingredient_y,

            string(
                ingredient.percentage
            )
            +
            "%"
        );
    }
}


// =====================================================
// FAILURE PANEL
// =====================================================

draw_set_color(
    make_color_rgb(
        30,
        36,
        47
    )
);


draw_rectangle(
    1080,
    670,
    1530,
    815,
    false
);


draw_set_color(c_white);


draw_label(
    1100,
    684,
    "CRAFT FAILURE"
);


// =====================================================
// BASE
// =====================================================

draw_set_color(
    col_muted
);


draw_label(
    1100,
    710,
    "BASE + KNOWLEDGE"
);


draw_set_color(c_white);


draw_label(
    1460,
    710,
    base_text
);


// =====================================================
// MARKET EVENT
// =====================================================

var market_label =
    "MARKET";


if (
    variable_global_exists(
        "market_event_name"
    )
)
{
    if (
        global.market_event_name != ""
        &&
        global.market_event_name != "NONE"
    )
    {
        market_label =
            global.market_event_name;


        if (
            variable_global_exists(
                "market_event_timer"
            )
        )
        {
            var market_seconds_left =
                ceil(
                    global.market_event_timer
                    /
                    room_speed
                );


            if (
                market_seconds_left < 0
            )
            {
                market_seconds_left = 0;
            }


            market_label +=
                " / "
                +
                string(
                    market_seconds_left
                )
                +
                "s";
        }
    }
}


// =====================================================
// MARKET COLOR
// =====================================================

if (failure_market > 0)
{
    draw_set_color(
        col_red
    );
}
else if (failure_market < 0)
{
    draw_set_color(
        col_green
    );
}
else
{
    draw_set_color(
        col_muted
    );
}


draw_label(
    1100,
    732,
    market_label
);


if (failure_market > 0)
{
    draw_set_color(
        col_red
    );
}
else if (failure_market < 0)
{
    draw_set_color(
        col_green
    );
}
else
{
    draw_set_color(c_white);
}


draw_label(
    1460,
    732,
    market_text
);


// =====================================================
// BUFF
// =====================================================

if (failure_buff > 0)
{
    draw_set_color(
        col_red
    );
}
else
{
    draw_set_color(
        col_muted
    );
}


draw_label(
    1100,
    754,
    "BUFF"
);


draw_label(
    1460,
    754,
    buff_text
);


// =====================================================
// FINAL
// =====================================================

draw_set_color(
    col_purple
);


draw_rectangle(
    1095,
    775,
    1515,
    808,
    false
);


draw_set_color(c_white);


draw_label(
    1110,
    785,
    "FINAL FAIL CHANCE"
);


draw_set_color(
    col_yellow
);


draw_label(
    1450,
    785,
    final_text
);


// =====================================================
// ACTIVE BUFFS
// =====================================================

draw_set_color(
    col_panel
);


draw_rectangle(
    1080,
    825,
    1530,
    870,
    false
);


draw_set_color(
    col_red
);


draw_small(
    1100,
    842,

    "FAIL -"
    +
    string(
        get_buff_rate(0)
    )
    +
    "%"
);


draw_small(
    1235,
    842,

    "BACK "
    +
    string(
        get_buff_rate(1)
    )
    +
    "%"
);


draw_small(
    1370,
    842,

    "FIND "
    +
    string(
        get_buff_rate(2)
    )
    +
    "%"
);


// =====================================================
// CRAFT NOTE
// =====================================================

if (craft_note != "")
{
    if (craft_result == 1)
    {
        draw_set_color(
            col_green
        );
    }
    else if (craft_result == 2)
    {
        draw_set_color(
            col_red
        );
    }
    else
    {
        draw_set_color(
            col_yellow
        );
    }


    draw_text(
        520,
        835,
        craft_note
    );
}


// =====================================================
// CONTROL HINT
// =====================================================

draw_set_color(
    col_muted
);


draw_small(
    520,
    860,
    "LMB: PLACE / RMB: CLEAR / LOAD: RECIPE TEMPLATE"
);


// =====================================================
// RESET DRAW STATE
// =====================================================

draw_set_font(-1);
draw_set_color(c_white);
draw_set_alpha(1);