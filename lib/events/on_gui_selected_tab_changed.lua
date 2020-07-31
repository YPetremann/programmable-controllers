local lib = {}
local handlers = {}
local on_pre_event = require("lib.events.on_pre_event")

function lib.bind(event)
   script.on_event(defines.events.on_gui_selected_tab_changed, lib.handler)
   lib.bind = nil
end

function lib.handler(event)
   on_pre_event.handler(event)
   local is_mod_gui = event.element.get_mod() == script.mod_name
   local element_name = event.element.name
   local parent_name = event.element.parent and event.element.parent.name
   for _, rule in ipairs(handlers) do
      if rule.strict and not is_mod_gui then
      elseif rule.parent_name and rule.parent_name ~= parent_name then
      elseif rule.element_name and rule.element_name ~= element_name then
      else
         rule.handler(event)
      end
   end
end

function lib.register(event)
   -- prevent duplicate
   for _, registered in ipairs(handlers) do
      if registered.handler == event.handler then
         return
      end
   end
   -- insert event
   table.insert(handlers, event)
end

function lib.unregister(event)
   -- foreach to remove event
   for i, registered in ipairs(handlers) do
      if registered.handler == event.handler then
         table.remove(handlers, i)
         return
      end
   end
end

return lib
