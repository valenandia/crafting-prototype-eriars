if (global.ui_screen != 0) exit;

/// obj_book - Draw GUI Event

draw_set_font(fnt_ui_small);


// =====================================================
// POSITION
// =====================================================

var book_x = 1330;
var book_y = 125;


// =====================================================
// TITLE
// =====================================================

draw_set_color(c_white);

draw_text(
    book_x,
    book_y,
    "ITEM BOOK"
);


// =====================================================
// DISCOVERED COUNT
// =====================================================

var discovered_count =
    array_length(global.discovered_items);

var total_count =
    array_length(global.recipes);


draw_set_color(c_gray);

draw_text(
    book_x,
    book_y + 30,
    "Discovered: "
    + string(discovered_count)
    + " / "
    + string(total_count)
);


// =====================================================
// EMPTY BOOK
// =====================================================

if (discovered_count == 0)
{
    draw_set_color(c_gray);

    draw_text(
        book_x,
        book_y + 75,
        "No items discovered yet."
    );

    draw_text(
        book_x,
        book_y + 100,
        "Successfully craft items"
    );

    draw_text(
        book_x,
        book_y + 125,
        "to discover them."
    );
}


// =====================================================
// DISCOVERED ITEMS
// =====================================================

if (discovered_count > 0)
{
    for (
        var i = 0;
        i < discovered_count;
        i++
    )
    {
        var discovered_id =
            global.discovered_items[i];

        var item_name =
            "Unknown";

        // Find recipe name
        for (
            var r = 0;
            r < array_length(global.recipes);
            r++
        )
        {
            if (
                global.recipes[r].id
                == discovered_id
            )
            {
                item_name =
                    global.recipes[r].name;

                break;
            }
        }


        var yy =
            book_y + 70 + (i * 24);


        // =============================================
        // KNOWN
        // =============================================

        draw_set_color(c_lime);

        draw_text(
            book_x,
            yy,
            "[KNOWN]"
        );


        // =============================================
        // ITEM NAME
        // =============================================

        draw_set_color(c_white);

        draw_text(
            book_x + 75,
            yy,
            item_name
        );
    }
}


// =====================================================
// RESET
// =====================================================

draw_set_font(-1);
draw_set_color(c_white);