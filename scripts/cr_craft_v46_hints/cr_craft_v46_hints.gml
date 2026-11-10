
/// scr_craft_v46_hints
/// Progressive discovery hints for the Item Book.
/// Works with V4.5 recipes and existing discovery data.

function craft_v46_hints_init()
{
    if (!variable_global_exists("recipe_hint_levels"))
    {
        global.recipe_hint_levels =
            array_create(array_length(craft_v3_recipes()), 0);
    }

    var count = array_length(craft_v3_recipes());

    if (array_length(global.recipe_hint_levels) != count)
    {
        var old = global.recipe_hint_levels;
        var fresh = array_create(count, 0);

        for (var i = 0; i < min(count, array_length(old)); i++)
            fresh[i] = clamp(old[i], 0, 3);

        global.recipe_hint_levels = fresh;
    }
}

function craft_v46_hint_level(_ri)
{
    craft_v46_hints_init();

    if (_ri < 0 || _ri >= array_length(global.recipe_hint_levels))
        return 0;

    return global.recipe_hint_levels[_ri];
}

function craft_v46_reveal_hint(_ri)
{
    craft_v46_hints_init();

    if (_ri < 0 || _ri >= array_length(global.recipe_hint_levels))
        return false;

    if (craft_v3_is_discovered(_ri))
        return false;

    if (global.recipe_hint_levels[_ri] >= 3)
        return false;

    global.recipe_hint_levels[_ri]++;
    return true;
}

function craft_v46_hint_data(_ri)
{
    var recipes = craft_v3_recipes();
    var categories = craft_v4_categories();

    if (_ri < 0 || _ri >= array_length(recipes))
    {
        return {
            valid:false,
            known:false,
            level:0,
            category:"UNKNOWN",
            group_count:0,
            first_group:"???",
            second_group:"???",
            has_second:false
        };
    }

    var recipe = recipes[_ri];
    var category_index = craft_v4_category_of(_ri);
    var ingredients = recipe.ingredients;
    var count = array_length(ingredients);

    var first_group = "???";
    var second_group = "???";

    if (count > 0)
        first_group = string_upper(ingredients[0].group);

    if (count > 1)
        second_group = string_upper(ingredients[1].group);

    return {
        valid:true,
        known:craft_v3_is_discovered(_ri),
        level:craft_v46_hint_level(_ri),
        category:categories[category_index],
        group_count:count,
        first_group:first_group,
        second_group:second_group,
        has_second:count > 1
    };
}
