
/// obj_minigame_ui - DRAW GUI
/// CRAFTING SYSTEM V5.0
///
/// Unified UI:
/// - Resource Pool
/// - Shape Presets
/// - Unified Module Grid
/// - Recipe Analyzer
/// - Mixing Vessel
/// - Item Book + V4.6 Hints
/// - Module Library + V4.9 Buffs
/// - V4.7 Combination Guide
///
/// Keeps V4.5 interaction coordinates.
/// Draw GUI End should be empty.

if (global.ui_screen != 1) exit;

draw_set_font(fnt_ui_small);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);

// ==========================================
// COLORS
// ==========================================

var bg = make_color_rgb(24,29,38);
var panel = make_color_rgb(37,44,56);
var light = make_color_rgb(61,73,90);
var purple = make_color_rgb(124,86,170);
var green = make_color_rgb(100,220,140);
var red = make_color_rgb(236,75,91);
var yellow = make_color_rgb(235,203,81);
var muted = make_color_rgb(160,170,185);
var cyan = make_color_rgb(80,207,225);
var magenta = make_color_rgb(224,91,196);

var module_colors = [
    make_color_rgb(125,135,150),
    cyan,
    magenta,
    yellow,
    red,
    green,
    purple
];

var module_names = [
    "B","C","M","Y","F","R","D"
];

var short_groups = [
    "STONE","POLY","TREE","CLOTH",
    "GLASS","JEWELS","MUSH","BLOOD"
];

var shift = ui_shift_y;

var analysis = get_analysis();

var detected_category =
    craft_v45_pattern_category(module_cells);

var shape_name = "UNKNOWN";

if (detected_category >= 0
&& detected_category < array_length(categories))
{
    shape_name = categories[detected_category];
}

var guide = craft_v47_analyze(module_cells);
var buffs = craft_v49_buff_report(module_cells);

// ==========================================
// BACKGROUND
// ==========================================

draw_set_color(bg);
draw_rectangle(0,0,1600,900,false);

// ==========================================
// HEADER
// ==========================================

draw_set_color(c_white);
draw_text(
    24,105 + shift,
    "CRAFTING SYSTEM V5.0"
);

draw_set_color(muted);
draw_text(
    24,133 + shift,
    "BUILD MODULES / MIX / CRAFT / DISCOVER"
);

// ==========================================
// RESOURCE POOL
// ==========================================

draw_set_color(panel);
draw_rectangle(
    24,185 + shift,
    364,810 + shift,
    false
);

draw_set_color(c_white);
draw_text(40,205 + shift,"RESOURCE POOL");

draw_set_color(muted);
draw_text(40,230 + shift,"SELECT MATERIAL");

// RESOURCE CARDS

for (var gi = 0; gi < 8; gi++)
{
    var cc = gi mod 4;
    var cr = gi div 4;

    var px = 36 + cc * 80;
    var py = 267 + cr * 90 + shift;

    draw_set_color(
        selected_group == gi ? purple : light
    );

    draw_rectangle(
        px,py,
        px + 74,py + 78,
        false
    );

    draw_set_color(group_colors[gi]);
    draw_rectangle(
        px,py,
        px + 74,py + 6,
        false
    );

    draw_set_color(c_white);
    draw_text(
        px + 5,py + 23,
        short_groups[gi]
    );

    draw_set_color(muted);
    draw_text(
        px + 5,py + 52,
        string(get_pool(groups[gi]))
    );
}

// RESOURCE VARIANT

draw_set_color(c_white);
draw_text(
    44,465 + shift,
    "RESOURCE VARIANT"
);

draw_set_color(light);
draw_rectangle(
    44,505 + shift,
    94,545 + shift,
    false
);
draw_rectangle(
    286,505 + shift,
    336,545 + shift,
    false
);

draw_set_color(c_white);
draw_text(64,516 + shift,"<");
draw_text(306,516 + shift,">");

draw_set_color(group_colors[selected_group]);
draw_text(
    118,516 + shift,
    groups[selected_group]
    + "_" + string(selected_variant)
);

// ADD / REMOVE

draw_set_color(green);
draw_rectangle(
    44,580 + shift,
    144,625 + shift,
    false
);

draw_set_color(red);
draw_rectangle(
    154,580 + shift,
    254,625 + shift,
    false
);

draw_set_color(bg);
draw_text(76,594 + shift,"+10");
draw_text(185,594 + shift,"-10");

// CLEAR

draw_set_color(light);
draw_rectangle(
    44,646 + shift,
    344,691 + shift,
    false
);

draw_set_color(c_white);
draw_text(172,660 + shift,"CLEAR");

// RESOURCE HELP

draw_set_color(muted);
draw_text(
    44,721 + shift,
    "One stack per required material"
);
draw_text(
    44,745 + shift,
    "can create a crude item."
);
draw_text(
    44,769 + shift,
    "Improve your mix to raise quality."
);

// ==========================================
// SHAPE PRESETS
// ==========================================

draw_set_color(panel);
draw_rectangle(
    380,185 + shift,
    665,475 + shift,
    false
);

draw_set_color(c_white);
draw_text(
    400,196 + shift,
    "SHAPE PRESETS"
);

// Move subtitle away from title.

draw_set_color(muted);
draw_text(
    400,222 + shift,
    "RANDOM VALID LAYOUT"
);

// Preserve original preset hitboxes.

for (var ci = 0;
     ci < array_length(categories);
     ci++)
{
    var cc = ci mod 2;
    var cr = ci div 2;

    var px = ui.preset_x + cc * 135;
    var py =
        ui.preset_y
        + cr * ui.preset_step
        + shift;

    draw_set_color(
        detected_category == ci
        ? purple
        : light
    );

    draw_rectangle(
        px,py,
        px + 125,
        py + ui.preset_h,
        false
    );

    draw_set_color(c_white);
    draw_text(
        px + 7,py + 18,
        categories[ci]
    );
}

// ==========================================
// UNIFIED MODULE GRID
// ==========================================

draw_set_color(panel);
draw_rectangle(
    680,185 + shift,
    975,475 + shift,
    false
);

draw_set_color(c_white);
draw_text(
    700,196 + shift,
    "UNIFIED MODULE GRID"
);

draw_set_color(muted);
draw_text(
    700,225 + shift,
    "SELECT MODULE FROM LIBRARY"
);
draw_text(
    700,246 + shift,
    "RIGHT CLICK: RESET TO BASE"
);

// Keep original grid hitboxes.
// Draw smaller modules inside each hitbox
// to improve visual spacing.

var visual_size = min(
    ui.upper_cell - 8,
    54
);

for (var ci = 0; ci < 9; ci++)
{
    var cc = ci mod 3;
    var cr = ci div 3;

    var cell_x =
        ui.upper_x + cc * ui.upper_cell;

    var cell_y =
        ui.upper_y
        + cr * ui.upper_cell
        + shift;

    var module = module_cells[ci];

    var inset =
        (ui.upper_cell - visual_size) * 0.5;

    var px = cell_x + inset;
    var py = cell_y + inset;

    // CELL BACKGROUND

    draw_set_color(light);
    draw_rectangle(
        px,py,
        px + visual_size,
        py + visual_size,
        false
    );

    // MODULE COLOR

    draw_set_color(module_colors[module]);
    draw_rectangle(
        px + 5,py + 5,
        px + visual_size - 5,
        py + visual_size - 5,
        false
    );

    // MODULE LETTER

    draw_set_color(bg);
    draw_text(
        px + visual_size * 0.39,
        py + visual_size * 0.28,
        module_names[module]
    );
}

// Shape status moved to top-right,
// away from the third grid row.

draw_set_color(
    detected_category >= 0
    ? green
    : red
);

draw_set_halign(fa_right);

draw_text(
    960,196 + shift,
    shape_name
);

draw_set_halign(fa_left);

// ==========================================
// RECIPE ANALYZER
// ==========================================

// Keep the original header and toggle
// coordinates for Step Event compatibility.

var analyzer_bottom =
    analyzer_open ? 598 : 515;

draw_set_color(panel);
draw_rectangle(
    ui.analyzer_x,
    ui.analyzer_y + shift,
    ui.analyzer_x + ui.analyzer_w,
    analyzer_bottom + shift,
    false
);

draw_set_color(c_white);
draw_text(
    405,491 + shift,
    "RECIPE ANALYZER"
);

var status_color = muted;

if (analysis.status == "CRAFTABLE")
    status_color = green;
else if (analysis.status == "UNSTABLE")
    status_color = red;

draw_set_color(status_color);
draw_text(
    727,491 + shift,
    analysis.status
);

draw_set_color(c_white);
draw_text(
    945,491 + shift,
    analyzer_open ? "[-]" : "[+]"
);

// EXPANDED ANALYZER

if (analyzer_open)
{
    // ROW 1

    draw_set_color(muted);
    draw_text(
        405,519 + shift,
        "SHAPE:"
    );

    draw_set_color(
        detected_category >= 0
        ? green
        : red
    );

    draw_text(
        480,519 + shift,
        shape_name
    );

    draw_set_color(muted);
    draw_text(
        760,519 + shift,
        "CAPACITY:"
    );

    draw_set_color(c_white);
    draw_text(
        860,519 + shift,
        string(analysis.capacity) + "/100"
    );

    // ROW 2

    draw_set_color(muted);
    draw_text(
        405,541 + shift,
        "QUALITY:"
    );

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
            490,541 + shift,
            analysis.tier
            + " / Q"
            + string(analysis.quality)
        );
    }
    else
    {
        draw_set_color(muted);
        draw_text(
            490,541 + shift,
            "UNKNOWN"
        );
    }

    // ROW 3

    if (analysis.status == "CRAFTABLE")
    {
        draw_set_color(muted);
        draw_text(
            405,566 + shift,
            "BREAKDOWN:"
        );

        draw_set_color(cyan);
        draw_text(
            545,566 + shift,
            "F " + string(analysis.fidelity) + "%"
        );

        draw_set_color(green);
        draw_text(
            670,566 + shift,
            "V " + string(analysis.variants) + "%"
        );

        draw_set_color(yellow);
        draw_text(
            795,566 + shift,
            "S " + string(analysis.structure) + "%"
        );

        draw_set_color(
            analysis.perfect ? yellow : muted
        );

        draw_text(
            405,584 + shift,
            analysis.perfect
            ? "PERFECT BLUEPRINT MATCH!"
            : "F: FIDELITY / V: VARIANTS / S: STACKS"
        );
    }
    else
    {
        draw_set_color(muted);
        draw_text(
            405,566 + shift,
            analysis.message
        );
    }
}

// ==========================================
// COMMENTARY
// ==========================================

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
draw_rectangle(
    390,603 + shift,
    975,631 + shift,
    false
);

draw_set_color(c_white);
draw_text(
    403,609 + shift,
    comment
);

// ==========================================
// MIXING VESSEL
// ==========================================

draw_set_color(panel);
draw_rectangle(
    390,640 + shift,
    975,805 + shift,
    false
);

draw_set_color(c_white);
draw_text(
    405,649 + shift,
    "MIXING VESSEL"
);

draw_set_color(muted);
draw_text(
    875,649 + shift,
    string(analysis.capacity) + "/100"
);

// CAPACITY BAR

draw_set_color(light);
draw_rectangle(
    405,675 + shift,
    960,687 + shift,
    false
);

draw_set_color(
    analysis.status == "CRAFTABLE"
    ? green
    : purple
);

draw_rectangle(
    405,675 + shift,
    405 + 555 * clamp(analysis.capacity / 100,0,1),
    687 + shift,
    false
);

// MATERIAL STACKS

var visible_stack_count =
    min(array_length(vessel_stacks),12);

for (var si = 0; si < visible_stack_count; si++)
{
    var stack = vessel_stacks[si];

    var cc = si mod 4;
    var cr = si div 4;

    var px = 405 + cc * 138;
    var py = 697 + cr * 26 + shift;

    draw_set_color(light);
    draw_rectangle(
        px,py,
        px + 132,py + 23,
        false
    );

    draw_set_color(c_white);
    draw_text(
        px + 5,py + 5,
        stack.group + "_"
        + string(stack.variant)
        + " x" + string(stack.amount)
    );
}

if (array_length(vessel_stacks) == 0)
{
    draw_set_color(muted);
    draw_text(
        405,712 + shift,
        "No materials added yet."
    );
}

if (array_length(vessel_stacks) > visible_stack_count)
{
    draw_set_color(yellow);
    draw_text(
        405,782 + shift,
        "+"
        + string(
            array_length(vessel_stacks)
            - visible_stack_count
        )
        + " MORE STACKS"
    );
}

// ==========================================
// RANDOM / CRAFT BUTTONS
// ==========================================

draw_set_color(light);
draw_rectangle(
    390,812 + shift,
    555,860 + shift,
    false
);

draw_set_color(c_white);
draw_text(
    440,828 + shift,
    "RANDOM"
);

draw_set_color(purple);
draw_rectangle(
    735,812 + shift,
    975,860 + shift,
    false
);

draw_set_color(c_white);
draw_text(
    830,828 + shift,
    "CRAFT"
);

// CRAFT RESULT MESSAGE

if (craft_result != 0)
{
    draw_set_color(panel);
    draw_rectangle(
        390,865 + shift,
        975,895 + shift,
        false
    );

    draw_set_color(
        craft_result == 1
        ? green
        : yellow
    );

    draw_text(
        405,873 + shift,
        craft_note
    );
}

// ==========================================
// UNKNOWN CRAFTING RESULT
// ==========================================

draw_set_color(panel);
draw_rectangle(
    1000,185 + shift,
    1575,275 + shift,
    false
);

draw_set_color(light);
draw_circle(
    1060,235 + shift,
    28,false
);

draw_set_color(c_white);
draw_text(
    1054,222 + shift,
    "?"
);

draw_set_color(muted);
draw_text(
    1110,218 + shift,
    "UNKNOWN RESULT"
);

if (analysis.status == "CRAFTABLE")
{
    draw_set_color(
        analysis.perfect ? yellow : cyan
    );

    draw_text(
        1110,241 + shift,
        analysis.tier
        + " / Q"
        + string(analysis.quality)
    );

    draw_set_color(muted);
    draw_text(
        1350,241 + shift,
        "SUCCESS "
        + string(round(100 - get_failure()))
        + "%"
    );
}
else
{
    draw_set_color(muted);
    draw_text(
        1110,241 + shift,
        analysis.message
    );
}

// ==========================================
// ITEM BOOK HEADER
// ==========================================

draw_set_color(panel);
draw_rectangle(
    1000,290 + shift,
    1575,332 + shift,
    false
);

var discovered_count = 0;

for (var ri = 0; ri < array_length(recipes); ri++)
{
    if (craft_v3_is_discovered(ri))
        discovered_count++;
}

draw_set_color(c_white);
draw_text(
    1020,302 + shift,
    "ITEM BOOK "
    + string(discovered_count)
    + "/"
    + string(array_length(recipes))
    + (book_open ? " [-]" : " [+]")
);

// ==========================================
// ITEM BOOK CONTENT
// ==========================================

if (book_open)
{
    draw_set_color(panel);
    draw_rectangle(
        1000,339 + shift,
        1575,652 + shift,
        false
    );

    var ri = selected_recipe;
    var recipe = recipes[ri];

    var hint = craft_v46_hint_data(ri);
    var known = hint.known;
    var hint_level = hint.level;

    // RECIPE ICON

    if (known)
    {
        var best_quality =
            craft_v3_visual_best_quality(ri);

        craft_v3_item_icon(
            ri,
            1080,410 + shift,
            112,
            max(35,best_quality)
        );
    }
    else
    {
        draw_set_color(light);
        draw_circle(
            1080,410 + shift,
            45,false
        );

        draw_set_color(c_white);
        draw_text(
            1074,397 + shift,
            "?"
        );
    }

    // RECIPE TITLE

    draw_set_color(c_white);

    if (known)
    {
        draw_text(
            1160,353 + shift,
            recipe.name
        );
    }
    else
    {
        draw_text(
            1160,353 + shift,
            "UNKNOWN ITEM #"
            + string(ri + 1)
        );
    }

    // CATEGORY

    draw_set_color(muted);
    draw_text(
        1160,380 + shift,
        "CATEGORY: " + hint.category
    );

    // DISCOVERY STATUS

    draw_set_color(
        known ? green : red
    );

    draw_text(
        1160,405 + shift,
        known
        ? "DISCOVERED"
        : "NOT DISCOVERED"
    );

    // HINT STATUS

    draw_set_color(muted);

    if (known)
    {
        draw_text(
            1160,430 + shift,
            "OWNED: "
            + string(craft_v3_visual_owned(ri))
        );
    }
    else
    {
        draw_text(
            1160,430 + shift,
            "HINTS REVEALED: "
            + string(hint_level)
            + "/3"
        );
    }

    // INGREDIENTS BUTTON

    draw_set_color(light);
    draw_rectangle(
        1020,475 + shift,
        1220,500 + shift,
        false
    );

    draw_set_color(c_white);
    draw_text(
        1030,480 + shift,
        ingredients_open
        ? "INGREDIENTS [-]"
        : "INGREDIENTS [+]"
    );

    // REVEAL NEXT HINT BUTTON

    if (!known)
    {
        draw_set_color(
            hint_level < 3 ? purple : light
        );

        draw_rectangle(
            1235,475 + shift,
            1555,500 + shift,
            false
        );

        draw_set_color(c_white);
        draw_text(
            1260,480 + shift,
            hint_level < 3
            ? "REVEAL NEXT HINT"
            : "ALL HINTS REVEALED"
        );
    }

    // INGREDIENTS / HINTS

    if (ingredients_open)
    {
        if (known)
        {
            for (
                var ii = 0;
                ii < array_length(recipe.ingredients);
                ii++
            )
            {
                var ing = recipe.ingredients[ii];

                draw_set_color(muted);
                draw_text(
                    1020,505 + ii * 18 + shift,
                    string_upper(ing.group)
                    + " x"
                    + string(ing.amount)
                );
            }
        }
        else
        {
            // LEVEL 1

            draw_set_color(muted);
            draw_text(
                1020,505 + shift,
                hint_level >= 1
                ? "MATERIAL GROUPS: "
                    + string(hint.group_count)
                : "MATERIAL GROUPS: ???"
            );

            // LEVEL 2

            draw_set_color(
                hint_level >= 2 ? cyan : muted
            );

            draw_text(
                1020,523 + shift,
                hint_level >= 2
                ? "MATERIAL #1: " + hint.first_group
                : "MATERIAL #1: ???"
            );

            // LEVEL 3

            var second_hint = "MATERIAL #2: ???";

            if (hint_level >= 3)
            {
                second_hint = hint.has_second
                    ? "MATERIAL #2: " + hint.second_group
                    : "MATERIAL #2: NONE";
            }

            draw_set_color(
                hint_level >= 3 ? green : muted
            );

            draw_text(
                1250,523 + shift,
                second_hint
            );
        }
    }
    else if (!known)
    {
        draw_set_color(muted);
        draw_text(
            1020,515 + shift,
            "OPEN INGREDIENTS TO VIEW HINTS"
        );
    }

    // PREVIOUS / NEXT

    draw_set_color(light);
    draw_rectangle(
        1020,550 + shift,
        1130,586 + shift,
        false
    );
    draw_rectangle(
        1445,550 + shift,
        1555,586 + shift,
        false
    );

    draw_set_color(c_white);
    draw_text(
        1040,561 + shift,
        "< PREV"
    );
    draw_text(
        1465,561 + shift,
        "NEXT >"
    );

    // LOAD BASIC / PERFECT

    draw_set_color(
        known ? purple : light
    );

    draw_rectangle(
        1020,600 + shift,
        1275,638 + shift,
        false
    );
    draw_rectangle(
        1290,600 + shift,
        1555,638 + shift,
        false
    );

    draw_set_color(c_white);
    draw_text(
        1070,611 + shift,
        known ? "LOAD BASIC" : "LOCKED"
    );
    draw_text(
        1330,611 + shift,
        known ? "LOAD PERFECT" : "LOCKED"
    );
}

// ==========================================
// MODULE LIBRARY
// ==========================================

draw_set_color(panel);
draw_rectangle(
    1000,665 + shift,
    1575,810 + shift,
    false
);

draw_set_color(c_white);
draw_text(
    1010,675 + shift,
    "MODULE LIBRARY / GUIDE "
    + (module_guide_open ? "[-]" : "[+]")
);

// MODULE BUTTONS

for (var mi = 0; mi < 7; mi++)
{
    var px = 1010 + mi * 79;
    var py = 709 + shift;

    draw_set_color(
        selected_module == mi
        ? purple
        : light
    );

    draw_rectangle(
        px,py,
        px + 72,py + 39,
        false
    );

    draw_set_color(module_colors[mi]);
    draw_text(
        px + 28,py + 11,
        module_names[mi]
    );
}

// MODULE GUIDE CONTENT

if (module_guide_open)
{
    draw_set_color(muted);
    draw_text(
        1010,753 + shift,
        "B: BASE | C/M/Y: CATEGORY | F/R/D: BUFFS"
    );

    // Show actual V4.9 rates.

    draw_set_color(
        buffs.has_fail ? red : muted
    );

    draw_text(
        1010,775 + shift,
        "F: -" + string(buffs.fail_rate) + "%"
    );

    draw_set_color(
        buffs.has_back ? green : muted
    );

    draw_text(
        1135,775 + shift,
        "R: " + string(buffs.back_rate) + "%"
    );

    draw_set_color(
        buffs.has_find ? purple : muted
    );

    draw_text(
        1260,775 + shift,
        "D: " + string(buffs.find_rate) + "%"
    );

    draw_set_color(
        buffs.pattern_active ? yellow : muted
    );

    draw_text(
        1380,775 + shift,
        buffs.pattern_active
        ? "BONUS x1.25"
        : "NO BONUS"
    );
}
else
{
    draw_set_color(muted);
    draw_text(
        1010,766 + shift,
        "SELECT MODULE, THEN CLICK A GRID CELL"
    );
}

// ==========================================
// MODULE COMBINATION GUIDE
// ==========================================

var guide_y = 815 + shift;

draw_set_color(panel);
draw_rectangle(
    1000,guide_y,
    1575,guide_y + 80,
    false
);

// TITLE

draw_set_color(c_white);
draw_text(
    1010,guide_y + 6,
    "MODULE COMBINATION GUIDE"
);

// CATEGORY MATCH

draw_set_color(
    guide.valid ? green : red
);

draw_text(
    1010,guide_y + 25,
    guide.valid
    ? "VALID SHAPE"
    : "CLOSEST: " + guide.category_name
);

// MATCH COUNT

draw_set_color(muted);
draw_text(
    1300,guide_y + 25,
    string(guide.correct)
    + "/9 CELLS"
);

// PROGRESS BAR

draw_set_color(light);
draw_rectangle(
    1010,guide_y + 46,
    1555,guide_y + 54,
    false
);

draw_set_color(
    guide.valid ? green : yellow
);

draw_rectangle(
    1010,guide_y + 46,
    1010 + 545 * guide.match_percent / 100,
    guide_y + 54,
    false
);

// SUGGESTED CORRECTION

draw_set_color(muted);

if (guide.valid)
{
    draw_text(
        1010,guide_y + 60,
        "READY FOR MATERIAL ANALYSIS"
    );
}
else if (
    array_length(guide.recommendations) > 0
)
{
    draw_text(
        1010,guide_y + 60,
        "TRY: "
        + guide.recommendations[0].message
    );
}
else
{
    draw_text(
        1010,guide_y + 60,
        guide.message
    );
}

// ==========================================
// DRAG PREVIEW
// ==========================================

if (drag_active && mouse_check_button(mb_left))
{
    var mouse_gui_x =
        device_mouse_x_to_gui(0);

    var mouse_gui_y =
        device_mouse_y_to_gui(0);

    var start_screen_y =
        drag_start_y + ui_shift_y;

    if (
        abs(mouse_gui_x - drag_start_x) > 8
        || abs(mouse_gui_y - start_screen_y) > 8
    )
    {
        draw_set_alpha(0.85);
        draw_set_color(purple);

        draw_rectangle(
            mouse_gui_x + 12,
            mouse_gui_y + 12,
            mouse_gui_x + 150,
            mouse_gui_y + 45,
            false
        );

        draw_set_color(c_white);
        draw_text(
            mouse_gui_x + 20,
            mouse_gui_y + 22,
            groups[drag_group]
            + "_"
            + string(drag_variant)
            + " +10"
        );

        draw_set_alpha(1);
    }
}

// ==========================================
// RESTORE DRAW STATE
// ==========================================

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
