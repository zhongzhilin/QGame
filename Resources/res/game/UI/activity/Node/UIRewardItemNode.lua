--region UIRewardItemNode.lua
--Author : anlitop
--Date   : 2017/04/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRewardItemNode  = class("UIRewardItemNode", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")
function UIRewardItemNode:ctor()
    self:CreateUI()
end

function UIRewardItemNode:CreateUI()
    local root = resMgr:createWidget("activity/reward_item_node")
    self:initUI(root)
end

function UIRewardItemNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/reward_item_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon_bg = self.root.Node_1.icon_bg_export
    self.number = self.root.Node_1.icon_bg_export.number_export
    self.icon = self.root.Node_1.icon_bg_export.icon_export
    self.item_number_bg = self.root.item_number_bg_export
    self.number = self.root.item_number_bg_export.number_export

--EXPORT_NODE_END

end
 
function UIRewardItemNode:onEnter()

end 

function UIRewardItemNode:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
    end 
end

function UIRewardItemNode:setData(data)

    -- dump(data,"item a =====================")
    -- body
    if data and data.data then 
       self.data  =data
        self.data.information =data.data
        self.m_TipsControl = UIItemTipsControl.new()
        -- self.m_TipsControl:setCheckMode(1)
       self.m_TipsControl:setdata(self.icon, self.data,data.tips_node)
        self.m_TipsControl:setIsDelay(true)
       self:updateUI()
    end 
end
--  - "劉寶" = {
-- [LUA-print] -     "buffId" = {
-- [LUA-print] -     }
-- [LUA-print] -     "class"       = 0
-- [LUA-print] -     "cooldown"    = 0
-- [LUA-print] -     "dropType"    = 0
-- [LUA-print] -     "effectDes"   = 0
-- [LUA-print] -     "effectPara1" = 0
-- [LUA-print] -     "effectPara2" = 0
-- [LUA-print] -     information = *REF*
-- [LUA-print] -     "itemDes"     = "经验"
-- [LUA-print] -     "itemIcon"    = "ui_surface_icon/icon_exp1.png"
-- [LUA-print] -     "itemId"      = 5
-- [LUA-print] -     "itemName"    = "经验"
-- [LUA-print] -     "itemType"    = 5
-- [LUA-print] -     "overlapType" = 0
-- [LUA-print] -     "para2Data"   = 0
-- [LUA-print] -     "quality"     = 0
-- [LUA-print] -     "queue"       = 0
-- [LUA-print] -     "stuckable"   = 999999999
-- [LUA-print] -     "tips_node"   = userdata: 20320F68
-- [LUA-print] -     "typePara1"   = 0
-- [LUA-print] -     "typePara2"   = 0
-- [LUA-print] -     "typePara3"   = 0
-- [LUA-print] -     "typeorder"   = 0
-- [LUA-print] -     "useDes"      = ""
-- [LUA-print] -     "useway"      = 0
-- [LUA-print] -     "value"       = 0
-- [LUA-print] -     "window"      = 0
-- [LUA-print] - }

function UIRewardItemNode:updateUI()
    -- self.icon_bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",self.data.data.quality))
    -- self.icon:setSpriteFrame(self.data.data.itemIcon)
    global.panelMgr:setTextureFor(self.icon_bg,string.format("icon/item/item_bg_0%d.png",self.data.data.quality))
    global.panelMgr:setTextureFor(self.icon,self.data.data.itemIcon)
   self.number:setString(self.data.number)
    self.item_number_bg:setVisible(self.data.isshownumber)
end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIRewardItemNode

--endregion
