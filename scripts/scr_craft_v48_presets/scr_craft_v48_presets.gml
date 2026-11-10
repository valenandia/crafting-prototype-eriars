
/// scr_craft_v48_presets
/// CRAFTING V4.8 - RANDOM PRESETS V2
///
/// MODULE VALUES:
/// 0 = BASE
/// 1 = C
/// 2 = M
/// 3 = Y
/// 4 = FAIL
/// 5 = BACK
/// 6 = FIND
///
/// FEATURES:
/// - Random category layout
/// - Preserve compatible buffs
/// - Relocate displaced buffs
/// - Optionally add random buffs
/// - Validate generated category
///
/// Requires:
/// scr_craft_v4
/// scr_craft_v45

function craft_v48_is_buff(_value)
{
    return _value >= 4 && _value <= 6;
}


/// Build a valid 3x3 layout for a category.
///
/// _category: 0..5
/// _omitted_row: 0..2
///
/// The original category pattern is 3x2.
/// It occupies two rows of the unified grid.
/// The remaining row contains BASE cells.

function craft_v48_category_layout(_category, _omitted_row)
{
    var pattern = craft_v4_category_pattern(_category);
    var cells = array_create(9, 0);

    var source_row = 0;

    for (var row = 0; row < 3; row++)
    {
        if (row == _omitted_row)
            continue;

        for (var col = 0; col < 3; col++)
        {
            var old_value =
                pattern[source_row * 3 + col];

            var index = row * 3 + col;

            if (old_value >= 0)
                cells[index] = old_value + 1;
        }

        source_row++;
    }

    return cells;
}


/// Count existing buff modules.

function craft_v48_count_buffs(_cells)
{
    var buff_count = 0;

    for (var i = 0; i < array_length(_cells); i++)
    {
        if (craft_v48_is_buff(_cells[i]))
            buff_count++;
    }

    return buff_count;
}


/// Generate a valid category layout.
///
/// _old_cells:
///     Previous 3x3 module grid.
///
/// _category:
///     Selected category index.
///
/// _random_buffs:
///     true  = generate extra random buffs.
///     false = preserve existing buffs only.
///
/// Returns:
///     success
///     cells
///     category
///     omitted_row
///     preserved
///     moved
///     dropped
///     added
///     message

function craft_v48_generate(
    _old_cells,
    _category,
    _random_buffs
)
{
    var categories = craft_v4_categories();

    // -----------------------------------------
    // VALIDATE CATEGORY
    // -----------------------------------------

    if (_category < 0
    || _category >= array_length(categories))
    {
        return {
            success:false,
            cells:array_create(9, 0),
            category:-1,
            omitted_row:-1,
            preserved:0,
            moved:0,
            dropped:0,
            added:0,
            message:"INVALID CATEGORY"
        };
    }

    // -----------------------------------------
    // FIND BEST ROW PLACEMENT
    // -----------------------------------------
    //
    // Choose the omitted row that preserves
    // the largest number of existing buffs.
    //
    // Randomness only breaks close ties.
    // -----------------------------------------

    var best_row = 0;
    var best_score = -9999;
    var best_layout = array_create(9, 0);

    for (var omitted = 0; omitted < 3; omitted++)
    {
        var candidate =
            craft_v48_category_layout(
                _category,
                omitted
            );

        var layout_score = 0;

        for (var i = 0; i < 9; i++)
        {
            if (craft_v48_is_buff(_old_cells[i]))
            {
                if (candidate[i] == 0)
                {
                    layout_score += 10;
                }
                else
                {
                    layout_score -= 2;
                }
            }
        }

        // Small random tie breaker.

        layout_score += random(0.5);

        if (layout_score > best_score)
        {
            best_score = layout_score;
            best_row = omitted;
            best_layout = candidate;
        }
    }

    // -----------------------------------------
    // COPY CATEGORY MODULES
    // -----------------------------------------

    var result = array_create(9, 0);

    for (var i = 0; i < 9; i++)
    {
        result[i] = best_layout[i];
    }

    // -----------------------------------------
    // PRESERVE EXISTING BUFFS
    // -----------------------------------------

    var displaced = [];

    var preserved = 0;
    var moved = 0;
    var dropped = 0;
    var added = 0;

    for (var i = 0; i < 9; i++)
    {
        if (!craft_v48_is_buff(_old_cells[i]))
            continue;

        // Cell is free: keep buff in place.

        if (result[i] == 0)
        {
            result[i] = _old_cells[i];
            preserved++;
        }
        else
        {
            // Required C/M/Y module occupies
            // the previous buff position.

            array_push(displaced, _old_cells[i]);
        }
    }

    // -----------------------------------------
    // COLLECT FREE CELLS
    // -----------------------------------------

    var free_cells = [];

    for (var i = 0; i < 9; i++)
    {
        if (result[i] == 0)
            array_push(free_cells, i);
    }

    // -----------------------------------------
    // SHUFFLE FREE CELL POSITIONS
    // -----------------------------------------

    for (
        var i = array_length(free_cells) - 1;
        i > 0;
        i--
    )
    {
        var j = irandom(i);

        var temp = free_cells[i];
        free_cells[i] = free_cells[j];
        free_cells[j] = temp;
    }

    // -----------------------------------------
    // RELOCATE DISPLACED BUFFS
    // -----------------------------------------

    for (var i = 0; i < array_length(displaced); i++)
    {
        if (array_length(free_cells) > 0)
        {
            var free_index = free_cells[0];

            array_delete(free_cells, 0, 1);

            result[free_index] = displaced[i];

            moved++;
        }
        else
        {
            dropped++;
        }
    }

    // -----------------------------------------
    // OPTIONAL RANDOM BUFF GENERATION
    // -----------------------------------------
    //
    // Generate up to two extra buff modules.
    //
    // Leave at least one BASE cell free
    // whenever possible.
    // -----------------------------------------

    if (_random_buffs)
    {
        var free_count = array_length(free_cells);

        var maximum_extra = max(
            0,
            free_count - 1
        );

        var add_count = min(
            irandom_range(0, 2),
            maximum_extra
        );

        for (var i = 0; i < add_count; i++)
        {
            if (array_length(free_cells) <= 0)
                break;

            var free_index = free_cells[0];

            array_delete(free_cells, 0, 1);

            result[free_index] =
                irandom_range(4, 6);

            added++;
        }
    }

    // -----------------------------------------
    // VALIDATE RESULT
    // -----------------------------------------

    var detected_category =
        craft_v45_pattern_category(result);

    var is_valid =
        detected_category == _category;

    // -----------------------------------------
    // RETURN GENERATION RESULT
    // -----------------------------------------

    return {
        success:is_valid,

        cells:result,

        category:_category,

        omitted_row:best_row,

        preserved:preserved,

        moved:moved,

        dropped:dropped,

        added:added,

        message:is_valid
            ? "VALID RANDOM PRESET"
            : "PRESET VALIDATION FAILED"
    };
}
