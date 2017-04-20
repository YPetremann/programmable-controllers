function prequire(f)
	local s, e=pcall(function()require(f)end)
	if not s then
		if type(e)=="string" then
			print(f..":"..e)
		else
			print(f..": can't load "..modname.."/"..string.gsub(f, "%.", "/")..".lua")
		end
	end
end

require("config")
require("instructions")
require("util")
prequire("interface")
prequire("defines")

local classes = {}

function nop()	end

function cantorPair(x, y) -- OK
	x, y = (x >= 0 and x or (-0.5 - x)), (y >= 0 and y or (-0.5 - y))
	local s = x + y
	local h = s * (s + 0.5) + x
	return h + h
end

function cantorUnpair(z) -- OK
	local w = math.floor((math.sqrt(8 * z + 1) - 1)/2)
	local t = (math.pow(w,2) + w) / 2
	local x = z - t
	local y = w - x
	return (x%2==1 and (-x-1)/2 or x/2),(y%2==1 and (-y-1)/2 or y/2)
end

function tablefind(tbl, el) -- TODO remove -- use of index cache instead of iterative find
	for k,v in pairs(tbl) do
		if v == el then
			return k
		end
	end
	return nil
end

function mergeSignals(red, green) -- TODO remove -- this create new table and need to be avoided
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

function remap(entity, mode) -- OK
	local x = math.floor(entity.position.x)
	local y = math.floor(entity.position.y)
	local eid = cantorPair(x, y)
	local update = {}
	if mode then 
		-- add entity to entity db
		global.ent[eid] = entity
		-- add entity to group map
		local gid = eid
		global.grp[gid] = {eid}
		global.rgrp[eid] = gid
		-- add entity to gui map
		global.rpid[eid] = {}
		-- add entity to update map
		update[eid]=true
		-- add adjacent entity to update map
		for _, o in pairs({{0, -1}, {-1, 0}, {1, 0}, {0, 1}}) do
			local ox = x + o[1]
			local oy = y + o[2]
			local oeid = cantorPair(ox, oy)
			if global.ent[oeid] ~= nil then
				if not update[oeid] then 
					update[oeid]=true
				end
			end
		end
		-- set every entity of these groups to be updated
		local buf = {}
		for ueid, _ in pairs(update) do
			local ugid = global.rgrp[ueid]
			if global.grp[ugid] ~= nil then
				for _, ugeid in pairs(global.grp[ugid]) do
					table.insert(buf,ugeid)
				end
				global.grp[ugid] = nil
			end
		end
		-- merge groups
		global.grp[gid] = buf
		for _, geid in pairs(global.grp[gid]) do
			global.rgrp[geid] = gid
		end
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
			local oeid = cantorPair(ox, oy)
			if global.ent[oeid] ~= nil then
				if not update[oeid] then 
					update[oeid]=true
				end
			end
		end
		-- set every entity of these groups to be updated
		local buf = {}
		for ueid, _ in pairs(update) do
			local ugid = global.rgrp[ueid]
			if global.grp[ugid] ~= nil then
				for _, ugeid in pairs(global.grp[ugid]) do
					table.insert(buf,ugeid)
				end
				global.grp[ugid] = nil
			end
		end
		-- split groups
		for _, bid in pairs(buf) do
			global.rgrp[bid] = 0
		end
		for ueid, _ in pairs(update) do
			if global.rgrp[ueid] == 0 then
				local ugid = ueid
				global.grp[ugid] = global.grp[ugid] or {}
				local ueids = {ueid}
				while #ueids > 0 do
					local ueid = ueids[1]
					local sx, sy = cantorUnpair(ueid)
					table.insert(global.grp[ugid],ueid)
					global.rgrp[ueid] = ugid
					for _, o in pairs({{0, -1}, {-1, 0}, {1, 0}, {0, 1}}) do
						local ox = sx + o[1]
						local oy = sy + o[2]
						local oeid = cantorPair(ox,oy)
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
	--reorganize groups
	local ugids = {}
	for ueid, _ in pairs(update) do
		local ugid = global.rgrp[ueid]
		if ugids[ugid] == nil then ugids[ugid] = true end -- TODO remove condition
	end
	for ugid, _ in pairs(ugids) do
		table.sort(global.grp[ugid], function(a, b)
			local mema = classes[global.ent[a].name].on_load_mem ~= nil
			local memb = classes[global.ent[b].name].on_load_mem
			local posax, posay = cantorUnpair(a)
			local posbx, posby = cantorUnpair(b)
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
	for dgid,deids in pairs(global.grp) do
		for rgid, deid in pairs(deids) do
			global.rgid[deid]=rgid
		end
	end
	return eid
end

function peek(index, addr) -- TODO update --  should not create tables
	local lindex = math.floor(addr/16)+1
	local laddr = addr%16+1
	local lent = global.grp[global.rgrp[index]][lindex]
	if global.mem[lent] == nil and global.ent[lent] ~= nil and classes[global.ent[lent].name].on_load_mem ~= nil then
		global.mem[lent] = classes[global.ent[lent].name].on_load_mem(lent, global.ent[lent])
	end
	if global.mem[lent] ~= nil then
		return global.mem[lent][laddr]
	else
		return {signal={type = "virtual", name = "pci-00"}, count = 0, index = laddr}
	end
end

function poke(index, addr, value)
	local lindex = math.floor(addr/16)+1
	local laddr = addr%16+1
	local lent = global.grp[global.rgrp[index]][lindex]
	if global.mem[lent] == nil and global.ent[lent] ~= nil and classes[global.ent[lent].name].on_load_mem ~= nil then
		global.mem[lent] = classes[global.ent[lent].name].on_load_mem(lent, global.ent[lent])
	end
	if global.mem[lent] ~= nil then
		value.index=laddr
		global.mem[lent][laddr] = value
	end
end

function toscnot(c)
	local sign = c<0
	if sign then c=-c end
	if c < 1000 then
		return (sign and "-" or "")..tostring(c)
	elseif c < 10000 then
		return (sign and "-" or "")..tostring(math.floor(c/1000)).."."..tostring(math.floor(c/100)%10).."k"
	elseif c < 1000000 then
		return (sign and "-" or "")..tostring(math.floor(c/1000)).."k"
	elseif c < 10000000 then
		return (sign and "-" or "")..tostring(math.floor(c/1000000)).."."..tostring(math.floor(c/100000)%10).."M"
	elseif c < 1000000000 then
		return (sign and "-" or "")..tostring(math.floor(c/1000000)).."M"
	elseif c < 10000000000 then
		return (sign and "-" or "")..tostring(math.floor(c/1000000000)).."."..tostring(math.floor(c/100000000)%10).."G"
	elseif c < 1000000000000 then
		return (sign and "-" or "")..tostring(math.floor(c/1000000000)).."G"
	end
end

function DEC_HEX(IN)
	OUT = string.format("%x", IN or 0):upper()
	while #OUT<4 do OUT = "0"..OUT end
	return OUT
end

classes["controller-mem"]={
	on_load_mem=function(index, entity)
		return entity.get_control_behavior().parameters.parameters
	end, 
	on_save_mem=function(index, entity, chunk)
		global.ent[index].get_control_behavior().parameters = {parameters=chunk}
	end, 
}
classes["controller-ext"]={}
classes["controller-pow"]={
	on_built_entity=function(entity)
		entity.power_usage = 1000/60
	end, 
}
classes["controller-con"]={
	on_load_mem=function(index, entity)
		local enabled = entity.get_control_behavior().enabled
		local parameters = entity.get_control_behavior().parameters
		local ret={}
		if not enabled then
			local rednet = entity.get_circuit_network(defines.wire_type.red)
			local grenet = entity.get_circuit_network(defines.wire_type.green)
			rednet = rednet and rednet.signals or {}
			grenet = grenet and grenet.signals or {}
			local net = mergeSignals(rednet, grenet)
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
				item.signal.type = "virtual"
				item.signal.name = "pci-00"
				item.count = 0
			end
			table.insert(ret, {t=item.signal.type, s=item.signal.name, c=item.count})
		end
		return parameters.parameters
	end, 
	on_save_mem=function(index, entity, chunk)
		global.ent[index].get_control_behavior().parameters = {parameters=chunk}
	end, 
}
classes["controller-cpu"]={
	on_gui_create=function(index, entity, player)
		local gui = player.gui.left.add{type="frame", name="pci-cpu-"..index, direction="vertical", caption="CPU"}
		gui.add{type="progressbar", name="cycles", size=128, value=0}
		gui.add{type="scroll-pane", name="log", direction="vertical", caption=category}
		gui.log.vertical_scroll_policy="auto"
		gui.log.horizontal_scroll_policy="never"
		gui.log.style.maximal_height=900
		gui.add{type="scroll-pane", name="mem", direction="vertical", caption=category}
		gui.mem.vertical_scroll_policy="auto"
		gui.mem.horizontal_scroll_policy="never"
		gui.mem.style.maximal_height=500
	end, 
	on_gui_destroy=function(index, entity, player)
		player.gui.left["pci-cpu-"..index].destroy()
	end, 
	on_built_entity=function(entity)
		entity.get_control_behavior().enabled=false
		parameters = entity.get_control_behavior().parameters
		parameters.parameters[1]={signal={type="virtual", name="pci-00"}, count=0, index=1}
		parameters.parameters[2]={signal={type="virtual", name="pci-10"}, count=3, index=2}
		parameters.parameters[3]={signal={type="virtual", name="pci-00"}, count=0, index=3}
		entity.get_control_behavior().parameters=parameters
	end, 
	on_tick=function(eid, entity, energy)
		local cycles = 0
		local power = config.power
		local grp = global.rgrp[eid]
		if entity.get_control_behavior().enabled and energy[grp] ~= nil and energy[grp][1] > power then
			o = (global.rgid[eid]-1)*16
			pointer = peek(eid, o+1).count
			brk = false
			while true do
				cycles = cycles + 1
				if energy[grp][1] < power then break end
				i = peek(eid, pointer)
				pointer = pointer+1
				local inst = i.signal.name
				if i ~= nil and pci[inst] ~= nil then
					pci[inst](eid, i.count)
					energy[grp][1] = energy[grp][1] - power
				end
				if cycles >= config.cpt then break end
				if brk then break end
			end
			poke(eid, o+1, {signal={type="virtual", name="pci-10"}, count=pointer, eid=2})
			state = peek(eid, o)
			entity.get_control_behavior().enabled = state.signal.name ~= "pci-0E" and state.signal.name ~= "pci-0F"
		end
		for pi, player in pairs(global.rpid[eid]) do
			local gui = player.gui.left["pci-cpu-"..eid]
			gui.cycles.value = cycles/config.cpt
		end
	end,
	on_load_mem=function(eid, entity)
		return entity.get_control_behavior().parameters.parameters
	end, 
	on_save_mem=function(eid, entity, chunk)
		entity.get_control_behavior().parameters = {parameters=chunk}
	end, 
	on_removed_entity=function(entity) end, 
}

local function on_built_entity(event) -- OK
	local entity = event.created_entity
	if classes[entity.name] ~= nil then
		remap(entity, true)
		if classes[entity.name].on_built_entity then
			classes[entity.name].on_built_entity(entity)
		end
		print(serpent.dump(global.rpid))
	end
end

local function on_removed_entity(event) -- OK
	local entity = event.entity
	if classes[entity.name] ~= nil then
		if classes[entity.name].on_removed_entity ~= nil then
			classes[entity.name].on_removed_entity(entity)
		end
		remap(entity, false)
	end
end

local function on_tick(event)
	energy = {}
	-- pre tick (energy and memory)
	for eid, entity in pairs(global.ent) do
		if entity.valid then
			if entity.name == "controller-pow" then
				local grp = global.rgrp[eid]
				energy[grp] = energy[grp] or {0,0}
				energy[grp][1] = energy[grp][1] + entity.energy
				energy[grp][2] = energy[grp][2] + 1
			elseif entity.name == "controller-con" or global.mcr[eid] then
				global.mem[eid] = nil
			end
		end
	end
	-- handle tick entity
	for eid, entity in pairs(global.ent) do
		if entity.valid and classes[entity.name].on_tick ~= nil then
			classes[entity.name].on_tick(eid, entity, energy)
		end
	end
	-- handle gui
	for _, player in pairs(game.players) do
		local pid = player.index
		local entity = player.opened
		if entity ~= nil and global.rgid[pid] == nil then
			-- just opened
			local x = math.floor(entity.position.x)
			local y = math.floor(entity.position.y)
			local eid = cantorPair(x, y)
			if global.rpid[eid] ~= nil then
				global.rpid[eid][pid] = player
				global.rgid[pid]=eid
				global.mcr[eid]=true
				global.mcw[eid]=true
				if classes[entity.name].on_gui_create ~= nil then
					classes[entity.name].on_gui_create(eid, entity, player)
				end
			end
		elseif entity == nil and global.rgid[pid] ~= nil then
			local eid = global.rgid[pid]
			local entity = global.ent[eid]
			global.mcr[eid]=false
			global.mcw[eid]=false
			if classes[entity.name].on_gui_destroy ~= nil then
				classes[entity.name].on_gui_destroy(eid, entity, player)
			end
			global.rpid[eid][pid] = nil
			global.rgid[pid]=nil
		end
	end
	-- save data and set energy
	for eid, chunk in pairs(global.mem) do
		local entity = global.ent[eid]
		if entity.name == "controller-con" or global.mcw[eid] then
			classes[entity.name].on_save_mem(eid, entity, chunk)
		end
	end
	-- set energy
	for eid, entity in pairs(global.ent) do
		if entity.name == "controller-pow" then
			local grp = global.rgrp[eid]
			local egrp = energy[grp] or {0,0}
			entity.energy = egrp[1]/egrp[2]
		end
	end
end
local function on_init()
	global.ent  = global.ent  or {} -- [eid] => entity         -- OK
	global.grp  = global.grp  or {} -- [gid] => {rgid=eid ...} -- OK
	global.rgrp = global.rgrp or {} -- [eid] => gid            -- OK
	global.rgid = global.rgid or {} -- [eid] => rgid           -- OK
	global.rpid = global.rpid or {} -- [eid] => {pid=peo ...}  -- OK
	global.pgid = global.pgid or {} -- [pid] => eid            -- OK
	global.mem  = global.mem  or {} -- [eid] => {sl ...}       -- OK
	global.mcr  = global.mcr  or {} -- [eid] => cacheread      -- OK
	global.mcw  = global.mcw  or {} -- [eid] => cachewrite     -- OK
end

local function on_load() end

script.on_init(on_init)
script.on_load(on_load)
script.on_configuration_changed(on_init)
script.on_event(defines.events.on_tick, on_tick)
script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_event(defines.events.on_robot_built_entity, on_built_entity)
script.on_event(defines.events.on_preplayer_mined_item, on_removed_entity)
script.on_event(defines.events.on_robot_pre_mined, on_removed_entity)
script.on_event(defines.events.on_entity_died, on_removed_entity)
