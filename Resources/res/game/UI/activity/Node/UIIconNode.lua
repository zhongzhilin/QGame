--region UIIconNode.lua
--Author : anlitop
--Date   : 2017/04/24
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIIconNode  = class("UIIconNode", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")


function UIIconNode:ctor()
    self:CreateUI()
end

function UIIconNode:CreateUI()
    local root = resMgr:createWidget("activity/activity_icon_node")
    self:initUI(root)
end


-- <var>" = {
-- [LUA-print] -     "data" = {
-- [LUA-print] -         "buffId" = {
-- [LUA-print] -         }
-- [LUA-print] -         "class"       = 3
-- [LUA-print] -         "cooldown"    = 0
-- [LUA-print] -         "dropType"    = 0
-- [LUA-print] -         "effectDes"   = 0
-- [LUA-print] -         "effectPara1" = 0
-- [LUA-print] -         "effectPara2" = 0
-- [LUA-print] -         "itemDes"     = "8小时内增加部队20%攻击"
-- [LUA-print] -         "itemIcon"    = "ui_surface_icon/item_icon_018.png"
-- [LUA-print] -         "itemId"      = 10401
-- [LUA-print] -         "itemName"    = "8小时攻击加成"
-- [LUA-print] -         "itemType"    = 104
-- [LUA-print] -         "overlapType" = 0
-- [LUA-print] -         "para2Data"   = 1
-- [LUA-print] -         "quality"     = 4
-- [LUA-print] -         "queue"       = 1
-- [LUA-print] -         "stuckable"   = 999
-- [LUA-print] -         "typePara1"   = 480
-- [LUA-print] -         "typePara2"   = 20
-- [LUA-print] -         "typePara3"   = 0
-- [LUA-print] -         "typeorder"   = 13
-- [LUA-print] -         "useDes"      = ""
-- [LUA-print] -         "useway"      = 0
-- [LUA-print] -         "value"       = 0
-- [LUA-print] -         "window"      = 0
-- [LUA-print] -     }
-- [LUA-print] -     "number"   = 1
-- [LUA-print] -     "number_2" = 5000
-- [LUA-print] - }


function UIIconNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/activity_icon_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon_bg = self.root.Node_1.icon_bg_export
    self.icon = self.root.Node_1.icon_bg_export.icon_export
    self.item_number_bg = self.root.Node_1.icon_bg_export.item_number_bg_export
    self.number = self.root.Node_1.icon_bg_export.item_number_bg_export.number_export



--EXPORT_NODE_END
end

function UIIconNode:setData(data)
     self.data  =data
     if not data.data then 
      return 
    end 
    self.data.information =data.data
    self.m_TipsControl = UIItemTipsControl.new()
    local tips_node = data.tips_panel.tips_node
    if tips_node then 
        self.m_TipsControl:setdata( self.icon_bg ,self.data,tips_node)
         self.m_TipsControl:setIsDelay(true)
    end 
     self:updateUI()

     -- self:setScale(1.2)

    self:setScale(self.data.scale or 1 ) 

end

function UIIconNode:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
    end 
end


function UIIconNode:updateUI()
   --self.item:setData(self.data)
    if self.data.information.quality then 
        -- self.icon_bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",self.data.information.quality))
        global.panelMgr:setTextureFor(self.icon_bg,string.format("icon/item/item_bg_0%d.png",self.data.information.quality))
    end 
    if self.data.information.itemIcon then
        -- self.icon:setSpriteFrame(self.data.information.itemIcon)
        global.panelMgr:setTextureFor(self.icon,self.data.information.itemIcon)

    elseif self.data.information.icon then 
        global.panelMgr:setTextureFor(self.icon,self.data.information.icon)
    end 

    self.number:setString(self.data.number or  0 )
    self.item_number_bg:setVisible(self.data.isshownumber)
end


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIIconNode

--endregion
