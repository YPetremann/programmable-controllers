local config = require("config")
local controller = require("prototypes.controller")
controller.add_device {
    mod = "programmable-controllers",
    name = "pc-con",
    circuit_wire_connection_points = {
        {
            shadow = {red = {0.143, -0.5}, green = {0.35, -0.5}},
            wire = {red = {-0.07, -0.55}, green = {0.100, -0.55}}
        }, {
            shadow = {red = {0.143, -0.5}, green = {0.35, -0.5}},
            wire = {red = {-0.07, -0.55}, green = {0.100, -0.55}}
        }, {
            shadow = {red = {0.143, -0.5}, green = {0.35, -0.5}},
            wire = {red = {-0.07, -0.55}, green = {0.100, -0.55}}
        }, {
            shadow = {red = {0.143, -0.5}, green = {0.35, -0.5}},
            wire = {red = {-0.07, -0.55}, green = {0.100, -0.55}}
        }
    },
    circuit_wire_max_distance = 7.5
}

controller.add_item("pc-con", "1-d",
                    "__programmable-controllers__/graphics/icons/pc-con.png")
controller.add_recipe("pc-con", {{"constant-combinator", 1}, {"pc-ext", 1}})
controller.add_recipe_to_tech("pc-con", "programmable-controllers")
