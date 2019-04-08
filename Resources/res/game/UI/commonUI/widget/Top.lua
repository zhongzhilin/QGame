--region Top.lua
--Author : wuwx
--Date   : 2016/09/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local ResSet = require("game.UI.commonUI.widget.ResSet")
local citybuffbutton = require("game.UI.commonUI.widget.citybuffbutton")
local UIEnterEffect = require("game.UI.advertisementItem.UIEnterEffect")
local UIRestTips = require("game.UI.commonUI.widget.UIRestTips")
local UIVipTips = require("game.UI.commonUI.widget.UIVipTips")
local UIWildTips = require("game.UI.commonUI.widget.UIWildTips")
--REQUIRE_CLASS_END

local TextScrollControl = require("game.UI.common.UITextScrollControl")

local Top  = class("Top", function() return gdisplay.newWidget() end )

function Top:ctor()
    
end

function Top:CreateUI()
    local root = resMgr:createWidget("common/mainui_top_bg")
    self:initUI(root)
end

local setting_fps = cc.UserDefault:getInstance():getBoolForKey("setting_fps",false)
function Top:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/mainui_top_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.portrait_btn = self.root.portrait_bg.portrait_btn_export
    self.NodeHead = self.root.portrait_bg.portrait_btn_export.NodeHead_export
    self.LoadingBar_exp = self.root.portrait_bg.LoadingBar_exp_export
    self.LoadingBar_hp = self.root.portrait_bg.LoadingBar_hp_export
    self.txt_lv = self.root.Sprite_18.txt_lv_export
    self.user_vip_node = self.root.user_vip_node_export
    self.user_vip_level_text = self.root.user_vip_node_export.user_vip_level_text_export
    self.user_vip_level_gary_text = self.root.user_vip_node_export.user_vip_level_gary_text_export
    self.txt_power = self.root.combatBtn.txt_power_export
    self.FileNode_1 = ResSet.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)
    self.citybuffnode = self.root.citybuffnode_export
    self.citybuffnode = citybuffbutton.new()
    uiMgr:configNestClass(self.citybuffnode, self.root.citybuffnode_export)
    self.leisure_btn = self.root.leisure_btn_export
    self.leisurePoint = self.root.leisure_btn_export.leisurePoint_export
    self.leisureNum = self.root.leisure_btn_export.leisurePoint_export.leisureNum_export
    self.ad_bt = self.root.ad_bt_export
    self.ad_enter = self.root.ad_bt_export.ad_enter_export
    self.ad_enter = UIEnterEffect.new()
    uiMgr:configNestClass(self.ad_enter, self.root.ad_bt_export.ad_enter_export)
    self.FileNode_3 = self.root.FileNode_3_export
    self.FileNode_3 = UIRestTips.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.FileNode_3_export)
    self.btn_acc_recharge = self.root.btn_acc_recharge_export
    self.acc_recharge = self.root.btn_acc_recharge_export.acc_recharge_export
    self.vip_tips = self.root.vip_tips_export
    self.vip_tips = UIVipTips.new()
    uiMgr:configNestClass(self.vip_tips, self.root.vip_tips_export)
    self.wild_tips = self.root.wild_tips_export
    self.wild_tips = UIWildTips.new()
    uiMgr:configNestClass(self.wild_tips, self.root.wild_tips_export)
    self.fund_red_point = self.root.fund_red_point_export
    self.lord_red_point = self.root.lord_red_point_export

    uiMgr:addWidgetTouchHandler(self.portrait_btn, function(sender, eventType) self:lordDetail_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.user_vip_node, function(sender, eventType) self:bt_vip_information(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.combatBtn, function(sender, eventType) self:combat_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.leisure_btn, function(sender, eventType) self:leisuerHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.ad_bt, function(sender, eventType) self:click_activity_event(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_acc_recharge, function(sender, eventType) self:onOpenAccRecharge(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_1.pandectBtn, function(sender, eventType) self:pandectHandler(sender, eventType) end)
--EXPORT_NODE_END
    self:initEventListener()

    self.run_power_node = cc.Node:create()
    self:addChild(self.run_power_node)

    self.prePower = 0
    self.lastLv = userData:getLevel()
    self.lastExp = userData:getCurExp()


    local widget = gdisplay.newWidget()
    if not tolua.isnull(widget) then
        global.panelMgr:addWidgetToSuper(widget)
        self.touchEventListener = cc.EventListenerTouchOneByOne:create()
        self.touchEventListener:setSwallowTouches(false)
        self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
        self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
        self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, widget)
    end
    
    setting_fps = cc.UserDefault:getInstance():getBoolForKey("setting_fps",false)
    self.m_fps = 1/30
    if not setting_fps then 
        self.m_fps = 1/60
    end
    cc.Director:getInstance():setAnimationInterval(self.m_fps)

    local nodeTimeLine =resMgr:createTimeline("effect/huodong_icon3")
    nodeTimeLine:setTimeSpeed(1)
    self.acc_recharge:runAction(nodeTimeLine)
    nodeTimeLine:play("animation0",true)

    self.m_accData = global.ActivityData:getCurrentActivityData(1,9001)

    self.fund_red_point:setLocalZOrder(self.FileNode_1:getLocalZOrder() + 1)
end

local beganPos = cc.p(0,0)
local ALLOW_MOVE_ERROR = 7.0/160.0
function Top:onTouchBegan(touch, event)

    beganPos = touch:getLocation()

    return true
end

local director = cc.Director:getInstance()
function Top:onTouchMoved(touch, event)
    if not setting_fps then return end
    if self.m_fps and self.m_fps > 1/40 then
        self.m_fps = 1/60
        director:setAnimationInterval(self.m_fps)
    end
end

function Top:onTouchEnded(touch, event)
    if not setting_fps then return end
    if self.m_fps and self.m_fps > 1/40 then
    else
        
        if tolua.isnull(self) then 
             -- protect
            return 
        end 

        self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
            self.m_fps = 1/30
            director:setAnimationInterval(self.m_fps)
        end)))
    end
end

function Top:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function Top:initEventListener()
    
    local callBB = function()
        -- body
        if self.UpdateVipUI then 
            self:UpdateVipUI()
        end 

        if self.updataItem then 
            self:updataItem()
        end 

        if self.lordRedPoint then 
            self:lordRedPoint()
        end 
    end

    local callBB1 = function() 
        if self.lordRedPoint then 
            self:lordRedPoint()
        end 
    end

    self:addEventListener(global.gameEvent.EV_ON_UI_USER_UPDATE,callBB)
    self:addEventListener(global.gameEvent.EV_ON_QUESTIONNAIRE,callBB1)

    local callBB2 = function()
        -- body
        if self.UpdateVipUI then 
            self:UpdateVipUI()
        end 
    end
    self:addEventListener(global.gameEvent.EV_ON_DAILY_GIFT,callBB2)

    local playEvent = function( event, cityNode, data, isBuildCity)
        -- body

        if self.updateLvAndExp then
            self:updateLvAndExp()
        end

        if self.PlayEffect then
            self:PlayEffect(cityNode, data, isBuildCity)
        end

    end
    self:addEventListener(global.gameEvent.EV_ON_UI_EFFECT_PLAY,playEvent)


    local playEvent = function( event,guide_id )
        -- body
        CCHgame:AdTorialCompletion(1,guide_id or "")
    end
    self:addEventListener(global.gameEvent.EV_ON_GUIDE_MAIN_END,playEvent)
end

function Top:onEnterTransitionFinish()
    if global.headData:isSdefineHead() then
        if not cc.FileUtils:getInstance():isFileExist(global.headData:getPortraitPath()) then
            local md5 = global.headData:getSdefineHead()        
            local data = {md5}
            local storagePath = global.headData:downloadPngzips(data)
            table.insertTo(self.m_eventListenerCustomList,global.headData:addDownLoadCall(self.root,storagePath,function()
                -- body
                global.headData:setSdefineHead(md5)
            end))
        end
    end
end

function Top:onEnter()

    -- self.FileNode_2:setVisible(global.scMgr:isWorldScene())
    
    if global.scMgr:isWorldScene() == false then 
        self.leisure_btn:setPositionY(-382.54)
    else 
        self.leisure_btn:setPositionY(-409)
    end 

    global.EasyDev:setRondomShowTips()

    self:addEventListener(global.gameEvent.EV_ON_USER_FLUSHUSEMSG, function ()
        self:changeHeadIcon()
    end) 

    self:addEventListener(global.gameEvent.EV_ON_CITY_BUFF_UPDATE, function ()
        if self.checkUsedBuff then 
            self:checkUsedBuff()
        end 
    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_HP_UPDATE, function ()
        self:strengthLoad()
    end)


    self:addEventListener(global.gameEvent.EV_ON_UI_ADUPDATE, function ()
        if self.UpdateActivityUI then 
            self:UpdateActivityUI()
        end

        self:checkADRedPoint()
    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_ADSOLDOUT, function ()
         if self.UpdateActivityUI then 
            self:UpdateActivityUI()
        end 
    end)


    -- 空闲监听列表
    local eventList = global.leisureData:getEventList()
    for _,v in pairs(eventList) do
        self:addEventListener(global.gameEvent[v], function ()
            if self.updateLeisure then
                self:updateLeisure()
            end
        end)
    end

    local function onResume() --更新活动数据  

        global.ActivityData:updaeAllActivityData()
        -- 切入后台，刷新boss关卡数据
        global.bossData:resumeGate()
        --检查广告数据是否需要更新。 
        -- global.advertisementData:CheckADUpdate()
    end
    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME,onResume)
    self:checkUsedBuff()
    self:UpdateVipUI()
    self:UpdateActivityUI()
    --  成就红点
    global.achieveData:isFinishAchieve()


    if not self.timer then 
        self.timer = gscheduler.scheduleGlobal(handler(self,self.updataOverTimeUI), 1)
    end 
    self.btn_acc_recharge:setVisible(false)
    local data,maxFinishIdx = self:getPointData()
    self.m_accMaxFiniIdx = maxFinishIdx
    self:updataOverTimeUI()


    global.userData:sendIosToken()

    self:fundRed()

    self:addEventListener(global.gameEvent.BANKUPDATE , function () 
        self:fundRed()
    end)

    self:addEventListener(global.gameEvent.EV_ON_DAILY_GIFT , function () 
        self:fundRed()
    end)

    self:addEventListener(global.gameEvent.EV_ON_UPGRADE_CITY,function(event , id) 
        if id == 1 then 
            global.itemApi:updateBankDate()
        end

        global.advertisementData:checkLock(id)
    end)

    self:addEventListener(global.gameEvent.EV_ON_SEVENDAYRECHARGE , function () 
        self:fundRed()
    end)


    self:addEventListener(global.gameEvent.EV_ON_UI_RECHARGE , function () 
        self:fundRed()
    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_RED_TURNTABLE_HERO_FREE_TIMES , function () 
        self:fundRed()
    end)
    
    self:addEventListener(global.gameEvent.EV_ON_PANEL_CLOSE,function()
        if not  table.hasval(global.EasyDev.RECHARGE_PANEL , global.panelMgr:getTopPanelName()) then 
            global.UIRechargeListOffset = nil
        end  
    end)

   
    self:addEventListener(global.gameEvent.EV_ON_UI_HERO_FLUSH,function()
        self:lordRedPoint()
    end) 


    self:addEventListener(global.gameEvent.EV_ON_LOGIC_NOTIFY_RED_POINT,function()
        self:lordRedPoint()
    end)


    self:lordRedPoint()

    self:checkADRedPoint()

    self:addEventListener(global.gameEvent.EV_ON_UNION_ADREDPOINT ,function ()
        self:checkADRedPoint()
    end )


    print("locaTime" ,global.dataMgr:getServerTime())


    self.m_eventListenerCustomList = {}


    if _NO_RECHARGE then 
        self.ad_bt:setPositionX(1000000)
    end 
end


function Top:checkADRedPoint()
    

    local key = tostring(global.userData:getUserId()).."ADLastTime"

    local lastTime = cc.UserDefault:getInstance():getStringForKey(key)

    local red = false 

    if lastTime and lastTime~="" then 

        if (global.EasyDev:getADIntervalTime()-86400) < tonumber(lastTime) and  (global.EasyDev:getADIntervalTime() > tonumber(lastTime)) then 

            red = false 
        else 
            
            red = true 
        end  
    else 
        red = true 
    end 
    self.ad_enter.point_red:setVisible(red)
end 


function Top:lordRedPoint()

    self.lord_red_point:setVisible(false)

    local hero = global.userData:getLordHero()
    local equips = global.equipData:getHeroEquips(hero.heroId) -- 得到英雄已经穿戴的装备
    for i,v in ipairs(equips) do
        if v ~= -1 then --已经穿上去了
        else            
            local state =global.equipData:getHeroEquipState(hero,i)
            if state == 2 then
                self.lord_red_point:setVisible(true)
            end
        end
    end 

    if global.userData:getHeadFrameRed() > 0 then --头像边框接入红点

        self.lord_red_point:setVisible(true)
    end 

    local totalTimes = luaCfg:get_investigation_by(1).totalTimes
    local curTimes = global.refershData:getlAnswerCount()
    if curTimes<totalTimes and not global.refershData:isQuestionToday() then
        self.lord_red_point:setVisible(true)
    end

end 

function Top:fundRed()


    self.fund_red_point:setVisible(false)

    if global.scMgr:isWorldScene() then 

        return 
    end 

    for _ , v in ipairs(global.luaCfg:fund()) do 
       if  global.propData:getFundState(v.ID) == 1  then 
            self.fund_red_point:setVisible(true)
        end 
    end 

    if global.propData:curBankCanGet() then
        self.fund_red_point:setVisible(true)
    end


    if global.rechargeData:isSevenDayRed() then 

        self.fund_red_point:setVisible(true)
        
    end 


    if global.rechargeData:isMonthGet() then 

         self.fund_red_point:setVisible(true)
    end 

    if global.userData:getFreeLotteryCount() <= 0 then 
         self.fund_red_point:setVisible(true)
    end 

    -- if global.userData:getDyFreeLotteryCount() <= 0 then 
    --      self.fund_red_point:setVisible(true)
    -- end 

    if global.userData:getlDailyGiftCount() > 0 then 
        self.fund_red_point:setVisible(true)
    end 
end 

-- 空闲红点
function Top:updateLeisure()

    local leiNum = global.leisureData:getLeisureNum()
    if self.leisurePoint then
        if leiNum > 0 then
            self.leisurePoint:setVisible(true)
            self.leisureNum:setString(leiNum)
        else
            self.leisurePoint:setVisible(false)
        end
    end
end

-- 0：准备中，1：进行中，2：结束
local lastState = 2
-- ui界面计时器回掉
function Top:updataOverTimeUI()

    if not self.acc_recharge or tolua.isnull(self.acc_recharge) then 
    else
        local rest = 0
        local isInReadyState = false
        if not self.m_accData or not self.m_accData.serverdata then
            -- 活动结束 数据拿不到之后的处理
            lastState = 2
        else
            -- 活动数据还能拿到的处理
            local curr = global.dataMgr:getServerTime()
            if curr-self.m_accData.serverdata.lBngTime <= 0 then
                -- 活动还没开启
                if self.btn_acc_recharge:isVisible() then
                    self.btn_acc_recharge:setVisible(false)
                end
                lastState = 0
                -- return
            else
                rest = self.m_accData.serverdata.lEndTime-curr
                if rest <= 0 then
                    rest = 0
                    if lastState and lastState == 1 then
                        local data,maxFinishIdx = self:getPointData()
                        self.m_accMaxFiniIdx = maxFinishIdx
                    end
                    lastState = 2
                else
                    if lastState and lastState == 0 then
                        global.userData:resetSumPay()
                        local data,maxFinishIdx = self:getPointData()
                        self.m_accMaxFiniIdx = maxFinishIdx
                    end
                    lastState = 1
                end
                self.acc_recharge.time:setString(global.funcGame.formatTimeToHMS(rest))
            end
        end

        local payData = global.userData:getSumPay()
        -- dump(payData)
        -- print("----->"..self.m_accMaxFiniIdx)
        if rest <= 0 and payData and self.m_accMaxFiniIdx and #payData.lPickUp >= self.m_accMaxFiniIdx then
            -- 累计充值完成，并且领完了
            if self.btn_acc_recharge:isVisible() then
                self.btn_acc_recharge:setVisible(false)
            end
        else
            if not self.btn_acc_recharge:isVisible() and not global.scMgr:isWorldScene() then
                self.btn_acc_recharge:setVisible(true)
            end
            if self.m_accData and self.m_accData.serverdata and rest > 0 then
            else
                -- 活动结束，还有可领取的奖励时
                self.acc_recharge.time:setString(global.luaCfg:get_local_string(10488))
            end
        end
        
    end
end

function Top:getPointData()
    local points = global.luaCfg:point_reward()
    local payData = global.userData:getSumPay()
    local data = {}
    for i,v in pairs(points) do
        if v.activity_id == 9001 then
            table.insert(data,v)
        end
    end
    table.sort(data,function(a,b)
        -- body
        return a.point < b.point
    end)

    local finishIdx = 0
    for i,v in pairs(data) do
        if v.point < payData.lGet and finishIdx < i then
            finishIdx = i
        end
    end
    return data,finishIdx
end

function Top:UpdateActivityUI()
    global.colorUtils.turnGray(self.ad_enter,not global.advertisementData:isHaveAvailableAD())
    self.ad_enter:Action(global.advertisementData:isHaveAvailableAD())
    local time = global.advertisementData:getAdOverTime()
    if time and  time - global.dataMgr:getServerTime() < 0 then 
        -- self.root.activity_bt:setEnabled(false)
        -- self.root.activity_bt:setVisible(false)
    else    
        self.ad_bt:setEnabled(true)
        self.ad_enter:setData({lEndTime = time})
    end
end 


function Top:initVipPanel()
    local  UIvipPanel = global.panelMgr:getPanel("UIvipPanel")
    UIvipPanel:setData()
end 

function Top:UpdateVipUI()
    self.user_vip_level_text:setString(global.vipBuffEffectData:getVipLevel())
    self.user_vip_level_gary_text:setString(global.vipBuffEffectData:getVipLevel())
    if not global.vipBuffEffectData:isVipEffective() then  
            self.user_vip_level_text:setVisible(false)
            self.user_vip_level_gary_text:setVisible(true)
            global.colorUtils.turnGray(self.user_vip_node,true)
    else 
        self.user_vip_level_text:setVisible(true)
        self.user_vip_level_gary_text:setVisible(false)
        global.colorUtils.turnGray(self.user_vip_node,false)
    end  
end 
function Top:checkUsedBuff()  

    local  allbuffs = global.buffData:getBuffs()
    dump(allbuffs,"allbuffs")  
    local  citybuff = luaCfg:citybuff()
    local  flag = false
    for _ ,v in pairs(allbuffs) do
        for i=1 ,#citybuff do
            if v.lID and  citybuff[i].datatype == v.lID and v.lEndTime  and (v.lEndTime > global.dataMgr:getServerTime()) then -- 设置为一秒 防止出现误差
                flag = true 
                break 
            end 
        end 
        if flag then break end 
    end

    if global.userData:inNewProtect() then 

        local m_cityId = global.userData:getWorldCityID()
        
        if m_cityId ~= 0 then

            flag = true 
        end

    end 
    if not flag then 
        self.citybuffnode:setGray(true)
        self.citybuffnode:showEffect(false)
    else
        self.citybuffnode:setGray(false)
        self.citybuffnode:showEffect(true)
    end 
end 



function Top:setBuffIconStatus(status)
     self.citybuffnode:setGray(status)
end

function Top:changeHeadIcon()

    -- 领主头像
    local head = global.headData:getCurHead()
    global.tools:setCircleAvatar(self.NodeHead, head)
end


function Top:onExit()
     self:checkUsedBuff()

    if self.timer then
        gscheduler.unscheduleGlobal(self.timer)
        self.timer = nil
    end

    if self.m_eventListenerCustomList then
        for i,v in pairs(self.m_eventListenerCustomList) do
            cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
        end
    end
end 

function Top:setData()
    -- body
    -- local curExp = userData:getCurExp()
    -- local maxExp = userData:getMaxExp()
    -- self.LoadingBar_exp:setPercent(curExp/maxExp*100)

    self.txt_lv:setString(userData:getLevel())
    self:changeHeadIcon()

    self:updataItem(true)
    self:ExpEffect()

    self.FileNode_1:setVisible(global.scMgr:isWorldScene() == false)
    self.citybuffnode:setVisible(global.scMgr:isWorldScene() == false)
    self.FileNode_1:setFirstScroll(true)
    self.FileNode_1:setData()

    self.FileNode_3:setVisible(global.scMgr:isWorldScene() == false)

    self.ad_bt:setVisible(global.scMgr:isWorldScene() == false)


end

function Top:updataItem(noAction)
    -- body
    
    if self.prePower == 0 then

        self.prePower = userData:getPower()
        self.txt_power:setString(self.prePower) 

    else
        if noAction then 
            self.txt_power:setString(userData:getPower()) 
        else 
            TextScrollControl.startScroll(self.txt_power,userData:getPower(),1.3)
        end 
    end

    self:updateLvAndExp()
    self:strengthLoad()
end

function Top:strengthLoad()
    
    local lastPer = self.LoadingBar_hp:getPercent()
    local curHp = userData:getCurHp()
    local maxHp = userData:getMaxHp()
    if curHp > maxHp then curHp = maxHp end

    local curPer = curHp/maxHp*100
    local time = math.abs(lastPer-curPer)/100 
    if time == 0 then
        self.LoadingBar_hp:setPercent(curHp/maxHp*100)
    else
        self.LoadingBar_hp:runAction(cc.ProgressFromTo:create(time, lastPer, curPer))
    end
    
end

function Top:ExpEffect()
    
    local lastPer = self.LoadingBar_exp:getPercent()
    local curExp = userData:getCurExp()
    local maxExp = userData:getMaxExp()
    if curExp > maxExp then curExp = maxExp end

    local curPer = curExp/maxExp*100
    local time = math.abs(lastPer-curPer)/100 
    if time == 0 then
        self.LoadingBar_exp:setPercent(curExp/maxExp*100)
    else
        self.LoadingBar_exp:runAction(cc.ProgressFromTo:create(time, lastPer, curPer))
    end
    
end


function Top:updateLvAndExp()
    
    local curExp = userData:getCurExp()
    local maxExp = userData:getMaxExp()
    local curLv = userData:getLevel()     

    if self.lastExp ~= curExp or curLv ~= self.lastLv then

        local isInRoot = global.panelMgr:isRootPanel()

        --if not isInRoot then
            if userData:getLevel() ~= self.lastLv and (not global.isLordOpen) then
                local loadLvUpPanel = global.panelMgr:openPanel("UILordLvUpPanel")
                loadLvUpPanel:setData()
                global.isLordOpen = true
            end                        
        --end

        --　领主升级界面
        -- if isInRoot then
        --     local loadLvUpPanel = global.panelMgr:openPanel("UILordLvUpPanel")
        --     loadLvUpPanel:setData()
        -- end

        self:stopAllActions()
        self:runAction(cc.Sequence:create(cc.DelayTime:create(2), cc.CallFunc:create(function ()

            local nodeTimeLine = resMgr:createTimeline("common/mainui_top_bg")
            nodeTimeLine:setTimeSpeed(0.5)
            nodeTimeLine:play("animation0", false)
            self:runAction(nodeTimeLine)

        end), cc.DelayTime:create(5/6), cc.CallFunc:create(function ()
         
            local curExp = userData:getCurExp()
            local maxExp = userData:getMaxExp()
            if userData:getLevel() == self.lastLv then

                self.LoadingBar_exp:runAction(cc.ProgressFromTo:create(0.5,self.LoadingBar_exp:getPercent(),(curExp/maxExp)*100))
            else
                self:runAction(cc.Sequence:create( cc.CallFunc:create(function ()
                    self.LoadingBar_exp:runAction(cc.ProgressFromTo:create(0.5,self.LoadingBar_exp:getPercent(),100))
                end), cc.DelayTime:create(0.5),  cc.CallFunc:create(function ()
                    self.LoadingBar_exp:runAction(cc.ProgressFromTo:create(0.5,0,(curExp/maxExp)*100))
                end) ))

                local nodeTimeLine1 = resMgr:createTimeline("common/mainui_top_bg")
                nodeTimeLine1:setTimeSpeed(0.5)
                nodeTimeLine1:play("animation1", false)
                nodeTimeLine1:setLastFrameCallFunc(function()                    
                end)
                self:runAction(nodeTimeLine1)

                self.lastLv = userData:getLevel()
                global.isLordOpen = nil
                -- 领主升级，更新占领野地上限
                global.resData:updateOccupy()

            end

            self.txt_lv:setString(userData:getLevel())

        end) ,  cc.CallFunc:create(function ()
             self.lastExp = curExp
        end) ))
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function Top:PlayEffect( cityNode, data, isBuildCity )
    if data == nil then  return end
    if tolua.isnull(cityNode) then 
        -- protect
        return 
    end 

    local building_ui_data = luaCfg:get_buildings_ui_by(global.cityData:getBuildingType(data.buildingType))
    local infoId = global.cityData:getBuildingsInfoId(data.buildingType,data.serverData.lGrade)         
    local building_info = luaCfg:get_buildings_info_by(infoId)

    local updateActionUp = resMgr:createCsbAction("effect/upgrade_effect","animation0",false,true)
    updateActionUp:setPosition(cc.p(building_ui_data.effect_posX,building_ui_data.effect_posY))
    updateActionUp:setScale(building_ui_data.effect_scale / 100)
    cityNode:addChild(updateActionUp,998)

    local updateActionDown = resMgr:createCsbAction("effect/upgrade_effect_fazheng","animation0",false,true)
    updateActionDown:setPosition(cc.p(building_ui_data.effect_posX,building_ui_data.effect_posY))
    updateActionDown:setScale(building_ui_data.effect_scale / 100)
    cityNode:addChild(updateActionDown,997)

    -- 战斗力显示
    local nextBuildLv = global.cityData:getBuildingById(data.id).serverData.lGrade 
    nextBuildLv = isBuildCity and nextBuildLv or nextBuildLv + 1
    self.root:runAction(cc.Sequence:create( cc.DelayTime:create(0.5), cc.CallFunc:create(function ()
        global.panelMgr:openPanel("UIUpPowerPanel"):setData(data.id, nextBuildLv)
    end)))
    
    -- local addAction = resMgr:createCsbAction("effect/upgrade_power_add","animation0",false,true)
    -- addAction:setPosition(cc.p(building_ui_data.effect_posX + cityNode:getPositionX(),building_ui_data.effect_posY + cityNode:getPositionY()))            
    -- global.g_cityView:getScrollViewLayer("effect"):addChild(addAction, 997)

    -- uiMgr:configUITree(addAction)    
    -- addAction.Text_1:setString(global.luaCfg:get_local_string(10026,""))        
    -- addAction.Text_Combat:setString("+" .. building_info.combatUp)
    -- global.tools:adjustNodePos(addAction.Text_1, addAction.Text_Combat)

    local speed = 0.65
    cityNode:runAction(cc.Sequence:create(cc.DelayTime:create(1.3),cc.CallFunc:create(function()


        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_fcup_1")
        local flystar = resMgr:createWidget("effect/upgrade_effect_flystar")
        flystar:setPosition(cityNode:convertToWorldSpace(cc.p(0,0)))
        flystar:runAction(cc.Sequence:create(cc.MoveTo:create(speed,cc.p(gdisplay.width / 2,gdisplay.height - 50)),cc.RemoveSelf:create()))            
        uiMgr:configUITree(flystar)           
        flystar.Particle_1:setPositionType(cc.POSITION_TYPE_FREE)
        -- global.scMgr:CurScene():addChild(flystar, 31)
        global.panelMgr:addWidgetToPanelDown(flystar)

        if self.lastExp ~= userData:getCurExp() then 
            local flystar2 = resMgr:createWidget("effect/upgrade_effect_exp")
            flystar2:setPosition(cityNode:convertToWorldSpace(cc.p(0,0)))
            flystar2:runAction(cc.Sequence:create(cc.MoveTo:create(speed,cc.p(45,gdisplay.height - 135)),cc.RemoveSelf:create()))            
            uiMgr:configUITree(flystar2)     
            flystar2.Particle_1:setPositionType(cc.POSITION_TYPE_FREE)
            -- global.scMgr:CurScene():addChild(flystar2, 31)
            global.panelMgr:addWidgetToPanelDown(flystar2)
        end
    end),cc.DelayTime:create(speed),cc.CallFunc:create(function()
            local upfire = resMgr:createCsbAction("effect/upgrade_effect_upfire","animation0",false,true)
            upfire:setPosition(cc.p(358,-50))
            self.root:addChild(upfire, 31)
    end)))

end


function Top:lordDetail_click(sender, eventType)

    local loadPanel = global.panelMgr:openPanel("UILordPanel")
    loadPanel:setData()
end

function Top:onSecondCityHandler(sender, eventType)
    local secCityLv = luaCfg:get_config_by(1).secCityLv
    local localStr = ""
    if global.userData:checkLevel(secCityLv) then
        localStr = luaCfg:get_local_string(10035)
    else
        localStr = "FuncNotFinish" --luaCfg:get_local_string(10032,secCityLv)
    end
    global.tipsMgr:showWarning(localStr)
end

function Top:combat_click(sender, eventType)

    local checkTrigger = function ()
        -- body
        local buildData = luaCfg:get_buildings_pos_by(29)
        if global.cityData:checkTrigger(buildData.triggerId[1]) then
            return true
        else
            local triggerData = luaCfg:get_triggers_id_by(buildData.triggerId[1])
            local triggerBuilding = luaCfg:get_buildings_pos_by(triggerData.buildsId)
            local str = luaCfg:get_local_string(10043,triggerBuilding.buildsName,triggerData.triggerCondition,buildData.buildsName)
            global.tipsMgr:showWarning(str)
            return false
        end
    end

    if not checkTrigger() then
        return
    end    
    
    global.itemApi:combatRank(function(msg)

        local combatPanel = global.panelMgr:openPanel("UICombatPowerPanel")
        combatPanel:setData(msg.tgRank)
    end)

end
 

function Top:bt_vip_information(sender, eventType)
    local panel = global.panelMgr:openPanel("UIvipPanel")
end


function Top:click_activity_event(sender, eventType)
    
    if not  global.advertisementData:isHaveAvailableAD()then 
        global.tipsMgr:showWarning("gift_sold_out")
    else  
        -- local panel =   global.panelMgr:openPanel("UIADGiftPanel")
        -- panel.back_bt:setVisible(true)
        -- panel:setData()
        global.panelMgr:openPanel("UIActivityPackagePanel")
        global.loginApi:clickPointReport(nil,12,nil,nil)

        local key = tostring(global.userData:getUserId()).."ADLastTime"
        cc.UserDefault:getInstance():setStringForKey(key , tostring(global.dataMgr:getServerTime()))
        gevent:call(global.gameEvent.EV_ON_UNION_ADREDPOINT)

    end 
end

function Top:leisuerHandler(sender, eventType)

    global.panelMgr:openPanel("UILeisurePanel")
end

function Top:onOpenAccRecharge(sender, eventType)
    local panel = global.panelMgr:openPanel("UIAccRechargePanel")
    if not self.m_accData then
        self.m_accData = global.ActivityData:getCurrentActivityData(1,9001)
    end
    panel:setData(self.m_accData)
end

function Top:pandectHandler(sender, eventType)
    global.panelMgr:openPanel("UIPandectPanel"):initData()
end

--CALLBACKS_FUNCS_END

return Top

--endregion
