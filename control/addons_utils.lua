require("__programmable-controllers__.control.table")

local lib = {}

function lib.add_hardwares(data, hard)
   data.classes = data.classes or {}
   table.merge(data.classes, hard)
end

function lib.add_instructions(data, soft)
   data.pci = data.pci or {}
   data.pcn = data.pcn or {}
   data.pco = data.pco or {}
   data.pcg = data.pcg or {}
   data.pcl = data.pcl or {}
   data.rpcn = data.rpcn or {}
   for id, v in pairs(soft) do
      if v.func then
         data.pci[id] = v.func
      end
      if v.name then
         data.pcn[id] = v.name
         data.rpcn[v.name] = id
      end
      if v.order then
         data.pco[id] = v.order
      end
      if v.icon then
         data.pcg[id] = v.icon
      end
      if v.locale then
         data.pcl[id] = v.locale
      end
   end
end

function lib.add_documentation(data, docs)
   data.docs = data.docs or {}
   table.merge(data.docs, docs)
end

return lib
