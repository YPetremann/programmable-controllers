local editor = require("__programmable-controllers__.control.editor")

return {
   ["pc-mem"] = {
      on_gui_create = function(index, entity, player)
         editor.create(index, entity, player)
      end,
      on_gui_destroy = function(index, entity, player)
         editor.destroy(player.gui.left, "pc-mem-window")
      end,
      on_load_mem = function(index, entity)
         return entity.get_control_behavior().parameters.parameters
      end,
      on_save_mem = function(index, entity, chunk)
         global.ent[index].get_control_behavior().parameters = {parameters = chunk}
      end,
   },
}
