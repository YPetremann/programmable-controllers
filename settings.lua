data:extend{
    {
        type = "int-setting",
        name = "pc-cycle-per-tick",
        setting_type = "startup",
        default_value = 128,
        minimum_value = 16,
        maximum_value = 4096
    }, {
        type = "int-setting",
        name = "pc-power-usage",
        setting_type = "startup",
        default_value = 10,
        minimum_value = 0,
        maximum_value = 10000
    }, {
        type = "int-setting",
        name = "pc-memory-block-size",
        setting_type = "startup",
        default_value = 24,
        minimum_value = 16,
        maximum_value = 128
    }, {
        type = "bool-setting",
        name = "pc-debug",
        setting_type = "runtime-per-user",
        default_value = true
    }
}

