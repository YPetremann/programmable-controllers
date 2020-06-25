local modname = "__programmable-controllers__"
local addons = require(modname .. ".control.addons_utils")

-- <> <?xml-stylesheet type='text/xsl' href='instructions.xsl'?>
-- <> <grid>
-- @@ [virtual-signal-name]
local lib = {}
addons.add_hardwares(lib, require(modname .. ".controller.connector"))
addons.add_hardwares(lib, require(modname .. ".controller.cpu"))
addons.add_hardwares(lib, require(modname .. ".controller.extension"))
addons.add_hardwares(lib, require(modname .. ".controller.memory"))
addons.add_hardwares(lib, require(modname .. ".controller.power"))

addons.add_instructions(lib, require(modname .. ".instructions.registers"))
addons.add_instructions(lib, require(modname .. ".instructions.controls"))
addons.add_instructions(lib, require(modname .. ".instructions.branchs"))
addons.add_instructions(lib, require(modname .. ".instructions.maths"))
addons.add_instructions(lib, require(modname .. ".instructions.bitwise"))
addons.add_instructions(lib, require(modname .. ".instructions.specials"))

addons.add_documentation(lib, require(modname .. ".docs.404"))
addons.add_documentation(lib, require(modname .. ".docs.intro"))
addons.add_documentation(lib, require(modname .. ".docs.examples"))
addons.add_documentation(lib, require(modname .. ".docs.components"))
addons.add_documentation(lib, require(modname .. ".docs.power"))
addons.add_documentation(lib, require(modname .. ".docs.cpu"))
addons.add_documentation(lib, require(modname .. ".docs.memory"))
addons.add_documentation(lib, require(modname .. ".docs.connector"))
addons.add_documentation(lib, require(modname .. ".docs.extension"))
addons.add_documentation(lib, require(modname .. ".docs.instructions"))
addons.add_documentation(lib, require(modname .. ".docs.register"))
addons.add_documentation(lib, require(modname .. ".docs.control"))
addons.add_documentation(lib, require(modname .. ".docs.branching"))
addons.add_documentation(lib, require(modname .. ".docs.simple_math"))
addons.add_documentation(lib, require(modname .. ".docs.binary"))

-- <> </grid>
return lib
