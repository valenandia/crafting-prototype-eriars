/// scr_crafting


// =====================================================
// CHECK MATERIALS
// Проверяет, хватает ли ресурсов для рецепта
// =====================================================

function has_materials_for_craft(_recipe)
{
    for (var i = 0; i < array_length(_recipe.materials); i++)
    {
        var material = _recipe.materials[i];

        var tag = material.tag;
        var required = material.percentage;

        var available = global.material_pool[$ tag];

        if (available < required)
        {
            return false;
        }
    }

    return true;
}


// =====================================================
// SPEND MATERIALS
// Списывает ресурсы из пула
// =====================================================

function spend_materials_for_craft(_recipe)
{
    for (var i = 0; i < array_length(_recipe.materials); i++)
    {
        var material = _recipe.materials[i];

        var tag = material.tag;
        var required = material.percentage;

        global.material_pool[$ tag] -= required;
    }
}


// =====================================================
// CRAFT ITEM
// =====================================================

function craft_item(_recipe, _discovered_count)
{
    // -------------------------------------------------
    // Проверяем ресурсы
    // -------------------------------------------------

    if (!has_materials_for_craft(_recipe))
    {
        return {
            success: false,
            can_craft: false,
            failure_chance: 0,
            roll: 0,
            item_id: _recipe.id,
            item_name: _recipe.name
        };
    }


    // -------------------------------------------------
    // Списываем материалы
    // -------------------------------------------------

    spend_materials_for_craft(_recipe);


    // -------------------------------------------------
    // Failure chance
    // -------------------------------------------------

    var tag_count =
        array_length(_recipe.materials);

    var failure_chance =
        get_final_failure_chance(
            tag_count,
            _discovered_count
        );


    // -------------------------------------------------
    // Roll
    // -------------------------------------------------

    var roll = random(100);

    var success =
        roll >= failure_chance;


    // -------------------------------------------------
    // Result
    // -------------------------------------------------

    return {
        success: success,
        can_craft: true,
        failure_chance: failure_chance,
        roll: roll,
        item_id: _recipe.id,
        item_name: _recipe.name
    };
}

// =====================================================
// ADD CRAFT LOG
// =====================================================

function add_craft_log(_text)
{
    global.craft_attempts++;

    var log_text =
        "#"
        + string(global.craft_attempts)
        + "  "
        + _text;

    // Добавляем новую запись в начало
    array_insert(
        global.craft_log,
        0,
        log_text
    );

    // Храним только последние 10
    if (array_length(global.craft_log) > 10)
    {
        array_delete(
            global.craft_log,
            10,
            1
        );
    }
}