--region TrainCard.lua
--Author : wuwx
--Date   : 2016/08/25
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local stateEvent = global.stateEvent
local dataMgr = global.dataMgr
local funcGame = global.funcGame
local tipsMgr = global.tipsMgr
local luaCfg = global.luaCfg
local cityData = global.cityData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local TrainCard  = class("TrainCard", function() return gdisplay.newWidget() end )

function TrainCard:ctor()
    
end

function TrainCard:CreateUI()
    local root = resMgr:createWidget("train/train_list")
    self:initUI(root)
end

function TrainCard:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "train/train_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.name = self.root.node1.name_export
    self.text = self.root.node1.text_export
    self.loadBar = self.root.loadBar_export
    self.bar = self.root.loadBar_export.bar_export
    self.time = self.root.loadBar_export.time_export
    self.btn_finish = self.root.btn_finish_export
    self.btn_txt = self.root.btn_finish_export.btn_txt_mlan_3_export
    self.cost_icon = self.root.btn_finish_export.cost_icon_export
    self.cost_num = self.root.btn_finish_export.cost_num_export
    self.portrait_view = self.root.portrait_view_export
    self.portrait_node = self.root.portrait_view_export.portrait_node_export
    self.list_idle = self.root.list_idle_export
    self.idle = self.root.list_idle_export.idle_mlan_15_export
    self.title1 = self.root.title1_mlan_8_export
    self.title = self.root.title_export
    self.complete = self.root.complete_mlan_8_export

    uiMgr:addWidgetTouchHandler(self.btn_finish, function(sender, eventType) self:onFinishClickHandler(sender, eventType) end)
--EXPORT_NODE_END

	self.fsm = global.stateMachine.new()
    self.m_clickCall = nil

    global.tools:adjustNodePos(self.title1,self.title)
end

local picBg = {
    [1] = "ui_button/btn_equip_grey.png",
    [2] = "ui_button/btn_reward.png",
}

function TrainCard:initStateMachine(initial_state)
    self.fsm:setupState({
        initial = initial_state,
        events = {
            {name = stateEvent.TRAIN.EVENT.IDLE, from = "*", to = stateEvent.TRAIN.STATE.IDLE},
            {name = stateEvent.TRAIN.EVENT.TRAINING, from = {stateEvent.TRAIN.STATE.IDLE,stateEvent.TRAIN.STATE.WAITING}, to = stateEvent.TRAIN.STATE.TRAINING},
            {name = stateEvent.TRAIN.EVENT.DONE, from = stateEvent.TRAIN.STATE.TRAINING, to = stateEvent.TRAIN.STATE.DONE},
        },
        callbacks = {
            ["onenter"..stateEvent.TRAIN.STATE.IDLE] = function(event)
                self.m_clickCall = function() 
                    print(event.name.."闲置状态，可以训练")
                end
                self.complete:setVisible(false)
                self:checkIdle()
				self.m_delegate:checkTrain()
            end,
            ["onenter"..stateEvent.TRAIN.STATE.TRAINING] = function(event)
                self.m_clickCall = function() 
                    print(event.name.."训练中")
                    -- tipsMgr:showWarning("秒cd功能暂未开放")
                    local  buildingId = self.m_delegate:getBuildingId()
                    local function leftTimeAndTotalTime(data, cutTime)
                        if not self.data then return end
                        if data and cutTime then
                            -- 加速起始时间减
                            self.data.lStartTime =  self.data.lStartTime - cutTime
                            self.data.lEndTime = self.data.lEndTime - cutTime
                            cityData:setTrainList(buildingId,self.data)
                            self:countDownHandler()
                        end

                        local lTotalTime = self.data.lEndTime - self.data.lStartTime
                        local currServerTime = dataMgr:getServerTime()
                        if self.data.lStartTime - currServerTime > 0 then
                            currServerTime = self.data.lStartTime
                        end
                        local lRestTime = self.data.lEndTime-currServerTime
                        lRestTime = (lTotalTime <= 0) and 0 or lRestTime
                        return lRestTime,self.m_totalTime
                    end

                    local panel = global.panelMgr:openPanel("UISpeedPanel")   -- 解锁道具使用
                    panel:setData(leftTimeAndTotalTime, self.data.lID, panel.TYPE_SOLDIER_TRAIN, buildingId)

                end

                self.complete:setVisible(false)
                self.loadBar:setVisible(true)
                self.list_idle:setVisible(false)
                self.btn_finish:loadTextures(picBg[1],picBg[1],picBg[1],ccui.TextureResType.plistType)
                self.btn_txt:setString(luaCfg:get_local_string(10028))

				if self.m_countDownTimer then
			    else
			        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
			    end
                self:countDownHandler()
            end,
            ["onleave"..stateEvent.TRAIN.STATE.TRAINING] = function(event)
    			-- tipsMgr:showWarning("训练完成士兵"..self.data.name.."+"..math.ceil(1))
            end,
            ["onenter"..stateEvent.TRAIN.STATE.DONE] = function(event)

                self.m_clickCall = function()
                    self:playSound()
                    self:trainFinish()
                end
                
                self.list_idle:setVisible(false)             
                self.btn_finish:loadTextures(picBg[2],picBg[2],picBg[2],ccui.TextureResType.plistType)
                self.btn_txt:setString(luaCfg:get_local_string(10657))
                self.loadBar:setVisible(false)
                self.complete:setVisible(true)

            end,

        }
    })
end

function TrainCard:playSound()
    if self.m_isRicher then
        return
    end
    local soldierData = luaCfg:get_soldier_train_by(self.data.lSID)
    gsound.stopEffect("city_click")
    if soldierData.type == 7 then
        if soldierData.skill == 1 then
            gevent:call(gsound.EV_ON_PLAYSOUND,"city_bartizan")
        else
            gevent:call(gsound.EV_ON_PLAYSOUND,"city_trap")
        end
    else
        gevent:call(gsound.EV_ON_PLAYSOUND,"city_train_"..soldierData.type)
    end
end

function TrainCard:onEnter()

     self:addEventListener(global.gameEvent.EV_ON_UI_VIPUPDATE,function()
        -- self:setData(true)
        if self:isIdle() then 
            self:checkIdle()
        end 
        
    end)
end

function TrainCard:onExit()
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function TrainCard:onFinishClickHandler(sender, eventType)
	if self.m_clickCall then self.m_clickCall() end
end
--CALLBACKS_FUNCS_END

function TrainCard:setDelegate(delegate)
	self.m_delegate = delegate
end

function TrainCard:setData(data)
    if data then
        self.data = self.data or {}
        table.assign(self.data,data)
    else
        self.data = nil
    end
    self:initStateMachine(stateEvent.TRAIN.STATE.IDLE)
    if self.data and self.data.lID then
        --保留最初的总时间
        self.m_totalTime = self.data.lEndTime-self.data.lStartTime
        self:startTrain(self.data)
    else
        self:startIdle()
    end
end

function TrainCard:setTitle(str)
	self.title:setString(str)
end

function TrainCard:setUIData()
    if not self.data then return end
    local soldierData = luaCfg:get_soldier_train_by(self.data.lSID)
    
	self.portrait_view:setSpriteFrame("ui_surface_icon/train_soldier_s_bg"..soldierData.skill..".png")
	global.tools:setSoldierAvatar(self.portrait_node,soldierData)
	self.name:setString(soldierData.name)
    self.text:setString(self.data.lCount)
    --润稿修改 张亮
    global.tools:adjustNodePos(self.name,self.text)

    if self.data.lStartTime then
        local lTotalTime = self.data.lEndTime-self.data.lStartTime
        local currServerTime = dataMgr:getServerTime()
        if self.data.lStartTime - currServerTime > 0 then
            currServerTime = self.data.lStartTime
        end
        local lRestTime = self.data.lEndTime-currServerTime
        lRestTime = (lTotalTime <= 0) and 0 or lRestTime
        self.time:setString(funcGame.formatTimeToHMS(lRestTime))
        self.cost_num:setString(global.funcGame.getDiamondCount(lRestTime))
        self.bar:setPercent((lTotalTime-lRestTime)/lTotalTime*100)
    end
end

function TrainCard:startTrain(data,isRicher)
    if data then
        self.data = self.data or {}
        table.assign(self.data,data)
    else
        self.data = nil
    end
    self.m_totalTime = self.data.lTotleTime
    self:setUIData()
    self:doEvent(stateEvent.TRAIN.STATE.TRAINING)
    self.m_isRicher = isRicher
    if isRicher then
        -- 秒兵
        self:onFinishClickHandler()
    end
end

function TrainCard:checkIdle()

    self.idle:setString(luaCfg:get_local_string(10655))
    self.list_idle:setVisible(true)
    local id = tonumber(self.title:getString())
    local isMonthCard = global.vipBuffEffectData:isTrainMonthCard()
    if (id == 2) and (isMonthCard == 0 ) then
        self.idle:setString(luaCfg:get_local_string(10656))
    end
end

function TrainCard:startIdle()
    self:setUIData()

    if self.fsm:canDoEvent(stateEvent.TRAIN.STATE.IDLE) then
        self:doEvent(stateEvent.TRAIN.STATE.IDLE)
    else
        self:checkIdle()
        self.m_delegate:checkTrain()
    end
end 

function TrainCard:startDone()
    self:setUIData()

    if self.fsm:canDoEvent(stateEvent.TRAIN.STATE.DONE) then
        self:doEvent(stateEvent.TRAIN.STATE.DONE)
    else
        self:checkIdle()
        self.m_delegate:checkTrain()
    end
end 

function TrainCard:doEvent(event_name)
    if self.fsm and self.fsm:canDoEvent(event_name) then
        self.fsm:doEvent(event_name)
    end
end

function TrainCard:countDownHandler(dt)
    local currServerTime = dataMgr:getServerTime()
    local queueData = self.data
    if not queueData then
        if not tolua.isnull(self.time) then 
            self.time:setString(0)
        end
        if not tolua.isnull(self.cost_num) then 
            self.cost_num:setString(0)
        end 
        if not tolua.isnull(self.bar) then 
            self.bar:setPercent(0)
        end
        if self.downOver then
            self:downOver()
        end
        return
    end
    local lTotalTime = queueData.lEndTime-queueData.lStartTime
    local lRestTime = queueData.lEndTime - currServerTime
    lRestTime = (lTotalTime <= 0) and 0 or lRestTime
    if lRestTime <= 0 then
        self.time:setString(0)
        self.cost_num:setString(0)
        self.bar:setPercent(0)
        self:downOver()
    else
        self.time:setString(funcGame.formatTimeToHMS(lRestTime))
        self.cost_num:setString(global.funcGame.getDiamondCount(lRestTime))
        self.bar:setPercent((lTotalTime-lRestTime)/lTotalTime*100)
    end
end

function TrainCard:downOver()

    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
    self:startDone()
end

function TrainCard:trainFinish()
    self:harvest()
end

function TrainCard:harvest()

    if self.data then
        cityData:removeTrainList(self.data.lID ,self.m_delegate:getBuildingId())
        gevent:call(global.gameEvent.EV_ON_UI_TRAINCARD_FINISH, self.data.lID,self.m_delegate:getBuildingId())
    end
    self:startIdle()

    local data = self.m_delegate:getData()
    local soundKey = "ui_harvest_"..data.buildingType
    if not self.m_isRicher then
        gevent:call(gsound.EV_ON_PLAYSOUND,soundKey)
    end
    global.cityApi:buildHarvest(self.m_delegate:getBuildingId(),function(msg)
        if msg and msg.tgTrain then
            global.cityData:setTrainList(self.m_delegate:getBuildingId(), msg.tgTrain)
        end

        if msg and msg.lSoldiers then
            for i,v in ipairs(msg.lSoldiers) do
                local outStr = luaCfg:get_local_string(10329)
                if data.buildingType == 14 then
                    global.soldierData:addTrapBy(v)
                    outStr = luaCfg:get_local_string(10330)
                else
                    global.soldierData:addSoldierBy(v)
                end
                local soldierTrainData = luaCfg:get_soldier_train_by(v.lID)
                outStr = outStr .. soldierTrainData.name.."+"..v.lCount
                tipsMgr:showWarning(outStr)
            end
            if global.g_cityView then 
                global.g_cityView:getSoldierMgr():refershSoldier()  -- 刷新校场士兵显示
            end 
        end
    end, nil, self.data.lID, self.data.lSID)

end

function TrainCard:isIdle()
	return self.fsm:isState(stateEvent.TRAIN.STATE.IDLE)
end

function TrainCard:isWait()
	return false
end

function TrainCard:isTraining()
    return self.fsm:isState(stateEvent.TRAIN.STATE.TRAINING)
end

function TrainCard:isDone()
    return self.fsm:isState(stateEvent.TRAIN.STATE.DONE)
end

function TrainCard:getData()
    return self.data
end

return TrainCard

--endregion
