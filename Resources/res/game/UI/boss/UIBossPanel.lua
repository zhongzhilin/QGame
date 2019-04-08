--region UIBossPanel.lua
--Author : yyt
--Date   : 2017/03/14
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local bossData = global.bossData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UINodeTop = require("game.UI.boss.Node.UINodeTop")
local UINodeBottom = require("game.UI.boss.Node.UINodeBottom")
--REQUIRE_CLASS_END

local UIBossPanel  = class("UIBossPanel", function() return gdisplay.newWidget() end )
local TabControl = require("game.UI.common.UITabControl")

function UIBossPanel:ctor()
    self:CreateUI()
end

function UIBossPanel:CreateUI()
    local root = resMgr:createWidget("boss/boss_bj")
    self:initUI(root)
end

function UIBossPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "boss/boss_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.ScrollView = self.root.ScrollView_export
    self.infoNode = self.root.ScrollView_export.infoNode_export
    self.Top = self.root.ScrollView_export.Top_export
    self.topNode = self.root.ScrollView_export.Top_export.topNode_export
    self.topNode = UINodeTop.new()
    uiMgr:configNestClass(self.topNode, self.root.ScrollView_export.Top_export.topNode_export)
    self.Bottom = self.root.ScrollView_export.Bottom_export
    self.botNode = self.root.ScrollView_export.Bottom_export.botNode_export
    self.botNode = UINodeBottom.new()
    uiMgr:configNestClass(self.botNode, self.root.ScrollView_export.Bottom_export.botNode_export)
    self.bossNode = self.root.ScrollView_export.bossNode_export
    self.title = self.root.title_export
    self.ml_title = self.root.title_export.ml_title_fnt_mlan_16_export
    self.starGate = self.root.starGate_export
    self.starNum = self.root.starGate_export.starNum_export
    self.chest_node = self.root.chest_node_export
    self.chest_levle = self.root.chest_node_export.chest_levle_export
    self.chest_bt_text = self.root.chest_node_export.chest_bt_text_export
    self.text = self.root.chest_node_export.chest_bt_text_export.text_mlan_6_export
    self.chest_bt_icon = self.root.chest_node_export.chest_bt_icon_export
    self.chesteffect = self.root.chest_node_export.chesteffect_export
    self.titleLayout = self.root.titleLayout_export
    self.topLayout = self.root.topLayout_export
    self.botLayout = self.root.botLayout_export
    self.infoLayout = self.root.infoLayout_export
    self.mapLayout = self.root.mapLayout_export
    self.limit = self.root.limit_export
    self.bossPoint = self.root.limit_export.bossPoint_export
    self.strengthNode = self.root.strengthNode_export
    self.strengthBtn = self.root.strengthNode_export.strengthBtn_export
    self.strengthCardNum = self.root.strengthNode_export.strengthBtn_export.strengthCardNum_export
    self.strengthBuy = self.root.strengthNode_export.strengthBuy_export

    uiMgr:addWidgetTouchHandler(self.root.title_export.intro_btn, function(sender, eventType) self:onHelp(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.chest_bt_text, function(sender, eventType) self:click_Chest_info(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.chest_bt_icon, function(sender, eventType) self:click_Chest(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.strengthBtn, function(sender, eventType) self:strengthHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.strengthBuy, function(sender, eventType) self:strengthHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.scrHeight = self.ScrollView:getContentSize().height

    self.topOffsetNode = cc.Node:create()
    self.ScrollView:addChild(self.topOffsetNode)

    self.ScrollView:addEventListener(function()
        self:scrollEvent()
    end)  

    self.tabControl = TabControl.new(self.limit, handler(self, self.onTabButtonChanged), 1,
        cc.c3b(151, 106, 64), cc.c3b(255, 208, 65))

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIBossPanel:checkBossPoint()

    -- body
    self.bossPoint:setVisible(false)
    local checkReward = function (index)
        -- body
        local chest = global.bossData:getCurrentShowChest(index)
        if chest and chest.canopen then
            self.bossPoint:setVisible(true)
        end
    end
    checkReward(2) -- 极限boss

    -- 极限boss第一次开启时显示红点
    local isFirstOpen = cc.UserDefault:getInstance():getStringForKey("BOSS_FIRST_OPEN"..global.userData:getUserId())
    local curStar, maxStar = global.bossData:getStarNum()
    local openNeedStar = global.luaCfg:get_config_by(1).EliteBossStar
    if isFirstOpen == "" and curStar >= openNeedStar then
        self.bossPoint:setVisible(true)
    end
end

-- 1 普通boss 2极限boss
function UIBossPanel:onTabButtonChanged(index)

    local curStar, maxStar = bossData:getStarNum()
    local openNeedStar = luaCfg:get_config_by(1).EliteBossStar
    if curStar < openNeedStar and index == 2 then
        return global.tipsMgr:showWarning("limitBoss01", openNeedStar)
    end

    self.defalutIndex = index
    self:setData()

    -- 去除第一次开启红点
    if index == 2 then
        cc.UserDefault:getInstance():setStringForKey("BOSS_FIRST_OPEN"..global.userData:getUserId(), "true")
        self:checkBossPoint()
        gevent:call(global.gameEvent.EV_ON_BOSS_POINT)
    end
end

function UIBossPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIBossPanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
    self.defalutIndex = nil
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIBossPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIBossPanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIBossPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIBossPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

--nodelist里的node是一个空node，为了计算位置
function UIBossPanel:scrollEvent()
    
    self.isStartMove = true
    local topY = self.topOffsetNode:getPositionY()
    local offsetY = self.topOffsetNode:convertToWorldSpace(cc.p(0,0)).y    
    local itemH = self.infoLayout:getContentSize().height

    self.nodeList = self.nodeList or {}
    for _,v in pairs(self.nodeList) do

        local y = (v:getPositionY() - topY) + offsetY        

        if y > -itemH and y < gdisplay.height + itemH then

            if v.item == nil then

                local item = self:getInfoNode(v.lType)
                if v.lType > 3 then 
                    item:setData(v.data)
                end
                item:setPosition(v:getPosition())          
                v.item = item
            end 
        else

            if v.item then
                self:cleanInfoNode(v.item)
                v.item = nil
            end
        end
    end
end

-------------------- 复用机制 ---------------------

--取出一个node
function UIBossPanel:getInfoNode(lType)
    
    local item = self:popMap(lType)
    if item then
        
        item:setVisible(true)        
        return item
    else
        local item = nil
        if lType < 4 then
            if lType < 0 then
                lType = math.abs(lType) + 3
            end
            item =  require("game.UI.boss.map.UIMap"..lType).new()
            self.infoNode:addChild(item)
        else
            lType = lType - 3
            item = require("game.UI.boss.Node.UINode"..lType).new()
            item:setTag(1010)
            self.bossNode:addChild(item)
        end         
        return item
    end    
end

--infocache里记录的是node
--从cache里拿出一个type的node
function UIBossPanel:popMap(lType)
    
    for i,v in ipairs(self.infoCache) do
        if v.lType == lType then            
            table.remove(self.infoCache,i)
            return v
        end
    end
    return nil
end

function UIBossPanel:cleanInfoNode(item)

    item:setVisible(false)
    table.insert(self.infoCache,item)
end

-------------------- 复用机制 ---------------------

function UIBossPanel:onEnter()

    self.isPageMove = false
    self:registerMove()
    
    self.tabControl:setSelectedIdx(1)
    self:onTabButtonChanged(1)
    self:scrollEvent()

    self:addEventListener(global.gameEvent.EV_ON_UI_BOSS_REFERSHITEM, function (event, msg)
        self:setData()
    end)
    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME,function ()
        global.bossData:resumeGate()
    end)

    self:addEventListener(global.gameEvent.EV_ON_BOSS_POINT, function (event, msg)
        if self.checkBossPoint then
            self:checkBossPoint()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_USER_UPDATE,function()
        if self.checkBossEnergy then
            self:checkBossEnergy()
        end
    end)

end

function UIBossPanel:setData()

    self.ml_title:setString(luaCfg:get_local_string(10992+self.defalutIndex))
    
    self.infoNode:removeAllChildren()
    self.bossNode:removeAllChildren()
    self.nodeList = {}
    self.infoCache = {}

    -- 获取图块和boss节点
    local roundNum = bossData:getRound(self.defalutIndex)
    local bosMidData  = bossData:getBosMidData(self.defalutIndex)
    local mapData  = bossData:getMap(self.defalutIndex)

    local sH = self.infoLayout:getContentSize().height
    local mapH = self.mapLayout:getContentSize().height
    local topH = self.topLayout:getContentSize().height
    local botH = self.botLayout:getContentSize().height

    local contentSize = gdisplay.height -  self.titleLayout:getContentSize().height
    local containerSize = (mapH*3)*roundNum + topH + botH
    if contentSize > containerSize then
        containerSize = contentSize
    end
    self.ScrollView:setContentSize(cc.size(gdisplay.width, contentSize))
    self.ScrollView:setInnerContainerSize(cc.size(gdisplay.width, containerSize))
    self.ScrollView:setPosition(cc.p(0, 0))

    -- 顶底块初始化
    self.Top:setPositionY(containerSize)
    self.Bottom:setPositionY(0)
    self.botNode:setData(bossData:getDataByType(-1, self.defalutIndex))
    self.topNode:setData(bossData:getDataByType(-2, self.defalutIndex))

    local picBgTop = {
        [1] = "boss_bj2.jpg",
        [2] = "tboss_bj2.jpg",
    }
    local picBgBot = {
        [1] = "boss_bj1.jpg",
        [2] = "tboss_bj1.jpg",
    }
    self.Top.top:setSpriteFrame(picBgTop[self.defalutIndex])
    self.Bottom.bottom:setSpriteFrame(picBgBot[self.defalutIndex])


    self.topOffsetNode:setPositionY(containerSize)
    local py = self.Bottom:getPositionY() + botH 

    -- 地图块
    for i=1,(#mapData) do
        
        local node = cc.Node:create()
        node:setPosition(cc.p(0, py + mapH*(i-1)))   
        node.lType =  self.defalutIndex == 1 and mapData[i] or (0-mapData[i])
        node.index = i
        self.infoNode:addChild(node)
        table.insert(self.nodeList,node)
    end

    -- boss
    for i=1,(#bosMidData) do
        
        local nodeBoss = cc.Node:create()
        nodeBoss:setPosition(cc.p(0, py + sH*(i-1)))                
        nodeBoss.lType = bosMidData[i].lType
        nodeBoss.data = bosMidData[i].data
        self.bossNode:addChild(nodeBoss)
        table.insert(self.nodeList,nodeBoss)
    end

    -- 普通boss关卡显示星星
    self.starGate:setVisible(self.defalutIndex == 1)
    local curStar, maxStar = bossData:getStarNum()
    self.starNum:setString(curStar.."/"..maxStar)

    local openNeedStar = luaCfg:get_config_by(1).EliteBossStar
    if curStar < openNeedStar then 
        self.tabControl:setEnabledIndex(2)
    else
        self.tabControl:setEnabledIndex(nil)
    end

    self:adjustScroPos()
    bossData:setFirstInit(self.defalutIndex)    

    self:setChest()
    self:checkBossPoint()

    self:checkBossEnergy()
end

function UIBossPanel:checkBossEnergy()
    local maxGateEnergy = luaCfg:get_lord_exp_by(global.userData:getLevel()).bossNum
    self.strengthCardNum:setString(global.userData:getGateEnergy() .. "/" .. maxGateEnergy)
end

function UIBossPanel:setChest()
    
   local chest =  bossData:getCurrentShowChest(self.defalutIndex)

    if chest then 
       local level = string.format(global.luaCfg:get_localization_by(10486).value,chest.gate.lv)
       self.chest_levle:setString(level)
        self.chest_node:setVisible(true) 
       self:setChestEffect(chest.canopen)
    else
        self.chest_node:setVisible(false) 
        self.chest_bt_text:setTouchEnabled(false)
        self.chest_bt_icon:setTouchEnabled(false)
    end 
end

function UIBossPanel:setChestEffect(status)
    if status then
        self.chesteffect:setVisible(true)
        self.chesteffect:stopAllActions()
        local nodeTimeLine =resMgr:createTimeline("effect/bx_light_boss")
        self.chesteffect:runAction(nodeTimeLine)
        nodeTimeLine:play("animation0",true)
    else
        self.chesteffect:stopAllActions()
        self.chesteffect:setVisible(false)
    end 
end

function UIBossPanel:gpsAndOpenItem(curGpsId)
    -- body

    local gateData = luaCfg:get_gateboss_by(curGpsId)
    if gateData then 
        self.tabControl:setSelectedIdx(gateData.Elite)
        self:onTabButtonChanged(gateData.Elite)
    end 

    self:adjustScroPos(curGpsId)
    local bosMonPanel = global.panelMgr:openPanel("UIBosMonstPanel")
    bosMonPanel.isBossItem = true
    bosMonPanel:setData(global.bossData:getDataById(curGpsId))
end

function UIBossPanel:adjustScroPos(curGpsId)

    self.ScrollView:jumpToBottom() 

    local curFinishId = curGpsId or global.bossData:getCurUnlockBoss(self.defalutIndex)
    -- curPos  当前图块位置
    local curPos, curType, curIndex = 0, 0, 0
    for i,v in ipairs(self.nodeList) do

        if v.data then
            for k,value in ipairs(v.data) do
                if value.id == curFinishId then

                    curPos = v:getPositionY()
                    curType  = v.lType
                    curIndex = k
                    break
                end
            end
        end
        if curPos ~= 0 then break end 
    end
  
    -- -- 当前关卡所在图块偏移
    local scroH = self.ScrollView:getInnerContainerSize().height
    local gOffset = gdisplay.height/2 
    local totalY = curPos - 100 
    local per = (1 - totalY/scroH)*100
    -- 定位到完成关卡的节点位置, 以便于下拿到相应复用item的数据信息
    self.ScrollView:setInnerContainerPosition(cc.p(0, -totalY))

    local itemPosY = 0
    local allItem = self.bossNode:getChildren()
    for _,v in pairs(allItem) do
        if v:getTag() == 1010 then
            
            for _,vv in pairs(v.data) do
                if vv.id == curFinishId then
                    local itemMonster = v["monster"..curIndex]
                    if itemMonster then
                        itemPosY = itemMonster:convertToWorldSpace(cc.p(0, 0)).y 
                    end
                end
            end
        end
    end

    local offsetY = gOffset - itemPosY
    local curOffset = self.ScrollView:getInnerContainerPosition()
    if offsetY < 0 then
        offsetY = curOffset.y - math.abs(offsetY)
    else
        offsetY = curOffset.y + offsetY
    end

    -- 最大最小偏移
    local offsetBottom = 0
    local offsetTop = -(scroH - gdisplay.height + self.titleLayout:getContentSize().height)
    
    if (offsetY > offsetTop) and (offsetY < offsetBottom) then
        self.ScrollView:setInnerContainerPosition(cc.p(curOffset.x, offsetY))
    else
        if offsetY >= offsetBottom then
            self.ScrollView:setInnerContainerPosition(cc.p(0, offsetBottom))
        end
        if offsetY <= offsetTop then
            self.ScrollView:setInnerContainerPosition(cc.p(0, -offsetTop))
        end
    end
end

function UIBossPanel:exit_call()
    global.panelMgr:closePanelForBtn("UIBossPanel")
end

function UIBossPanel:onHelp(sender, eventType)

    local data = luaCfg:get_introduction_by(14)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end

function UIBossPanel:click_Chest_info(sender, eventType)
    local chest = bossData:getCurrentShowChest(self.defalutIndex)
    global.panelMgr:openPanel("UIDailyTaskRewardPanel"):setBossData(chest.dropid,chest.canopen,chest.gate.id,handler(self,self.setChest))
end

function UIBossPanel:click_Chest(sender, eventType)
    local chest = bossData:getCurrentShowChest(self.defalutIndex)
    global.panelMgr:openPanel("UIDailyTaskRewardPanel"):setBossData(chest.dropid,chest.canopen,chest.gate.id,handler(self,self.setChest))
end

function UIBossPanel:strengthHandler(sender, eventType)
    self:dealCall()
end

function UIBossPanel:strengthHandler(sender, eventType)
    self:dealCall()
end

function UIBossPanel:dealCall()
    global.panelMgr:openPanel("UIBossEnergyPanel"):setData()
end

--CALLBACKS_FUNCS_END

return UIBossPanel

--endregion
