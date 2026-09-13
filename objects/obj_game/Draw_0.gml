/// obj_game - Create Event

// Получаем данные материалов
global.materials = get_material_data();

// Получаем рецепты
global.recipes = get_recipes();

// Книжка изученных предметов
global.discovered_items = [];

// Выбранный рецепт
global.selected_recipe = 0;

// Последний результат крафта
global.craft_result = "Press CRAFT to create an item.";