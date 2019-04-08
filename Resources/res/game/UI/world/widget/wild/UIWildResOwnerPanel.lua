--region UIWildResOwnerPanel.lua
--Author : wuwx
--Date   : 2016/11/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
local UIWildResPro = require("game.UI.world.widget.wild.UIWildResPro")
local UIWildSoldier = require("game.UI.world.widget.wild.UIWildSoldier")
--REQUIRE_CLASS_END
local UIAttackBoard = require("game.UI.world.widget.UIAttackBoard")

local UIWildResOwnerPanel  = class("UIWildResOwnerPanel", function() return gdisplay.newWidget() end )

function UIWildResOwnerPanel:ctor()
    self:CreateUI()
end

function UIWildResOwnerPanel:CreateUI()
    local root = resMgr:createWidget("wild/wild_ziyuan_bj2")
    self:initUI(root)
end

function UIWildResOwnerPanel:setObj(obj)
    
    self.obj = obj
end

function UIWildResOwnerPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_ziyuan_bj2")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.Node = self.root.Node_export
    self.close_node = self.root.Node_export.close_node_export
    self.close_node = CloseBtn.new()
    uiMgr:configNestClass(self.close_node, self.root.Node_export.close_node_export)
    self.name = self.root.Node_export.name_export
    self.FileNode_1 = UIWildResPro.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.FileNode_1)
    self.combat = self.root.Node_export.combat_mlan_10.combat_export
    self.arms = self.root.Node_export.arms_mlan_5.arms_export
    self.collection = self.root.Node_export.collection_export
    self.attack = self.root.Node_export.attack_export
    self.d1 = UIWildSoldier.new()
    uiMgr:configNestClass(self.d1, self.root.Node_export.recruit_title.d1)
    self.d2 = UIWildSoldier.new()
    uiMgr:configNestClass(self.d2, self.root.Node_export.recruit_title.d2)
    self.d3 = UIWildSoldier.new()
    uiMgr:configNestClass(self.d3, self.root.Node_export.recruit_title.d3)
    self.d4 = UIWildSoldier.new()
    uiMgr:configNestClass(self.d4, self.root.Node_export.recruit_title.d4)
    self.a1 = UIWildSoldier.new()
    uiMgr:configNestClass(self.a1, self.root.Node_export.recruit_title_0.a1)
    self.a2 = UIWildSoldier.new()
    uiMgr:configNestClass(self.a2, self.root.Node_export.recruit_title_0.a2)
    self.a3 = UIWildSoldier.new()
    uiMgr:configNestClass(self.a3, self.root.Node_export.recruit_title_0.a3)
    self.a4 = UIWildSoldier.new()
    uiMgr:configNestClass(self.a4, self.root.Node_export.recruit_title_0.a4)
    self.attack_detail = self.root.Node_export.attack_detail_export

    uiMgr:addWidgetTouchHandler(self.collection, function(sender, eventType) self:collectionHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack, function(sender, eventType) self:militaryHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.intro_btn, function(sender, eventType) self:infoCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_1, function(sender, eventType) self:shareHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.close_node:setData(function ()
        global.panelMgr:closePanel("UIWildResOwnerPanel")
    end)

    self:initTouch()
end
function  UIWildResOwnerPanel:close_call(sender, eventType)
    global.panelMgr:closePanel("UIWildResOwnerPanel")
end

function UIWildResOwnerPanel:onExit()
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")
end 

function UIWildResOwnerPanel:initTouch()
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(function(touch, event)
        -- body
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(function(touch, event)
        self:onCloseHandler()
    end, cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self.touch)
end

function UIWildResOwnerPanel:onEnter()
    if self.attackBoard and not tolua.isnull(self.attackBoard) then
        self.attackBoard:close()
        self.attackBoard = nil
    end
end

function UIWildResOwnerPanel:onCloseHandler()
    global.panelMgr:closePanel("UIWildResOwnerPanel")
end

function UIWildResOwnerPanel:setData(data)
    self.data = data
    self.designerData = luaCfg:get_wild_res_by(data.lKind)
    local pos = global.g_worldview.const:converPix2Location(cc.p(self.data.lPosX, self.data.lPosY))

    self.combat:setString(self.designerData.combat)
    self.combat:getParent():setLocalZOrder(1)
    self.arms:getParent():setLocalZOrder(1)

    self.name:setString(string.format("%s(%s,%s)",self.designerData.name,pos.x,pos.y))

    --润稿翻译处理 张亮

    global.tools:adjustNodePosForFather(self.combat:getParent(),self.combat)
    global.tools:adjustNodePosForFather(self.arms:getParent(),self.arms)


    -- self.FileNode_1:setData(self.data,self.designerData)

    global.g_worldview.worldPanel.chooseCityId = self.data.lResID
    global.g_worldview.worldPanel.chooseCityName = self.designerData.name

    self.FileNode_1:setOverCall(handler(self,self.hpOver))
    self.FileNode_1:setData(self.data,self.designerData)


    self.arms:setString(luaCfg:get_local_string(self.designerData.wartype + 10684))

    local attackS = self.data.tagAtkSoldiers or {}
    for i = 1,4 do
        if attackS[i] then
            self["a"..i]:setVisible(true)
            self["a"..i]:setData(attackS[i])
        else
            self["a"..i]:setVisible(false)
        end
    end

    local defS = self.data.tagDefSoldiers or {}
    for i = 1,4 do
        if defS[i] then
            self["d"..i]:setVisible(true)
            self["d"..i]:setData(defS[i])
        else
            self["d"..i]:setVisible(false)
        end
    end
end

function UIWildResOwnerPanel:hpOver()
    self:onCloseHandler()
    global.tipsMgr:showWarning("ResVillageDis")
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIWildResOwnerPanel:collectionHandler(sender, eventType)
    local cityId = self.data.lResID
    if global.collectData:checkCollect(cityId) then

        local tempData = {}
        tempData.lMapID = self.designerData.file
        tempData.lPosX = self.data.lPosX
        tempData.lPosY = self.data.lPosY
        tempData.szName = self.designerData.name

        local collectPanel = global.panelMgr:openPanel("UICollectPanel") 
        collectPanel:setData( cityId, tempData)
    else
        global.tipsMgr:showWarning("Collectionend")
    end
end

function UIWildResOwnerPanel:militaryHandler(sender, eventType)
    

    local lv = self.designerData.level
    local resLevel = global.userData:getResLevel()
    local resLevelData = luaCfg:get_map_unlock_by(resLevel)

    if lv > resLevelData.MaxLv then
        local map_unlocks = luaCfg:map_unlock()
        for _,v in ipairs(map_unlocks) do
            if lv <= v.MaxLv then            
                global.tipsMgr:showWarning('499',v.KeyLv)
                return
            end
        end
    end
    
    local openCall = function()
        local attackBoard = UIAttackBoard.new()
        attackBoard:setCity(self.obj,self.designerData.energy)
        attackBoard:changeSharpPos()
        attackBoard:setTargetCombat(self.designerData.combat)
        self.attack_detail:addChild(attackBoard)
        self.attackBoard = attackBoard
    end

    local isSelfProect,endTime = global.g_worldview.worldPanel:isMainCityProtect()    

    if isSelfProect and self.obj:isOccupire() and false then

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        local str = global.troopData:timeStringFormat(endTime - global.dataMgr:getServerTime())
        panel:setData("ProtectPrompt", function()
                
            global.worldApi:removeProtection(function(msg)
                    
                openCall()
            end)
        end,str,global.luaCfg:get_config_by(1).protectCD / 60)
    else


        openCall()  
    end   
end

function UIWildResOwnerPanel:infoCall(sender, eventType)

    local data = luaCfg:get_introduction_by(18)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end

function UIWildResOwnerPanel:shareHandler(sender, eventType)

    local x = self.data.lPosX
    local y = self.data.lPosY
    local posXY = global.g_worldview.const:converPix2Location(cc.p(x, y))
    local x = math.round(posXY.x)
    local y = math.round(posXY.y)

    local surfaceData = luaCfg:get_world_surface_by(self.designerData.file) 
    local lWildKind = surfaceData.mold

    local tagSpl = {}
    tagSpl.lKey = 3
    tagSpl.lValue = 0
    tagSpl.szParam = ""--vardump(self.data)
    local sendData = {name = self.designerData.name, posX = x,posY = y,cityId = self.data.lResID,wildKind = lWildKind}    
    tagSpl.szInfo = vardump(sendData,"test")--global.mailData:getCurMailTitleStr()
    tagSpl.lTime = 0

    global.panelMgr:openPanel("UISharePanel"):setData(tagSpl) 
end
--CALLBACKS_FUNCS_END

return UIWildResOwnerPanel

--endregion
