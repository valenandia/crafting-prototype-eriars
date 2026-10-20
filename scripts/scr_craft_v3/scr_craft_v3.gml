/// scr_craft_v3
/// CRAFTING V3.1

// =====================================================
// RESOURCES
// =====================================================

function craft_v3_groups()
{
    return [
        "stone", "polyester", "tree", "cloth",
        "glass", "jewels", "mushrooms", "blood"
    ];
}

function craft_v3_variant_counts()
{
    return [1, 2, 3, 3, 3, 4, 4, 5];
}

function craft_v3_group_colors()
{
    return [
        make_color_rgb(150,150,150),
        make_color_rgb(255,100,180),
        make_color_rgb(80,190,90),
        make_color_rgb(240,210,60),
        make_color_rgb(80,210,240),
        make_color_rgb(60,100,255),
        make_color_rgb(150,90,30),
        make_color_rgb(220,40,40)
    ];
}

function craft_v3_group_index(_name)
{
    var groups = craft_v3_groups();

    for (var i = 0; i < array_length(groups); i++)
    {
        if (groups[i] == _name) return i;
    }

    return -1;
}

// =====================================================
// RECIPES
// =====================================================

function craft_v3_recipes()
{
    return [
        {
            id:"item_01",
            name:"Thanos' Stone Gauntlet",
            category:"GAUNTLET",
            pattern:[0,1,0,2,1,2],
            ingredients:[
                {group:"stone",amount:20},
                {group:"glass",amount:20},
                {group:"jewels",amount:60}
            ]
        },
        {
            id:"item_02",
            name:"Rapunzel's Crown",
            category:"CROWN",
            pattern:[2,1,2,-1,0,-1],
            ingredients:[
                {group:"jewels",amount:60},
                {group:"glass",amount:40}
            ]
        },
        {
            id:"item_03",
            name:"Mycelium Dress",
            category:"DRESS",
            pattern:[1,-1,1,2,1,2],
            ingredients:[
                {group:"mushrooms",amount:60},
                {group:"blood",amount:20},
                {group:"cloth",amount:20}
            ]
        },
        {
            id:"item_04",
            name:"Vampire Grillz",
            category:"GRILLZ",
            pattern:[2,0,2,-1,1,-1],
            ingredients:[
                {group:"jewels",amount:70},
                {group:"blood",amount:30}
            ]
        },
        {
            id:"item_05",
            name:"Baba Yaga's Mortar & Potion",
            category:"POTION",
            pattern:[0,1,-1,0,2,-1],
            ingredients:[
                {group:"stone",amount:60},
                {group:"tree",amount:40}
            ]
        },
        {
            id:"item_06",
            name:"Tung Tung Tung Sahur",
            category:"TOTEM",
            pattern:[-1,0,-1,-1,0,-1],
            ingredients:[
                {group:"tree",amount:100}
            ]
        },
        {
            id:"item_07",
            name:"Legendary Thong",
            category:"UNDERWEAR",
            pattern:[1,-1,1,-1,2,-1],
            ingredients:[
                {group:"polyester",amount:60},
                {group:"cloth",amount:40}
            ]
        },
        {
            id:"item_08",
            name:"Cyber Fairy Wings",
            category:"WINGS",
            pattern:[2,1,2,0,-1,0],
            ingredients:[
                {group:"polyester",amount:40},
                {group:"glass",amount:40},
                {group:"jewels",amount:20}
            ]
        },
        {
            id:"item_09",
            name:"Forbidden Mushroom Smoothie",
            category:"POTION",
            pattern:[0,1,-1,0,2,-1],
            ingredients:[
                {group:"mushrooms",amount:50},
                {group:"blood",amount:20},
                {group:"glass",amount:30}
            ]
        },
        {
            id:"item_10",
            name:"Cursed Disco Ball",
            category:"ARTIFACT",
            pattern:[2,1,2,1,0,1],
            ingredients:[
                {group:"glass",amount:40},
                {group:"jewels",amount:40},
                {group:"polyester",amount:20}
            ]
        }
    ];
}

// =====================================================
// RECIPE MATCHING
// =====================================================

function craft_v3_match_pattern(_upper, _pattern)
{
    for (var i = 0; i < 6; i++)
    {
        if (_upper[i] != _pattern[i]) return false;
    }

    return true;
}

function craft_v3_find_recipe(_upper, _stacks)
{
    var recipes = craft_v3_recipes();
    var totals = array_create(8, 0);
    var total_amount = 0;

    for (var i = 0; i < array_length(_stacks); i++)
    {
        var stack = _stacks[i];
        var group_index = craft_v3_group_index(stack.group);

        if (group_index >= 0)
        {
            totals[group_index] += stack.amount;
            total_amount += stack.amount;
        }
    }

    if (total_amount != 100) return -1;

    for (var recipe_i = 0; recipe_i < array_length(recipes); recipe_i++)
    {
        var recipe = recipes[recipe_i];

        if (!craft_v3_match_pattern(_upper, recipe.pattern))
            continue;

        var expected = array_create(8, 0);

        for (var ing_i = 0;
             ing_i < array_length(recipe.ingredients);
             ing_i++)
        {
            var ing = recipe.ingredients[ing_i];
            var idx = craft_v3_group_index(ing.group);

            if (idx >= 0) expected[idx] = ing.amount;
        }

        var valid = true;

        for (var group_i = 0; group_i < 8; group_i++)
        {
            if (totals[group_i] != expected[group_i])
            {
                valid = false;
                break;
            }
        }

        if (valid) return recipe_i;
    }

    return -1;
}

// =====================================================
// QUALITY
//
// 35 base
// + weighted variant bonus
// + diversity bonus
//
// A recipe accepts any variant within its group.
// =====================================================

function craft_v3_quality(_stacks)
{
    var total = 0;
    var weighted_variant = 0;
    var distinct = 0;

    for (var i = 0; i < array_length(_stacks); i++)
    {
        var stack = _stacks[i];

        if (stack.amount <= 0) continue;

        var group_index = craft_v3_group_index(stack.group);
        if (group_index < 0) continue;

        var counts = craft_v3_variant_counts();
        var max_variant = counts[group_index];

        var normalized = 0;

        if (max_variant > 1)
        {
            normalized =
                (stack.variant - 1) / (max_variant - 1);
        }

        normalized = clamp(normalized, 0, 1);

        weighted_variant += normalized * stack.amount;
        total += stack.amount;
        distinct++;
    }

    if (total <= 0) return 0;

    var variant_bonus = 40 * weighted_variant / total;
    var diversity_bonus = min(25, max(0, distinct - 1) * 5);

    return clamp(
        round(35 + variant_bonus + diversity_bonus),
        1,
        100
    );
}

// =====================================================
// RARITY
// =====================================================

function craft_v3_rarity(_quality)
{
    if (_quality >= 90) return 3;
    if (_quality >= 70) return 2;
    if (_quality >= 50) return 1;

    return 0;
}

function craft_v3_rarity_name(_quality)
{
    switch (craft_v3_rarity(_quality))
    {
        case 0: return "COMMON";
        case 1: return "UNCOMMON";
        case 2: return "RARE";
        case 3: return "LEGENDARY";
    }

    return "COMMON";
}

function craft_v3_rarity_color(_quality)
{
    switch (craft_v3_rarity(_quality))
    {
        case 0: return make_color_rgb(170,175,185);
        case 1: return make_color_rgb(90,210,125);
        case 2: return make_color_rgb(85,140,255);
        case 3: return make_color_rgb(245,195,70);
    }

    return c_white;
}

// =====================================================
// BUFF SHAPES
//
// Shape must match exactly occupied cells.
// Pattern cells can contain any buff type.
// =====================================================

function craft_v3_buff_patterns()
{
    return [
        [1,4,6,7,8],
        [1,3,4,5,7],
        [0,2,4,6,8],
        [0,4,8],
        [2,4,6],
        [0,2,4,7],
        [4,8],
        [0,1]
    ];
}

function craft_v3_buff_shape(_cells)
{
    var patterns = craft_v3_buff_patterns();

    for (var p = 0; p < array_length(patterns); p++)
    {
        var pattern = patterns[p];
        var valid = true;

        for (var cell_i = 0; cell_i < 9; cell_i++)
        {
            var expected_occupied = false;

            for (var j = 0; j < array_length(pattern); j++)
            {
                if (pattern[j] == cell_i)
                {
                    expected_occupied = true;
                    break;
                }
            }

            var actually_occupied = _cells[cell_i] != -1;

            if (expected_occupied != actually_occupied)
            {
                valid = false;
                break;
            }
        }

        if (valid) return p;
    }

    return -1;
}

// =====================================================
// INVENTORY INITIALIZATION
// =====================================================

function craft_v3_ensure_inventory()
{
    if (!variable_global_exists("item_inventory"))
        global.item_inventory = {};

    if (!is_struct(global.item_inventory))
        global.item_inventory = {};

    if (!variable_global_exists("item_quality_inventory"))
        global.item_quality_inventory = {};

    if (!is_struct(global.item_quality_inventory))
        global.item_quality_inventory = {};

    var recipes = craft_v3_recipes();

    for (var i = 0; i < array_length(recipes); i++)
    {
        var item_id = recipes[i].id;

        if (!variable_struct_exists(global.item_inventory, item_id))
        {
            variable_struct_set(
                global.item_inventory, item_id, 0
            );
        }

        if (!variable_struct_exists(
            global.item_quality_inventory, item_id))
        {
            variable_struct_set(
                global.item_quality_inventory,
                item_id,
                []
            );
        }
    }
}

// =====================================================
// ADD ITEM WITH QUALITY
//
// Old inventory: total count
// New inventory: quality stacks
// =====================================================

function craft_v3_add_item(_recipe_index, _quality)
{
    var recipes = craft_v3_recipes();

    if (_recipe_index < 0 ||
        _recipe_index >= array_length(recipes))
    {
        return false;
    }

    craft_v3_ensure_inventory();

    var item_id = recipes[_recipe_index].id;
    var owned = variable_struct_get(global.item_inventory, item_id);

    if (!is_real(owned)) owned = 0;

    variable_struct_set(
        global.item_inventory,
        item_id,
        owned + 1
    );

    var stacks = variable_struct_get(
        global.item_quality_inventory,
        item_id
    );

    var found = false;

    for (var i = 0; i < array_length(stacks); i++)
    {
        if (stacks[i].quality == _quality)
        {
            stacks[i].amount++;
            found = true;
            break;
        }
    }

    if (!found)
    {
        array_push(
            stacks,
            {
                quality: _quality,
                rarity: craft_v3_rarity(_quality),
                amount: 1
            }
        );
    }

    variable_struct_set(
        global.item_quality_inventory,
        item_id,
        stacks
    );

    return true;
}

// =====================================================
// DISCOVERY
// =====================================================

function craft_v3_is_discovered(_recipe_index)
{
    var recipes = craft_v3_recipes();

    if (_recipe_index < 0 ||
        _recipe_index >= array_length(recipes))
        return false;

    if (!variable_global_exists("discovered_items"))
        return false;

    var item_id = recipes[_recipe_index].id;

    for (var i = 0; i < array_length(global.discovered_items); i++)
    {
        if (global.discovered_items[i] == item_id)
            return true;
    }

    return false;
}

function craft_v3_discover(_recipe_index)
{
    var recipes = craft_v3_recipes();

    if (_recipe_index < 0 ||
        _recipe_index >= array_length(recipes))
        return false;

    if (!variable_global_exists("discovered_items"))
        global.discovered_items = [];

    if (craft_v3_is_discovered(_recipe_index))
        return false;

    array_push(
        global.discovered_items,
        recipes[_recipe_index].id
    );

    return true;
}

// =====================================================
// CRAFTING V3.2 - QUALITY ECONOMY
// =====================================================

// -----------------------------------------------------
// PRICE MULTIPLIER BY RARITY
// -----------------------------------------------------

function craft_v3_quality_multiplier(_quality)
{
    if (_quality >= 90) return 2.50;
    if (_quality >= 70) return 1.75;
    if (_quality >= 50) return 1.25;

    return 1.00;
}


// -----------------------------------------------------
// BASE ITEM SELL PRICE
//
// Temporary economy values.
// Can later be moved into recipe configs.
// -----------------------------------------------------

function craft_v3_base_sell_price(_recipe_index)
{
    var prices = [
        180, // Thanos' Stone Gauntlet
        150, // Rapunzel's Crown
        120, // Mycelium Dress
        100, // Vampire Grillz
         90, // Baba Yaga's Mortar & Potion
         65, // Tung Tung Tung Sahur
         50, // Legendary Thong
        140, // Cyber Fairy Wings
         85, // Forbidden Mushroom Smoothie
        160  // Cursed Disco Ball
    ];

    if (_recipe_index < 0 ||
        _recipe_index >= array_length(prices))
    {
        return 0;
    }

    return prices[_recipe_index];
}


// -----------------------------------------------------
// CALCULATE SELL PRICE
// -----------------------------------------------------

function craft_v3_sell_price(_recipe_index, _quality)
{
    var base_price =
        craft_v3_base_sell_price(_recipe_index);

    var multiplier =
        craft_v3_quality_multiplier(_quality);

    return round(base_price * multiplier);
}


// -----------------------------------------------------
// SELL ONE QUALITY STACK ITEM
//
// _recipe_index: 0..9
// _quality: exact quality, e.g. 76
//
// Returns earned credits, or 0 on failure.
// -----------------------------------------------------

function craft_v3_sell_quality_item(_recipe_index, _quality)
{
    var recipes = craft_v3_recipes();

    if (_recipe_index < 0 ||
        _recipe_index >= array_length(recipes))
    {
        return 0;
    }

    craft_v3_ensure_inventory();

    if (!variable_global_exists("credits"))
    {
        global.credits = 0;
    }

    var item_id = recipes[_recipe_index].id;

    var quality_stacks = variable_struct_get(
        global.item_quality_inventory,
        item_id
    );

    var stack_index = -1;

    for (var i = 0; i < array_length(quality_stacks); i++)
    {
        if (
            quality_stacks[i].quality == _quality &&
            quality_stacks[i].amount > 0
        )
        {
            stack_index = i;
            break;
        }
    }

    if (stack_index == -1)
    {
        return 0;
    }

    var owned = variable_struct_get(
        global.item_inventory,
        item_id
    );

    if (!is_real(owned) || owned <= 0)
    {
        return 0;
    }

    var sell_price =
        craft_v3_sell_price(_recipe_index, _quality);

    // Remove one item from quality inventory.
    quality_stacks[stack_index].amount--;

    if (quality_stacks[stack_index].amount <= 0)
    {
        array_delete(quality_stacks, stack_index, 1);
    }

    variable_struct_set(
        global.item_quality_inventory,
        item_id,
        quality_stacks
    );

    // Remove one from shared inventory.
    variable_struct_set(
        global.item_inventory,
        item_id,
        owned - 1
    );

    // Pay credits.
    global.credits += sell_price;

    return sell_price;
}


// -----------------------------------------------------
// GET QUALITY STACKS FOR A RECIPE
// -----------------------------------------------------

function craft_v3_get_quality_stacks(_recipe_index)
{
    var recipes = craft_v3_recipes();

    if (_recipe_index < 0 ||
        _recipe_index >= array_length(recipes))
    {
        return [];
    }

    craft_v3_ensure_inventory();

    return variable_struct_get(
        global.item_quality_inventory,
        recipes[_recipe_index].id
    );
}

// =====================================================
// CRAFTING V3.3
// INVENTORY SYNCHRONIZATION
// =====================================================

// Returns the total number of items in quality stacks.
function craft_v3_quality_total(_recipe_index)
{
    var stacks = craft_v3_get_quality_stacks(_recipe_index);
    var total = 0;

    for (var i = 0; i < array_length(stacks); i++)
    {
        total += max(0, stacks[i].amount);
    }

    return total;
}


// Reconcile legacy inventory with quality inventory.
//
// Legacy items without quality data become Common Q35.
// If quality stacks exceed the shared inventory count,
// excess entries are removed from the end.
//
// Call after loading saved inventory or before selling.
function craft_v3_sync_inventory(_recipe_index)
{
    var recipes = craft_v3_recipes();

    if (_recipe_index < 0 ||
        _recipe_index >= array_length(recipes))
    {
        return false;
    }

    craft_v3_ensure_inventory();

    var item_id = recipes[_recipe_index].id;

    var owned = variable_struct_get(
        global.item_inventory,
        item_id
    );

    if (!is_real(owned))
    {
        owned = 0;
    }

    owned = max(0, floor(owned));

    var stacks = craft_v3_get_quality_stacks(_recipe_index);

    var quality_total = 0;

    for (var i = 0; i < array_length(stacks); i++)
    {
        quality_total += max(0, stacks[i].amount);
    }

    // Add legacy items with unknown quality.
    if (quality_total < owned)
    {
        var missing = owned - quality_total;
        var found_common = false;

        for (var i = 0; i < array_length(stacks); i++)
        {
            if (stacks[i].quality == 35)
            {
                stacks[i].amount += missing;
                found_common = true;
                break;
            }
        }

        if (!found_common)
        {
            array_push(
                stacks,
                {
                    quality:35,
                    rarity:craft_v3_rarity(35),
                    amount:missing
                }
            );
        }
    }

    // Remove excess quality entries.
    if (quality_total > owned)
    {
        var excess = quality_total - owned;

        for (var i = array_length(stacks) - 1; i >= 0; i--)
        {
            if (excess <= 0)
            {
                break;
            }

            var remove_count = min(
                excess,
                stacks[i].amount
            );

            stacks[i].amount -= remove_count;
            excess -= remove_count;

            if (stacks[i].amount <= 0)
            {
                array_delete(stacks, i, 1);
            }
        }
    }

    variable_struct_set(
        global.item_quality_inventory,
        item_id,
        stacks
    );

    return true;
}


// Sell one item, optionally selecting its exact quality.
//
// _quality = -1 means sell the lowest-quality item.
//
// Returns earned credits or 0 on failure.
function craft_v3_sell_item(_recipe_index, _quality)
{
    var recipes = craft_v3_recipes();

    if (_recipe_index < 0 ||
        _recipe_index >= array_length(recipes))
    {
        return 0;
    }

    craft_v3_sync_inventory(_recipe_index);

    var item_id = recipes[_recipe_index].id;
    var stacks = craft_v3_get_quality_stacks(_recipe_index);

    var selected_index = -1;
    var selected_quality = 999;

    for (var i = 0; i < array_length(stacks); i++)
    {
        if (stacks[i].amount <= 0)
        {
            continue;
        }

        if (_quality >= 0)
        {
            if (stacks[i].quality == _quality)
            {
                selected_index = i;
                break;
            }
        }
        else
        {
            if (stacks[i].quality < selected_quality)
            {
                selected_quality = stacks[i].quality;
                selected_index = i;
            }
        }
    }

    if (selected_index == -1)
    {
        return 0;
    }

    var quality = stacks[selected_index].quality;

    var earned = craft_v3_sell_price(
        _recipe_index,
        quality
    );

    if (earned <= 0)
    {
        return 0;
    }

    var owned = variable_struct_get(
        global.item_inventory,
        item_id
    );

    if (!is_real(owned) || owned <= 0)
    {
        return 0;
    }

    // Remove from quality stack.
    stacks[selected_index].amount--;

    if (stacks[selected_index].amount <= 0)
    {
        array_delete(stacks, selected_index, 1);
    }

    variable_struct_set(
        global.item_quality_inventory,
        item_id,
        stacks
    );

    // Remove from shared inventory.
    variable_struct_set(
        global.item_inventory,
        item_id,
        owned - 1
    );

    if (!variable_global_exists("credits"))
    {
        global.credits = 0;
    }

    global.credits += earned;

    return earned;
}

// =====================================================
// CRAFTING V3.4 - ITEM VISUALS
// Add to the END of scr_craft_v3
// =====================================================

function craft_v3_item_icon(_index, _cx, _cy, _size, _quality)
{
    var old_color = draw_get_color();
    var old_alpha = draw_get_alpha();

    var accent = craft_v3_rarity_color(_quality);
    var dark = make_color_rgb(35, 40, 53);
    var metal = make_color_rgb(185, 195, 215);
    var gold = make_color_rgb(245, 195, 80);
    var red = make_color_rgb(220, 65, 90);
    var green = make_color_rgb(110, 210, 135);
    var blue = make_color_rgb(100, 190, 240);

    var s = _size / 100;

    // Background
    draw_set_color(dark);
    draw_rectangle(
        _cx - 50*s, _cy - 50*s,
        _cx + 50*s, _cy + 50*s,
        false
    );

    // Rarity frame
    draw_set_color(accent);
    draw_rectangle(
        _cx - 48*s, _cy - 48*s,
        _cx + 48*s, _cy + 48*s,
        true
    );

    switch (_index)
    {
        // 01 - Thanos' Stone Gauntlet
        case 0:
        {
            draw_set_color(metal);
            draw_rectangle(
                _cx - 21*s, _cy - 4*s,
                _cx + 21*s, _cy + 31*s, false
            );

            for (var i = 0; i < 4; i++)
            {
                draw_rectangle(
                    _cx + (-19+i*11)*s, _cy - 30*s,
                    _cx + (-11+i*11)*s, _cy + 3*s,
                    false
                );
            }

            var gems = [
                c_red, c_blue, c_lime, c_yellow, c_fuchsia
            ];

            for (var i = 0; i < 5; i++)
            {
                var gx = _cx + (-16+i*8)*s;
                var gy = _cy + 12*s;

                draw_set_color(gems[i]);
                draw_circle(gx, gy, 3*s, false);
            }
            break;
        }

        // 02 - Rapunzel's Crown
        case 1:
        {
            draw_set_color(gold);
            draw_rectangle(
                _cx - 32*s, _cy + 11*s,
                _cx + 32*s, _cy + 27*s, false
            );

            for (var i = 0; i < 5; i++)
            {
                var px = _cx + (-26+i*13)*s;

                draw_triangle(
                    px-7*s, _cy+12*s,
                    px+7*s, _cy+12*s,
                    px, _cy-26*s,
                    false
                );
            }

            draw_set_color(blue);
            draw_circle(_cx, _cy+14*s, 7*s, false);
            break;
        }

        // 03 - Mycelium Dress
        case 2:
        {
            draw_set_color(green);

            draw_triangle(
                _cx, _cy-32*s,
                _cx-33*s, _cy+31*s,
                _cx+33*s, _cy+31*s,
                false
            );

            draw_set_color(red);
            draw_rectangle(
                _cx-14*s, _cy-10*s,
                _cx+14*s, _cy+2*s,
                false
            );

            draw_set_color(c_white);

            for (var i = 0; i < 5; i++)
            {
                draw_circle(
                    _cx + (-20+i*10)*s,
                    _cy+22*s,
                    3*s,
                    false
                );
            }
            break;
        }

        // 04 - Vampire Grillz
        case 3:
        {
            draw_set_color(metal);
            draw_ellipse(
                _cx-35*s, _cy-14*s,
                _cx+35*s, _cy+19*s,
                false
            );

            draw_set_color(dark);

            for (var i = 0; i < 5; i++)
            {
                var tx = _cx + (-20+i*10)*s;

                draw_rectangle(
                    tx-2*s, _cy-7*s,
                    tx+2*s, _cy+12*s,
                    false
                );
            }

            draw_set_color(red);
            draw_circle(_cx, _cy-9*s, 5*s, false);
            break;
        }

        // 05 - Baba Yaga's Mortar & Potion
        case 4:
        {
            draw_set_color(metal);
            draw_ellipse(
                _cx-33*s, _cy-3*s,
                _cx+33*s, _cy+28*s,
                false
            );

            draw_set_color(green);
            draw_ellipse(
                _cx-27*s, _cy-10*s,
                _cx+27*s, _cy+5*s,
                false
            );

            draw_set_color(gold);
            draw_line_width(
                _cx+8*s, _cy-31*s,
                _cx-8*s, _cy+9*s,
                6*s
            );
            break;
        }

        // 06 - Tung Tung Tung Sahur
        case 5:
        {
            draw_set_color(make_color_rgb(145,90,48));
            draw_rectangle(
                _cx-19*s, _cy-32*s,
                _cx+19*s, _cy+32*s,
                false
            );

            draw_set_color(c_white);
            draw_circle(_cx-9*s, _cy-13*s, 5*s, false);
            draw_circle(_cx+9*s, _cy-13*s, 5*s, false);

            draw_set_color(dark);
            draw_circle(_cx-9*s, _cy-13*s, 2*s, false);
            draw_circle(_cx+9*s, _cy-13*s, 2*s, false);

            draw_set_color(dark);
            draw_rectangle(
                _cx-10*s, _cy+12*s,
                _cx+10*s, _cy+16*s,
                false
            );
            break;
        }

        // 07 - Legendary Thong
        case 6:
        {
            draw_set_color(make_color_rgb(245,110,180));

            draw_triangle(
                _cx-32*s, _cy-20*s,
                _cx+32*s, _cy-20*s,
                _cx, _cy+28*s,
                false
            );

            draw_set_color(gold);
            draw_line_width(
                _cx-32*s, _cy-20*s,
                _cx+32*s, _cy-20*s,
                4*s
            );
            break;
        }

        // 08 - Cyber Fairy Wings
        case 7:
        {
            draw_set_color(blue);

            draw_triangle(
                _cx-5*s, _cy,
                _cx-37*s, _cy-30*s,
                _cx-28*s, _cy+26*s,
                false
            );

            draw_triangle(
                _cx+5*s, _cy,
                _cx+37*s, _cy-30*s,
                _cx+28*s, _cy+26*s,
                false
            );

            draw_set_color(gold);
            draw_rectangle(
                _cx-4*s, _cy-22*s,
                _cx+4*s, _cy+25*s,
                false
            );
            break;
        }

        // 09 - Forbidden Mushroom Smoothie
        case 8:
        {
            draw_set_color(metal);
            draw_rectangle(
                _cx-21*s, _cy-15*s,
                _cx+21*s, _cy+30*s,
                false
            );

            draw_set_color(red);
            draw_rectangle(
                _cx-16*s, _cy+1*s,
                _cx+16*s, _cy+25*s,
                false
            );

            draw_set_color(green);
            draw_ellipse(
                _cx-24*s, _cy-28*s,
                _cx+24*s, _cy-6*s,
                false
            );

            draw_set_color(c_white);
            draw_circle(_cx-9*s, _cy-18*s, 3*s, false);
            draw_circle(_cx+9*s, _cy-17*s, 3*s, false);
            break;
        }

        // 10 - Cursed Disco Ball
        case 9:
        {
            draw_set_color(metal);
            draw_circle(_cx, _cy, 32*s, false);

            draw_set_color(accent);

            for (var i = -2; i <= 2; i++)
            {
                draw_line(
                    _cx+i*11*s, _cy-28*s,
                    _cx+i*11*s, _cy+28*s
                );

                draw_line(
                    _cx-28*s, _cy+i*11*s,
                    _cx+28*s, _cy+i*11*s
                );
            }

            draw_set_color(gold);
            draw_circle(_cx, _cy, 5*s, false);
            break;
        }
    }

    draw_set_color(old_color);
    draw_set_alpha(old_alpha);
}


// =====================================================
// GET OWNED TOTAL WITHOUT MUTATING INVENTORY
// =====================================================

function craft_v3_visual_owned(_recipe_index)
{
    var recipes = craft_v3_recipes();

    if (_recipe_index < 0 ||
        _recipe_index >= array_length(recipes))
        return 0;

    if (!variable_global_exists("item_inventory"))
        return 0;

    if (!is_struct(global.item_inventory))
        return 0;

    var item_id = recipes[_recipe_index].id;

    if (!variable_struct_exists(global.item_inventory, item_id))
        return 0;

    var owned = variable_struct_get(
        global.item_inventory,
        item_id
    );

    if (!is_real(owned)) return 0;

    return max(0, owned);
}


// =====================================================
// GET BEST OWNED QUALITY
// =====================================================

function craft_v3_visual_best_quality(_recipe_index)
{
    if (!variable_global_exists("item_quality_inventory"))
        return -1;

    if (!is_struct(global.item_quality_inventory))
        return -1;

    var recipes = craft_v3_recipes();

    if (_recipe_index < 0 ||
        _recipe_index >= array_length(recipes))
        return -1;

    var item_id = recipes[_recipe_index].id;

    if (!variable_struct_exists(
        global.item_quality_inventory,
        item_id
    ))
        return -1;

    var stacks = variable_struct_get(
        global.item_quality_inventory,
        item_id
    );

    var best = -1;

    for (var i = 0; i < array_length(stacks); i++)
    {
        if (stacks[i].amount > 0)
        {
            best = max(best, stacks[i].quality);
        }
    }

    return best;
}