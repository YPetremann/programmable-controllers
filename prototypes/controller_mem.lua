data:extend({
	{
		type = "constant-combinator",
		name = "controller-mem",
		icon = "__programmable-controllers__/graphics/icons/controller-mem.png",
		icon_size = 32,
		flags = {"placeable-neutral", "player-creation"},
		fast_replaceable_group = "controller",
		minable = {hardness = 0.2, mining_time = 0.5, result = "controller-mem"},
		max_health = 55,
		corpse = "small-remnants",
		collision_box = {{-0.3, -0.3}, {0.3, 0.3}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		item_slot_count = 16,
		sprites = {
			north = {
				filename = "__programmable-controllers__/graphics/entity/controller-mem.png",
				priority = "high",
				width = 64,	height = 64,
				shift = {0, 0},
				frame_count = 1,
				axially_symmetrical = false,
				direction_count = 1,
			},
			east = {
				filename = "__programmable-controllers__/graphics/entity/controller-mem.png",
				priority = "high",
				width = 64,	height = 64,
				shift = {0, 0},
				frame_count = 1,
				axially_symmetrical = false,
				direction_count = 1,
			},
			south = {
				filename = "__programmable-controllers__/graphics/entity/controller-mem.png",
				priority = "high",
				width = 64,	height = 64,
				shift = {0, 0},
				frame_count = 1,
				axially_symmetrical = false,
				direction_count = 1,
			},
			west = {
				filename = "__programmable-controllers__/graphics/entity/controller-mem.png",
				priority = "high",
				width = 64,	height = 64,
				shift = {0, 0},
				frame_count = 1,
				axially_symmetrical = false,
				direction_count = 1,
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
				shadow = {
					red = {0.859375, -0.296875},
					green = {0.859375, -0.296875},
				},
				wire = {
					red = {0.40625, -0.59375},
					green = {0.40625, -0.59375},
				}
			}, {
				shadow = {
					red = {0.859375, -0.296875},
					green = {0.859375, -0.296875},
				},
				wire = {
					red = {0.40625, -0.59375},
					green = {0.40625, -0.59375},
				}
			}, {
				shadow = {
					red = {0.859375, -0.296875},
					green = {0.859375, -0.296875},
				},
				wire = {
					red = {0.40625, -0.59375},
					green = {0.40625, -0.59375},
				}
			}, {
				shadow = {
					red = {0.859375, -0.296875},
					green = {0.859375, -0.296875},
				},
				wire = {
					red = {0.40625, -0.59375},
					green = {0.40625, -0.59375},
				}
			}
		},
		circuit_wire_max_distance = 0,
		vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		energy_source = {
			type = "electric",
			usage_priority = "secondary-input"
		},
		energy_usage_per_tick = "5KW",
	},
	{
		type = "item",
		name = "controller-mem",
		icon = "__programmable-controllers__/graphics/icons/controller-mem.png",
		icon_size = 32,
		flags = {"goes-to-quickbar"},
		subgroup = "pc-blocks",
		order = "a-c",
		place_result = "controller-mem",
		stack_size = 50
	},
	{
		type = "recipe",
		name = "controller-mem",
		enabled=false,
		ingredients = {{"advanced-circuit", 4},{"copper-cable",8},{"controller-ext",1}},
		result = "controller-mem",
		result_count = 1
	}
})
table.insert(data.raw.technology["advanced-electronics-2"].effects, {type = "unlock-recipe", recipe = "controller-mem"})
