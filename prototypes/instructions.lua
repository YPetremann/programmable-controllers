print("==== ====")
local ee = string.char(27)
local datas = require("addons.programmable-controllers")
local files = {}
if not pcall(
   function()
      files = require "files"
   end
) then
   print(ee .. "[31m - can't load file list")
end
for id, name in pairs(datas.pcn) do
   local warn = nil
   local error = nil
   if not datas.pcn[id] then
      error = "name missing"
   end
   if not datas.pci[id] then
      error = "func missing"
   end
   if not datas.pco[id] then
      error = "order missing"
   end
   if not datas.pcg[id] then
      warn = "icon definition missing"
   end
   if not datas.pcl[id] then
      warn = "locale definition missing"
   end
   local icon = "__programmable-controllers__/graphics/icons/instructions/" .. id .. ".png"
   if not files[icon] then
      error = "icon missing : " .. icon
   end
   if not error then
      local subgroup, order = string.match(datas.pco[id], "(.+):(.+)")
      if string.find("01234567WX", order) then
         subgroup = subgroup .. "+"
      end
      if string.find("89ABCDEFYZ", order) then
         subgroup = subgroup .. "-"
      end
      -- adding subgroup
      if data.raw["item-subgroup"][subgroup] == nil then
         data:extend{
            {type = "item-subgroup", group = "programmable-controllers", name = subgroup, order = "i" .. subgroup},
         }
      end
      -- adding instruction
      data:extend{{type = "virtual-signal", name = id, icon = icon, icon_size = 64, subgroup = subgroup, order = order}}
      if warn then
         print(ee .. "[32m - added " .. id .. " : " .. warn)
      else
         print(ee .. "[32m - added " .. id)
      end
   else
      print(ee .. "[31m - can't add " .. id .. " : " .. error)
   end
end
print("==== ====")
