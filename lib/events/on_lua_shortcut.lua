local lib = {}
local handlers_general = {}
local handlers_by_name = {}
local on_pre_event = require("lib.events.on_pre_event")

function lib.bind(event)
   script.on_event(defines.events.on_lua_shortcut, lib.handler)
   lib.bind = nil
end

function lib.handler(event)
   on_pre_event.handler(event)
   for _, func in ipairs(handlers_general) do
      func(event)
   end
   if handlers_by_name[event.prototype_name] then
      for _, func in ipairs(handlers_by_name[event.prototype_name]) do
         func(event)
      end
   end
end

function lib.register(event)
   local shortcut_name = event.prototype_name
   local local_handlers = handlers_general
   if shortcut_name then
      handlers_by_name[shortcut_name] = handlers_by_name[shortcut_name] or {}
      local_handlers = handlers_by_name[shortcut_name]
   end
   table.insert(local_handlers, event.handler)
end

function lib.unregister(event)
   local handler = event.handler
   for i, registered in ipairs(lib.events[event.name]) do
      if registered == handler then
         table.remove(lib.events[event.name], i)
         return true
      end
   end
end
return lib
