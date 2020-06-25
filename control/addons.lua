-- lib.pcn = {}
-- lib.pci = {}
require("control.table")
local datas = require("__programmable-controllers__.control.addon_base")

local ret = nil
local function prequire(name)
   ret = require(name)
end

for name, version in pairs(script.active_mods) do
   if pcall(prequire, "__" .. name .. "__.addons." .. script.mod_name) then
      table.merge(datas, ret)
   end
end

return datas
