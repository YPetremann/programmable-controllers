local memory = require("__programmable-controllers__.control.memory")
local cpu = require("__programmable-controllers__.control.cpu_control")

return {
   ["pci-00"] = {
      name = "NOP#",
      order = "0:0",
      locale = "pci-00 = #### [color=orange]00[/color] NOP[color=pink]# V[/color]\n\n0003 [color=orange]00[/color] NOP[color=pink]# 14[/color] \ndo nothing, hold value 14",
      icon = "<instruction class=\"mem\" id=\"00\" x=\"0\" y=\"0\"></instruction>",
      func = function(G, V) -- OK
      end,
   },
   ["pci-01"] = {
      name = "VAL#",
      order = "0:1",
      locale = "pci-01 = #### [color=orange]01[/color] VAL[color=pink]# V[/color]\n\n0003 [color=orange]01[/color] VAL[color=pink]# 14[/color] \ncopy value 14 in register",
      icon = "<instruction class=\"mem\" id=\"01\" x=\"1\" y=\"0\"  name=\"VAL\" type=\"value\"   ><line dy=\"12\"><register dx=\"6\"/><setter/><value   /></line></instruction>",
      func = function(G, V) -- OK
         local R = memory.peek(G, cpu.register)
         if R.signal.name == nil then
            R.signal = {type = "virtual", name = "pci-00"}
         end
         R.count = V
         memory.poke(G, cpu.register, R)
      end,
   },
   ["pci-02"] = {
      name = "GET@",
      order = "0:2",
      locale = "pci-02 = #### [color=orange]02[/color] GET[color=acid]@ A[/color]\n\n0003 [color=orange]02[/color] GET[color=acid]@ 14[/color] \ncopy memory at address 14 in register",
      icon = "<instruction class=\"mem\" id=\"02\" x=\"2\" y=\"0\"  name=\"GET\" type=\"cell\"    ><line dy=\"12\"><register/><grabber/><cell    /></line></instruction>",
      func = function(G, A) -- OK
         local M = memory.peek(G, A)
         memory.poke(G, cpu.register, {signal = {type = M.signal.type, name = M.signal.name}, count = M.count})
      end,
   },
   ["pci-03"] = {
      name = "GET&",
      order = "0:3",
      locale = "pci-03 = #### [color=orange]03[/color] GET[color=cyan]& P[/color]\n\n0003 [color=orange]03[/color] GET[color=cyan]& 14[/color] \ncopy memory at cpu.pointer 14 in register",
      icon = "<instruction class=\"mem\" id=\"03\" x=\"3\" y=\"0\"  name=\"GET\" type=\"cpu.pointer\" ><line dy=\"12\"><register/><grabber/><cpu.pointer /></line></instruction>",
      func = function(G, P) -- OK
         local A = memory.peek(G, P).count
         local M = memory.peek(G, A)
         memory.poke(G, cpu.register, {signal = {type = M.signal.type, name = M.signal.name}, count = M.count})
      end,
   },
   ["pci-04"] = {
      name = "SET@",
      order = "0:4",
      locale = "pci-04 = #### [color=orange]04[/color] SET[color=acid]@ A[/color]\n\n0003 [color=orange]04[/color] SET[color=acid]@ 14[/color] \ncopy register to memory at address 14",
      icon = "<instruction class=\"memory\" id=\"04\" x=\"4\" y=\"0\"  name=\"SET\" type=\"cell\"    ><line dy=\"12\"><cell    /><grabber/><register/></line></instruction>",
      func = function(G, A) -- OK
         local R = memory.peek(G, cpu.register)
         memory.poke(G, A, {signal = {type = R.signal.type, name = R.signal.name}, count = R.count})
      end,
   },
   ["pci-05"] = {
      name = "SET&",
      order = "0:5",
      locale = "pci-05 = #### [color=orange]05[/color] SET[color=cyan]& P[/color]\n\n0003 [color=orange]05[/color] SET[color=cyan]& 14[/color] \ncopy register to memory at cpu.pointer 14",
      icon = "<instruction class=\"memory\" id=\"05\" x=\"5\" y=\"0\"  name=\"SET\" type=\"cpu.pointer\" ><line dy=\"12\"><cpu.pointer /><grabber/><register/></line></instruction>",
      func = function(G, P) -- OK
         local A = memory.peek(G, P).count
         local R = memory.peek(G, cpu.register)
         memory.poke(G, A, {signal = {type = R.signal.type, name = R.signal.name}, count = R.count})
      end,
   },
   ["pci-06"] = {
      name = "SWP@",
      order = "0:6",
      locale = "pci-06 = #### [color=orange]06[/color] SWP[color=acid]@ A[/color]\n\n0003 [color=orange]06[/color] SWP[color=acid]@ 14[/color] \nswap register and memory at address 14",
      icon = "<instruction class=\"memory\" id=\"06\" x=\"6\" y=\"0\"  name=\"SWP\" type=\"cell\"    ><line dy=\"12\"><register/><tspan dx=\"0 -3 -2 -3\">&lt;==&gt;</tspan><cell    /></line></instruction>",
      func = function(G, A) -- OK
         local R = memory.peek(G, cpu.register)
         local M = memory.peek(G, A)
         memory.poke(G, A, R)
         memory.poke(G, cpu.register, M)
      end,
   },
   ["pci-07"] = {
      name = "SWP&",
      order = "0:7",
      locale = "pci-07 = #### [color=orange]07[/color] SWP[color=cyan]& P[/color]\n\n0003 [color=orange]07[/color] SWP[color=cyan]& 14[/color] \nswap register and memory at cpu.pointer 14",
      icon = "<instruction class=\"memory\" id=\"07\" x=\"7\" y=\"0\"  name=\"SWP\" type=\"cpu.pointer\" ><line dy=\"12\"><register/><tspan dx=\"0 -3 -2 -3\">&lt;==&gt;</tspan><cpu.pointer /></line></instruction>",
      func = function(G, P) -- OK
         local A = memory.peek(G, P).count
         local R = memory.peek(G, cpu.register)
         local M = memory.peek(G, A)
         memory.poke(G, A, R)
         memory.poke(G, cpu.register, M)
      end,
   },
}
