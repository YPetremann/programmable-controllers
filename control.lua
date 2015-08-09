
require("defines")
require("util")
require("helpers.gui_helpers")

local cycles_per_tick = 1024
local data={}
local classes = {}
local _debug=true

local function debugLog(message)
    if _debug then -- set for debug
    game.player.print(tostring(message))
    end
end


local function ttostring(tab)
    local res=""
    if type(tab)=="table" then
        res="{"
            for k,v in pairs(tab) do
                res=res.." "..tostring(k).." = "..ttostring(v)..","
            end
            res=res.."}"
        else
            res=tostring(tab)
        end
        return res
    end
    
local function getLink(tab)
    setmetatable(tab,{__call=function(tab) return tab end})
    return tab()
end

   
local function getArea(pos)
    return {{pos.x-1,pos.y-1},{pos.x+1,pos.y+1}}
end

local function contains(tab,val)
    for k,v in pairs(tab) do
        if v==val then
            return true
        end
    end
    return false
end

local function addAll(tab,w)
   for k,v in ipairs(w) do
       table.insert(tab,v)
   end
   return tab
end

local function scanAround(entity,exclude)
    debugLog(ttostring(entity.position))
    local around=entity.surface.find_entities(getArea(entity.position))
    table.insert(exclude,entity)
    local res={entity}
    for k,v in pairs(around) do
        if string.match (v.name, "controller") then
            if not contains(exclude,v) then
                res=addAll(res,scanAround(v,exclude)) 
            end
        end
    end
    return res
end

local function countMemorySize(self)
    local size = 0
    for i,v in ipairs(self.peripherals) do
        size = size + v:getSize()
    end
    return size
end


local function addStatusLabel(text,gui)
    if gui.mode==1 then 
        GUI.Label("status"..gui.status_index,text)
    elseif gui.mode==2 and gui.status.flow["status"..gui.status_index] ~= nil then
        gui.status.flow["status"..gui.status_index].caption=text
    end
    gui.status_index=gui.status_index+1
end

local function getControllerStatus(self)
    if self.running then
        return "RUNNING"
    end
    return "STOPPED"
end

local function systemInfo(self,gui)
    addStatusLabel("==================================================================",gui)
    addStatusLabel("STATUS: "..getControllerStatus(self),gui)
    addStatusLabel("HALT REASON: "..self.halt_reason,gui)
    addStatusLabel("CORE LOAD: "..(self.cycles_last_tick/cycles_per_tick * 100).."%",gui)
    addStatusLabel("SYSTEM ADDRESS SPACE: "..self.address_space,gui)
    local addr=0
    for k,v in pairs(self.peripherals) do
        addStatusLabel("P"..k..": FROM "..(addr+1).."  TO "..(addr+v:getSize()).." IS "..v:info(),gui)
        addr=addr+v:getSize()
    end
    
    --d=d.."PROGRAM SIZE: "..#self.code.." CYCLES".."\n"
    addStatusLabel("==================================================================",gui)
end


local function getLines(gui)
    for i=1,16 do
        gui.lines[i+gui.offset] = gui.code.line_flow["line_group"..i].line.text
    end
end

local function updateLines(gui)
    for i=1,16 do
        gui.code.line_flow["line_group"..i].num.caption = i + gui.offset
        gui.code.line_flow["line_group"..i].line.text = gui.lines[i+gui.offset] or "" 
    end
end


local function checkMem(obj,index)
    if index <= 0 or index > obj.address_space then
        classes["controller-cpu"].halt(obj,"SIGSEGV: index out of memory PCTR:"..obj.pctr.." INDEX:"..index)
        return
    end
    return true
end

local function getByAccessor(obj,str)
    if string.sub(str,1,1)=="#" then
        return tonumber(string.sub(str,2))-obj.pctr-1
    elseif string.sub(str,1,1)=="$" then
        return tonumber(string.sub(str,2))
    else 
        return obj.memory[tonumber(str)]
    end
end


local instructions = {}
instructions["mov"]=function(obj,a,b)
    obj.memory[tonumber(b)]=getByAccessor(obj,a)
end
instructions["inc"]=function(obj,a)
    obj.memory[tonumber(a)]=obj.memory[tonumber(a)]+1
end
instructions["dec"]=function(obj,a)
    obj.memory[tonumber(a)]=obj.memory[tonumber(a)]-1
end
instructions["add"]=function(obj,a,b)
    obj.memory[tonumber(a)]=obj.memory[tonumber(a)]+getByAccessor(obj,b)
end
instructions["sub"]=function(obj,a,b)
    obj.memory[tonumber(a)]=obj.memory[tonumber(a)]-getByAccessor(obj,b)
end
instructions["mul"]=function(obj,a,b)
    obj.memory[tonumber(a)]=obj.memory[tonumber(a)]*getByAccessor(obj,b)
end
instructions["div"]=function(obj,a,b)
    obj.memory[tonumber(a)]=obj.memory[tonumber(a)]/getByAccessor(obj,b)
end
instructions["hlt"]=function(obj,a)
    classes["controller-cpu"].halt(obj,"HALTED BY PROGRAM: "..tostring(a))
end

instructions["jez"]=function(obj,a,b)
    if getByAccessor(obj,a) == 0 then
        obj.pctr = obj.pctr + getByAccessor(obj,b)
    end
end

instructions["jnz"]=function(obj,a,b)
    if getByAccessor(obj,a) ~= 0 then
        obj.pctr = obj.pctr + getByAccessor(obj,b) 
    end
end

instructions["jmp"]=function(obj,a)
    obj.pctr = obj.pctr + getByAccessor(obj,a)
end
instructions["jlz"]=function(obj,a,b)
    if getByAccessor(obj,a) < 0 then
        obj.pctr = obj.pctr + getByAccessor(obj,b)
    end
end

instructions["jgz"]=function(obj,a,b)
    if getByAccessor(obj,a) > 0 then
        obj.pctr = obj.pctr + getByAccessor(obj,b) 
    end
end


instructions["nop"]=function(obj)
end

instructions["flo"]=function(obj,a)
    obj.memory[tonumber(a)]=math.floor(tonumber(a))
end
instructions["cel"]=function(obj,a)
    obj.memory[tonumber(a)]=math.ceil(tonumber(a))
end
instructions["pow"]=function(obj,a,b)
    obj.memory[tonumber(a)]=math.pow(obj.memory[tonumber(a)],getByAccessor(obj,b))
end
instructions["rsh"]=function(obj,a,b)
    obj.memory[tonumber(a)]=math.floor(obj.memory[tonumber(a)] / math.pow(2,getByAccessor(obj,b)))
end

instructions["lsh"]=function(obj,a,b)
    obj.memory[tonumber(a)]=obj.memory[tonumber(a)] * math.pow(2,getByAccessor(obj,b))
end

local function OpenMainGUI(playerIndex,k,i)
  if k.gui[playerIndex] ~= nil then
    return
  end
  debugLog("Open Gui")
  k.gui[playerIndex]={}
  GUI.PushCenterSection(playerIndex)
  k.gui[playerIndex].status = GUI.PushParent(GUI.Frame("controller-cpu_"..k.entity.position.x.."_"..k.entity.position.y, "Controller CPU", GUI.HORIZONTAL))
  GUI.PushParent(GUI.Flow("flow", GUI.VERTICAL))
  k.gui[playerIndex].mode=1
  k.gui[playerIndex].status_index=1
  systemInfo(k,k.gui[playerIndex])
  GUI.PushParent(GUI.Flow("flow-d", GUI.HORIZONTAL))
  GUI.Button("reset", "Reset", "ResetCPU", classes["controller-cpu"],k)
  GUI.Button("restart", "Restart", "RestartCPU", classes["controller-cpu"],k)
  GUI.Button("halt", "Halt", "HaltCPU", classes["controller-cpu"],k)
  GUI.PopAll()
  GUI.PushLeftSection(playerIndex)
  k.gui[playerIndex].code = GUI.PushParent(GUI.Frame("controller-cpu-code_"..k.entity.position.x.."_"..k.entity.position.y, "Controller CPU CODE", GUI.HORIZONTAL))
  k.gui[playerIndex].lines = k.code
  k.gui[playerIndex].offset = 0
  GUI.PushParent(GUI.Flow("line_flow", GUI.VERTICAL))
  for i=1,16 do
     GUI.PushParent(GUI.Flow("line_group"..i, GUI.HORIZONTAL))
     GUI.Label("num",""..i)
     GUI.TextField("line", "")
     GUI.PopParent()
  end
  GUI.PushParent(GUI.Flow("flow-controls", GUI.HORIZONTAL))
  GUI.Button("up", "UP", "ScrollUp", classes["controller-cpu"],k.gui[playerIndex])
  GUI.Button("down", "DOWN", "ScrollDown", classes["controller-cpu"],k.gui[playerIndex])
  GUI.PopAll()
  updateLines(k.gui[playerIndex])
end

local function CloseMainGUI(playerIndex,k,i)
  if k.gui[playerIndex]==nil then
    return
  end
  debugLog("Close Gui")
  getLines(k.gui[playerIndex])
  k.gui[playerIndex].status.destroy()
  k.gui[playerIndex].code.destroy()
  
  for i=#k.gui[playerIndex].lines,1,-1 do
    if string.len(k.gui[playerIndex].lines[i])==0 then
        k.gui[playerIndex].lines[i]=nil
    else
        break
    end
  end
  local m = #k.code == #k.gui[playerIndex].lines
  if m then
    for i=1,#k.gui[playerIndex].lines do
        if tostring(k.code[i]) ~= tostring(k.gui[playerIndex].lines[i]) then
            m = false
            break
        end
    end
  end
  
  if not m then
      debugLog("Code edited")
      k.code = k.gui[playerIndex].lines
  end
  
  k.gui[playerIndex]=nil
  
end


function executeInstruction(obj,inst)
    
    if inst == nil then
        classes["controller-cpu"].halt(obj,"PROGRAM ENDED")
        return
    end
    if #inst == 0 then
        return
    end
    local cmd = string.sub(inst,1,3)
    
    if cmd == "yld" then
        return
    end
    local args_str = string.sub(inst,4)
    local args = {obj}
    for str in string.gmatch(args_str,"([#$]?[-0-9A-Za-z.]+)") do
        table.insert(args,str)
    end
    local ok,err=pcall(instructions[cmd],unpack(args))
    if not ok then
        debugLog("LUA ERROR: "..err)
    end
    return ok
end

local function findDataByEntity(ty,ent)
    for k,v in pairs(data[ty]) do
        if v.entity==ent then
            return v
        end
    end
end

local function regenMem(obj)
   local memory={}
        setmetatable(memory,{__newindex=function(table,index,value)
        if checkMem(obj,index) then
            local pos = 1
            while true do --it not infinit i promise
                    if obj.peripherals[pos]:getSize() >= index then
                        obj.peripherals[pos]:setMem(index,value)
                        break
                    else
                        index = index - obj.peripherals[pos]:getSize()
                        pos = pos + 1
                    end
                end
            end
        end,
        __index=function(table,index)
            if checkMem(obj,index) then
                local pos = 1
                while true do --it not infinit i promise
                    if obj.peripherals[pos]:getSize() >= index then
                        return obj.peripherals[pos]:getMem(index)
                    else
                        index = index - obj.peripherals[pos]:getSize()
                        pos = pos + 1
                    end
                end
            end
        end})
        obj.memory=memory
        
end

classes["controller-cpu"]={
    onPlace=function(entity)
        debugLog("CPU placed")
        local obj=getLink({entity=entity,gui=getLink({}),peripherals=getLink({}),address_space = 0,halt_reason = "NEVER HALTED",running = false,code={},cycles_last_tick=0,pctr = 1})
        regenMem(obj)
        return obj
    end,
    onDestroy=function(entity)
        debugLog("CPU removed")
    end,
    onTick=function(obj,index)
        if obj.entity.energy > 0.5 then
            for playerIndex = 1, #game.players do
                if util.distance(game.players[playerIndex].position, obj.entity.position) < 2 then
                    OpenMainGUI(playerIndex,obj,index)
                else
                    CloseMainGUI(playerIndex,obj,index)
                end
                if obj.gui[playerIndex] then
                    obj.gui[playerIndex].mode=2
                    obj.gui[playerIndex].status_index=1
                    systemInfo(obj,obj.gui[playerIndex])
                end
            end
            obj.cycles_last_tick = 0
            while obj.running and obj.cycles_last_tick < cycles_per_tick do 
                if not executeInstruction(obj,obj.code[obj.pctr]) then
                    obj.pctr=obj.pctr+1
                    break
                end
                obj.pctr=obj.pctr+1
                obj.cycles_last_tick = obj.cycles_last_tick + 1
            end
        else
            classes["controller-cpu"].halt(obj,"OUT OF POWER")
        end
    end,
    ResetCPU=function(_,event,obj)
        debugLog("Resetting CPU")
        local controller_ent=scanAround(obj.entity,{})
         obj.peripherals={}
        for k,v in pairs(controller_ent) do
            if classes[v.name]~= nil and classes[v.name].getPRP then
                obj.peripherals=addAll(obj.peripherals,classes[v.name].getPRP(findDataByEntity(v.name,v)))
            end
        end
        obj.address_space=countMemorySize(obj)
        regenMem(obj)
    end,
    halt=function(obj,msg)
        obj.running=false
        obj.halt_reason=msg
    end,
    HaltCPU=function(_,event,obj)
        obj.running=false
        obj.halt_reason="HALTED BY USER"
        debugLog("Halt")
    end,
    RestartCPU=function(_,event,obj)
        getLines(obj.gui[event.player_index])
        obj.code=obj.gui[event.player_index].lines
        obj.running=true
        for k,v in pairs(obj.peripherals) do
            v:clear()
        end
    end,
    ScrollDown=function(_,event,obj)
        getLines(obj)
        obj.offset = obj.offset + 1 
        updateLines(obj)
    end,
    ScrollUp=function(_,event,obj)
        getLines(obj)
        if obj.offset >= 1 then
            obj.offset = obj.offset - 1 
        end
        updateLines(obj)
    end,
    getPRP=function(obj)
        return {{
            setMem = function (self,index,value)
                obj.pctr = index
            end,
            getMem = function (self,index)
                return obj.pctr
            end,
            getSize = function (self)
                return 1
            end,
            info = function(self)
                return "PROGRAM COUNTER"
            end,
            clear = function(self)
                obj.pctr=1
            end
        }}
    end
}

classes["controller-mem"]={
    onPlace=function(entity)
        debugLog("MEM placed")
        return {entity=entity,mem={}}
    end,
    onDestroy=function(entity)
        debugLog("MEM removed")
    end,
    onTick=function(obj)
        if obj.entity.energy < 0.5 then
            obj.mem = {}
        end
    end,
    getPRP=function(obj)
        return {{
            setMem = function (self,index,value)
                obj.mem[index]=value
            end,
            getMem = function (self,index)
                return obj.mem[index] or 0
            end,
            getSize = function (self)
                return 32
            end,
            info = function(self)
                return "MEM BLOCK"
            end,
            clear = function(self)
                obj.mem={}
            end
        }}
    end
}

classes["controller-out"]={
    onPlace=function(entity)
        debugLog("OUT placed")
        return {entity=entity,mem={}}
    end,
    onDestroy=function(entity)
        debugLog("OUT removed")
    end,
    onTick=function(obj)
        local rec = obj.entity.get_circuit_condition(1)
        for i=1,15 do
            rec.parameters[i].count=obj.mem[i] or 0
        end
        obj.entity.set_circuit_condition(1,rec)
    end,
    getPRP=function(obj)
        return {{
            setMem = function (self,index,value)
                obj.mem[index]=value
            end,
            getMem = function (self,index)
                return obj.mem[index] or 0
            end,
            getSize = function (self)
                return 15
            end,
            info = function(self)
                return "OUT COMBINATOR"
            end,
            clear = function(self)
                obj.mem={}
            end
        }}
    end
}

classes["controller-in"]={
    onPlace=function(entity)
        debugLog("IN placed")
        return {entity=entity,mem={}}
    end,
    onDestroy=function(entity)
        debugLog("IN removed")
    end,
    onTick=function(obj)
        if obj.entity.get_circuit_condition(1).fulfilled then
            obj.mem[1]=1
        else
            obj.mem[1]=0
        end
    end,
    getPRP=function(obj)
        return {{
            setMem = function (self,index,value)
                --ERROR HERE
            end,
            getMem = function (self,index)
                return obj.mem[index] or 0
            end,
            getSize = function (self)
                return 1
            end,
            info = function(self)
                return "1-INPUT"
            end,
            clear = function(self)
                obj.mem={0}
            end
        }}
    end
}

local function entityBuilt(event)
    if classes[event.created_entity.name]~= nil then
        local tab = data[event.created_entity.name]
        table.insert(tab,classes[event.created_entity.name].onPlace(event.created_entity))
        data[event.created_entity.name] = tab
    end
end

local function entityRemoved(event)
    if classes[event.entity.name]~= nil then
        for k, v in ipairs(data[event.entity.name]) do
            if v.entity==event.entity then
                local tab = data[event.entity.name]
                table.remove(tab,k)
                classes[event.entity.name].onDestroy(v)
                data[event.entity.name] = tab
                break
            end
        end
    end
end

local function onTick()
	for k, v in pairs(classes) do
		for q, i in pairs(data[k]) do
			if i.entity.valid then
				v.onTick(i,q)
			end
		end
	end
end


local function onLoad()
    data = global.programmableControllers or {}
    for k,v in pairs(classes) do
        data[k]=data[k] or {}
    end
    for k,v in pairs(data["controller-cpu"]) do
        classes["controller-cpu"].ResetCPU(nil,nil,v)
    end
end

game.on_init(onLoad)
game.on_load(onLoad)
game.on_save(function()
global.programmableControllers = data
end)

game.on_event(defines.events.on_tick, onTick)

game.on_event(defines.events.on_built_entity, entityBuilt)
game.on_event(defines.events.on_robot_built_entity, entityBuilt)

game.on_event(defines.events.on_preplayer_mined_item, entityRemoved)
game.on_event(defines.events.on_robot_pre_mined, entityRemoved)
game.on_event(defines.events.on_entity_died, entityRemoved)