--region UIBuySoldierSource.lua
--Author : yyt
--Date   : 2017/11/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBuySoldierSource  = class("UIBuySoldierSource", function() return gdisplay.newWidget() end )

function UIBuySoldierSource:ctor()
    self:CreateUI()
end

function UIBuySoldierSource:CreateUI()
    local root = resMgr:createWidget("manpower/buy_soliderSource")
    self:initUI(root)
end

function UIBuySoldierSource:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "manpower/buy_soliderSource")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.gray_spite = self.root.Node_export.use_btn.gray_spite_export
    self.diamond = self.root.Node_export.use_btn.diamond_export
    self.txt_Title = self.root.Node_export.node.txt_Title_mlan_18_export
    self.cost = self.root.Node_export.node.cost_export
    self.tips2 = self.root.Node_export.node.tips2_mlan_14_export
    self.resetTime = self.root.Node_export.node.tips2_mlan_14_export.resetTime_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.use_btn, function(sender, eventType) self:useDiamondHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.item_btn, function(sender, eventType) self:useItemHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIBuySoldierSource:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_SOURCE_SINGEBUY,function()
        if self.checkDiamondEnough then
            self:checkDiamondEnough(self.singleCost)
        end
    end)

    -- 固定时间购买次重置
    self:addEventListener(global.gameEvent.EV_ON_SOURCE_BUYCOST_UPDATE,function ()
        if self.setData then
            self:setData(self.data)
        end
    end)
end

function UIBuySoldierSource:setData(data)

    self.data = data
    local buyTimes = global.refershData:getBuyCount()
    local singleCost = self:getDiamondCost(buyTimes)
    self.buyTimes = buyTimes
    self.singleCost = singleCost
    self:checkDiamondEnough(singleCost)
    self.txt_Title:setString(global.luaCfg:get_local_string(10904))
    global.colorUtils.turnGray(self.gray_spite,buyTimes <= 0)


    self.tips2:setVisible(false)
    self.cost:setPositionY(self.tips2:getPositionY()+50)
    -- self:setNextReSetTime()
    -- self.tips2:setString(global.luaCfg:get_local_string(10905))
    -- global.tools:adjustNodeVerical(self.tips2, self.resetTime)

    
end

-- 兵源购买次数倒计时
-- function UIBuySoldierSource:setNextReSetTime()

--     self.lEndTime = global.dailyTaskData:getTimestamp().lPopTime
--     self:cutTime()
-- end

-- function UIBuySoldierSource:cutTime()

--     if not self.m_countDownTimer then
--         self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
--     end
--     self:countDownHandler()
-- end

-- function UIBuySoldierSource:countDownHandler(dt)
--     if self.lEndTime <= 0 then
--         self.resetTime:setString("00:00:00")
--         return
--     end
--     local curr = global.dataMgr:getServerTime()
--     local rest = self.lEndTime - curr
--     if rest < 0 then
--         if self.m_countDownTimer then
--             gscheduler.unscheduleGlobal(self.m_countDownTimer)
--             self.m_countDownTimer = nil
--         end
--         return
--     end

--     local dayNum = math.floor(rest/(24*3600))
--     local str = ""
--     if dayNum > 0 then
--         str = string.format(global.luaCfg:get_local_string(10675),dayNum ,global.funcGame.formatTimeToHMS(rest-dayNum*24*3600)) 
--     else
--         str = global.funcGame.formatTimeToHMS(rest)
--     end
--     self.resetTime:setString(str)
-- end

-- function UIBuySoldierSource:onExit()
    
--     if self.m_countDownTimer then
--         gscheduler.unscheduleGlobal(self.m_countDownTimer)
--         self.m_countDownTimer = nil
--     end
-- end

function UIBuySoldierSource:checkDiamondEnough(num)

    self.needDiamond = num
    self.diamond:setString(num)

    local panelSource = global.panelMgr:getPanel("UISoldierSourcePanel")
    self.singleBuySource = panelSource.singleBuySource
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,num) then
        self.diamond:setTextColor(gdisplay.COLOR_RED)
        uiMgr:setRichText(self, "cost", 50224, {count = num, num = panelSource.singleBuySource})
        return false
    else
        self.diamond:setTextColor(cc.c3b(255, 184, 34))
        uiMgr:setRichText(self, "cost", 50223, {count = num, num = panelSource.singleBuySource})
        return true
    end
end

function UIBuySoldierSource:getDiamondCost(buyTimes)
    
    local powerData = luaCfg:get_buildings_manpower_by(self.data.serverData.lGrade)
    return powerData["costNum"..buyTimes] or powerData["costNum"..powerData.maxNum]
end

function UIBuySoldierSource:exit_click(sender, eventType)
    global.panelMgr:closePanel("UIBuySoldierSource")
end

function UIBuySoldierSource:useDiamondHandler(sender, eventType)
    
    if not self:checkDiamondEnough(self.singleCost) then
        global.panelMgr:openPanel("UIRechargePanel")
        return
    else
        global.itemApi:diamondUse(function(msg)

            if msg.tgBuyCount then 
                global.refershData:setBuyCount(msg.tgBuyCount.lPopCount) 
            end
            local panelSource = global.panelMgr:getPanel("UISoldierSourcePanel")
            global.tipsMgr:showWarning(string.format(luaCfg:get_local_string(10117), self.singleCost, self.singleBuySource))
            -- gevent:call(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE)
            self:exit_click()
        end,6)
    end
end

function UIBuySoldierSource:useItemHandler(sender, eventType)
    global.panelMgr:closePanel("UIBuySoldierSource")
    local panel = global.panelMgr:openPanel("UISpeedPanel")   --行军加速道具使用
    panel:setData(nil,nil,panel.TYPE_SOLDIER_SOURCE, nil)
end
--CALLBACKS_FUNCS_END

return UIBuySoldierSource

--endregion
