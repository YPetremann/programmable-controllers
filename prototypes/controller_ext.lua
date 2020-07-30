local controller = require("prototypes.controller")
controller.add_device {
    type = "wall",
    mod = "programmable-controllers",
    name = "pc-ext",
    item_slot_count = 0,
    pictures = {
        single = controller.entity_frame(
            "__programmable-controllers__/graphics/entity/pc-ext.png", 0, 0),
        straight_vertical = controller.entity_frame(
            "__programmable-controllers__/graphics/entity/pc-ext.png", 0, 0),
        straight_horizontal = controller.entity_frame(
            "__programmable-controllers__/graphics/entity/pc-ext.png", 0, 0),
        corner_right_down = controller.entity_frame(
            "__programmable-controllers__/graphics/entity/pc-ext.png", 0, 0),
        corner_left_down = controller.entity_frame(
            "__programmable-controllers__/graphics/entity/pc-ext.png", 0, 0),
        t_up = controller.entity_frame(
            "__programmable-controllers__/graphics/entity/pc-ext.png", 0, 0),
        ending_right = controller.entity_frame(
            "__programmable-controllers__/graphics/entity/pc-ext.png", 0, 0),
        ending_left = controller.entity_frame(
            "__programmable-controllers__/graphics/entity/pc-ext.png", 0, 0)
    }
}

controller.add_item("pc-ext", "1-z",
                    "__programmable-controllers__/graphics/icons/pc-ext.png")
controller.add_recipe("pc-ext", {
    {"concrete", 1}, {"iron-plate", 1}, {"copper-cable", 8},
    {"advanced-circuit", 2}
})
controller.add_recipe_to_tech("pc-ext", "programmable-controllers")
