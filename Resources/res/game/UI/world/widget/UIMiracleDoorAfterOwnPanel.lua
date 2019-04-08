--region UIMiracleDoorAfterOwnPanel.lua
--Author : Untory
--Date   : 2017/09/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIMiracleDoorAfterOwnNode = require("game.UI.world.widget.UIMiracleDoorAfterOwnNode")
--REQUIRE_CLASS_END
local luaCfg = global.luaCfg
local UIAttackBoard = require("game.UI.world.widget.UIAttackBoard")

local UIMiracleDoorAfterOwnPanel  = class("UIMiracleDoorAfterOwnPanel", function() return gdisplay.newWidget() end )

function UIMiracleDoorAfterOwnPanel:ctor()
    self:CreateUI()
end

function UIMiracleDoorAfterOwnPanel:CreateUI()
    local root = resMgr:createWidget("wild/temple_2nd_bg")
    self:initUI(root)
end

function UIMiracleDoorAfterOwnPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/temple_2nd_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.Node_5.name_export
    self.attack = self.root.Node_export.Node_5.attack_export
    self.collection = self.root.Node_export.Node_5.collection_export
    self.FileNode_1 = UIMiracleDoorAfterOwnNode.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.FileNode_1)
    self.attack_detail = self.root.Node_export.attack_detail_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack, function(sender, eventType) self:attack_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.collection, function(sender, eventType) self:collect_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_1, function(sender, eventType) self:shareHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIMiracleDoorAfterOwnPanel:onEnter()
    if self.attackBoard and not tolua.isnull(self.attackBoard) then
        self.attackBoard:close()
        self.attackBoard = nil
    end
end

function UIMiracleDoorAfterOwnPanel:setObj(city)
    self.obj = city
end


function UIMiracleDoorAfterOwnPanel:setData(data,city)

    self.data = data
    self.designerData = luaCfg:get_wild_res_by(data.lKind)

    local pos = global.g_worldview.const:converPix2Location(cc.p(self.data.lPosX, self.data.lPosY))
    self.name:setString(string.format("%s(%s,%s)",self.designerData.name,pos.x,pos.y))
    
    self.FileNode_1:setData(data,city)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIMiracleDoorAfterOwnPanel:attack_click(sender, eventType)

    if self.FileNode_1.isInProtect then
        global.tipsMgr:showWarning("ProtectNot")
        return
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

function UIMiracleDoorAfterOwnPanel:collect_click(sender, eventType)

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

function UIMiracleDoorAfterOwnPanel:exitCall(sender, eventType)
    global.panelMgr:closePanelForBtn("UIMiracleDoorAfterOwnPanel")
end

function UIMiracleDoorAfterOwnPanel:shareHandler(sender, eventType)

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

return UIMiracleDoorAfterOwnPanel

--endregion
