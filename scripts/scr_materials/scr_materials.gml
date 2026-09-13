/// scr_materials

function get_material_data() {
    return {
        stone: {
            name: "Stone",
            color: make_color_rgb(120, 120, 120),
            rarity: 35,
            sources: "Drone / Trade"
        },

        polyester: {
            name: "Polyester",
            color: make_color_rgb(255, 120, 180),
            rarity: 25,
            sources: "Drone"
        },

        tree: {
            name: "Tree",
            color: make_color_rgb(80, 180, 80),
            rarity: 12,
            sources: "Drone / Trade"
        },

        cloth: {
            name: "Cloth",
            color: make_color_rgb(240, 220, 70),
            rarity: 10,
            sources: "Drone / Trade"
        },

        glass: {
            name: "Glass",
            color: make_color_rgb(80, 190, 230),
            rarity: 9,
            sources: "Drone / Trade"
        },

        jewels: {
            name: "Jewels",
            color: make_color_rgb(70, 100, 230),
            rarity: 6,
            sources: "Drone"
        },

        mushrooms: {
            name: "Mushrooms",
            color: make_color_rgb(130, 80, 50),
            rarity: 2,
            sources: "Quest"
        },

        blood: {
            name: "Blood",
            color: make_color_rgb(220, 50, 50),
            rarity: 1,
            sources: "Quest"
        }
    };
}