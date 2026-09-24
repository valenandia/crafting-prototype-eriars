/// scr_recipes

function create_recipes()
{
    return [

        // ==================================================
        // 1 TAG
        // ==================================================

        {
            id: "item_01",
            name: "Item 01",
            materials: [
                { tag: "stone", percentage: 100 }
            ]
        },

        {
            id: "item_02",
            name: "Item 02",
            materials: [
                { tag: "polyester", percentage: 100 }
            ]
        },

        {
            id: "item_03",
            name: "Item 03",
            materials: [
                { tag: "tree", percentage: 100 }
            ]
        },


        // ==================================================
        // 2 TAGS
        // ==================================================

        {
            id: "item_04",
            name: "Item 04",
            materials: [
                { tag: "stone", percentage: 70 },
                { tag: "tree", percentage: 30 }
            ]
        },

        {
            id: "item_05",
            name: "Item 05",
            materials: [
                { tag: "glass", percentage: 60 },
                { tag: "polyester", percentage: 40 }
            ]
        },

        {
            id: "item_06",
            name: "Item 06",
            materials: [
                { tag: "cloth", percentage: 75 },
                { tag: "tree", percentage: 25 }
            ]
        },

        {
            id: "item_07",
            name: "Item 07",
            materials: [
                { tag: "jewels", percentage: 35 },
                { tag: "glass", percentage: 65 }
            ]
        },


        // ==================================================
        // 3 TAGS
        // ==================================================

        {
            id: "item_08",
            name: "Item 08",
            materials: [
                { tag: "stone", percentage: 50 },
                { tag: "glass", percentage: 30 },
                { tag: "polyester", percentage: 20 }
            ]
        },

        {
            id: "item_09",
            name: "Item 09",
            materials: [
                { tag: "tree", percentage: 45 },
                { tag: "cloth", percentage: 35 },
                { tag: "stone", percentage: 20 }
            ]
        },

        {
            id: "item_10",
            name: "Item 10",
            materials: [
                { tag: "jewels", percentage: 20 },
                { tag: "glass", percentage: 50 },
                { tag: "stone", percentage: 30 }
            ]
        },

        {
            id: "item_11",
            name: "Item 11",
            materials: [
                { tag: "mushrooms", percentage: 15 },
                { tag: "tree", percentage: 55 },
                { tag: "cloth", percentage: 30 }
            ]
        },


        // ==================================================
        // 4 TAGS
        // ==================================================

        {
            id: "item_12",
            name: "Item 12",
            materials: [
                { tag: "stone", percentage: 40 },
                { tag: "glass", percentage: 25 },
                { tag: "polyester", percentage: 20 },
                { tag: "jewels", percentage: 15 }
            ]
        },

        {
            id: "item_13",
            name: "Item 13",
            materials: [
                { tag: "tree", percentage: 35 },
                { tag: "cloth", percentage: 30 },
                { tag: "stone", percentage: 25 },
                { tag: "glass", percentage: 10 }
            ]
        },

        {
            id: "item_14",
            name: "Item 14",
            materials: [
                { tag: "polyester", percentage: 40 },
                { tag: "cloth", percentage: 25 },
                { tag: "glass", percentage: 20 },
                { tag: "jewels", percentage: 15 }
            ]
        },

        {
            id: "item_15",
            name: "Item 15",
            materials: [
                { tag: "mushrooms", percentage: 10 },
                { tag: "tree", percentage: 40 },
                { tag: "stone", percentage: 30 },
                { tag: "cloth", percentage: 20 }
            ]
        },


        // ==================================================
        // 5 TAGS
        // ==================================================

        {
            id: "item_16",
            name: "Item 16",
            materials: [
                { tag: "stone", percentage: 35 },
                { tag: "tree", percentage: 25 },
                { tag: "cloth", percentage: 20 },
                { tag: "glass", percentage: 15 },
                { tag: "jewels", percentage: 5 }
            ]
        },

        {
            id: "item_17",
            name: "Item 17",
            materials: [
                { tag: "polyester", percentage: 30 },
                { tag: "glass", percentage: 25 },
                { tag: "cloth", percentage: 20 },
                { tag: "jewels", percentage: 15 },
                { tag: "stone", percentage: 10 }
            ]
        },

        {
            id: "item_18",
            name: "Item 18",
            materials: [
                { tag: "tree", percentage: 35 },
                { tag: "stone", percentage: 25 },
                { tag: "cloth", percentage: 20 },
                { tag: "mushrooms", percentage: 15 },
                { tag: "blood", percentage: 5 }
            ]
        },

        {
            id: "item_19",
            name: "Item 19",
            materials: [
                { tag: "glass", percentage: 30 },
                { tag: "polyester", percentage: 25 },
                { tag: "jewels", percentage: 20 },
                { tag: "stone", percentage: 15 },
                { tag: "blood", percentage: 10 }
            ]
        },

        {
            id: "item_20",
            name: "Item 20",
            materials: [
                { tag: "stone", percentage: 30 },
                { tag: "tree", percentage: 25 },
                { tag: "glass", percentage: 20 },
                { tag: "mushrooms", percentage: 15 },
                { tag: "blood", percentage: 10 }
            ]
        }

    ];
}
// =====================================================
// FINAL FAILURE CHANCE
//
// TAG = количество ингредиентов
//
// 1 ingredient = 1%
// 2 ingredients = 10%
// 3 ingredients = 20%
// 4 ingredients = 30%
// 5 ingredients = 40%
//
// Каждый изученный предмет = -2%
// =====================================================

function get_final_failure_chance(_tag_count, _discovered_count)
{
    // ---------------------------------------------
    // BASE FAILURE
    // ---------------------------------------------

    var failure = 1;

    switch (_tag_count)
    {
        case 1:
            failure = 1;
        break;

        case 2:
            failure = 10;
        break;

        case 3:
            failure = 20;
        break;

        case 4:
            failure = 30;
        break;

        case 5:
            failure = 40;
        break;

        default:
            failure = 40;
        break;
    }


    // ---------------------------------------------
    // KNOWLEDGE BONUS
    //
    // Каждый открытый предмет = -2%
    // ---------------------------------------------

    var knowledge_bonus =
        _discovered_count * 2;

    failure -= knowledge_bonus;


    // ---------------------------------------------
    // LIMIT
    // ---------------------------------------------

    failure =
        max(
            0,
            failure
        );


    return failure;
}
function create_concrete_recipes()
{
    // Каждая запись: [группа, номер вида, процент].
    // Порядок строк: item_01 ... item_20.
    var data = [
        [["stone", 1, 100]],
        [["polyester", 1, 100]],
        [["tree", 1, 100]],

        [["stone", 1, 70], ["tree", 2, 30]],
        [["glass", 1, 60], ["polyester", 2, 40]],
        [["cloth", 1, 75], ["tree", 2, 25]],
        [["jewels", 1, 35], ["glass", 2, 65]],

        [["stone", 1, 50], ["glass", 3, 30],
         ["polyester", 1, 20]],

        [["tree", 3, 45], ["cloth", 2, 35],
         ["stone", 1, 20]],

        [["jewels", 2, 20], ["glass", 1, 50],
         ["stone", 1, 30]],

        [["mushrooms", 1, 15], ["tree", 1, 55],
         ["cloth", 3, 30]],

        [["stone", 1, 40], ["glass", 2, 25],
         ["polyester", 2, 20], ["jewels", 3, 15]],

        [["tree", 2, 35], ["cloth", 1, 30],
         ["stone", 1, 25], ["glass", 3, 10]],

        [["polyester", 1, 40], ["cloth", 2, 25],
         ["glass", 1, 20], ["jewels", 4, 15]],

        [["mushrooms", 2, 10], ["tree", 3, 40],
         ["stone", 1, 30], ["cloth", 3, 20]],

        [["stone", 1, 35], ["tree", 1, 25],
         ["cloth", 1, 20], ["glass", 2, 15],
         ["jewels", 1, 5]],

        [["polyester", 2, 30], ["glass", 3, 25],
         ["cloth", 2, 20], ["jewels", 2, 15],
         ["stone", 1, 10]],

        [["tree", 2, 35], ["stone", 1, 25],
         ["cloth", 3, 20], ["mushrooms", 3, 15],
         ["blood", 1, 5]],

        [["glass", 1, 30], ["polyester", 1, 25],
         ["jewels", 3, 20], ["stone", 1, 15],
         ["blood", 2, 10]],

        [["stone", 1, 30], ["tree", 3, 25],
         ["glass", 2, 20], ["mushrooms", 4, 15],
         ["blood", 3, 10]]
    ];

    var result = [];

    for (var i = 0; i < array_length(data); i++)
    {
        var number = string(i + 1);

        if (i < 9)
        {
            number = "0" + number;
        }

        var ingredients = [];

        for (var j = 0; j < array_length(data[i]); j++)
        {
            var entry = data[i][j];

            var group = entry[0];
            var variant = entry[1];
            var percentage = entry[2];

            array_push(ingredients, {
                tag: group + "_" + string(variant),
                group: group,
                percentage: percentage
            });
        }

        array_push(result, {
            id: "item_" + number,
            name: "Item " + number,
            materials: ingredients
        });
    }

    return result;
}