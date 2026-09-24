/// scr_recipes

// =====================================================
// RECIPES
//
// tag   = конкретный вариант для CRAFT MINI-GAME
// group = общий ресурс для ECONOMY / MATERIAL POOL
//
// Пример:
// tag:   "tree_3"  -> какой именно ресурс нужен в рецепте
// group: "tree"    -> из какого общего запаса он берётся
// =====================================================

function create_recipes()
{
    return [

        // ==================================================
        // 1 INGREDIENT
        // ==================================================

        {
            id: "item_01",
            name: "Item 01",
            materials: [
                {
                    tag: "stone_1",
                    group: "stone",
                    percentage: 100
                }
            ]
        },

        {
            id: "item_02",
            name: "Item 02",
            materials: [
                {
                    tag: "polyester_1",
                    group: "polyester",
                    percentage: 100
                }
            ]
        },

        {
            id: "item_03",
            name: "Item 03",
            materials: [
                {
                    tag: "tree_1",
                    group: "tree",
                    percentage: 100
                }
            ]
        },


        // ==================================================
        // 2 INGREDIENTS
        // ==================================================

        {
            id: "item_04",
            name: "Item 04",
            materials: [
                {
                    tag: "stone_1",
                    group: "stone",
                    percentage: 70
                },
                {
                    tag: "tree_2",
                    group: "tree",
                    percentage: 30
                }
            ]
        },

        {
            id: "item_05",
            name: "Item 05",
            materials: [
                {
                    tag: "glass_1",
                    group: "glass",
                    percentage: 60
                },
                {
                    tag: "polyester_2",
                    group: "polyester",
                    percentage: 40
                }
            ]
        },

        {
            id: "item_06",
            name: "Item 06",
            materials: [
                {
                    tag: "cloth_1",
                    group: "cloth",
                    percentage: 75
                },
                {
                    tag: "tree_2",
                    group: "tree",
                    percentage: 25
                }
            ]
        },

        {
            id: "item_07",
            name: "Item 07",
            materials: [
                {
                    tag: "jewels_1",
                    group: "jewels",
                    percentage: 35
                },
                {
                    tag: "glass_2",
                    group: "glass",
                    percentage: 65
                }
            ]
        },


        // ==================================================
        // 3 INGREDIENTS
        // ==================================================

        {
            id: "item_08",
            name: "Item 08",
            materials: [
                {
                    tag: "stone_1",
                    group: "stone",
                    percentage: 50
                },
                {
                    tag: "glass_3",
                    group: "glass",
                    percentage: 30
                },
                {
                    tag: "polyester_1",
                    group: "polyester",
                    percentage: 20
                }
            ]
        },

        {
            id: "item_09",
            name: "Item 09",
            materials: [
                {
                    tag: "tree_3",
                    group: "tree",
                    percentage: 45
                },
                {
                    tag: "cloth_2",
                    group: "cloth",
                    percentage: 35
                },
                {
                    tag: "stone_1",
                    group: "stone",
                    percentage: 20
                }
            ]
        },

        {
            id: "item_10",
            name: "Item 10",
            materials: [
                {
                    tag: "jewels_2",
                    group: "jewels",
                    percentage: 20
                },
                {
                    tag: "glass_1",
                    group: "glass",
                    percentage: 50
                },
                {
                    tag: "stone_1",
                    group: "stone",
                    percentage: 30
                }
            ]
        },

        {
            id: "item_11",
            name: "Item 11",
            materials: [
                {
                    tag: "mushrooms_1",
                    group: "mushrooms",
                    percentage: 15
                },
                {
                    tag: "tree_1",
                    group: "tree",
                    percentage: 55
                },
                {
                    tag: "cloth_3",
                    group: "cloth",
                    percentage: 30
                }
            ]
        },


        // ==================================================
        // 4 INGREDIENTS
        // ==================================================

        {
            id: "item_12",
            name: "Item 12",
            materials: [
                {
                    tag: "stone_1",
                    group: "stone",
                    percentage: 40
                },
                {
                    tag: "glass_2",
                    group: "glass",
                    percentage: 25
                },
                {
                    tag: "polyester_2",
                    group: "polyester",
                    percentage: 20
                },
                {
                    tag: "jewels_3",
                    group: "jewels",
                    percentage: 15
                }
            ]
        },

        {
            id: "item_13",
            name: "Item 13",
            materials: [
                {
                    tag: "tree_2",
                    group: "tree",
                    percentage: 35
                },
                {
                    tag: "cloth_1",
                    group: "cloth",
                    percentage: 30
                },
                {
                    tag: "stone_1",
                    group: "stone",
                    percentage: 25
                },
                {
                    tag: "glass_3",
                    group: "glass",
                    percentage: 10
                }
            ]
        },

        {
            id: "item_14",
            name: "Item 14",
            materials: [
                {
                    tag: "polyester_1",
                    group: "polyester",
                    percentage: 40
                },
                {
                    tag: "cloth_2",
                    group: "cloth",
                    percentage: 25
                },
                {
                    tag: "glass_1",
                    group: "glass",
                    percentage: 20
                },
                {
                    tag: "jewels_4",
                    group: "jewels",
                    percentage: 15
                }
            ]
        },

        {
            id: "item_15",
            name: "Item 15",
            materials: [
                {
                    tag: "mushrooms_2",
                    group: "mushrooms",
                    percentage: 10
                },
                {
                    tag: "tree_3",
                    group: "tree",
                    percentage: 40
                },
                {
                    tag: "stone_1",
                    group: "stone",
                    percentage: 30
                },
                {
                    tag: "cloth_3",
                    group: "cloth",
                    percentage: 20
                }
            ]
        },


        // ==================================================
        // 5 INGREDIENTS
        // ==================================================

        {
            id: "item_16",
            name: "Item 16",
            materials: [
                {
                    tag: "stone_1",
                    group: "stone",
                    percentage: 35
                },
                {
                    tag: "tree_1",
                    group: "tree",
                    percentage: 25
                },
                {
                    tag: "cloth_1",
                    group: "cloth",
                    percentage: 20
                },
                {
                    tag: "glass_2",
                    group: "glass",
                    percentage: 15
                },
                {
                    tag: "jewels_1",
                    group: "jewels",
                    percentage: 5
                }
            ]
        },

        {
            id: "item_17",
            name: "Item 17",
            materials: [
                {
                    tag: "polyester_2",
                    group: "polyester",
                    percentage: 30
                },
                {
                    tag: "glass_3",
                    group: "glass",
                    percentage: 25
                },
                {
                    tag: "cloth_2",
                    group: "cloth",
                    percentage: 20
                },
                {
                    tag: "jewels_2",
                    group: "jewels",
                    percentage: 15
                },
                {
                    tag: "stone_1",
                    group: "stone",
                    percentage: 10
                }
            ]
        },

        {
            id: "item_18",
            name: "Item 18",
            materials: [
                {
                    tag: "tree_2",
                    group: "tree",
                    percentage: 35
                },
                {
                    tag: "stone_1",
                    group: "stone",
                    percentage: 25
                },
                {
                    tag: "cloth_3",
                    group: "cloth",
                    percentage: 20
                },
                {
                    tag: "mushrooms_3",
                    group: "mushrooms",
                    percentage: 15
                },
                {
                    tag: "blood_1",
                    group: "blood",
                    percentage: 5
                }
            ]
        },

        {
            id: "item_19",
            name: "Item 19",
            materials: [
                {
                    tag: "glass_1",
                    group: "glass",
                    percentage: 30
                },
                {
                    tag: "polyester_1",
                    group: "polyester",
                    percentage: 25
                },
                {
                    tag: "jewels_3",
                    group: "jewels",
                    percentage: 20
                },
                {
                    tag: "stone_1",
                    group: "stone",
                    percentage: 15
                },
                {
                    tag: "blood_2",
                    group: "blood",
                    percentage: 10
                }
            ]
        },

        {
            id: "item_20",
            name: "Item 20",
            materials: [
                {
                    tag: "stone_1",
                    group: "stone",
                    percentage: 30
                },
                {
                    tag: "tree_3",
                    group: "tree",
                    percentage: 25
                },
                {
                    tag: "glass_2",
                    group: "glass",
                    percentage: 20
                },
                {
                    tag: "mushrooms_4",
                    group: "mushrooms",
                    percentage: 15
                },
                {
                    tag: "blood_3",
                    group: "blood",
                    percentage: 10
                }
            ]
        }
    ];
}


// =====================================================
// FAILURE
// =====================================================
//
// 1 ingredient = 1%
// 2 ingredients = 10%
// 3 ingredients = 20%
// 4 ingredients = 30%
// 5 ingredients = 40%
//
// Каждый открытый рецепт = -2 percentage points.
//
// ВАЖНО:
// Market Event и MODUL_BUFF здесь НЕ считаем.
// Они добавляются позже в mini-game,
// чтобы не считать один эффект дважды.
// =====================================================

function get_final_failure_chance(
    _ingredient_count,
    _discovered_count
)
{
    var failure = 40;

    switch (_ingredient_count)
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
    }

    // Knowledge bonus
    failure -= _discovered_count * 2;

    return max(0, failure);
}