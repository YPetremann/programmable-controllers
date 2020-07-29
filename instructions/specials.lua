local memory = require("__programmable-controllers__.control.memory")
local cpu = require("__programmable-controllers__.control.cpu_control")

local function sign(a) return (a + 2147483648) % 4294967296 - 2147483648 end

local function unsign(a) return a % 4294967296 end

local b = bit32
return {
    ["pci-EE0"] = {
        name = "",
        order = "E:E",
        locale = "",
        icon = "<instruction class=\"special\" id=\"EE\" x=\"7\" y=\"15\" name=\"PID\" type=\"register\"><line>RLOC</line><line><control/>TO<register/></line></instruction>",
        func = function(G, A) -- SHIFT
            R = cpu.register.count
            C = unsign(memory.peek(G, A).count)
            C.count = unsign(C.count) * 2 ^ R
            memory.poke(G, A, C)
        end
    },
    ["pci-EE1"] = {
        name = "",
        order = "E:E",
        locale = "",
        icon = "<instruction class=\"special\" id=\"EE\" x=\"7\" y=\"15\" name=\"PID\" type=\"register\"><line>RLOC</line><line><control/>TO<register/></line></instruction>",
        func = function(G, A) -- UNSHIFT
            R = memory.peek(G, cpu.register)
            C = memory.peek(G, A)
            C.count = math.floor(unsign(C.count) / 2 ^ R.count)
            memory.poke(G, A, C)
        end
    },
    ["pci-EE2"] = {
        name = "",
        order = "E:E",
        locale = "",
        icon = "<instruction class=\"special\" id=\"EE\" x=\"7\" y=\"15\" name=\"PID\" type=\"register\"><line>RLOC</line><line><control/>TO<register/></line></instruction>",
        func = function(G, A) -- SHIFT
            R = cpu.register.count
            C = unsign(memory.peek(G, A).count)
            C.count = unsign(C.count) * 2 ^ R
            memory.poke(G, A, C)
        end
    },
    ["pci-EE3"] = {
        name = "",
        order = "E:E",
        locale = "",
        icon = "<instruction class=\"special\" id=\"EE\" x=\"7\" y=\"15\" name=\"PID\" type=\"register\"><line>RLOC</line><line><control/>TO<register/></line></instruction>",
        func = function(G, A) -- UNSHIFT
            R = memory.peek(G, cpu.register)
            C = memory.peek(G, A)
            C.count = math.floor(unsign(C.count) / 2 ^ R.count)
            memory.poke(G, A, C)
        end
    },
    ["pci-EE4"] = {
        name = "",
        order = "E:E",
        locale = "",
        icon = "<instruction class=\"special\" id=\"EE\" x=\"7\" y=\"15\" name=\"PID\" type=\"register\"><line>RLOC</line><line><control/>TO<register/></line></instruction>",
        func = function(G, A) -- RND
            C = memory.peek(G, A)
            C.count = math.random(-2147483648, 2147483647)
            memory.poke(G, A, C)
        end
    },
    ["pci-Z00"] = {
        name = "",
        order = "Z0:0",
        locale = "pci-FF = #### [color=orange]FF[/color] DBG[color=acid]@ A[/color]\n\n0003 [color=orange]FF[/color] DBG[color=acid]@ 14[/color] \nprint mem at address 14 in chat",
        icon = "<instruction class=\"special\" id=\"Z00\" x=\"7\" y=\"15\" name=\"PID\" type=\"register\"><line>RLOC</line><line><control/>TO<register/></line></instruction>",
        func = function(G, A) -- F0 UNIT V : do unit test V
            if A == 0 then
                -- set register initial value
                memory.poke(G, cpu.register, {
                    signal = {type = "virtual", name = "pci-00"},
                    count = 0
                })
                -- set UNIT test code
                memory.poke(G, cpu.control + 3, {
                    signal = {type = "virtual", name = "pci-Z00"},
                    count = 0
                })
                -- instructions
                memory.poke(G, cpu.control + 4, {
                    signal = {type = "virtual", name = "pci-01"},
                    count = 2
                })
                memory.poke(G, cpu.control + 5, {
                    signal = {type = "virtual", name = "pci-14"},
                    count = 2
                })
                memory.poke(G, cpu.control + 6, {
                    signal = {type = "virtual", name = "pci-10"},
                    count = 12
                })
                memory.poke(G, cpu.control + 7, {
                    signal = {type = "virtual", name = "pci-01"},
                    count = 1
                })
                memory.poke(G, cpu.control + 8, {
                    signal = {type = "virtual", name = "pci-14"},
                    count = 1
                })
                memory.poke(G, cpu.control + 9, {
                    signal = {type = "virtual", name = "pci-00"},
                    count = 0
                })
                memory.poke(G, cpu.control + 10, {
                    signal = {type = "virtual", name = "pci-00"},
                    count = 0
                })
                -- display if error
                memory.poke(G, cpu.control + 11, {
                    signal = {type = "virtual", name = "pci-Z01"},
                    count = 15
                })
                -- ending
                memory.poke(G, cpu.control + 12, {
                    signal = {type = "virtual", name = "pci-Z04"},
                    count = 15
                })
                memory.poke(G, cpu.control + 13, {
                    signal = {type = "virtual", name = "pci-0E"},
                    count = 1
                })
                memory.poke(G, cpu.control + 14, {
                    signal = {type = "virtual", name = "pci-10"},
                    count = 3
                })
                memory.poke(G, cpu.control + 15, {
                    signal = {type = "virtual", name = "signal-green"},
                    count = 0
                })
            end
        end
    },
    ["pci-Z01"] = {
        name = "",
        order = "Z0:1",
        locale = "",
        icon = "<instruction class=\"special\" id=\"Z01\" x=\"7\" y=\"15\" name=\"PID\" type=\"register\"><line>RLOC</line><line><control/>TO<register/></line></instruction>",
        func = function(G, A) -- F1 FAIL V : indicate fail on test V
            memory.poke(G, cpu.control + 15, {
                signal = {type = "virtual", name = "signal-red"},
                count = A
            })
        end
    },
    ["pci-Z02"] = {
        name = "",
        order = "Z0:2",
        locale = "",
        icon = "<instruction class=\"special\" id=\"Z02\" x=\"7\" y=\"15\" name=\"PID\" type=\"register\"><line>RLOC</line><line><control/>TO<register/></line></instruction>",
        func = function(G, A) -- F2 WARN V : indicate warning on test V
            memory.poke(G, cpu.control + 15, {
                signal = {type = "virtual", name = "signal-yellow"},
                count = A
            })
        end
    },
    ["pci-Z03"] = {
        name = "",
        order = "Z0:3",
        locale = "",
        icon = "<instruction class=\"special\" id=\"Z03\" x=\"7\" y=\"15\" name=\"PID\" type=\"register\"><line>RLOC</line><line><control/>TO<register/></line></instruction>",
        func = function(G, A) -- F3 DONE V : indicate done test V
            memory.poke(G, cpu.control + 15, {
                signal = {type = "virtual", name = "signal-green"},
                count = A
            })
        end
    },
    ["pci-Z04"] = {
        name = "",
        order = "Z0:4",
        locale = "",
        icon = "<instruction id=\"Z04\" x=\"7\" y=\"15\" name=\"PID\" type=\"register\"><line>RLOC</line><line><control/>TO<register/></line></instruction>",
        func = function(G, A) -- FF DBG &A : random in &A in %R range
            local M = memory.peek(G, A)
            local ret = ""
            if M.signal.type == "virtual" and M.signal.name then
                ret = "[img = virtual-signal/" .. (M.signal.name) .. "]" ..
                          (M.count)
            elseif M.signal.type == "item" and M.signal.name then
                ret = "[img = item/" .. (M.signal.name) .. "]" .. (M.count)
            else
                ret = "[img = virtual-signal/pci-00]" .. (M.count)
            end
            game.print(game.tick .. " : " .. ret)
        end
    },
    ["pci-Z05"] = {
        name = "",
        order = "Z0:5",
        locale = "",
        icon = "<instruction id=\"Z05\" x=\"7\" y=\"15\" name=\"PID\" type=\"register\"><line>RLOC</line><line><control/>TO<register/></line></instruction>",
        func = function(G, A) -- FF DBG &A : random in &A in %R range
            A = A * 16
            local ret = ""
            for B = A, A + 15, 1 do
                local M = memory.peek(G, B)
                if M.signal.type == "virtual" and M.signal.name then
                    ret = ret .. "[img = virtual-signal/" .. (M.signal.name) ..
                              "]" .. (M.count)
                elseif M.signal.type == "item" and M.signal.name then
                    ret = ret .. "[img = item/" .. (M.signal.name) .. "]" ..
                              (M.count)
                else
                    ret = ret .. "[img = virtual-signal/pci-00]" .. (M.count)
                end
            end
            game.print(game.tick .. " : " .. ret)
        end
    }
}
