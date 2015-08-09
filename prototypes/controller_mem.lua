 
 
data:extend(
{ 
 {
    type = "lamp",
    name = "controller-mem",
    icon = "__ProgrammableControllers__/graphics/controller-mem/icon.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "controller-mem"},
    max_health = 55,
    corpse = "small-remnants",
    collision_box = {{-0.15, -0.15}, {0.15, 0.15}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input"
    },
    energy_usage_per_tick = "5KW",
    light = {intensity = 0.9, size = 40},
    picture_off =
    {
      filename = "__ProgrammableControllers__/graphics/controller-mem/light-off.png",
      priority = "high",
      width = 67,
      height = 58,
      frame_count = 1,
      axially_symmetrical = false,
      direction_count = 1,
      shift = {0.078125, -0.03125},
    },
    picture_on =
    {
      filename = "__ProgrammableControllers__/graphics/null.png",
      priority = "high",
      width = 1,
      height = 1,
      frame_count = 1,
      axially_symmetrical = false,
      direction_count = 1,
      shift = {0.0625, -0.21875},
    },

    circuit_wire_connection_point =
    {
      shadow =
      {
        red = {0.859375, -0.296875},
        green = {0.859375, -0.296875},
      },
      wire =
      {
        red = {0.40625, -0.59375},
        green = {0.40625, -0.59375},
      }
    },

    circuit_wire_max_distance = 7.5
  },
  {
		type = "item",
		name = "controller-mem",
		icon = "__ProgrammableControllers__/graphics/controller-mem/icon.png",
		flags = {"goes-to-quickbar"},
		subgroup = "programmable-controllers-blocks",
		order = "a[input]",
		place_result = "controller-mem",
		stack_size = 50
  },
  {
    type = "recipe",
    name = "controller-mem",
    enabled=false,
    ingredients = {{"processing-unit",1},{"advanced-circuit", 8},{"copper-cable",8}},
    result = "controller-mem",
    result_count = 1
  }
})