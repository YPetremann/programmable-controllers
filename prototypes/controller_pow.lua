local controller = require("prototypes.controller")
controller.add_device {
   mod = "programmable-controllers",
   type = "electric-energy-interface",
   name = "pc-pow",
   picture = controller.entity_frame("__programmable-controllers__/graphics/entity/pc-pow.png", 0, 0),
   energy_source = {
      type = "electric",
      buffer_capacity = "1MJ",
      usage_priority = "secondary-input",
      input_flow_limit = "150kW",
      output_flow_limit = "0kW",
   },
   energy_production = "0kW",
   energy_usage = "0kW",
   energy_usage_per_tick = "10KW",
}

controller.add_item("pc-pow", "1-a", "__programmable-controllers__/graphics/icons/pc-pow.png")
controller.add_recipe("pc-pow", {{"battery", 2}, {"copper-cable", 8}, {"pc-ext", 1}})
controller.add_recipe_to_tech("pc-pow", "advanced-electronics")
