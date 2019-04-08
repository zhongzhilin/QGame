--region UISoldierSourcePanel.lua
--Author : yyt
--Date   : 2016/11/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData
local refershData = global.refershData
local propData = global.propData
local tipsMgr = global.tipsMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIAdSlideNode = require("game.UI.advertisementItem.UIAdSlideNode")
--REQUIRE_CLASS_END

local UISoldierSourcePanel  = class("UISoldierSourcePanel", function() return gdisplay.newWidget() end )

function UISoldierSourcePanel:ctor()
    self:CreateUI()
end

function UISoldierSourcePanel:CreateUI()
    local root = resMgr:createWidget("manpower/manpower_1st")
    self:initUI(root)
end

function UISoldierSourcePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "manpower/manpower_1st")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.panel_name = self.root.title_export.panel_name_fnt_mlan_12_export
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.top_content = self.root.ScrollView_1_export.top_content_export
    self.loadingbar_bg = self.root.ScrollView_1_export.top_content_export.loadingbar_bg_export
    self.LoadingBar = self.root.ScrollView_1_export.top_content_export.loadingbar_bg_export.LoadingBar_export
    self.loadLine = self.root.ScrollView_1_export.top_content_export.loadingbar_bg_export.loadLine_export
    self.now_num = self.root.ScrollView_1_export.top_content_export.loadingbar_bg_export.now_num_export
    self.total_num = self.root.ScrollView_1_export.top_content_export.loadingbar_bg_export.total_num_export
    self.recover = self.root.ScrollView_1_export.top_content_export.manpower_bg1.recover_mlan_51_export
    self.next_time = self.root.ScrollView_1_export.top_content_export.manpower_bg1.next_time_export
    self.next_recover = self.root.ScrollView_1_export.top_content_export.manpower_bg1.next_time_export.next_recover_mlan_14_export
    self.gray_spite = self.root.ScrollView_1_export.top_content_export.botNode.use_btn.gray_spite_export
    self.diamond = self.root.ScrollView_1_export.top_content_export.botNode.use_btn.diamond_export
    self.FileNode_2 = UIAdSlideNode.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.FileNode_2)

    uiMgr:addWidgetTouchHandler(self.root.title_export.intro_btn, function(sender, eventType) self:info_btn(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView_1_export.top_content_export.botNode.item_btn, function(sender, eventType) self:useItemHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView_1_export.top_content_export.botNode.use_btn, function(sender, eventType) self:useDiamondHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:btn_exit(sender, eventType) end)
    self:adapt()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UISoldierSourcePanel:adapt()

    self.ScrollView_1:setTouchEnabled(true)

    self.ScrollView_1:setContentSize(cc.size(gdisplay.width ,self.ScrollView_1:getPositionY()))

    if self.ScrollView_1:getContentSize().height > 1093 then 
        self.ScrollView_1:setTouchEnabled(false)
    end 

    ccui.Helper:doLayout(self.ScrollView_1)
end 

function UISoldierSourcePanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_SOURCE_SINGEBUY,function()
        if self.checkDiamondEnough then
            self:checkDiamondEnough(self.singleCost)
        end
    end)

    -- 固定恢复兵源
    self:addEventListener(global.gameEvent.EV_ON_SOLDIER_GET,function()
        if self.setData then
            self:setData(self.data)
        end
    end)

    -- 当前兵源刷新
    self:addEventListener(global.gameEvent.EV_ON_UI_USER_UPDATE,function()
        if self.setData then
            self:setData(self.data)
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,function(event, isLogic)
        if self.checkDiamondEnough then
            self:checkDiamondEnough(self.singleCost)
        end
    end)

  
    local reFreshAd = function () 

        if global.advertisementData:isPsLock(9) then 
            self.FileNode_2:setVisible(false)
        else 
            self.FileNode_2:setData(9)
            self.FileNode_2:setVisible(true)
        end 
        self:adjustps()
        
    end 

    self:addEventListener(global.gameEvent.EV_ON_UI_ADUPDATE, function ()
        reFreshAd()
    end)

    reFreshAd()

end

function UISoldierSourcePanel:setData(data)
    
    self.data = data
    self.nowSource = userData:getUsefulPopulation()
    self.maxSource = self:getMaxBuySource()
    self.now_num:setString(self.nowSource)
    self.total_num:setString(self.maxSource)
    self.LoadingBar:setPercent(self.nowSource/self.maxSource*100)

    local perBuy = global.luaCfg:get_config_by(1).perBuy
    self.singleBuySource = self.maxSource*perBuy/100

    self:setBuffAdd()
    self:setNextRecoverTime()
      
    local buyTimes = global.refershData:getBuyCount()
    local singleCost = self:getDiamondCost(buyTimes)
    self.singleCost = singleCost
    self:checkDiamondEnough(singleCost)
    global.colorUtils.turnGray(self.gray_spite,buyTimes <= 0)
  
end


local ps ={
    ad = gdisplay.height-184 ,  
    default = gdisplay.height - 79, 
} 

function UISoldierSourcePanel:adjustps()

    if self.FileNode_2:isVisible() then 
        self.ScrollView_1:setPositionY(ps.ad)

    else 
        self.ScrollView_1:setPositionY(ps.default)
    end

    self:adapt()
end 

function UISoldierSourcePanel:setBuffAdd()
    -- body
    global.gmApi:effectBuffer({{lType = 10,lBind = 4}},function(msg)
        
        local allAddNum, allAddPer = 0, 0
        local paraNum = 0 
        if self.getMaxBuySource then 
            paraNum = self:getMaxBuySource()
        end        
        for _,v in ipairs(msg.tgEffect[1].tgEffect or {}) do
            
            if v.lEffectID == 3044 then
                allAddNum = allAddNum + v.lVal
            elseif v.lEffectID == 3095 then
                allAddPer = allAddPer + v.lVal
            end
        end
        if self.maxSource then 
            local allTotal = math.floor(self.maxSource*allAddPer/100) + allAddNum
            if allTotal > 0 then
                local maxSource = self.maxSource+allTotal
                self.total_num:setString(maxSource)
                self.LoadingBar:setPercent(self.nowSource/maxSource*100)
                local perBuy = global.luaCfg:get_config_by(1).perBuy
                self.singleBuySource = maxSource*perBuy/100
                gevent:call(global.gameEvent.EV_ON_SOURCE_SINGEBUY)
            end
        end 
    end) 
end

-- 兵源恢复倒计时
function UISoldierSourcePanel:setNextRecoverTime()
    
    self.lEndTime = global.dailyTaskData:getTimestamp().lDailyPopTime
    self:cutTime()
end

function UISoldierSourcePanel:cutTime()

    if not self.m_countDownTimer then
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
    self:countDownHandler()
end

function UISoldierSourcePanel:countDownHandler(dt)
    if self.lEndTime <= 0 then
        self.next_time:setString("00:00:00")
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
    self.next_time:setString(global.funcGame.formatTimeToHMS(rest))
end

function UISoldierSourcePanel:getMaxBuySource()

    local id = self.data.id
    local currentLv = self.data.serverData.lGrade
    local buildInfoData = luaCfg:buildings_lvup()
    for k,v in pairs(buildInfoData) do
        if v.buildingId == id and v.level ==  currentLv then
            return v.severPara1
        end 
    end
end

function UISoldierSourcePanel:info_btn(sender, eventType)

    local data = luaCfg:get_introduction_by(4)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end

function UISoldierSourcePanel:btn_exit(sender, eventType)
   global.panelMgr:closePanelForBtn("UISoldierSourcePanel")
end

function UISoldierSourcePanel:onExit()
    
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

function UISoldierSourcePanel:useItemHandler(sender, eventType)
    local panel = global.panelMgr:openPanel("UISpeedPanel")   --兵源道具使用
    panel:setData(nil,nil,panel.TYPE_SOLDIER_SOURCE, nil)
end

function UISoldierSourcePanel:useDiamondHandler(sender, eventType)

    if not self:checkDiamondEnough(self.singleCost) then
        global.panelMgr:openPanel("UIRechargePanel")
        return
    else
        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setRichData({self.singleCost, self.singleBuySource})
        panel:setData("50223", function()

            global.itemApi:diamondUse(function(msg)
                if msg.tgBuyCount then 
                    global.refershData:setBuyCount(msg.tgBuyCount.lPopCount) 
                end
                global.tipsMgr:showWarning(string.format(luaCfg:get_local_string(10117), self.singleCost, self.singleBuySource))

            end, 6)
        end)
    end
end

function UISoldierSourcePanel:checkDiamondEnough(num)

    self.diamond:setString(num)
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,num) then
        self.diamond:setTextColor(gdisplay.COLOR_RED)
        return false
    else
        self.diamond:setTextColor(cc.c3b(255, 184, 34))
        return true
    end
end

function UISoldierSourcePanel:getDiamondCost(buyTimes)
    
    local powerData = luaCfg:get_buildings_manpower_by(self.data.serverData.lGrade)
    return powerData["costNum"..buyTimes] or powerData["costNum"..powerData.maxNum]
end

--CALLBACKS_FUNCS_END

return UISoldierSourcePanel

--endregion
