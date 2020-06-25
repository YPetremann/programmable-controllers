local memory = require("__programmable-controllers__.control.memory")
local cpu = require("__programmable-controllers__.control.cpu_control")

return {
   ["pci-10"] = {
      name = "JMP#",
      order = "1:0",
      locale = "pci-10 = #### [color=orange]10[/color] JMP[color=pink]# V[/color]\n\n0003 [color=orange]10[/color] JMP[color=pink]# 14[/color] \njump defined by value 14",
      icon = "<instruction class=\"branch\" id=\"10\" x=\"0\" y=\"2\"  name=\"JMP\" type=\"value\"   ><line dy=\"12\"><control dx=\"6\"/><setter/><value   /></line></instruction>",
      func = function(G, V) -- TODO 0003 -- JMP# 14 ## jump to 14
         cpu.pointer = V
      end,
   },
   ["pci-11"] = {
      name = "JMP@",
      order = "1:1",
      locale = "pci-11 = #### [color=orange]11[/color] JMP[color=acid]@ A[/color]\n\n0003 [color=orange]11[/color] JMP[color=acid]@ 14[/color] \njump defined by address 14",
      icon = "<instruction class=\"branch\" id=\"11\" x=\"1\" y=\"2\"  name=\"JMP\" type=\"cell\"    ><line dy=\"12\"><control dx=\"6\"/><setter/><cell    /></line></instruction>",
      func = function(G, A) -- TODO 0003 -- JMP@ 14 ## jump to value at address 14
         cpu.pointer = memory.peek(G, A).count
      end,
   },
   ["pci-12"] = {
      name = "RJP#",
      order = "1:2",
      locale = "pci-12 = #### [color=orange]12[/color] RJP[color=pink]# V[/color]\n\n0003 [color=orange]12[/color] RJP[color=pink]# 14[/color] \njump relative defined by value 14",
      icon = "<instruction class=\"branch\" id=\"12\" x=\"2\" y=\"2\"  name=\"RJP\" type=\"value\"   ><line dy=\"12\"><control/><tspan>+</tspan><setter/><value   /></line></instruction>",
      func = function(G, V) -- TODO 0003 -- RJP# 14 ## jump relative of 14
         cpu.pointer = cpu.pointer + V - 1
      end,
   },
   ["pci-13"] = {
      name = "RJP@",
      order = "1:3",
      locale = "pci-13 = #### [color=orange]13[/color] RJP[color=acid]@ A[/color]\n\n0003 [color=orange]13[/color] RJP[color=acid]@ 14[/color] \njump relative defined by address 14",
      icon = "<instruction class=\"branch\" id=\"13\" x=\"3\" y=\"2\"  name=\"RJP\" type=\"cell\"    ><line dy=\"12\"><control/><tspan>+</tspan><setter/><cell    /></line></instruction>",
      func = function(G, A) -- TODO 0003 -- RJP@ 14 ## jump relative of value at address 14
         cpu.pointer = cpu.pointer + memory.peek(G, A).count - 1
      end,
   },
   ["pci-14"] = {
      name = "SEQ#",
      order = "1:4",
      locale = "pci-14 = #### [color=orange]14[/color] SEQ[color=pink]# V[/color]\n\n0003 [color=orange]14[/color] SEQ[color=pink]# 14[/color] \nskip next instruction if register == value 14",
      icon = "<instruction class=\"branch\" id=\"14\" x=\"4\" y=\"2\"  name=\"SEQ\" type=\"value\"   ><line><register/><tspan>==</tspan><value   /></line><line><then/><control/>++</line></instruction>",
      func = function(G, V) -- TODO 0003 -- SEQ# 14 ## skip next instruction if cpu register == 14
         if memory.peek(G, cpu.register).count == V then
            cpu.pointer = cpu.pointer + 1
         end
      end,
   },
   ["pci-15"] = {
      name = "SEQ@",
      order = "1:5",
      locale = "pci-15 = #### [color=orange]15[/color] SEQ[color=acid]@ A[/color]\n\n0003 [color=orange]15[/color] SEQ[color=acid]@ 14[/color] \nskip next instruction if register == address 14",
      icon = "<instruction class=\"branch\" id=\"15\" x=\"5\" y=\"2\"  name=\"SEQ\" type=\"cell\"    ><line><register/><tspan>==</tspan><cell    /></line><line><then/><control/>++</line></instruction>",
      func = function(G, A) -- TODO 0003 -- SEQ@ 14 ## skip next instruction if cpu register == value at address 14
         if memory.peek(G, cpu.register).count == memory.peek(G, A).count then
            cpu.pointer = cpu.pointer + 1
         end
      end,
   },
   ["pci-16"] = {
      name = "SNE#",
      order = "1:6",
      locale = "pci-16 = #### [color=orange]16[/color] SNE[color=pink]# V[/color]\n\n0003 [color=orange]16[/color] SNE[color=pink]# 14[/color] \nskip next instruction if register ! = value 14",
      icon = "<instruction class=\"branch\" id=\"16\" x=\"6\" y=\"2\"  name=\"SNE\" type=\"value\"   ><line><register/><tspan dx=\"2 2\">!=</tspan><value   /></line><line><then/><control/>++</line></instruction>",
      func = function(G, V) -- TODO 0003 -- SNE# 14 ## skip next instruction if not cpu register == 14
         if memory.peek(G, cpu.register).count ~= V then
            cpu.pointer = cpu.pointer + 1
         end
      end,
   },
   ["pci-17"] = {
      name = "SNE@",
      order = "1:7",
      locale = "pci-17 = #### [color=orange]17[/color] SNE[color=acid]@ A[/color]\n\n0003 [color=orange]17[/color] SNE[color=acid]@ 14[/color] \nskip next instruction if register ! = address 14",
      icon = "<instruction class=\"branch\" id=\"17\" x=\"7\" y=\"2\"  name=\"SNE\" type=\"cell\"    ><line><register/><tspan dx=\"2 2\">!=</tspan><cell    /></line><line><then/><control/>++</line></instruction>",
      func = function(G, A) -- TODO 0003 -- SNE@ 14 ## skip next instruction if not cpu register == value at address 14
         if memory.peek(G, cpu.register).count ~= memory.peek(G, A).count then
            cpu.pointer = cpu.pointer + 1
         end
      end,
   },
   ["pci-18"] = {
      name = "SLT#",
      order = "1:8",
      locale = "pci-18 = #### [color=orange]18[/color] SLT[color=pink]# V[/color]\n\n0003 [color=orange]18[/color] SLT[color=pink]# 14[/color] \nskip next instruction if register < value 14",
      icon = "<instruction class=\"branch\" id=\"18\" x=\"0\" y=\"3\"  name=\"SLT\" type=\"value\"   ><line><register dx=\"6\"/><tspan dx=\"1\">&lt;</tspan><value dx=\"1\"/></line><line><then/><control/>++</line></instruction>",
      func = function(G, V) -- TODO 0003 -- SLT# 14 ## skip next instruction if cpu register < 14
         if memory.peek(G, cpu.register).count < V then
            cpu.pointer = cpu.pointer + 1
         end
      end,
   },
   ["pci-19"] = {
      name = "SLT@",
      order = "1:9",
      locale = "pci-19 = #### [color=orange]19[/color] SLT[color=acid]@ A[/color]\n\n0003 [color=orange]19[/color] SLT[color=acid]@ 14[/color] \nskip next instruction if register < address 14",
      icon = "<instruction class=\"branch\" id=\"19\" x=\"1\" y=\"3\"  name=\"SLT\" type=\"cell\"    ><line><register dx=\"6\"/><tspan dx=\"1\">&lt;</tspan><cell dx=\"1\"/></line><line><then/><control/>++</line></instruction>",
      func = function(G, A) -- TODO 0003 -- SLT@ 14 ## skip next instruction if cpu register < value at address 14
         if memory.peek(G, cpu.register).count < memory.peek(G, A).count then
            cpu.pointer = cpu.pointer + 1
         end
      end,
   },
   ["pci-1A"] = {
      name = "SGT#",
      order = "1:A",
      locale = "pci-1A = #### [color=orange]1A[/color] SGT[color=pink]# V[/color]\n\n0003 [color=orange]1A[/color] SGT[color=pink]# 14[/color] \nskip next instruction if register > value 14",
      icon = "<instruction class=\"branch\" id=\"1A\" x=\"2\" y=\"3\"  name=\"SGT\" type=\"value\"   ><line><register dx=\"6\"/><tspan dx=\"1\">&gt;</tspan><value dx=\"1\"/></line><line><then/><control/>++</line></instruction>",
      func = function(G, V) -- TODO 0003 -- SGT# 14 ## skip next instruction if cpu register > 14
         if memory.peek(G, cpu.register).count > V then
            cpu.pointer = cpu.pointer + 1
         end
      end,
   },
   ["pci-1B"] = {
      name = "SGT@",
      order = "1:B",
      locale = "pci-1B = #### [color=orange]1B[/color] SGT[color=acid]@ A[/color]\n\n0003 [color=orange]1B[/color] SGT[color=acid]@ 14[/color] \nskip next instruction if register > address 14",
      icon = "<instruction class=\"branch\" id=\"1B\" x=\"3\" y=\"3\"  name=\"SGT\" type=\"cell\"    ><line><register dx=\"6\"/><tspan dx=\"1\">&gt;</tspan><cell dx=\"1\"/></line><line><then/><control/>++</line></instruction>",
      func = function(G, A) -- TODO 0003 -- SGT@ 14 ## skip next instruction if cpu register > value at address 14
         if memory.peek(G, cpu.register).count > memory.peek(G, A).count then
            cpu.pointer = cpu.pointer + 1
         end
      end,
   },
   ["pci-1C"] = {
      name = "SLE#",
      order = "1:C",
      locale = "pci-1C = #### [color=orange]1C[/color] SLE[color=pink]# V[/color]\n\n0003 [color=orange]1C[/color] SLE[color=pink]# 14[/color] \nskip next instruction if register <= value 14",
      icon = "<instruction class=\"branch\" id=\"1D\" x=\"4\" y=\"3\"  name=\"SLE\" type=\"value\"   ><line><register/><tspan dx=\"1 1\">&lt;=</tspan><cell    /></line><line><then/><control/>++</line></instruction>",
      func = function(G, V) -- TODO 0003 -- SLE# 14 ## skip next instruction if cpu register <= 14
         if memory.peek(G, cpu.register).count <= V then
            cpu.pointer = cpu.pointer + 1
         end
      end,
   },
   ["pci-1D"] = {
      name = "SLE@",
      order = "1:D",
      locale = "pci-1D = #### [color=orange]1D[/color] SLE[color=acid]@ A[/color]\n\n0003 [color=orange]1D[/color] SLE[color=acid]@ 14[/color] \nskip next instruction if register <= address 14",
      icon = "<instruction class=\"branch\" id=\"1C\" x=\"5\" y=\"3\"  name=\"SLE\" type=\"cell\"    ><line><register/><tspan dx=\"1 1\">&lt;=</tspan><value   /></line><line><then/><control/>++</line></instruction>",
      func = function(G, A) -- TODO 0003 -- SLE@ 14 ## skip next instruction if cpu register <= value at address 14
         if memory.peek(G, cpu.register).count <= memory.peek(G, A).count then
            cpu.pointer = cpu.pointer + 1
         end
      end,
   },
   ["pci-1E"] = {
      name = "SGE#",
      order = "1:E",
      locale = "pci-1E = #### [color=orange]1E[/color] SGE[color=pink]# V[/color]\n\n0003 [color=orange]1E[/color] SGE[color=pink]# 14[/color] \nskip next instruction if register >= value 14",
      icon = "<instruction class=\"branch\" id=\"1E\" x=\"6\" y=\"3\"  name=\"SGE\" type=\"value\"   ><line><register/><tspan dx=\"1 1\">&gt;=</tspan><value   /></line><line><then/><control/>++</line></instruction>",
      func = function(G, V) -- TODO 0003 -- SGE# 14 ## skip next instruction if cpu register >= 14
         if memory.peek(G, cpu.register).count >= V then
            cpu.pointer = cpu.pointer + 1
         end
      end,
   },
   ["pci-1F"] = {
      name = "SGE@",
      order = "1:F",
      locale = "pci-1F = #### [color=orange]1F[/color] SGE[color=acid]@ A[/color]\n\n0003 [color=orange]1F[/color] SGE[color=acid]@ 14[/color] \nskip next instruction if register >= address 14",
      icon = "<instruction class=\"branch\" id=\"1F\" x=\"7\" y=\"3\"  name=\"SGE\" type=\"cell\"    ><line><register/><tspan dx=\"1 1\">&gt;=</tspan><cell    /></line><line><then/><control/>++</line></instruction>",
      func = function(G, A) -- TODO 0003 -- SGE@ 14 ## skip next instruction if cpu register >= value at address 14
         if memory.peek(G, cpu.register).count >= memory.peek(G, A).count then
            cpu.pointer = cpu.pointer + 1
         end
      end,
   },
}
