/// scr_craft_v2

function craft_v2_presets()
{
    return [
        { name: "BLADE",    pattern: [0, 0, 1, -1, 2, -1] },
        { name: "DRESS",    pattern: [1, -1, 1, 2, 1, 2] },
        { name: "TOOL",     pattern: [0, 1, -1, 0, 2, -1] },
        { name: "ARMOR",    pattern: [0, 1, 0, 2, 1, 2] },
        { name: "ARTIFACT", pattern: [2, 1, 2, 0, -1, 0] }
    ];
}


// =====================================================
// SINGLE RECIPE CATALOG
//
// category: 0 BLADE, 1 DRESS, 2 TOOL,
//           3 ARMOR, 4 ARTIFACT
//
// ingredients: group names and percentage weights.
// =====================================================

function craft_v2_recipes()
{
    return [
        { id:"item_01", name:"Wooden Sword",    category:0, ingredients:[{group:"tree",amount:80},{group:"stone",amount:20}] },
        { id:"item_02", name:"Stone Sword",     category:0, ingredients:[{group:"stone",amount:75},{group:"tree",amount:25}] },
        { id:"item_03", name:"Crystal Sword",   category:0, ingredients:[{group:"glass",amount:70},{group:"jewels",amount:30}] },
        { id:"item_04", name:"Hunting Dagger",  category:0, ingredients:[{group:"stone",amount:50},{group:"cloth",amount:50}] },

        { id:"item_05", name:"Cotton Dress",    category:1, ingredients:[{group:"cloth",amount:80},{group:"tree",amount:20}] },
        { id:"item_06", name:"Polyester Dress", category:1, ingredients:[{group:"polyester",amount:80},{group:"cloth",amount:20}] },
        { id:"item_07", name:"Royal Dress",     category:1, ingredients:[{group:"cloth",amount:60},{group:"jewels",amount:40}] },
        { id:"item_08", name:"Traveler Cloak",  category:1, ingredients:[{group:"cloth",amount:60},{group:"tree",amount:40}] },

        { id:"item_09", name:"Wooden Hammer",   category:2, ingredients:[{group:"tree",amount:75},{group:"stone",amount:25}] },
        { id:"item_10", name:"Stone Hammer",    category:2, ingredients:[{group:"stone",amount:75},{group:"tree",amount:25}] },
        { id:"item_11", name:"Glass Tool",      category:2, ingredients:[{group:"glass",amount:75},{group:"polyester",amount:25}] },
        { id:"item_12", name:"Jewel Pickaxe",   category:2, ingredients:[{group:"jewels",amount:60},{group:"stone",amount:40}] },

        { id:"item_13", name:"Stone Armor",     category:3, ingredients:[{group:"stone",amount:70},{group:"cloth",amount:30}] },
        { id:"item_14", name:"Cloth Armor",     category:3, ingredients:[{group:"cloth",amount:80},{group:"polyester",amount:20}] },
        { id:"item_15", name:"Crystal Armor",   category:3, ingredients:[{group:"glass",amount:60},{group:"jewels",amount:40}] },
        { id:"item_16", name:"Hunter Armor",    category:3, ingredients:[{group:"tree",amount:40},{group:"cloth",amount:40},{group:"mushrooms",amount:20}] },

        { id:"item_17", name:"Forest Amulet",   category:4, ingredients:[{group:"tree",amount:60},{group:"mushrooms",amount:40}] },
        { id:"item_18", name:"Blood Talisman",  category:4, ingredients:[{group:"blood",amount:60},{group:"jewels",amount:40}] },
        { id:"item_19", name:"Mushroom Relic",  category:4, ingredients:[{group:"mushrooms",amount:70},{group:"glass",amount:30}] },
        { id:"item_20", name:"Ancient Core",    category:4, ingredients:[{group:"stone",amount:40},{group:"jewels",amount:30},{group:"blood",amount:30}] }
    ];
}


function craft_v2_item_names()
{
    var recipes = craft_v2_recipes();
    var names = [];

    for (var recipe_i = 0; recipe_i < array_length(recipes); recipe_i++)
    {
        array_push(names, recipes[recipe_i].name);
    }

    return names;
}


// =====================================================
// PRESET MATCHING
// =====================================================

function craft_v2_match_preset(_modules)
{
    var presets = craft_v2_presets();

    for (var preset_i = 0; preset_i < array_length(presets); preset_i++)
    {
        var valid = true;

        for (var cell_i = 0; cell_i < 6; cell_i++)
        {
            if (_modules[cell_i] != presets[preset_i].pattern[cell_i])
            {
                valid = false;
                break;
            }
        }

        if (valid) return preset_i;
    }

    return -1;
}


// =====================================================
// GEOMETRIC BUFF SHAPES
// =====================================================

function craft_v2_buff_shape(_lower)
{
    var patterns = [
        [1,4,6,7,8],
        [1,3,4,5,7],
        [0,2,4,6,8],
        [0,4,8],
        [2,4,6],
        [0,2,4,7],
        [4,8],
        [0,1]
    ];

    for (var pattern_i = 0; pattern_i < array_length(patterns); pattern_i++)
    {
        var pattern = patterns[pattern_i];
        var valid = true;

        for (var p = 0; p < array_length(pattern); p++)
        {
            if (_lower[pattern[p]] == -1)
            {
                valid = false;
                break;
            }
        }

        if (valid) return pattern_i;
    }

    return -1;
}


// =====================================================
// CONNECTIONS
// =====================================================

function craft_v2_connections(_upper, _lower)
{
    var result = 0;

    for (var cell_i = 0; cell_i < 6; cell_i++)
    {
        if (_upper[cell_i] != -1 && _lower[cell_i] != -1)
        {
            result++;
        }
    }

    return result;
}


// =====================================================
// INVENTORY - SAFE INITIALIZATION
// =====================================================

function craft_v2_add_item(_item_index)
{
    // Check valid item index
    if (_item_index < 0 || _item_index >= 20)
    {
        show_debug_message(
            "CRAFT ERROR: Invalid item index: " + string(_item_index)
        );

        return false;
    }

    // Initialize shared inventory if missing
    if (!variable_global_exists("item_inventory"))
    {
        global.item_inventory = {};
    }

    // Repair invalid inventory
    if (!is_struct(global.item_inventory))
    {
        global.item_inventory = {};
    }

    // Build item ID
    var item_id =
        "item_" + string_format(_item_index + 1, 2, 0);

    // Initialize item if missing
    if (!variable_struct_exists(global.item_inventory, item_id))
    {
        variable_struct_set(
            global.item_inventory,
            item_id,
            0
        );
    }

    // Read current quantity
    var current_amount = variable_struct_get(
        global.item_inventory,
        item_id
    );

    // Repair invalid quantity
    if (!is_real(current_amount))
    {
        current_amount = 0;
    }

    // Add one item
    variable_struct_set(
        global.item_inventory,
        item_id,
        current_amount + 1
    );

    show_debug_message(
        "CRAFT INVENTORY: " +
        item_id +
        " = " +
        string(current_amount + 1)
    );

    return true;
}


// =====================================================
// MATCH RECIPE BY CATEGORY AND MATERIAL RATIOS
//
// Each resource cell = 10 units.
// Tolerance is 10 percentage points per ingredient.
// No extra material groups allowed.
// =====================================================

function craft_v2_find_recipe(_category, _lower, _resource_groups)
{
    if (_category < 0) return -1;

    var recipes = craft_v2_recipes();

    var groups = [
        "stone", "polyester", "tree", "cloth",
        "glass", "jewels", "mushrooms", "blood"
    ];

    var counts = array_create(8, 0);
    var total = 0;

    for (var cell_i = 0; cell_i < 9; cell_i++)
    {
        var resource_index = _lower[cell_i];

        if (resource_index < 0) continue;

        var group = _resource_groups[resource_index];

        for (var group_i = 0; group_i < 8; group_i++)
        {
            if (groups[group_i] == group)
            {
                counts[group_i]++;
                total++;
                break;
            }
        }
    }

    if (total == 0) return -1;

    var best_recipe = -1;
    var best_error = 999999;

    for (var recipe_i = 0; recipe_i < array_length(recipes); recipe_i++)
    {
        var recipe = recipes[recipe_i];

        if (recipe.category != _category) continue;

        var expected = array_create(8, 0);

        for (var ing_i = 0; ing_i < array_length(recipe.ingredients); ing_i++)
        {
            var ingredient = recipe.ingredients[ing_i];

            for (var group_i = 0; group_i < 8; group_i++)
            {
                if (groups[group_i] == ingredient.group)
                {
                    expected[group_i] = ingredient.amount;
                    break;
                }
            }
        }

        var valid = true;
        var error_total = 0;

        for (var group_i = 0; group_i < 8; group_i++)
        {
            var actual_percent = counts[group_i] * 100 / total;
            var expected_percent = expected[group_i];

            if (expected_percent == 0 && counts[group_i] > 0)
            {
                valid = false;
                break;
            }

            var difference = abs(actual_percent - expected_percent);

            if (difference > 10)
            {
                valid = false;
                break;
            }

            error_total += difference;
        }

        if (valid && error_total < best_error)
        {
            best_error = error_total;
            best_recipe = recipe_i;
        }
    }

    return best_recipe;
}