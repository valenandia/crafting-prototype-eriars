/// obj_drone - Create Event

// =====================================================
// ECONOMY LAYOUT
// CENTER TOP
// =====================================================

drone_x = 575;
drone_y = 135;

drone_panel_w = 450;
drone_panel_h = 370;


// =====================================================
// DRONE A
// =====================================================

drone_a_active = false;
drone_a_time = 0;
drone_a_duration = 10;
drone_a_result = "Ready";

drone_a_button_x1 = drone_x + 300;
drone_a_button_y1 = drone_y + 90;
drone_a_button_x2 = drone_x + 420;
drone_a_button_y2 = drone_y + 125;


// =====================================================
// DRONE B
// =====================================================

drone_b_active = false;
drone_b_time = 0;
drone_b_duration = 15;
drone_b_result = "Ready";

drone_b_button_x1 = drone_x + 300;
drone_b_button_y1 = drone_y + 190;
drone_b_button_x2 = drone_x + 420;
drone_b_button_y2 = drone_y + 225;


// =====================================================
// SCOUT
// =====================================================

scout_active = false;
scout_time = 0;
scout_duration = 25;
scout_reward = 50;

scout_target_tag = "";
scout_target_name = "";

scout_result = "Finds lowest resource";

scout_button_x1 = drone_x + 300;
scout_button_y1 = drone_y + 300;
scout_button_x2 = drone_x + 420;
scout_button_y2 = drone_y + 335;