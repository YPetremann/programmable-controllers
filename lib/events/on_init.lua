local lib = {}
local local_handlers = {}
local on_pre_event = require("lib.events.on_pre_event")

function lib.bind(event)
   script.on_init(lib.handler)
   lib.bind = nil
end

function lib.handler()
   local event = {name = -1}
   on_pre_event.handler(event)
   for _, func in ipairs(local_handlers) do
      func(event)
   end
end

function lib.register(event)
   table.insert(local_handlers, event.handler)
end

function lib.unregister(event)
   local handler = event.handler
   for i, registered in ipairs(local_handlers) do
      if registered == handler then
         table.remove(local_handlers, i)
         return true
      end
   end
end

return lib
