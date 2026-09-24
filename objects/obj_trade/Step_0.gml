/// obj_trade - Step Event

if (global.ui_screen != 0)
{
    exit;
}


var mouse_gui_x =
    device_mouse_x_to_gui(0);

var mouse_gui_y =
    device_mouse_y_to_gui(0);


if (mouse_check_button_pressed(mb_left))
{
    for (
        var trade_i = 0;
        trade_i < array_length(trade_resources);
        trade_i++
    )
    {
        var trade_tag =
            trade_resources[trade_i];

        var trade_row_y =
            trade_y + 93 + trade_i * 30;


        // =================================================
        // BUY BUTTON
        // =================================================

        var buy_button_x1 =
            trade_x + 290;

        var buy_button_y1 =
            trade_row_y - 5;

        var buy_button_x2 =
            buy_button_x1 + button_w;

        var buy_button_y2 =
            buy_button_y1 + button_h;


        // =================================================
        // SELL BUTTON
        // =================================================

        var sell_button_x1 =
            trade_x + 470;

        var sell_button_y1 =
            trade_row_y - 5;

        var sell_button_x2 =
            sell_button_x1 + button_w;

        var sell_button_y2 =
            sell_button_y1 + button_h;


        // =================================================
        // BUY
        // =================================================

        if (
            mouse_gui_x >= buy_button_x1 &&
            mouse_gui_x <= buy_button_x2 &&
            mouse_gui_y >= buy_button_y1 &&
            mouse_gui_y <= buy_button_y2
        )
        {
            var buy_price =
                trade_get_buy_price(trade_tag);

            var buy_world =
                trade_get_cheapest_world(trade_tag);


            if (global.credits >= buy_price)
            {
                global.credits -=
                    buy_price;


                switch (trade_tag)
                {
                    case "stone":
                        global.material_pool.stone += trade_amount;
                    break;

                    case "polyester":
                        global.material_pool.polyester += trade_amount;
                    break;

                    case "tree":
                        global.material_pool.tree += trade_amount;
                    break;

                    case "cloth":
                        global.material_pool.cloth += trade_amount;
                    break;

                    case "glass":
                        global.material_pool.glass += trade_amount;
                    break;

                    case "jewels":
                        global.material_pool.jewels += trade_amount;
                    break;

                    case "mushrooms":
                        global.material_pool.mushrooms += trade_amount;
                    break;

                    case "blood":
                        global.material_pool.blood += trade_amount;
                    break;
                }


                trade_result =
                    "BOUGHT +"
                    + string(trade_amount)
                    + " "
                    + trade_get_resource_name(trade_tag)
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
        // SELL
        // =================================================

        if (
            mouse_gui_x >= sell_button_x1 &&
            mouse_gui_x <= sell_button_x2 &&
            mouse_gui_y >= sell_button_y1 &&
            mouse_gui_y <= sell_button_y2
        )
        {
            var owned_amount = 0;


            switch (trade_tag)
            {
                case "stone":
                    owned_amount = global.material_pool.stone;
                break;

                case "polyester":
                    owned_amount = global.material_pool.polyester;
                break;

                case "tree":
                    owned_amount = global.material_pool.tree;
                break;

                case "cloth":
                    owned_amount = global.material_pool.cloth;
                break;

                case "glass":
                    owned_amount = global.material_pool.glass;
                break;

                case "jewels":
                    owned_amount = global.material_pool.jewels;
                break;

                case "mushrooms":
                    owned_amount = global.material_pool.mushrooms;
                break;

                case "blood":
                    owned_amount = global.material_pool.blood;
                break;
            }


            if (owned_amount >= trade_amount)
            {
                var sell_price =
                    trade_get_sell_price(trade_tag);

                var sell_world =
                    trade_get_best_sell_world(trade_tag);


                switch (trade_tag)
                {
                    case "stone":
                        global.material_pool.stone -= trade_amount;
                    break;

                    case "polyester":
                        global.material_pool.polyester -= trade_amount;
                    break;

                    case "tree":
                        global.material_pool.tree -= trade_amount;
                    break;

                    case "cloth":
                        global.material_pool.cloth -= trade_amount;
                    break;

                    case "glass":
                        global.material_pool.glass -= trade_amount;
                    break;

                    case "jewels":
                        global.material_pool.jewels -= trade_amount;
                    break;

                    case "mushrooms":
                        global.material_pool.mushrooms -= trade_amount;
                    break;

                    case "blood":
                        global.material_pool.blood -= trade_amount;
                    break;
                }


                global.credits +=
                    sell_price;


                trade_result =
                    "SOLD -"
                    + string(trade_amount)
                    + " "
                    + trade_get_resource_name(trade_tag)
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