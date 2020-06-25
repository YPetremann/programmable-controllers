local config = require("config")
local controller = require("prototypes.controller")
controller.add_device {mod = "programmable-controllers", name = "pc-mem"}

controller.add_item("pc-mem", "1-c", "__programmable-controllers__/graphics/icons/pc-mem.png")
controller.add_recipe("pc-mem", {{"constant-combinator", 1}, {"decider-combinator", 1}, {"pc-ext", 1}})
controller.add_recipe_to_tech("pc-mem", "advanced-electronics")
