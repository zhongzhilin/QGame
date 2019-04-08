--region UIBuyEnergyPanel.lua
--Author : yyt
--Date   : 2017/02/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local userData = global.userData
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBuyEnergyPanel  = class("UIBuyEnergyPanel", function() return gdisplay.newWidget() end )

function UIBuyEnergyPanel:ctor()
    self:CreateUI()
end

function UIBuyEnergyPanel:CreateUI()
    local root = resMgr:createWidget("lord/lord_buy_energy")
    self:initUI(root)
end

function UIBuyEnergyPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "lord/lord_buy_energy")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.gray_spite = self.root.Node_export.use_btn.gray_spite_export
    self.diamond = self.root.Node_export.use_btn.diamond_export
    self.txt_Title = self.root.Node_export.node.txt_Title_mlan_15_export
    self.cost = self.root.Node_export.node.cost_export
    self.tips2 = self.root.Node_export.node.tips2_mlan_15_export
    self.resetTime = self.root.Node_export.node.tips2_mlan_15_export.resetTime_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.use_btn, function(sender, eventType) self:confirm(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.item_btn, function(sender, eventType) self:use_item(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIBuyEnergyPanel:onEnter()

    -- 零点刷新 
    self:addEventListener(global.gameEvent.EV_ON_DAILY_TASK_FLUSH,function()
        self:setData()
    end)

end

function UIBuyEnergyPanel:onExit()

    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

function UIBuyEnergyPanel:setData(callback, isNotEnough)

    self.isNotEnough = isNotEnough
    self.needDiamond = 0
    self.m_buyCall = callback
    local vipfreenumber = global.vipBuffEffectData:getVipDiverseFreeNumber("lVipLordCount")
    local curVipLv = userData:getVipLevel()

    local vipData = luaCfg:get_vip_func_by(curVipLv)

    local expData = luaCfg:get_lord_exp_by(userData:getLevel())

    local curBuyTimes = global.dailyTaskData:getBuyStrengthTimes()

    local canBuyTimes = vipData.energyBuyTimes - curBuyTimes+vipfreenumber

    if canBuyTimes < 0 then canBuyTimes = 0 end

    local diamondNum =  (expData.energy/10)*vipData.tenEnergyCost
    
    if curBuyTimes > 0 then
        -- diamondNum = diamondNum * curBuyTimes * vipData.multiple
        diamondNum = diamondNum *  math.pow(vipData.multiple , curBuyTimes) 
    end

    diamondNum = math.ceil(diamondNum)
    self.canBuyTimes = canBuyTimes 
    self.maxEnergy = expData.energy
    global.colorUtils.turnGray(self.gray_spite,self.canBuyTimes <= 0)
    self:checkDiamondEnough(diamondNum)

    -- 购买重置倒计时
    self:cutTime()

end

function UIBuyEnergyPanel:cutTime()
    -- body
    self.lEndTime = global.dailyTaskData:getNextFlushTime()
    if not self.m_countDownTimer then
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
    self:countDownHandler()
end

function UIBuyEnergyPanel:countDownHandler(dt)

    if not self.lEndTime or not self.tips2 or not self.resetTime or not self.m_countDownTimer then return end  --容错处理

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

function UIBuyEnergyPanel:exit_click(sender, eventType)
    global.panelMgr:closePanelForBtn("UIBuyEnergyPanel")  
end

function UIBuyEnergyPanel:confirm(sender, eventType)

    if self.canBuyTimes <= 0 then
        global.tipsMgr:showWarning("Physical01")
        return
    end

    local curHp = global.userData:getCurHp()
    if self:checkDiamondEnough(self.needDiamond) then

        global.itemApi:diamondUse(function(msg)
            if msg.tgBuyCount.lBuyLord then
                -- if  global.vipBuffEffectData:isUseVipFreeNumber("lVipLordCount") then 
                --     global.vipBuffEffectData:useVipDiverseFreeNumber("lVipLordCount",1)
                -- else 
                global.dailyTaskData:setBuyStrengthTimes(msg.tgBuyCount.lBuyLord)
                -- end 
            end

            global.userData:setCurHp( curHp + self.maxEnergy )
            gevent:call(global.gameEvent.EV_ON_UI_HP_UPDATE)

            if self.m_buyCall then self.m_buyCall(msg) end
            self:exit_click()

        end,9)
    else
        global.panelMgr:openPanel("UIRechargePanel")
        self:exit_click()
    end

end

function UIBuyEnergyPanel:checkDiamondEnough(num)

    self.needDiamond = num
    self.diamond:setString(num)

    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,num) then

        self.diamond:setTextColor(gdisplay.COLOR_RED)
        local richId1 = 0
        if self.isNotEnough then
            richId1 = 50055
        else
            richId1 = 50025
        end

        uiMgr:setRichText(self, "cost", richId1, {count = num, num = self.maxEnergy, level = userData:getVipLevel(), buyTime = self.canBuyTimes })
        return false
    else

        self.diamond:setTextColor(cc.c3b(255, 184, 34))
        local richId2 = 0
        if self.isNotEnough then
            richId2 = 50056
        else
            richId2 = 50024
        end
        uiMgr:setRichText(self, "cost", richId2, {count = num, num = self.maxEnergy, level = userData:getVipLevel(), buyTime = self.canBuyTimes })
        return true
    end
end


function UIBuyEnergyPanel:use_item(sender, eventType)
    --  -- 如果有体力药水 则弹出 道具使用

    global.panelMgr:closePanel("UIBuyEnergyPanel")
    local panel = global.panelMgr:openPanel("UISpeedPanel")   --行军加速道具使用
    panel:setData(nil,nil,panel.TYPE_LORD_HP, nil)
end
--CALLBACKS_FUNCS_END

return UIBuyEnergyPanel

--endregion
