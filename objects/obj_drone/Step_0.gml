/// obj_drone - Step Event

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);


// =====================================================
// DRONE A - START
// =====================================================

if (!drone_a_active)
{
    if (mouse_check_button_pressed(mb_left))
    {
        if (
            mx >= drone_a_button_x1 &&
            mx <= drone_a_button_x2 &&
            my >= drone_a_button_y1 &&
            my <= drone_a_button_y2
        )
        {
            drone_a_active = true;

            drone_a_time =
                drone_a_duration * room_speed;

            drone_a_result =
                "Searching...";
        }
    }
}


// =====================================================
// DRONE B - START
// =====================================================

if (!drone_b_active)
{
    if (mouse_check_button_pressed(mb_left))
    {
        if (
            mx >= drone_b_button_x1 &&
            mx <= drone_b_button_x2 &&
            my >= drone_b_button_y1 &&
            my <= drone_b_button_y2
        )
        {
            drone_b_active = true;

            drone_b_time =
                drone_b_duration * room_speed;

            drone_b_result =
                "Searching...";
        }
    }
}


// =====================================================
// SCOUT - START
// =====================================================

if (!scout_active)
{
    if (mouse_check_button_pressed(mb_left))
    {
        if (
            mx >= scout_button_x1 &&
            mx <= scout_button_x2 &&
            my >= scout_button_y1 &&
            my <= scout_button_y2
        )
        {
            // -----------------------------------------
            // Find lowest NORMAL resource
            // -----------------------------------------

            var lowest_tag = "stone";
            var lowest_amount =
                global.material_pool[$ "stone"];


            if (
                global.material_pool[$ "polyester"]
                < lowest_amount
            )
            {
                lowest_tag = "polyester";

                lowest_amount =
                    global.material_pool[$ "polyester"];
            }


            if (
                global.material_pool[$ "tree"]
                < lowest_amount
            )
            {
                lowest_tag = "tree";

                lowest_amount =
                    global.material_pool[$ "tree"];
            }


            if (
                global.material_pool[$ "cloth"]
                < lowest_amount
            )
            {
                lowest_tag = "cloth";

                lowest_amount =
                    global.material_pool[$ "cloth"];
            }


            if (
                global.material_pool[$ "glass"]
                < lowest_amount
            )
            {
                lowest_tag = "glass";

                lowest_amount =
                    global.material_pool[$ "glass"];
            }


            if (
                global.material_pool[$ "jewels"]
                < lowest_amount
            )
            {
                lowest_tag = "jewels";

                lowest_amount =
                    global.material_pool[$ "jewels"];
            }


            // -----------------------------------------
            // Save target
            // -----------------------------------------

            scout_target_tag =
                lowest_tag;


            switch (lowest_tag)
            {
                case "stone":
                    scout_target_name = "Stone";
                break;

                case "polyester":
                    scout_target_name = "Polyester";
                break;

                case "tree":
                    scout_target_name = "Tree";
                break;

                case "cloth":
                    scout_target_name = "Cloth";
                break;

                case "glass":
                    scout_target_name = "Glass";
                break;

                case "jewels":
                    scout_target_name = "Jewels";
                break;
            }


            scout_active = true;

            scout_time =
                scout_duration * room_speed;

            scout_result =
                "TARGET: "
                + scout_target_name;
        }
    }
}


// =====================================================
// DRONE A - SEARCH
// =====================================================

if (drone_a_active)
{
    drone_a_time--;


    if (drone_a_time <= 0)
    {
        drone_a_active = false;


        var roll_a =
            random(97);


        var found_tag_a = "";
        var found_name_a = "";


        if (roll_a < 35)
        {
            found_tag_a = "stone";
            found_name_a = "Stone";
        }
        else if (roll_a < 60)
        {
            found_tag_a = "polyester";
            found_name_a = "Polyester";
        }
        else if (roll_a < 72)
        {
            found_tag_a = "tree";
            found_name_a = "Tree";
        }
        else if (roll_a < 82)
        {
            found_tag_a = "cloth";
            found_name_a = "Cloth";
        }
        else if (roll_a < 91)
        {
            found_tag_a = "glass";
            found_name_a = "Glass";
        }
        else
        {
            found_tag_a = "jewels";
            found_name_a = "Jewels";
        }


        var found_amount_a =
            irandom_range(20, 60);


        global.material_pool[$ found_tag_a] +=
            found_amount_a;


        drone_a_result =
            "+"
            + string(found_amount_a)
            + " "
            + found_name_a;
    }
}


// =====================================================
// DRONE B - SEARCH
// =====================================================

if (drone_b_active)
{
    drone_b_time--;


    if (drone_b_time <= 0)
    {
        drone_b_active = false;


        var roll_b =
            random(97);


        var found_tag_b = "";
        var found_name_b = "";


        if (roll_b < 35)
        {
            found_tag_b = "stone";
            found_name_b = "Stone";
        }
        else if (roll_b < 60)
        {
            found_tag_b = "polyester";
            found_name_b = "Polyester";
        }
        else if (roll_b < 72)
        {
            found_tag_b = "tree";
            found_name_b = "Tree";
        }
        else if (roll_b < 82)
        {
            found_tag_b = "cloth";
            found_name_b = "Cloth";
        }
        else if (roll_b < 91)
        {
            found_tag_b = "glass";
            found_name_b = "Glass";
        }
        else
        {
            found_tag_b = "jewels";
            found_name_b = "Jewels";
        }


        var found_amount_b =
            irandom_range(35, 75);


        global.material_pool[$ found_tag_b] +=
            found_amount_b;


        drone_b_result =
            "+"
            + string(found_amount_b)
            + " "
            + found_name_b;
    }
}


// =====================================================
// SCOUT - SEARCH
// =====================================================

if (scout_active)
{
    scout_time--;


    if (scout_time <= 0)
    {
        scout_active = false;


        global.material_pool[$ scout_target_tag] +=
            scout_reward;


        scout_result =
            "+"
            + string(scout_reward)
            + " "
            + scout_target_name;
    }
}