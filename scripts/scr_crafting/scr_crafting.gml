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

        var available =
            global.material_pool[$ tag];

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
    // CHECK MATERIALS
    // -------------------------------------------------

    if (!has_materials_for_craft(_recipe))
    {
        return {
            success: false,
            can_craft: false,

            failure_chance: 0,
            base_failure: 0,
            event_failure: 0,

            roll: 0,

            item_id: _recipe.id,
            item_name: _recipe.name
        };
    }


    // -------------------------------------------------
    // TAG
    //
    // TAG = количество ингредиентов
    // -------------------------------------------------

    var tag_count =
        array_length(_recipe.materials);


    // -------------------------------------------------
    // FAILURE AFTER KNOWLEDGE
    //
    // Эта функция уже считает:
    //
    // TAG 1 = 1%
    // TAG 2 = 10%
    // TAG 3 = 20%
    // TAG 4 = 30%
    // TAG 5 = 40%
    //
    // и затем:
    // -2% за каждый discovered item
    // -------------------------------------------------

    var base_failure =
        get_final_failure_chance(
            tag_count,
            _discovered_count
        );


    // -------------------------------------------------
    // MARKET EVENT BONUS
    // -------------------------------------------------

    var event_failure =
        market_event_get_failure_bonus();


    // -------------------------------------------------
    // FINAL FAILURE
    // -------------------------------------------------

    var final_failure =
        base_failure + event_failure;


    // Ограничиваем шанс 0-95%
    final_failure =
        clamp(
            final_failure,
            0,
            95
        );


    // -------------------------------------------------
    // SPEND MATERIALS
    //
    // Материалы списываются при попытке крафта
    // даже если предмет сломается
    // -------------------------------------------------

    spend_materials_for_craft(
        _recipe
    );


    // -------------------------------------------------
    // RANDOM ROLL
    // -------------------------------------------------

    var roll =
        random(100);


    var success =
        roll >= final_failure;


    // -------------------------------------------------
    // RESULT
    // -------------------------------------------------

    return {
        success: success,
        can_craft: true,

        failure_chance: final_failure,

        base_failure: base_failure,
        event_failure: event_failure,

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


    // Новая запись в начало
    array_insert(
        global.craft_log,
        0,
        log_text
    );


    // Храним только последние 10 записей
    if (array_length(global.craft_log) > 10)
    {
        array_delete(
            global.craft_log,
            10,
            1
        );
    }
}