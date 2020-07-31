if data then

    local lib = {}

    function lib.create(def)
        local prototype = table.deepcopy(def)
        prototype.type = "shortcut"

        prototype.icon = {
            size = 32,
            scale = 1,
            priority = "extra-high-no-scale",
            flags = {"icon"},
        }
        prototype.icon.filename = string.format(def.icon, "x32-n")

        prototype.disabled_icon = table.deepcopy(prototype.icon)
        prototype.disabled_icon.filename =
            string.format(def.disabled_icon or def.icon, "x32-d")

        prototype.small_icon = table.deepcopy(prototype.icon)
        prototype.small_icon.filename = string.format(
            def.small_icon or def.icon, "x24-n"
        )
        prototype.small_icon.size = 24

        prototype.disabled_small_icon = table.deepcopy(prototype.small_icon)
        prototype.disabled_small_icon.filename =
            string.format(def.disabled_small_icon or def.icon, "x24-d")

        return prototype
    end

    return lib

elseif script then

    print(... .. " will do nothing at runtime")

end
