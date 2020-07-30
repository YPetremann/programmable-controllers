local pc_utils = require("__programmable-controllers__.control.utils")
local editor = require("__programmable-controllers__.control.editor")

return {
    ["pc-con"] = {
        on_gui_create = function(index, entity, player)
            editor.create(index, entity, player)
            local gui = player.gui.screen.programmable_controllers.add {
                type = "frame",
                name = entity.name .. "-window",
                direction = "vertical",
                caption = "CNI"
            }
            local action = gui.add {
                type = "flow",
                name = "flow-" .. index,
                direction = "horizontal"
            }
            local btn = action.add {
                type = "button",
                name = "input-" .. index,
                caption = "Input",
                style = "back_button"
            }
            btn.style.minimal_width = 126
            btn = action.add {
                type = "button",
                name = "output-" .. index,
                caption = "Output",
                style = "forward_button"
            }
            btn.style.minimal_width = 126
        end,
        on_gui_destroy = function(index, entity, player)
            editor.destroy(player.gui.screen, "programmable_controllers")
        end,
        on_built_entity = function(entity)
            local eid = entity.unit_number
            pc_utils.write_status(eid, true)
            pc_utils.read_status(eid, true)
        end,
        on_load_mem = function(index, entity)
            -- game.print(game.tick.." con >> mem")
            local enabled = entity.get_control_behavior().enabled
            local parameters = entity.get_control_behavior().parameters
            local ret = {}
            if not enabled then
                local rednet = entity.get_circuit_network(defines.wire_type.red)
                local grenet = entity.get_circuit_network(
                                   defines.wire_type.green)
                rednet = rednet and rednet.signals or {}
                grenet = grenet and grenet.signals or {}
                local net = pc_utils.mergeSignals(rednet, grenet)
                for k, s in pairs(parameters.parameters) do
                    local stype = s.signal.type
                    local sname = s.signal.name
                    if sname ~= nil then
                        if net[stype] ~= nil and net[stype][sname] ~= nil then
                            s.count = net[stype][sname]
                        else
                            s.count = 0
                        end
                    end
                end
            end
            for _, item in pairs(parameters.parameters) do
                if item.signal.name == nil then
                    item.signal.type = "item"
                    item.signal.name = nil
                    item.count = 0
                end
                table.insert(ret, {
                    t = item.signal.type,
                    s = item.signal.name,
                    c = item.count
                })
            end
            return parameters.parameters
        end,
        on_save_mem = function(index, entity, chunk)
            -- game.print(game.tick.." con << mem")
            entity.get_control_behavior().parameters = {parameters = chunk}
        end
    }
}
