
/// scr_craft_v47_guide
/// CRAFTING V4.7
///
/// Module Combination Guide
///
/// Unified 3x3 module values:
/// 0 = BASE
/// 1 = C
/// 2 = M
/// 3 = Y
/// 4 = FAIL
/// 5 = BACK
/// 6 = FIND
///
/// Uses existing V4 category patterns.
/// Does not change module placement or crafting rules.

function craft_v47_module_name(_module)
{
    switch (_module)
    {
        case 0: return "BASE";
        case 1: return "C";
        case 2: return "M";
        case 3: return "Y";
        case 4: return "FAIL";
        case 5: return "BACK";
        case 6: return "FIND";
    }

    return "UNKNOWN";
}


/// Builds a 3x3 target from a 3x2 category pattern.
///
/// _omitted_row = 0, 1 or 2
///
/// -1 represents a wildcard slot.
/// A wildcard can contain BASE or a buff.

function craft_v47_build_target(_category, _omitted_row)
{
    var source = craft_v4_category_pattern(_category);
    var target = array_create(9, -1);

    var source_row = 0;

    for (var row = 0; row < 3; row++)
    {
        if (row == _omitted_row)
            continue;

        for (var col = 0; col < 3; col++)
        {
            var source_value =
                source[source_row * 3 + col];

            var index = row * 3 + col;

            if (source_value >= 0)
            {
                // Old C/M/Y values: 0,1,2
                // New C/M/Y values: 1,2,3

                target[index] = source_value + 1;
            }
            else
            {
                target[index] = -1;
            }
        }

        source_row++;
    }

    return target;
}


/// Returns whether a module is valid for
/// one target cell.

function craft_v47_cell_matches(_actual, _expected)
{
    if (_expected == -1)
    {
        // BASE and buff modules are neutral.

        return (
            _actual == 0
            || _actual == 4
            || _actual == 5
            || _actual == 6
        );
    }

    return _actual == _expected;
}


/// Evaluate a category and an omitted row.

function craft_v47_evaluate_layout(
    _cells,
    _category,
    _omitted_row
)
{
    var target = craft_v47_build_target(
        _category,
        _omitted_row
    );

    var correct = 0;
    var errors = 0;

    var cell_status = array_create(9, 0);
    var recommendations = [];

    for (var i = 0; i < 9; i++)
    {
        var actual = _cells[i];
        var expected = target[i];

        if (craft_v47_cell_matches(actual, expected))
        {
            cell_status[i] = 1;
            correct++;
        }
        else
        {
            cell_status[i] = -1;
            errors++;

            var replacement = expected;

            // For wildcard slots, recommend BASE.
            // Existing buffs in valid wildcard slots
            // are never marked as errors.

            if (replacement == -1)
                replacement = 0;

            var row = (i div 3) + 1;
            var col = (i mod 3) + 1;

            array_push(recommendations, {
                index:i,
                row:row,
                col:col,
                actual:actual,
                expected:expected,
                replacement:replacement,
                message:
                    "R" + string(row)
                    + " C" + string(col)
                    + ": "
                    + craft_v47_module_name(actual)
                    + " -> "
                    + craft_v47_module_name(replacement)
            });
        }
    }

    return {
        category:_category,
        omitted_row:_omitted_row,
        correct:correct,
        errors:errors,
        valid:errors == 0,
        target:target,
        cell_status:cell_status,
        recommendations:recommendations
    };
}


/// Find the closest valid category layout.
///
/// Checks all six categories and all three
/// possible omitted rows.
///
/// When several layouts are equally close,
/// the first one in category order is used.
/// This is a recommendation, not a guarantee
/// that the player intended that category.

function craft_v47_analyze(_cells)
{
    if (array_length(_cells) != 9)
    {
        return {
            valid:false,
            category:-1,
            category_name:"UNKNOWN",
            correct:0,
            errors:9,
            match_percent:0,
            omitted_row:-1,
            cell_status:array_create(9, -1),
            recommendations:[],
            message:"INVALID GRID SIZE"
        };
    }

    var categories = craft_v4_categories();

    var best = undefined;
    var best_errors = 999;

    for (var category = 0;
         category < array_length(categories);
         category++)
    {
        for (var omitted = 0; omitted < 3; omitted++)
        {
            var result = craft_v47_evaluate_layout(
                _cells,
                category,
                omitted
            );

            if (result.errors < best_errors)
            {
                best = result;
                best_errors = result.errors;
            }
        }
    }

    if (is_undefined(best))
    {
        return {
            valid:false,
            category:-1,
            category_name:"UNKNOWN",
            correct:0,
            errors:9,
            match_percent:0,
            omitted_row:-1,
            cell_status:array_create(9, -1),
            recommendations:[],
            message:"NO CATEGORY PATTERNS"
        };
    }

    var detected =
        craft_v45_pattern_category(_cells);

    var is_valid = detected >= 0;

    // Use the real detected category when valid.
    // This keeps the guide consistent with crafting.

    if (is_valid && best.category != detected)
    {
        for (var omitted = 0; omitted < 3; omitted++)
        {
            var exact = craft_v47_evaluate_layout(
                _cells,
                detected,
                omitted
            );

            if (exact.valid)
            {
                best = exact;
                break;
            }
        }
    }

    var category_name = categories[best.category];

    var message = "";

    if (is_valid)
    {
        message = "VALID " + category_name + " SHAPE";
    }
    else
    {
        message =
            string(best.errors)
            + " CELL(S) NEED CORRECTION";
    }

    return {
        valid:is_valid,
        category:best.category,
        category_name:category_name,
        correct:best.correct,
        errors:best.errors,
        match_percent:round(best.correct / 9 * 100),
        omitted_row:best.omitted_row,
        cell_status:best.cell_status,
        recommendations:best.recommendations,
        message:message
    };
}
