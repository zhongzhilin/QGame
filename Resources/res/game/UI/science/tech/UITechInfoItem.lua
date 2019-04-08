--region UITechInfoItem.lua
--Author : yyt
--Date   : 2017/03/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITechInfoItem  = class("UITechInfoItem", function() return gdisplay.newWidget() end )

function UITechInfoItem:ctor()
    
end

function UITechInfoItem:CreateUI()
    local root = resMgr:createWidget("science/tech_studying_node")
    self:initUI(root)
end

function UITechInfoItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "science/tech_studying_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.science_name = self.root.Node_1.science_name_export
    self.rest_time = self.root.Node_1.rest_time_export
    self.state = self.root.Node_1.state_export

    uiMgr:addWidgetTouchHandler(self.root.Node_1.speed_btn, function(sender, eventType) self:onSpeedHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UITechInfoItem:setData()
    
    local queue = global.techData:getQueueByTime()
    self.curQueue = queue[#queue] 

    local scienceData = luaCfg:get_science_by(self.curQueue.lBindID) or {}  -- protect 
    if scienceData and scienceData.name then 
        self.science_name:setString(scienceData.name.."  ")
    end 
    self.rest_time:setPositionX(self.science_name:getPositionX()+self.science_name:getContentSize().width)

    self.m_totalTime = self.curQueue.lTotleTime
    if self.m_countDownTimer then
    else
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
    self:countDownHandler()

end

function UITechInfoItem:countDownHandler(dt)

    local curServerTime = global.dataMgr:getServerTime()

    if self.curQueue and self.curQueue.lRestTime then 
        if self.curQueue.lRestTime <= 0 then
            self.m_restTime = math.floor(self.curQueue.lRestTime)
        else
            self.curQueue.lStartTime = self.curQueue.lStartTime or curServerTime
            self.m_restTime = math.floor(self.curQueue.lRestTime - (curServerTime-self.curQueue.lStartTime))
        end
        
        if self.m_restTime <= 0 then
            if self.m_countDownTimer then
                gscheduler.unscheduleGlobal(self.m_countDownTimer)
                self.m_countDownTimer = nil
            end
            return
        end
        self.rest_time:setString(global.funcGame.formatTimeToHMS(self.m_restTime))
    end 
end


function UITechInfoItem:onSpeedHandler(sender, eventType)
    
    local function leftTimeAndTotalTime(data)

        if data then
            --使用道具消除训练cd回调方法
            global.techData:referQueue(data)
            self.curQueue.lRestTime = data.lRestTime
        end

        return self.m_restTime, self.m_totalTime
    end

    local panel = global.panelMgr:openPanel("UISpeedPanel")   -- 科技加速

    if self.curQueue and self.curQueue.lID then -- 保护处理--

        panel:setData(leftTimeAndTotalTime, self.curQueue.lID, panel.TYPE_TECH_SPEED)
    end 
end

function UITechInfoItem:onExit()
    -- body
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

--CALLBACKS_FUNCS_END

return UITechInfoItem

--endregion
