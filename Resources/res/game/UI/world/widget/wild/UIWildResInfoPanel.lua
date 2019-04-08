--region UIWildResInfoPanel.lua
--Author : yyt
--Date   : 2016/11/30
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIWildResPro = require("game.UI.world.widget.wild.UIWildResPro")
--REQUIRE_CLASS_END
local UIAttackBoard = require("game.UI.world.widget.UIAttackBoard")

local UIWildResInfoPanel  = class("UIWildResInfoPanel", function() return gdisplay.newWidget() end )

function UIWildResInfoPanel:ctor()
    self:CreateUI()
end

function UIWildResInfoPanel:CreateUI()
    local root = resMgr:createWidget("wild/wild_ziyuan_bj1")
    self:initUI(root)
end

function UIWildResInfoPanel:setObj(obj)
    
    self.obj = obj
end

function UIWildResInfoPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_ziyuan_bj1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.Node_5.name_export
    self.attack = self.root.Node_export.Node_5.attack_export
    self.collection = self.root.Node_export.Node_5.collection_export
    self.FileNode_1 = UIWildResPro.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.FileNode_1)
    self.attack_detail = self.root.Node_export.attack_detail_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack, function(sender, eventType) self:attack_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.collection, function(sender, eventType) self:collect_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_1, function(sender, eventType) self:shareHandler(sender, eventType) end)
--EXPORT_NODE_END

end

function UIWildResInfoPanel:setData(data)
    self.data = data
    self.designerData = luaCfg:get_wild_res_by(data.lKind)
    local pos = global.g_worldview.const:converPix2Location(cc.p(self.data.lPosX, self.data.lPosY))

    self.name:setString(string.format("%s(%s,%s)",self.designerData.name,pos.x,pos.y))

    global.g_worldview.worldPanel.chooseCityId = self.data.lResID
    global.g_worldview.worldPanel.chooseCityName = self.designerData.name

    self.FileNode_1:setOverCall(handler(self,self.hpOver))
    self.FileNode_1:setData(self.data,self.designerData)
end

function UIWildResInfoPanel:onEnter()
    if self.attackBoard and not tolua.isnull(self.attackBoard) then
        self.attackBoard:close()
        self.attackBoard = nil
    end
end

function UIWildResInfoPanel:hpOver()
    self:onCloseHandler()
    global.tipsMgr:showWarning("ResVillageDis")
end

function UIWildResInfoPanel:onCloseHandler()
    global.panelMgr:closePanel("UIWildResInfoPanel")
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIWildResInfoPanel:onCloseHanler(sender, eventType)
    global.panelMgr:closePanel("UIWildResInfoPanel")
end

function UIWildResInfoPanel:attack_click(sender, eventType)

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
        attackBoard:changeSharpPos()
        attackBoard:setCity(self.obj,self.designerData.energy)
        self.attack_detail:addChild(attackBoard)
        self.attack_detail:setLocalZOrder(2)
        self.attackBoard = attackBoard
    end

    local isSelfProect,endTime = global.g_worldview.worldPanel:isMainCityProtect()

    if isSelfProect then

        print("if isSelfProect then")
    end

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

function UIWildResInfoPanel:collect_click(sender, eventType)
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

function UIWildResInfoPanel:shareHandler(sender, eventType)
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

return UIWildResInfoPanel

--endregion
