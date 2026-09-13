/// scr_crafting

function craft_item(_recipe, _discovered_count) {
    
    // Сколько тегов используется в рецепте
    var tag_count = array_length(_recipe.materials);
    
    // Рассчитываем финальный шанс ошибки
    var failure_chance = get_final_failure_chance(
        tag_count,
        _discovered_count
    );
    
    // Random от 0 до 99.999...
    var roll = random(100);
    
    var success = roll >= failure_chance;
    
    return {
        success: success,
        failure_chance: failure_chance,
        roll: roll,
        item_id: _recipe.id,
        item_name: _recipe.name
    };
}