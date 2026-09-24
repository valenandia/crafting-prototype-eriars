/// obj_market - Create Event

market_x = 50;
market_y = 530;

market_panel_w = 500;
market_panel_h = 340;


// =====================================================
// WORLDS
// =====================================================

global.market_worlds =
[
    "FANTASY",
    "CYBERPUNK",
    "STEAMPUNK"
];


// =====================================================
// MATERIALS
// =====================================================

global.market_materials =
[
    "stone",
    "polyester",
    "tree",
    "cloth",
    "glass",
    "jewels",
    "mushrooms",
    "blood"
];


// =====================================================
// DATA
// =====================================================

global.market_prices = {};

global.selected_market_world = 0;


// =====================================================
// TIMER
// =====================================================

market_update_seconds = 30;

market_timer =
    market_update_seconds * room_speed;


// =====================================================
// EVENTS
// =====================================================

global.market_event_active = false;

global.market_event_name =
    "NO EVENT";

global.market_event_failure_bonus =
    0;

global.market_event_timer =
    0;

global.market_event_duration =
    0;


// =====================================================
// FIRST MARKET
// =====================================================

market_generate_prices();