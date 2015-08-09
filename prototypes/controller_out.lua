 
 
 
data:extend(
{ 

	{
	  type = "constant-combinator",
	  name = "controller-out",
	  icon = "__ProgrammableControllers__/graphics/controller-out/icon.png",
	  flags = {"placeable-neutral", "player-creation"},
	  minable = {hardness = 0.2, mining_time = 0.5, result = "controller-out"},
	  max_health = 50,
	  corpse = "small-remnants",

	  collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
	  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},

	  item_slot_count = 15,

	  sprite =
	  {
	    filename = "__ProgrammableControllers__/graphics/controller-out/constanter.png",
	    x = 61,
	    width = 61,
	    height = 50,
	    shift = {0.078125, 0.15625},
	  },
	  circuit_wire_connection_point =
	  {
	    shadow =
	    {
	      red = {0.828125, 0.328125},
	      green = {0.828125, -0.078125},
	    },
	    wire =
	    {
	      red = {0.515625, -0.078125},
	      green = {0.515625, -0.484375},
	    }
	  },
	  circuit_wire_max_distance = 7.5
  }
,
  {
		type = "item",
		name = "controller-out",
		icon = "__ProgrammableControllers__/graphics/controller-out/icon.png",
		flags = {"goes-to-quickbar"},
		subgroup = "programmable-controllers-blocks",
		order = "a[input]",
		place_result = "controller-out",
		stack_size = 50
  },
  {
    type = "recipe",
    name = "controller-out",
    enabled=false,
    ingredients = {{"processing-unit",1},{"advanced-circuit", 1},{"copper-cable", 4},{"constant-combinator", 1}},
    result = "controller-out",
    result_count = 1
  }
})