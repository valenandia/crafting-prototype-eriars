/// scr_recipes

function get_recipes() {
    
    return [
        {
            id: "stone_token",
            name: "Stone Token",
            
            materials: [
                { tag: "stone", percentage: 100 }
            ]
        },

        {
            id: "pink_cloth",
            name: "Pink Cloth",
            
            materials: [
                { tag: "polyester", percentage: 60 },
                { tag: "cloth", percentage: 40 }
            ]
        },

        {
            id: "forest_glass",
            name: "Forest Glass",
            
            materials: [
                { tag: "tree", percentage: 40 },
                { tag: "glass", percentage: 35 },
                { tag: "stone", percentage: 25 }
            ]
        },

        {
            id: "jewel_lantern",
            name: "Jewel Lantern",
            
            materials: [
                { tag: "stone", percentage: 30 },
                { tag: "glass", percentage: 25 },
                { tag: "polyester", percentage: 20 },
                { tag: "tree", percentage: 15 },
                { tag: "jewels", percentage: 10 }
            ]
        },

        {
            id: "blood_relic",
            name: "Blood Relic",
            
            materials: [
                { tag: "stone", percentage: 25 },
                { tag: "glass", percentage: 20 },
                { tag: "jewels", percentage: 20 },
                { tag: "mushrooms", percentage: 20 },
                { tag: "blood", percentage: 15 }
            ]
        }
    ];
}