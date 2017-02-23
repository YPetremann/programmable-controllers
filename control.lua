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
function dbg_log(category, message)
	if config.debug then
		for _, player in pairs(game.players) do
			if player.gui.left.debug == nil then
				player.gui.left.add{type="flow", name="debug", direction="vertical"}
			end
			if player.gui.left.debug[category] == nil then
				player.gui.left.debug.add{type="frame", name=category, direction="vertical", caption=category}
				player.gui.left.debug[category].add{type="scroll-pane", name="log", direction="vertical", caption=category}
				player.gui.left.debug[category].log.vertical_scroll_policy="auto"
				player.gui.left.debug[category].log.horizontal_scroll_policy="never"
				player.gui.left.debug[category].log.style.maximal_height=900
			end
			if player.gui.left.debug[category].log["end"] ~= nil then
				player.gui.left.debug[category].log["end"].destroy()
			end
			n=tostring(#player.gui.left.debug[category].log.children_names+1)
			player.gui.left.debug[category].log.add{type="label", name=n, direction="vertical", caption=message}
			player.gui.left.debug[category].log[n].style.minimal_height=8
			player.gui.left.debug[category].log[n].style.maximal_height=8
			player.gui.left.debug[category].log[n].style.bottom_padding=0
			player.gui.left.debug[category].log[n].style.top_padding=0
			player.gui.left.debug[category].log.add{type="label", name="end", direction="vertical", caption=" "}
			player.gui.left.debug[category].log["end"].style.minimal_height=5
			player.gui.left.debug[category].log["end"].style.maximal_height=5
			player.gui.left.debug[category].log[n].style.bottom_padding=0
			player.gui.left.debug[category].log[n].style.top_padding=0
		end
	end
end
function dbg_clr(category)
	for _, player in pairs(game.players) do
		if player.gui.left.debug ~= nil then
			if player.gui.left.debug[category] ~= nil then
				player.gui.left.debug[category].destroy()
			end
		end
	end
end

local classes = {}

function tablefind(tbl, el)
	for k,v in pairs(tbl) do
		if v == el then
			return k
		end
	end
	return nil
end
local function getArea(pos, offset, radius)
	return {{pos.x-radius+offset.x, pos.y-radius+offset.y}, {pos.x+radius+offset.x, pos.y+radius+offset.y}}
end
local function ttostring(tab)
	local res=""
	if type(tab)=="table" then
		res="{"
		for k, v in pairs(tab) do
			res=res..tostring(k).." = "..ttostring(v)..", "
		end
		res=res.."}"
	else
		res=tostring(tab)
	end
	return res
end
function mergeSignals(red, green)
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
function remap(entity, index, mode)
	local x = math.floor(entity.position.x)
	local y = math.floor(entity.position.y)
	local update = {}
	if mode then
		-- add entity to entity db (reassigning unused id)
		index = 1
		while global.ent[index] ~= nil do index = index + 1 end
		global.ent[index] = entity
		-- add entity to group map
		local gid = 1
		while global.grp[gid] ~= nil do gid = gid + 1 end
		global.grp[gid] = {index}
		global.rgrp[index] = gid
		-- add entity index to entity map
		global.map = global.map or {}
		global.map[x] = global.map[x] or {}
		global.map[x][y] = index
		global.rmap[index] = {x, y}
		-- add entity to update map
		table.insert(update, index)
	else
		-- remove entity to entity db (avoid shifting entries)
		global.ent[index]=nil
		-- remove entity to group map
		local gid = global.rgrp[index]
		local gindex = tablefind(global.grp[gid], index)
		global.grp[gid][gindex] = nil
		if next(global.grp[gid]) == nil then global.grp[gid] = nil end
		global.rgrp[index] = nil
		-- remove entity index to entity map
		global.map[x][y] = nil
		global.rmap[index] = nil
		if next(global.map[x]) == nil then global.map[x] = nil end
	end
	-- add adjacent entity to update map
	for _, o in pairs({{0, -1}, {-1, 0}, {1, 0}, {0, 1}}) do
		local ox = x + o[1]
		local oy = y + o[2]
		if global.map[ox] ~= nil and global.map[ox][oy] ~= nil then
			local id = global.map[ox][oy]
			if not tablefind(update, id) then 
				table.insert(update, id)
			end
		end
	end
	-- set every entity of these groups to be updated
	local buf = {}
	for _, i in pairs(update) do
		local g = global.rgrp[i]
		if global.grp[g] ~= nil then
			for __, k in pairs(global.grp[g]) do
				table.insert(buf, k)
			end
			global.grp[g] = nil
		end
	end
	-- merge or split groups
	if mode then
		local gid = 1
		while global.grp[gid] ~= nil do gid = gid + 1 end
		global.grp[gid] = buf
		update = {index}
		for _, i in pairs(global.grp[gid]) do
			global.rgrp[i] = gid
		end
	else
		for _, i in pairs(buf) do
			global.rgrp[i] = 0
		end
		for k, v in pairs(update) do
			if global.rgrp[v] == 0 then
				local gid = 1
				while global.grp[gid] ~= nil do gid = gid + 1 end
				global.grp[gid] = global.grp[gid] or {}
				local current = {global.rmap[v]}
				while #current > 0 do
					local sx = current[1][1]
					local sy = current[1][2]
					local li = global.map[sx][sy]
					table.insert(global.grp[gid], li)
					global.rgrp[li] = gid
					for _, o in pairs({{0, -1}, {-1, 0}, {1, 0}, {0, 1}}) do
						local ox = sx + o[1]
						local oy = sy + o[2]
						if global.map[ox] ~= nil and 
								global.map[ox][oy] ~= nil and
								global.rgrp[global.map[ox][oy]] == 0 then
							table.insert(current, {ox, oy})
							global.rgrp[global.map[ox][oy]] = gid
						end
					end
					table.remove(current, 1)
				end
			end
		end
	end
	--reorganize groups
	local grp = {}
	for _, i in pairs(update) do
		local g = global.rgrp[i]
		if grp[g] == nil then grp[g] = true end
	end
	for g, _ in pairs(grp) do
		table.sort(global.grp[g], function(a, b)
			local mema = classes[global.ent[a].name].on_load_mem ~= nil
			local memb = classes[global.ent[b].name].on_load_mem
			if mema and not memb then
				return true
			elseif not mema and memb then
				return false
			elseif global.rmap[a][2] < global.rmap[b][2] then
				return true
			elseif global.rmap[a][2] > global.rmap[b][2] then
				return false
			elseif global.rmap[a][1] < global.rmap[b][1] then
				return true
			else
				return false
			end
		end)
	end
	return tablefind(global.ent, entity)
end
function peek(index, addr)
	local lindex = math.floor(addr/16)+1
	local laddr = addr%16+1
	local lent = global.grp[global.rgrp[index]][lindex]
	if memory[lent] == nil and global.ent[lent] ~= nil and classes[global.ent[lent].name].on_load_mem ~= nil then
		memory[lent] = classes[global.ent[lent].name].on_load_mem(lent, global.ent[lent])
	end
	if memory[lent] ~= nil then
		return memory[lent][laddr]
	else
		return {t = "virtual", s = "pci-00", c = 0}
	end
end
function poke(index, addr, value)
	local lindex = math.floor(addr/16)+1
	local laddr = addr%16+1
	local lent = global.grp[global.rgrp[index]][lindex]
	if memory[lent] == nil and global.ent[lent] ~= nil and classes[global.ent[lent].name].on_load_mem ~= nil then
		memory[lent] = classes[global.ent[lent].name].on_load_mem(lent, global.ent[lent])
	end
	if memory[lent] ~= nil then
		memory[lent][laddr] = value
	end
end
function DEC_HEX(IN)
	OUT = string.format("%x", IN or 0):upper()
	while #OUT<4 do OUT = "0"..OUT end
	return OUT
end
classes["controller-mem"]={
	on_load_mem=function(index, entity)
		local parameters = entity.get_control_behavior().parameters
		local ret={}
		for _, item in pairs(parameters.parameters) do
			if item.signal.name == nil then
				item.signal.type = "virtual"
				item.signal.name = "pci-00"
				item.count = 0
			end
			table.insert(ret, {t=item.signal.type, s=item.signal.name, c=item.count})
		end
		return ret
	end, 
	on_save_mem=function(index, entity, chunk)
		for i, k in pairs(chunk) do
			chunk[i]={signal={type=k.t, name=k.s}, count=k.c, index=i}
		end
		global.ent[index].get_control_behavior().parameters = {parameters=chunk}
	end, 
}
classes["controller-ext"]={}
classes["controller-pow"]={
	on_built_entity=function(index, entity)
		entity.power_usage = 1000/60
	end, 
}
classes["controller-con"]={
	on_load_mem=function(index, entity)
		local enabled = entity.get_control_behavior().enabled
		local parameters = entity.get_control_behavior().parameters
		local ret={}
		if not enabled then
			local rednet = {}
			local grenet = {}
			if entity.get_circuit_network(defines.wire_type.red) then
				rednet = entity.get_circuit_network(defines.wire_type.red).signals 
			end
			if entity.get_circuit_network(defines.wire_type.green) then
				local grenet = entity.get_circuit_network(defines.wire_type.green).signals
			end
			local net = mergeSignals(rednet, grenet)
			for k, s in pairs(parameters.parameters) do
				local stype = s.signal.type
				local sname = s.signal.name
				if sname ~= nil then
					if net[stype] ~= nil and net[stype][sname] ~= nil then
						parameters.parameters[k].count = net[stype][sname]
					else
						parameters.parameters[k].count = 0
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
		return ret
	end, 
	on_save_mem=function(index, entity, chunk)
		for i, k in pairs(chunk) do
			chunk[i]={signal={type=k.t, name=k.s}, count=k.c, index=i}
		end
		global.ent[index].get_control_behavior().parameters = {parameters=chunk}
	end, 
}
classes["controller-cpu"]={
	on_gui_create=function(index, entity, player)
		local gui = player.gui.left.add{type="frame", name="pci-cpu-"..index, direction="vertical", caption="CPU"}
		gui.add{type="progressbar", name="cycles", size=100, value=0}
		gui.add{type="scroll-pane", name="log", direction="vertical", caption=category}
		gui.log.vertical_scroll_policy="auto"
		gui.log.horizontal_scroll_policy="never"
		gui.log.style.maximal_height=900
		local lines = {}
		table.insert(lines,"id: "..index)
		table.insert(lines,"group: "..global.rgrp[index])
		local grp = global.grp[global.rgrp[index]]
		for k,v in pairs(grp) do
			table.insert(lines," - ["..DEC_HEX(k).."] "..v.." ("..global.rmap[v][1]..","..global.rmap[v][2]..") "..global.ent[v].name)
		end
		table.insert(lines,"type: "..global.ent[index].name)
		local n = 1
		for _,line in pairs(lines) do
			local label = gui.log.add{type="label", name=n, direction="vertical", caption=line}
			label.style.minimal_height = 8
			label.style.maximal_height = 8
			label.style.bottom_padding = 0
			label.style.top_padding = 0
			n = n + 1
		end
		local	nd = gui.log.add{type="label", name="end", direction="vertical", caption=" "}
		nd.style.minimal_height=5
		nd.style.maximal_height=5
		nd.style.bottom_padding=0
		nd.style.top_padding=0
	end, 
	on_gui_destroy=function(index, entity, player)
		player.gui.left["pci-cpu-"..index].destroy()
	end, 
	on_built_entity=function(index, entity)
		entity.get_control_behavior().enabled=false
		parameters = entity.get_control_behavior().parameters
		parameters.parameters[1]={signal={type="virtual", name="pci-00"}, count=0, index=1}
		parameters.parameters[2]={signal={type="virtual", name="pci-10"}, count=3, index=2}
		parameters.parameters[3]={signal={type="virtual", name="pci-00"}, count=0, index=3}
		entity.get_control_behavior().parameters=parameters
	end, 
	on_tick=function(index, entity, energy, memory)
		local cycles = 0
		local power = config.power
		local grp = global.rgrp[index]
		if entity.get_control_behavior().enabled and energy[grp] ~= nil and energy[grp][1] > power then
			o = (tablefind(global.grp[global.rgrp[index]], index)-1)*16
			pointer = peek(index, o+1).c
			brk = false
			for _=0, config.cpt-1, 1 do
				cycles = cycles + 1
				if energy[grp][1] < power then break end
				i = peek(index, pointer)
				pointer=pointer+1
				if i ~= nil and pci[i.s] ~= nil then
					pci[i.s](index, i.c)
					energy[grp][1] = energy[grp][1] - power
				end
				if brk then break end
			end
			poke(index, o+1, {t="virtual", s="pci-10", c=pointer})
			state = peek(index, o)
			entity.get_control_behavior().enabled = state.s ~= "pci-0E" and state.s ~= "pci-0F"
		end
		if global.rgui[index] then
			for _,pi in pairs(global.rgui[index]) do
				local gui = game.players[pi].gui.left["pci-cpu-"..index]
				gui.cycles.value = cycles/config.cpt
			end
		end
	end,
	on_load_mem=function(index, entity)
		local parameters = entity.get_control_behavior().parameters
		local enabled = entity.get_control_behavior().enabled
		local ret={}
		for _, item in pairs(parameters.parameters) do
			if item.signal.name == nil then
				item.signal.type = "virtual"
				item.signal.name = "pci-00"
				item.count = 0
			end
			table.insert(ret, {t=item.signal.type, s=item.signal.name, c=item.count})
		end
		return ret
	end, 
	on_save_mem=function(index, entity, chunk)
		for i, k in pairs(chunk) do
			chunk[i]={signal={type=k.t, name=k.s}, count=k.c, index=i}
		end
		global.ent[index].get_control_behavior().parameters = {parameters=chunk}
	end, 
	on_removed_entity=function(index) end, 
}

local function on_built_entity(event)
	local entity = event.created_entity
	if classes[entity.name] ~= nil then
		local index = remap(entity, nil, true)
		if classes[entity.name].on_built_entity ~= nil then
			classes[entity.name].on_built_entity(index, entity)
		end
	end
end
local function on_removed_entity(event)
	local entity = event.entity
	if classes[entity.name] ~= nil then
		local index = tablefind(global.ent, entity)
		if classes[entity.name].on_removed_entity ~= nil then
			classes[entity.name].on_removed_entity(index)
		end
		remap(entity, index, false)
	end
end

local function on_tick(event)
	energy = {}
	memory = {}
	-- get energy
	for index, entity in pairs(global.ent) do
		if entity.valid and entity.name == "controller-pow" then
			local grp = global.rgrp[index]
			energy[grp] = energy[grp] or {0,0}
			energy[grp][1] = energy[grp][1] + entity.energy
			energy[grp][2] = energy[grp][2] + 1
		end
	end
	-- handle tick entity
	for index, entity in pairs(global.ent) do
		if entity.valid and classes[entity.name].on_tick ~= nil then
			classes[entity.name].on_tick(index, entity, energy, memory)
		end
	end
	--]]
	-- save data
	for index, chunk in pairs(memory) do
		classes[global.ent[index].name].on_save_mem(index, global.ent[index], chunk)
	end
	--]]
	-- set energy
	for index, entity in pairs(global.ent) do
		if entity.valid and entity.name == "controller-pow" then
			local egrp = energy[global.rgrp[index]]
			entity.energy = egrp[1]/egrp[2]
		end
	end
	-- handle gui
	for _, player in pairs(game.players) do
		local pi = player.name
		local entity = player.opened
		if entity ~= nil and global.gui[pi] == nil then
			local ei = tablefind(global.ent, entity)
			if ei ~= nil then
				global.gui[pi]={id=ei}
				global.rgui[ei] = global.rgui[ei] or {}
				table.insert(global.rgui[ei],pi)
				if classes[entity.name].on_gui_create ~= nil then
					classes[entity.name].on_gui_create(ei, entity, player)
				end
			end
		elseif entity == nil and global.gui[pi] ~= nil then
			local ei = global.gui[pi].id
			local entity = global.ent[ei]
			if classes[entity.name].on_gui_destroy ~= nil then
				classes[entity.name].on_gui_destroy(ei, entity, player)
			end
			table.remove(global.rgui[ei],tablefind(global.rgui[ei], pi))
			if #global.rgui[ei] == 0 then global.rgui[ei] = nil end
			global.gui[pi] = nil
		end
	end
end
local function on_init()
	global.ent  = global.ent  or {}
	global.map  = global.map  or {}
	global.rmap = global.rmap or {}
	global.grp  = global.grp  or {}
	global.rgrp = global.rgrp or {}
	global.gui  = global.gui  or {}
	global.rgui = global.rgui or {}
end
local function on_init()
	game.write_file('logs/pci/debug.log', "start log\n", false)
end


script.on_init(on_init)
script.on_load(on_load)
script.on_configuration_changed(on_init)
script.on_event(defines.events.on_tick, on_tick)
script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_event(defines.events.on_robot_built_entity, on_built_entity)
script.on_event(defines.events.on_preplayer_mined_item, on_removed_entity)
script.on_event(defines.events.on_robot_pre_mined, on_removed_entity)
script.on_event(defines.events.on_entity_died, on_removed_entity)
