--region UIHpPanel.lua
--Author : wuwx
--Date   : 2016/11/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIHpPanel  = class("UIHpPanel", function() return gdisplay.newWidget() end )

local UITableView = require("game.UI.common.UITableView")
local UIHpSoldierCell = require("game.UI.city.panel.widget.UIHpSoldierCell")

function UIHpPanel:ctor()
    self:CreateUI()
end

function UIHpPanel:CreateUI()
    local root = resMgr:createWidget("hospital/hospital_bg")
    self:initUI(root)
end

function UIHpPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hospital/hospital_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.res = self.root.res_export
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.ps_node = self.root.ScrollView_1_export.ps_node_export
    self.no_recruit = self.root.ScrollView_1_export.helper.no_recruit_mlan_18_export
    self.tips1 = self.root.ScrollView_1_export.helper.tips1_export
    self.lost_time = self.root.ScrollView_1_export.helper.tips1_export.lost_time_export
    self.recruit_btn = self.root.ScrollView_1_export.helper.recruit_btn_export
    self.all_recruit_btn = self.root.ScrollView_1_export.helper.all_recruit_btn_export
    self.recruit_panel_tableview = self.root.ScrollView_1_export.helper.recruit_panel_tableview_export
    self.tips2 = self.root.ScrollView_1_export.helper.tips2_export
    self.heal_time = self.root.ScrollView_1_export.helper.tips2_export.heal_time_export
    self.tips3 = self.root.ScrollView_1_export.helper.tips3_mlan_15_export
    self.free_time = self.root.ScrollView_1_export.helper.tips3_mlan_15_export.free_time_export
    self.heal_bg = self.root.ScrollView_1_export.helper.heal_bg_export
    self.no_heal = self.root.ScrollView_1_export.helper.heal_bg_export.no_heal_mlan_18_export
    self.limit_node = self.root.ScrollView_1_export.helper.limit_node_export
    self.curWoundNum = self.root.ScrollView_1_export.helper.limit_node_export.curWoundNum_export
    self.maxWoundNum = self.root.ScrollView_1_export.helper.limit_node_export.maxWoundNum_export
    self.cure_panel_tableview = self.root.ScrollView_1_export.helper.cure_panel_tableview_export
    self.cell_tableview = self.root.ScrollView_1_export.helper.cell_tableview_export
    self.bottom_node = self.root.ScrollView_1_export.helper.bottom_node_export
    self.heal_btn = self.root.ScrollView_1_export.helper.bottom_node_export.heal_btn_export
    self.free_heal_btn = self.root.ScrollView_1_export.helper.bottom_node_export.free_heal_btn_export
    self.all_heal_btn = self.root.ScrollView_1_export.helper.bottom_node_export.all_heal_btn_export
    self.tips_node = self.root.ScrollView_1_export.tips_node_export

    uiMgr:addWidgetTouchHandler(self.root.title_export.intro1_btn, function(sender, eventType) self:onHelpRecruitHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.recruit_btn, function(sender, eventType) self:onRecruitHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.all_recruit_btn, function(sender, eventType) self:onRecruitAllHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.heal_btn, function(sender, eventType) self:onCureHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.free_heal_btn, function(sender, eventType) self:onFreeCureAllHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.all_heal_btn, function(sender, eventType) self:onCureAllHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:onCloseHandler(sender, eventType) end, nil, true)
    uiMgr:addWidgetTouchHandler(self.recruit_btn, function(sender, eventType) self:onRecruitHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.all_recruit_btn, function(sender, eventType) self:onRecruitAllHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.heal_btn, function(sender, eventType) self:onCureHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.free_heal_btn, function(sender, eventType) self:onFreeCureAllHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.all_heal_btn, function(sender, eventType) self:onCureAllHandler(sender, eventType) end, true)

    local ResSetControl = require("game.UI.commonUI.widget.ResSetControl")
    self.ResSetControl = ResSetControl.new(self.res)

    local recruitPanelSize = self.recruit_panel_tableview:getContentSize()
    local recruitSize = cc.size(recruitPanelSize.width, recruitPanelSize.height)
    self.recruit_tableView = UITableView.new()
        :setSize(recruitSize)
        :setCellSize(self.cell_tableview:getContentSize())
        :setCellTemplate(UIHpSoldierCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(4)
    self.recruit_panel_tableview:addChild(self.recruit_tableView)

    self.cure_panel_size = self.cure_panel_tableview:getContentSize()

    -- --按钮距离底步的固定距离
    -- local dsToBottom = 143
    -- --伤兵背景底部距离操作按钮
    -- local dsToBtnNode = 50

    -- --伤兵滚动容器底部距离伤兵背景
    -- local dsToHealBg = 20

    -- local heal_bg_originH = 239
    
    -- local heal_bg_Y = self.heal_bg:getPositionY()
    -- local heal_bg_S = self.heal_bg:getScaleY()

    -- local dstBottomY = dsToBtnNode-gdisplay.height
    -- self.bottom_node:setPositionY(dstBottomY)

    -- local heal_bg_nowS = (heal_bg_Y-dstBottomY-dsToBtnNode)/heal_bg_originH
    -- self.heal_bg:setScaleY(heal_bg_nowS)
    -- self.no_heal:setScaleY(1/heal_bg_nowS)

    -- local dstPanelSize = cc.size(self.cure_panel_size.width,heal_bg_originH*heal_bg_nowS-dsToHealBg)
    -- if dstPanelSize.height <= 0 then dstPanelSize.height = 1 end
    -- self.cure_panel_tableview:setContentSize(dstPanelSize)
    -- local dstSize = cc.size(dstPanelSize.width,dstPanelSize.height-dsToHealBg)

    self.cure_tableView = UITableView.new()
        :setSize( self.cure_panel_tableview:getContentSize() ) -- dstPanelSize)
        :setCellSize(self.cell_tableview:getContentSize())
        :setCellTemplate(UIHpSoldierCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(4)
    self.cure_panel_tableview:addChild(self.cure_tableView)


    self:adapt()


    self.recruit_btn:setSwallowTouches(false)
    self.all_recruit_btn:setSwallowTouches(false)
    self.heal_btn:setSwallowTouches(false)
    self.free_heal_btn:setSwallowTouches(false)
    self.all_heal_btn:setSwallowTouches(false)



    self.tips3:setVisible(false)

end

function UIHpPanel:adapt()

    self.ScrollView_1:setTouchEnabled(true)

    local sHeight =(gdisplay.height - 130)
    local defY = self.ScrollView_1:getContentSize().height
    self.ScrollView_1:setContentSize(cc.size(gdisplay.width, sHeight))
    local minsize= cc.size(gdisplay.width, defY)
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


function UIHpPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIHpPanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIHpPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIHpPanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIHpPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIHpPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end



function UIHpPanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanelForBtn("UIHpPanel")
end

function UIHpPanel:onEnter()
    self.ResSetControl:setData()
    self.ResSetControl:playAnimation(self.res)

    self:initEventListener()

    self.isPageMove = false
    self:registerMove()
end

function UIHpPanel:onExit()
    gevent:call(global.gameEvent.EV_ON_CITY_SOLDIERS_REFRESH)-- 刷新校场士兵显示

    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

function UIHpPanel:initEventListener()
    local callBB = function(eventName)
        -- body
        self:refreshData()
    end
    self:addEventListener(global.gameEvent.EV_ON_SOLDIERS_UPDATE,callBB)


    local callBB1 = function(eventName)
        -- 免费次数
        self:refreshData()
    end
    self:addEventListener(global.gameEvent.EV_ON_SOLDIERS_FREE_RECRUIT_UPDATE,callBB1)
end

function UIHpPanel:setData(data)
    self.data = data or self.data

    self.recruit_tableView:cleanFocus()
    self.cure_tableView:cleanFocus()
    self.recruit_tableView:setFocusIndex(1)
    self.cure_tableView:setFocusIndex(1)

    -- local soldierData = global.soldierData
    -- self.recruit_tableView:setData(soldierData:getAllHealedSoldierArr())
    -- self.recruit_tableView:setData(data)
    -- self.cure_tableView:setData(soldierData:getAllWoundedSoldierArr())

    global.cityApi:updateBuildingsByIds(function()
        if self.refreshData then 
            self:refreshData()
        end
    end, {self.data.id})
    self:refreshData()

    if not self.m_countDownTimer then
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
    self:countDownHandler()

    -- 伤兵上限
    self:setWoundSoldier()

    local recruitTimeConf = luaCfg:get_time_by(2)
    self.tips1:setString(luaCfg:get_local_string(10610,recruitTimeConf.effectPro.."%"))

    local lvData = global.cityData:getBuildingDataByLvAndId(data.id,data.serverData.lGrade)
    self.tips2:setString(luaCfg:get_local_string(10611,lvData.extraPara1))
end

function UIHpPanel:setWoundSoldier()
    -- body
    self.cureBuff = 0
    global.gmApi:effectBuffer({{lType = luaCfg:get_buildings_pos_by(13).funcType, lBind = 13}},function(msg)
        
        local maxWound = 0
        if msg.tgEffect then 
            msg.tgEffect[1] = msg.tgEffect[1] or {}
            local buffs = msg.tgEffect[1].tgEffect
            for i,v in ipairs(buffs) do
                if v.lEffectID == 47 then
                    maxWound = maxWound + v.lVal
                elseif v.lEffectID == 3054 then  -- 伤兵治疗消耗减少
                    self.cureBuff = self.cureBuff + v.lVal
                end
            end
        end
        if not tolua.isnull(self.maxWoundNum) then 
            self.maxWoundNum:setString(maxWound)
        end 
        gevent:call(global.gameEvent.EV_ON_SOLDIER_CURE_BUFF)
    end)  
end

function UIHpPanel:getCureBuff()
    return self.cureBuff or 0
end

function UIHpPanel:countDownHandler(dt)
    local sData = self.data.serverData
    local curr = global.dataMgr:getServerTime()
    if not sData or not sData.lBdTime then return end
    local rest2 = sData.lBdTime.lParam[2]-curr
    local rest1 = sData.lBdTime.lParam[1]-curr
    local rest3 = sData.lBdTime.lParam[3]-curr
    if rest2 <= 0 then 
        rest2 = 0
        global.cityApi:updateBuildingsByIds(function()
        end, {self.data.id})
    end

    if rest1 <= 0 then
        rest1 = 0
        global.cityApi:updateBuildingsByIds(function()
        end, {self.data.id})
    end
    -- self.time:setString(global.funcGame.formatTimeToHMS(rest))
    self.lost_time:setString(global.funcGame.formatTimeToHMS(rest2))
    self.heal_time:setString(global.funcGame.formatTimeToHMS(rest1))
    self.free_time:setString(global.funcGame.formatTimeToHMS(rest3))

    
    global.tools:adjustNodeVerical(self.tips1, self.lost_time)
    global.tools:adjustNodeVerical(self.tips2, self.heal_time)
    global.tools:adjustNodeVerical(self.tips3, self.free_time)

end

function UIHpPanel:refreshData()
    local soldierData = global.soldierData

    local recruitData = soldierData:getAllHealedSoldierArr()
    local cureData = soldierData:getAllWoundedSoldierArr()

    -- 添加tips 引用
    for _ ,v in pairs(cureData) do 
        v.isrecruit = true 
        v.tips_panel = self
    end 

    for _ ,v in pairs(recruitData) do 
        v.tips_panel = self
    end 

    self.recruit_tableView:setData(recruitData)
    self.cure_tableView:setData(cureData)

    -- 当前伤兵数
    local curNum = 0
    for i,v in ipairs(cureData) do
        local soldierPerpop = luaCfg:get_soldier_property_by(v.lID).perPop
        curNum = curNum + v.num*soldierPerpop
    end
    self.curWoundNum:setString(curNum)

    if not recruitData or #recruitData <= 0 then
        self.recruit_btn:setEnabled(false)
        self.all_recruit_btn:setEnabled(false)
        self.no_recruit:setVisible(true)
    else
        self.recruit_btn:setEnabled(true)
        self.all_recruit_btn:setEnabled(true)
        self.no_recruit:setVisible(false)
    end

    if not cureData or #cureData <= 0 then
        self.heal_btn:setEnabled(false)
        self.free_heal_btn:setEnabled(false)
        self.all_heal_btn:setEnabled(false)
        self.no_heal:setVisible(true)
    else
        self.heal_btn:setEnabled(true)
        self.free_heal_btn:setEnabled(true)        
        self.all_heal_btn:setEnabled(true)
        self.no_heal:setVisible(false)
    end

    if global.userData:getFreeHeal() <= 0 or true then -- or true  去除免费治疗
        self.free_heal_btn:setVisible(false)
        self.all_heal_btn:setVisible(true)
    else
        self.free_heal_btn:setVisible(true)
        self.all_heal_btn:setVisible(false)
    end

    global.tools:adjustNodeVerical(self.tips1, self.lost_time)
    global.tools:adjustNodeVerical(self.tips2, self.heal_time)

    -- 空闲监听
    gevent:call(global.gameEvent.EV_ON_UI_LEISURE)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIHpPanel:onRecruitHandler(sender, eventType)

    if eventType == ccui.TouchEventType.began then
        self.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if self.isPageMove then 
            return
        end

        --康复士兵可招募
        local function callback()
            self:refreshData()
        end
        local data = self.recruit_tableView:getSelectedData()
        if data then
            global.panelMgr:openPanel("UIRecruitNumPanel"):setData(data,callback)
        end
    end
end

function UIHpPanel:onRecruitAllHandler(sender, eventType)

    if eventType == ccui.TouchEventType.began then
        self.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if self.isPageMove then 
            return
        end

        --全部招募
        local function callback()
            self:refreshData()
        end
        local data = self.recruit_tableView:getData()
        if data then
            local panel = global.panelMgr:openPanel("UIAllRecruitSurePanel")
            panel:setData(data,callback)
        end
    end
end

function UIHpPanel:onCureAllHandler(sender, eventType)
    
    if eventType == ccui.TouchEventType.began then
        self.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if self.isPageMove then 
            return
        end

        --全部治疗
        local function callback()
            self:refreshData()
        end
        local data = self.cure_tableView:getData()
        if data then
            local panel = global.panelMgr:openPanel("UIAllCureSurePanel")
            panel:setData(data,callback)
        end

    end
end

function UIHpPanel:onCureHandler(sender, eventType)

    if eventType == ccui.TouchEventType.began then
        self.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if self.isPageMove then 
            return
        end

        --伤兵需治疗
        local function callback()
            self:refreshData()
        end
        local data = self.cure_tableView:getSelectedData()
        if data then
            local panel = global.panelMgr:openPanel("UICureNumPanel")
            panel:setData(data,callback)
        end
    end
end

function UIHpPanel:onFreeCureAllHandler(sender, eventType)

    if eventType == ccui.TouchEventType.began then
        self.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if self.isPageMove then 
            return
        end

        local lType = 1 --免费全部治疗
        global.cityApi:healSoldier(function(msg)
            -- body
            --扣除资源消耗
            global.soldierData:addSoldiersBy(msg.tgSoldiers)
            global.tipsMgr:showWarning(luaCfg:get_local_string(10221))

            gevent:call(gsound.EV_ON_PLAYSOUND,"city_click_13")--音效添加（张亮）

            local healTimes = global.userData:getFreeHeal()-1
            if healTimes < 0 then
                healTimes = 0
            end
            global.userData:setFreeHeal(healTimes)
            self:refreshData()
        end, lType)

    end

end

function UIHpPanel:onHelpRecruitHandler(sender, eventType)

    local data = luaCfg:get_introduction_by(2)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end

--CALLBACKS_FUNCS_END

return UIHpPanel

--endregion
