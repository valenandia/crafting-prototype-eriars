/// obj_ui - Mouse Left Pressed

// Проверяем, попал ли клик в кнопку CRAFT
if (mouse_x >= 40 && mouse_x <= 220
&& mouse_y >= 410 && mouse_y <= 465)
{
    var recipe = global.recipes[global.selected_recipe];

    var result = craft_item(
        recipe,
        array_length(global.discovered_items)
    );

    if (result.success)
    {
        global.craft_result =
            "SUCCESS! " + result.item_name;

        // Проверяем, изучен ли уже предмет
        var already_discovered = false;

        for (var i = 0; i < array_length(global.discovered_items); i++)
        {
            if (global.discovered_items[i] == result.item_id)
            {
                already_discovered = true;
                break;
            }
        }

        // Добавляем новый предмет в книжку
        if (!already_discovered)
        {
            array_push(
                global.discovered_items,
                result.item_id
            );
        }
    }
    else
    {
        global.craft_result =
            "FAILED! " + result.item_name;
    }
}