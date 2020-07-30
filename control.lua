local pc_utils = require("__programmable-controllers__.control.utils")
local addons = require("__programmable-controllers__.control.addons")
local config = require("config")
-- settings.get_player_settings(game.get_player(event.player_index))["pc-debug"]
local safe = false

local function on_gui_text_changed(e)
    -- mem_save(e)
end
local function on_gui_click(e)
    if e.element.name == "pc-load" then
        pc_utils.mem_load(e)
    elseif e.element.name == "pc-reset" then
        pc_utils.mem_load(e)
        local eid = global.lpid[e.player_index].eid
        local entity = global.ent[eid]
        local index = (global.rgid[eid] - 1) * config.blocksize + 6
        local parameters = entity.get_control_behavior().parameters
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
        parameters.parameters[3] = {
            signal = {type = "virtual", name = "signal-blue"},
            count = 0,
            index = 3
        }
        parameters.parameters[4] = {
            signal = {type = "virtual", name = "signal-green"},
            count = 0,
            index = 4
        }
        parameters.parameters[5] = {
            signal = {type = "virtual", name = "signal-yellow"},
            count = 0,
            index = 5
        }
        parameters.parameters[6] = {
            signal = {type = "virtual", name = "signal-red"},
            count = 0,
            index = 6
        }
        entity.get_control_behavior().parameters = parameters
    elseif e.element.name == "pc-pause" then
        pc_utils.mem_load(e)
        local eid = global.lpid[e.player_index].eid
        local entity = global.ent[eid]
        entity.get_control_behavior().enabled = false
    elseif e.element.name == "pc-start" then
        pc_utils.mem_load(e)
        local eid = global.lpid[e.player_index].eid
        local entity = global.ent[eid]
        entity.get_control_behavior().enabled = true
    elseif e.element.name == "pc-save" then
        e.text = e.element.parent.parent["pc-mem"].text
        pc_utils.mem_save(e)
    end
end

local function on_gui_opened(e)
    local pid = e.player_index
    local entity = e.entity
    if entity == nil then return end
    local eid = pc_utils.cantorPair(math.floor(entity.position.x),
                                    math.floor(entity.position.y))
    if global.rgrp[eid] == nil then return end
    if global.rpid[eid] == nil then global.rpid[eid] = {} end
    global.rpid[eid][pid] = game.players[pid]
    global.rgid[pid] = eid
    pc_utils.read_status(eid, true)
    pc_utils.write_status(eid, true)
    if addons.classes[entity.name].on_gui_create ~= nil then
        addons.classes[entity.name]
            .on_gui_create(eid, entity, game.players[pid])
    end
    -- game.print(game.tick.." rpid: "..global.rpid[eid])

end
local function on_gui_closed(e)
    -- player_index :: uint: The player.
    -- gui_type     :: defines.gui_type: The GUI type that was open.
    -- entity       :: LuaEntity (optional): The entity that was open
    -- item         :: LuaItemStack (optional): The item that was open
    -- equipment    :: LuaEquipment (optional): The equipment that was open
    -- other_player :: LuaPlayer (optional): The other player that was open
    -- element      :: LuaGuiElement (optional): The custom GUI element that was open
    local pid = e.player_index
    local entity = e.entity
    if entity == nil or global.rgid[pid] == nil then return end
    local eid = global.rgid[pid]
    entity = global.ent[eid]

    if entity.name ~= "pc-con" then
        pc_utils.read_status(eid, false)
        pc_utils.write_status(eid, false)
    end
    if addons.classes[entity.name].on_gui_destroy ~= nil then
        addons.classes[entity.name].on_gui_destroy(eid, entity,
                                                   game.players[pid])
    end
    global.rgid[pid] = nil
    global.rpid[eid][pid] = nil
    if next(global.rpid[eid]) == nil then global.rpid[eid] = nil end
end

local function on_built_entity(event) -- OK
    local entity = event.created_entity or event.entity
    if addons.classes[entity.name] ~= nil then
        -- game.print("+"..entity.name)
        pc_utils.remap(entity, true)
        if addons.classes[entity.name].on_built_entity then
            addons.classes[entity.name].on_built_entity(entity)
        end
    end
end
local function on_removed_entity(event) -- OK
    local entity = event.entity
    if addons.classes[entity.name] ~= nil then
        -- game.print("-"..entity.name)
        if addons.classes[entity.name].on_removed_entity ~= nil then
            addons.classes[entity.name].on_removed_entity(entity)
        end
        local eid = pc_utils.cantorPair(math.floor(entity.position.x),
                                        math.floor(entity.position.y))
        if global.rpid[eid] then
            for pi, player in pairs(global.rpid[eid]) do
                on_gui_closed({player_index = pi, entity = entity})
            end
        end
        pc_utils.remap(entity, false)
    end
end
local function on_player_rotated_entity(event)
    -- event.entity.rotate{reverse = true}
end
local function on_tick(event)
    if safe then
        local energy = {}
        -- pre tick (energy and memory)
        for eid, entity in pairs(global.ent) do
            if entity.valid then
                if entity.name == "pc-pow" then
                    local grp = global.rgrp[eid]
                    energy[grp] = energy[grp] or {0, 0}
                    energy[grp][1] = energy[grp][1] + entity.energy
                    energy[grp][2] = energy[grp][2] + 1
                elseif global.mcr[eid] then
                    global.mem[eid] = nil
                end
            end
        end
        -- handle tick entity
        for eid, entity in pairs(global.ent) do
            if entity.valid and addons.classes[entity.name].on_tick ~= nil then
                addons.classes[entity.name].on_tick(eid, entity, energy)
            end
        end
        -- save data and set energy
        for eid, chunk in pairs(global.mem) do
            local entity = global.ent[eid]
            if global.mcw[eid] then
                -- game.print(game.tick.." Saved "..eid )
                addons.classes[entity.name].on_save_mem(eid, entity, chunk)
            end
        end
        -- set energy
        for eid, entity in pairs(global.ent) do
            if entity.name == "pc-pow" then
                local grp = global.rgrp[eid]
                local egrp = energy[grp] or {0, 0}
                entity.energy = egrp[1] / egrp[2]
            end
        end
        -- reopen gui
        for pi, d in pairs(global.lpid) do
            if d.tick == game.tick then
                local entity = global.ent[d.eid]
                game.players[pi].opened = entity
                global.lpid[pi] = nil
                if entity.name == "pc-con" then
                    pc_utils.write_status(d.eid, true)
                    pc_utils.read_status(d.eid, true)
                end
            end
        end
    end
end

remote.add_interface("pc-docs", {
    informatron_menu = function(data) return addons.docs.menu end,
    informatron_page_content = function(data)
        local page = addons.docs.pages[data.page_name] or
                         addons.docs.pages["404"]
        return page(data)
    end
})
local function on_after_load()
    safe = true
    for i, g in pairs(global.mem) do
        print(i .. " checking cell")
        for j, c in pairs(g) do
            local s = c.signal
            if (s.type == "virtual" and
                not game.virtual_signal_prototypes[s.name]) or
                (s.type == "item" and not game.item_prototypes[s.name]) then
                print("  " .. i .. ":" .. j .. " cleared memory " ..
                          (s.name or ""))
                global.mem[i][j].signal = {type = "item"}
                global.mem[i][j].count = 0
            else
                print("  " .. i .. ":" .. j .. " memory ok " .. (s.name or ""))
            end
        end
    end
    -- game.item_prototypes
    -- game.virtual_signal_prototypes
    for index, force in pairs(game.forces) do
        force.reset_recipes()
        force.reset_technologies()
        force.reset_technology_effects()
    end
end
local function on_load()
    script.on_nth_tick(1, function()
        script.on_nth_tick(1, nil)
        on_after_load()
    end)
end

if __DebugAdapter then
    commands.add_command("debug", "", __DebugAdapter.breakpoint)
end
local function on_init()
    -- eid is the cantor pair of the entity position
    -- get entity from their eid
    global.ent = global.ent or {} -- [eid] = > entity         -- OK
    -- get gid from eid
    global.rgrp = global.rgrp or {} -- [eid] = > gid            -- OK
    -- get players viewing from eid
    global.rpid = global.rpid or {} -- [eid] = > {pid = peo ...}  -- OK
    -- get mem from eid
    global.mem = global.mem or {} -- [eid] = > {sl ...}       -- OK
    -- get cache read from eid
    global.mcr = global.mcr or {} -- [eid] = > cacheread      -- OK
    -- get cache write from eid
    global.mcw = global.mcw or {} -- [eid] = > cachewrite     -- OK
    -- get group from gid
    global.grp = global.grp or {} -- [gid] = > {rgid = eid ...} -- OK

    global.rgid = global.rgid or {} -- [eid] = > index          -- OK
    global.lpid = global.lpid or {} -- [pid] = > eid            -- OK

    -- get neighbours from eid
    global.sxy = global.sxy or {} -- [ent.surface.name][ent.position.x][ent.position.y] = > {eid=>uidqq}            -- OK

    -- get datas from eid
    global.data = global.data or {} -- [eid] = > {data...}            -- OK
    -- game.print("hello")
    on_load()
end

script.on_init(on_init)
script.on_load(on_load)
script.on_configuration_changed(on_init)
script.on_event(defines.events.on_tick, on_tick)
script.on_event(defines.events.on_gui_click, on_gui_click)
script.on_event(defines.events.on_gui_text_changed, on_gui_text_changed)
script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_event(defines.events.on_robot_built_entity, on_built_entity)
script.on_event(defines.events.script_raised_built, on_built_entity)
script.on_event(defines.events.script_raised_revive, on_built_entity)
script.on_event(defines.events.on_player_rotated_entity,
                on_player_rotated_entity)
script.on_event(defines.events.on_pre_player_mined_item, on_removed_entity)
script.on_event(defines.events.on_robot_pre_mined, on_removed_entity)
script.on_event(defines.events.on_entity_died, on_removed_entity)
script.on_event(defines.events.script_raised_destroy, on_removed_entity)

script.on_event(defines.events.on_gui_opened, on_gui_opened)
script.on_event(defines.events.on_gui_closed, on_gui_closed)
