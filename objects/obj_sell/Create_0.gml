/// obj_sell - Create Event


// =====================================================
// PANEL
// =====================================================

sell_x = 575;
sell_y = 530;

sell_panel_w = 450;
sell_panel_h = 340;

sell_result =
    "Choose an item and market.";


// =====================================================
// SELECTED ITEM
// =====================================================
//
// Separate from global.selected_recipe.
// Sell panel has its own selected item.
//

sell_item_index = 0;


// =====================================================
// BUTTON SIZE
// =====================================================

sell_button_w = 100;
sell_button_h = 36;


// =====================================================
// ITEM HEADER AREA
// =====================================================
//
// Mouse wheel works while cursor is here.
//

sell_item_x1 =
    sell_x + 20;

sell_item_y1 =
    sell_y + 52;

sell_item_x2 =
    sell_x + 430;

sell_item_y2 =
    sell_y + 100;


// =====================================================
// BUTTONS
// =====================================================

fantasy_button_x1 =
    sell_x + 310;

fantasy_button_y1 =
    sell_y + 130;

fantasy_button_x2 =
    fantasy_button_x1 +
    sell_button_w;

fantasy_button_y2 =
    fantasy_button_y1 +
    sell_button_h;


cyber_button_x1 =
    sell_x + 310;

cyber_button_y1 =
    sell_y + 190;

cyber_button_x2 =
    cyber_button_x1 +
    sell_button_w;

cyber_button_y2 =
    cyber_button_y1 +
    sell_button_h;


steam_button_x1 =
    sell_x + 310;

steam_button_y1 =
    sell_y + 250;

steam_button_x2 =
    steam_button_x1 +
    sell_button_w;

steam_button_y2 =
    steam_button_y1 +
    sell_button_h;