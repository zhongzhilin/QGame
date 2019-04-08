--region UITaskTab.lua
--Author : untory
--Date   : 2017/05/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITaskTab  = class("UITaskTab", function() return gdisplay.newWidget() end )

function UITaskTab:ctor()
    
end

function UITaskTab:CreateUI()
    local root = resMgr:createWidget("achievement/paging_btn")
    self:initUI(root)
end

function UITaskTab:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "achievement/paging_btn")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.tab = self.root.tab_export
    self.task_point = self.root.tab_export.Button_1.task_point_export
    self.task_point_Text = self.root.tab_export.Button_1.task_point_export.task_point_Text_export
    self.acm_point = self.root.tab_export.Button_2.acm_point_export
    self.acm_point_Text = self.root.tab_export.Button_2.acm_point_export.acm_point_Text_export
    self.daily_point = self.root.tab_export.Button_3.daily_point_export
    self.daily_point_Text = self.root.tab_export.Button_3.daily_point_export.daily_point_Text_export

    uiMgr:addWidgetTouchHandler(self.root.tab_export.Button_1, function(sender, eventType) self:changeToTask(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.tab_export.Button_2, function(sender, eventType) self:changeToACM(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.tab_export.Button_3, function(sender, eventType) self:changeToDaily(sender, eventType) end)
--EXPORT_NODE_END

    self.root.tab_export.Button_1:setZoomScale(0)
    self.root.tab_export.Button_2:setZoomScale(0)
    self.root.tab_export.Button_3:setZoomScale(0)
    self.acm_point:setVisible(false)
end

local coppery= cc.c3b(255,226,165)
local white = gdisplay.COLOR_WHITE

function UITaskTab:setIndex(index)
    for i = 1,3 do
        self.root.tab_export["Button_" .. i]:setEnabled(i ~= index)
            
        if  self.root.tab_export["Button_" .. i].text_mlan_8 then 
            if i ~= index  then        
                self.root.tab_export["Button_" .. i].text_mlan_8:setTextColor(coppery)
            else  
                self.root.tab_export["Button_" .. i].text_mlan_8:setTextColor(white)
            end 
        end 
    end
end

function UITaskTab:onEnter()
 
    self:checkDailyPoint()
    self:checkAcmPoint()
    self:checkTaskPoint()


    self:addEventListener(global.gameEvent.EV_ON_TASK_COMPELETE,function()
        
        self:checkTaskPoint()
    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_ACM_UPDATE, function()
        
        self:checkAcmPoint()
    end)


    self:addEventListener(global.gameEvent.EV_ON_DAILY_TASK_FLUSH, function()
        
        self:checkDailyPoint()
    end)
end

function UITaskTab:checkTaskPoint()
    
    local isNeedShowRed,Count = global.taskData:isHaveNewGift()
    self.task_point:setVisible(isNeedShowRed)
    self.task_point_Text:setString(Count)
end

function UITaskTab:checkDailyPoint()

    self.daily_point:setVisible(false)
    local opLv = global.luaCfg:get_config_by(1).dailyTaskLv
    if global.cityData:checkBuildLv(1, opLv) then
        local dailyNum = global.dailyTaskData:getFinishTask()
        self.daily_point:setVisible(dailyNum > 0)
        self.daily_point_Text:setString(dailyNum)
    end
end

function UITaskTab:checkAcmPoint()

    self.acm_point:setVisible(false)
    local achCount = global.achieveData:getAcieveNum()
    if achCount > 0 then
        self.acm_point:setVisible(true)        
        self.acm_point_Text:setString(achCount)    
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UITaskTab:changeToACM(sender, eventType)
    gsound.stopEffect("city_click")
    global.panelMgr:closeTopPanel()
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_flip")

    local panel = global.panelMgr:openPanel("UIAchievePanel")
    panel:showTab()

end

function UITaskTab:changeToDaily(sender, eventType)
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_flip")

    local opLv = global.luaCfg:get_config_by(1).dailyTaskLv
    if global.funcGame:checkBuildLv(1, opLv) then
        global.panelMgr:closeTopPanel() 
        local panel = global.panelMgr:openPanel("UIDailyTaskPanel")
        panel:showTab()
        panel:setData()  
    end
end

function UITaskTab:changeToTask(sender, eventType)
    gsound.stopEffect("city_click")
    global.panelMgr:closeTopPanel() 
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_flip")

    local panel = global.panelMgr:openPanel("TaskPanel")

end
--CALLBACKS_FUNCS_END

return UITaskTab

--endregion
