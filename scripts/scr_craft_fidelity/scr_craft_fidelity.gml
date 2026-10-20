
/// scr_craft_fidelity
/// CRAFTING V3.9
/// RECIPE FIDELITY + PERFECT ITEMS

function craft_f39_blueprint(_recipe_index)
{
    var recipes = craft_v3_recipes();
    var recipe = recipes[_recipe_index];
    var groups = craft_v3_groups();
    var counts = craft_v3_variant_counts();
    var stacks = [];

    for (var i = 0; i < array_length(recipe.ingredients); i++)
    {
        var ing = recipe.ingredients[i];
        var gi = craft_v3_group_index(ing.group);
        var variants = counts[gi];

        // Spread units in chunks of 10 across variants.
        var remaining = ing.amount;
        var next_variant = 1;

        while (remaining > 0)
        {
            var chunk = min(10, remaining);
            var found = -1;

            for (var s = 0; s < array_length(stacks); s++)
            {
                if (stacks[s].group == ing.group
                && stacks[s].variant == next_variant)
                {
                    found = s;
                    break;
                }
            }

            if (found == -1)
            {
                array_push(stacks, {
                    group:ing.group,
                    variant:next_variant,
                    amount:chunk
                });
            }
            else
            {
                stacks[found].amount += chunk;
            }

            remaining -= chunk;
            next_variant++;

            if (next_variant > variants)
                next_variant = 1;
        }
    }

    return stacks;
}

function craft_f39_total(_stacks)
{
    var total = 0;

    for (var i = 0; i < array_length(_stacks); i++)
        total += max(0, _stacks[i].amount);

    return total;
}

function craft_f39_group_amount(_stacks, _group)
{
    var total = 0;

    for (var i = 0; i < array_length(_stacks); i++)
    {
        if (_stacks[i].group == _group)
            total += max(0, _stacks[i].amount);
    }

    return total;
}

function craft_f39_variant_amount(_stacks, _group, _variant)
{
    var total = 0;

    for (var i = 0; i < array_length(_stacks); i++)
    {
        if (_stacks[i].group == _group
        && _stacks[i].variant == _variant)
            total += max(0, _stacks[i].amount);
    }

    return total;
}

function craft_f39_match(_upper, _stacks)
{
    if (craft_f39_total(_stacks) != 100)
        return -1;

    var recipes = craft_v3_recipes();
    var all_groups = craft_v3_groups();

    for (var r = 0; r < array_length(recipes); r++)
    {
        var recipe = recipes[r];

        if (!craft_v3_match_pattern(_upper, recipe.pattern))
            continue;

        var valid = true;

        // Every required group must exist.
        for (var i = 0; i < array_length(recipe.ingredients); i++)
        {
            if (craft_f39_group_amount(
                _stacks,
                recipe.ingredients[i].group
            ) <= 0)
            {
                valid = false;
                break;
            }
        }

        if (!valid)
            continue;

        // No extra groups allowed.
        for (var g = 0; g < array_length(all_groups); g++)
        {
            var group_name = all_groups[g];
            var present = craft_f39_group_amount(
                _stacks, group_name
            );

            if (present <= 0)
                continue;

            var required = false;

            for (var i = 0; i < array_length(recipe.ingredients); i++)
            {
                if (recipe.ingredients[i].group == group_name)
                {
                    required = true;
                    break;
                }
            }

            if (!required)
            {
                valid = false;
                break;
            }
        }

        if (valid)
            return r;
    }

    return -1;
}

function craft_f39_quality(_recipe_index, _stacks)
{
    var recipes = craft_v3_recipes();
    var recipe = recipes[_recipe_index];
    var target = craft_f39_blueprint(_recipe_index);
    var counts = craft_v3_variant_counts();

    // ------------------------------------------
    // FIDELITY: exact group proportions
    // ------------------------------------------

    var proportion_error = 0;

    for (var i = 0; i < array_length(recipe.ingredients); i++)
    {
        var ing = recipe.ingredients[i];

        var actual = craft_f39_group_amount(
            _stacks, ing.group
        );

        proportion_error += abs(actual - ing.amount);
    }

    var fidelity = clamp(
        1 - proportion_error / 200,
        0, 1
    );

    // ------------------------------------------
    // VARIANTS: exact variant quantities
    // ------------------------------------------

    var variant_error = 0;
    var variant_total = 0;

    for (var i = 0; i < array_length(recipe.ingredients); i++)
    {
        var ing = recipe.ingredients[i];
        var gi = craft_v3_group_index(ing.group);

        for (var v = 1; v <= counts[gi]; v++)
        {
            var expected = craft_f39_variant_amount(
                target, ing.group, v
            );

            var actual = craft_f39_variant_amount(
                _stacks, ing.group, v
            );

            variant_error += abs(expected - actual);
        }

        variant_total += ing.amount;
    }

    var variant_score = clamp(
        1 - variant_error / max(1, 2 * variant_total),
        0, 1
    );

    // ------------------------------------------
    // STACK STRUCTURE
    // ------------------------------------------
    // Compare how many separate stacks are used.
    // Perfect requires exact canonical stacks.

    var expected_count = array_length(target);
    var actual_count = 0;

    for (var i = 0; i < array_length(_stacks); i++)
    {
        if (_stacks[i].amount > 0)
            actual_count++;
    }

    var structure_score = clamp(
        1 - abs(actual_count - expected_count)
            / max(1, expected_count),
        0, 1
    );

    // ------------------------------------------
    // PERFECT: exact target stack distribution
    // ------------------------------------------

    var perfect = (
        proportion_error == 0
        && variant_error == 0
        && actual_count == expected_count
    );

    // Exact group + variant amounts are the
    // canonical stack structure in this system.
    // Duplicate stacks of one variant are not
    // considered canonical.

    if (perfect)
    {
        for (var t = 0; t < array_length(target); t++)
        {
            var matches = 0;

            for (var s = 0; s < array_length(_stacks); s++)
            {
                if (_stacks[s].group == target[t].group
                && _stacks[s].variant == target[t].variant
                && _stacks[s].amount == target[t].amount)
                    matches++;
            }

            if (matches != 1)
            {
                perfect = false;
                break;
            }
        }
    }

    var raw_quality = round(
        50 * fidelity
        + 30 * variant_score
        + 20 * structure_score
    );

    // Q95-99 is reserved: Perfect is exactly 100.
    var quality = perfect
        ? 100
        : clamp(raw_quality, 1, 94);

    return {
        quality:quality,
        fidelity:round(fidelity * 100),
        variants:round(variant_score * 100),
        structure:round(structure_score * 100),
        perfect:perfect
    };
}

function craft_f39_tier(_quality)
{
    if (_quality == 100) return "PERFECT";
    if (_quality >= 75) return "MASTERWORK";
    if (_quality >= 50) return "REFINED";
    if (_quality >= 25) return "STANDARD";
    return "CRUDE";
}

function craft_f39_analyze(_upper, _stacks)
{
    var total = craft_f39_total(_stacks);
    var recipes = craft_v3_recipes();

    var result = {
        status:"EMPTY",
        shape_status:"UNKNOWN",
        materials_status:"WAITING",
        proportions_status:"WAITING",
        capacity:total,
        recipe_index:-1,
        is_discovered:false,
        quality:0,
        fidelity:0,
        variants:0,
        structure:0,
        perfect:false,
        tier:"UNKNOWN",
        message:"ADD MATERIALS"
    };

    var shape_found = false;

    for (var i = 0; i < array_length(recipes); i++)
    {
        if (craft_v3_match_pattern(
            _upper, recipes[i].pattern
        ))
        {
            shape_found = true;
            break;
        }
    }

    result.shape_status =
        shape_found ? "RECOGNIZED" : "UNKNOWN";

    if (total <= 0)
        return result;

    if (total < 100)
    {
        result.status = "INCOMPLETE";
        result.message = "FILL VESSEL TO 100";
        return result;
    }

    if (total > 100)
    {
        result.status = "UNSTABLE";
        result.message = "OVER CAPACITY";
        return result;
    }

    var recipe_index = craft_f39_match(
        _upper, _stacks
    );

    if (recipe_index < 0)
    {
        result.status = "UNSTABLE";
        result.materials_status = "MISMATCH";
        result.proportions_status = "UNKNOWN";
        result.message = "UNKNOWN MIX";
        return result;
    }

    var quality_data = craft_f39_quality(
        recipe_index, _stacks
    );

    result.status = "READY";
    result.shape_status = "RECOGNIZED";
    result.materials_status = "COMPATIBLE";
    result.proportions_status =
        quality_data.fidelity == 100
        ? "EXACT" : "IMPRECISE";

    result.recipe_index = recipe_index;
    result.is_discovered =
        craft_v3_is_discovered(recipe_index);

    result.quality = quality_data.quality;
    result.fidelity = quality_data.fidelity;
    result.variants = quality_data.variants;
    result.structure = quality_data.structure;
    result.perfect = quality_data.perfect;
    result.tier = craft_f39_tier(result.quality);

    result.message = result.perfect
        ? "PERFECT RECIPE!"
        : "RECIPE RECOGNIZED";

    return result;
}
