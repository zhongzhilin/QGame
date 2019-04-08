--region UIBossEnergyPanel.lua
--Author : yyt
--Date   : 2018/02/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBossEnergyPanel  = class("UIBossEnergyPanel", function() return gdisplay.newWidget() end )

function UIBossEnergyPanel:ctor()
    self:CreateUI()
end

function UIBossEnergyPanel:CreateUI()
    local root = resMgr:createWidget("boss/boss_buyEnergy")
    self:initUI(root)
end

function UIBossEnergyPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "boss/boss_buyEnergy")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.gray_spite = self.root.Node_export.use_btn.gray_spite_export
    self.diamond = self.root.Node_export.use_btn.diamond_export
    self.cost = self.root.Node_export.node.cost_export
    self.tips2 = self.root.Node_export.node.tips2_mlan_14_export
    self.resetTime = self.root.Node_export.node.tips2_mlan_14_export.resetTime_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.use_btn, function(sender, eventType) self:diamondBuyHander(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIBossEnergyPanel:onEnter()
    -- 零点刷新 
    self:addEventListener(global.gameEvent.EV_ON_DAILY_TASK_FLUSH,function()
        if self.setData then
            self:setData()
        end
    end)
end

function UIBossEnergyPanel:setData(callBack)

    self.callBack = callBack
    local maxGateEnergy = luaCfg:get_lord_exp_by(global.userData:getLevel()).bossNum
    local diamondNum = maxGateEnergy*(1.5^global.bossData:getGateBuyTime())
    self.maxGateEnergy = maxGateEnergy
    self.diamondNum = diamondNum
    self:checkDiamondEnough(math.ceil(diamondNum))

    -- 购买重置倒计时
    self:cutTime()

end

function UIBossEnergyPanel:cutTime()
    -- body
    self.lEndTime = global.dailyTaskData:getNextFlushTime()
    if not self.m_countDownTimer then
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
    self:countDownHandler()
end

function UIBossEnergyPanel:countDownHandler(dt)

    if not self.lEndTime then return end 

    if self.lEndTime <= 0 then
        self.resetTime:setString(global.funcGame.formatTimeToHMS(0))
        global.tools:adjustNodeVerical(self.tips2, self.resetTime)
        return
    end
    local curr = global.dataMgr:getServerTime()
    local rest = self.lEndTime - curr
    if rest < 0 then
        if self.m_countDownTimer then
            gscheduler.unscheduleGlobal(self.m_countDownTimer)
            self.m_countDownTimer = nil
        end
        return
    end
    self.resetTime:setString(global.funcGame.formatTimeToHMS(rest))
    global.tools:adjustNodeVerical(self.tips2, self.resetTime)
end

function UIBossEnergyPanel:checkDiamondEnough(num)

    self.diamond:setString(num)

    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,num) then

        self.diamond:setTextColor(gdisplay.COLOR_RED)
        uiMgr:setRichText(self, "cost", 50328, {count = num, num = self.maxGateEnergy})
        return false
    else
        self.diamond:setTextColor(cc.c3b(255, 184, 34))
        uiMgr:setRichText(self, "cost", 50327, {count = num, num = self.maxGateEnergy})
        return true
    end
end

function UIBossEnergyPanel:exit_click(sender, eventType)
    global.panelMgr:closePanel("UIBossEnergyPanel")
end

function UIBossEnergyPanel:diamondBuyHander(sender, eventType)
    
    local maxGateEnergy = self.maxGateEnergy
    global.itemApi:diamondUse(function (msg)
        -- body
        global.bossData:setGateBuyTime(global.bossData:getGateBuyTime()+1)
        global.panelMgr:closePanel("UIBossEnergyPanel")
        global.tipsMgr:showWarning("buyBossRes", maxGateEnergy)
        if self.callBack then
            self.callBack()
        end
    end, 16)
end
--CALLBACKS_FUNCS_END

return UIBossEnergyPanel

--endregion
