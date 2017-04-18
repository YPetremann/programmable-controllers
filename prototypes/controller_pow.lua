    --~ working_sound =
    --~ {
      --~ sound =
      --~ {
        --~ filename = "__base__/sound/accumulator-working.ogg",
        --~ volume = 1
      --~ },
      --~ idle_sound = {
        --~ filename = "__base__/sound/accumulator-idle.ogg",
        --~ volume = 0.4
      --~ },
      --~ max_sounds_per_type = 5
    --~ },

data:extend({ 
	{
    type = "electric-energy-interface",
		name = "controller-pow",
		icon = "__programmable-controllers__/graphics/icons/controller-pow.png",
		flags = {"placeable-neutral", "player-creation"},
		fast_replaceable_group = "controller",
		minable = {hardness = 0.2, mining_time = 0.5, result = "controller-pow"},
		max_health = 55,
		corpse = "small-remnants",
		collision_box = {{-0.3, -0.3}, {0.3, 0.3}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		item_slot_count = 32,
    picture = {
			filename = "__programmable-controllers__/graphics/entity/controller-pow.png",
			priority = "high",
			width = 64,	height = 64,
			shift = {0, 0},
			frame_count = 1,
			axially_symmetrical = false,
			direction_count = 1,
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
		circuit_wire_max_distance = 0,
		vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		energy_source = {
			type = "electric",
			buffer_capacity = "1MJ",
			usage_priority = "secondary-input",
			input_flow_limit = "150kW",
			output_flow_limit = "0kW"
		},
    energy_production = "0kW",
    energy_usage = "0kW",
		energy_usage_per_tick = "10KW"
	},
	{
		type = "item",
		name = "controller-pow",
		icon = "__programmable-controllers__/graphics/icons/controller-pow.png",
		flags = {"goes-to-quickbar"},
		subgroup = "pc-blocks",
		order = "a-a",
		place_result = "controller-pow",
		stack_size = 50
	},
	{
		type = "recipe",
		name = "controller-pow",
		enabled=false,
		ingredients = {{"copper-cable",16},{"controller-ext",1}},
		result = "controller-pow",
		result_count = 1
	}
})
table.insert(data.raw.technology["advanced-electronics-2"].effects, {type = "unlock-recipe", recipe = "controller-pow"})
