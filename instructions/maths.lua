local memory = require("__programmable-controllers__.control.memory")
local cpu = require("__programmable-controllers__.control.cpu_control")

local function sign(a)
   return (a + 2147483648) % 4294967296 - 2147483648
end

local function unsign(a)
   return a % 4294967296
end

local b = bit32

return {
   ["pci-20"] = {
      name = "ADD#",
      order = "2:0",
      locale = "pci-20 = #### [color=orange]20[/color] ADD[color=pink]# V[/color]\n\n0003 [color=orange]20[/color] ADD[color=pink]# 14[/color] \nincrease register by value 14",
      icon = "<instruction class=\"math\" id=\"20\" x=\"0\" y=\"4\"  name=\"ADD\" type=\"value\"   ><line dy=\"12\"><register/><tspan>+</tspan><setter/><value   /></line></instruction>",
      func = function(G, V) -- TODO 0003 -- ADD# 14 ## add 14 to cpu register
         local R = memory.peek(G, cpu.register)
         R.count = sign(R.count + V)
         memory.poke(G, cpu.register, R)
      end,
   },
   ["pci-28"] = {
      name = "ADD@",
      order = "2:8",
      locale = "pci-28 = #### [color=orange]28[/color] ADD[color=acid]@ A[/color]\n\n0003 [color=orange]28[/color] ADD[color=acid]@ 14[/color] \nincrease register by address 14",
      icon = "<instruction class=\"math\" id=\"28\" x=\"0\" y=\"5\"  name=\"ADD\" type=\"cell\"    ><line dy=\"12\"><register/><tspan>+</tspan><setter/><cell    /></line></instruction>",
      func = function(G, A) -- TODO 0003 -- ADD@ 14 ## add value at address 14 to cpu register
         local M = memory.peek(G, A)
         local R = memory.peek(G, cpu.register)
         R.count = sign(R.count + M.count)
         memory.poke(G, cpu.register, R)
      end,
   },
   ["pci-30"] = {
      name = "ADD&",
      order = "3:0",
      locale = "pci-30 = #### [color=orange]30[/color] ADD[color=cyan]& P[/color]\n\n0003 [color=orange]30[/color] ADD[color=cyan]& 14[/color] \nincrease cpu.pointer 14 by register",
      icon = "<instruction class=\"math\" id=\"30\" x=\"0\" y=\"6\"  name=\"ADD\" type=\"cpu.pointer\" ><line dy=\"12\"><cpu.pointer /><tspan>+</tspan><setter/><register/></line></instruction>",
      func = function(G, P) -- TODO 0003 -- ADD& 14 ## add value of cpu register to memory at cpu.pointer 14
         local A = memory.peek(G, P).count
         local R = memory.peek(G, cpu.register)
         local M = memory.peek(G, A)
         M.count = sign(M.count + R.count)
         memory.poke(G, A, M)
      end,
   },
   ["pci-38"] = {
      name = "ADD%",
      order = "3:8",
      locale = "pci-38 = #### [color=orange]38[/color] ADD[color=yellow]% A[/color]\n\n0003 [color=orange]38[/color] ADD[color=yellow]% 14[/color] \nincrease address 14 by register",
      icon = "<instruction class=\"math\" id=\"38\" x=\"0\" y=\"7\"  name=\"ADD\" type=\"register\"><line dy=\"12\"><cell    /><tspan>+</tspan><setter/><register/></line></instruction>",
      func = function(G, A) -- TODO 0003 -- ADD% 14 ## add value of cpu register to memory at address 14
         local R = memory.peek(G, cpu.register)
         local M = memory.peek(G, A)
         M.count = sign(M.count + R.count)
         memory.poke(G, A, M)
      end,
   },
   ["pci-21"] = {
      name = "SUB#",
      order = "2:1",
      locale = "pci-21 = #### [color=orange]21[/color] SUB[color=pink]# V[/color]\n\n0003 [color=orange]21[/color] SUB[color=pink]# 14[/color] \ndecrease register by value 14",
      icon = "<instruction class=\"math\" id=\"21\" x=\"1\" y=\"4\"  name=\"SUB\" type=\"value\"   ><line dy=\"12\"><register/><tspan dx=\"1 1\">-=</tspan><value   /></line></instruction>",
      func = function(G, V) -- TODO 0003 -- SUB# 14 ## subtract 14 to cpu register
         local R = memory.peek(G, cpu.register)
         R.count = sign(R.count - V)
         memory.poke(G, cpu.register, R)
      end,
   },
   ["pci-29"] = {
      name = "SUB@",
      order = "2:9",
      locale = "pci-29 = #### [color=orange]29[/color] SUB[color=acid]@ A[/color]\n\n0003 [color=orange]29[/color] SUB[color=acid]@ 14[/color] \ndecrease register by address 14",
      icon = "<instruction class=\"math\" id=\"29\" x=\"1\" y=\"5\"  name=\"SUB\" type=\"cell\"    ><line dy=\"12\"><register/><tspan dx=\"1 1\">-=</tspan><cell    /></line></instruction>",
      func = function(G, A) -- TODO 0003 -- SUB@ 14 ## substract value at address 14 to cpu register
         local M = memory.peek(G, A)
         local R = memory.peek(G, cpu.register)
         R.count = sign(R.count - M.count)
         memory.poke(G, cpu.register, R)
      end,
   },
   ["pci-31"] = {
      name = "SUB&",
      order = "3:1",
      locale = "pci-31 = #### [color=orange]31[/color] SUB[color=cyan]& P[/color]\n\n0003 [color=orange]31[/color] SUB[color=cyan]& 14[/color] \ndecrease cpu.pointer 14 by register",
      icon = "<instruction class=\"math\" id=\"31\" x=\"1\" y=\"6\"  name=\"SUB\" type=\"cpu.pointer\" ><line dy=\"12\"><cpu.pointer /><tspan dx=\"1 1\">-=</tspan><register/></line></instruction>",
      func = function(G, P) -- TODO 0003 -- SUB& 14 ## substract value of cpu register to memory at cpu.pointer 14
         local A = memory.peek(G, P).count
         local R = memory.peek(G, cpu.register)
         local M = memory.peek(G, A)
         M.count = sign(M.count - R.count)
         memory.poke(G, A, M)
      end,
   },
   ["pci-39"] = {
      name = "SUB%",
      order = "3:9",
      locale = "pci-39 = #### [color=orange]39[/color] SUB[color=yellow]% A[/color]\n\n0003 [color=orange]39[/color] SUB[color=yellow]% 14[/color] \ndecrease address 14 by register",
      icon = "<instruction class=\"math\" id=\"39\" x=\"1\" y=\"7\"  name=\"SUB\" type=\"register\"><line dy=\"12\"><cell    /><tspan dx=\"1 1\">-=</tspan><register/></line></instruction>",
      func = function(G, A) -- TODO 0003 -- SUB% 14 ## substract value of cpu register to memory at address 14
         local R = memory.peek(G, cpu.register)
         local M = memory.peek(G, A)
         M.count = sign(M.count - R.count)
         memory.poke(G, A, M)
      end,
   },
   ["pci-22"] = {
      name = "MUL#",
      order = "2:2",
      locale = "pci-22 = #### [color=orange]22[/color] MUL[color=pink]# V[/color]\n\n0003 [color=orange]22[/color] MUL[color=pink]# 14[/color] \nmultiply register by value 14",
      icon = "<instruction class=\"math\" id=\"22\" x=\"2\" y=\"4\"  name=\"MUL\" type=\"value\"   ><line dy=\"12\"><register/><tspan>x</tspan><setter/><value   /></line></instruction>",
      func = function(G, V) -- TODO 0003 -- MUL# 14 ## multiply cpu register by 14
         local R = memory.peek(G, cpu.register)
         R.count = sign(R.count * V)
         memory.poke(G, cpu.register, R)
      end,
   },
   ["pci-2A"] = {
      name = "MUL@",
      order = "2:A",
      locale = "pci-2A = #### [color=orange]2A[/color] MUL[color=acid]@ A[/color]\n\n0003 [color=orange]2A[/color] MUL[color=acid]@ 14[/color] \nmultiply register by address 14",
      icon = "<instruction class=\"math\" id=\"2A\" x=\"2\" y=\"5\"  name=\"MUL\" type=\"cell\"    ><line dy=\"12\"><register/><tspan>x</tspan><setter/><cell    /></line></instruction>",
      func = function(G, A) -- TODO 0003 -- MUL@ 14 ## multiply cpu register by value at address 14
         local M = memory.peek(G, A)
         local R = memory.peek(G, cpu.register)
         R.count = sign(R.count * M.count)
         memory.poke(G, cpu.register, R)
      end,
   },
   ["pci-32"] = {
      name = "MUL&",
      order = "3:2",
      locale = "pci-32 = #### [color=orange]32[/color] MUL[color=cyan]& P[/color]\n\n0003 [color=orange]32[/color] MUL[color=cyan]& 14[/color] \nmultiply cpu.pointer 14 by register",
      icon = "<instruction class=\"math\" id=\"32\" x=\"2\" y=\"6\"  name=\"MUL\" type=\"cpu.pointer\" ><line dy=\"12\"><cpu.pointer /><tspan>x</tspan><setter/><register/></line></instruction>",
      func = function(G, P) -- TODO 0003 -- MUL& 14 ## multiply memory at cpu.pointer 14 by value of cpu register
         local A = memory.peek(G, P).count
         local R = memory.peek(G, cpu.register)
         local M = memory.peek(G, A)
         M.count = sign(M.count * R.count)
         memory.poke(G, A, M)
      end,
   },
   ["pci-3A"] = {
      name = "MUL%",
      order = "3:A",
      locale = "pci-3A = #### [color=orange]3A[/color] MUL[color=yellow]% A[/color]\n\n0003 [color=orange]3A[/color] MUL[color=yellow]% 14[/color] \nmultiply address 14 by register",
      icon = "<instruction class=\"math\" id=\"3A\" x=\"2\" y=\"7\"  name=\"MUL\" type=\"register\"><line dy=\"12\"><cell    /><tspan>x</tspan><setter/><register/></line></instruction>",
      func = function(G, A) -- TODO 0003 -- MUL% 14 ## multiply memory at address 14 by value of cpu register
         local R = memory.peek(G, cpu.register)
         local M = memory.peek(G, A)
         M.count = sign(M.count * R.count)
         memory.poke(G, A, M)
      end,
   },
   ["pci-23"] = {
      name = "DVF#",
      order = "2:3",
      locale = "pci-23 = #### [color=orange]23[/color] DVF[color=pink]# V[/color]\n\n0003 [color=orange]23[/color] DVF[color=pink]# 14[/color] \nfloor division on register by value 14",
      icon = "<instruction class=\"math\" id=\"23\" x=\"3\" y=\"4\"  name=\"DVF\" type=\"value\"   ><line dy=\"12\"><register/><tspan dx=\"0 -3 -1\" dy=\"1 -9 8\" rotate=\"0 180 0\">/^=</tspan><value   /></line></instruction>",
      func = function(G, V) -- TODO 0003 -- DVF# 14 ## floor division on cpu register by 14
         local R = memory.peek(G, cpu.register)
         R.count = sign(math.floor(R.count / V))
         memory.poke(G, cpu.register, R)
      end,
   },
   ["pci-2B"] = {
      name = "DVF@",
      order = "2:B",
      locale = "pci-2B = #### [color=orange]2B[/color] DVF[color=acid]@ A[/color]\n\n0003 [color=orange]2B[/color] DVF[color=acid]@ 14[/color] \nfloor division on register by address 14",
      icon = "<instruction class=\"math\" id=\"2B\" x=\"3\" y=\"5\"  name=\"DVF\" type=\"cell\"    ><line dy=\"12\"><register/><tspan dx=\"0 -3 -1\" dy=\"1 -9 8\" rotate=\"0 180 0\">/^=</tspan><cell    /></line></instruction>",
      func = function(G, A) -- TODO 0003 -- DVF@ 14 ## floor division on cpu register by value at address 14
         local M = memory.peek(G, A)
         local R = memory.peek(G, cpu.register)
         R.count = sign(math.floor(R.count / M.count))
         memory.poke(G, cpu.register, R)
      end,
   },
   ["pci-33"] = {
      name = "DVF&",
      order = "3:3",
      locale = "pci-33 = #### [color=orange]33[/color] DVF[color=cyan]& P[/color]\n\n0003 [color=orange]33[/color] DVF[color=cyan]& 14[/color] \nfloor division on cpu.pointer 14 by register",
      icon = "<instruction class=\"math\" id=\"33\" x=\"3\" y=\"6\"  name=\"DVF\" type=\"cpu.pointer\" ><line dy=\"12\"><cpu.pointer /><tspan dx=\"0 -3 -1\" dy=\"1 -9 8\" rotate=\"0 180 0\">/^=</tspan><register/></line></instruction>",
      func = function(G, P) -- TODO 0003 -- DVF& 14 ## floor division on memory at cpu.pointer 14 by value of cpu register
         local A = memory.peek(G, P).count
         local R = memory.peek(G, cpu.register)
         local M = memory.peek(G, A)
         M.count = sign(math.floor(M.count / R.count))
         memory.poke(G, A, M)
      end,
   },
   ["pci-3B"] = {
      name = "DVF%",
      order = "3:B",
      locale = "pci-3B = #### [color=orange]3B[/color] DVF[color=yellow]% A[/color]\n\n0003 [color=orange]3B[/color] DVF[color=yellow]% 14[/color] \nfloor division on address 14 by register",
      icon = "<instruction class=\"math\" id=\"3B\" x=\"3\" y=\"7\"  name=\"DVF\" type=\"register\"><line dy=\"12\"><cell    /><tspan dx=\"0 -3 -1\" dy=\"1 -9 8\" rotate=\"0 180 0\">/^=</tspan><register/></line></instruction>",
      func = function(G, A) -- TODO 0003 -- DVF% 14 ## floor division on memory at address 14 by value of cpu register
         local R = memory.peek(G, cpu.register)
         local M = memory.peek(G, A)
         M.count = sign(math.floor(M.count / R.count))
         memory.poke(G, A, M)
      end,
   },
   ["pci-24"] = {
      name = "DVC#",
      order = "2:4",
      locale = "pci-2C = #### [color=orange]2C[/color] DVC[color=acid]@ A[/color]\n\n0003 [color=orange]2C[/color] DVC[color=acid]@ 14[/color] \nceil division on register by address 14",
      icon = "<instruction class=\"math\" id=\"24\" x=\"4\" y=\"4\"  name=\"DVC\" type=\"value\"   ><line dy=\"12\"><register/><tspan dx=\"0 -4\" dy=\"-1 4 -3\">/^=</tspan><value   /></line></instruction>",
      func = function(G, V) -- TODO 0003 -- DVC# 14 ## ceil division on cpu register by 14
         local R = memory.peek(G, cpu.register)
         R.count = sign(math.ceil(R.count / V))
         memory.poke(G, cpu.register, R)
      end,
   },
   ["pci-34"] = {
      name = "DVC&",
      order = "3:4",
      locale = "pci-24 = #### [color=orange]24[/color] DVC[color=pink]# V[/color]\n\n0003 [color=orange]24[/color] DVC[color=pink]# 14[/color] \nceil division on register by value 14",
      icon = "<instruction class=\"math\" id=\"2C\" x=\"4\" y=\"5\"  name=\"DVC\" type=\"cell\"    ><line dy=\"12\"><register/><tspan dx=\"0 -4\" dy=\"-1 4 -3\">/^=</tspan><cell    /></line></instruction>",
      func = function(G, P) -- TODO 0003 -- DVC& 14 ## ceil division on memory at cpu.pointer 14 by value of cpu register
         local A = memory.peek(G, P).count
         local R = memory.peek(G, cpu.register)
         local M = memory.peek(G, A)
         M.count = sign(math.ceil(M.count / R.count))
         memory.poke(G, A, M)
      end,
   },
   ["pci-2C"] = {
      name = "DVC@",
      order = "2:C",
      locale = "pci-34 = #### [color=orange]34[/color] DVC[color=cyan]& P[/color]\n\n0003 [color=orange]34[/color] DVC[color=cyan]& 14[/color] \nceil division on cpu.pointer 14 by register",
      icon = "<instruction class=\"math\" id=\"34\" x=\"4\" y=\"6\"  name=\"DVC\" type=\"cpu.pointer\" ><line dy=\"12\"><cpu.pointer /><tspan dx=\"0 -4\" dy=\"-1 4 -3\">/^=</tspan><register/></line></instruction>",
      func = function(G, A) -- TODO 0003 -- DVC@ 14 ## ceil division on cpu register by value at address 14
         local M = memory.peek(G, A)
         local R = memory.peek(G, cpu.register)
         R.count = sign(math.ceil(R.count / M.count))
         memory.poke(G, cpu.register, R)
      end,
   },
   ["pci-3C"] = {
      name = "DVC%",
      order = "3:C",
      locale = "pci-3C = #### [color=orange]3C[/color] DVC[color=yellow]% A[/color]\n\n0003 [color=orange]3C[/color] DVC[color=yellow]% 14[/color] \nceil division on address 14 by register",
      icon = "<instruction class=\"math\" id=\"3C\" x=\"4\" y=\"7\"  name=\"DVC\" type=\"register\"><line dy=\"12\"><cell    /><tspan dx=\"0 -4\" dy=\"-1 4 -3\">/^=</tspan><register/></line></instruction>",
      func = function(G, A) -- TODO 0003 -- DVC% 14 ## ceil division on memory at address 14 by value of cpu register
         local R = memory.peek(G, cpu.register)
         local M = memory.peek(G, A)
         M.count = sign(math.ceil(M.count / R.count))
         memory.poke(G, A, M)
      end,
   },
   ["pci-25"] = {
      name = "MOD#",
      order = "2:5",
      locale = "pci-2D = #### [color=orange]2D[/color] MOD[color=acid]@ A[/color]\n\n0003 [color=orange]2D[/color] MOD[color=acid]@ 14[/color] \nmodulo on register by address 14",
      icon = "<instruction class=\"math\" id=\"25\" x=\"5\" y=\"4\"  name=\"MOD\" type=\"value\"   ><line dy=\"12\"><register/><tspan>%</tspan><setter/><value   /></line></instruction>",
      func = function(G, V) -- TODO 0003 -- MOD# 14 ## modulo 14 on cpu register
         local R = memory.peek(G, cpu.register)
         R.count = sign(R.count % V)
         memory.poke(G, cpu.register, R)
      end,
   },
   ["pci-2D"] = {
      name = "MOD@",
      order = "2:D",
      locale = "pci-25 = #### [color=orange]25[/color] MOD[color=pink]# V[/color]\n\n0003 [color=orange]25[/color] MOD[color=pink]# 14[/color] \nmodulo on register by value 14",
      icon = "<instruction class=\"math\" id=\"2D\" x=\"5\" y=\"5\"  name=\"MOD\" type=\"cell\"    ><line dy=\"12\"><register/><tspan>%</tspan><setter/><cell    /></line></instruction>",
      func = function(G, A) -- TODO 0003 -- MOD@ 14 ## modulo value at address 14 on cpu register
         local M = memory.peek(G, A)
         local R = memory.peek(G, cpu.register)
         R.count = sign(R.count % M.count)
         memory.poke(G, cpu.register, R)
      end,
   },
   ["pci-35"] = {
      name = "MOD&",
      order = "3:5",
      locale = "pci-35 = #### [color=orange]35[/color] MOD[color=cyan]& P[/color]\n\n0003 [color=orange]35[/color] MOD[color=cyan]& 14[/color] \nmodulo on cpu.pointer 14 by register",
      icon = "<instruction class=\"math\" id=\"35\" x=\"5\" y=\"6\"  name=\"MOD\" type=\"cpu.pointer\" ><line dy=\"12\"><cpu.pointer /><tspan>%</tspan><setter/><register/></line></instruction>",
      func = function(G, P) -- TODO 0003 -- MOD& 14 ## modulo value of cpu register on memory at cpu.pointer 14
         local A = memory.peek(G, P).count
         local R = memory.peek(G, cpu.register)
         local M = memory.peek(G, A)
         M.count = sign(M.count % R.count)
         memory.poke(G, A, M)
      end,
   },
   ["pci-3D"] = {
      name = "MOD%",
      order = "3:D",
      locale = "pci-3D = #### [color=orange]3D[/color] MOD[color=yellow]% A[/color]\n\n0003 [color=orange]3D[/color] MOD[color=yellow]% 14[/color] \nmodulo on address 14 by register",
      icon = "<instruction class=\"math\" id=\"3D\" x=\"5\" y=\"7\"  name=\"MOD\" type=\"register\"><line dy=\"12\"><cell    /><tspan>%</tspan><setter/><register/></line></instruction>",
      func = function(G, A) -- TODO 0003 -- MOD% 14 ## modulo value of cpu register on memory at address 14
         local R = memory.peek(G, cpu.register)
         local M = memory.peek(G, A)
         M.count = sign(M.count % R.count)
         memory.poke(G, A, M)
      end,
   },
   ["pci-26"] = {
      name = "NOT&",
      order = "2:6",
      locale = "pci-26 = #### [color=orange]26[/color] NOT[color=cyan]& P[/color]\n\n0003 [color=orange]26[/color] NOT[color=cyan]& 14[/color] \nbitwise not on cpu.pointer 14",
      icon = "<instruction class=\"math\" id=\"26\" x=\"6\" y=\"4\"  name=\"NOT\" type=\"cpu.pointer\" ><line dy=\"4 0 0 0 2\">   _ </line><line><cell dx=\"6\"/><tspan>=</tspan><cell/></line></instruction>",
      func = function(G, P) -- TODO 0003 -- NOT& 14 ## bitwise not on cpu.pointer 14
         local A = memory.peek(G, P).count
         local M = memory.peek(G, A)
         M.count = sign(b.bnot(M.count))
         memory.poke(G, A, M)
      end,
   },
   ["pci-2E"] = {
      name = "NOT@",
      order = "2:E",
      locale = "pci-2E = #### [color=orange]2E[/color] NOT[color=acid]@ A[/color]\n\n0003 [color=orange]2E[/color] NOT[color=acid]@ 14[/color] \nbitwise not on address 14",
      icon = "<instruction class=\"math\" id=\"2E\" x=\"6\" y=\"5\"  name=\"NOT\" type=\"cell\"    ><line dy=\"4 0 0 0 2\">   _ </line><line><cpu.pointer dx=\"6\"/><tspan>=</tspan><cpu.pointer/></line></instruction>",
      func = function(G, A) -- TODO 0003 -- NOT@ 14 ## bitwise not on address 14
         local M = memory.peek(G, A)
         M.count = sign(b.bnot(M.count))
         memory.poke(G, A, M)
      end,
   },
   ["pci-36"] = {
      name = "NEG&",
      order = "3:6",
      locale = "pci-36 = #### [color=orange]36[/color] NOT[color=cyan]& P[/color]\n\n0003 [color=orange]36[/color] NOT[color=cyan]& 14[/color] \nnegate on cpu.pointer 14",
      icon = "<instruction class=\"math\" id=\"36\" x=\"6\" y=\"6\"  name=\"NEG\" type=\"cpu.pointer\" ><line dy=\"12\"><cell    /><tspan dx=\"0 1\">=-</tspan><cell dx=\"1\"/></line></instruction>",
      func = function(G, P) -- TODO 0003 -- NOT& 14 ## negate on memory at cpu.pointer 14
         local A = memory.peek(G, P).count
         local M = memory.peek(G, A)
         M.count = sign(-M.count)
         memory.poke(G, A, M)
      end,
   },
   ["pci-3E"] = {
      name = "NEG@",
      order = "3:E",
      locale = "pci-3E = #### [color=orange]3E[/color] NOT[color=acid]@ A[/color]\n\n0003 [color=orange]3E[/color] NOT[color=acid]@ 14[/color] \nnegate on address 14",
      icon = "<instruction class=\"math\" id=\"3E\" x=\"6\" y=\"7\"  name=\"NEG\" type=\"cell\"    ><line dy=\"12\"><cpu.pointer /><tspan dx=\"0 1\">=-</tspan><cpu.pointer dx=\"1\"/></line></instruction>",
      func = function(G, A) -- TODO 0003 -- NOT@ 14 ## bitwise not on cpu.pointer 14
         local M = memory.peek(G, A)
         M.count = sign(-M.count)
         memory.poke(G, A, M)
      end,
   },
   ["pci-27"] = {
      name = "INC&",
      order = "2:7",
      locale = "pci-27 = #### [color=orange]27[/color] INC[color=cyan]& P[/color]\n\n0003 [color=orange]27[/color] INC[color=cyan]& 14[/color] \nincrease cpu.pointer 14 by 1",
      icon = "<instruction class=\"math\" id=\"27\" x=\"7\" y=\"4\"  name=\"INC\" type=\"cpu.pointer\" ><line dy=\"12\"><cpu.pointer /><tspan dx=\"0 0 1\">+=1</tspan></line></instruction>",
      func = function(G, P) -- TODO 0003 -- INC& 14 ## increase mem on cpu.pointer 14 by 1
         local A = memory.peek(G, P).count
         local M = memory.peek(G, A)
         M.count = sign(M.count + 1)
         memory.poke(G, A, M)
      end,
   },
   ["pci-2F"] = {
      name = "INC@",
      order = "2:F",
      locale = "pci-2F = #### [color=orange]2F[/color] INC[color=acid]@ A[/color]\n\n0003 [color=orange]2F[/color] INC[color=acid]@ 14[/color] \nincrease address 14 by 1",
      icon = "<instruction class=\"math\" id=\"2F\" x=\"7\" y=\"5\"  name=\"INC\" type=\"cell\"    ><line dy=\"12\"><cell    /><tspan dx=\"0 0 1\">+=1</tspan></line></instruction>",
      func = function(G, A) -- TODO 0003 -- INC@ 14 ## increase mem on address 14 by 1
         local M = memory.peek(G, A)
         M.count = sign(M.count + 1)
         memory.poke(G, A, M)
      end,
   },
   ["pci-37"] = {
      name = "DEC&",
      order = "3:7",
      locale = "pci-37 = #### [color=orange]37[/color] INC[color=cyan]& P[/color]\n\n0003 [color=orange]37[/color] INC[color=cyan]& 14[/color] \ndecrease cpu.pointer 14 by 1",
      icon = "<instruction class=\"math\" id=\"37\" x=\"7\" y=\"6\"  name=\"DEC\" type=\"cpu.pointer\" ><line dy=\"12\"><cpu.pointer /><tspan dx=\"1 1 1\">-=1</tspan></line></instruction>",
      func = function(G, P) -- TODO 0003 -- INC& 14 ## decrease mem on memory at cpu.pointer 14 by 1
         local A = memory.peek(G, P).count
         local M = memory.peek(G, A)
         M.count = sign(M.count - 1)
         memory.poke(G, A, M)
      end,
   },
   ["pci-3F"] = {
      name = "DEC@",
      order = "3:F",
      locale = "pci-3F = #### [color=orange]3F[/color] INC[color=acid]@ A[/color]\n\n0003 [color=orange]3F[/color] INC[color=acid]@ 14[/color] \ndecrease address 14 by 1",
      icon = "<instruction class=\"math\" id=\"3F\" x=\"7\" y=\"7\"  name=\"DEC\" type=\"cell\"    ><line dy=\"12\"><cell    /><tspan dx=\"1 1 1\">-=1</tspan></line></instruction>",
      func = function(G, A) -- TODO 0003 -- INC@ 14 ## increase mem on cpu.pointer 14 by 1
         local M = memory.peek(G, A)
         M.count = sign(M.count - 1)
         memory.poke(G, A, M)
      end,
   },
}
