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

        var yy =
            trade_y + 80 + (i * 27);


        // =================================================
        // BUY BUTTON POSITION
        // =================================================

        var buy_x1 =
            trade_x + 195;

        var buy_y1 =
            yy - 5;

        var buy_x2 =
            buy_x1 + button_w;

        var buy_y2 =
            buy_y1 + button_h;


        // =================================================
        // SELL BUTTON POSITION
        // =================================================

        var sell_x1 =
            trade_x + 365;

        var sell_y1 =
            yy - 5;

        var sell_x2 =
            sell_x1 + button_w;

        var sell_y2 =
            sell_y1 + button_h;


        // =================================================
        // BUY CLICK
        // =================================================

        if (
            mx >= buy_x1 &&
            mx <= buy_x2 &&
            my >= buy_y1 &&
            my <= buy_y2
        )
        {
            var buy_price =
                trade_get_buy_price(tag);

            var buy_world =
                trade_get_cheapest_world(tag);


            // ---------------------------------------------
            // ENOUGH CREDITS
            // ---------------------------------------------

            if (global.credits >= buy_price)
            {
                global.credits -=
                    buy_price;

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
                    + buy_world
                    + " / "
                    + string(buy_price)
                    + " cr";
            }
            else
            {
                trade_result =
                    "NOT ENOUGH CREDITS";
            }


            break;
        }


        // =================================================
        // SELL CLICK
        // =================================================

        if (
            mx >= sell_x1 &&
            mx <= sell_x2 &&
            my >= sell_y1 &&
            my <= sell_y2
        )
        {
            var owned =
                global.material_pool[$ tag];


            // ---------------------------------------------
            // ENOUGH RESOURCE
            // ---------------------------------------------

            if (owned >= trade_amount)
            {
                var sell_price =
                    trade_get_sell_price(tag);

                var sell_world =
                    trade_get_best_sell_world(tag);


                // -----------------------------------------
                // REMOVE RESOURCE
                // -----------------------------------------

                global.material_pool[$ tag] -=
                    trade_amount;


                // -----------------------------------------
                // ADD CREDITS
                // -----------------------------------------

                global.credits +=
                    sell_price;


                var sell_resource_name =
                    trade_get_resource_name(tag);


                trade_result =
                    "SOLD -"
                    + string(trade_amount)
                    + " "
                    + sell_resource_name
                    + " / "
                    + sell_world
                    + " / +"
                    + string(sell_price)
                    + " cr";
            }
            else
            {
                trade_result =
                    "NOT ENOUGH RESOURCE";
            }


            break;
        }
    }
}