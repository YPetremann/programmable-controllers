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
function lib.add_sxy(s, x, y, i)
    global.rsxy = global.rsxy or {}
    global.rsxy[i] = {s = s, x = x, y = y, i = i}

    global.sxy = global.sxy or {}
    global.sxy[s] = global.sxy[s] or {}
    global.sxy[s][x] = global.sxy[s][x] or {}
    global.sxy[s][x][y] = global.rsxy[i]
end
function lib.get_sxy(s, x, y, i)
    if i and s == nil or x == nil or y == nil then
        return global.rsxy and global.rsxy[i]
    else
        return global.sxy and global.sxy[s] and global.sxy[s][x] and
                   global.sxy[s][x][y]
    end
end
function lib.delete_sxy(s, x, y, i)
    if i and s == nil or x == nil or y == nil then
        local l = global.rsxy[i]
        s = l.s
        x = l.x
        y = l.y
    else
        i = global.sxy[s][x][y]
    end

    global.sxy[s][x][y] = nil
    if table_size(global.sxy[s][x]) == 0 then global.sxy[s][x] = nil end
    if table_size(global.sxy[s]) == 0 then global.sxy[s] = nil end
    global.rsxy[i] = nil
end

function lib.remap(entity, mode) -- OK
    print("=== on_removed_entity")
    local surface = entity.surface.name
    local x = math.floor(entity.position.x)
    local y = math.floor(entity.position.y)
    local eid = entity.unit_number

    local update = {}
    if mode then
        lib.add_sxy(surface, x, y, eid)
        -- add entity to group map
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
        for _, offset in pairs({{0, -1}, {-1, 0}, {1, 0}, {0, 1}}) do
            local offset_x = x + offset[1]
            local offset_y = y + offset[2]
            local offset = lib.get_sxy(surface, offset_x, offset_y)
            if offset and offset.i and global.ent[offset.i] and
                not update[offset.i] then update[offset.i] = true end
        end
        -- set every entity of these groups to be updated
        local buf = {}
        for update_eid, _ in pairs(update) do
            local update_gid = global.rgrp[update_eid]
            if global.grp[update_gid] then
                for _, update_group_eid in pairs(global.grp[update_gid]) do
                    table.insert(buf, update_group_eid)
                end
                global.grp[update_gid] = nil
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
        table.remove(global.grp[gid], rgid)
        if next(global.grp[gid]) == nil then global.grp[gid] = nil end
        global.rgrp[eid] = nil
        global.rgid[eid] = nil
        -- remove entity to gui map
        global.rpid[eid] = nil
        global.mem[eid] = nil
        lib.delete_sxy(surface, x, y, eid)
        -- add adjacent entity to update map
        for _, offset in pairs({{0, -1}, {-1, 0}, {1, 0}, {0, 1}}) do
            local offset_x = x + offset[1]
            local offset_y = y + offset[2]
            local offset_eid = lib.get_sxy(surface, offset_x, offset_y)
            if offset_eid and global.ent[offset_eid] and not update[offset_eid] then
                update[offset_eid] = true
            end
        end
        -- set every entity of these groups to be updated
        local buf = {}
        for update_eid, _ in pairs(update) do
            local update_gid = global.rgrp[update_eid]
            if global.grp[update_gid] ~= nil then
                for _, update_group_eid in pairs(global.grp[update_gid]) do
                    table.insert(buf, update_group_eid)
                end
                global.grp[update_gid] = nil
            end
        end
        -- split groups
        for _, buf_id in pairs(buf) do global.rgrp[buf_id] = 0 end
        for update_eid, _ in pairs(update) do
            if global.rgrp[update_eid] == 0 then
                local update_gid = update_eid
                global.grp[update_gid] = global.grp[update_gid] or {}
                local update_eids = {update_eid}
                while #update_eids > 0 do
                    local update_eid = update_eids[1]
                    local update_pos = lib.get_sxy(nil, nil, nil, update_eid)
                    table.insert(global.grp[update_gid], update_eid)
                    global.rgrp[update_eid] = update_gid
                    for _, o in pairs({{0, -1}, {-1, 0}, {1, 0}, {0, 1}}) do
                        local ox = update_pos.x + o[1]
                        local oy = update_pos.y + o[2]
                        local oeid = lib.get_sxy(surface, ox, oy)
                        if global.ent[oeid] ~= nil and global.rgrp[oeid] == 0 then
                            table.insert(update_eids, oeid)
                            global.rgrp[oeid] = update_gid
                        end
                    end
                    table.remove(update_eids, 1)
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
            local posa = lib.get_sxy(nil, nil, nil, a)
            local posb = lib.get_sxy(nil, nil, nil, b)
            if mema and not memb then
                return true
            elseif not mema and memb then
                return false
            elseif posa.y < posb.y then
                return true
            elseif posa.y > posb.y then
                return false
            elseif posa.x < posb.x then
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
