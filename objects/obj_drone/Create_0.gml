/// obj_drone - Create Event


// =====================================================
// PANEL
// =====================================================

drone_x = 610;
drone_y = 515;


// =====================================================
// DRONE A
// Random normal resource
// 10 sec / +20..60
// =====================================================

drone_a_active = false;
drone_a_time = 0;
drone_a_duration = 10;
drone_a_result = "Ready";

drone_a_button_x1 = drone_x;
drone_a_button_y1 = drone_y + 70;
drone_a_button_x2 = drone_x + 165;
drone_a_button_y2 = drone_y + 100;


// =====================================================
// DRONE B
// Random normal resource
// 15 sec / +35..75
// =====================================================

drone_b_active = false;
drone_b_time = 0;
drone_b_duration = 15;
drone_b_result = "Ready";

drone_b_button_x1 = drone_x;
drone_b_button_y1 = drone_y + 175;
drone_b_button_x2 = drone_x + 165;
drone_b_button_y2 = drone_y + 205;


// =====================================================
// SCOUT DRONE
//
// Finds lowest NORMAL resource.
// Mushrooms / Blood are excluded.
//
// 25 sec / +50
// =====================================================

scout_active = false;
scout_time = 0;
scout_duration = 25;
scout_reward = 50;

scout_target_tag = "";
scout_target_name = "";

scout_result = "Finds lowest resource";

scout_button_x1 = drone_x;
scout_button_y1 = drone_y + 290;
scout_button_x2 = drone_x + 165;
scout_button_y2 = drone_y + 320;