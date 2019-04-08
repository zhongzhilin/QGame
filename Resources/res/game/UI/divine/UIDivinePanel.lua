--region UIDivinePanel.lua
--Author : yyt
--Date   : 2017/03/06
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIDivineItem = require("game.UI.divine.UIDivineItem")
--REQUIRE_CLASS_END

local UIDivinePanel  = class("UIDivinePanel", function() return gdisplay.newWidget() end )

function UIDivinePanel:ctor()
    self:CreateUI()
end

function UIDivinePanel:CreateUI()
    local root = resMgr:createWidget("citybuff/divine_bg")
    self:initUI(root)
end

function UIDivinePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "citybuff/divine_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.resetDiaBtn = self.root.reset.resetDiaBtn_export
    self.resetDiaNum = self.root.reset.resetDiaBtn_export.resetDiaNum_export
    self.resetFreeBtn = self.root.reset.resetFreeBtn_export
    self.resetTimes = self.root.reset.resetFreeBtn_export.resetTimes_export
    self.divDiaBtn = self.root.divine.divDiaBtn_export
    self.divDiaNum = self.root.divine.divDiaBtn_export.divDiaNum_export
    self.divFreeBtn = self.root.divine.divFreeBtn_export
    self.divTimes = self.root.divine.divFreeBtn_export.divTimes_export
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.ps_node = self.root.ScrollView_1_export.ps_node_export
    self.bg = self.root.ScrollView_1_export.bg_export
    self.effectNode = self.root.ScrollView_1_export.effectNode_export
    self.FileNode_1 = self.root.ScrollView_1_export.effectNode_export.Node1.FileNode_1_export
    self.FileNode_1 = UIDivineItem.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.ScrollView_1_export.effectNode_export.Node1.FileNode_1_export)
    self.Card_1 = self.root.ScrollView_1_export.effectNode_export.Card_1_export
    self.FileNode_6 = self.root.ScrollView_1_export.effectNode_export.Node6.FileNode_6_export
    self.FileNode_6 = UIDivineItem.new()
    uiMgr:configNestClass(self.FileNode_6, self.root.ScrollView_1_export.effectNode_export.Node6.FileNode_6_export)
    self.Card_6 = self.root.ScrollView_1_export.effectNode_export.Card_6_export
    self.FileNode_3 = self.root.ScrollView_1_export.effectNode_export.Node3.FileNode_3_export
    self.FileNode_3 = UIDivineItem.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.ScrollView_1_export.effectNode_export.Node3.FileNode_3_export)
    self.Card_3 = self.root.ScrollView_1_export.effectNode_export.Card_3_export
    self.FileNode_4 = self.root.ScrollView_1_export.effectNode_export.Node4.FileNode_4_export
    self.FileNode_4 = UIDivineItem.new()
    uiMgr:configNestClass(self.FileNode_4, self.root.ScrollView_1_export.effectNode_export.Node4.FileNode_4_export)
    self.Card_4 = self.root.ScrollView_1_export.effectNode_export.Card_4_export
    self.FileNode_5 = self.root.ScrollView_1_export.effectNode_export.Node5.FileNode_5_export
    self.FileNode_5 = UIDivineItem.new()
    uiMgr:configNestClass(self.FileNode_5, self.root.ScrollView_1_export.effectNode_export.Node5.FileNode_5_export)
    self.Card_5 = self.root.ScrollView_1_export.effectNode_export.Card_5_export
    self.FileNode_2 = self.root.ScrollView_1_export.effectNode_export.Node2.FileNode_2_export
    self.FileNode_2 = UIDivineItem.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.ScrollView_1_export.effectNode_export.Node2.FileNode_2_export)
    self.Card_2 = self.root.ScrollView_1_export.effectNode_export.Card_2_export
    self.title = self.root.title_export
    self.zeroTime = self.root.div_bg.reset_mlan_8.zeroTime_export
    self.buffText = self.root.buffText_export
    self.buffName = self.root.buffText_export.buffName_export
    self.buffEff = self.root.buffText_export.buffEff_export
    self.topLayout = self.root.topLayout_export
    self.bottomLayout = self.root.bottomLayout_export

    uiMgr:addWidgetTouchHandler(self.resetDiaBtn, function(sender, eventType) self:resetClick(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.resetFreeBtn, function(sender, eventType) self:resetClick(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.divDiaBtn, function(sender, eventType) self:divineClick(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.divFreeBtn, function(sender, eventType) self:divineClick(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    for i=1,6 do
        self["Card_"..i]:setSwallowTouches(false)
        self["Node"..i] = self.effectNode["Node"..i]
    end

    self:adapt()

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIDivinePanel:adapt()

    local sHeight =gdisplay.height - self.topLayout:getContentSize().height - self.bottomLayout:getContentSize().height
    local defY = self.ScrollView_1:getContentSize().height
    self.ScrollView_1:setContentSize(cc.size(gdisplay.width, sHeight))
    if sHeight < defY then 

    else
        self.ScrollView_1:setTouchEnabled(false)
        self.ScrollView_1:setInnerContainerSize(cc.size(gdisplay.width, sHeight))
        local tt =  self.ScrollView_1:getContentSize().height- self.ps_node:getPositionY()
        for _ ,v in pairs(self.ScrollView_1:getChildren()) do 
            v:setPositionY(v:getPositionY()+tt)
        end 
    end 

end 

function UIDivinePanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIDivinePanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIDivinePanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIDivinePanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIDivinePanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIDivinePanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end


function UIDivinePanel:onEnter()

    self.isPageMove = false
    self:registerMove()
    
    self.nodeTimeLine = resMgr:createTimeline("citybuff/divine_bg")
    self.root:stopAllActions()
    self.root:runAction(self.nodeTimeLine)
    self.ScrollView_1:jumpToTop()

    self.lEndTime = -1
    self:getDivineList(0)

    -- 零点重置 
    self:addEventListener(global.gameEvent.EV_ON_DAILY_REGISTER,function ()
        global.refershData:setFirstDivine(0) 
        self:getDivineList(0)
    end) 

    -- vip 消息更新
    self:addEventListener(global.gameEvent.EV_ON_UI_USER_UPDATE,function()
        self:reFreshNumber()
    end)
end

function UIDivinePanel:reFreshNumber()
    self.divFreeBtn:setVisible(false)
    self.divDiaBtn:setVisible(false)
    local config = luaCfg:get_config_by(1)
    local freeR, freeD = config.divineReset, config.divineCost
    local freeTimes, diamondTimes = global.refershData:getDivTimes()
    -- 占卜
    local vipfreenumber = global.vipBuffEffectData:getVipDiverseFreeNumber("lVipDivCount")
    local divTimes = freeD - freeTimes[2]+vipfreenumber
    if divTimes > 0 then
        self.divTimes:setString(luaCfg:get_local_string(10203, divTimes))
        self.divFreeBtn:setVisible(true)
    else
        self.divDiaBtn:setVisible(true)
        local maxTimes = (#luaCfg:divine_gold())
        if diamondTimes[2] >= maxTimes then diamondTimes[2] = maxTimes-1 end
        local diaCost = luaCfg:get_divine_gold_by(diamondTimes[2]+1)
        if diaCost then
            self.divDiaNum:setString(diaCost.divineCost)
            if not self:checkDiamondEnough(diaCost.divineCost) then
                self.divDiaNum:setTextColor(gdisplay.COLOR_RED)
            else
                self.divDiaNum:setTextColor(cc.c3b(255, 184, 34))
            end
        end
    end
end


function UIDivinePanel:getDivineList( lType,flag)
    
    global.techApi:divineList(lType, function (msg)

        self:setData(msg,lType)
        self:playAnimation(lType, flag)
        global.refershData:setFirstDivine(1) 
    end)
end

-- 翻转其他卡牌
function UIDivinePanel:setOtherCardFix(curDivId)

    for i=1,6 do
        self["Card_"..i]:setVisible(false)
        local item = self["FileNode_"..i]
        if not item:isMine(curDivId) then
           item:setCardSideFix()
        end
    end
end

function UIDivinePanel:playAnimation(lType, flag)

    if not self.data then  --protect 
        return  
    end 

    local nodeTimeLine = self.nodeTimeLine
    if self.data.lState == 0 then      -- 正常状态

        if lType == 2 or (global.refershData:isFirstDiv() == 0) then
            -- 所有卡牌重置
            for i=1,6 do
                local item = self["FileNode_"..i]
                item:setCardSide(true, false, true)
            end
            global.uiMgr:addSceneModel(1.5)
            nodeTimeLine:play("animation0", false)
        else
            nodeTimeLine:gotoFrameAndPause(135)
            for i=1,6 do
                local item = self["FileNode_"..i]
                item:setCardSide(true, false, true)
            end
        end

    elseif self.data.lState == 2 then   -- 正在占卜

        if not flag then
            nodeTimeLine:gotoFrameAndPause(135)
            for i=1,6 do
                local item = self["FileNode_"..i]
                item:setCardSide(false, false)
            end
        end

    else --占卜状态

        nodeTimeLine:gotoFrameAndPause(135)
        for i=1,6 do
            self["Card_"..i]:setVisible(false)
            local item = self["FileNode_"..i]
            if item:isMine(self.data.lState - 10000) then
                item:setCardSide(true, false)
            else
                if global.refershData:getDivingState() == -1 then
                    item:setCardSide(true, false, true)
                else
                    item:setCardSide(false, false)
                end
            end
        end

    end
end

function UIDivinePanel:setData( data ,flag)

    self.data = data
    global.refershData:setDivTimes(data.tgBuyCount,flag)

    -- 设置按钮状态
    self:setBtnState()

    local curDivId = data.lState - 10000
    local divlist = data.tgDivine or {}
    for i=1,6 do
        local item = self["FileNode_"..i]
        if divlist[i] then
            divlist[i].localId = i
            if curDivId == divlist[i].ID then
                item:setData(divlist[i])
            else
                item:setData(divlist[i])
            end
        end
    end

    -- 零点倒计时
    self.lEndTime = data.lEndTime
    if not self.m_countDownTimer then
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
    self:countDownHandler()

    global.refershData:setDivState(data.lState)

    if data.lState > 10000 then
        self.buffText:setVisible(true)
        local divD = luaCfg:get_divine_by(curDivId)
        self.buffName:setString(divD.name)
        self.buffEff:setString(divD.des)
    else
        self.buffText:setVisible(false)
    end

end

function UIDivinePanel:getDivState()
    
    if self.data then 
        return self.data.lState
    end 

    return nil
end

function UIDivinePanel:setBtnState()
    
    self.resetCost = 0
    self.divCost = 0
    self.divFreeBtn:setVisible(false)
    self.divDiaBtn:setVisible(false)
    self.resetFreeBtn:setVisible(false)
    self.resetDiaBtn:setVisible(false)

    local config = luaCfg:get_config_by(1)
    local freeR, freeD = config.divineReset, config.divineCost
    local freeTimes, diamondTimes = global.refershData:getDivTimes()

    -- 重置
    if freeTimes[1] < freeR then
        self.resetTimes:setString(luaCfg:get_local_string(10203, freeR - freeTimes[1]))
        self.resetFreeBtn:setVisible(true)
    else
        self.resetDiaBtn:setVisible(true)
        local maxTimes = (#luaCfg:divine_gold())
        if diamondTimes[1] >= maxTimes then diamondTimes[1] = maxTimes - 1 end
        local diaCost = luaCfg:get_divine_gold_by(diamondTimes[1]+1)
        if diaCost then
            self.resetDiaNum:setString(diaCost.divineReset)
            if not self:checkDiamondEnough(diaCost.divineReset) then
                self.resetDiaNum:setTextColor(gdisplay.COLOR_RED)
            else
                self.resetDiaNum:setTextColor(cc.c3b(255, 184, 34))
            end
            self.resetCost = diaCost.divineReset
        end
    end

    -- 占卜
    local vipfreenumber = global.vipBuffEffectData:getVipDiverseFreeNumber("lVipDivCount")
    local divTimes = freeD - freeTimes[2]+vipfreenumber
    if divTimes > 0 then
        self.divTimes:setString(luaCfg:get_local_string(10203, divTimes))
        self.divFreeBtn:setVisible(true)
    else
        self.divDiaBtn:setVisible(true)
        local maxTimes = (#luaCfg:divine_gold())
        if diamondTimes[2] >= maxTimes then diamondTimes[2] = maxTimes-1 end
        local diaCost = luaCfg:get_divine_gold_by(diamondTimes[2]+1)
        if diaCost then
            self.divDiaNum:setString(diaCost.divineCost)
            if not self:checkDiamondEnough(diaCost.divineCost) then
                self.divDiaNum:setTextColor(gdisplay.COLOR_RED)
            else
                self.divDiaNum:setTextColor(cc.c3b(255, 184, 34))
            end
            self.divCost = diaCost.divineCost
        end
    end

end

function UIDivinePanel:countDownHandler(dt)
    if self.lEndTime <= 0 then
        self.zeroTime:setString("")
        return
    end
    local curr = global.dataMgr:getServerTime()
    local rest = self.lEndTime - curr
    if rest < 0 then
        if self.m_countDownTimer then
            gscheduler.unscheduleGlobal(self.m_countDownTimer)
            self.m_countDownTimer = nil
        end
        global.tipsMgr:showWarning("divine04")
        self:refresh()
        return
    end
    self.zeroTime:setString(global.funcGame.formatTimeToHMS(rest))
end

-- 零点重置
function UIDivinePanel:refresh()
    
    global.refershData:setFirstDivine(0)
    self:getDivineList(0)
end

-- 重置
function UIDivinePanel:resetClick(sender, eventType)

    if not self.data then 
         -- protect 
        return 
    end 
    
    if self.data.lState == 2 then
        global.tipsMgr:showWarning("divine06")
        return
    end 

    if not self:checkDiamondEnough(self.resetCost) then 
        global.panelMgr:openPanel("UIRechargePanel")
        return
    end

    if self.data.lState > 10000 then

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData("divine01", function()
            self:getDivineList(2)
        end)
    else
        self:getDivineList(2)
    end
    
end

-- 占卜
function UIDivinePanel:divineClick(sender, eventType)
    
    if not self.data then 
         -- protect 
        return 
    end 

    if self.data.lState == 2 then
        global.tipsMgr:showWarning("divine06")
        return
    end 

    if not self:checkDiamondEnough(self.divCost) then 
        global.panelMgr:openPanel("UIRechargePanel")
        return
    end

    local divCall = function ()
        
        for i=1,6 do
            self["Card_"..i]:setVisible(true)
        end
        local time = 0
        local nodeTimeLine = resMgr:createTimeline("citybuff/divine_bg")
        if self.data.lState > 10000 then 
            nodeTimeLine:gotoFrameAndPlay(185, 325, false)
            time = 2.5
        else
            nodeTimeLine:play("animation1", false)
            time = 3
        end

        global.uiMgr:addSceneModel(time)
        nodeTimeLine:setLastFrameCallFunc(function()
            for i=1,6 do
                self["Card_"..i]:setVisible(false)
                self["Node"..i]:setScale(1)
                self["Node"..i]:setOpacity(255)
                
                local item = self["FileNode_"..i]
                item:setCardSide(false, false)
            end 
        end)
        self.root:runAction(nodeTimeLine)
        self:getDivineList(1, true)
    end

    if self.data.lState > 10000 then 
        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData("divine02", function()

            divCall()
        end)
    else
        divCall()
    end

end

function UIDivinePanel:checkDiamondEnough(num)
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,num) then
        return false
    else
        return true
    end
end

function UIDivinePanel:onExit()
    
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
    global.panelMgr:closePanel("UIPromptPanel")  
end

function UIDivinePanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIDivinePanel")  
end
--CALLBACKS_FUNCS_END

return UIDivinePanel

--endregion
