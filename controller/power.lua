local editor = require("__programmable-controllers__.control.editor")

return {
    ["pc-pow"] = {
        on_gui_create = function(index, entity, player)
            editor.create(index, entity, player)
        end,
        on_gui_destroy = function(index, entity, player)
            editor.destroy(player.gui.screen, "programmable_controllers")
        end,
        on_built_entity = function(entity) entity.power_usage = 1000 / 60 end
    }
}
