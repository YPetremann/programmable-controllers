local config = require("config")
local controller = require("prototypes.controller")
controller.add_device {mod = "programmable-controllers", name = "pc-cpu"}

controller.add_item("pc-cpu", "1-b",
                    "__programmable-controllers__/graphics/icons/pc-cpu.png")
-- generic.add_recipe("pc-cpu", {{"processing-unit",1}, {"arithmetic-combinator", 1}, {"decider-combinator", 1}, {"pc-ext",1}})
controller.add_recipe("pc-cpu", {
    {"advanced-circuit", 1}, {"arithmetic-combinator", 1},
    {"decider-combinator", 1}, {"pc-ext", 1}
})
controller.add_recipe_to_tech("pc-cpu", "programmable-controllers")
