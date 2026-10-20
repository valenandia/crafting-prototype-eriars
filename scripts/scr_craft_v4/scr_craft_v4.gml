
function craft_v4_categories()
{
    return [
        "JEWELRY",
        "CLOTHING",
        "RITUAL",
        "EQUIPMENT",
        "ALCHEMY",
        "ARTIFACTS"
    ];
}

function craft_v4_category_of(_ri)
{
    switch (_ri)
    {
        case 0: case 1: case 3: return 0;
        case 2: case 6: return 1;
        case 4: case 5: return 2;
        case 7: return 3;
        case 8: return 4;
        case 9: return 5;
    }
    return -1;
}

function craft_v4_total(_stacks)
{
    var n = 0;
    for (var i = 0; i < array_length(_stacks); i++)
        n += max(0, _stacks[i].amount);
    return n;
}

function craft_v4_group_amount(_stacks, _group)
{
    var n = 0;
    for (var i = 0; i < array_length(_stacks); i++)
        if (_stacks[i].group == _group)
            n += max(0, _stacks[i].amount);
    return n;
}

function craft_v4_variant_amount(_stacks, _group, _variant)
{
    var n = 0;
    for (var i = 0; i < array_length(_stacks); i++)
        if (_stacks[i].group == _group
        && _stacks[i].variant == _variant)
            n += max(0, _stacks[i].amount);
    return n;
}

// Canonical perfect stack layout.
// Uses the deterministic V3.9 blueprint.
function craft_v4_blueprint(_ri)
{
    return craft_f39_blueprint(_ri);
}

// A recipe matches when all its required groups
// are present, with no extra material groups.
// The vessel does NOT need to be full.
function craft_v4_match(_category, _stacks)
{
    var recipes = craft_v3_recipes();
    var groups = craft_v3_groups();
    var total = craft_v4_total(_stacks);

    if (total <= 0 || total > 100)
        return -1;

    for (var ri = 0; ri < array_length(recipes); ri++)
    {
        if (craft_v4_category_of(ri) != _category)
            continue;

        var recipe = recipes[ri];
        var valid = true;

        for (var j = 0; j < array_length(recipe.ingredients); j++)
        {
            if (craft_v4_group_amount(
                _stacks, recipe.ingredients[j].group
            ) <= 0)
            {
                valid = false;
                break;
            }
        }

        if (!valid) continue;

        for (var g = 0; g < array_length(groups); g++)
        {
            if (craft_v4_group_amount(_stacks, groups[g]) <= 0)
                continue;

            var required = false;

            for (var j = 0; j < array_length(recipe.ingredients); j++)
            {
                if (recipe.ingredients[j].group == groups[g])
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

        if (valid) return ri;
    }

    return -1;
}

function craft_v4_quality(_ri, _stacks)
{
    var recipe = craft_v3_recipes()[_ri];
    var target = craft_v4_blueprint(_ri);
    var counts = craft_v3_variant_counts();

    var total = craft_v4_total(_stacks);
    var group_error = 0;
    var variant_error = 0;

    for (var i = 0; i < array_length(recipe.ingredients); i++)
    {
        var ing = recipe.ingredients[i];
        var actual = craft_v4_group_amount(_stacks, ing.group);
        group_error += abs(actual - ing.amount);

        var gi = craft_v3_group_index(ing.group);

        for (var v = 1; v <= counts[gi]; v++)
        {
            variant_error += abs(
                craft_v4_variant_amount(_stacks, ing.group, v)
                - craft_v4_variant_amount(target, ing.group, v)
            );
        }
    }

    // Relative completeness, proportions and
    // exact variant quantities.
    var completeness = clamp(total / 100, 0, 1);

    var fidelity = clamp(
        1 - group_error / max(1, 100 + total),
        0, 1
    );

    var variants = clamp(
        1 - variant_error / max(1, 100 + total),
        0, 1
    );

    var actual_stacks = 0;
    for (var i = 0; i < array_length(_stacks); i++)
        if (_stacks[i].amount > 0)
            actual_stacks++;

    var expected_stacks = array_length(target);

    var structure = clamp(
        1 - abs(actual_stacks - expected_stacks)
            / max(1, expected_stacks),
        0, 1
    );

    var perfect = total == 100
        && group_error == 0
        && variant_error == 0
        && actual_stacks == expected_stacks;

    if (perfect)
    {
        // Check exact canonical stacks, including
        // duplicate stack prevention.
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

    var raw = round(
        50 * fidelity
        + 30 * variants
        + 20 * structure
    );

    // Completeness is the hard upper limit.
    // 30/100 => max Q24
    // 50/100 => max Q49
    // 80/100 => max Q74
    // 100/100 => max Q94 unless perfect.
    var cap = 94;

    if (total < 40) cap = 24;
    else if (total < 60) cap = 49;
    else if (total < 90) cap = 74;

    var quality = perfect
        ? 100
        : clamp(min(raw, cap), 1, 94);

    return {
        quality:quality,
        completeness:round(completeness * 100),
        fidelity:round(fidelity * 100),
        variants:round(variants * 100),
        structure:round(structure * 100),
        perfect:perfect
    };
}

function craft_v4_tier(_q)
{
    if (_q == 100) return "PERFECT";
    if (_q >= 75) return "MASTERWORK";
    if (_q >= 50) return "REFINED";
    if (_q >= 25) return "STANDARD";
    return "CRUDE";
}

function craft_v4_analyze(_category, _stacks)
{
    var total = craft_v4_total(_stacks);
    var ri = craft_v4_match(_category, _stacks);

    var result = {
        status:"EMPTY",
        recipe_index:-1,
        capacity:total,
        quality:0,
        tier:"UNKNOWN",
        completeness:0,
        fidelity:0,
        variants:0,
        structure:0,
        perfect:false,
        is_discovered:false,
        message:"ADD MATERIALS"
    };

    if (total <= 0) return result;

    if (ri < 0)
    {
        result.status = "UNSTABLE";
        result.message = "UNKNOWN MATERIAL COMBINATION";
        return result;
    }

    var q = craft_v4_quality(ri, _stacks);

    result.status = "CRAFTABLE";
    result.recipe_index = ri;
    result.quality = q.quality;
    result.tier = craft_v4_tier(q.quality);
    result.completeness = q.completeness;
    result.fidelity = q.fidelity;
    result.variants = q.variants;
    result.structure = q.structure;
    result.perfect = q.perfect;
    result.is_discovered = craft_v3_is_discovered(ri);
    result.message = q.perfect
        ? "PERFECT BLUEPRINT MATCH!"
        : "RECIPE RECOGNIZED";

    return result;
}


function craft_v4_category_pattern(_category)
{
    switch (_category)
    {
        case 0: return [0,1,0,2,1,2];     // JEWELRY
        case 1: return [1,-1,1,2,1,2];    // CLOTHING
        case 2: return [0,1,-1,0,2,-1];  // RITUAL
        case 3: return [2,1,2,0,-1,0];   // EQUIPMENT
        case 4: return [1,0,1,2,0,2];    // ALCHEMY
        case 5: return [2,1,2,1,0,1];    // ARTIFACTS
    }

    return array_create(6,-1);
}

function craft_v4_pattern_category(_upper)
{
    for (var ci = 0; ci < 6; ci++)
    {
        var pattern = craft_v4_category_pattern(ci);

        if (craft_v3_match_pattern(_upper,pattern))
            return ci;
    }

    return -1;
}

function craft_v4_match_modules(_upper,_stacks)
{
    var category = craft_v4_pattern_category(_upper);

    if (category < 0)
        return -1;

    return craft_v4_match(category,_stacks);
}

function craft_v4_analyze_modules(_upper,_stacks)
{
    var category = craft_v4_pattern_category(_upper);

    if (category < 0)
    {
        return {
            status:"UNSTABLE",
            recipe_index:-1,
            capacity:craft_v4_total(_stacks),
            quality:0,
            tier:"UNKNOWN",
            completeness:0,
            fidelity:0,
            variants:0,
            structure:0,
            perfect:false,
            is_discovered:false,
            message:"UNKNOWN MODULE SHAPE"
        };
    }

    return craft_v4_analyze(category,_stacks);
}
