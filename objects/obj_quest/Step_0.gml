/// obj_quest - Step Event

var mouse_gui_x =
    device_mouse_x_to_gui(0);

var mouse_gui_y =
    device_mouse_y_to_gui(0);


// =====================================================
// INPUT ONLY ON ECONOMY
// =====================================================

if (global.ui_screen == 0)
{
    if (!quest_active)
    {
        if (mouse_check_button_pressed(mb_left))
        {
            if (
                mouse_gui_x >= mushroom_button_x1 &&
                mouse_gui_x <= mushroom_button_x2 &&
                mouse_gui_y >= mushroom_button_y1 &&
                mouse_gui_y <= mushroom_button_y2
            )
            {
                quest_active = true;
                quest_type = "mushrooms";

                quest_duration =
                    mushroom_duration * room_speed;

                quest_timer =
                    quest_duration;

                quest_result =
                    "Searching for Mushrooms...";
            }


            else if (
                mouse_gui_x >= blood_button_x1 &&
                mouse_gui_x <= blood_button_x2 &&
                mouse_gui_y >= blood_button_y1 &&
                mouse_gui_y <= blood_button_y2
            )
            {
                quest_active = true;
                quest_type = "blood";

                quest_duration =
                    blood_duration * room_speed;

                quest_timer =
                    quest_duration;

                quest_result =
                    "Blood hunt started...";
            }
        }
    }
}


// =====================================================
// TIMER ALWAYS RUNS
// =====================================================

if (quest_active)
{
    quest_timer--;


    if (quest_timer <= 0)
    {
        quest_active = false;


        if (quest_type == "mushrooms")
        {
            global.material_pool.mushrooms +=
                mushroom_reward;

            quest_result =
                "FOUND: +"
                + string(mushroom_reward)
                + " Mushrooms";
        }


        else if (quest_type == "blood")
        {
            global.material_pool.blood +=
                blood_reward;

            quest_result =
                "FOUND: +"
                + string(blood_reward)
                + " Blood";
        }


        quest_type = "";
    }
}