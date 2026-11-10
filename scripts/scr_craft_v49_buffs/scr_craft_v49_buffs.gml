
/// scr_craft_v49_buffs
/// CRAFTING V4.9
///
/// Buff module system for unified 3x3 grid.
///
/// 0 = BASE
/// 1 = C
/// 2 = M
/// 3 = Y
/// 4 = FAIL
/// 5 = BACK
/// 6 = FIND
///
/// A buff occupies its own cell.
/// Multiple modules of the same type do not stack.
///
/// Buff pattern bonus: x1.25

function craft_v49_is_buff(_value)
{
    return _value >= 4 && _value <= 6;
}


/// Return true if at least one module of
/// the requested buff type exists.

function craft_v49_has_buff(_cells, _type)
{
    var target = _type + 4;

    for (var i = 0; i < array_length(_cells); i++)
    {
        if (_cells[i] == target)
            return true;
    }

    return false;
}


/// Count occupied buff cells.

function craft_v49_buff_count(_cells)
{
    var count_buffs = 0;

    for (var i = 0; i < array_length(_cells); i++)
    {
        if (craft_v49_is_buff(_cells[i]))
            count_buffs++;
    }

    return count_buffs;
}


/// Detect buff patterns.
///
/// A pattern is valid when all required cells
/// contain buff modules.
///
/// Other cells may contain BASE or C/M/Y.
///
/// This intentionally treats any F/R/D module
/// as a valid buff-pattern cell.
///
/// Supported patterns:
/// 1. Main diagonal: 0,4,8
/// 2. Anti-diagonal: 2,4,6
/// 3. Middle row: 3,4,5
/// 4. Middle column: 1,4,7
///
/// Important:
/// These patterns require the center cell
/// to contain a buff module.

function craft_v49_buff_pattern(_cells)
{
    if (array_length(_cells) != 9)
        return -1;

    var patterns = [
        [0,4,8],
        [2,4,6],
        [3,4,5],
        [1,4,7]
    ];

    for (var p = 0; p < array_length(patterns); p++)
    {
        var valid = true;

        for (var j = 0; j < 3; j++)
        {
            var index = patterns[p][j];

            if (!craft_v49_is_buff(_cells[index]))
            {
                valid = false;
                break;
            }
        }

        if (valid)
            return p;
    }

    return -1;
}


/// Buff pattern names.

function craft_v49_pattern_name(_pattern)
{
    switch (_pattern)
    {
        case 0: return "MAIN DIAGONAL";
        case 1: return "ANTI-DIAGONAL";
        case 2: return "MIDDLE ROW";
        case 3: return "MIDDLE COLUMN";
    }

    return "NO ACTIVE PATTERN";
}


/// Calculate one buff's effective value.
///
/// _type:
/// 0 = FAIL
/// 1 = BACK
/// 2 = FIND

function craft_v49_buff_rate(_cells, _type)
{
    if (!craft_v49_has_buff(_cells, _type))
        return 0;

    var base_rate = 0;

    switch (_type)
    {
        case 0: base_rate = 10; break;
        case 1: base_rate = 30; break;
        case 2: base_rate = 2; break;
        default: return 0;
    }

    if (craft_v49_buff_pattern(_cells) >= 0)
        base_rate *= 1.25;

    return base_rate;
}


/// Return a complete buff report.

function craft_v49_buff_report(_cells)
{
    var pattern = craft_v49_buff_pattern(_cells);

    return {
        pattern:pattern,
        pattern_name:craft_v49_pattern_name(pattern),
        pattern_active:pattern >= 0,
        multiplier:pattern >= 0 ? 1.25 : 1,

        total_buffs:craft_v49_buff_count(_cells),

        has_fail:craft_v49_has_buff(_cells, 0),
        has_back:craft_v49_has_buff(_cells, 1),
        has_find:craft_v49_has_buff(_cells, 2),

        fail_rate:craft_v49_buff_rate(_cells, 0),
        back_rate:craft_v49_buff_rate(_cells, 1),
        find_rate:craft_v49_buff_rate(_cells, 2)
    };
}
