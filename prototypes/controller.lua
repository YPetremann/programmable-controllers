local config = require("__programmable-controllers__.config")
local lib = {}

function lib.entity_frame(filename, x, y)
    x = x or 0
    y = y or 0
    return {
        layers = {
            {
                filename = "__programmable-controllers__/graphics/entity/pc-frame-shadow.png",
                width = 128,
                height = 128,
                shift = {0, -0.125},
                scale = 0.5,
                draw_as_shadow = true
            }, {
                filename = "__programmable-controllers__/graphics/entity/pc-frame.png",
                width = 128,
                height = 128,
                shift = {0, -0.125},
                scale = 0.5
            }, {
                filename = filename,
                width = 64,
                height = 64,
                shift = {0, -0.125},
                scale = 0.5,
                x = x,
                y = y
            }
        }
    }
end
function lib.null_texture()
    return {
        filename = "__programmable-controllers__/graphics/null.png",
        width = 1,
        height = 1,
        frame_count = 1,
        shift = {0, 0}
    }
end

local device_model = {
    type = "constant-combinator",
    name = "px-ext",
    icon = "__%s__/graphics/icons/%s.png",
    icon_size = 64,
    flags = {"placeable-neutral", "player-creation"},
    fast_replaceable_group = "controller",
    minable = {hardness = 0.2, mining_time = 0.5, result = "pc-ext"},
    max_health = 50,
    corpse = "small-remnants",
    collision_box = {{-0.3, -0.3}, {0.3, 0.3}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    drawing_box = {{-0.5, -0.75}, {0.5, 0.25}},
    hit_visualization_box = {{-0.5, -0.75}, {0.5, 0.25}},
    sticker_box = {{-0.5, -0.75}, {0.5, 0.25}},
    alert_icon_shift = {0, -0.25},
    item_slot_count = config.blocksize,
    sprites = "__%s__/graphics/entity/%s.png",
    activity_led_sprites = {
        north = lib.null_texture(),
        east = lib.null_texture(),
        south = lib.null_texture(),
        west = lib.null_texture()
    },
    activity_led_light = {intensity = 0.8, size = 1},
    activity_led_light_offsets = {
        {0.296875, -0.40625}, {0.25, -0.03125}, {-0.296875, -0.078125},
        {-0.21875, -0.46875}
    },
    circuit_wire_connection_points = {
        {
            shadow = {
                red = {0.859375, -0.296875},
                green = {0.859375, -0.296875}
            },
            wire = {red = {0.40625, -0.59375}, green = {0.40625, -0.59375}}
        }, {
            shadow = {
                red = {0.859375, -0.296875},
                green = {0.859375, -0.296875}
            },
            wire = {red = {0.40625, -0.59375}, green = {0.40625, -0.59375}}
        }, {
            shadow = {
                red = {0.859375, -0.296875},
                green = {0.859375, -0.296875}
            },
            wire = {red = {0.40625, -0.59375}, green = {0.40625, -0.59375}}
        }, {
            shadow = {
                red = {0.859375, -0.296875},
                green = {0.859375, -0.296875}
            },
            wire = {red = {0.40625, -0.59375}, green = {0.40625, -0.59375}}
        }
    },
    circuit_wire_max_distance = 0,
    vehicle_impact_sound = {
        filename = "__base__/sound/car-metal-impact.ogg",
        volume = 0.65
    },
    energy_source = {type = "electric", usage_priority = "secondary-input"},
    energy_usage_per_tick = "5KW"
}
function lib.add_device(def)
    local final = table.deepcopy(device_model)
    final.icon = def.icon or final.icon:format(def.mod, def.name)
    final.minable.result = def.name
    final.sprites = {
        north = lib.entity_frame(final.sprites:format(def.mod, def.name), 0, 0),
        east = lib.entity_frame(final.sprites:format(def.mod, def.name), 64, 0),
        south = lib.entity_frame(final.sprites:format(def.mod, def.name), 0, 64),
        west = lib.entity_frame(final.sprites:format(def.mod, def.name), 64, 64)
    }
    for k, v in pairs(def) do final[k] = v end
    def.mod = nil
    -- merge everything else
    data:extend{final}
end

function lib.add_item(name, order, icon, icon_size)
    icon_size = icon_size or 64
    data:extend{
        {
            type = "item",
            name = name,
            icon = icon,
            icon_size = icon_size,
            flags = {},
            subgroup = "pc-blocks",
            order = order,
            place_result = name,
            stack_size = 50
        }
    }
end
function lib.add_recipe(result, ingredients)
    data:extend{
        {
            type = "recipe",
            name = result,
            enabled = false,
            ingredients = ingredients,
            result = result,
            result_count = 1
        }
    }

end
function lib.add_recipe_to_tech(recipe, tech)
    tech = tech or "advanced-electronics"
    table.insert(data.raw.technology[tech].effects,
                 {type = "unlock-recipe", recipe = recipe})
end
return lib
