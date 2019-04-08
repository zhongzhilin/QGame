--region UIWorldPanel.lua
--Author : untory
--Date   : 2016/08/24
--generate by [ui_code_tool.py] automatically

local luaCfg = global.luaCfg
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local GameEvent = global.gameEvent
local WCONST = WCONST

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local Bottom = require("game.UI.commonUI.widget.Bottom")
local Top = require("game.UI.commonUI.widget.Top")
local UIAttackInfo = require("game.UI.world.widget.UIAttackInfo")
local UIDirectorButton = require("game.UI.world.widget.UIDirectorButton")
local UILocationInfo = require("game.UI.world.widget.UILocationInfo")
local UIMinimap = require("game.UI.world.widget.UIMinimap")
local UINotice = require("game.UI.commonUI.widget.UINotice")
local UIUnionHint = require("game.UI.commonUI.UIUnionHint")
local UIWorldMapBtn = require("game.UI.world.widget.UIWorldMapBtn")
local UITaskJumpBoard = require("game.UI.mission.UITaskJumpBoard")
local UIMonthEffect = require("game.UI.monthCard.UIMonthEffect")
--REQUIRE_CLASS_END

local AreaDataMgr = require("game.UI.world.mgr.AreaDataMgr")
local UIWorldPanel  = class("UIWorldPanel", function() return gdisplay.newWidget() end )
local UIWorldScrollView = require("game.UI.world.UIWorldScrollView")
local UIDirectorButton = require("game.UI.world.widget.UIDirectorButton")

function UIWorldPanel:ctor()
 
    cc.SpriteFrameCache:getInstance():addSpriteFrames("commonui_0.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("worldmap_0.plist")
    
    self:CreateUI()

    self.drawTurn = 0

    self:addEventListener(GameEvent.EV_ON_NET_SHOW_CIRCLE,function()
        
        print("hide loading")
        if self.hideLoading then
            self:hideLoading()
        end
    end)

    self:addEventListener(GameEvent.EV_ON_GAME_RESUME,function()
        
        if global.g_worldview.isStory then return end

        local worldApi = global.worldApi        

        -- self.attactInfoBoard:cleanAttack()
        -- self.mapPanel.wayNode:removeAllChildren()
        -- self.mapPanel.armyNode:removeAllChildren()        

        worldApi:enterWorld(function(msg)
        
            if not global.g_worldview.isInit then return end

            local city = msg.lCitys
            
            if msg.lCityState == 3 then

                global.userData:setCityState(3)
                global.scMgr:gotoMainSceneWithAnimation()
                return
            end

            if self.flushSituation then 
                self:flushSituation()
            end 

            if self.mainId == city.lCityID then

                global.g_worldview.areaDataMgr:flushCurrentScreen(function()
                    
                    self:cleanDirt()
                end,true)
            else
                if not self.setMainCityData then return end
                self:setMainCityData(city)
                self.m_scrollView:setOffset(cc.p(-city.lPosX,-city.lPosY))
                global.userData:setMainCityPos(cc.p(city.lPosX,city.lPosY))
            end                                    

        end)

        if self.checkBossPoint then
            self:checkBossPoint()
        end

        -- local pos = self.mapPanel:getTruePos()    
        -- global.scMgr:gotoWorldScene()
        -- global.g_worldview.m_scrollView:setOffset(pos)
        -- print("self:addEventListener(GameEvent.EV_ON_GAME_RESUME,function()")
    end)
end

function UIWorldPanel:cleanDirt()
        
    self.mapPanel.wayNode:removeAllChildren()
    self.mapPanel.armyNode:removeAllChildren()
    self.mapPanel.attackEffectNode:removeAllChildren()
    self.mapPanel.effectNode:removeAllChildren()
    global.g_worldview.lineViewMgr:cleanAll()
end

function UIWorldPanel:flushSituation()
    
    if global.scMgr:isWorldScene() then
        global.worldApi:querySituation(function(data)
            
            if tolua.isnull(self.attactInfoBoard) then return end
            self.attactInfoBoard:cleanAttack()

            local attackMgr = global.g_worldview.attackMgr

            for _,v in ipairs(data.tgData or {}) do

                attackMgr:dealAttackBoard(v)

                global.worldApi:dealAttackEffectCommon(v)
            end
        end)
    end    
end

function UIWorldPanel:setLoadDoneCallBack(callback)

    print("set load done call back")
    self.loadDoneCallBack = callback
end

function UIWorldPanel:setEnterCallBack(callback)
    
    print(">>>>>>>>>>>>>>>function UIWorldPanel:setEnterCallBack(callback)")
    self.enterCallBack = callback
end

function UIWorldPanel:CreateUI()
    local root = resMgr:createWidget("world/world")
    self:initUI(root)
end

function UIWorldPanel:initPanel()
    
    self.mapPanel = require("game.UI.world.widget.UIMapPanel").new() 

    global.g_worldview.mapPanel = self.mapPanel

    self.m_scrollView = UIWorldScrollView.new()
    self.m_scrollView:initWithWorldSize(self.UI_ScrollView,self.mapPanel)
    self.m_scrollView:setPositionY(self.m_scrollView:getPositionY() -  100)

    if WCONST.WORLD_CFG.IS_3D then
    
        local rotation = self.m_scrollView:getRotation3D()
        self.m_scrollView:setRotation3D(cc.vec3(rotation.x-25,rotation.y,rotation.z))
    end    

    local rootBg = cc.TMXTiledMap:create("map/file/root1.tmx")
    rootBg:setAnchorPoint(cc.p(0,0))
    self:addChild(rootBg, -1, "rootBg")
    --global.g_worldview.flogMgr:createFlog(self)
end

function UIWorldPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/world")
 
-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.UI_ScrollView = self.root.Panel_1.UI_ScrollView_export
    self.part_node = self.root.part_node_export
    self.bot_ui = self.root.bot_ui_export
    self.bot_ui = Bottom.new()
    uiMgr:configNestClass(self.bot_ui, self.root.bot_ui_export)
    self.top_ui = self.root.top_ui_export
    self.top_ui = Top.new()
    uiMgr:configNestClass(self.top_ui, self.root.top_ui_export)
    self.attactInfoBoard = self.root.attactInfoBoard_export
    self.attactInfoBoard = UIAttackInfo.new()
    uiMgr:configNestClass(self.attactInfoBoard, self.root.attactInfoBoard_export)
    self.directorButton = UIDirectorButton.new()
    uiMgr:configNestClass(self.directorButton, self.root.directorButton)
    self.locationInfo = self.root.locationInfo_export
    self.locationInfo = UILocationInfo.new()
    uiMgr:configNestClass(self.locationInfo, self.root.locationInfo_export)
    self.miniMap = self.root.miniMap_export
    self.miniMap = UIMinimap.new()
    uiMgr:configNestClass(self.miniMap, self.root.miniMap_export)
    self.fund_red_point = self.root.miniMap_export.fund_red_point_export
    self.sunshine = self.root.sunshine_export
    self.loading = self.root.loading_export
    local loading_TimeLine = resMgr:createTimeline("world/map_Load")
    loading_TimeLine:play("animation0", true)
    self.root.loading_export:runAction(loading_TimeLine)
    self.FileNode_1 = UINotice.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)
    self.btn_state = self.root.btn_state_export
    self.icon = self.root.btn_state_export.icon_export
    self.btn_boss = self.root.btn_boss_export
    self.boss = self.root.btn_boss_export.boss_export
    self.txt_boss_export = self.root.btn_boss_export.txt_boss_export_mlan_6
    self.bossPoint = self.root.btn_boss_export.bossPoint_export
    self.btn_seek = self.root.btn_seek_export
    self.seek = self.root.btn_seek_export.seek_export
    self.txt_seek_export = self.root.btn_seek_export.txt_seek_export_mlan_6
    self.noUnionHint = self.root.noUnionHint_export
    self.noUnionHint = UIUnionHint.new()
    uiMgr:configNestClass(self.noUnionHint, self.root.noUnionHint_export)
    self.btn_troops = self.root.btn_troops_export
    self.troops = self.root.btn_troops_export.troops_export
    self.txt_troops_export = self.root.btn_troops_export.txt_troops_export_mlan_6
    self.btn_skill = self.root.btn_skill_export
    self.skill = self.root.btn_skill_export.skill_export
    self.txt_skill_export = self.root.btn_skill_export.txt_skill_export_mlan_6
    self.FileNode_2 = UIWorldMapBtn.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.FileNode_2)
    self.taskJumpBoard = UITaskJumpBoard.new()
    uiMgr:configNestClass(self.taskJumpBoard, self.root.taskJumpBoard)
    self.FileNode_3 = UIMonthEffect.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.FileNode_3)

    uiMgr:addWidgetTouchHandler(self.btn_state, function(sender, eventType) self:changeToLineMap(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_boss, function(sender, eventType) self:bossHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_seek, function(sender, eventType) self:seekHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_troops, function(sender, eventType) self:troopsHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_skill, function(sender, eventType) self:SkillHandler(sender, eventType) end)
--EXPORT_NODE_END

    self.miniMap:setLocalZOrder(2)
    self.locationInfo:setLocalZOrder(2)
    self.directorButton:setLocalZOrder(3)
    self.FileNode_1:setLocalZOrder(4)
    self.noUnionHint:setLocalZOrder(998)
    self.top_ui:setData()
    self.isLineMap = false

    -- self.FileNode_1:removeFromParent()

    self:hideLoading()
    -- self:scheduleUpdate()  

    if (cc.UserDefault:getInstance():getBoolForKey("islowFpsPhone", false)) then
        self.part_node:removeFromParent()
        global.g_worldview.worldCityMgr:showByLv()
    end  
end

function UIWorldPanel:hideUI()

    local ui_list = {"miniMap","bot_ui","taskJumpBoard","btn_skill","top_ui","directorButton","btn_state","FileNode_1","locationInfo", "btn_boss","btn_seek","btn_troops","FileNode_2","FileNode_3","attactInfoBoard"}
    for _,v in ipairs(ui_list) do

        self[v]:setVisible(false)
    end                                               

    self.m_scrollView:setScale(1.05)
    self.m_scrollView:setPositionY(self.m_scrollView:getPositionY() - 45)
end

function UIWorldPanel:showPathTimePanel(data)
    
    global.panelMgr:getPanel("UISeeking"):setDelayClose(function()
        
        local cutTime = data.lRoadTime
        local luaCfg = global.luaCfg

        local hour = math.floor(cutTime / 3600) 
        cutTime = cutTime  % 3600
        local min = math.floor(cutTime / 60)
        cutTime = cutTime % 60
        local sec = math.floor(cutTime)

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData("TroopsBtn", function()
            
            self:startAttack()
        end)

        local cityName = global.g_worldview.worldPanel.chooseCityName
        local troopName = "" 
        if cityName==nil then cityName = "-" end
        if troopName=="" then troopName = luaCfg:get_local_string(10140) end
        panel.text:setString(string.format(luaCfg:get_local_string(10020), troopName, global.troopData:getTargetStr(),cityName,hour,min,sec, global.troopData:getOrderStr()))
        
        gevent:call(global.gameEvent.EV_ON_GUIDE_CHECK_ATTACK_BOARD_OPEN)
    end)
    
end

function UIWorldPanel:startAttack()    

    global.worldApi:attackCity(self.mainId,self.chooseCityId,self.attackMode,self.outTroopId,self.lForce,function(msg)
        
        global.panelMgr:closePanel("UITroopPanel")

        global.panelMgr:closePanelShowWorld() 
        
        self.mapPanel:closeChoose()

        if global.scMgr:isWorldScene() then
            
            if not global.guideMgr:isPlaying() then
                global.g_worldview.worldPanel:chooseSoldier(self.outTroopId,global.userData:getUserId())            
            end                        
        end        
    end)
end

function UIWorldPanel:showLoading()
    self.loading:stopActionByTag(998)
    local action = cc.Sequence:create(cc.DelayTime:create(0.3),cc.Show:create())
    action:setTag(998)
    self.loading:runAction(action)
    -- self.loading:setVisible(true)
end

function UIWorldPanel:hideLoading()
    self.loading:stopActionByTag(998)
    self.loading:setVisible(false)
end

function UIWorldPanel:changeScene()
    
    -- self.bot_ui:runAction(cc.MoveBy:create(0.5,cc.p(0,-200)))
    -- self.top_ui:runAction(cc.MoveBy:create(0.5,cc.p(0,200)))

    if not self.m_scrollView then return end

    local node = cc.Node:create()
    self.m_scrollView:addChild(node)

    node:runAction(cc.Repeat:create(cc.Sequence:create(cc.CallFunc:create(function()
        
        self.m_scrollView:setZoomScale(self.m_scrollView:getZoomScale() - 0.01)
    end),cc.DelayTime:create(1 / 60)),30))
end

function UIWorldPanel:enterScene()
    
    if not self.m_scrollView then return end
    
    local node = cc.Node:create()
    self.m_scrollView:addChild(node)

    self.m_scrollView:setZoomScale(WCONST.WORLD_CFG.CUR_SCALE)

    -- self.m_scrollView:setZoomScale(self.m_scrollView:getZoomScale() - 0.3)
    -- node:runAction(cc.Repeat:create(cc.Sequence:create(cc.CallFunc:create(function()
        
    --     self.m_scrollView:setZoomScale(self.m_scrollView:getZoomScale() + 0.01)
    -- end),cc.DelayTime:create(1 / 60)),30))
end

local worldConst = require("game.UI.world.utils.WorldConst")
function UIWorldPanel:setMainCityData(data,isNeedScroll)
    if not data then
        return
    end
    --dump(data,"fsadfjasdfasdfasfd")
    if not data.lPosX then
        local pixelpos = worldConst:convertCityId2Pix(data.lCityID)
        data.lPosX = pixelpos.x
        data.lPosY = pixelpos.y
    end
    --dump(data,"fsadfjasdfasdfasfdfa---a》》")
    self.mainOffset = cc.p(-data.lPosX,-data.lPosY)
    self.mainCityPos = cc.p(data.lPosX,data.lPosY)
    self.mainId = data.lCityID

    if not global.g_worldview.isStory then
        global.userData:setWorldCityID(data.lCityID)
    end    

    --TODO
    -- self.mainOffset = cc.p(0,0)
    -- self.mainCityPos = cc.p(50,0)
    --TODO

    -- print("main city pos",self.mainCityPos.x,self.mainCityPos.y)

    if isNeedScroll then

        self.m_scrollView:setOffset(self.mainOffset)
    end
end

function UIWorldPanel:enterWorld(msg)
    
    local city = msg.lCitys

    if not city then 
        return 
    end 

    global.uiMgr:removeSceneModal(10002)
    global.uiMgr:addSceneModel(0.6,10003)  

    self:setMainCityData(city)

    if not self.isGPS then
        self.m_scrollView:setOffset(cc.p(-city.lPosX,-city.lPosY))
    end   

    self:enterScene() 

    -- 云层开始展开
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.6),cc.CallFunc:create(function( ... )
        
        -- 云层展开结束
        if not self.isGPS then
            self.m_scrollView:setOffset(cc.p(-city.lPosX,-city.lPosY))
        end

        global.userData:setMainCityPos(cc.p(city.lPosX,city.lPosY))

        global.uiMgr:removeSceneModal(10003)

        if self.enterCallBack then

            self.enterCallBack()
        end

    end)))
end

function UIWorldPanel:openCloud()
   
    local widget = global.scMgr:CurScene().cloud 
    if widget == nil then return end

    local timelineAction = resMgr:createTimeline("world/yun_new")        
    widget:runAction(timelineAction)
    timelineAction:play("animation1", false)        

    timelineAction:setLastFrameCallFunc(function()

        widget:removeFromParent()
    end)        

    if not global.g_worldview.isStory then
        gevent:call(global.gameEvent.EV_ON_ENTER_WORLD_SCENE)
    end    

    global.uiMgr:addSceneModel(nil,10002)  
end

function UIWorldPanel:initWeatherAnimation()
    
    self.nodeTimeLine = resMgr:createTimeline("world/world")    
    self.root:stopAllActions()
    self.root:runAction(self.nodeTimeLine)
end

function UIWorldPanel:onEnter()
 
    self:initWeatherAnimation()

    global.g_worldview.worldCityMgr:getRoadNode():setVisible(true)

    self:initPanel()
    
    self.mainOffset = cc.p(0,0)
    self.mainCityPos = cc.p(0,0)        

    -- 此处只是为了做表现
    global.delayCallFunc(function()
    
        local cityPos = global.userData:getMainCityPos()
        if cityPos then
            self.m_scrollView:setOffset(cc.p(-cityPos.x,-cityPos.y),true) 
        end        
     
    end,nil,0)

    if global.g_worldview.isStory then
        
        self:hideUI()

        gevent:call(global.gameEvent.EV_ON_ENTER_WORLD_SCENE)
        -- global.guideMgr:play("OPstart")        
        global.scMgr:setChangeState(false)
    else


        self:openCloud()

        global.worldApi:enterWorld(function( msg )
            
            if not self.enterWorld then
                return
            end

            self:enterWorld(msg) 
            self:flushSituation()
            global.scMgr:setChangeState(false)
        end)
    end

    -- 联盟加入提示
    self:addEventListener(global.gameEvent.EV_ON_UNIONHINT,function (event, isHide)
        if self.checkUnionHint then
            self:checkUnionHint(isHide)
        end
    end)
    self:addEventListener(global.gameEvent.EV_ON_GUIDE_START, function()
        if self.noUnionHint then
            self.noUnionHint:hideHint()
        end
    end)

    self:checkBossPoint()
    self:addEventListener(global.gameEvent.EV_ON_UI_BOSS_REFERSHITEM, function (event, msg)
        if self.checkBossPoint then
            self:checkBossPoint()
        end
    end)
    self:addEventListener(global.gameEvent.EV_ON_BOSS_POINT, function (event, msg)
        if self.checkBossPoint then
            self:checkBossPoint()
        end
    end)

    self:fundRed()

    self:addEventListener(global.gameEvent.BANKUPDATE , function () 
        self:fundRed()
    end)

    self:addEventListener(global.gameEvent.EV_ON_SEVENDAYRECHARGE , function () 
        self:fundRed()
    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_RECHARGE , function () 
        self:fundRed()
    end)

    -- 联盟红包
    self:checkUnionRedBag()
    self:addEventListener(global.gameEvent.EV_ON_UNION_REDBAG,function ()
        if self.checkUnionRedBag then
            self:checkUnionRedBag()
        end
    end)
    global.chatData:refershUnionGift()

end

function UIWorldPanel:checkUnionRedBag()
    if self.isLineMap or global.g_worldview.isStory then
        if self.unionGift then 
            self.unionGift:hideHint()
        end 
        return
    end

    if not self.unionGift then 
        local UIRedBag = require("game.UI.commonUI.UIRedBag")
        self.unionGift =UIRedBag.new(true)
        self.unionGift:setPositionX(536.27)
        self.unionGift:setPositionY(341.60)
        self.root:addChild(self.unionGift)
        self.unionGift:setLocalZOrder(999)
    end 

    self.unionGift:setData()
end


function UIWorldPanel:fundRed()

    self.fund_red_point:setVisible(false)

    if  global.scMgr:isWorldScene() then 

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
    end 
end 

function UIWorldPanel:checkBossPoint()
    -- body
    self.bossPoint:setVisible(false)
    local checkReward = function (index)
        -- body
        local chest = global.bossData:getCurrentShowChest(index)
        if chest and chest.canopen then
            self.bossPoint:setVisible(true)
        end
    end
    checkReward(1) -- 普通boss
    checkReward(2) -- 极限boss

    -- 极限boss第一次开启时显示红点
    local isFirstOpen = cc.UserDefault:getInstance():getStringForKey("BOSS_FIRST_OPEN"..global.userData:getUserId())
    local curStar, maxStar = global.bossData:getStarNum()
    local openNeedStar = global.luaCfg:get_config_by(1).EliteBossStar
    if isFirstOpen == "" and curStar >= openNeedStar then
        self.bossPoint:setVisible(true)
    end
end

function UIWorldPanel:checkUnionHint(isHide)

    if self.isLineMap then return end -- 进入世界
    local isNotJoin = not global.userData:checkJoinUnion()
    local isCityLV = global.cityData:getBuildingById(1).serverData.lGrade < 10
    local cdTime = global.unionData:getAllyCdTime()
    local limitConfig = global.luaCfg:get_config_by(1).union_cd_time
    local limit = global.dataMgr:getServerTime() - cdTime
    local isNoCding = (cdTime == 0) or (limit > limitConfig*60)
    if isNotJoin and isCityLV and isNoCding then
        self.noUnionHint:showHint()
    else
        self.noUnionHint:hideHint()
    end
    if isHide then
        self.noUnionHint:hideHint()
    end
end

function UIWorldPanel:onExit()
    
    -- print("worldpanel onexit")
    global.g_worldview.worldCityMgr:cleanCache()
    self.m_scrollView:closeSchedule()

    self.loadDoneCallBack = nil
end

function UIWorldPanel:gpsSoldier(id)
    
    print("gps sodler")
    local troop = self.mapPanel:getTroop(id)    
    self.gpsTarget = troop
end

function UIWorldPanel:cancelGpsSoldier()

    -- print(">>>>>>>>>>>>function UIWorldPanel:cancelGpsSoldier()")

    self.mapPanel:closeChoose(false)
    self.gpsTarget = nil
end

function UIWorldPanel:isInGPS()
    
    return self.gpsTarget ~= nil
end

function UIWorldPanel:chooseSoldier(id,userId,isHideSound)
    
    print("start choose soldiers")
    local troop = self.mapPanel:getTroop(id)    
    if not troop then        

        if userId then

            global.g_worldview.attackMgr:flushTroopInstance(userId, id,function()
                if self.chooseSoldier then             
                    self:chooseSoldier(id)
                end
            end)
        end
        return false
    end

    self.mapPanel:chooseObject(troop,isHideSound)

    return true
end

function UIWorldPanel:chooseCityById( id,lWildKind,isNeedHideUI)
    
    self.mapPanel:closeChoose(true)
    self:cancelGpsSoldier()

    if not isNeedHideUI then
        self.gpsCityId = id
    end    

    local city = self.mapPanel:getCityByIdForAll(id,lWildKind)

    if city then
 
        local pos = cc.p(city:getPosition())
        self.m_scrollView:setOffset(cc.p(pos.x * -1,pos.y * -1))
        
        if lWildKind and lWildKind == 2 then
            
            city:checkChoose()
        else


            if not isNeedHideUI then
                self.mapPanel:chooseObject(city)    
            end    
            
        end
    else

        --如果没有找到，则联网去加载
        global.worldApi:getCityPos(id,function(msg)
            
            msg = msg or {}
            msg.lPosx = msg.lPosx or 0
            msg.lPosy = msg.lPosy or 0

            if not tolua.isnull(self.m_scrollView) then -- 报错处理
                self.m_scrollView:setOffset(cc.p(-msg.lPosx,-msg.lPosy))
            end

            if self.cancelGpsSoldier then --报错处理
                self:cancelGpsSoldier()            
            end  
        end)
    end
end

function UIWorldPanel:chooseCityByAttackTroopId(id)
    
    local troop = self.mapPanel:getAttackEffectNodeByTroopId(id)

    local pos = cc.p(troop:getPosition())
    self.m_scrollView:setOffset(cc.p(pos.x * -1,pos.y * -1))

    local city = self.mapPanel:getCityById(troop.data.lTarget)

    if city then
        
        self.mapPanel:chooseObject(city)
    end
end

function UIWorldPanel:getScreenZeroToWorldPos()
    return self.m_scrollView:convertToNodeSpace(cc.p(0,0))
end

function UIWorldPanel:getWorldScrollView()
    return self.m_scrollView
end

function UIWorldPanel:addWidgetToMapPanel(widget)
    self.mapPanel:addChild(widget,999)
end

function UIWorldPanel:getScreenZeroToMapPos()
    return self.mapPanel:convertToNodeSpace(cc.p(0,0))
end

function UIWorldPanel:getWorldMapPanel()
    return self.mapPanel
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

-- function UIWorldPanel:update(dt)
    
--     if self.gpsTroop then

--         self.m_scrollView:setOffset(cc.p(troop:getPositionX() * -1,troop:getPositionY() * -1))
--     end
-- end

function UIWorldPanel:getIsLineMap()
    
    return self.isLineMap

end

function UIWorldPanel:cleanDraw()
    if self.draw1 then self.draw1:removeFromParent() self.draw1 = nil end
end

function UIWorldPanel:drawMap()
    
    local childs = self.mapPanel:getAllCitysAndMiracle()

    local allChilds = self.mapPanel.mapObjNode:getChildren()    

    for _,v in ipairs(allChilds) do

        v:changeToLineMap()            
    end

    self.drawTurn = self.drawTurn + 1    

    local lineWidth = 1000
    local resData = {}
    local cPoints = {}

    for i,v in ipairs(childs) do
        
        if v:isNeedDraw() then
           table.insert(resData,i)           
        end

        v:setTag(i)        
        table.insert(cPoints,cc.p(v:getPosition()))
    end

    local isPointEquie = function(p1,p2)
        
        return (p1.x == p2.x and p1.y == p2.y)
    end

    local isLineInLineCache = function(startPos,endPos)
        
        for _,i in ipairs(lineCache) do

            local preStart = i[1]
            local preEnd = i[2]

            if (isPointEquie(startPos,preStart) and isPointEquie(endPos,preEnd)) or (isPointEquie(startPos,preEnd) and isPointEquie(endPos,preStart)) then

                return true
            end
        end

        return false
    end


    if #cPoints == 0 then return end

    -- dump(cPoints,'..cPoints')

    CCHgame:StartDraw(function(drawTurn,lineCache)
        
        if drawTurn ~= self.drawTurn then return end

        if self.draw1 then self.draw1:removeFromParent() self.draw1 = nil end

        local draw1 = cc.DrawNode:create()
        draw1:setAnchorPoint(cc.p(0,0))
        draw1:setPosition(cc.p(0,0))
        self.mapPanel:addChild(draw1,998)

        self.draw1 = draw1

        -- for _,v in ipairs(lineCache) do

        --     draw1:drawSegment(v[1],v[2],2,{r = 37 / 255,g = 52 / 255,b = 0,a = 0.20})                
        -- end        

        local allyLineCache = {}
        for _,j in ipairs(resData) do
        
            local city = self.mapPanel:getCityByTag(j)

            if city then

                local point3 = cc.p(city:getPosition())
                local line = {}
                
                for _,i in ipairs(lineCache) do

                    if isPointEquie(point3,i[1]) then
                    
                        table.insert(line,i[2])
                    end

                    if isPointEquie(point3,i[2]) then
                       
                        table.insert(line,i[1])
                    end
                end


                -- dump(line,">>>>awdawdwda")

                local sortFun = function(pos1,pos2)
                    
                    local ang1 = cc.pToAngleSelf(cc.pSub(point3,pos1))                    
                    local ang2 = cc.pToAngleSelf(cc.pSub(point3,pos2))                    

                    return ang1 > ang2
                end

                table.sort(line,sortFun)          
  

                local isNeedDraw = true
                if #line >= 2 then
                    local angMax = cc.pToAngleSelf(cc.pSub(point3,line[1])) + 3.1415926
                    local angMin = cc.pToAngleSelf(cc.pSub(point3,line[#line])) + 3.1415926

                    -- print(city:getName(),angMax - angMin)

                    if angMax - angMin < 3.14 then
-- 
                        -- print(">>>>isNeedDraw == false")
                        isNeedDraw = false
                    end
                end

                local centerPosForCheck = cc.p(0,0)
                
                local lineCount = #line
                for i = 1,lineCount do
                    local pos1 = line[i]            
                    centerPosForCheck.x = centerPosForCheck.x + pos1.x
                    centerPosForCheck.y = centerPosForCheck.y + pos1.y  
                end

                centerPosForCheck.x = centerPosForCheck.x / lineCount
                centerPosForCheck.y = centerPosForCheck.y / lineCount

                for i = 1,lineCount do

                    local nextIndex = i + 1
                    local pos1 = line[i]            
                    if i == lineCount then

                        nextIndex = 1
                    end
                    local pos2 = line[nextIndex]
                    
                    if cc.pIsSegmentIntersect(pos1,pos2,point3,centerPosForCheck) then

                        -- draw1:drawSegment(pos1,pos2,2,{r = 37 / 255,g = 52 / 255,b = 0,a = 0.20})                
                        -- draw1:drawSegment(point3,centerPosForCheck,2,{r = 37 / 255,g = 52 / 255,b = 0,a = 0.20})                

                        isNeedDraw = false
                        -- print(">>>>>is out true")
                    end
                end            

                local avatar = city:getAvatarType()


                print(isNeedDraw,"isNeedDraw",avatar,"avatar")

                if isNeedDraw and avatar then


                    if #line ~= 1 then

                        local centerPoss = {}

                        local lineCount = #line

                        for i = 1,lineCount do
                            
                            local nextIndex = i + 1

                            local pos1 = line[i]
                            
                            if i == lineCount then

                                nextIndex = 1
                            end

                            local pos2 = line[nextIndex]
                        
                            local centerPos = cc.p((pos1.x + pos2.x + point3.x) / 3,(pos1.y + pos2.y + point3.y) / 3)
                            
                            table.insert(centerPoss,centerPos)
                        end     --放置三角形中心

                        for i = 1,lineCount do

                            line[i] = cc.p((line[i].x + point3.x) / 2,(line[i].y + point3.y) / 2)
                        end     --放置边的中点
                        
                        for _,v in ipairs(centerPoss) do

                            table.insert(line,v)
                        end

                        table.sort(line,sortFun)
                    end                                        

                    local colors = {
                        [0] = {r = 255 / 255,g = 213 / 255,b = 45 / 255, a = 0.2},
                        [1] = {r = 14 / 255,g = 201 / 255,b = 255 / 255, a = 0.2},
                        [2] = {r = 55 / 255,g = 255 / 255,b = 17 / 255, a = 0.2},
                        [3] = {r = 55 / 255,g = 255 / 255,b = 17 / 255, a = 0.2},
                        [4] = {r = 255 / 255,g = 30 / 255,b = 7 / 255, a = 0.2}
                    }

                    local color = colors[avatar]
                    
                    allyLineCache[avatar] = allyLineCache[avatar] or {}    
                    lineCount = #line

                    for i = 1,lineCount do

                        local nextIndex = i + 1
                        local pos1 = line[i]            
                        if i == lineCount then

                            nextIndex = 1
                        end
                        local pos2 = line[nextIndex]

                        draw1:drawTriangle(point3,pos1,pos2,color)     
                        table.insert(allyLineCache[avatar],{[1] = pos1,[2] = pos2})            
                    end            
                end                
            end            
        end

        local alreadyDrawLineCache = nil
        local finalLineCache = {}

        local checkIsAlreadyDraw = function(startPos,endPos)

            for _,v in ipairs(alreadyDrawLineCache) do

                if (isPointEquie(v[1],startPos) and isPointEquie(v[2],endPos)) or isPointEquie(v[2],startPos) and isPointEquie(v[1],endPos) then

                    return true
                end
            end

            return false
        end

        for _,v in pairs(allyLineCache) do        

            alreadyDrawLineCache = {}
            local needDrawCache = {}

            for _,vv in ipairs(v) do

                if not checkIsAlreadyDraw(vv[1],vv[2]) then
                    
                    table.insert(needDrawCache,{[1] = clone(vv[1]),[2] = clone(vv[2])})                
                    table.insert(alreadyDrawLineCache,{[1] = clone(vv[1]),[2] = clone(vv[2])})
                else

                    for i,v in ipairs(needDrawCache) do

                        if (isPointEquie(v[1],vv[1]) and isPointEquie(v[2],vv[2])) or isPointEquie(v[2],vv[1]) and isPointEquie(v[1],vv[2]) then

                            table.remove(needDrawCache,i)                    
                        end        
                    end
                end            
            end

            for _,vv in ipairs(needDrawCache) do
                            
                table.insert(finalLineCache,{[1] = clone(vv[1]),[2] = clone(vv[2])}) 
            end
        end


        alreadyDrawLineCache = {}
        for _,vv in ipairs(finalLineCache) do

            if not checkIsAlreadyDraw(vv[1],vv[2]) then
                   
                draw1:drawSegment(vv[1],vv[2],2,{r = 37 / 255,g = 52 / 255,b = 0,a = 0.20})       
                table.insert(alreadyDrawLineCache,{[1] = clone(vv[1]),[2] = clone(vv[2])})        
            end         
        end
    end,cPoints,#cPoints,self.drawTurn)
end

-- 隐藏非战斗相关UI
function UIWorldPanel:hideUI_careWar()

    if self.isLineMap then return end

    global.uiMgr:addSceneModel(0.5)

    self.isHide_carWar = not self.isHide_carWar

    if self.isHide_carWar then

        gsound.stopEffect("city_click")
        gevent:call(gsound.EV_ON_PLAYSOUND,"world_mapzoomIn")

        self.bot_ui:runAction(cc.MoveBy:create(0.5,cc.p(0,-200)))
        self.top_ui:runAction(cc.MoveBy:create(0.5,cc.p(0,200)))
        self.top_ui.ad_enter:runAction(cc.MoveBy:create(0.5,cc.p(0,-200)))
        self.top_ui.ad_enter:runAction(cc.MoveBy:create(0.5,cc.p(200,0)))
        self.top_ui.leisure_btn:runAction(cc.MoveBy:create(0.5,cc.p(0,-200)))
        self.top_ui.leisure_btn:runAction(cc.MoveBy:create(0.5,cc.p(200,0)))
        -- self.miniMap:runAction(cc.MoveBy:create(0.5,cc.p(300,0)))
        self.btn_seek:runAction(cc.MoveBy:create(0.5,cc.p(200,0)))
        self.FileNode_2:runAction(cc.MoveBy:create(0.5,cc.p(-150,0)))
        self.FileNode_3:runAction(cc.MoveBy:create(0.5,cc.p(200,0)))
        self.btn_skill:runAction(cc.MoveBy:create(0.5,cc.p(200,0)))
        self.btn_state:runAction(cc.MoveBy:create(0.5,cc.p(200,0)))        
        self.btn_boss:runAction(cc.MoveBy:create(0.5,cc.p(-150,0)))
        self.taskJumpBoard:runAction(cc.MoveBy:create(0.5,cc.p(-450,0)))            
    else

        gsound.stopEffect("city_click")
        gevent:call(gsound.EV_ON_PLAYSOUND,"world_mapzoomOut")
        
        self.bot_ui:runAction(cc.MoveBy:create(0.5,cc.p(0,200)))
        self.top_ui:runAction(cc.MoveBy:create(0.5,cc.p(0,-200)))
        self.top_ui.ad_enter:runAction(cc.MoveBy:create(0.5,cc.p(0,200)))
        self.top_ui.ad_enter:runAction(cc.MoveBy:create(0.5,cc.p(-200,0)))
        self.top_ui.leisure_btn:runAction(cc.MoveBy:create(0.5,cc.p(0,200)))
        self.top_ui.leisure_btn:runAction(cc.MoveBy:create(0.5,cc.p(-200,0)))
        -- self.miniMap:runAction(cc.MoveBy:create(0.5,cc.p(300,0)))
        self.btn_seek:runAction(cc.MoveBy:create(0.5,cc.p(-200,0)))
        self.FileNode_2:runAction(cc.MoveBy:create(0.5,cc.p(150,0)))
        self.FileNode_3:runAction(cc.MoveBy:create(0.5,cc.p(-200,0)))
        self.btn_skill:runAction(cc.MoveBy:create(0.5,cc.p(-200,0)))
        self.btn_state:runAction(cc.MoveBy:create(0.5,cc.p(-200,0)))        
        self.btn_boss:runAction(cc.MoveBy:create(0.5,cc.p(150,0)))
        self.taskJumpBoard:runAction(cc.MoveBy:create(0.5,cc.p(450,0)))        
    end

    return self.isHide_carWar
    
    -- self.FileNode_5:runAction(cc.MoveBy:create(0.5,cc.p(-150,0)))
    -- self.attactInfoBoard:runAction(cc.MoveBy:create(0.5,cc.p(-300,0)))
end

function UIWorldPanel:changeToLineMap()

    if self.isHide_carWar then return end

    self.isLineMap = not self.isLineMap

    if self.isLineMap then

        self.noUnionHint:hideHint()
        self:checkUnionRedBag()
        gsound.stopEffect("city_click")
        gevent:call(gsound.EV_ON_PLAYSOUND,"world_mapzoomIn")

        if WCONST.WORLD_CFG.IS_3D then
    
            local rotation = self.m_scrollView:getRotation3D()
            -- self.m_scrollView:setRotation3D(cc.vec3(0,rotation.y,rotation.z))

            self.m_scrollView:stopAllActions()
            self.m_scrollView:runAction(cc.EaseInOut:create(cc.RotateTo:create(0.5,cc.vec3(0,rotation.y,rotation.z)),2))
        end    

        self.mapPanel:closeChoose()

        self.icon:setSpriteFrame("ui_surface_icon/map_narrow.png")

        self.m_scrollView:setMinScale(0.45)

        local node = cc.Node:create()
        node:setScale(self.m_scrollView:getZoomScale())
        self.m_scrollView:addChild(node)

        node:runAction(cc.Sequence:create(cc.EaseInOut:create(cc.ScaleTo:create(0.5,0.50),2),cc.RemoveSelf:create()))
        node:runAction(cc.Repeat:create(cc.Sequence:create(cc.CallFunc:create(function()
            
            self.m_scrollView:setZoomScale(node:getScale())
        end),cc.DelayTime:create(1 / 60)),998))        

        self.bot_ui:runAction(cc.MoveBy:create(0.5,cc.p(0,-200)))
        self.top_ui:runAction(cc.MoveBy:create(0.5,cc.p(0,200)))
        self.top_ui.ad_enter:runAction(cc.MoveBy:create(0.5,cc.p(0,-200)))
        self.top_ui.ad_enter:runAction(cc.MoveBy:create(0.5,cc.p(200,0)))
        self.top_ui.leisure_btn:runAction(cc.MoveBy:create(0.5,cc.p(0,-200)))
        self.top_ui.leisure_btn:runAction(cc.MoveBy:create(0.5,cc.p(200,0)))
        self.miniMap:runAction(cc.MoveBy:create(0.5,cc.p(300,0)))
        self.btn_seek:runAction(cc.MoveBy:create(0.5,cc.p(200,0)))
        self.FileNode_2:runAction(cc.MoveBy:create(0.5,cc.p(-150,0)))
        self.FileNode_3:runAction(cc.MoveBy:create(0.5,cc.p(200,0)))
        self.btn_skill:runAction(cc.MoveBy:create(0.5,cc.p(200,0)))
        self.btn_troops:runAction(cc.MoveBy:create(0.5,cc.p(200,0)))        
        self.btn_boss:runAction(cc.MoveBy:create(0.5,cc.p(-150,0)))
        self.taskJumpBoard:runAction(cc.MoveBy:create(0.5,cc.p(-450,0)))        
        -- self.FileNode_5:runAction(cc.MoveBy:create(0.5,cc.p(-150,0)))
        self.attactInfoBoard:runAction(cc.MoveBy:create(0.5,cc.p(-300,0)))
        self.mapPanel.attackEffectNode:setVisible(false)
        self.mapPanel.battleNode:setVisible(false)
        self.mapPanel.armyNode:setVisible(false)
        self.mapPanel.roadNode:setVisible(false)
        self.mapPanel.wayNode:setVisible(false)         

        uiMgr:addSceneModel(0.5)

        global.g_worldview.worldCityMgr:getRoadNode():setVisible(false)

        self:drawMap()
        -- self.btn_state:runAction(cc.MoveBy:create(0.5,cc.p(0,-270)))
    else


        gsound.stopEffect("city_click")
        gevent:call(gsound.EV_ON_PLAYSOUND,"world_mapzoomOut")

        self.icon:setSpriteFrame("ui_surface_icon/map_enlarge.png")

        local node = cc.Node:create()
        node:setScale(self.m_scrollView:getZoomScale())
        self.m_scrollView:addChild(node)

        if WCONST.WORLD_CFG.IS_3D then
    
            local rotation = self.m_scrollView:getRotation3D()
            -- self.m_scrollView:setRotation3D(cc.vec3(-25,rotation.y,rotation.z))

            self.m_scrollView:stopAllActions()
            self.m_scrollView:runAction(cc.EaseInOut:create(cc.RotateTo:create(0.5,cc.vec3(-25,rotation.y,rotation.z)),2))
        end

        node:runAction(cc.Sequence:create(cc.EaseInOut:create(cc.ScaleTo:create(0.5,0.95),2),cc.CallFunc:create(function( ... )
            -- body
                self.m_scrollView:setMinScale(WCONST.WORLD_CFG.MIN_SCALE)
        end),cc.RemoveSelf:create()))
        node:runAction(cc.Repeat:create(cc.Sequence:create(cc.CallFunc:create(function()
            
            self.m_scrollView:setZoomScale(node:getScale())
        end),cc.DelayTime:create(1 / 60)),998))

        -- local childs = self.mapPanel:getAllCitys()
        -- for _,v in ipairs(childs) do

        --     v:changeToNormalMap()
        -- end

        local allChilds = self.mapPanel.mapObjNode:getChildren()

        for _,v in ipairs(allChilds) do

            v:changeToNormalMap()
        end

        if self.draw1 then
            self.draw1:removeFromParent()
            self.draw1 = nil
        end        

        self.bot_ui:runAction(cc.MoveBy:create(0.5,cc.p(0,200)))
        self.top_ui:runAction(cc.MoveBy:create(0.5,cc.p(0,-200)))
        self.top_ui.ad_enter:runAction(cc.MoveBy:create(0.5,cc.p(0,200)))
        self.top_ui.ad_enter:runAction(cc.MoveBy:create(0.5,cc.p(-200,0)))        
        self.top_ui.leisure_btn:runAction(cc.MoveBy:create(0.5,cc.p(0,200)))
        self.top_ui.leisure_btn:runAction(cc.MoveBy:create(0.5,cc.p(-200,0)))
        self.miniMap:runAction(cc.MoveBy:create(0.5,cc.p(-300,0)))
        self.btn_boss:runAction(cc.MoveBy:create(0.5,cc.p(150,0)))
        self.btn_seek:runAction(cc.MoveBy:create(0.5,cc.p(-200,0)))
        self.FileNode_3:runAction(cc.MoveBy:create(0.5,cc.p(-200,0)))
        self.FileNode_2:runAction(cc.MoveBy:create(0.5,cc.p(150,0)))
        self.btn_troops:runAction(cc.MoveBy:create(0.5,cc.p(-200,0)))   
        self.btn_skill:runAction(cc.MoveBy:create(0.5,cc.p(-200,0)))
        self.taskJumpBoard:runAction(cc.MoveBy:create(0.5,cc.p(450,0)))
        -- self.FileNode_5:runAction(cc.MoveBy:create(0.5,cc.p(150,0)))
        self.attactInfoBoard:runAction(cc.MoveBy:create(0.5,cc.p(300,0)))
        self.mapPanel.attackEffectNode:setVisible(true)
        self.mapPanel.battleNode:setVisible(true)
        self.mapPanel.armyNode:setVisible(true)
        self.mapPanel.roadNode:setVisible(true)
        self.mapPanel.wayNode:setVisible(true)        

        uiMgr:addSceneModel(0.5)

        global.g_worldview.worldCityMgr:getRoadNode():setVisible(true)

        self.drawTurn = self.drawTurn + 1
        -- self.btn_state:runAction(cc.MoveBy:create(0.5,cc.p(0,270)))
    end
end

function UIWorldPanel:isMainCityProtect()
    
    return self._isMainCityProtect,self._mainCityProtectEndTime
end


function UIWorldPanel:bossHandler(sender, eventType)

    local checkTrigger = function ()

        local trigger = luaCfg:get_buildings_pos_by(28)
        if global.cityData:checkTrigger(trigger.triggerId[1]) then
            return true
        else
            local triggerData = luaCfg:get_triggers_id_by(trigger.triggerId[1])
            local triggerBuilding = luaCfg:get_buildings_pos_by(triggerData.buildsId)
            local str = luaCfg:get_local_string(10043,triggerBuilding.buildsName,triggerData.triggerCondition, trigger.buildsName)
            global.tipsMgr:showWarning(str)
            return false
        end
    end
    if not checkTrigger() then
        return
    end
    global.panelMgr:openPanel("UIBossPanel")
end

function UIWorldPanel:seekHandler(sender, eventType)

    global.panelMgr:openPanel("UIWorldSearchPanel")
end

function UIWorldPanel:troopsHandler(sender, eventType)

    global.troopData:setTargetData(-1,0,global.userData:getWorldCityID())   
    global.troopData:setPageMode(1)
    global.panelMgr:openPanel("UITroopPanel")
end

function UIWorldPanel:kingHandler(sender, eventType)

    global.panelMgr:openPanel('UIOfficalPanel'):setData()
end

function UIWorldPanel:SkillHandler(sender, eventType)
    
    if global.petData:getPetActNum() == 0 then
        return global.tipsMgr:showWarning("petPrompt04")
    end
    global.panelMgr:openPanel("UIPetSkillUsePanel")

end
--CALLBACKS_FUNCS_END

function UIWorldPanel:getAttackQueue()

    return self.attactInfoBoard

end

return UIWorldPanel

--endregion
