local memory = require("__programmable-controllers__.control.memory")
local cpu = require("__programmable-controllers__.control.cpu_control")

local function sign(a) return (a + 2147483648) % 4294967296 - 2147483648 end

local function unsign(a) return a % 4294967296 end

local b = bit32

return {
    ["pci-40"] = {
        name = "BOR#",
        order = "4:0",
        locale = "pci-40 = #### [color=orange]40[/color] BOR[color=pink]# V[/color]\n\n0003 [color=orange]40[/color] BOR[color=pink]# 14[/color] \nbitwise or value 14 on register",
        icon = "<instruction class=\"bitwise\" id=\"40\" x=\"0\" y=\"8\"  name=\"BOR\" type=\"value\"   ><line dy=\"12\"><register/><or/><setter/><value   /></line></instruction>",
        func = function(G, V) -- TODO 0003 -- BOR# 14 ## bitwise or 14 on cpu register
            local R = memory.peek(G, cpu.register)
            R.count = sign(b.bor(R.count, V))
            memory.poke(G, cpu.register, R)
        end
    },
    ["pci-48"] = {
        name = "BOR@",
        order = "4:8",
        locale = "pci-48 = #### [color=orange]48[/color] BOR[color=acid]@ A[/color]\n\n0003 [color=orange]48[/color] BOR[color=acid]@ 14[/color] \nbitwise or address 14 on register",
        icon = "<instruction class=\"bitwise\" id=\"48\" x=\"0\" y=\"9\"  name=\"BOR\" type=\"cell\"    ><line dy=\"12\"><register/><or/><setter/><cell    /></line></instruction>",
        func = function(G, A) -- TODO 0003 -- BOR@ 14 ## bitwise or value at address 14 on cpu register
            local M = memory.peek(G, A)
            local R = memory.peek(G, cpu.register)
            R.count = sign(b.bor(R.count, M.count))
            memory.poke(G, cpu.register, R)
        end
    },
    ["pci-50"] = {
        name = "BOR&",
        order = "5:0",
        locale = "pci-50 = #### [color=orange]50[/color] BOR[color=cyan]& P[/color]\n\n0003 [color=orange]50[/color] BOR[color=cyan]& 14[/color] \nbitwise or register on cpu.pointer 14",
        icon = "<instruction class=\"bitwise\" id=\"50\" x=\"0\" y=\"10\" name=\"BOR\" type=\"cpu.pointer\" ><line dy=\"12\"><cpu.pointer /><or/><setter/><register/></line></instruction>",
        func = function(G, P) -- TODO 0003 -- BOR& 14 ## bitwise or value on cpu register on cell at cpu.pointer 14
            local A = memory.peek(G, P).count
            local R = memory.peek(G, cpu.register)
            local M = memory.peek(G, A)
            M.count = sign(b.bor(M.count, R.count))
            memory.poke(G, A, M)
        end
    },
    ["pci-58"] = {
        name = "BOR%",
        order = "5:8",
        locale = "pci-58 = #### [color=orange]58[/color] BOR[color=yellow]% A[/color]\n\n0003 [color=orange]58[/color] BOR[color=yellow]% 14[/color] \nbitwise or register on address 14",
        icon = "<instruction class=\"bitwise\" id=\"58\" x=\"0\" y=\"11\" name=\"BOR\" type=\"register\"><line dy=\"12\"><cell    /><or/><setter/><register/></line></instruction>",
        func = function(G, A) -- TODO 0003 -- BOR% 14 ## bitwise or value on cpu register on cell at address 14
            local R = memory.peek(G, cpu.register)
            local M = memory.peek(G, A)
            M.count = sign(b.bor(M.count, R.count))
            memory.poke(G, A, M)
        end
    },
    ["pci-41"] = {
        name = "NOR#",
        order = "4:1",
        locale = "pci-41 = #### [color=orange]41[/color] NOR[color=pink]# V[/color]\n\n0003 [color=orange]41[/color] NOR[color=pink]# 14[/color] \nbitwise nor value 14 on register",
        icon = "<instruction class=\"bitwise\" id=\"41\" x=\"1\" y=\"8\"  name=\"NOR\" type=\"value\"   ><line dy=\"4 0 0 0 2\"> _   </line><line><register/><or/><setter/><value   /></line></instruction>",
        func = function(G, V) -- TODO 0003 -- NOR# 14 ## bitwise nor 14 on cpu register
            local R = memory.peek(G, cpu.register)
            R.count = sign(b.bnot(b.bor(R.count, V)))
            memory.poke(G, cpu.register, R)
        end
    },
    ["pci-49"] = {
        name = "NOR@",
        order = "4:9",
        locale = "pci-49 = #### [color=orange]49[/color] NOR[color=acid]@ A[/color]\n\n0003 [color=orange]49[/color] NOR[color=acid]@ 14[/color] \nbitwise nor address 14 on register",
        icon = "<instruction class=\"bitwise\" id=\"49\" x=\"1\" y=\"9\"  name=\"NOR\" type=\"cell\"    ><line dy=\"4 0 0 0 2\"> _   </line><line><register/><or/><setter/><cell    /></line></instruction>",
        func = function(G, A) -- TODO 0003 -- NOR@ 14 ## bitwise nor value at address 14 on cpu register
            local M = memory.peek(G, A)
            local R = memory.peek(G, cpu.register)
            R.count = sign(b.bnot(b.bor(R.count, M.count)))
            memory.poke(G, cpu.register, R)
        end
    },
    ["pci-51"] = {
        name = "NOR&",
        order = "5:1",
        locale = "pci-51 = #### [color=orange]51[/color] NOR[color=cyan]& P[/color]\n\n0003 [color=orange]51[/color] NOR[color=cyan]& 14[/color] \nbitwise nor register on cpu.pointer 14",
        icon = "<instruction class=\"bitwise\" id=\"51\" x=\"1\" y=\"10\" name=\"NOR\" type=\"cpu.pointer\" ><line dy=\"4 0 0 0 2\"> _   </line><line><cpu.pointer /><or/><setter/><register/></line></instruction>",
        func = function(G, P) -- TODO 0003 -- NOR& 14 ## bitwise nor value on cpu register on cell at cpu.pointer 14
            local A = memory.peek(G, P).count
            local R = memory.peek(G, cpu.register)
            local M = memory.peek(G, A)
            M.count = sign(b.bnot(b.bor(M.count, R.count)))
            memory.poke(G, A, M)
        end
    },
    ["pci-59"] = {
        name = "NOR%",
        order = "5:9",
        locale = "pci-59 = #### [color=orange]59[/color] NOR[color=yellow]% A[/color]\n\n0003 [color=orange]59[/color] NOR[color=yellow]% 14[/color] \nbitwise nor register on address 14",
        icon = "<instruction class=\"bitwise\" id=\"59\" x=\"1\" y=\"11\" name=\"NOR\" type=\"register\"><line dy=\"4 0 0 0 2\"> _   </line><line><cell    /><or/><setter/><register/></line></instruction>",
        func = function(G, A) -- TODO 0003 -- NOR% 14 ## bitwise nor value on cpu register on cell at address 14
            local R = memory.peek(G, cpu.register)
            local M = memory.peek(G, A)
            M.count = sign(b.bnot(b.bor(M.count, R.count)))
            memory.poke(G, A, M)
        end
    },
    ["pci-42"] = {
        name = "ORN#",
        order = "4:2",
        locale = "pci-42 = #### [color=orange]42[/color] ORN[color=pink]# V[/color]\n\n0003 [color=orange]42[/color] ORN[color=pink]# 14[/color] \nbitwise or not value 14 on register",
        icon = "<instruction class=\"bitwise\" id=\"42\" x=\"2\" y=\"8\"  name=\"ORN\" type=\"value\"   ><line dy=\"4 0 0 0 2\">   _ </line><line><register/><or/><setter/><value   /></line></instruction>",
        func = function(G, V) -- TODO 0003 -- ORN# 14 ## bitwise or not 14 on cpu register
            local R = memory.peek(G, cpu.register)
            R.count = sign(b.bor(R.count, b.bnot(V)))
            memory.poke(G, cpu.register, R)
        end
    },
    ["pci-4A"] = {
        name = "ORN@",
        order = "4:A",
        locale = "pci-4A = #### [color=orange]4A[/color] ORN[color=acid]@ A[/color]\n\n0003 [color=orange]4A[/color] ORN[color=acid]@ 14[/color] \nbitwise or not address 14 on register",
        icon = "<instruction class=\"bitwise\" id=\"4A\" x=\"2\" y=\"9\"  name=\"ORN\" type=\"cell\"    ><line dy=\"4 0 0 0 2\">   _ </line><line><register/><or/><setter/><cell    /></line></instruction>",
        func = function(G, A) -- TODO 0003 -- ORN@ 14 ## bitwise or not value at address 14 on cpu register
            local M = memory.peek(G, A)
            local R = memory.peek(G, cpu.register)
            R.count = sign(b.bor(R.count, b.bnot(M.count)))
            memory.poke(G, cpu.register, R)
        end
    },
    ["pci-52"] = {
        name = "ORN&",
        order = "5:2",
        locale = "pci-52 = #### [color=orange]52[/color] ORN[color=cyan]& P[/color]\n\n0003 [color=orange]52[/color] ORN[color=cyan]& 14[/color] \nbitwise or not register on cpu.pointer 14",
        icon = "<instruction class=\"bitwise\" id=\"52\" x=\"2\" y=\"10\" name=\"ORN\" type=\"cpu.pointer\" ><line dy=\"4 0 0 0 2\">   _ </line><line><cpu.pointer /><or/><setter/><register/></line></instruction>",
        func = function(G, P) -- TODO 0003 -- ORN& 14 ## bitwise or not value on cpu register on cell at cpu.pointer 14
            local A = memory.peek(G, P).count
            local R = memory.peek(G, cpu.register)
            local M = memory.peek(G, A)
            M.count = sign(b.bor(M.count, b.bnot(R.count)))
            memory.poke(G, A, M)
        end
    },
    ["pci-5A"] = {
        name = "ORN%",
        order = "5:A",
        locale = "pci-5A = #### [color=orange]5A[/color] ORN[color=yellow]% A[/color]\n\n0003 [color=orange]5A[/color] ORN[color=yellow]% 14[/color] \nbitwise or not register on address 14",
        icon = "<instruction class=\"bitwise\" id=\"5A\" x=\"2\" y=\"11\" name=\"ORN\" type=\"register\"><line dy=\"4 0 0 0 2\">   _ </line><line><cell    /><or/><setter/><register/></line></instruction>",
        func = function(G, A) -- TODO 0003 -- ORN% 14 ## bitwise or not value on cpu register on cell at address 14
            local R = memory.peek(G, cpu.register)
            local M = memory.peek(G, A)
            M.count = sign(b.bor(M.count, b.bnot(R.count)))
            memory.poke(G, A, M)
        end
    },
    ["pci-43"] = {
        name = "NON#",
        order = "4:3",
        locale = "pci-43 = #### [color=orange]43[/color] NON[color=pink]# V[/color]\n\n0003 [color=orange]43[/color] NON[color=pink]# 14[/color] \nbitwise nor not value 14 on register",
        icon = "<instruction class=\"bitwise\" id=\"43\" x=\"3\" y=\"8\"  name=\"NON\" type=\"value\"   ><line dy=\"4 0 0 0 2\"> _ _ </line><line><register/><or/><setter/><value   /></line></instruction>",
        func = function(G, V) -- TODO 0003 -- NON# 14 ## bitwise nor not 14 on cpu register
            local R = memory.peek(G, cpu.register)
            R.count = sign(b.bnot(b.bor(R.count, b.bnot(V))))
            memory.poke(G, cpu.register, R)
        end
    },
    ["pci-4B"] = {
        name = "NON@",
        order = "4:B",
        locale = "pci-4B = #### [color=orange]4B[/color] NON[color=acid]@ A[/color]\n\n0003 [color=orange]4B[/color] NON[color=acid]@ 14[/color] \nbitwise nor not address 14 on register",
        icon = "<instruction class=\"bitwise\" id=\"4B\" x=\"3\" y=\"9\"  name=\"NON\" type=\"cell\"    ><line dy=\"4 0 0 0 2\"> _ _ </line><line><register/><or/><setter/><cell    /></line></instruction>",
        func = function(G, A) -- TODO 0003 -- NON@ 14 ## bitwise nor not value at address 14 on cpu register
            local M = memory.peek(G, A)
            local R = memory.peek(G, cpu.register)
            R.count = sign(b.bnot(b.bor(R.count, b.bnot(M.count))))
            memory.poke(G, cpu.register, R)
        end
    },
    ["pci-53"] = {
        name = "NON&",
        order = "5:3",
        locale = "pci-53 = #### [color=orange]53[/color] NON[color=cyan]& P[/color]\n\n0003 [color=orange]53[/color] NON[color=cyan]& 14[/color] \nbitwise nor not register on cpu.pointer 14",
        icon = "<instruction class=\"bitwise\" id=\"53\" x=\"3\" y=\"10\" name=\"NON\" type=\"cpu.pointer\" ><line dy=\"4 0 0 0 2\"> _ _ </line><line><cpu.pointer /><or/><setter/><register/></line></instruction>",
        func = function(G, P) -- TODO 0003 -- NON& 14 ## bitwise nor not value on cpu register on cell at cpu.pointer 14
            local A = memory.peek(G, P).count
            local R = memory.peek(G, cpu.register)
            local M = memory.peek(G, A)
            M.count = sign(b.bnot(b.bor(M.count, b.bnot(R.count))))
            memory.poke(G, A, M)
        end
    },
    ["pci-5B"] = {
        name = "NON%",
        order = "5:B",
        locale = "pci-5B = #### [color=orange]5B[/color] NON[color=yellow]% A[/color]\n\n0003 [color=orange]5B[/color] NON[color=yellow]% 14[/color] \nbitwise nor not register on address 14",
        icon = "<instruction class=\"bitwise\" id=\"5B\" x=\"3\" y=\"11\" name=\"NON\" type=\"register\"><line dy=\"4 0 0 0 2\"> _ _ </line><line><cell    /><or/><setter/><register/></line></instruction>",
        func = function(G, A) -- TODO 0003 -- NON% 14 ## bitwise nor not value on cpu register on cell at address 14
            local R = memory.peek(G, cpu.register)
            local M = memory.peek(G, A)
            M.count = sign(b.bnot(b.bor(M.count, b.bnot(R.count))))
            memory.poke(G, A, M)
        end
    },
    ["pci-44"] = {
        name = "AND#",
        order = "4:4",
        locale = "pci-44 = #### [color=orange]44[/color] AND[color=pink]# V[/color]\n\n0003 [color=orange]44[/color] AND[color=pink]# 14[/color] \nbitwise and value 14 on register",
        icon = "<instruction class=\"bitwise\" id=\"44\" x=\"4\" y=\"8\"  name=\"AND\" type=\"value\"   ><line dy=\"12\"><register/><and/><setter/><value   /></line></instruction>",
        func = function(G, V) -- TODO 0003 -- AND# 14 ## bitwise and 14 on cpu register
            local R = memory.peek(G, cpu.register)
            R.count = sign(b.band(R.count, V))
            memory.poke(G, cpu.register, R)
        end
    },
    ["pci-4C"] = {
        name = "AND@",
        order = "4:C",
        locale = "pci-4C = #### [color=orange]4C[/color] AND[color=acid]@ A[/color]\n\n0003 [color=orange]4C[/color] AND[color=acid]@ 14[/color] \nbitwise and address 14 on register",
        icon = "<instruction class=\"bitwise\" id=\"4C\" x=\"4\" y=\"9\"  name=\"AND\" type=\"cell\"    ><line dy=\"12\"><register/><and/><setter/><cell    /></line></instruction>",
        func = function(G, A) -- TODO 0003 -- AND@ 14 ## bitwise and value at address 14 on cpu register
            local M = memory.peek(G, A)
            local R = memory.peek(G, cpu.register)
            R.count = sign(b.band(R.count, M.count))
            memory.poke(G, cpu.register, R)
        end
    },
    ["pci-54"] = {
        name = "AND&",
        order = "5:4",
        locale = "pci-54 = #### [color=orange]54[/color] AND[color=cyan]& P[/color]\n\n0003 [color=orange]54[/color] AND[color=cyan]& 14[/color] \nbitwise and register on cpu.pointer 14",
        icon = "<instruction class=\"bitwise\" id=\"54\" x=\"4\" y=\"10\" name=\"AND\" type=\"cpu.pointer\" ><line dy=\"12\"><cpu.pointer /><and/><setter/><register/></line></instruction>",
        func = function(G, P) -- TODO 0003 -- AND& 14 ## bitwise and value on cpu register on cell at cpu.pointer 14
            local A = memory.peek(G, P).count
            local R = memory.peek(G, cpu.register)
            local M = memory.peek(G, A)
            M.count = sign(b.band(M.count, R.count))
            memory.poke(G, A, M)
        end
    },
    ["pci-5C"] = {
        name = "AND%",
        order = "5:C",
        locale = "pci-5C = #### [color=orange]5C[/color] AND[color=yellow]% A[/color]\n\n0003 [color=orange]5C[/color] AND[color=yellow]% 14[/color] \nbitwise and register on address 14",
        icon = "<instruction class=\"bitwise\" id=\"5C\" x=\"4\" y=\"11\" name=\"AND\" type=\"register\"><line dy=\"12\"><cell    /><and/><setter/><register/></line></instruction>",
        func = function(G, A) -- TODO 0003 -- AND% 14 ## bitwise and value on cpu register on cell at address 14
            local R = memory.peek(G, cpu.register)
            local M = memory.peek(G, A)
            M.count = sign(b.band(M.count, R.count))
            memory.poke(G, A, M)
        end
    },
    ["pci-45"] = {
        name = "NAD#",
        order = "4:5",
        locale = "pci-45 = #### [color=orange]45[/color] NAD[color=pink]# V[/color]\n\n0003 [color=orange]45[/color] NAD[color=pink]# 14[/color] \nbitwise nand value 14 on register",
        icon = "<instruction class=\"bitwise\" id=\"45\" x=\"5\" y=\"8\"  name=\"NAD\" type=\"value\"   ><line dy=\"4 0 0 0 2\"> _   </line><line><register/><and/><setter/><value   /></line></instruction>",
        func = function(G, V) -- TODO 0003 -- NAD# 14 ## bitwise nand 14 on cpu register
            local R = memory.peek(G, cpu.register)
            R.count = sign(b.bnot(b.band(R.count, V)))
            memory.poke(G, cpu.register, R)
        end
    },
    ["pci-4D"] = {
        name = "NAD@",
        order = "4:D",
        locale = "pci-4D = #### [color=orange]4D[/color] NAD[color=acid]@ A[/color]\n\n0003 [color=orange]4D[/color] NAD[color=acid]@ 14[/color] \nbitwise nand address 14 on register",
        icon = "<instruction class=\"bitwise\" id=\"4D\" x=\"5\" y=\"9\"  name=\"NAD\" type=\"cell\"    ><line dy=\"4 0 0 0 2\"> _   </line><line><register/><and/><setter/><cell    /></line></instruction>",
        func = function(G, A) -- TODO 0003 -- NAD@ 14 ## bitwise nand value at address 14 on cpu register
            local M = memory.peek(G, A)
            local R = memory.peek(G, cpu.register)
            R.count = sign(b.bnot(b.band(R.count, M.count)))
            memory.poke(G, cpu.register, R)
        end
    },
    ["pci-55"] = {
        name = "NAD&",
        order = "5:5",
        locale = "pci-55 = #### [color=orange]55[/color] NAD[color=cyan]& P[/color]\n\n0003 [color=orange]55[/color] NAD[color=cyan]& 14[/color] \nbitwise nand register on cpu.pointer 14",
        icon = "<instruction class=\"bitwise\" id=\"55\" x=\"5\" y=\"10\" name=\"NAD\" type=\"cpu.pointer\" ><line dy=\"4 0 0 0 2\"> _   </line><line><cpu.pointer /><and/><setter/><register/></line></instruction>",
        func = function(G, P) -- TODO 0003 -- NAD& 14 ## bitwise nand value on cpu register on cell at cpu.pointer 14
            local A = memory.peek(G, P).count
            local R = memory.peek(G, cpu.register)
            local M = memory.peek(G, A)
            M.count = sign(b.bnot(b.band(M.count, R.count)))
            memory.poke(G, A, M)
        end
    },
    ["pci-5D"] = {
        name = "NAD%",
        order = "5:D",
        locale = "pci-5D = #### [color=orange]5D[/color] NAD[color=yellow]% A[/color]\n\n0003 [color=orange]5D[/color] NAD[color=yellow]% 14[/color] \nbitwise nand register on address 14",
        icon = "<instruction class=\"bitwise\" id=\"5D\" x=\"5\" y=\"11\" name=\"NAD\" type=\"register\"><line dy=\"4 0 0 0 2\"> _   </line><line><cell    /><and/><setter/><register/></line></instruction>",
        func = function(G, A) -- TODO 0003 -- NAD% 14 ## bitwise nand value on cpu register on cell at address 14
            local R = memory.peek(G, cpu.register)
            local M = memory.peek(G, A)
            M.count = sign(b.bnot(b.band(M.count, R.count)))
            memory.poke(G, A, M)
        end
    },
    ["pci-46"] = {
        name = "ADN#",
        order = "4:6",
        locale = "pci-46 = #### [color=orange]46[/color] ADN[color=pink]# V[/color]\n\n0003 [color=orange]46[/color] ADN[color=pink]# 14[/color] \nbitwise and not value 14 on register",
        icon = "<instruction class=\"bitwise\" id=\"46\" x=\"6\" y=\"8\"  name=\"ADN\" type=\"value\"   ><line dy=\"4 0 0 0 2\">   _ </line><line><register/><and/><setter/><value   /></line></instruction>",
        func = function(G, V) -- TODO 0003 -- ADN# 14 ## bitwise and not 14 on cpu register
            local R = memory.peek(G, cpu.register)
            R.count = sign(b.band(R.count, b.bnot(V)))
            memory.poke(G, cpu.register, R)
        end
    },
    ["pci-4E"] = {
        name = "ADN@",
        order = "4:E",
        locale = "pci-4E = #### [color=orange]4E[/color] ADN[color=acid]@ A[/color]\n\n0003 [color=orange]4E[/color] ADN[color=acid]@ 14[/color] \nbitwise and not address 14 on register",
        icon = "<instruction class=\"bitwise\" id=\"4E\" x=\"6\" y=\"9\"  name=\"ADN\" type=\"cell\"    ><line dy=\"4 0 0 0 2\">   _ </line><line><register/><and/><setter/><cell    /></line></instruction>",
        func = function(G, A) -- TODO 0003 -- ADN@ 14 ## bitwise and not value at address 14 on cpu register
            local M = memory.peek(G, A)
            local R = memory.peek(G, cpu.register)
            R.count = sign(b.band(R.count, b.bnot(M.count)))
            memory.poke(G, cpu.register, R)
        end
    },
    ["pci-56"] = {
        name = "ADN&",
        order = "5:6",
        locale = "pci-56 = #### [color=orange]56[/color] ADN[color=cyan]& P[/color]\n\n0003 [color=orange]56[/color] ADN[color=cyan]& 14[/color] \nbitwise and not register on cpu.pointer 14",
        icon = "<instruction class=\"bitwise\" id=\"56\" x=\"6\" y=\"10\" name=\"ADN\" type=\"cpu.pointer\" ><line dy=\"4 0 0 0 2\">   _ </line><line><cpu.pointer /><and/><setter/><register/></line></instruction>",
        func = function(G, P) -- TODO 0003 -- ADN& 14 ## bitwise and not value on cpu register on cell at cpu.pointer 14
            local A = memory.peek(G, P).count
            local R = memory.peek(G, cpu.register)
            local M = memory.peek(G, A)
            M.count = sign(b.band(M.count, b.bnot(R.count)))
            memory.poke(G, A, M)
        end
    },
    ["pci-5E"] = {
        name = "ADN%",
        order = "5:E",
        locale = "pci-5E = #### [color=orange]5E[/color] ADN[color=yellow]% A[/color]\n\n0003 [color=orange]5E[/color] ADN[color=yellow]% 14[/color] \nbitwise and not register on address 14",
        icon = "<instruction class=\"bitwise\" id=\"5E\" x=\"6\" y=\"11\" name=\"ADN\" type=\"register\"><line dy=\"4 0 0 0 2\">   _ </line><line><cell    /><and/><setter/><register/></line></instruction>",
        func = function(G, A) -- TODO 0003 -- ADN% 14 ## bitwise and not value on cpu register on cell at address 14
            local R = memory.peek(G, cpu.register)
            local M = memory.peek(G, A)
            M.count = sign(b.band(M.count, b.bnot(R.count)))
            memory.poke(G, A, M)
        end
    },
    ["pci-47"] = {
        name = "NDN#",
        order = "4:7",
        locale = "pci-47 = #### [color=orange]47[/color] NDN[color=pink]# V[/color]\n\n0003 [color=orange]47[/color] NDN[color=pink]# 14[/color] \nbitwise nand not value 14 on register",
        icon = "<instruction class=\"bitwise\" id=\"47\" x=\"7\" y=\"8\"  name=\"NDN\" type=\"value\"   ><line dy=\"4 0 0 0 2\"> _ _ </line><line><register/><and/><setter/><value   /></line></instruction>",
        func = function(G, V) -- TODO 0003 -- NDN# 14 ## bitwise nand not 14 on cpu register
            local R = memory.peek(G, cpu.register)
            R.count = sign(b.bnot(b.band(R.count, b.bnot(V))))
            memory.poke(G, cpu.register, R)
        end
    },
    ["pci-4F"] = {
        name = "NDN@",
        order = "4:F",
        locale = "pci-4F = #### [color=orange]4F[/color] NDN[color=acid]@ A[/color]\n\n0003 [color=orange]4F[/color] NDN[color=acid]@ 14[/color] \nbitwise nand not address 14 on register",
        icon = "<instruction class=\"bitwise\" id=\"4F\" x=\"7\" y=\"9\"  name=\"NDN\" type=\"cell\"    ><line dy=\"4 0 0 0 2\"> _ _ </line><line><register/><and/><setter/><cell    /></line></instruction>",
        func = function(G, A) -- TODO 0003 -- NDN@ 14 ## bitwise nand not value at address 14 on cpu register
            local M = memory.peek(G, A)
            local R = memory.peek(G, cpu.register)
            R.count = sign(b.bnot(b.band(R.count, b.bnot(M).count)))
            memory.poke(G, cpu.register, R)
        end
    },
    ["pci-57"] = {
        name = "NDN&",
        order = "5:7",
        locale = "pci-57 = #### [color=orange]57[/color] NDN[color=cyan]& P[/color]\n\n0003 [color=orange]57[/color] NDN[color=cyan]& 14[/color] \nbitwise nand not register on cpu.pointer 14",
        icon = "<instruction class=\"bitwise\" id=\"57\" x=\"7\" y=\"10\" name=\"NDN\" type=\"cpu.pointer\" ><line dy=\"4 0 0 0 2\"> _ _ </line><line><cpu.pointer /><and/><setter/><register/></line></instruction>",
        func = function(G, P) -- TODO 0003 -- NDN& 14 ## bitwise nand not value on cpu register on cell at cpu.pointer 14
            local A = memory.peek(G, P).count
            local R = memory.peek(G, cpu.register)
            local M = memory.peek(G, A)
            M.count = sign(b.bnot(b.band(M.count, b.bnot(R).count)))
            memory.poke(G, A, M)
        end
    },
    ["pci-5F"] = {
        name = "NDN%",
        order = "5:F",
        locale = "pci-5F = #### [color=orange]5F[/color] NDN[color=yellow]% A[/color]\n\n0003 [color=orange]5F[/color] NDN[color=yellow]% 14[/color] \nbitwise nand not register on address 14",
        icon = "<instruction class=\"bitwise\" id=\"5F\" x=\"7\" y=\"11\" name=\"NDN\" type=\"register\"><line dy=\"4 0 0 0 2\"> _ _ </line><line><cell    /><and/><setter/><register/></line></instruction>",
        func = function(G, A) -- TODO 0003 -- NDN% 14 ## bitwise nand not value on cpu register on cell at address 14
            local R = memory.peek(G, cpu.register)
            local M = memory.peek(G, A)
            M.count = sign(b.bnot(b.band(M.count, b.bnot(R).count)))
            memory.poke(G, A, M)
        end
    },
    ["pci-60"] = {
        name = "LSH#",
        order = "6:0",
        icon = "<instruction class=\"bitwise\" id=\"60\" x=\"0\" y=\"12\" name=\"LSH\" type=\"value\"   ><line dy=\"12\"><register/><leftshift/><setter/><value   /></line></instruction>",
        locale = "",
        func = function(G, A) end
    },
    ["pci-68"] = {
        name = "LSH",
        order = "6:8",
        icon = "<instruction class=\"bitwise\" id=\"68\" x=\"0\" y=\"13\" name=\"LSH\" type=\"cell\"    ><line dy=\"12\"><register/><leftshift/><setter/><cell    /></line></instruction>"
    },
    ["pci-70"] = {
        name = "LSH",
        order = "7:0",
        icon = "<instruction class=\"bitwise\" id=\"70\" x=\"0\" y=\"14\" name=\"LSH\" type=\"cpu.pointer\" ><line dy=\"12\"><cpu.pointer /><leftshift/><setter/><register/></line></instruction>"
    },
    ["pci-78"] = {
        name = "LSH",
        order = "7:8",
        icon = "<instruction class=\"bitwise\" id=\"78\" x=\"0\" y=\"15\" name=\"LSH\" type=\"register\"><line dy=\"12\"><cell    /><leftshift/><setter/><register/></line></instruction>"
    },
    ["pci-61"] = {
        name = "RSH",
        order = "6:1",
        icon = "<instruction class=\"bitwise\" id=\"61\" x=\"1\" y=\"12\" name=\"RSH\" type=\"value\"   ><line dy=\"12\"><register/><rightshift/><setter/><value   /></line></instruction>",
        locale = "",
        func = function(G, A) end
    },
    ["pci-69"] = {
        name = "RSH",
        order = "6:9",
        icon = "<instruction class=\"bitwise\" id=\"69\" x=\"1\" y=\"13\" name=\"RSH\" type=\"cell\"    ><line dy=\"12\"><register/><rightshift/><setter/><cell    /></line></instruction>"
    },
    ["pci-71"] = {
        name = "RSH",
        order = "7:1",
        icon = "<instruction class=\"bitwise\" id=\"71\" x=\"1\" y=\"14\" name=\"RSH\" type=\"cpu.pointer\" ><line dy=\"12\"><cpu.pointer /><rightshift/><setter/><register/></line></instruction>"
    },
    ["pci-79"] = {
        name = "RSH",
        order = "7:9",
        icon = "<instruction class=\"bitwise\" id=\"79\" x=\"1\" y=\"15\" name=\"RSH\" type=\"register\"><line dy=\"12\"><cell    /><rightshift/><setter/><register/></line></instruction>"
    },
    ["pci-62"] = {
        name = "XOR",
        order = "6:2",
        icon = "<instruction class=\"bitwise\" id=\"62\" x=\"2\" y=\"12\" name=\"XOR\" type=\"value\"   ><line dy=\"12\"><register/><xor/><setter/><value   /></line></instruction>",
        locale = "",
        func = function(G, A) end
    },
    ["pci-6A"] = {
        name = "XOR",
        order = "6:A",
        icon = "<instruction class=\"bitwise\" id=\"6A\" x=\"2\" y=\"13\" name=\"XOR\" type=\"cell\"    ><line dy=\"12\"><register/><xor/><setter/><cell    /></line></instruction>"
    },
    ["pci-72"] = {
        name = "XOR",
        order = "7:2",
        icon = "<instruction class=\"bitwise\" id=\"72\" x=\"2\" y=\"14\" name=\"XOR\" type=\"cpu.pointer\" ><line dy=\"12\"><cpu.pointer /><xor/><setter/><register/></line></instruction>"
    },
    ["pci-7A"] = {
        name = "XOR",
        order = "7:A",
        icon = "<instruction class=\"bitwise\" id=\"7A\" x=\"2\" y=\"15\" name=\"XOR\" type=\"register\"><line dy=\"12\"><cell    /><xor/><setter/><register/></line></instruction>"
    },
    ["pci-63"] = {
        name = "NXR",
        order = "6:3",
        icon = "<instruction class=\"bitwise\" id=\"63\" x=\"3\" y=\"12\" name=\"NXR\" type=\"value\"   ><line dy=\"4 0 0 0 2\"> _   </line><line><register/><tspan>v</tspan><setter/><value   /></line></instruction>",
        locale = "",
        func = function(G, A) end
    },
    ["pci-6B"] = {
        name = "NXR",
        order = "6:B",
        icon = "<instruction class=\"bitwise\" id=\"6B\" x=\"3\" y=\"13\" name=\"NXR\" type=\"cell\"    ><line dy=\"4 0 0 0 2\"> _   </line><line><register/><tspan>v</tspan><setter/><cell    /></line></instruction>"
    },
    ["pci-73"] = {
        name = "NXR",
        order = "7:3",
        icon = "<instruction class=\"bitwise\" id=\"73\" x=\"3\" y=\"14\" name=\"NXR\" type=\"cpu.pointer\" ><line dy=\"4 0 0 0 2\"> _   </line><line><cpu.pointer /><tspan>v</tspan><setter/><register/></line></instruction>"
    },
    ["pci-7B"] = {
        name = "NXR",
        order = "7:B",
        icon = "<instruction class=\"bitwise\" id=\"7B\" x=\"3\" y=\"15\" name=\"NXR\" type=\"register\"><line dy=\"4 0 0 0 2\"> _   </line><line><cell    /><tspan>v</tspan><setter/><register/></line></instruction>"
    },
    ["pci-64"] = {
        name = "RND",
        order = "6:4",
        icon = "<instruction class=\"bitwise\" id=\"64\" x=\"4\" y=\"12\" name=\"RND\" type=\"value\"   ><line dy=\"12\"><register/><setter/><tspan>?</tspan><value   /></line></instruction>",
        locale = "",
        func = function(G, A) end
    },
    ["pci-6C"] = {
        name = "RND",
        order = "6:C",
        icon = "<instruction class=\"bitwise\" id=\"6C\" x=\"4\" y=\"13\" name=\"RND\" type=\"cell\"    ><line dy=\"12\"><register/><setter/><tspan>?</tspan><cell    /></line></instruction>"
    },
    ["pci-74"] = {
        name = "RND",
        order = "7:4",
        icon = "<instruction class=\"bitwise\" id=\"74\" x=\"4\" y=\"14\" name=\"RND\" type=\"cpu.pointer\" ><line dy=\"12\"><cpu.pointer /><setter/><tspan>?</tspan><register/></line></instruction>"
    },
    ["pci-7C"] = {
        name = "RND",
        order = "7:C",
        icon = "<instruction class=\"bitwise\" id=\"7C\" x=\"4\" y=\"15\" name=\"RND\" type=\"register\"><line dy=\"12\"><cell    /><setter/><tspan>?</tspan><register/></line></instruction>"
    },
    ["pci-65"] = {
        name = "REG",
        order = "6:5",
        icon = "<instruction class=\"bitwise\" id=\"65\" x=\"5\" y=\"12\" name=\"REG\" type=\"value\"   ><line>RLOC</line><line><register/>TO<value   /></line></instruction>",
        locale = "",
        func = function(G, A) end
    },
    ["pci-6D"] = {
        name = "REG",
        order = "6:D",
        icon = "<instruction class=\"bitwise\" id=\"6D\" x=\"5\" y=\"13\" name=\"REG\" type=\"cell\"    ><line>RLOC</line><line><register/>TO<cell    /></line></instruction>",
        locale = "",
        func = function(G, A) end
    },
    ["pci-75"] = {
        name = "REG",
        order = "7:5",
        icon = "<instruction class=\"bitwise\" id=\"75\" x=\"5\" y=\"14\" name=\"REG\" type=\"cpu.pointer\" ><line>RLOC</line><line><register/>TO<cpu.pointer /></line></instruction>",
        locale = "",
        func = function(G, A) end
    },
    ["pci-7D"] = {
        name = "REG",
        order = "7:D",
        icon = "<instruction class=\"bitwise\" id=\"7D\" x=\"5\" y=\"15\" name=\"REG\" type=\"register\"><line>RLOC</line><line><register/>TO<register/></line></instruction>",
        locale = "",
        func = function(G, A) end
    },
    ["pci-66"] = {
        name = "CCP",
        order = "6:6",
        icon = "<instruction class=\"bitwise\" id=\"66\" x=\"6\" y=\"12\" name=\"CCP\" type=\"value\"   ><line>RLOC</line><line><control/>TO<value   /></line></instruction>",
        locale = "",
        func = function(G, A) end
    },
    ["pci-6E"] = {
        name = "CCP",
        order = "6:E",
        icon = "<instruction class=\"bitwise\" id=\"6E\" x=\"6\" y=\"13\" name=\"CCP\" type=\"cell\"    ><line>RLOC</line><line><control/>TO<cell    /></line></instruction>",
        locale = "",
        func = function(G, A) end
    },
    ["pci-76"] = {
        name = "CCP",
        order = "7:6",
        icon = "<instruction class=\"bitwise\" id=\"76\" x=\"6\" y=\"14\" name=\"CCP\" type=\"cpu.pointer\" ><line>RLOC</line><line><control/>TO<cpu.pointer /></line></instruction>",
        locale = "",
        func = function(G, A) end
    },
    ["pci-7E"] = {
        name = "CCP",
        order = "7:E",
        icon = "<instruction class=\"bitwise\" id=\"7E\" x=\"6\" y=\"15\" name=\"CCP\" type=\"register\"><line>RLOC</line><line><control/>TO<register/></line></instruction>",
        locale = "",
        func = function(G, A) end
    },
    ["pci-67"] = {
        name = "PID",
        order = "6:7",
        icon = "<instruction class=\"bitwise\" id=\"67\" x=\"7\" y=\"12\" name=\"PID\" type=\"value\"   ><line>RLOC</line><line><control/>TO<value   /></line></instruction>",
        locale = "",
        func = function(G, A) end
    },
    ["pci-6F"] = {
        name = "PID",
        order = "6:F",
        icon = "<instruction class=\"bitwise\" id=\"6F\" x=\"7\" y=\"13\" name=\"PID\" type=\"cell\"    ><line>RLOC</line><line><control/>TO<cell    /></line></instruction>",
        locale = "",
        func = function(G, A) end
    },
    ["pci-77"] = {
        name = "PID",
        order = "7:7",
        icon = "<instruction class=\"bitwise\" id=\"77\" x=\"7\" y=\"14\" name=\"PID\" type=\"cpu.pointer\" ><line>RLOC</line><line><control/>TO<cpu.pointer /></line></instruction>",
        locale = "",
        func = function(G, A) end
    },
    ["pci-7F"] = {
        name = "PID",
        order = "7:F",
        icon = "<instruction class=\"bitwise\" id=\"7F\" x=\"7\" y=\"15\" name=\"PID\" type=\"register\"><line>RLOC</line><line><control/>TO<register/></line></instruction>",
        locale = "",
        func = function(G, A) end
    }
}
