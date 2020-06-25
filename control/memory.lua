local config = require("__programmable-controllers__.config")
local addons = require("__programmable-controllers__.control.addon_base")

local lib = {}

function lib.peek(index, addr) -- TODO update --  should not create tables
   local lindex = math.floor(addr / config.blocksize) + 1
   local laddr = addr % config.blocksize + 1
   local lent = global.grp[global.rgrp[index]][lindex]
   if global.mem[lent] == nil and global.ent[lent] ~= nil and addons.classes[global.ent[lent].name].on_load_mem ~= nil then
      global.mem[lent] = addons.classes[global.ent[lent].name].on_load_mem(lent, global.ent[lent])
   end
   if global.mem[lent] ~= nil and global.mem[lent][laddr] ~= nil then
      return global.mem[lent][laddr]
   else
      return {signal = {type = "item"}, count = 0, index = laddr}
   end
end

function lib.poke(index, addr, value)
   local lindex = math.floor(addr / config.blocksize) + 1
   local laddr = addr % config.blocksize + 1
   local lent = global.grp[global.rgrp[index]][lindex]
   if global.mem[lent] == nil and global.ent[lent] ~= nil and addons.classes[global.ent[lent].name].on_load_mem ~= nil then
      global.mem[lent] = addons.classes[global.ent[lent].name].on_load_mem(lent, global.ent[lent])
   end
   if global.mem[lent] ~= nil then
      value.index = laddr
      global.mem[lent][laddr] = value
   end
end

return lib
