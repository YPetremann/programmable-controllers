local config = require("__programmable-controllers__.config")
local memory = require("__programmable-controllers__.control.memory")
local addons = require("__programmable-controllers__.control.addon_base")
local lib = {}

local function DEC_HEX(IN)
    local OUT = string.format("%x", IN or 0):upper()
    while #OUT < 4 do OUT = "0" .. OUT end
    return OUT
end

local function DEC_N0(IN)
    local OUT = tostring(IN)
    while #OUT < 4 do OUT = "0" .. OUT end
    return OUT
end

function lib.create(eid, entity, player)
    local first, code = true, ""
    local lgrp = global.grp[global.rgrp[eid]]
    local ls, le = 0, 0
    for i = 0, #lgrp - 1, 1 do
        local lent = lgrp[i + 1]
        local name = global.ent[lent].name
        if (name ~= "pc-pow") and (name ~= "pc-ext") then
            if first then
                first = false
            else
                code = code .. "\n\n"
            end
            if lent == eid then ls = #code end
            code = code .. "#### #### " .. name
            for j = 0, config.blocksize - 1, 1 do
                local k = i * config.blocksize + j
                local m = memory.peek(eid, k)
                local sname = m.signal.name
                local type = m.signal.type
                local count = m.count
                if sname == nil then
                    sname = "pci-00"
                    count = 0
                end
                if addons.pcn[sname] ~= nil then
                    code =
                        code .. "\n" .. DEC_N0(k) .. " " .. addons.pcn[sname] ..
                            " " .. tostring(count)
                else
                    local t = string.upper(string.sub(type, 1, 1))
                    code =
                        code .. "\n" .. DEC_N0(k) .. " " .. t .. ":" .. sname ..
                            " " .. tostring(count)
                end
            end
            if lent == eid then le = #code end
        elseif name == "pc-pow" then
            if first ~= name then
                code = code .. "\n"
                first = name
            end
            code = code .. "\n#### #### " .. name
        end
    end
    lib.destroy(player.gui.screen, "programmable_controllers")
    local flow = player.gui.screen.add {
        type = "flow",
        name = "programmable_controllers",
        direction = "vertical"
    }
    local gui = flow.add {
        type = "frame",
        name = "pc-mem-window",
        direction = "vertical",
        caption = "CODE"
    }
    local mem = gui.add {type = "text-box", name = "pc-mem", text = code}
    mem.style.maximal_height = 28 + (config.blocksize * 20)
    mem.style.minimal_width = 256
    mem.select(ls, le)
    local action = gui.add {type = "flow", direction = "horizontal"}
    local btn = action.add {
        type = "button",
        name = "pc-load",
        caption = "Load",
        style = "back_button"
    }
    btn.style.minimal_width = 126
    btn = action.add {
        type = "button",
        name = "pc-save",
        caption = "Save",
        style = "forward_button"
    }
    btn.style.minimal_width = 126
end

function lib.destroy(origin, path)
    if origin[path] ~= nil then origin[path].destroy() end
end

return lib
