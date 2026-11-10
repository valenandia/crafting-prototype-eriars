
/// scr_craft_v45 - NEW SCRIPT
/// Reads the 3x3 unified module grid.
/// Base and buffs are neutral for pattern recognition.
/// C/M/Y must match the required category pattern.
/// Any two of the three rows may contain the original 3x2 pattern.

function craft_v45_pattern_category(_cells)
{
    if (array_length(_cells) != 9)
        return -1;

    for (var category = 0; category < 6; category++)
    {
        var pattern = craft_v4_category_pattern(category);

        for (var omitted = 0; omitted < 3; omitted++)
        {
            var valid = true;
            var src_row = 0;

            for (var row = 0; row < 3; row++)
            {
                if (row == omitted)
                {
                    // Non-pattern row cannot contain C/M/Y.
                    for (var col = 0; col < 3; col++)
                    {
                        var v = _cells[row * 3 + col];

                        if (v >= 1 && v <= 3)
                            valid = false;
                    }

                    continue;
                }

                for (var col = 0; col < 3; col++)
                {
                    var required = pattern[src_row * 3 + col];
                    var actual = _cells[row * 3 + col];

                    if (required >= 0)
                    {
                        if (actual != required + 1)
                            valid = false;
                    }
                    else
                    {
                        // A wildcard may contain Base or a buff.
                        if (actual >= 1 && actual <= 3)
                            valid = false;
                    }
                }

                src_row++;
            }

            if (valid)
                return category;
        }
    }

    return -1;
}
