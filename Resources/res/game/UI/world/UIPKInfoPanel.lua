--region UIPKInfoPanel.lua
--Author : yyt
--Date   : 2016/11/14
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local funcGame = global.funcGame
local UITableView = require("game.UI.common.UITableView")
local UIPKItemCell = require("game.UI.world.UIPKItemCell")
local UIAttackBoard = require("game.UI.world.widget.UIAttackBoard")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPKInfoMenu = require("game.UI.world.UIPKInfoMenu")
--REQUIRE_CLASS_END

local UIPKInfoPanel  = class("UIPKInfoPanel", function() return gdisplay.newWidget() end )

function UIPKInfoPanel:ctor()
    self:CreateUI()
end

function UIPKInfoPanel:CreateUI()
    local root = resMgr:createWidget("world/info/city_pk")
    self:initUI(root)
end

function UIPKInfoPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/info/city_pk")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.titleNode = self.root.titleNode_export
    self.cityIcon = self.root.nodeInfo.cityIcon_export
    self.info = self.root.nodeInfo.info_export
    self.timeB = self.root.nodeInfo.timeB_export
    self.timeL = self.root.nodeInfo.timeL_export
    self.attack_node = self.root.nodeInfo.attack_node_export
    self.att_btn = self.root.nodeInfo.att_btn_export
    self.ATitleNode = self.root.ATitleNode_export
    self.ATitleNode = UIPKInfoMenu.new()
    uiMgr:configNestClass(self.ATitleNode, self.root.ATitleNode_export)
    self.DTitleNode = self.root.DTitleNode_export
    self.DTitleNode = UIPKInfoMenu.new()
    uiMgr:configNestClass(self.DTitleNode, self.root.DTitleNode_export)
    self.AUpNode = self.root.AUpNode_export
    self.ABottomNode = self.root.ABottomNode_export
    self.DNode = self.root.DNode_export
    self.AContentLayout = self.root.AContentLayout_export
    self.aItemLayout = self.root.AContentLayout_export.aItemLayout_export
    self.DContentLayout = self.root.DContentLayout_export

    uiMgr:addWidgetTouchHandler(self.root.nodeInfo.share_btn, function(sender, eventType) self:callHelp_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.att_btn, function(sender, eventType) self:att_call(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.titleNode.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableViewA = UITableView.new()
        :setSize(self.AContentLayout:getContentSize(), self.AUpNode, self.ABottomNode)
        :setCellSize(self.aItemLayout:getContentSize())
        :setCellTemplate(UIPKItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self:addChild(self.tableViewA)

    self.tableViewD = UITableView.new()
        :setSize(self.DContentLayout:getContentSize(), self.DNode)
        :setCellSize(self.aItemLayout:getContentSize())
        :setCellTemplate(UIPKItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self:addChild(self.tableViewD)

    self.cityId = 0
    self.m_restTime = 0
    self.attack_node:setLocalZOrder(1)

    self.tips_node = cc.Node:create()
    self:addChild(self.tips_node)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPKInfoPanel:onEnter()
    
    self.defCityName = ""
    self:initEventListener()
end

function UIPKInfoPanel:initEventListener()
    
    local callBB1 = function(eventName)
        self:refershCall()
    end
    self:addEventListener(global.gameEvent.EV_ON_FIGHT_CHANGE,callBB1)
end

function UIPKInfoPanel:setData(city, cityData)

    self.city = city
    self.cityId = city:getId()
    self.cityName = city:getName()

    self.isPlayer = city.isPlayer and city:isPlayer()
    self.isWildRes = city.isWildRes
    self.isWildObj = city.isWildObj
    self.isWorldBoss = city.isBoss and city:isBoss()

    -- 是否是资源野地
    self.isWild = false
    if city.getSurfaceData and city:getSurfaceData() then
        self.isWild = city:getSurfaceData().type == 101 
    end

    if cityData.type == 102 then
        -- self.cityIcon:setSpriteFrame( cityData.uimap)
        global.panelMgr:setTextureFor(self.cityIcon,cityData.uimap)
    else

        local cityIconData = nil
        if city.getCityIconPath then
            cityIconData = city:getCityIconPath()
        end

        if cityIconData then
            global.panelMgr:setTextureFor(self.cityIcon,cityIconData.worldmap)
        else
            global.panelMgr:setTextureFor(self.cityIcon,cityData.worldmap)
            -- self.cityIcon:setSpriteFrame( cityData.worldmap)
        end        
        -- self.cityIcon:setSpriteFrame( cityData.worldmap)
    end

    self.cityIcon:setScale(cityData.iconSize)

    self.root.nodeInfo.share_btn:setVisible(false)

    self:refershCall()

    self.ATitleNode:setData(1)
    self.DTitleNode:setData(2)

    self.att_btn:setVisible(self.city.isCity and self.city:isPlayer())
end

function UIPKInfoPanel:refershCall()

    global.worldApi:infoBattle(function(msg)

        if not self.setBattleInfo then return end
        if msg.lefttime and msg.lefttime > 0 then
            self.sznameId = msg.szname
            self:setBattleInfo(msg)
        else
            self:exit_call()
            global.tipsMgr:showWarning("Endbattle")
            return
        end
    end, self.cityId)

end

function UIPKInfoPanel:getWildKind()
    
    if not self.data.lWildKind then
        return 0
    end
    return self.data.lWildKind
end

function UIPKInfoPanel:getAllName()
    
    return self.data.szname
end

function UIPKInfoPanel:getSzName()
    
    return self.dataSzname
end

function UIPKInfoPanel:setBattleInfo(data)
    if data == nil then return end


    -- 获取最近选择的大地图形象名称
    self.dataSzname = data.szname
    data.szname =  self.cityName

    self.data = data
    if data.tgatktroop then
        local tgatktroop = self:addType(data.tgatktroop, 0)
        self.tableViewA:setData(tgatktroop)

        local troopScale =  data.lAtkPower --self:getTroopScale(data.tgatktroop)
        if troopScale > 0 then
            self.ATitleNode.scale:setString( troopScale )
        else
            self.ATitleNode.scale:setString("-")
        end
    else
        self.ATitleNode.scale:setString("-")
        self.tableViewA:setData({})
    end
    if data.tgdeftroop then
        local tgdeftroop = self:addType(data.tgdeftroop, 1)
        self.tableViewD:setData(tgdeftroop)

        local troopScale = data.lDefPower --self:getTroopScale(data.tgdeftroop)
        if troopScale > 0 then
            self.DTitleNode.scale:setString( troopScale )
        else
            self.DTitleNode.scale:setString("-")
        end
        
    else
        self.DTitleNode.scale:setString("-")
        self.tableViewD:setData({})
    end

    -- local city = global.g_worldview.worldPanel:getWorldMapPanel():getCityOrMiracleById(self.cityId)
    -- print(">>>ciysi",city)
    -- if city and not global.unionData:isMineUnion(0) then

    --     if city.isWildRes then

    --         print(">>>ciysi")
    --        self.root.nodeInfo.share_btn:setVisible(city:isMiracle())
    --     else
    --         self.root.nodeInfo.share_btn:setVisible(city:isPlayer())
    --     end
    -- else
    --     self.root.nodeInfo.share_btn:setVisible(false)
    -- end
    
    print(self.data.lPartyLeader,self.data.lWarSupport)

    if (self.data.lPartyLeader and self.data.lPartyLeader > 0 ) and (not self.data.lWarSupport or self.data.lWarSupport<=0) and (not  self.isWild) then
        self.root.nodeInfo.share_btn:setVisible(true)
    else
        self.root.nodeInfo.share_btn:setVisible(false)
    end

    self:initInfo(data)
end

function UIPKInfoPanel:addType(data, type)

    local typeData = {}
    for _,v in pairs(data) do
        v.type = type
    end
    typeData = clone(data)
    return typeData
end

function UIPKInfoPanel:getTroopScale( troopData )
    
    local scaleNum = 0
    for _,v in pairs(troopData) do
        
        scaleNum = scaleNum + v.ltroopsize
    end
    return scaleNum
end

function UIPKInfoPanel:getWorldBoss()
    -- body
    return self.isWorldBoss 
end

function UIPKInfoPanel:initInfo(data)

    local pos = global.g_worldview.const:converPix2Location(cc.p(data.lposx, data.lposy))
    if data.szname and (not self.isPlayer) then
        
        local fightType = 0
        if self.isWildRes then
            fightType = 2
        elseif self.isWildObj then
            fightType = 3
        else
            fightType = 5
        end

        if self.isWorldBoss then
            fightType = 9
        end

        local rwData = global.mailData:getDataByType(fightType, tonumber(self.sznameId))
        if not rwData then
            self.info:setString(luaCfg:get_local_string(10106, data.szname, pos.x, pos.y))
            self.defCityName = data.szname
        else
            self.info:setString(luaCfg:get_local_string(10106, rwData.name, pos.x, pos.y))
            self.defCityName = rwData.szname
        end

    else
        self.defCityName = data.szname
        self.info:setString(luaCfg:get_local_string(10106, data.szname, pos.x, pos.y))
    end

    if data.larrived then
        local tBegan = funcGame.formatTimeToTime(data.larrived)
        self.timeB:setString(luaCfg:get_local_string( 10017 , tBegan.hour, tBegan.minute, tBegan.second ))
    end

    if data.lefttime and data.lefttime > 0 then
        self.m_restTime = data.lefttime 
        self:cutTimeHandler()
        if self.m_countDownTimer then
        else
            self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.cutTimeHandler), 1)
        end
    end

end

function UIPKInfoPanel:cutTimeHandler()

    if not self.m_restTime then 
        --报错处理 
        return 
    end 

    if self.m_restTime < 0 then 
        self:exit_call()
        global.tipsMgr:showWarning("Endbattle")
        return
    end

    local str = global.troopData:timeStringFormat(self.m_restTime)
    self.timeL:setString(str)

    self.m_restTime = self.m_restTime -  1
end

-- lPartyLeader = 12;  //0无 1：进攻 2：防御
function UIPKInfoPanel:callHelp_click(sender, eventType)
    local function call(lWarSupport)
        self.data.lWarSupport = lWarSupport
        self.root.nodeInfo.share_btn:setVisible(false)
    end
    if self.data.lPartyLeader and self.data.lPartyLeader == 1 then
        global.panelMgr:openPanel("UIUWarAtkChoicePanel"):setData(self.data.lmapid,call, self.defCityName)
    elseif self.data.lPartyLeader and self.data.lPartyLeader == 2 then
        global.panelMgr:openPanel("UIUWarDefChoicePanel"):setData(self.data.lmapid,call)
    end
end

function UIPKInfoPanel:exit_call(sender, eventType)
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
    global.panelMgr:closePanelForBtn("UIPKInfoPanel")
    if global.panelMgr:isPanelOpened("UIUWarAtkChoicePanel") then
        global.panelMgr:closePanel("UIUWarAtkChoicePanel")
    end
    if global.panelMgr:isPanelOpened("UIUWarDefChoicePanel") then
        global.panelMgr:closePanel("UIUWarDefChoicePanel")
    end
end

function UIPKInfoPanel:att_call(sender, eventType)

    global.g_worldview.worldPanel.chooseCityId = self.cityId

    local attackBoard = UIAttackBoard.new()
    attackBoard:changeSharpPos(false,true)
    attackBoard:setCity(self.city)
    self.attack_node:addChild(attackBoard)
    self.attackBoard = attackBoard
    self.attackBoard.root.Node_1.Image_2:setPositionX(280)
    self.attackBoard.root.Node_1.Image_2:setFlippedX(true)
end


function UIPKInfoPanel:onEnter()
    if self.attackBoard and not tolua.isnull(self.attackBoard) then
        self.attackBoard:close()
        self.attackBoard = nil
    end
end

--CALLBACKS_FUNCS_END

return UIPKInfoPanel

--endregion
