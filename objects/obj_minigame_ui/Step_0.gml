
/// obj_minigame_ui - STEP
/// CRAFTING V4.6 - RECIPE DISCOVERY

if (global.ui_screen != 1) exit;

craft_v46_hints_init();

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0) - ui_shift_y;

var click = mouse_check_button_pressed(mb_left);
var release = mouse_check_button_released(mb_left);
var right_click = mouse_check_button_pressed(mb_right);
var handled = false;

if (craft_result != 0 && current_time > result_until)
    craft_result = 0;

// ANALYZER

if (click && !handled
&& mx >= ui.analyzer_x
&& mx <= ui.analyzer_x + ui.analyzer_w
&& my >= ui.analyzer_y
&& my <= ui.analyzer_y + 35)
{
    analyzer_open = !analyzer_open;
    handled = true;
}

// RANDOM MATERIAL MIX

if (click && !handled
&& mx >= ui.random_x
&& mx <= ui.random_x + ui.random_w
&& my >= ui.random_y
&& my <= ui.random_y + ui.random_h)
{
    randomize_craft();
    handled = true;
}

// CRAFT

if (click && !handled
&& mx >= ui.craft_x
&& mx <= ui.craft_x + ui.craft_w
&& my >= ui.craft_y
&& my <= ui.craft_y + ui.craft_h)
{
    craft_current();
    handled = true;
}

// CATEGORY PRESETS

if (click && !handled)
{
    for (var ci = 0; ci < array_length(categories); ci++)
    {
        var cc = ci mod 2;
        var cr = ci div 2;

        var px = ui.preset_x + cc * 135;
        var py = ui.preset_y + cr * ui.preset_step;

        if (mx >= px && mx <= px + 125
        && my >= py && my <= py + ui.preset_h)
        {
            load_category_shape(ci);
            handled = true;
            break;
        }
    }
}

// UNIFIED 3x3 MODULE GRID

if ((click || right_click) && !handled)
{
    for (var ci = 0; ci < 9; ci++)
    {
        var cc = ci mod 3;
        var cr = ci div 3;

        var px = ui.upper_x + cc * ui.upper_cell;
        var py = ui.upper_y + cr * ui.upper_cell;

        if (mx >= px
        && mx <= px + ui.upper_cell - 6
        && my >= py
        && my <= py + ui.upper_cell - 6)
        {
            if (right_click)
                module_cells[ci] = 0;
            else
                module_cells[ci] = selected_module;

            update_detected_category();

            craft_result = 0;
            craft_note = "MODULE UPDATED";
            handled = true;
            break;
        }
    }
}

// MODULE PALETTE

if (click && !handled)
{
    for (var mi = 0; mi < 7; mi++)
    {
        var px = 1010 + mi * 79;

        if (mx >= px && mx <= px + 72
        && my >= 709 && my <= 748)
        {
            selected_module = mi;
            handled = true;
            break;
        }
    }
}

// MODULE GUIDE TOGGLE

if (click && !handled
&& mx >= 1010 && mx <= 1560
&& my >= 673 && my <= 700)
{
    module_guide_open = !module_guide_open;
    handled = true;
}

// RESOURCE SELECTION

if (click && !handled)
{
    for (var gi = 0; gi < 8; gi++)
    {
        var cc = gi mod 4;
        var cr = gi div 4;

        var px = ui.pool_x + 12 + cc * 80;
        var py = ui.pool_y + 82 + cr * 90;

        if (mx >= px && mx <= px + 74
        && my >= py && my <= py + 78)
        {
            selected_group = gi;
            selected_variant = min(
                selected_variant,
                variant_counts[gi]
            );

            drag_active = true;
            drag_group = gi;
            drag_variant = selected_variant;
            drag_start_x = mx;
            drag_start_y = my;

            handled = true;
            break;
        }
    }
}

// VARIANT ARROWS

if (click && !handled && my >= 505 && my <= 545)
{
    if (mx >= 44 && mx <= 94)
    {
        selected_variant--;

        if (selected_variant < 1)
            selected_variant = variant_counts[selected_group];

        handled = true;
    }
    else if (mx >= 286 && mx <= 336)
    {
        selected_variant++;

        if (selected_variant > variant_counts[selected_group])
            selected_variant = 1;

        handled = true;
    }
}

// ADD / REMOVE / CLEAR

if (click && !handled)
{
    var group_name = groups[selected_group];

    if (mx >= 44 && mx <= 144
    && my >= 580 && my <= 625)
    {
        add_to_vessel(group_name, selected_variant, add_amount);
        handled = true;
    }
    else if (mx >= 154 && mx <= 254
    && my >= 580 && my <= 625)
    {
        remove_from_vessel(group_name, selected_variant, add_amount);
        handled = true;
    }
    else if (mx >= 44 && mx <= 344
    && my >= 646 && my <= 691)
    {
        clear_vessel();
        handled = true;
    }
}

// DRAG TO VESSEL

if (release && drag_active)
{
    if (mx >= ui.vessel_x
    && mx <= ui.vessel_x + ui.vessel_w
    && my >= ui.vessel_y
    && my <= ui.vessel_y + ui.vessel_h)
    {
        add_to_vessel(
            groups[drag_group],
            drag_variant,
            add_amount
        );
    }

    drag_active = false;
    drag_group = -1;
}

// ITEM BOOK TOGGLE

if (click && !handled
&& mx >= ui.book_x
&& mx <= ui.book_x + ui.book_w
&& my >= ui.book_y
&& my <= ui.book_y + 42)
{
    book_open = !book_open;
    handled = true;
}

// ITEM BOOK CONTROLS

if (click && !handled && book_open)
{
    var known = craft_v3_is_discovered(selected_recipe);

    // REVEAL NEXT HINT
    // Coordinates are in original, unshifted UI space.

    if (!known
    && mx >= 1235 && mx <= 1555
    && my >= 475 && my <= 500)
    {
        if (craft_v46_reveal_hint(selected_recipe))
        {
            craft_note = "NEW RECIPE HINT REVEALED";
            craft_result = 0;
        }
        else
        {
            craft_note = "ALL HINTS ALREADY REVEALED";
        }

        handled = true;
    }

    // INGREDIENTS TOGGLE

    if (!handled
    && mx >= 1020 && mx <= 1220
    && my >= 475 && my <= 500)
    {
        ingredients_open = !ingredients_open;
        handled = true;
    }

    // PREVIOUS / NEXT

    if (!handled && my >= 550 && my <= 586)
    {
        if (mx >= 1020 && mx <= 1130)
        {
            selected_recipe =
                (selected_recipe + array_length(recipes) - 1)
                mod array_length(recipes);

            handled = true;
        }
        else if (mx >= 1445 && mx <= 1555)
        {
            selected_recipe =
                (selected_recipe + 1)
                mod array_length(recipes);

            handled = true;
        }
    }

    // LOAD BASIC

    if (!handled
    && mx >= 1020 && mx <= 1275
    && my >= 600 && my <= 638)
    {
        load_recipe(selected_recipe, false);
        handled = true;
    }

    // LOAD PERFECT

    if (!handled
    && mx >= 1290 && mx <= 1555
    && my >= 600 && my <= 638)
    {
        load_recipe(selected_recipe, true);
        handled = true;
    }
}
