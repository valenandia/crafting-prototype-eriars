/// scr_materials

function create_materials()
{
    return {

        stone : {
            id: "stone",
            name: "Stone",
            color: make_color_rgb(150, 150, 150),
            rarity: 35,
            source: "Drone / Trade"
        },

        polyester : {
            id: "polyester",
            name: "Polyester",
            color: make_color_rgb(255, 100, 180),
            rarity: 25,
            source: "Drone"
        },

        tree : {
            id: "tree",
            name: "Tree",
            color: make_color_rgb(80, 190, 90),
            rarity: 12,
            source: "Drone / Trade"
        },

        cloth : {
            id: "cloth",
            name: "Cloth",
            color: make_color_rgb(240, 210, 60),
            rarity: 10,
            source: "Drone / Trade"
        },

        glass : {
            id: "glass",
            name: "Glass",
            color: make_color_rgb(80, 210, 240),
            rarity: 9,
            source: "Drone / Trade"
        },

        jewels : {
            id: "jewels",
            name: "Jewels",
            color: make_color_rgb(60, 100, 255),
            rarity: 6,
            source: "Drone"
        },

        mushrooms : {
            id: "mushrooms",
            name: "Mushrooms",
            color: make_color_rgb(140, 90, 50),
            rarity: 2,
            source: "Quest"
        },

        blood : {
            id: "blood",
            name: "Blood",
            color: make_color_rgb(220, 40, 40),
            rarity: 1,
            source: "Quest"
        }
    };
}