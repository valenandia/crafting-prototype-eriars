/// obj_minigame_ui - Create

display_set_gui_size(1600, 900);

ui = {
    module_x: 38, module_y: 88, module_gap: 75, module_size: 55,
    pool_x1: 28, pool_y1: 178, pool_x2: 290, pool_y2: 438,
    resource_x1: 42, resource_x2: 276, resource_y: 222,
    resource_gap: 37, resource_height: 31, visible_rows: 5,
    pool_nav_y1: 407, pool_nav_y2: 434,
    grid_x: 340, grid_y: 228, cell_size: 75,
    reset_x1: 42, reset_x2: 143,
    random_x1: 154, random_x2: 275,
    craft_x1: 397, craft_x2: 509,
    button_y1: 470, button_y2: 512,
    book_x1: 605, book_x2: 935,
    book_y1: 178, book_y2: 438,
    book_header_y2: 207,
    book_nav_y1: 407, book_nav_y2: 434
};

resources = [];
resource_counts = [];
resource_modules = [];
resource_tags = [];
resource_colors = [];
resource_variants = [];

var groups = [
    "stone", "polyester", "tree", "cloth",
    "glass", "jewels", "mushrooms", "blood"
];

var variant_counts = [1, 2, 3, 3, 3, 4, 4, 5];

// 0..2 — обычные модули для ресурсов.
// 3..5 — три разных modul_buff.
var module_types = [0, 0, 0, 1, 1, 1, 2, 2];

var group_colors = [
    make_color_rgb(150, 150, 150),
    make_color_rgb(255, 100, 180),
    make_color_rgb(80, 190, 90),
    make_color_rgb(240, 210, 60),
    make_color_rgb(80, 210, 240),
    make_color_rgb(60, 100, 255),
    make_color_rgb(140, 90, 50),
    make_color_rgb(220, 40, 40)
];

for (var g = 0; g < array_length(groups); g++) {
    for (var v = 1; v <= variant_counts[g]; v++) {
        array_push(resources, groups[g] + "_" + string(v));
        array_push(resource_counts, 0);
        array_push(resource_modules, module_types[g]);
        array_push(resource_tags, groups[g]);
        array_push(resource_colors, group_colors[g]);
        array_push(resource_variants, v);
    }
}

resource_scroll = 0;

recipes = create_concrete_recipes();
discovered = array_create(array_length(recipes), false);
discovered_count = 0;

book_index = 0;
book_open = true;

grid_x = ui.grid_x;
grid_y = ui.grid_y;
cell_size = ui.cell_size;

grid_modules = array_create(9, -1);
grid_items = array_create(9, -1);

// drag_kind: 0 — ничего; 1 — модуль; 2 — ресурс.
drag_kind = 0;
drag_value = -1;
drag_from = -1;

// 0 — обычное состояние; 1 — успех; 2 — неудача.
craft_result = 0;
craft_note = "";

// Проверяем фигуру по занятым клеткам.
// Звезда занимает клетку сама, без ресурса.
get_buff = function() {
    var patterns = [
        [1, 4, 6, 7, 8],
        [1, 3, 4, 5, 7],
        [0, 2, 4, 6, 8],
        [0, 4, 8],
        [2, 4, 6],
        [0, 2, 4, 7],
        [4, 8],
        [0, 1]
    ];

    for (var p = 0; p < array_length(patterns); p++) {
        var same = true;

        for (var cell = 0; cell < 9; cell++) {
            var required = false;

            for (var k = 0; k < array_length(patterns[p]); k++) {
                if (patterns[p][k] == cell) {
                    required = true;
                    break;
                }
            }

            var active =
                grid_modules[cell] >= 3 ||
                grid_items[cell] != -1;

            if (active != required) {
                same = false;
                break;
            }
        }

        if (same) return p;
    }

    return -1;
};

// Ищем рецепт только по ресурсам.
// Звёзды не являются ингредиентами.
find_grid_recipe = function() {
    var filled = 0;

    for (var cell = 0; cell < 9; cell++) {
        if (grid_modules[cell] >= 3) {
            // Ресурс внутри звезды недопустим.
            if (grid_items[cell] != -1) return -1;
            continue;
        }

        // Пустой обычный модуль — рецепт не готов.
        if (grid_modules[cell] != -1 &&
            grid_items[cell] == -1) {
            return -1;
        }

        if (grid_items[cell] != -1) {
            if (grid_modules[cell] !=
                resource_modules[grid_items[cell]]) {
                return -1;
            }

            filled++;
        }
    }

    if (filled == 0) return -1;

    for (var p = 0; p < array_length(recipes); p++) {
        var ingredients = recipes[p].materials;

        if (array_length(ingredients) != filled) {
            continue;
        }

        var all_found = true;

        for (var k = 0; k < array_length(ingredients); k++) {
            var matches = 0;

            for (var cell = 0; cell < 9; cell++) {
                if (grid_items[cell] != -1 &&
                    resources[grid_items[cell]] ==
                    ingredients[k].tag) {
                    matches++;
                }
            }

            if (matches != 1) {
                all_found = false;
                break;
            }
        }

        if (all_found) return p;
    }

    return -1;
};

// 0: снижение ошибки.
// 1: шанс вернуть ресурс.
// 2: шанс открыть рецепт.
get_buff_rate = function(_type) {
    var base = [10, 30, 2];

    for (var cell = 0; cell < 9; cell++) {
        if (grid_modules[cell] == _type + 3) {
            var multiplier =
                get_buff() != -1 ? 1.25 : 1;

            return base[_type] * multiplier;
        }
    }

    return 0;
};

get_craft_failure = function(_recipe_index) {
    if (_recipe_index == -1) return -1;

    var base_failure =
        get_final_failure_chance(
            array_length(
                recipes[_recipe_index].materials
            ),
            discovered_count
        );

    return max(
        0,
        base_failure - get_buff_rate(0)
    );
};
// =====================================================
// ECONOMY BRIDGE
// =====================================================

// Получить количество ресурса из общей экономики.
get_resource_count = function(_resource_index)
{
    var group = resource_tags[_resource_index];

    return global.material_pool[$ group];
};


// Потратить ресурс из общей экономики.
spend_resource = function(_resource_index, _amount)
{
    var group = resource_tags[_resource_index];

    global.material_pool[$ group] =
        max(
            0,
            global.material_pool[$ group] - _amount
        );
};


// Вернуть ресурс в общую экономику.
return_resource = function(_resource_index, _amount)
{
    var group = resource_tags[_resource_index];

    global.material_pool[$ group] += _amount;
};