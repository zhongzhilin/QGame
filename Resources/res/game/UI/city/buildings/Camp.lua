--region Camp.lua
--Author : wuwx
--Date   : 2016/08/10

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local dataMgr = global.dataMgr
local cityData = global.cityData
local stateEvent = global.stateEvent
local tipsMgr = global.tipsMgr
local soldierData = global.soldierData
local resMgr = global.resMgr
local funcGame = global.funcGame
local gameEvent = global.gameEvent

local BuildingItem = require("game.UI.city.widget.BuildingItem")
local Camp  = class("Camp", function() return BuildingItem.new() end )

local Train = require("game.UI.city.buildings.widget.Train")
local TrainCircle = require("game.UI.city.buildings.widget.TrainCircle")
function Camp:ctor()

    self.m_clickCall = nil --call by BuildingItem.lua
    self.m_sleepNode = nil --node of sleeping effect 
    self.m_trainWidget1 = nil
    self.m_trainWidget2 = nil
end

function Camp:initStateMachine(initial_state)
    BuildingItem.initStateMachine(self, initial_state or stateEvent.BUILDING.STATE.OPERATE)
    self.fsm:addState({
        events = {
            {name = stateEvent.CAMP.EVENT.SLEEP, from = {stateEvent.BUILDING.STATE.OPERATE,stateEvent.CAMP.STATE.DONE}, to = stateEvent.CAMP.STATE.SLEEP},
            {name = stateEvent.CAMP.EVENT.TRAIN, from = {stateEvent.BUILDING.STATE.OPERATE,stateEvent.CAMP.STATE.SLEEP,stateEvent.CAMP.STATE.DONE}, to = stateEvent.CAMP.STATE.TRAIN},
            {name = stateEvent.CAMP.EVENT.DONE, from = stateEvent.CAMP.EVENT.TRAIN, to = stateEvent.CAMP.STATE.DONE},
        },
        callbacks = {
            ["onenter"..stateEvent.CAMP.STATE.SLEEP] = function(event)
                print(event.name.."休眠状态")
                self.m_clickCall = function() 
                    self:showOperatePanel()
                end

            end,
            ["onleave"..stateEvent.CAMP.STATE.SLEEP] = function(event)
                if self.m_sleepNode then
                    self.m_sleepNode:setVisible(false)
                    self.m_sleepNode.timeLine:pause()
                end
            end,
            ["onenter"..stateEvent.CAMP.STATE.TRAIN] = function(event)
                print(event.name.."训练状态")
                self.m_clickCall = function() 
                    self:showOperatePanel()
                        self:overTime()
                    end
            end,
            ["onleave"..stateEvent.CAMP.STATE.TRAIN] = function(event)
            end,
            ["onenter"..stateEvent.CAMP.STATE.DONE] = function(event)
                    print(event.name.."收获状态")
                    self.m_clickCall = function() 
                        self:showOperatePanel()
                    end 

                    if self.timer then
                        gscheduler.unscheduleGlobal(self.timer)
                        self.timer = nil
                    end
            end,
        }
    })
end

function Camp:trainState()

    local queueData = cityData:getTrainList(self.data.id)
    self.data.serverData.lBdTrain = queueData
    if #queueData > 0 then
        for _,v in pairs(queueData) do                     
            self:train(v)
        end
    end
    self:checkIdle()
   
end

-- 训练完成
function Camp:trainOver(lID)
    
    local i = lID
    if self["m_countDownTimer"..i] then
        gscheduler.unscheduleGlobal(self["m_countDownTimer"..i])
        self["m_countDownTimer"..i] = nil
    end

    if self:isSelected() then
        global.g_cityView:getOperateMgr():removeOpeBtnWidget()
    end
    gevent:call(global.gameEvent.EV_ON_UI_LEISURE)
    self:checkIdle()
end

-- 检测idle
function Camp:checkIdle()
    local queueData = cityData:getTrainList(self.data.id)
    if queueData and #queueData > 0 then

        self:doEvent(stateEvent.CAMP.EVENT.TRAIN)
        if self.m_sleepNode then
            self.m_sleepNode:setVisible(false)
            self.m_sleepNode.timeLine:pause()
        end
    else
        self:doEvent(stateEvent.CAMP.EVENT.SLEEP)
        self:sleep()
    end
end

-- 收获完成
function Camp:finishState(lID)

    self:trainOver(lID)
    local i = lID
    if self["m_trainWidget"..i] then
        self["m_trainWidget"..i]:removeFromParent()
        self["m_trainWidget"..i] = nil
    end
    self:checkPos()
end

function Camp:onEnter()
    BuildingItem.onEnter(self)
end

function Camp:onExit()

    for i=1,2 do
        if self["m_countDownTimer"..i] then
            gscheduler.unscheduleGlobal(self["m_countDownTimer"..i])
            self["m_countDownTimer"..i] = nil
        end
    end

    BuildingItem.onExit(self)

    if self.timer then
        gscheduler.unscheduleGlobal(self.timer)
        self.timer = nil
    end
end

function Camp:setData(data,noChangeTex)
    if not BuildingItem.setData(self,data,noChangeTex) then return end

    self:addEventListener(global.gameEvent.EV_ON_UI_TRAINCARD_FINISH, function (event, lID, buildingId)
        if buildingId and buildingId == self.data.id then
            self:finishState(lID)
        end
    end)

    if self.data.serverData.lStatus ~= WDEFINE.CITY.BUILD_STATE.BUILDED then
        return
    end
    self:trainState()

    self:overTime()

    if self.timer then
    else
        self.timer = gscheduler.scheduleGlobal(handler(self,self.overTime), 1)
    end
end


function Camp:overTime(i) --魔晶直接 加速 -- 队列 1 队列2  
    
    if self:isSelected() then 

        local setTime = function (state , time) 
            local m_operateNode = global.g_cityView:getOperateMgr()
            if not m_operateNode or tolua.isnull(m_operateNode) then return end
            local txt_node = m_operateNode:getBtnTxtNodeById(42)
            if txt_node then 
                local btn = txt_node:getParent()
                txt_node:setVisible(state)
                local label = txt_node.time
                local title = txt_node.txt
                title:setVisible(false)
                label:setString(time)
            end
        end 

        setTime(false,0)
        if self:getAccData() then 
            local queue = self:getTrainByID(self:getAccData().lID)
            local currServerTime =global.dataMgr:getServerTime()
            local lTotalTime = queue.lEndTime - queue.lStartTime
            local lRestTime = queue.lEndTime - currServerTime
            setTime(true,funcGame.getDiamondCount(lRestTime))
        end 
    end
 
end

function Camp:getTrainByID(lID)
    
    if self.data.serverData.lBdTrain then
        for k,v in pairs(self.data.serverData.lBdTrain) do
            if v.lID == lID then
                return v
            end
        end
    end
    return false
end

function Camp:countDownHandler(i)

    local curQueue = self:getTrainByID(i)
    if not curQueue then
        --在训练快到的时候，锁屏，再回来，队列数据已经没有了 
        self:finishState(i)
        return
    end
    local currServerTime = dataMgr:getServerTime()
    local lTotalTime = curQueue.lEndTime-curQueue.lStartTime
    local lRestTime = curQueue.lEndTime - currServerTime
    lRestTime = lRestTime <= 0 and 0 or lRestTime

    local data = {}
    data.time = funcGame.formatTimeToHMS(lRestTime)

    local leftTime = lTotalTime-lRestTime
    if leftTime < 0 then leftTime = 0 end
    -- 魔晶立即完成
    if lTotalTime == 0 then
        data.percent = 100
    else
        data.percent = math.floor(leftTime/lTotalTime*100)
    end
    
    if self["m_trainWidget"..i] then
        self["m_trainWidget"..i]:updateInfo(data, curQueue)
        self:checkPos()
    end

    if lRestTime <= 0 then
        self:trainOver(i)
    end
end

function Camp:countDownHandler1()
    self:countDownHandler(1)
end

function Camp:countDownHandler2()
    self:countDownHandler(2)
end

function Camp:harvest(lQID, finishCall)

    local curQueue = global.cityData:getTrainListById(self.data.serverData.lBuildID, lQID) or {}
    local soldierId = curQueue.lSID or ""
    
    local tempData = clone(self.data)
    global.cityApi:buildHarvest(self.data.serverData.lBuildID,function(msg)
        if msg and msg.tgTrain then
            global.cityData:setTrainList(tempData.id, msg.tgTrain)
        end
        
        local soundKey = "ui_harvest_"..tempData.buildingType
        gevent:call(gsound.EV_ON_PLAYSOUND,soundKey)

        if msg and msg.lSoldiers then

            local combatAll = 0
            local raceId = global.userData:getRace()
            for i,v in ipairs(msg.lSoldiers) do
                local outStr = luaCfg:get_local_string(10329)
                local combat = 0
                if tempData.buildingType == 14 then
                    global.soldierData:addTrapBy(v)
                    combat = luaCfg:get_def_device_by(v.lID%(raceId*1000)).combat
                    outStr = luaCfg:get_local_string(10330)
                else
                    combat = luaCfg:get_soldier_property_by(v.lID).combat
                    global.soldierData:addSoldierBy(v)
                end
                local soldierTrainData = luaCfg:get_soldier_train_by(v.lID)
                outStr = outStr .. soldierTrainData.name.."+"..v.lCount
                tipsMgr:showWarning(outStr)

                combatAll = combatAll + combat * v.lCount
            end            

            --　特效播放监听
            if self.playAnimation then
                self:playAnimation(combatAll)
            end
            if global.g_cityView and not tolua.isnull(global.g_cityView) then
                global.g_cityView:getSoldierMgr():refershSoldier()  -- 刷新校场士兵显示
            end
        end  

        if self.checkIdle then 
            self:checkIdle()
        end
        if self.checkPos then 
            self:checkPos()  
        end  
    end,nil, lQID, soldierId)
    if finishCall then
        finishCall()
    else
        -- 训练中收获，隐藏
        -- self["m_trainWidget"..lQID]:hideCircle()
    end
    if self:isSelected() then
        global.g_cityView:getOperateMgr():removeOpeBtnWidget()
    end
end

function Camp:playAnimation(combatAll)

    local cityView = global.g_cityView
    local cityNode = cityView.touchMgr:getBuildingNodeBy(self.data.serverData.lBuildID)
    local speed = 0.65
    cityNode:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function()
        
        local trainEffect = resMgr:createCsbAction("effect/army_build_par","animation0",true)
        trainEffect:setPosition(cityNode:convertToWorldSpace(cc.p(0,0)))  
        trainEffect:runAction(cc.Sequence:create(cc.MoveTo:create(speed,cc.p(gdisplay.width / 2,gdisplay.height - 50)),cc.RemoveSelf:create()))            
        uiMgr:configUITree(trainEffect)       
        trainEffect.Particle_1:setPositionType(cc.POSITION_TYPE_FREE)
        global.g_cityView:addChild(trainEffect, global.panelMgr.LAYER.LAYER_SYSTEM)

        end),cc.DelayTime:create(speed),cc.CallFunc:create(function()
                local upfire = resMgr:createCsbAction("effect/upgrade_effect_upfire","animation0",false,true)
                upfire:setPosition(cc.p(gdisplay.width / 2,gdisplay.height - 50))
                global.g_cityView:addChild(upfire, global.panelMgr.LAYER.LAYER_SYSTEM)
    end)))

    
    local building_ui_data = luaCfg:get_buildings_ui_by(global.cityData:getBuildingType(self.data.buildingType))
    local addAction = resMgr:createCsbAction("effect/upgrade_power_add","animation0",false,true)
    addAction:setPosition(cc.p(building_ui_data.effect_posX + self:getPositionX(),building_ui_data.effect_posY + self:getPositionY()))            
    global.g_cityView:getScrollViewLayer("effect"):addChild(addAction, 997)

    uiMgr:configUITree(addAction)       
    addAction.Text_1:setString(global.luaCfg:get_local_string(10026,""))     
    addAction.Text_Combat:setString("+" .. combatAll)

end

function Camp:checkPos()

    local checkIsFull = function (curQueue)
        -- body
        local currServerTime = dataMgr:getServerTime()
        local lTotalTime = curQueue.lEndTime-curQueue.lStartTime
        local lRestTime = curQueue.lEndTime - currServerTime
        lRestTime = lRestTime <= 0 and 0 or lRestTime

        local percent = 0 
        local leftTime = lTotalTime-lRestTime
        if leftTime < 0 then leftTime = 0 end
        if lTotalTime == 0 then -- 魔晶立即完成
            percent = 100
        else
            percent = math.floor(leftTime/lTotalTime*100)
        end
        if percent == 100 then
            return true
        else
            return false
        end
    end

    local posY = 80
    local buildingUIData = luaCfg:get_buildings_ui_by(global.cityData:getBuildingType(self.data.buildingType))
    if buildingUIData and buildingUIData.btnui_posY ~= 0 then
        posY = 80 + buildingUIData.btnui_posY
    end

    for i=1,2 do
        local m_trainWidget = self["m_trainWidget"..i]
        if m_trainWidget then
            local id = i
            local queueData = cityData:getTrainList(self.data.id)
            if #queueData > 1 then

                local full1 = checkIsFull(queueData[1])
                local full2 = checkIsFull(queueData[2])
                if full1 and full2 then
                    id = id==1 and -1 or 1
                    m_trainWidget:setPosition(60*id, posY)
                elseif (not full1) and (not full2) then
                    id = id==1 and 0 or 1
                    m_trainWidget:setPosition(0, posY+65*id)
                else
                    if m_trainWidget.isFinsih then 
                        m_trainWidget:setPosition(0, posY+55)
                    else
                        m_trainWidget:setPosition(0, posY)
                    end
                end               
            else
                m_trainWidget:setPosition(0, posY)
            end
        end
    end

end

function Camp:train(queueData)

    local i = queueData.lID
    if self["m_countDownTimer"..i] then
    else
        self["m_countDownTimer"..i] = gscheduler.scheduleGlobal(handler(self,self["countDownHandler"..i]), 1)
    end

    if self["m_trainWidget"..i] then
    else
        self["m_trainWidget"..i] = Train.new()
        local buildingUIData = luaCfg:get_buildings_ui_by(global.cityData:getBuildingType(self.data.buildingType))
        if buildingUIData and buildingUIData.btnui_posY ~= 0 then
            self["m_trainWidget"..i]:setPositionY(80+buildingUIData.btnui_posY)  
        else
            self["m_trainWidget"..i]:setPositionY(80)         
        end              
        self:addChild(self["m_trainWidget"..i])
    end

    self:checkPos()
 
    if queueData and self["m_trainWidget"..i] then
        local soldierTrainData = luaCfg:get_soldier_train_by(queueData.lSID)
        self.m_totalTime = queueData.lEndTime - queueData.lStartTime
        self["m_trainWidget"..i]:setData(soldierTrainData, true)
        self["m_trainWidget"..i]:setHarvestCall(handler(self, self.harvestCall))
    end
    self["countDownHandler"..i](self)

end

-- 点击建筑上方头像，收获士兵
function Camp:harvestCall(curQueue)
   
    local endTime = curQueue.lEndTime
    local currServerTime = global.dataMgr:getServerTime()

    -- 训练中收获
    if currServerTime < endTime then
        --self:harvest(curQueue.lID)
        self:showOperatePanel()
    else       
        local finishCall = function ()
            -- 训练完成
            if self.data and self.data.id then --protect 
                global.cityData:removeTrainList(curQueue.lID ,self.data.id)      
            end 
            self:finishState(curQueue.lID)
        end
        self:harvest(curQueue.lID, finishCall)
    end
end

function Camp:sleep()

    for i=1,2 do
        if self["m_trainWidget"..i] then
            self["m_trainWidget"..i]:removeFromParent()
            self["m_trainWidget"..i] = nil
        end
    end
    
    if self.m_sleepNode then
        self.m_sleepNode:setVisible(true)
        self.m_sleepNode.timeLine:resume()
        return
    end
    local csbName = "city/build_train_free"
    local node = resMgr:createCsbAction(csbName,"sleep",true)
    node.Sprite_1.Text_1:setString(gls(10391))
    self.root:addChild(node)
    local data = luaCfg:get_buildings_ui_by(global.cityData:getBuildingType(self.data.buildingType))
    node:setPosition(cc.p(data.idleui_posX,data.idleui_posY))
    self.m_sleepNode = node
end

function Camp:getAccData()
    local currTime = dataMgr:getServerTime() 
    local data = self.data.serverData.lBdTrain
    if not data then
        return nil
    end
    if data[1] and data[1].lEndTime - currTime > 0 then
        return data[1]
    elseif data[2] and data[2].lEndTime - currTime > 0 then
        return data[2]
    else
        return nil
    end
end


function Camp:leftTimeAndTotalTime(data1, cutTime1)

    local buildingId = self.data.id
    local queue = self:getAccData()
    if not queue then
        return 
    end

    local function leftTimeAndTotalTimeT(data, cutTime)
        if not self.data.serverData.lBdTrain or (#self.data.serverData.lBdTrain <= 0) then
            --在训练快到的时候，锁屏，再回来，队列数据已经没有了
            local lRestTime = 0
            return lRestTime,self.m_totalTime
        end
        if data then
            -- 加速起始时间减
            queue.lStartTime =  queue.lStartTime - cutTime
            queue.lEndTime = queue.lEndTime - cutTime
           global.cityData:setTrainList(buildingId, queue)
            self.data.serverData.lBdTrain = global.cityData:getTrainList(buildingId)
        end

        local lTotalTime = queue.lEndTime - queue.lStartTime
        local currServerTime = dataMgr:getServerTime() 
        if queue.lStartTime - currServerTime > 0 then
            currServerTime = queue.lStartTime
        end
        local lRestTime = queue.lEndTime-currServerTime
        lRestTime = (lTotalTime <= 0) and 0 or lRestTime
        return lRestTime,lTotalTime
    end

    return leftTimeAndTotalTimeT(data1 , cutTime1)

end 

--训练加速
function Camp:accelerate()
    local buildingId = self.data.id
    local queue = self:getAccData()
    if not queue then
        return 
    end

    local panel = global.panelMgr:openPanel("UISpeedPanel")   -- 加速道具使用
    panel:setData(handler(self , self.leftTimeAndTotalTime), queue.lID or 1, panel.TYPE_SOLDIER_TRAIN, buildingId)
end

return Camp

--endregion
