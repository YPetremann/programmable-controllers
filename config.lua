local config = {}
config.cpt = settings.startup["pc-cycle-per-tick"].value
config.power = settings.startup["pc-power-usage"].value
config.blocksize = settings.startup["pc-memory-block-size"].value
return config
