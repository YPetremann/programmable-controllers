local config = require("__programmable-controllers__.config")
local pc_utils = require("__programmable-controllers__.control.utils")
local memory = require("__programmable-controllers__.control.memory")
local cpu = require("__programmable-controllers__.control.cpu_control")
local editor = require("__programmable-controllers__.control.editor")
local addons = require("__programmable-controllers__.control.addon_base")

return {
    ["pc-cpu"] = {
        on_gui_create = function(index, entity, player)
            editor.create(index, entity, player)
            local gui = player.gui.left.add {
                type = "frame",
                name = entity.name .. "-" .. index,
                direction = "vertical",
                caption = "CPU"
            }
            local action = gui.add {
                type = "flow",
                name = "flow-" .. index,
                direction = "horizontal"
            }
            local btn = action.add {
                type = "button",
                name = "pc-reset",
                caption = "Reset",
                style = "back_button"
            }
            btn.style.maximal_width = 83
            btn = action.add {
                type = "button",
                name = "pc-pause",
                caption = "Pause",
                style = "dialog_button"
            }
            btn.style.maximal_width = 82
            btn = action.add {
                type = "button",
                name = "pc-start",
                caption = "Start",
                style = "forward_button"
            }
            btn.style.maximal_width = 83
            gui.add {
                type = "progressbar",
                name = "cycles",
                size = 256,
                value = 0
            }
            gui.cycles.style.minimal_width = 256
        end,
        on_gui_destroy = function(index, entity, player)
            editor.destroy(player.gui.left, "pc-mem-window")
            editor.destroy(player.gui.left, entity.name .. "-" .. index)
        end,
        on_built_entity = function(entity)
            entity.get_control_behavior().enabled = false
            local eid = pc_utils.cantorPair(math.floor(entity.position.x),
                                            math.floor(entity.position.y))
            local index = (global.rgid[eid] - 1) * config.blocksize + 6
            local parameters = entity.get_control_behavior().parameters
            if parameters.parameters[2].name then
                parameters.parameters[3] =
                    {
                        signal = {type = "virtual", name = "signal-blue"},
                        count = 0,
                        index = 3
                    }
                parameters.parameters[4] =
                    {
                        signal = {type = "virtual", name = "signal-green"},
                        count = 0,
                        index = 4
                    }
                parameters.parameters[5] =
                    {
                        signal = {type = "virtual", name = "signal-yellow"},
                        count = 0,
                        index = 5
                    }
                parameters.parameters[6] =
                    {
                        signal = {type = "virtual", name = "signal-red"},
                        count = 0,
                        index = 6
                    }
                parameters.parameters[7] =
                    {
                        signal = {type = "virtual", name = "signal-C"},
                        count = 0,
                        index = 7
                    }
                parameters.parameters[8] =
                    {
                        signal = {type = "virtual", name = "signal-O"},
                        count = 0,
                        index = 8
                    }
                parameters.parameters[9] =
                    {
                        signal = {type = "virtual", name = "signal-D"},
                        count = 0,
                        index = 9
                    }
                parameters.parameters[10] =
                    {
                        signal = {type = "virtual", name = "signal-E"},
                        count = 0,
                        index = 10
                    }
                parameters.parameters[11] =
                    {
                        signal = {type = "virtual", name = "signal-blue"},
                        count = 0,
                        index = 11
                    }
                parameters.parameters[12] =
                    {
                        signal = {type = "virtual", name = "signal-blue"},
                        count = 0,
                        index = 12
                    }
                parameters.parameters[13] =
                    {
                        signal = {type = "virtual", name = "signal-H"},
                        count = 0,
                        index = 13
                    }
                parameters.parameters[14] =
                    {
                        signal = {type = "virtual", name = "signal-E"},
                        count = 0,
                        index = 14
                    }
                parameters.parameters[15] =
                    {
                        signal = {type = "virtual", name = "signal-R"},
                        count = 0,
                        index = 15
                    }
                parameters.parameters[16] =
                    {
                        signal = {type = "virtual", name = "signal-E"},
                        count = 0,
                        index = 16
                    }
            end
            parameters.parameters[1] = {
                signal = {type = "virtual", name = "pci-00"},
                count = 0,
                index = 1
            }
            parameters.parameters[2] = {
                signal = {type = "virtual", name = "pci-10"},
                count = index,
                index = 2
            }
            entity.get_control_behavior().parameters = parameters
        end,
        on_tick = function(eid, entity, energy)
            local cycles = 0
            local power = config.power
            local grp = global.rgrp[eid]
            if entity.get_control_behavior().enabled and energy[grp] ~= nil and
                energy[grp][1] > power then
                cpu.origin = (global.rgid[eid] - 1) * config.blocksize
                local cell = memory.peek(eid, cpu.origin)
                if cell.signal.name == "pci-66" then
                    cpu.control = cell.count
                else
                    cpu.control = cpu.origin
                end
                cpu.pointer = memory.peek(eid, cpu.control + 1).count
                cpu.register = memory.peek(eid, cpu.control + 2)
                if cpu.register.signal.name == "pci-65" then
                    cpu.register = cpu.register.count
                else
                    cpu.register = cpu.control + 2
                end
                local state = memory.peek(eid, cpu.control)
                if state.signal.name == "pci-0E" or state.signal.name ==
                    "pci-0F" then
                    state.signal.name = "pci-00"
                    memory.poke(eid, cpu.control, state)
                end
                cpu.brk = false
                while true do
                    cycles = cycles + 1
                    if energy[grp][1] < power then break end
                    local i = memory.peek(eid, cpu.pointer)
                    cpu.pointer = cpu.pointer + 1
                    local inst = i.signal.name
                    if i ~= nil and addons.pci[inst] ~= nil then
                        addons.pci[inst](eid, i.count)
                        energy[grp][1] = energy[grp][1] - power
                    end
                    if cycles >= config.cpt then
                        entity.direction = 6
                        break
                    end
                    if cpu.brk then
                        if cycles == 1 then
                            entity.direction = 2
                        else
                            entity.direction = 4
                        end
                        break
                    end
                end
                local C = memory.peek(eid, cpu.control + 1)
                C.count = cpu.pointer
                memory.poke(eid, cpu.control + 1, C)
                state = memory.peek(eid, cpu.control)
                if state.signal.name == "pci-0E" or state.signal.name ==
                    "pci-0F" then
                    local gid = global.rgrp[eid]
                    for _, fid in pairs(global.grp[gid]) do
                        if global.rpid[fid] then
                            for pi, player in pairs(global.rpid[fid]) do
                                global.lpid[pi] =
                                    {eid = fid, tick = game.tick + 1}
                                player.opened = nil
                            end
                        end
                        pc_utils.read_status(fid, false)
                        pc_utils.write_status(fid, true)
                    end
                end
                entity.get_control_behavior().enabled =
                    state.signal.name ~= "pci-0E" and state.signal.name ~=
                        "pci-0F"
            else
                entity.direction = 0
            end
            if global.rpid[eid] then
                for pi, player in pairs(global.rpid[eid]) do
                    local gui = player.gui.left[entity.name .. "-" .. eid]
                    gui.cycles.value = cycles / config.cpt
                end
            end
        end,
        on_load_mem = function(eid, entity)
            return entity.get_control_behavior().parameters.parameters
        end,
        on_save_mem = function(eid, entity, chunk)
            entity.get_control_behavior().parameters = {parameters = chunk}
        end,
        on_removed_entity = function(entity) end
    }
}
