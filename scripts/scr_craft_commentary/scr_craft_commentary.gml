/// scr_craft_commentary
/// CRAFTING V3.5 - FUNNY PROGRESS COMMENTARY

function craft_v3_commentary()
{
    var total = get_vessel_total();
    var recipe_index = get_current_recipe();

    var message = "";
    var detail = "";

    var tone = 0;
    // 0 = neutral
    // 1 = warning
    // 2 = success
    // 3 = legendary

    // =================================================
    // RESULT COMMENTS - HIGHEST PRIORITY
    // =================================================

    if (craft_result == 1)
    {
        if (last_quality >= 90)
        {
            message = "LEGENDARY?! Who let you cook?!";
            tone = 3;
        }
        else if (last_quality >= 70)
        {
            message = "Ooh, fancy! Someone's feeling talented.";
            tone = 2;
        }
        else
        {
            message = "Go again, you absolute goofball!";
            tone = 2;
        }

        detail =
            "CRAFT SUCCESS / Q" + string(last_quality) +
            " / " + craft_v3_rarity_name(last_quality);

        return {
            message: message,
            detail: detail,
            tone: tone
        };
    }

    if (craft_result == 2)
    {
        return {
            message: "Didn't work out, bro. :(",
            detail:
                "CRAFT FAILED / " +
                string(last_failure) + "% failure chance",
            tone: 1
        };
    }

    // =================================================
    // EMPTY VESSEL
    // =================================================

    if (total <= 0)
    {
        var empty_comments = [
            "The cauldron is emptier than my wallet.",
            "I'm doing my Gacha dailies while you stare.",
            "Hello? The materials won't mix themselves.",
            "Zero ingredients. Infinite disappointment."
        ];

        var empty_index =
            floor(current_time / 8000)
            mod array_length(empty_comments);

        return {
            message: empty_comments[empty_index],
            detail: "VESSEL EMPTY / 0 OF 100 UNITS",
            tone: 0
        };
    }

    // =================================================
    // PARTIAL FILLING
    // =================================================

    if (total < 100)
    {
        if (total <= 30)
        {
            message = "A little more. This isn't a cooking show.";
        }
        else if (total <= 60)
        {
            message = "We're cooking. Legally? That's debatable.";
        }
        else if (total <= 90)
        {
            message = "Something is bubbling. Should I worry?";
        }
        else
        {
            message = "Almost there. Don't ruin it now.";
        }

        var stack_count = array_length(vessel_stacks);

        detail =
            "MIXING: " + string(total) + "/100" +
            " / " + string(stack_count) + " VARIANT STACKS";

        return {
            message: message,
            detail: detail,
            tone: 0
        };
    }

    // =================================================
    // FULL VESSEL - UNKNOWN RECIPE
    // =================================================

    if (recipe_index == -1)
    {
        return {
            message: "What the hell is this crap?!",
            detail: "100/100 / UNKNOWN COMBINATION",
            tone: 1
        };
    }

    // =================================================
    // FULL VESSEL - VALID RECIPE
    // =================================================

    var quality = get_quality();
    var failure = get_failure();

    if (failure >= 50)
    {
        message = "This has disaster written all over it.";
        tone = 1;
    }
    else if (quality >= 90)
    {
        message = "This looks illegally good.";
        tone = 3;
    }
    else if (quality >= 70)
    {
        message = "Ooh, fancy! Someone's feeling talented.";
        tone = 2;
    }
    else if (quality >= 50)
    {
        message = "Wait... you actually made something?!";
        tone = 2;
    }
    else
    {
        message = "Well, look at the mess you've made!";
        tone = 0;
    }

    detail =
        "READY / Q" + string(quality) +
        " / FAIL " + string(failure) + "%";

    // =================================================
    // BUFF GEOMETRY COMMENT
    // =================================================

    if (get_buff_shape() != -1)
    {
        if (failure < 50 && quality < 90)
        {
            message =
                "The stars aligned. Suspiciously convenient.";
        }

        detail += " / BUFF SHAPE ACTIVE";
    }

    return {
        message: message,
        detail: detail,
        tone: tone
    };
}