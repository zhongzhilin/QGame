--region UIRoleHeadNode.lua
--Author : yyt
--Date   : 2017/01/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local UIHeadItem = require("game.UI.roleHead.UIHeadItem")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRoleHeadNode  = class("UIRoleHeadNode", function() return gdisplay.newWidget() end )

function UIRoleHeadNode:ctor()
    self:CreateUI()
end

function UIRoleHeadNode:CreateUI()
    local root = resMgr:createWidget("rolehead/type_node")
    self:initUI(root)
end

function UIRoleHeadNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "rolehead/type_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.titleBg = self.root.titleBg_export
    self.title = self.root.titleBg_export.title_export
    self.bg = self.root.bg_export
    self.itemLayout = self.root.itemLayout_export

--EXPORT_NODE_END
    self.itemNode = cc.Node:create()
    self:addChild(self.itemNode)
    
end

function UIRoleHeadNode:setData(data)
    
    self.rolePanel = global.panelMgr:getPanel("UIRoleHeadPanel")
    self.data = data
    self.itemNode:removeAllChildren()
    local pX, pY = self.itemLayout:getPosition()

    local pW = self.itemLayout:getContentSize().width
    local pH = self.itemLayout:getContentSize().height
    
    local paddingY = 15
    local itemNum = table.nums(data) 
    cellNum = math.ceil(itemNum/5)
    local cellH = cellNum*pH + (cellNum+1)*paddingY

    local paddingX = (self.bg:getContentSize().width - pW*5)/6
    pX = pX + paddingX
    pY = pY - paddingY
    
    local j = 0
    for i=0,#data-1 do
        
        local headItem = UIHeadItem.new()
        headItem:setData(data[i+1])
        headItem:setPosition(cc.p(pX + (pW+paddingX)*(i%5), pY - (pH+paddingY)*(math.floor(j/5))))
        self.itemNode:addChild(headItem)
        table.insert(self.rolePanel.itemTable, headItem)
        j = j + 1
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIRoleHeadNode

--endregion
