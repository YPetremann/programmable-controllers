data:extend({
	{
		type = "constant-combinator",
		name = "controller-cpu",
		icon = "__programmable-controllers__/graphics/icons/controller-cpu.png",
		flags = {"placeable-neutral", "player-creation"},
		minable = {hardness = 0.2, mining_time = 0.5, result = "controller-cpu"},
		max_health = 55,
		corpse = "small-remnants",
		collision_box = {{-0.3, -0.3}, {0.3, 0.3}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		item_slot_count = 16,
		sprites = {
			north = {
				filename = "__programmable-controllers__/graphics/entity/controller-cpu.png",
				priority = "high",
				width = 64,	height = 64,
				shift = {0, 0},
				frame_count = 1,
				axially_symmetrical = false,
				direction_count = 1,
			},
			east = {
				filename = "__programmable-controllers__/graphics/entity/controller-cpu.png",
				priority = "high",
				width = 64,	height = 64,
				shift = {0, 0},
				frame_count = 1,
				axially_symmetrical = false,
				direction_count = 1,
			},
			south = {
				filename = "__programmable-controllers__/graphics/entity/controller-cpu.png",
				priority = "high",
				width = 64,	height = 64,
				shift = {0, 0},
				frame_count = 1,
				axially_symmetrical = false,
				direction_count = 1,
			},
			west = {
				filename = "__programmable-controllers__/graphics/entity/controller-cpu.png",
				priority = "high",
				width = 64,	height = 64,
				shift = {0, 0},
				frame_count = 1,
				axially_symmetrical = false,
				direction_count = 1,
			}
		},
		activity_led_sprites = {
			north = {
				filename = "__base__/graphics/entity/combinator/activity-leds/combinator-led-constant-north.png",
				width = 11,
				height = 10,
				frame_count = 1,
				shift = {0.296875, -0.40625},
			},
			east = {
				filename = "__base__/graphics/entity/combinator/activity-leds/combinator-led-constant-east.png",
				width = 14,
				height = 12,
				frame_count = 1,
				shift = {0.25, -0.03125},
			},
			south = {
				filename = "__base__/graphics/entity/combinator/activity-leds/combinator-led-constant-south.png",
				width = 11,
				height = 11,
				frame_count = 1,
				shift = {-0.296875, -0.078125},
			},
			west = {
				filename = "__base__/graphics/entity/combinator/activity-leds/combinator-led-constant-west.png",
				width = 12,
				height = 12,
				frame_count = 1,
				shift = {-0.21875, -0.46875},
			}
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
		--circuit_wire_max_distance = 0,
		circuit_wire_max_distance = 0,
		vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		energy_source = {
			type = "electric",
			usage_priority = "secondary-input"
		},
		energy_usage_per_tick = "5KW"
	},
	{
		type = "item",
		name = "controller-cpu",
		icon = "__programmable-controllers__/graphics/icons/controller-cpu.png",
		flags = {"goes-to-quickbar"},
		subgroup = "pc-blocks",
		order = "a[input]",
		place_result = "controller-cpu",
		stack_size = 50
	},
	{
		type = "recipe",
		name = "controller-cpu",
		enabled=false,
		ingredients = {{"processing-unit",1},{"arithmetic-combinator", 2},{"decider-combinator", 2},{"controller-ext",1}},
		result = "controller-cpu",
		result_count = 1
	}
})
table.insert(data.raw.technology["advanced-electronics-2"].effects, {type = "unlock-recipe", recipe = "controller-cpu"})
