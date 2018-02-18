data:extend({
	{
		type = "constant-combinator",
		name = "controller-con",
		icon = "__programmable-controllers__/graphics/icons/controller-con.png",
		icon_size = 32,
		flags = {"placeable-neutral", "player-creation"},
		fast_replaceable_group = "controller",
		minable = {hardness = 0.2, mining_time = 0.5, result = "controller-con"},
		max_health = 50,
		corpse = "small-remnants",
		collision_box = {{-0.3, -0.3}, {0.3, 0.3}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		item_slot_count = 16,
		sprites = {
			north = {
				filename = "__programmable-controllers__/graphics/entity/controller-con.png",
				width = 64,	height = 64,
				shift = {0, 0}
			},
			east = {
				filename = "__programmable-controllers__/graphics/entity/controller-con.png",
				width = 64,	height = 64,
				shift = {0, 0}
			},
			south = {
				filename = "__programmable-controllers__/graphics/entity/controller-con.png",
				width = 64,	height = 64,
				shift = {0, 0}
			},
			west = {
				filename = "__programmable-controllers__/graphics/entity/controller-con.png",
				width = 64,	height = 64,
				shift = {0, 0}
			}
		},
		activity_led_sprites = {
			north = {filename = "__programmable-controllers__/graphics/null.png", width = 1, height = 1, frame_count = 1, shift = {0,0}},
			east = {filename = "__programmable-controllers__/graphics/null.png", width = 1, height = 1, frame_count = 1, shift = {0,0}},
			south = {filename = "__programmable-controllers__/graphics/null.png", width = 1, height = 1, frame_count = 1, shift = {0,0}},
			west = {filename = "__programmable-controllers__/graphics/null.png", width = 1, height = 1, frame_count = 1, shift = {0,0}}
		},
		activity_led_light = {
			intensity = 0.8,
			size = 1,
		},
		activity_led_light_offsets = {
			{0.296875, -0.40625},
			{0.25, -0.03125},
			{-0.296875, -0.078125},
			{-0.21875, -0.46875}
		},
		circuit_wire_connection_points = {
			{
				shadow = {red = {0.143, -0.25},green = {0.35, -0.25}},
				wire   = {red = {-0.07, -0.4},green = {0.1, -0.4}}
			}, {
				shadow = {red = {0.35, -0.25},green = {0.143, -0.25}},
				wire   = {red = {0.1, -0.4},green = {-0.07, -0.4}}
			}, {
				shadow = {red = {0.143, -0.25},green = {0.35, -0.25}},
				wire   = {red = {-0.07, -0.4},green = {0.1, -0.4}}
			}, {
				shadow = {red = {0.35, -0.25},green = {0.143, -0.25}},
				wire   = {red = {0.1, -0.4},green = {-0.07, -0.4}}
			}
		},
		circuit_wire_max_distance = 7.5
	}, {
		type = "item",
		name = "controller-con",
		icon = "__programmable-controllers__/graphics/icons/controller-con.png",
		icon_size = 32,
		flags = {"goes-to-quickbar"},
		subgroup = "pc-blocks",
		order = "a-d",
		place_result = "controller-con",
		stack_size = 50
	}, {
		type = "recipe",
		name = "controller-con",
		enabled=false,
		ingredients = {{"constant-combinator", 1},{"advanced-circuit", 2},{"controller-ext", 1}},
		result = "controller-con",
		result_count = 1
	}
})
table.insert(data.raw.technology["advanced-electronics-2"].effects, {type = "unlock-recipe", recipe = "controller-con"})
