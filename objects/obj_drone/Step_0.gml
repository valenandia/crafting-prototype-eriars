/// obj_drone - Step Event

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);


// =====================================================
// START DRONE
// =====================================================

if (!drone_active)
{
    if (mouse_check_button_pressed(mb_left))
    {
        if (
            mx >= drone_button_x1 &&
            mx <= drone_button_x2 &&
            my >= drone_button_y1 &&
            my <= drone_button_y2
        )
        {
            drone_active = true;

            drone_time =
                drone_duration * room_speed;

            drone_result =
                "Drone searching...";
        }
    }
}


// =====================================================
// DRONE SEARCH
// =====================================================

if (drone_active)
{
    drone_time--;

    if (drone_time <= 0)
    {
        drone_active = false;


        // =================================================
        // RESOURCE ROLL
        // =================================================

        var roll = random(97);

        var found_tag = "";
        var found_name = "";


        if (roll < 35)
        {
            found_tag = "stone";
            found_name = "Stone";
        }
        else if (roll < 60)
        {
            found_tag = "polyester";
            found_name = "Polyester";
        }
        else if (roll < 72)
        {
            found_tag = "tree";
            found_name = "Tree";
        }
        else if (roll < 82)
        {
            found_tag = "cloth";
            found_name = "Cloth";
        }
        else if (roll < 91)
        {
            found_tag = "glass";
            found_name = "Glass";
        }
        else
        {
            found_tag = "jewels";
            found_name = "Jewels";
        }


        // =================================================
        // AMOUNT
        // =================================================

        var found_amount =
            irandom_range(20, 60);


        // =================================================
        // ADD RESOURCE
        // =================================================

        global.material_pool[$ found_tag] +=
            found_amount;


        // =================================================
        // RESULT
        // =================================================

        drone_result =
            "FOUND: +"
            + string(found_amount)
            + " "
            + found_name;
    }
}