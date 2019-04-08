--region UIScienceStudy.lua
--Author : yyt
--Date   : 2017/02/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local funcGame = global.funcGame
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIScienceStudy  = class("UIScienceStudy", function() return gdisplay.newWidget() end )

function UIScienceStudy:ctor()
end

function UIScienceStudy:CreateUI()
    local root = resMgr:createWidget("science/science_main_studying_node")
    self:initUI(root)
end

function UIScienceStudy:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "science/science_main_studying_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.type = self.root.Button_2.type_export
    self.loadingbar_bg = self.root.Button_2.loadingbar_bg_export
    self.LoadingBar = self.root.Button_2.loadingbar_bg_export.LoadingBar_export
    self.time = self.root.Button_2.loadingbar_bg_export.time_export

    uiMgr:addWidgetTouchHandler(self.root.Button_2, function(sender, eventType) self:clickHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIScienceStudy:setData(data, overCall, index)

    self.data = data
    self.index = index
    self.overCall = overCall
    local scienceData = luaCfg:get_science_by(data.lBindID)
    if scienceData then
        self.type:setString(scienceData.name)
    end
    
    self.m_totalTime = data.lTotleTime
    if self.m_countDownTimer then
    else
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
    self:countDownHandler()

end

function UIScienceStudy:countDownHandler(dt)

    local curServerTime = global.dataMgr:getServerTime()
    if self.data.lRestTime <= 0 then
        self.m_restTime = math.floor(self.data.lRestTime)
    else
        --报错处理
        if self.data and self.data.lStartTime then 
            self.m_restTime = math.floor(self.data.lRestTime - (curServerTime-self.data.lStartTime))
        end
    end

    if self.m_restTime then 
        if self.m_restTime <= 0 then
            self:techOver()
            return
        end
        if self.m_totalTime  then 
            self.LoadingBar:setPercent((1-self.m_restTime / self.m_totalTime )* 100)
        end 
        self.time:setString(funcGame.formatTimeToHMS(self.m_restTime))  
    end 
end

function UIScienceStudy:techOver()

    self.LoadingBar:setPercent(100)
    self.time:setString("00:00:00")

    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end

    self.overCall(self.data.lBindID, self.index)
end

function UIScienceStudy:onExit()
    
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

function UIScienceStudy:clickHandler(sender, eventType)

    local scienceData = global.techData:getTechById(self.data.lBindID)
    global.panelMgr:openPanel("UITechNowPanel"):setData(scienceData)

end
--CALLBACKS_FUNCS_END

return UIScienceStudy

--endregion
