--region DeviceListCard.lua
--Author : yyt
--Date   : 2016/10/08
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

local DeviceListCard  = class("DeviceListCard", function() return gdisplay.newWidget() end )

function DeviceListCard:ctor()
    
end

function DeviceListCard:CreateUI()
    local root = resMgr:createWidget("wall/wall_fac_list")
    self:initUI(root)
end

function DeviceListCard:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wall/wall_fac_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.name = self.root.name_export
    self.text = self.root.text_export
    self.bar = self.root.bar_export
    self.btn_finish = self.root.btn_finish_export
    self.btn_txt = self.root.btn_finish_export.btn_txt_export
    self.cost_icon = self.root.btn_finish_export.cost_icon_export
    self.cost_num = self.root.btn_finish_export.cost_num_export
    self.waiting = self.root.waiting_mlan_6_export
    self.time = self.root.time_export
    self.portrait_view = self.root.portrait_view_export
    self.portrait_node = self.root.portrait_view_export.portrait_node_export
    self.list_idle = self.root.list_idle_export
    self.title = self.root.title_export

    uiMgr:addWidgetTouchHandler(self.btn_finish, function(sender, eventType) self:onFinishClickHandler(sender, eventType) end)
--EXPORT_NODE_END

    self.fsm = global.stateMachine.new()
    self.m_clickCall = nil
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function DeviceListCard:initStateMachine(initial_state)
    self.fsm:setupState({
        initial = initial_state,
        events = {
            {name = stateEvent.TRAIN.EVENT.IDLE, from = "*", to = stateEvent.TRAIN.STATE.IDLE},
            {name = stateEvent.TRAIN.EVENT.TRAINING, from = {stateEvent.TRAIN.STATE.IDLE,stateEvent.TRAIN.STATE.WAITING}, to = stateEvent.TRAIN.STATE.TRAINING},
            {name = stateEvent.TRAIN.EVENT.WAITING, from = stateEvent.TRAIN.STATE.IDLE, to = stateEvent.TRAIN.STATE.WAITING},
        },
        callbacks = {
            ["onenter"..stateEvent.TRAIN.STATE.IDLE] = function(event)
                self.m_clickCall = function() 
                    print(event.name.."闲置状态，可以建造")
                end
                self.list_idle:setVisible(true)
                self.m_delegate:checkBuild()
            end,
            ["onenter"..stateEvent.TRAIN.STATE.TRAINING] = function(event)
                self.m_clickCall = function() 
                    print(event.name.."训练中")
                    tipsMgr:showWarning("秒cd功能暂未开放")
                    -- if cityData.checkResources(self.data.perCost) then
        --                 self:downOver()
                    -- end
                end
                self.list_idle:setVisible(false)
                self.btn_finish:setVisible(true)
                self.waiting:setVisible(false)

                if self.m_countDownTimer then
                    
                else
                    self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
                end
            end,
            ["onleave"..stateEvent.TRAIN.STATE.TRAINING] = function(event)
                -- tipsMgr:showWarning("设备建造完成"..self.data.name.."+"..math.ceil(1))
            end,
            ["onenter"..stateEvent.TRAIN.STATE.WAITING] = function(event)
                self.m_clickCall = function() 
                    print(event.name.."等待中")
                end
                self.list_idle:setVisible(false)
                self.btn_finish:setVisible(false)
                self.waiting:setVisible(true)
            end,
        }
    })
end

function DeviceListCard:setDelegate(delegate)
    self.m_delegate = delegate
end

function DeviceListCard:setData( data )
    self.data = data
    dump(self.data)
    self:initStateMachine(stateEvent.TRAIN.STATE.IDLE)
    if self.data then
        if self.data.lID == 1 then
            self:startTrain(self.data)
        else
            self:startWait(self.data)
        end
    else
        self:startIdle()
    end

end

function DeviceListCard:setUIData()
    if not self.data then return end

    local deviceData = luaCfg:get_def_device_by(self.data.lSID)
    
    --self.portrait_view:setSpriteFrame("ui_surface_icon/train_soldier_s_bg"..soldierData.skill..".png")
    --global.tools:setSoldierAvatar(self.portrait_node,soldierData)
    self.name:setString(deviceData.name)
    self.text:setString(self.data.lCount)
    self.cost_num:setString(50)
    local itemData = luaCfg:get_item_by(WCONST.ITEM.TID.GOLD)
    -- self.cost_icon:setSpriteFrame(itemData.itemIcon)

    if self.data.lStartTime then
        local lTotalTime = self.data.lEndTime - self.data.lStartTime
        local currServerTime = dataMgr:getServerTime()
        if self.data.lStartTime - currServerTime > 0 then
            currServerTime = self.data.lStartTime
        end
        local lRestTime = self.data.lEndTime -  currServerTime
        self.time:setString(funcGame.formatTimeToHMS(lRestTime))
        self.bar:setPercent((lTotalTime-lRestTime)/lTotalTime*100)
    end 
end

function DeviceListCard:startTrain(data)
    self.data = data
    if self.data.lID ~= 1 then
        --预防第二个队列调用建造接口
        return
    end
    self:setUIData()
    self:doEvent(stateEvent.TRAIN.STATE.TRAINING)
end

function DeviceListCard:startWait(data)
    self.data = data
    self:setUIData()
    self:doEvent(stateEvent.TRAIN.STATE.WAITING)
end

function DeviceListCard:startIdle()
    self:setUIData()
    self:doEvent(stateEvent.TRAIN.STATE.IDLE)
end 

function DeviceListCard:doEvent(event_name)
    if self.fsm and self.fsm:canDoEvent(event_name) then
        -- self.cur_event = event_name
        self.fsm:doEvent(event_name)
    end
end

function DeviceListCard:countDownHandler(dt)
    local currServerTime = dataMgr:getServerTime()
    local queueData = self.data
    local lTotalTime = queueData.lEndTime - queueData.lStartTime
    local lRestTime = queueData.lEndTime - currServerTime

    self.time:setString(funcGame.formatTimeToHMS(lRestTime))
    self.bar:setPercent((lTotalTime-lRestTime)/lTotalTime*100)
    if lRestTime <= 0 then
        self:downOver()
    end
end

function DeviceListCard:downOver()

    local waiter = self.m_delegate:getWaiter()
    --是否有待建造任务
    if waiter:isWait() then
        local data = waiter:getData()
        data.lID = 1
        self:startTrain(data)
        waiter:startIdle()
    else
        if self.m_countDownTimer then
            gscheduler.unscheduleGlobal(self.m_countDownTimer)
            self.m_countDownTimer = nil
        end
        self:startIdle()
    end
end

function DeviceListCard:isIdle()
    return self.fsm:isState(stateEvent.TRAIN.STATE.IDLE)
end

function DeviceListCard:isWait()
    return self.fsm:isState(stateEvent.TRAIN.STATE.WAITING)
end

function DeviceListCard:setTitle(str)
    self.title:setString(str)
end

function DeviceListCard:getData()
    return self.data
end

function DeviceListCard:onFinishClickHandler(sender, eventType)
    if self.m_clickCall then self.m_clickCall() end
end

function DeviceListCard:onExit()
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end
--CALLBACKS_FUNCS_END

return DeviceListCard

--endregion
