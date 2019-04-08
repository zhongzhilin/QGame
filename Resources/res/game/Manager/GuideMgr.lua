local GuideMgr = class("LineViewMgr")
local handler = require("game.GuideScript.ScriptHandler").new()
local gameEvent = global.gameEvent

local careEvent = {
    
    {key = gameEvent.EV_ON_ENTER_WORLD_SCENE},
    {key = gameEvent.EV_ON_ENTER_MAIN_SCENE},
    {key = gameEvent.EV_ON_ATTACK_FINISH},
    {key = gameEvent.EV_ON_GUIDE_CHECK_ATTACK_BOARD_OPEN},    
    {key = gameEvent.EV_ON_UI_LOOP_ADDCHILD_DONE},
    {key = gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE},
    {key = gameEvent.EV_ON_GUIDE_SILDIER_300},
}

--需要处理的会突然弹出的panel
local panelAnyWay = {    
    "UILordLvUpPanel",
}

--屏蔽屏蔽列表的列表
local noSkipIndex = {[30004] = true,[11001] = true,[40001] = true}

--隐藏panel
local hidePanelPath = {
    "UIRegisterPanel",
    "UIADGiftPanel",
    "UIFirRechargePanel",
    "UIMonthCardPanel",
}

function GuideMgr:ctor()
    
end

function GuideMgr:getHandler()
    
    return handler
end

function GuideMgr:loadScript()

    if not self.isLoaded then
        self.isLoaded = true
    else
        return
    end

    local userData = global.userData
    local step = userData:getGuideStep()

    print(step,"....step")

    local mainScript = require("game.GuideScript.MainScript")
    local eventScript = require("game.GuideScript.EventScript")    
    local loopEventScript = require("game.GuideScript.LoopEventScript")    
    
    self.isInFristScript = nil
    self.isInScript = false
    self.isFirst = true
    self.keyStepList = {}
    self.eventStepList = {}
    self.lastMainScriptKey = -1

    --加载顺序引导
    local isFirst = true
    for _,v in ipairs(mainScript) do
        if v.key > step then            
            if isFirst then                
                if v.target == nil or not self:checkEventTarget(v.target) then
                    table.insert(self.keyStepList,v)
                    v.guideType = 0
                else                    
                    self.curGuideType = 0
                    global.commonApi:setGuideStep(v.key,function()
                        
                    end)              
                end
            else
                table.insert(self.keyStepList,v)
                v.guideType = 0
            end

            if v.key > self.lastMainScriptKey then
                self.lastMainScriptKey = v.key
            end

            isFirst = false           
        end
    end

    if #self.keyStepList ~= 0 then

        global.resMgr:loadGuideRes()
    end 

    table.sortBySortList(self.keyStepList,{{"key","min"}})    

    --加载触发引导
    for _,v in ipairs(eventScript) do
        v.guideType = 1
        if not userData:isEventGuideDone(v.key) then            

            --如果这个是任意时间都可以做的引导
            if v.isAnyTime and self:checkEventTarget(v.target or {}) then

                table.insert(self.keyStepList,v)                
            else
                
                self.eventStepList[v.event] = self.eventStepList[v.event] or {}            
                table.insert(self.eventStepList[v.event],v)
            end            
        end
    end    
    
    for _,v in ipairs(loopEventScript) do
        v.guideType = 1
        v.isLoop = true
        self.eventStepList[v.event] = self.eventStepList[v.event] or {}            
        table.insert(self.eventStepList[v.event],v)
    end
    
    self:bindEvents() 
end

function GuideMgr:checkEventTarget(targets)

    print("start check target " .. vardump(targets))

    local funcGame = global.funcGame    
    for _,targetId in ipairs(targets) do                
        if not funcGame:checkTarget(targetId) then                        
            print("checkEventTarget targetId fail" , targetId )
            return false
        end
    end        
    return true
end

function GuideMgr:checkResume()
    
    print(self:getCurStep(),"self:getCurStep() function GuideMgr:checkResume()")
    
    if self:getCurStep() == 803 then        
        if not global.troopData:getTroopStateOwn() then
            self:flush(global.gameEvent.EV_ON_ATTACK_FINISH)
        end        
    end
end

function GuideMgr:bindEvents()
    
    -- 后台的时候收不到推送，导致一直在等待推送
    gevent:addListener(global.gameEvent.EV_ON_GAME_RESUME,function()

        self:checkResume()
    end)

    -- 由于重连会丢失返回，所以在重连的时候，判断如果正在处于等待联网的话，则继续引导
    gevent:addListener(global.gameEvent.EV_ON_LOGIN_DONE, function(event,data)
          
        -- 如果是重连
        print(">> guide mgr happen a relogin ,isRelogn:",data)

        global.uiMgr:removeSceneModal(10002)

        if self.netMethod then
        
            if data == 1 then
                
                print(">> guide mgr tag 1")    

                self.netMethod = nil
                self:dealScript()
            elseif data == WCODE.ERR_RPC_CLIENT_NO_SEND then    
                
                print(">> guide mgr tag 2")    
                --重新做一次这个引导
                self.handler:autoInsertStory({tbdata = {self:getCurTask()}})
                self:dealScript()
            end            
        elseif self.taskEvent == gameEvent.EV_ON_ENTER_MAIN_SCENE then

            if data == 1 then
                global.scMgr:gotoMainSceneWithAnimation()
            end            
        end     
        
    end)    

    for _,v in ipairs(careEvent) do

        print('-->guide manager init care event ',v.key)
        gevent:addListener(v.key, function()

            print("-->guide manager care event ",v.key)            
            self:flush(v.key)
        end)
    end    

    for eventKey,steps in pairs(self.eventStepList) do

        local eventId = nil
        eventId = gevent:addListener(eventKey, function(event,data)
            
            print("-->guide manager got a event",eventKey,data)            

            local isPlaying = self:isPlaying()

            local removeList = {}
            local isRemove = false
            for stepIndex,v in ipairs(steps) do

                -- print("-->check guide",stepIndex)
    
                print(v.eventData,"v.eventData",data,"data")
                if data == (v.eventData or data) then

                    if not (isPlaying and self:getCurGuideType() == 0) or v.isAnyTime then


                        -- 尝试处理，有可能会出现isAnyTime进入排队队列的情况，现处理为一旦排队队列里面有任务，不触发isAnyTime为false的引导
                        -- 简单描述为：不可能出现isAnyTime为false的引导进入等待队列

                        -- print('...gogogo')
                        dump(self.keyStepList,'self.keyStepList')

                        if not (not v.isAnyTime and #self.keyStepList > 0 and self:isStepListCanDo()) then
                          
                            local targets = v.target or {}
                            local isSuccess = self:checkEventTarget(targets) and (v.isLoop or not global.userData:isEventGuideDone(v.key))                    

                            if isSuccess then

                                --将这一步从待做事项中移除
                                
                                if not v.isLoop then
                                    removeList[stepIndex] = true                    
                                end                        
                                
                                isRemove = true

                                -- self:play(v)
                                table.insert(self.keyStepList,v)
                            end  
                        end                        
                    end                    
                end   
            end

            if isRemove then
                
                for i = #steps,1,-1 do
                    if removeList[i] then
                        table.remove(steps,i)
                    end
                end

                --如果这个事件的引导全部做完了，则下次不需要再次引导
                if #steps == 0 then
                    gevent:removeListener(eventId)
                end

                if not isPlaying then
                    self:flush()
                end
                
            end            
        end) 
    end

    gevent:addListener(global.gameEvent.EV_ON_PANEL_OPEN,function(event,data)
        
        if not self:isPlaying() then return end
        if self:getCurGuideType() == 0 then return end

        for _,panel in ipairs(panelAnyWay) do

            if panel == data then

                --将当前正在做的事情暂停，添加需要强制引导的脚本

                -- self.handler:autoInsertStory({tbdata = {self:getCurTask()}})
                -- self.handler:autoInsertStory({name = "panelCatch.deal" .. panel})
                -- self:dealScript()

                if not noSkipIndex[self:getCurStep()] then
                    global.panelMgr:closePanel(panel,true)
                end
                
                break
            end
        end
    end)
end

function GuideMgr:isStepListCanDo()
    
    for _,v in ipairs(self.keyStepList) do
        
        if v.guideType == 0 then

            if self:checkEventTarget(v.cutTarget or {}) then

                return true
            end
        end 
    end

    return false
end

function GuideMgr:stopWait(waitID)
    
    if self.taskEventID == waitID then

        print("GuideMgr:stopWait")
        self:dealScript(true)
    end
end

function GuideMgr:isMainScriptDone()
        
    return global.userData:getGuideStep() >= self.lastMainScriptKey    
end

function GuideMgr:flush(event)
  
    -- dump(self.keyStepList,"-->self.keyStepList")

    print("flush--guidemgr",debug.traceback())

    if self:isPlaying() then 

        if self.taskEvent == event then

            print(">>>isplaying")
            self:dealScript(true)    
        end
        
        return 
    end    

    for index,v in ipairs(self.keyStepList) do
        
        local keyStep = self.keyStepList[index]
        
        if self:checkEventTarget(keyStep.cutTarget or {}) then
                    
            print("--> guide manager target success")

            table.remove(self.keyStepList,index)                   
            self:play(keyStep)
            
            return
        end

        -- return
    end        

    print("gevent call en_on_guide_end")

    if self:getCurGuideType() == 0 then

        global.resMgr:unloadTextures("guide")
        gevent:call(global.gameEvent.EV_ON_GUIDE_MAIN_END,self:getCurStep())
    end

    gevent:call(global.gameEvent.EV_ON_GUIDE_END)
end

function GuideMgr:getCurTask()
    
    return self.curTask
end

function GuideMgr:getCurBaseStep()
    
    print("self.baseStep 1",self.baseStep)

    return self.baseStep + self.key * 1000
end

function GuideMgr:moveBaseStep()
    
    self.baseStep = self.baseStep + 1

    print("self.baseStep 2",self.baseStep)
end

function GuideMgr:handleTask(task)

    print("handle type:" .. task.key .. " stepId:" .. self:getCurStep() .. " data:" .. vardump(task.data))

    self.curTask = task

    if self:checkEventTarget(task.target or {}) then
        
        return handler["auto" .. task.key](handler,task.data or {}) or 0
    else

        print("task event target is not support")
        return 0
    end    
end

function GuideMgr:stop()
    
    self.script = {}
    global.stopDelayCallFunc(self.scheduleID)
end

function GuideMgr:dealScript(isCallByEvent)
    
    print(self.taskEvent,"self.taskEvent",isCallByEvent,"isCallByEvent")

    if self.taskEvent and not isCallByEvent then
        print("这个原本就会有问题了")
        return
    end

    if self.taskEvent then
       self.taskEvent = nil 
       self.taskEventID = -1
    end

    if #self.script == 0 then 

        self.isInScript = false

        self:flush()
        return
    end

    local task = self.script[1]
    table.remove(self.script,1)

    local delayTime = self:handleTask(task)
    if delayTime > 0 then
        self.scheduleID = global.delayCallFunc(self.dealScript,self,delayTime)               
    elseif delayTime ~= -1 then

        self:dealScript()
    end    
end

function GuideMgr:isPlaying()

    return self.isInScript
    -- return self.script and #self.script > 0   
end

-- 引导结束后的重置
function GuideMgr:setIsPlayingFirst(isFirst)
    self.isInFristScript = isFirst   
end
function GuideMgr:isPlayingFirst()
    return self.isInFristScript or self.isInScript   
end

function GuideMgr:getCurStep()
    
    return self.key
end

function GuideMgr:setStepArg(arg)
  
    -- if self:getCurStep() == global.luaCfg:get_guide_stage_by(5).Key then

    --    global.userData:setWorldCityID(arg)
    -- end

    self.stepArg = arg
end

function GuideMgr:getStepArg()
    
    return self.stepArg or 0
end

function GuideMgr:setTempData(data)
    self.tempData = data
end

function GuideMgr:cleanCache()    
    self.keyStepList = {}
end

function GuideMgr:getTempData()
    return self.tempData
end

function GuideMgr:hidePanel()
    
    for _,v in ipairs(hidePanelPath) do

        global.panelMgr:closePanel(v)
    end
end

function GuideMgr:waitForNet()
   
    print("wait fotr net ") 
    self.isWaitForNet = true
end

function GuideMgr:setWaitNetMethod(method)
    
    print("GuideMgr:setWaitNetMethod",method)

    if self.isWaitForNet then

        print("..true")
        self.netMethod = method
        self.isWaitForNet = false 
    end    
end

function GuideMgr:checkWaitNetMethod(method)
    
    if self.netMethod == method then

        print("got method success",method)
        self.netMethod = nil
        self:dealScript()
    end
end

function GuideMgr:setTaskEvent(event,waitID) 
    
    self.taskEvent = event    
    self.taskEventID = waitID
end
                                                        
function GuideMgr:getCurGuideType()     
                                                
    return self.curGuideType                
end                                                 
                                                                        
function GuideMgr:play(stepData)

    gevent:call(global.gameEvent.EV_ON_GUIDE_START)

    self.isInScript = true

    self.curGuideType = stepData.guideType
    self.key = stepData.key    
    self.baseStep = 0

    print("self.baseStep",self.baseStep)

    self.worldCityId = global.userData:getWorldCityID()

    local modelName = nil
    if self.isFirst then

        modelName = "game.GuideScript.Scripts." .. (stepData.startName or stepData.name)
        self.isFirst = false
    else

        modelName = "game.GuideScript.Scripts." .. stepData.name
    end

    local tb = require(modelName)
    self.script = clone(tb)
    self:dealScript()

    self:hidePanel()
end

global.guideMgr = GuideMgr.new()
