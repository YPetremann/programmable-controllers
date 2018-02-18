data:extend({
	{
		type = "wall",
		name = "controller-ext",
		icon = "__programmable-controllers__/graphics/icons/controller-ext.png",
		icon_size = 32,
		flags = {"placeable-neutral", "player-creation"},
		fast_replaceable_group = "controller",
		minable = {hardness = 0.2, mining_time = 0.5, result = "controller-ext"},
		max_health = 50,
		corpse = "small-remnants",
		collision_box = {{-0.3, -0.3}, {0.3, 0.3}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		item_slot_count = 0,
		pictures = {
			single = {
				filename = "__programmable-controllers__/graphics/entity/controller-ext.png",
				width = 64,	height = 64,
				shift = {0, 0}
			},
			straight_vertical = {
				filename = "__programmable-controllers__/graphics/entity/controller-ext.png",
				width = 64,	height = 64,
				shift = {0, 0}
			},
			straight_horizontal = {
				filename = "__programmable-controllers__/graphics/entity/controller-ext.png",
				width = 64,	height = 64,
				shift = {0, 0}
			},
			corner_right_down = {
				filename = "__programmable-controllers__/graphics/entity/controller-ext.png",
				width = 64,	height = 64,
				shift = {0, 0}
			},
			corner_left_down = {
				filename = "__programmable-controllers__/graphics/entity/controller-ext.png",
				width = 64,	height = 64,
				shift = {0, 0}
			},
			t_up = {
				filename = "__programmable-controllers__/graphics/entity/controller-ext.png",
				width = 64,	height = 64,
				shift = {0, 0}
			},
			ending_right = {
				filename = "__programmable-controllers__/graphics/entity/controller-ext.png",
				width = 64,	height = 64,
				shift = {0, 0}
			},
			ending_left = {
				filename = "__programmable-controllers__/graphics/entity/controller-ext.png",
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
				shadow = {
					red = {0.15625, -0.28125},
					green = {0.65625, -0.25}
				},
				wire = {
					red = {-0.28125, -0.5625},
					green = {0.21875, -0.5625},
				}
			}, {
				shadow = {
					red = {0.75, -0.15625},
					green = {0.75, 0.25},
				},
				wire = {
					red = {0.46875, -0.5},
					green = {0.46875, -0.09375},
				}
			}, {
				shadow = {
					red = {0.75, 0.5625},
					green = {0.21875, 0.5625}
				},
				wire = {
					red = {0.28125, 0.15625},
					green = {-0.21875, 0.15625}
				}
			}, {
				shadow = {
					red = {-0.03125, 0.28125},
					green = {-0.03125, -0.125},
				},
				wire = {
					red = {-0.46875, 0},
					green = {-0.46875, -0.40625},
				}
			}
		},
		circuit_wire_max_distance = 0
	},
	{
		type = "item",
		name = "controller-ext",
		icon = "__programmable-controllers__/graphics/icons/controller-ext.png",
		icon_size = 32,
		flags = {"goes-to-quickbar"},
		subgroup = "pc-blocks",
		order = "a-z",
		place_result = "controller-ext",
		stack_size = 50
  },
  {
    type = "recipe",
    name = "controller-ext",
    enabled=false,
    ingredients = {{"concrete",1},{"iron-plate",1},{"copper-cable", 16},{"advanced-circuit", 2}},
    result = "controller-ext",
    result_count = 1
  }
})
table.insert(data.raw.technology["advanced-electronics-2"].effects, {type = "unlock-recipe", recipe = "controller-ext"})
