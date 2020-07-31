local lib = {}
local handlers = {}
local on_pre_event = require("lib.events.on_pre_event")
handlers.unfiltered = {}
handlers.by_command = {}

function lib.bind(event)
   script.on_event(defines.events.on_console_command, lib.handler)
   lib.bind = nil
end

function lib.handler(event)
   on_pre_event.handler(event)
   local command = event.command
   for _, func in ipairs(handlers.unfiltered) do
      func(event)
   end
   if handlers.by_command[command] then
      for _, func in ipairs(handlers.by_command[command]) do
         func(event)
      end
   end
end

function lib.register(event)
   local handler = event.handler
   local command = event.command

   local handlers_group = nil
   if command then
      handlers.by_command[command] = handlers.by_command[command] or {}
      handlers_group = handlers.by_command[command]
   else
      handlers_group = handlers.unfiltered
   end

   -- prevent duplicate
   for _, registered in ipairs(handlers_group) do
      if registered == handler then
         return
      end
   end

   -- insert event
   table.insert(handlers_group, handler)
end

function lib.unregister(event)
   local handler = event.handler
   local command = event.command

   local handlers_group = nil
   if command then
      handlers.by_command[command] = handlers.by_command[command] or {}
      handlers_group = handlers.by_command[command]
   else
      handlers_group = handlers.unfiltered
   end

   -- foreach to remove event
   for i, registered in ipairs(handlers_group) do
      if registered == handler then
         table.remove(handlers_group, i)
         return
      end
   end
end

return lib
