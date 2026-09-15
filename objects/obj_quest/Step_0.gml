/// obj_quest - Step Event

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);


// =====================================================
// START QUEST
// =====================================================

if (!quest_active)
{
    if (mouse_check_button_pressed(mb_left))
    {
        // MUSHROOM
        if (
            mx >= mushroom_button_x1 &&
            mx <= mushroom_button_x2 &&
            my >= mushroom_button_y1 &&
            my <= mushroom_button_y2
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


        // BLOOD
        else if (
            mx >= blood_button_x1 &&
            mx <= blood_button_x2 &&
            my >= blood_button_y1 &&
            my <= blood_button_y2
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


// =====================================================
// QUEST TIMER
// =====================================================

if (quest_active)
{
    quest_timer--;

    if (quest_timer <= 0)
    {
        quest_active = false;


        // MUSHROOM REWARD
        if (quest_type == "mushrooms")
        {
            global.material_pool.mushrooms +=
                mushroom_reward;

            quest_result =
                "FOUND: +"
                + string(mushroom_reward)
                + " Mushrooms";
        }


        // BLOOD REWARD
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