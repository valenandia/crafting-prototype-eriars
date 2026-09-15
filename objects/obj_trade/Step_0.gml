/// obj_trade - Step Event

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);


if (mouse_check_button_pressed(mb_left))
{
    for (
        var i = 0;
        i < array_length(trade_resources);
        i++
    )
    {
        var tag =
            trade_resources[i];


        // =================================================
        // BUTTON POSITION
        // =================================================

        var yy =
            trade_y + 80 + (i * 27);

        var bx1 =
            trade_x + 205;

        var by1 =
            yy - 5;

        var bx2 =
            bx1 + button_w;

        var by2 =
            by1 + button_h;


        // =================================================
        // CLICK
        // =================================================

        if (
            mx >= bx1 &&
            mx <= bx2 &&
            my >= by1 &&
            my <= by2
        )
        {
            var price =
                trade_get_buy_price(tag);

            var world =
                trade_get_cheapest_world(tag);


            // =================================================
            // BUY
            // =================================================

            if (global.credits >= price)
            {
                global.credits -= price;


                global.material_pool[$ tag] +=
                    trade_amount;


                var resource_name =
                    trade_get_resource_name(tag);


                trade_result =
                    "BOUGHT +"
                    + string(trade_amount)
                    + " "
                    + resource_name
                    + " / "
                    + world
                    + " / "
                    + string(price)
                    + " cr";
            }
            else
            {
                trade_result =
                    "NOT ENOUGH CREDITS";
            }


            break;
        }
    }
}