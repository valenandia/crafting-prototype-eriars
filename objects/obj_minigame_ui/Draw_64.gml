
/// obj_minigame_ui - DRAW GUI
/// CRAFTING V4.3
/// QUALITY BREAKDOWN INSIDE ANALYZER
/// CRAFT PREVIEW ALWAYS UNKNOWN

if (global.ui_screen != 1) exit;

// CRAFTING V4.4 - DRAW OFFSET

var old_matrix = matrix_get(matrix_world);

matrix_set(
    matrix_world,
    matrix_build(
        0, ui_shift_y, 0,
        0, 0, 0,
        1, 1, 1
    )
);

draw_set_font(fnt_ui_small);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);

var bg = make_color_rgb(24,29,38);
var panel = make_color_rgb(37,44,56);
var light = make_color_rgb(61,73,90);
var purple = make_color_rgb(124,86,170);
var green = make_color_rgb(100,220,140);
var red = make_color_rgb(236,75,91);
var yellow = make_color_rgb(235,203,81);
var muted = make_color_rgb(160,170,185);
var cyan = make_color_rgb(80,207,225);

var module_colors = [
    cyan,
    make_color_rgb(224,91,196),
    yellow
];

var module_names = ["C","M","Y"];
var buff_names = ["FAIL","BACK","FIND"];

var short_groups = [
    "STONE","POLY","TREE","CLOTH",
    "GLASS","JEWELS","MUSH","BLOOD"
];

var analysis = get_analysis();
var detected_category =
    craft_v4_pattern_category(upper_modules);

var shape_name = "UNKNOWN";

if (detected_category >= 0
&& detected_category < array_length(categories))
{
    shape_name = categories[detected_category];
}

// BACKGROUND
draw_set_color(bg);
draw_rectangle(0,0,1600,900,false);

draw_set_color(c_white);
draw_text(24,105,"CRAFTING SYSTEM V4.3");

draw_set_color(muted);
draw_text(24,133,"BUILD SHAPE / MIX / CRAFT / PERFECT");

// RESOURCE POOL
draw_set_color(panel);
draw_rectangle(24,185,364,810,false);

draw_set_color(c_white);
draw_text(40,205,"RESOURCE POOL");

draw_set_color(muted);
draw_text(40,230,"SELECT MATERIAL");

for (var gi = 0; gi < 8; gi++)
{
    var cc = gi mod 4;
    var cr = gi div 4;
    var px = 36 + cc*80;
    var py = 267 + cr*90;

    draw_set_color(selected_group == gi ? purple : light);
    draw_rectangle(px,py,px+74,py+78,false);

    draw_set_color(group_colors[gi]);
    draw_rectangle(px,py,px+74,py+6,false);

    draw_set_color(c_white);
    draw_text(px+5,py+23,short_groups[gi]);

    draw_set_color(muted);
    draw_text(px+5,py+52,string(get_pool(groups[gi])));
}

// RESOURCE VARIANT
draw_set_color(c_white);
draw_text(44,465,"RESOURCE VARIANT");

draw_set_color(light);
draw_rectangle(44,505,94,545,false);
draw_rectangle(286,505,336,545,false);

draw_set_color(c_white);
draw_text(64,516,"<");
draw_text(306,516,">");

draw_set_color(group_colors[selected_group]);
draw_text(
    118,516,
    groups[selected_group]+"_"+string(selected_variant)
);

// ADD / REMOVE / CLEAR
draw_set_color(green);
draw_rectangle(44,580,144,625,false);

draw_set_color(red);
draw_rectangle(154,580,254,625,false);

draw_set_color(bg);
draw_text(76,594,"+10");
draw_text(185,594,"-10");

draw_set_color(light);
draw_rectangle(44,646,344,691,false);

draw_set_color(c_white);
draw_text(172,660,"CLEAR");

draw_set_color(muted);
draw_text(44,721,"One stack per required material");
draw_text(44,745,"can create a crude item.");
draw_text(44,769,"Improve your mix to raise quality.");

// SHAPE PRESETS
draw_set_color(panel);
draw_rectangle(380,185,665,475,false);

draw_set_color(c_white);
draw_text(400,199,"SHAPE PRESETS");

for (var ci = 0; ci < array_length(categories); ci++)
{
    var cc = ci mod 2;
    var cr = ci div 2;
    var px = ui.preset_x + cc*135;
    var py = ui.preset_y + cr*ui.preset_step;

    draw_set_color(
        detected_category == ci ? purple : light
    );

    draw_rectangle(
        px,py,px+125,py+ui.preset_h,false
    );

    draw_set_color(c_white);
    draw_text(px+7,py+18,categories[ci]);
}

// UPPER MODULE GRID
draw_set_color(panel);
draw_rectangle(680,185,975,475,false);

draw_set_color(c_white);
draw_text(700,199,"UPPER MODULE GRID");

draw_set_color(muted);
draw_text(700,227,"LEFT CLICK: CYCLE C / M / Y");
draw_text(700,247,"RIGHT CLICK: CLEAR CELL");

for (var ci = 0; ci < 6; ci++)
{
    var cc = ci mod 3;
    var cr = ci div 3;
    var px = ui.upper_x + cc*ui.upper_cell;
    var py = ui.upper_y + cr*ui.upper_cell;

    draw_set_color(light);
    draw_rectangle(
        px,py,
        px+ui.upper_cell-6,
        py+ui.upper_cell-6,false
    );

    if (upper_modules[ci] >= 0)
    {
        var module = upper_modules[ci];

        draw_set_color(module_colors[module]);
        draw_rectangle(
            px+12,py+12,
            px+ui.upper_cell-18,
            py+ui.upper_cell-18,false
        );

        draw_set_color(bg);
        draw_text(px+27,py+25,module_names[module]);
    }
    else
    {
        draw_set_color(muted);
        draw_text(px+27,py+25,"+");
    }
}

draw_set_color(detected_category >= 0 ? green : muted);
draw_text(700,430,"SHAPE: "+shape_name);

// RECIPE ANALYZER
var analyzer_bottom = analyzer_open ? 598 : 515;

draw_set_color(panel);
draw_rectangle(
    ui.analyzer_x,
    ui.analyzer_y,
    ui.analyzer_x+ui.analyzer_w,
    analyzer_bottom,
    false
);

draw_set_color(c_white);
draw_text(405,491,"RECIPE ANALYZER");

var status_color = muted;

if (analysis.status == "CRAFTABLE")
    status_color = green;
else if (analysis.status == "UNSTABLE")
    status_color = red;

draw_set_color(status_color);
draw_text(727,491,analysis.status);

draw_set_color(c_white);
draw_text(945,491,analyzer_open ? "[-]" : "[+]");

if (analyzer_open)
{
    // SHAPE MATCH
    draw_set_color(muted);
    draw_text(405,519,"SHAPE MATCH:");

    draw_set_color(detected_category >= 0 ? green : red);
    draw_text(
        525,519,
        shape_name+
        (detected_category >= 0 ? " / VALID" : " / INVALID")
    );

    // PREDICTED QUALITY
    draw_set_color(muted);
    draw_text(405,541,"PREDICTED QUALITY:");

    if (analysis.status == "CRAFTABLE")
    {
        var quality_color = cyan;

        if (analysis.quality <= 24)
            quality_color = red;
        else if (analysis.quality >= 75)
            quality_color = yellow;

        if (analysis.perfect)
            quality_color = green;

        draw_set_color(quality_color);
        draw_text(
            575,541,
            analysis.tier+" / Q"+string(analysis.quality)
        );
    }
    else
    {
        draw_set_color(muted);
        draw_text(575,541,"UNKNOWN");
    }

    // CAPACITY
    draw_set_color(muted);
    draw_text(760,519,"CAPACITY:");

    draw_set_color(c_white);
    draw_text(
        860,519,
        string(analysis.capacity)+"/100"
    );

    // QUALITY BREAKDOWN INSIDE ANALYZER
    if (analysis.status == "CRAFTABLE")
    {
        draw_set_color(muted);
        draw_text(405,566,"QUALITY BREAKDOWN");

        draw_set_color(cyan);
        draw_text(
            585,566,
            "F "+string(analysis.fidelity)+"%"
        );

        draw_set_color(green);
        draw_text(
            700,566,
            "V "+string(analysis.variants)+"%"
        );

        draw_set_color(yellow);
        draw_text(
            815,566,
            "S "+string(analysis.structure)+"%"
        );

        draw_set_color(analysis.perfect ? yellow : muted);

        draw_text(
            405,583,
            analysis.perfect
            ? "PERFECT BLUEPRINT MATCH!"
            : "F: FIDELITY / V: VARIANTS / S: STACKS"
        );
    }
    else
    {
        draw_set_color(muted);
        draw_text(405,566,"QUALITY BREAKDOWN: --");
        draw_text(405,583,analysis.message);
    }
}

// COMMENTARY
var comment = "";

if (craft_result == 1)
{
    if (last_quality == 100)
        comment = "PERFECT?! WHO LET YOU COOK?!";
    else if (last_quality <= 24)
        comment = "It's ugly. It's alive. I'm impressed.";
    else
        comment = "It worked! Now make it prettier.";
}
else if (craft_result == 2)
{
    comment = "Didn't work out, bro. :(";
}
else if (craft_result == 3)
{
    comment = "What the hell is this crap?!";
}
else if (craft_result == 4)
{
    comment = "The cauldron is emptier than my wallet.";
}
else if (craft_result == 5)
{
    comment = "You're broke. The cauldron knows.";
}
else
{
    switch (analysis.status)
    {
        case "EMPTY":
            comment = "The materials won't mix themselves.";
            break;

        case "UNSTABLE":
            comment = detected_category < 0
                ? "What the hell is this shape?!"
                : "These ingredients are fighting each other.";
            break;

        case "CRAFTABLE":
            if (analysis.perfect)
                comment = "Perfect recipe detected!";
            else if (analysis.capacity < 40)
                comment = "A terrible item is still an item!";
            else if (analysis.quality >= 75)
                comment = "Ooh, fancy! Someone's talented.";
            else
                comment = "This looks suspiciously craftable.";
            break;
    }
}

draw_set_color(panel);
draw_rectangle(390,603,975,631,false);

draw_set_color(c_white);
draw_text(403,609,comment);

// MIXING VESSEL
draw_set_color(panel);
draw_rectangle(390,640,975,805,false);

draw_set_color(c_white);
draw_text(405,649,"MIXING VESSEL");

draw_set_color(muted);
draw_text(875,649,string(analysis.capacity)+"/100");

draw_set_color(light);
draw_rectangle(405,675,960,687,false);

draw_set_color(
    analysis.status == "CRAFTABLE" ? green : purple
);

draw_rectangle(
    405,675,
    405+555*clamp(analysis.capacity/100,0,1),
    687,false
);

var visible_stack_count =
    min(array_length(vessel_stacks),12);

for (var si = 0; si < visible_stack_count; si++)
{
    var stack = vessel_stacks[si];
    var cc = si mod 4;
    var cr = si div 4;
    var px = 405+cc*138;
    var py = 697+cr*26;

    draw_set_color(light);
    draw_rectangle(px,py,px+132,py+23,false);

    draw_set_color(c_white);
    draw_text(
        px+5,py+5,
        stack.group+"_"+string(stack.variant)+
        " x"+string(stack.amount)
    );
}

if (array_length(vessel_stacks) == 0)
{
    draw_set_color(muted);
    draw_text(405,712,"No materials added yet.");
}

if (array_length(vessel_stacks) > visible_stack_count)
{
    draw_set_color(yellow);
    draw_text(
        405,782,
        "+"+string(
            array_length(vessel_stacks)-visible_stack_count
        )+" MORE STACKS"
    );
}

// RANDOM / CRAFT
draw_set_color(light);
draw_rectangle(390,812,555,860,false);

draw_set_color(c_white);
draw_text(440,828,"RANDOM");

draw_set_color(purple);
draw_rectangle(735,812,975,860,false);

draw_set_color(c_white);
draw_text(830,828,"CRAFT");

if (craft_result != 0)
{
    draw_set_color(panel);
    draw_rectangle(390,865,975,895,false);

    draw_set_color(craft_result == 1 ? green : yellow);
    draw_text(405,873,craft_note);
}

// CRAFT PREVIEW - ALWAYS UNKNOWN
draw_set_color(panel);
draw_rectangle(1000,185,1575,275,false);

draw_set_color(c_white);

draw_set_color(light);
draw_circle(1060,235,28,false);

draw_set_color(c_white);
draw_text(1054,222,"?");

draw_set_color(muted);
draw_text(1110,218,"UNKNOWN RESULT");

if (analysis.status == "CRAFTABLE")
{
    draw_set_color(analysis.perfect ? yellow : cyan);
    draw_text(
        1110,241,
        analysis.tier+" / Q"+string(analysis.quality)
    );

    draw_set_color(muted);
    draw_text(
        1350,241,
        "SUCCESS "+string(round(100-get_failure()))+"%"
    );
}
else
{
    draw_set_color(muted);
    draw_text(1110,241,analysis.message);
}

// ITEM BOOK HEADER
draw_set_color(panel);
draw_rectangle(1000,290,1575,332,false);

var discovered_count = 0;

for (var ri = 0; ri < array_length(recipes); ri++)
{
    if (craft_v3_is_discovered(ri))
        discovered_count++;
}

draw_set_color(c_white);
draw_text(
    1020,302,
    "ITEM BOOK "+string(discovered_count)+"/"+
    string(array_length(recipes))+
    (book_open ? " [-]" : " [+]")
);

// ITEM BOOK CONTENT
if (book_open)
{
    draw_set_color(panel);
    draw_rectangle(1000,339,1575,652,false);

    var book_recipe = recipes[selected_recipe];
    var known = craft_v3_is_discovered(selected_recipe);

    if (known)
    {
        var best_quality =
            craft_v3_visual_best_quality(selected_recipe);

        craft_v3_item_icon(
            selected_recipe,
            1080,410,112,
            max(35,best_quality)
        );

        draw_set_color(c_white);
        draw_text(1160,353,book_recipe.name);

        draw_set_color(muted);
        draw_text(
            1160,380,
            "CATEGORY: "+
            categories[craft_v4_category_of(selected_recipe)]
        );

        draw_set_color(green);
        draw_text(1160,405,"DISCOVERED");

        draw_set_color(muted);
        draw_text(
            1160,430,
            "OWNED: "+
            string(craft_v3_visual_owned(selected_recipe))
        );
    }
    else
    {
        draw_set_color(light);
        draw_circle(1080,410,45,false);

        draw_set_color(c_white);
        draw_text(1074,397,"?");
        draw_text(
            1160,353,
            "UNKNOWN ITEM #"+string(selected_recipe+1)
        );

        draw_set_color(muted);
        draw_text(1160,380,"CATEGORY: ???");

        draw_set_color(red);
        draw_text(1160,405,"NOT DISCOVERED");

        draw_set_color(muted);
        draw_text(1160,430,"CRAFT TO UNLOCK");
    }

    draw_set_color(light);
    draw_rectangle(1020,475,1220,500,false);

    draw_set_color(c_white);
    draw_text(
        1030,480,
        ingredients_open
        ? "INGREDIENTS [-]"
        : "INGREDIENTS [+]"
    );

    if (ingredients_open)
    {
        if (known)
        {
            for (
                var ii = 0;
                ii < array_length(book_recipe.ingredients);
                ii++
            )
            {
                var ing = book_recipe.ingredients[ii];

                draw_set_color(muted);
                draw_text(
                    1020,505+ii*18,
                    string_upper(ing.group)+
                    " x"+string(ing.amount)
                );
            }
        }
        else
        {
            draw_set_color(muted);
            draw_text(1020,510,"???");
        }
    }

    draw_set_color(light);
    draw_rectangle(1020,550,1130,586,false);
    draw_rectangle(1445,550,1555,586,false);

    draw_set_color(c_white);
    draw_text(1040,561,"< PREV");
    draw_text(1465,561,"NEXT >");

    draw_set_color(known ? purple : light);
    draw_rectangle(1020,600,1275,638,false);
    draw_rectangle(1290,600,1555,638,false);

    draw_set_color(c_white);
    draw_text(1070,611,known ? "LOAD BASIC" : "LOCKED");
    draw_text(1330,611,known ? "LOAD PERFECT" : "LOCKED");
}

// BUFF GEOMETRY
draw_set_color(panel);
draw_rectangle(1000,665,1575,810,false);

draw_set_color(c_white);
draw_text(1020,675,"BUFF GEOMETRY");

for (var ci = 0; ci < 9; ci++)
{
    var cc = ci mod 3;
    var cr = ci div 3;
    var px = ui.buff_x+cc*ui.buff_cell;
    var py = ui.buff_y+cr*ui.buff_cell;

    draw_set_color(light);
    draw_rectangle(
        px,py,
        px+ui.buff_cell-3,
        py+ui.buff_cell-3,false
    );

    if (buff_cells[ci] >= 0)
    {
        var bi = buff_cells[ci];

        switch (bi)
        {
            case 0: draw_set_color(red); break;
            case 1: draw_set_color(green); break;
            case 2: draw_set_color(yellow); break;
        }

        draw_rectangle(
            px+6,py+6,
            px+ui.buff_cell-9,
            py+ui.buff_cell-9,false
        );

        draw_set_color(bg);
        draw_text(px+11,py+8,string(bi+1));
    }
}

for (var bi = 0; bi < 3; bi++)
{
    var px = 1210+bi*112;

    draw_set_color(selected_buff == bi ? purple : light);
    draw_rectangle(px,710,px+100,746,false);

    draw_set_color(c_white);
    draw_text(px+17,721,buff_names[bi]);
}

draw_set_color(get_buff_shape() != -1 ? green : muted);
draw_text(
    1210,757,
    "SHAPE: "+
    (get_buff_shape() == -1 ? "OFF" : "ACTIVE x1.25")
);

draw_set_color(muted);
draw_text(
    1210,781,
    "FAIL -"+string(get_buff_rate(0))+
    "% / BACK "+string(get_buff_rate(1))+
    "% / FIND "+string(get_buff_rate(2))+"%"
);

// DRAG PREVIEW
if (drag_active && mouse_check_button(mb_left))
{
    var mouse_gui_x = device_mouse_x_to_gui(0);
    var mouse_gui_y = device_mouse_y_to_gui(0);

    if (abs(mouse_gui_x-drag_start_x) > 8
    || abs(mouse_gui_y-drag_start_y) > 8)
    {
        draw_set_alpha(0.85);
        draw_set_color(purple);

        draw_rectangle(
            mouse_gui_x+12,mouse_gui_y+12,
            mouse_gui_x+150,mouse_gui_y+45,false
        );

        draw_set_color(c_white);
        draw_text(
            mouse_gui_x+20,mouse_gui_y+22,
            groups[drag_group]+"_"+
            string(drag_variant)+" +10"
        );

        draw_set_alpha(1);
    }
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);


// Restore matrix for other objects.
matrix_set(matrix_world, old_matrix);
