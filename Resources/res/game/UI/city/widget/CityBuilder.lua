--region CityBuilder.lua
--Author : wuwx
--Date   : 2016/08/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local stateEvent = global.stateEvent
local funcGame = global.funcGame
local dataMgr = global.dataMgr
local cityData = global.cityData
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local CityBuilder  = class("CityBuilder", function() return gdisplay.newWidget() end )



function CityBuilder:ctor()
    
end

function CityBuilder:CreateUI()
    local root = resMgr:createWidget("city/builder")
    self:initUI(root)
end

function CityBuilder:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/builder")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn_state = self.root.btn_state_export
    self.effect_node = self.root.btn_state_export.effect_node_export
    self.txt_count = self.root.btn_state_export.txt_count_export

    uiMgr:addWidgetTouchHandler(self.btn_state, function(sender, eventType) self:onStateHandler(sender, eventType) end)
--EXPORT_NODE_END
   self.txt_count:setVisible(false) 
   self.m_opened = false

   self.effectList = {}
  
   self.effectList["wait"]      = "effect/leisure"
   self.effectList["vipwait"]   = "effect/leisure2"
   self.effectList["lock"]      = "effect/disabled"
   self.effectList["time"]      = "effect/wait"
   self.effectList["free"]      = "effect/free"

end

function CityBuilder:showEffect(key)
    self.effect_node:removeAllChildren()
    local node = resMgr:createCsbAction(self.effectList[key],"animation0",true)
    self.effect_node:addChild(node)
end

function CityBuilder:showUnlockEffect()
    
    local node = resMgr:createCsbAction("effect/hitfree","animation0",false,true)
    self.effect_node:addChild(node)
end

function CityBuilder:setupStateMachine(initial_state)
    self.fsm = global.stateMachine.new()
    self.fsm:setupState({
        initial = initial_state,
        events = {
            {name = stateEvent.BUILDER.EVENT.IDLE, from = {stateEvent.BUILDER.STATE.CANFREE,stateEvent.BUILDER.STATE.NOTOPEN,stateEvent.BUILDER.STATE.BUSY}, to = stateEvent.BUILDER.STATE.IDLE},
            {name = stateEvent.BUILDER.EVENT.BUSY, from = {stateEvent.BUILDER.STATE.IDLE,stateEvent.BUILDER.EVENT.CANFREE}, to = stateEvent.BUILDER.STATE.BUSY},
            {name = stateEvent.BUILDER.EVENT.CANFREE, from = {stateEvent.BUILDER.STATE.IDLE,stateEvent.BUILDER.STATE.BUSY}, to = stateEvent.BUILDER.STATE.CANFREE},
            {name = stateEvent.BUILDER.EVENT.NOTOPEN, from = "*", to = stateEvent.BUILDER.STATE.NOTOPEN}
        },
        callbacks = {
            ["onenter"..stateEvent.BUILDER.STATE.NOTOPEN] = function()
                self.m_stateCall = function()
                    -- global.panelMgr:openPanel("UIMonthCardPanel"):setData()
                    global.panelMgr:openPanel("UIGetChannelPanel"):setData({titleId=10979, target=5})
                    -- local panel = global.panelMgr:openPanel("UISpeedPanel")   -- 解锁道具使用
                    -- panel:setData(handler(self,  self.unLockQueueCall), self.data.queueId, panel.TYPE_QUEUE_UNLOCK)
                end
                self.txt_count:setVisible(false) 

                self:showEffect("lock")

                if self.m_countLockDownTimer then
                    gscheduler.unscheduleGlobal(self.m_countLockDownTimer)
                    self.m_countLockDownTimer = nil
                end
            end,
            ["onleave"..stateEvent.BUILDER.STATE.NOTOPEN] = function()
                self:countLockDownHandler()
                if self.m_countLockDownTimer then
                else
                    self.m_countLockDownTimer = gscheduler.scheduleGlobal(handler(self,self.countLockDownHandler), 1)
                end
            end,
            ["onenter"..stateEvent.BUILDER.STATE.IDLE] = function()
                self.m_stateCall = function() 
                    print(stateEvent.BUILDER.STATE.IDLE.."不需要响应")
                    if self.data.queueId == 3 and self.queueData and self.queueData.lRestTime then
                        local restTime = math.ceil(self.queueData.lRestTime - global.dataMgr:getServerTime())
                        local dayNum = math.floor(restTime/(24*3600))
                        local str = ""
                        if dayNum > 0 then
                            str = string.format(global.luaCfg:get_local_string(10675),dayNum ,global.funcGame.formatTimeToHMS(restTime-dayNum*24*3600)) 
                        else
                            str = global.funcGame.formatTimeToHMS(restTime)
                        end
                        global.tipsMgr:showWarning( string.format(luaCfg:get_local_string(10027), str))

                        -- local panel = global.panelMgr:openPanel("UISpeedPanel")   -- 加速道具使用
                        -- panel:setData(handler(self,  self.unLockQueueCall), self.data.queueId, panel.TYPE_QUEUE_UNLOCK)
                    else
                        global.tipsMgr:showWarning("IdleBuildQueue")
                    end
                    
                end
                self.txt_count:setVisible(false) 
                
                if self.isVipWait then

                    self:showEffect("vipwait")
                else

                    self:showEffect("wait")
                end
                
            end,
            ["onenter"..stateEvent.BUILDER.STATE.BUSY] = function()
                self.m_stateCall = function() 
                    print(stateEvent.BUILDER.STATE.BUSY.."不需要响应")
                    
                    local panel = global.panelMgr:openPanel("UISpeedPanel")   -- 加速道具使用
                    panel:setData(handler(self,  self.leftTimeAndTotalTime), self.data.queueId, panel.TYPE_QUEUE_SPEED)
                end
                self.txt_count:setVisible(true) 
                self.txt_count:setString("")
                self:showEffect("time")

                self:startCountDown()
            end,
            ["onenter"..stateEvent.BUILDER.STATE.CANFREE] = function()
                self.m_stateCall = function()
                    global.cityApi:clearQueue(self.data.queueId, 0,function(msg)
                        -- body
                        if self.data then --protect 
                            self.data.serverData = msg
                        end 
                        cityData:setBuilderBy(msg.lID,msg)
                        
                        if self.buildOver then 
                            self:buildOver()
                        end 
                        if self.showUnlockEffect then 
                            self:showUnlockEffect()
                        end 

                        gevent:call(global.gameEvent.EV_ON_GUIDE_FINISH_CRUX_STEP)
                        if self.freeEffectCall then 
                            self.freeEffectCall() 
                        else                         
                            gevent:call(global.gameEvent.EV_ON_UI_BUILD_FLUSH)
                        end
                    end)
                end
                self.txt_count:setVisible(true) 
                self:showEffect("free")
            end
        }
    })
end

function CityBuilder:startCountDown()
    self.data = cityData:getBuilderBy(self.data.queueId)
    self.m_totalTime = self.data.serverData.lTotleTime
    self:countDownHandler()
    if self.m_countDownTimer then
    else
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
end

function CityBuilder:onEnter()
end

function CityBuilder:onExit()
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end

    if self.m_countLockDownTimer then
        gscheduler.unscheduleGlobal(self.m_countLockDownTimer)
        self.m_countLockDownTimer = nil
    end
end

function CityBuilder:setData(data)

    --dump(data,"hahahaahahahahahaha")
    self.data = data

    self.btn_state:setName("btn_state" .. self.data.queueId)


    local queueData = cityData:getQueueById(self.data.queueId) or {} 
    self.queueData = queueData
    if #data.unlockCost == 0 then

        self.isVipWait = false
    else

        self.isVipWait = true 
    end

    if queueData.lLocked == 0 then
        self:setOpened(true)
    else
        self:setOpened(false)
        self.m_lockRestTime = 0
    end

    if self.m_opened then
        self:setupStateMachine(stateEvent.BUILDER.STATE.IDLE)
        if self.data.serverData.lRestTime > 0 then
            self:doEvent(stateEvent.BUILDER.EVENT.BUSY)
        end
        if self:isNeedLockSchedule() then
            --如果当前已经是解锁状态了，就直接开启剩余解锁倒计时
            self:countLockDownHandler()
            if self.m_countLockDownTimer then
            else
                self.m_countLockDownTimer = gscheduler.scheduleGlobal(handler(self,self.countLockDownHandler), 1)
            end
        end
    else
        self:setupStateMachine(stateEvent.BUILDER.STATE.NOTOPEN)
    end
end

function CityBuilder:doEvent(event_name)
    if self.fsm and self.fsm:canDoEvent(event_name) then

        -- self.cur_event = event_name
        self.fsm:doEvent(event_name)
    end
end

function CityBuilder:countLockDownHandler(dt)
    if not self.queueData.lRestTime then return end
    self.m_lockRestTime = self.queueData.lRestTime - global.dataMgr:getServerTime()

    if self.m_lockRestTime <= 0 then
        --时间到啦
        local data = {
            lID = self.data.queueId,
            lLocked = 1,
            lRestTime = nil,
            lOpenTime = nil
        }
        global.cityData:setQueueById( self.data.queueId,data )
        self:doEvent(stateEvent.BUILDER.EVENT.NOTOPEN)
    end
end

function CityBuilder:countDownHandler(dt)
    local curServerTime = dataMgr:getServerTime()
    local serverData = self.data.serverData
    if serverData.lRestTime <= 0 then
        self.m_restTime = serverData.lRestTime
    else
        self.m_restTime = serverData.lRestTime - (curServerTime-serverData.lStartTime)
    end
    -- log.trace("##############CityBuilder:countDownHandler m_restTime=%s,lRestTime=%s,curServerTime=%s, lStartTime=%s",self.m_restTime,serverData.lRestTime,curServerTime,serverData.lStartTime)
    if self.txt_count:isVisible() then
        self.txt_count:setString(funcGame.formatTimeToHMS(self.m_restTime))
    end
    if self.m_restTime <= 0 then
        self:buildOver()
        return
    end
    if self.m_restTime <= global.cityData:getFreeBuildTime()  and self.fsm:getState() ~= stateEvent.BUILDER.STATE.CANFREE then
        self:doEvent(stateEvent.BUILDER.EVENT.CANFREE)
    end
end

function CityBuilder:buildOver()
    print("建造完成")
    self:doEvent(stateEvent.BUILDER.EVENT.IDLE)

    if self.m_buildOverCall then self.m_buildOverCall() end
    
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end

    if self.freeEffectCall then 
    else                         
        gevent:call(global.gameEvent.EV_ON_UI_BUILD_FLUSH)
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function CityBuilder:onStateHandler(sender, eventType)
    self:stateCall()
end

function CityBuilder:stateCall(freeEffectCall)
    self.freeEffectCall = freeEffectCall
    if self.m_stateCall then self.m_stateCall() end
end

--CALLBACKS_FUNCS_END

function CityBuilder:isNeedLockSchedule()
    --需要解锁，并且处于解锁状态，则需要开启解锁时间计时器
    return (self:isCharged() and self.m_opened)
end

function CityBuilder:setOpened(i_opened)
    self.m_opened = i_opened
end

function CityBuilder:getOpened()
    return self.m_opened
end

--data=
-- lQueueID = 3,
-- lRestTime = 1474354651,
-- lStartTime = 1474354555,
function CityBuilder:work(builderId,overCall)
    self.m_buildOverCall = overCall
    self:doEvent(stateEvent.BUILDER.EVENT.BUSY)
end

function CityBuilder:checkIdle()
    return (self.fsm:getState() == stateEvent.BUILDER.STATE.IDLE)
end

function CityBuilder:checkIdleAndFree()
    return (self.fsm:getState() == stateEvent.BUILDER.STATE.IDLE) or (self.fsm:getState() == stateEvent.BUILDER.STATE.CANFREE)
end

--data
-- required int32      lID         = 1;
-- required int32      lRestTime   = 2;
-- required int32      lSysTime    = 3;
function CityBuilder:leftTimeAndTotalTime(data)

    if data then
        --使用道具消除倒计时
        data.lSysTime = data.lSysTime or 0
        data.lRestTime = data.lRestTime or 0
        self.data.serverData.lRestTime = data.lRestTime
        self.data.serverData.lStartTime = data.lSysTime
        self.m_restTime = data.lRestTime

        cityData:setBuilderBy(self.data.queueId,self.data.serverData)
    end

    local startTime = self.data.serverData.lStartTime or 0
    return self.m_restTime,self.m_totalTime
end

function CityBuilder:unLockQueueCall( _itemId, _itemCount )
    if _itemId ~= 0 then
        if _itemId == 6 then
            global.cityApi:clearQueue(self.data.queueId, 1,function(msg)
                if self.m_opened then
                    global.tipsMgr:showWarning("IncreaseQueueTime")
                else
                    global.tipsMgr:showWarning("ActivateQueue")
                end
                self:setOpened(true)
                self:doEvent(stateEvent.BUILDER.EVENT.IDLE)
                self:showUnlockEffect()

                local data = {
                    lID = self.data.queueId,
                    lLocked = 0,
                    lRestTime = msg.lRestTime,
                    lOpenTime = msg.lSysTime
                }
                global.cityData:setQueueById( self.data.queueId,data )
                self.m_lockRestTime = msg.lRestTime
            end)
        else
            global.cityApi:clearQueue(self.data.queueId, 1,function(msg)
                if self.m_opened then
                    global.tipsMgr:showWarning("IncreaseQueueTime")
                else
                    global.tipsMgr:showWarning("ActivateQueue")
                end
                self:setOpened(true)
                self:doEvent(stateEvent.BUILDER.EVENT.IDLE)
                self:showUnlockEffect()

                local data = {
                    lID = self.data.queueId,
                    lLocked = 0,
                    lRestTime = msg.lRestTime,
                    lOpenTime = msg.lSysTime
                }
                global.cityData:setQueueById( self.data.queueId,data )
                self.m_lockRestTime = msg.lRestTime
                
            end, 0,_itemId, _itemCount)
        end
    else
        if self.data.queueId == 3 and self.queueData and self.queueData.lRestTime then
            self.m_lockRestTime = self.queueData.lRestTime
        else
            self.m_lockRestTime = 0
        end
    end
    return self.m_lockRestTime
end

function CityBuilder:isCharged()
    return not(self.data.unlockCost and #self.data.unlockCost <= 0)
end

function CityBuilder:getQueueId()
    return self.data.queueId
end

function CityBuilder:getBtn()
    return self.btn_state
end

return CityBuilder

--endregion
