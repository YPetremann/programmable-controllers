local lib = {}
local local_handlers = {}
local on_pre_event = require("lib.events.on_pre_event")

function lib.bind()
end

function lib.register(event)
   table.insert(local_handlers, event.handler)
   local tick_handlers = local_handlers[event.tick]
   local tick_cycle = event.cycle == true or event.cycle == "repeat"
   local function handler(event)
      event.name = -4
      on_pre_event.handler(event)
      for _, func in ipairs(tick_handlers) do
         func(event)
      end
      if not tick_cycle then
         lib.unregister(event)
      end
   end
   script.on_nth_tick(event.tick, handler)
end

function lib.unregister(event)
   local handler = event.handler
   for t, _ in pairs(local_handlers) do
      if event.tick then
         t = event.tick
      end
      for i, registered in ipairs(local_handlers[t]) do
         if registered == handler then
            table.remove(local_handlers[t], i)
            if #local_handlers[t] == 0 then
               script.on_nth_tick(event.tick, nil)
               local_handlers[t] = nil
            end
            return true
         end
      end
   end
end

return lib
