local memory = require("__programmable-controllers__.control.memory")
local cpu = require("__programmable-controllers__.control.cpu_control")

return {
   ["pci-08"] = {
      name = "SLP#",
      order = "0:8",
      locale = "pci-08 = #### [color=orange]08[/color] SLP[color=pink]# V[/color]\n\n0003 [color=orange]08[/color] SLP[color=pink]# 14[/color] \nwait for processor cycles defined by value 14",
      icon = "<instruction class=\"control\" id=\"08\" x=\"0\" y=\"1\"  name=\"SLP\" type=\"value\"   ><line><tspan>FOR</tspan><value   /><tspan></tspan></line><line><then/><control/><tspan dx=\"1 2\">--</tspan></line></instruction>",
      func = function(G, V) -- OK
         local C = memory.peek(G, cpu.control)
         if C.signal.name ~= "pci-08" or C.count > V then
            -- init sleep loop
            C = {signal = {type = "virtual", name = "pci-08"}, count = V}
         end
         if C.count > 0 then
            -- decrement sleep loop
            cpu.pointer = cpu.pointer - 1
            C.count = C.count - 1
         else
            -- stop sleep loop
            C = {signal = {type = "virtual", name = "pci-00"}, count = 0}
         end
         memory.poke(G, cpu.control, C)
      end,
   },
   ["pci-09"] = {
      name = "SLP@",
      order = "0:9",
      locale = "pci-09 = #### [color=orange]09[/color] SLP[color=acid]@ A[/color]\n\n0003 [color=orange]09[/color] SLP[color=acid]@ 14[/color] \nwait for processor cycles defined by address 14",
      icon = "<instruction class=\"control\" id=\"09\" x=\"1\" y=\"1\"  name=\"SLP\" type=\"cell\"    ><line><tspan>FOR</tspan><cell    /><tspan></tspan></line><line><then/><control/><tspan dx=\"1 2\">--</tspan></line></instruction>",
      func = function(G, A) -- OK
         local C = memory.peek(G, cpu.control)
         local V = memory.peek(G, A).count
         if C.signal.name ~= "pci-08" or C.count > V then
            -- init sleep loop
            C = {signal = {type = "virtual", name = "pci-08"}, count = V}
         end
         if C.count > 0 then
            -- decrement sleep loop
            cpu.pointer = cpu.pointer - 1
            C.count = C.count - 1
         else
            -- stop sleep loop
            C = {signal = {type = "virtual", name = "pci-00"}, count = 0}
         end
         memory.poke(G, cpu.control, C)
      end,
   },
   ["pci-0A"] = {
      name = "YLD#",
      order = "0:A",
      locale = "pci-0A = #### [color=orange]0A[/color] YLD[color=pink]# V[/color]\n\n0003 [color=orange]0A[/color] YLD[color=pink]# 14[/color] \nwait for clock tick defined by value 14",
      icon = "<instruction class=\"control\" id=\"0A\" x=\"2\" y=\"1\"  name=\"YLD\" type=\"value\"   ><line><tspan>FOR</tspan><value   /><tspan></tspan></line><line><then/><tspan>TCK</tspan></line></instruction>",
      func = function(G, V) -- OK
         local C = memory.peek(G, cpu.control)
         if C.signal.name ~= "pci-0A" or C.count > V then
            C = {signal = {type = "virtual", name = "pci-0A"}, count = V}
         end
         if C.count > 0 then
            cpu.brk = true
         end
         if C.count > 1 then
            cpu.pointer = cpu.pointer - 1
            C.count = C.count - 1
         else
            C = {signal = {type = "virtual", name = "pci-00"}, count = 1}
         end
         memory.poke(G, cpu.control, C)
      end,
   },
   ["pci-0B"] = {
      name = "YLD@",
      order = "0:B",
      locale = "pci-0B = #### [color=orange]0B[/color] YLD[color=acid]@ A[/color]\n\n0003 [color=orange]0B[/color] YLD[color=acid]@ 14[/color] \nwait for clock tick defined by address 14",
      icon = "<instruction class=\"control\" id=\"0B\" x=\"3\" y=\"1\"  name=\"YLD\" type=\"cell\"    ><line><tspan>FOR</tspan><cell    /><tspan></tspan></line><line><then/><tspan>TCK</tspan></line></instruction>",
      func = function(G, A) -- OK
         local V = memory.peek(G, A).count
         local C = memory.peek(G, cpu.control)
         if C.signal.name ~= "pci-0A" or C.count > V then
            C = {signal = {type = "virtual", name = "pci-0A"}, count = V}
         end
         if C.count > 0 then
            cpu.brk = true
         end
         if C.count > 1 then
            cpu.pointer = cpu.pointer - 1
            C.count = C.count - 1
         else
            C = {signal = {type = "virtual", name = "pci-00"}, count = 1}
         end
         memory.poke(G, cpu.control, C)
      end,
   },
   ["pci-0C"] = {
      name = "INT@",
      order = "0:C",
      locale = "pci-0C = #### [color=orange]0C[/color] INT[color=acid]@ A[/color]\n\n0003 [color=orange]0C[/color] INT[color=acid]@ 14[/color] \nwait modification at address 14",
      icon = "<instruction class=\"control\" id=\"0C\" x=\"4\" y=\"1\"  name=\"INT\" type=\"cell\"    ><line><tspan>CHG</tspan><cell    /><tspan></tspan></line><line><else/><control/><tspan dx=\"1 2\">--</tspan></line></instruction>",
      func = function(Cpu, Addr) -- OK
         local Clone = memory.peek(Cpu, cpu.control)
         local Control = memory.peek(Cpu, cpu.control + 1)
         local Mem = memory.peek(Cpu, Addr)
         if Control.signal.name ~= "pci-0C" then
            cpu.pointer = cpu.pointer - 1
            memory.poke(Cpu, cpu.control, {signal = {type = Mem.signal.type, name = Mem.signal.name}, count = Mem.count})
            memory.poke(Cpu, cpu.control + 1, {signal = {type = "virtual", name = "pci-0C"}, count = cpu.Control.count})
         elseif Clone.signal.type == Mem.signal.type and Clone.signal.name == Mem.signal.name and Clone.count ==
            Mem.count then
            cpu.pointer = cpu.pointer - 1
            cpu.brk = true
         else
            memory.poke(Cpu, cpu.control, {signal = {type = "virtual", name = "pci-00"}, count = 1})
            memory.poke(Cpu, cpu.control + 1, {signal = {type = "virtual", name = "pci-10"}, count = cpu.Control.count})
         end
      end,
   },
   ["pci-0D"] = {
      name = "INT&",
      order = "0:D",
      locale = "pci-0D = #### [color=orange]0D[/color] INT[color=cyan]& P[/color]\n\n0003 [color=orange]0D[/color] INT[color=cyan]& 14[/color] \nwait modification at cpu.pointer 14",
      icon = "<instruction class=\"control\" id=\"0D\" x=\"5\" y=\"1\"  name=\"INT\" type=\"cpu.pointer\" ><line><tspan>CHG</tspan><cpu.pointer /><tspan></tspan></line><line><else/><control/><tspan dx=\"1 2\">--</tspan></line></instruction>",
      func = function(G, P) -- OK
         local S = memory.peek(G, cpu.control)
         local C = memory.peek(G, cpu.control + 1)
         local A = memory.peek(G, P).count
         local M = memory.peek(G, A)
         if C.signal.name ~= "pci-0C" then
            cpu.pointer = cpu.pointer - 1
            memory.poke(G, cpu.control, {signal = {type = M.signal.type, name = M.signal.name}, count = M.count})
            memory.poke(G, cpu.control + 1, {signal = {type = "virtual", name = "pci-0C"}, count = C.count})
         elseif S.signal.type == M.signal.type and S.signal.name == M.signal.name and S.count == M.count then
            cpu.pointer = cpu.pointer - 1
            cpu.brk = true
         else
            memory.poke(G, cpu.control, {signal = {type = "virtual", name = "pci-00"}, count = 1})
            memory.poke(G, cpu.control + 1, {signal = {type = "virtual", name = "pci-10"}, count = C.count})
         end
      end,
   },
   ["pci-0E"] = {
      name = "HLT#",
      order = "0:E",
      locale = "pci-0E = #### [color=orange]0E[/color] HLT[color=pink]# V[/color]\n\n0003 [color=orange]0E[/color] HLT[color=pink]# 14[/color] \nhalt with code defined by value 14",
      icon = "<instruction class=\"control\" id=\"0E\" x=\"6\" y=\"1\"  name=\"HLT\" type=\"value\"   ><line><register/><grabber/><cell    /></line><line><tspan>HALT</tspan></line></instruction>",
      func = function(G, V) -- OK
         memory.poke(G, cpu.origin, {signal = {type = "virtual", name = "pci-0E"}, count = V, index = 1})
         cpu.brk = true
      end,
   },
   ["pci-0F"] = {
      name = "HLT@",
      order = "0:F",
      locale = "pci-0F = #### [color=orange]0F[/color] HLT[color=acid]@ A[/color]\n\n0003 [color=orange]0F[/color] HLT[color=acid]@ 14[/color] \nhalt with code defined by address 14",
      icon = "<instruction class=\"control\" id=\"0F\" x=\"7\" y=\"1\"  name=\"HLT\" type=\"cell\"    ><line><register/><grabber/><cpu.pointer /></line><line><tspan>HALT</tspan></line></instruction>",
      func = function(G, A) -- OK
         memory.poke(
            G, cpu.origin, {signal = {type = "virtual", name = "pci-0E"}, count = memory.peek(G, A).count, index = 1}
         )
         cpu.brk = true
      end,
   },
}
