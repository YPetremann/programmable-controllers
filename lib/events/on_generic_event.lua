local lib = {}
lib.events = {}
lib.events_code = {}
local on_pre_event = require("lib.events.on_pre_event")

local function get_events_code(name)
   if defines.events[name] then
      return defines.events[name]
   else
      if not lib.events_code[name] then
         lib.events_code[name] = script.generate_event_name()
      end
      return lib.events_code[name]
   end
end

function lib.bind(event)
   if lib.events[event.name] then
      return
   end
   lib.events[event.name] = lib.events[event.name] or {}
   local name = event.name
   local local_handlers = lib.events[name]
   local function handler(e)
      on_pre_event.handler(e)
      for _, func in ipairs(local_handlers) do
         func(e)
      end
   end
   script.on_event(get_events_code(name), handler)
end
function lib.register(event)
   local name = event.name
   local handler = event.handler
   local local_handlers = lib.events[name]
   table.insert(local_handlers, handler)
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
if __DebugAdapter then
   __DebugAdapter.stepIgnore(lib.bind)
   __DebugAdapter.stepIgnore(lib.register)
   __DebugAdapter.stepIgnore(lib.unregister)
end
return lib
