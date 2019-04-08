--region UIDivineInfoPanel.lua
--Author : yyt
--Date   : 2017/03/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIDivineItem = require("game.UI.divine.UIDivineItem")
--REQUIRE_CLASS_END

local UIDivineInfoPanel  = class("UIDivineInfoPanel", function() return gdisplay.newWidget() end )

function UIDivineInfoPanel:ctor()
    self:CreateUI()
end

function UIDivineInfoPanel:CreateUI()
    local root = resMgr:createWidget("citybuff/divine_info")
    self:initUI(root)
end

function UIDivineInfoPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "citybuff/divine_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.cardNode = self.root.Node_export.cardNode_export
    self.cardNode = UIDivineItem.new()
    uiMgr:configNestClass(self.cardNode, self.root.Node_export.cardNode_export)
    self.buffName = self.root.Node_export.buffName_export
    self.buffDes = self.root.Node_export.buffDes_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIDivineInfoPanel:setData(data, isAnimation)

    self.data = data
    local divineData = global.luaCfg:get_divine_by(self.data.ID)
    self.cardNode:setData(self.data, true)
    self.buffName:setString(divineData.name)
    self.buffDes:setString(divineData.des)
    if isAnimation then
        self.cardNode:setCardSide(true, false)
    else
        self.cardNode:setCardSide(true, false, true)
    end

end

function UIDivineInfoPanel:onCloseHanler(sender, eventType)
    global.panelMgr:closePanel("UIDivineInfoPanel")
end
--CALLBACKS_FUNCS_END

return UIDivineInfoPanel

--endregion
