
/// scr_craft_analyzer
/// CRAFTING V3.8-A
/// BALANCED DISCOVERY ANALYZER
///
/// Read-only diagnostics.
/// Does not spend resources, unlock recipes,
/// or modify the vessel.
///
/// STATUS:
/// EMPTY / INCOMPLETE / UNSTABLE / READY
///
/// SHAPE:
/// EMPTY / RECOGNIZED / UNKNOWN
///
/// MATERIALS:
/// WAITING / CHECKING / COMPATIBLE / MISMATCH
///
/// PROPORTIONS:
/// WAITING / PENDING / STABLE / UNSTABLE / UNKNOWN

function craft_v3_analyze(_upper, _stacks)
{
    var recipes = craft_v3_recipes();

    var result = {
        status: "EMPTY",

        shape_status: "EMPTY",
        materials_status: "WAITING",
        proportions_status: "WAITING",

        capacity: 0,
        capacity_max: 100,

        shape_candidates: 0,
        material_candidates: 0,

        recipe_index: -1,
        is_discovered: false,

        quality: 0,
        rarity: "UNKNOWN",

        failure_chance: -1,
        success_chance: -1,

        message: "",
        detail: ""
    };

    // --------------------------------------------
    // 1. READ VESSEL
    // --------------------------------------------

    var total = 0;
    var current_groups = {};

    for (var i = 0; i < array_length(_stacks); i++)
    {
        var stack = _stacks[i];

        if (stack.amount <= 0)
            continue;

        total += stack.amount;

        var group_name = stack.group;

        if (!variable_struct_exists(current_groups, group_name))
        {
            variable_struct_set(
                current_groups,
                group_name,
                stack.amount
            );
        }
        else
        {
            var previous = variable_struct_get(
                current_groups,
                group_name
            );

            variable_struct_set(
                current_groups,
                group_name,
                previous + stack.amount
            );
        }
    }

    result.capacity = total;

    // --------------------------------------------
    // 2. CHECK WHETHER SHAPE IS EMPTY
    // --------------------------------------------

    var shape_has_modules = false;

    for (var i = 0; i < array_length(_upper); i++)
    {
        if (_upper[i] != -1)
        {
            shape_has_modules = true;
            break;
        }
    }

    // --------------------------------------------
    // 3. FIND ALL RECIPES WITH MATCHING SHAPE
    // --------------------------------------------

    var shape_matches = [];

    if (shape_has_modules)
    {
        for (var r = 0; r < array_length(recipes); r++)
        {
            if (craft_v3_match_pattern(
                _upper,
                recipes[r].pattern
            ))
            {
                array_push(shape_matches, r);
            }
        }
    }

    result.shape_candidates = array_length(shape_matches);

    if (!shape_has_modules)
    {
        result.shape_status = "EMPTY";
    }
    else if (result.shape_candidates > 0)
    {
        result.shape_status = "RECOGNIZED";
    }
    else
    {
        result.shape_status = "UNKNOWN";
    }

    // --------------------------------------------
    // 4. EMPTY VESSEL
    // --------------------------------------------

    if (total <= 0)
    {
        result.status = "EMPTY";

        result.message = "VESSEL EMPTY";
        result.detail = "Add materials to begin mixing.";

        return result;
    }

    // --------------------------------------------
    // 5. CHECK MATERIAL GROUP COMPATIBILITY
    // --------------------------------------------
    // Groups must match a recipe's group set.
    // Exact amounts are checked separately.

    var compatible_matches = [];

    for (var s = 0; s < array_length(shape_matches); s++)
    {
        var recipe_index = shape_matches[s];
        var recipe = recipes[recipe_index];

        var required_groups = {};
        var group_count = 0;

        for (var ing = 0;
             ing < array_length(recipe.ingredients);
             ing++)
        {
            var ingredient = recipe.ingredients[ing];

            if (!variable_struct_exists(
                required_groups,
                ingredient.group
            ))
            {
                variable_struct_set(
                    required_groups,
                    ingredient.group,
                    true
                );

                group_count++;
            }
        }

        var current_group_names =
            variable_struct_get_names(current_groups);

        if (array_length(current_group_names) != group_count)
            continue;

        var compatible = true;

        for (var g = 0;
             g < array_length(current_group_names);
             g++)
        {
            if (!variable_struct_exists(
                required_groups,
                current_group_names[g]
            ))
            {
                compatible = false;
                break;
            }
        }

        if (compatible)
            array_push(compatible_matches, recipe_index);
    }

    result.material_candidates =
        array_length(compatible_matches);

    if (result.shape_status == "UNKNOWN")
    {
        result.materials_status = "UNKNOWN";
        result.proportions_status = "UNKNOWN";
    }
    else if (result.material_candidates > 0)
    {
        result.materials_status = "COMPATIBLE";
        result.proportions_status = "UNSTABLE";
    }
    else
    {
        result.materials_status = "MISMATCH";
        result.proportions_status = "UNKNOWN";
    }

    // --------------------------------------------
    // 6. CHECK EXACT PROPORTIONS
    // --------------------------------------------

    var exact_recipe = -1;

    if (total == 100)
    {
        for (var c = 0;
             c < array_length(compatible_matches);
             c++)
        {
            var recipe_index = compatible_matches[c];
            var recipe = recipes[recipe_index];

            var exact = true;

            for (var ing = 0;
                 ing < array_length(recipe.ingredients);
                 ing++)
            {
                var ingredient = recipe.ingredients[ing];

                var actual = variable_struct_get(
                    current_groups,
                    ingredient.group
                );

                if (actual != ingredient.amount)
                {
                    exact = false;
                    break;
                }
            }

            if (exact)
            {
                exact_recipe = recipe_index;
                break;
            }
        }
    }

    // --------------------------------------------
    // 7. FINAL STATUS
    // --------------------------------------------

    if (total < 100)
    {
        result.status = "INCOMPLETE";

        if (result.shape_status == "UNKNOWN")
        {
            result.message = "UNKNOWN SHAPE";
            result.detail = "Try another module arrangement.";
        }
        else if (result.materials_status == "COMPATIBLE")
        {
            result.message = "MIXING IN PROGRESS";
            result.detail =
                string(100 - total) +
                " more units needed.";
        }
        else
        {
            result.message = "KEEP EXPERIMENTING";
            result.detail =
                string(100 - total) +
                " units remaining.";
        }

        result.proportions_status = "PENDING";

        return result;
    }

    if (total > 100)
    {
        result.status = "UNSTABLE";
        result.message = "VESSEL OVER CAPACITY";
        result.detail = "Remove excess materials.";

        return result;
    }

    if (exact_recipe == -1)
    {
        result.status = "UNSTABLE";

        if (result.shape_status == "UNKNOWN")
        {
            result.message = "UNKNOWN SHAPE";
            result.detail =
                "This module arrangement is not recognized.";
        }
        else if (result.materials_status == "MISMATCH")
        {
            result.message = "MATERIAL MISMATCH";
            result.detail =
                "Try experimenting with other material groups.";
        }
        else
        {
            result.message = "UNSTABLE PROPORTIONS";
            result.detail =
                "The material groups look promising.";
        }

        return result;
    }

    // --------------------------------------------
    // 8. VALID RECIPE
    // --------------------------------------------

    result.status = "READY";
    result.recipe_index = exact_recipe;

    result.materials_status = "COMPATIBLE";
    result.proportions_status = "STABLE";

    result.is_discovered =
        craft_v3_is_discovered(exact_recipe);

    result.quality = craft_v3_quality(_stacks);
    result.rarity = craft_v3_rarity_name(result.quality);

    result.message = "READY TO CRAFT";

    if (result.is_discovered)
    {
        result.detail = "Known recipe recognized.";
    }
    else
    {
        result.detail = "A mysterious combination is ready.";
    }

    return result;
}
