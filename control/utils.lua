local addons = require("__programmable-controllers__.control.addon_base")
local memory = require("__programmable-controllers__.control.memory")

local lib = {}

function lib.cantorPair(x, y) -- OK
    x, y = (x >= 0 and x or (-0.5 - x)), (y >= 0 and y or (-0.5 - y))
    local s = x + y
    local h = s * (s + 0.5) + x
    return h + h
end

function lib.cantorUnpair(z) -- OK
    local w = math.floor((math.sqrt(8 * z + 1) - 1) / 2)
    local t = (math.pow(w, 2) + w) / 2
    local x = z - t
    local y = w - x
    return (x % 2 == 1 and (-x - 1) / 2 or x / 2),
           (y % 2 == 1 and (-y - 1) / 2 or y / 2)
end

function lib.write_status(eid, status)
    if global.mcw[eid] ~= status then
        -- game.print(game.tick..eid.." write : "..(status and "true" or "false"))
        global.mcw[eid] = status
    end
end

function lib.read_status(eid, status)
    if global.mcr[eid] ~= status then
        -- game.print(game.tick..eid.." read  : "..(status and "true" or "false"))
        global.mcr[eid] = status
    end
end

function lib.mem_load(e)
    local eid = global.rgrp[global.rgid[e.player_index]]
    local gid = global.rgrp[eid]
    for _, fid in pairs(global.grp[gid]) do
        if global.rpid[fid] then
            for pi, player in pairs(global.rpid[fid]) do
                global.lpid[pi] = {eid = fid, tick = game.tick + 1}
                player.opened = nil
            end
        end
        lib.read_status(fid, false)
        lib.write_status(fid, true)
    end
end

function lib.mergeSignals(red, green) -- TODO remove -- this create new table and need to be avoided
    local ret = {}
    for k, s in ipairs(red) do
        local stype = s.signal.type
        local sname = s.signal.name
        local count = s.count
        ret[stype] = ret[stype] or {}
        ret[stype][sname] = count
    end
    for k, s in ipairs(green) do
        local stype = s.signal.type
        local sname = s.signal.name
        local count = s.count
        ret[stype] = ret[stype] or {}
        if ret[stype][sname] == nil then
            ret[stype][sname] = count
        else
            ret[stype][sname] = ret[stype][sname] + count
        end
    end
    return ret
end

function lib.mem_save(e)
    local eid = global.rgrp[global.rgid[e.player_index]]
    for line in string.gmatch(e.text, "[^\n]+") do
        local instruction = {
            string.match(line,
                         "^ *([0-9][0-9][0-9][0-9]) +([A-Z][A-Z][A-Z][#@&%%]) +(-?[0-9]+) *$")
        }
        local item = {
            string.match(line,
                         "^ *([0-9][0-9][0-9][0-9]) +I:([^ ]*) +(-?[0-9]+) *$")
        }
        local virtual = {
            string.match(line,
                         "^ *([0-9][0-9][0-9][0-9]) +V:([^ ]*) +(-?[0-9]+) *$")
        }
        if addons.rpcn[instruction[2]] then
            if instruction[2] == "NOP#" and instruction[3] == "0" then
                memory.poke(eid, tonumber(instruction[1]),
                            {signal = {type = "item"}, count = 0})
            else
                memory.poke(eid, tonumber(instruction[1]), {
                    signal = {
                        type = "virtual",
                        name = addons.rpcn[instruction[2]]
                    },
                    count = tonumber(instruction[3])
                })
            end
        elseif game.item_prototypes[item[2]] then
            memory.poke(eid, tonumber(item[1]), {
                signal = {type = "item", name = item[2]},
                count = tonumber(item[3])
            })
        elseif game.virtual_signal_prototypes[virtual[2]] then
            memory.poke(eid, tonumber(virtual[1]), {
                signal = {type = "virtual", name = virtual[2]},
                count = tonumber(virtual[3])
            })
        elseif string.match(line, "^ *#") then
            -- game.print(game.tick.."[color=gray]-"..line.."[/color]")
        else
            -- game.print(game.tick.."[color=red]\""..line.."\"[/color]")
        end
    end
    local gid = global.rgrp[eid]
    for _, fid in pairs(global.grp[gid]) do
        local entity = global.ent[fid]
        if addons.classes[entity.name].on_save_mem then
            -- ²game.print(serpent.line(global.mem[fid]))
            addons.classes[entity.name]
                .on_save_mem(fid, entity, global.mem[fid])
            lib.read_status(fid, false)
            lib.write_status(fid, false)
        end
        if global.rpid[fid] then
            for pi, player in pairs(global.rpid[fid]) do
                global.lpid[pi] = {eid = fid, tick = game.tick + 1}
                player.opened = nil
            end
        end
    end
end
local function add_sxy(s, x, y, i)
    global.sxy = global.sxy or {}
    global.sxy[s] = global.sxy[s] or {}
    global.sxy[s][x] = global.sxy[s][x] or {}
    global.sxy[s][x][y] = global.sxy[s][x][y] or {}
    table.insert(global.sxy[s][x][y], i)
end
local function get_sxy(s, x, y)
    return global.sxy and global.sxy[s] and global.sxy[s][x] and
               global.sxy[s][x][y]
end
local function delete_sxy(s, x, y, i)
    if i then
        for k, v in ipairs(global.sxy[s][x][y]) do
            if v == i then table.remove(global.sxy[s][x][y], k) end
        end
    else
        global.sxy[s][x][y] = {}
    end
    if table_size(global.sxy[s][x][y]) == 0 then global.sxy[s][x][y] = nil end
    if table_size(global.sxy[s][x]) == 0 then global.sxy[s][x] = nil end
    if table_size(global.sxy[s]) == 0 then global.sxy[s] = nil end
end

function lib.remap(entity, mode) -- OK
    local surface = entity.surface.name
    local x = math.floor(entity.position.x)
    local y = math.floor(entity.position.y)
    local eid = entity.unit_number

    local update = {}
    if mode then
        add_sxy(surface, x, y, eid)
        -- add entity to entity db
        global.ent[eid] = entity
        -- add entity to group map
        local gid = eid
        global.grp[gid] = {eid}
        global.rgrp[eid] = gid
        -- add entity to gui map
        global.rpid[eid] = {}
        -- add entity to update map
        update[eid] = true
        -- add adjacent entity to update map
        for _, o in pairs({{0, -1}, {-1, 0}, {1, 0}, {0, 1}}) do
            local ox = x + o[1]
            local oy = y + o[2]
            local oeid = lib.cantorPair(ox, oy)
            if global.ent[oeid] ~= nil then
                if not update[oeid] then update[oeid] = true end
            end
        end
        -- set every entity of these groups to be updated
        local buf = {}
        for ueid, _ in pairs(update) do
            local ugid = global.rgrp[ueid]
            if global.grp[ugid] ~= nil then
                for _, ugeid in pairs(global.grp[ugid]) do
                    table.insert(buf, ugeid)
                end
                global.grp[ugid] = nil
            end
        end
        -- merge groups
        global.grp[gid] = buf
        for _, geid in pairs(global.grp[gid]) do global.rgrp[geid] = gid end
        -- prepare reorganisation
        update = {}
        update[eid] = true
    else
        -- remove entity to entity db (avoid shifting entries)
        global.ent[eid] = nil
        -- remove entity to group map
        local gid = global.rgrp[eid]
        local rgid = global.rgid[eid]
        global.grp[gid][rgid] = nil
        if next(global.grp[gid]) == nil then global.grp[gid] = nil end
        global.rgrp[eid] = nil
        global.rgid[eid] = nil
        -- remove entity to gui map
        global.rpid[eid] = nil
        global.mem[eid] = nil
        -- add adjacent entity to update map
        for _, o in pairs({{0, -1}, {-1, 0}, {1, 0}, {0, 1}}) do
            local ox = x + o[1]
            local oy = y + o[2]
            local oeid = lib.cantorPair(ox, oy)
            if global.ent[oeid] ~= nil then
                if not update[oeid] then update[oeid] = true end
            end
        end
        -- set every entity of these groups to be updated
        local buf = {}
        for ueid, _ in pairs(update) do
            local ugid = global.rgrp[ueid]
            if global.grp[ugid] ~= nil then
                for _, ugeid in pairs(global.grp[ugid]) do
                    table.insert(buf, ugeid)
                end
                global.grp[ugid] = nil
            end
        end
        -- split groups
        for _, bid in pairs(buf) do global.rgrp[bid] = 0 end
        for ueid, _ in pairs(update) do
            if global.rgrp[ueid] == 0 then
                local ugid = ueid
                global.grp[ugid] = global.grp[ugid] or {}
                local ueids = {ueid}
                while #ueids > 0 do
                    local ueid = ueids[1]
                    local sx, sy = lib.cantorUnpair(ueid)
                    table.insert(global.grp[ugid], ueid)
                    global.rgrp[ueid] = ugid
                    for _, o in pairs({{0, -1}, {-1, 0}, {1, 0}, {0, 1}}) do
                        local ox = sx + o[1]
                        local oy = sy + o[2]
                        local oeid = lib.cantorPair(ox, oy)
                        if global.ent[oeid] ~= nil and global.rgrp[oeid] == 0 then
                            table.insert(ueids, oeid)
                            global.rgrp[oeid] = ugid
                        end
                    end
                    table.remove(ueids, 1)
                end
            end
        end
    end
    -- reorganize groups
    local ugids = {}
    for ueid, _ in pairs(update) do
        local ugid = global.rgrp[ueid]
        if ugids[ugid] == nil then ugids[ugid] = true end -- TODO remove condition
    end
    for ugid, _ in pairs(ugids) do
        table.sort(global.grp[ugid], function(a, b)
            local mema = addons.classes[global.ent[a].name].on_load_mem ~= nil
            local memb = addons.classes[global.ent[b].name].on_load_mem
            local posax, posay = lib.cantorUnpair(a)
            local posbx, posby = lib.cantorUnpair(b)
            if mema and not memb then
                return true
            elseif not mema and memb then
                return false
            elseif posay < posby then
                return true
            elseif posay > posby then
                return false
            elseif posax < posbx then
                return true
            else
                return false
            end
        end)
    end
    -- organize rgid db
    for dgid, deids in pairs(global.grp) do
        for rgid, deid in pairs(deids) do global.rgid[deid] = rgid end
    end
    return eid
end

return lib
