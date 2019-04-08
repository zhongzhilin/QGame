--region UIItem.lua
--Author : anlitop
--Date   : 2017/08/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIItem  = class("UIItem", function() return gdisplay.newWidget() end )

local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")


function UIItem:ctor()
    self:CreateUI()
    
end

function UIItem:CreateUI()
    local root = resMgr:createWidget("activity/sevendays/reward_item_node")
    self:initUI(root)
end

function UIItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/sevendays/reward_item_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon_bg = self.root.Node_1.icon_bg_export
    self.icon = self.root.Node_1.icon_bg_export.icon_export
    self.item_number_bg = self.root.Node_1.item_number_bg_export
    self.number = self.root.Node_1.item_number_bg_export.number_export

--EXPORT_NODE_END
end


function UIItem:setData(data)
     self.data  =data
     if not data.data then 
      return 
    end 
    self.data.information =data.data
    self.m_TipsControl = UIItemTipsControl.new()
    local tips_node = data.tips_panel.tips_node
    if tips_node then 
        self.m_TipsControl:setdata( self.icon ,self.data,tips_node)
         self.m_TipsControl:setIsDelay(true)
    end 
     self:updateUI()

     -- self:setScale(1.2)

    self:setScale(self.data.scale or 1 ) 

end

function UIItem:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
    end 
end


function UIItem:updateUI()
   --self.item:setData(self.data)
    if self.data.information.quality then 
        -- self.icon_bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",self.data.information.quality))
        global.panelMgr:setTextureFor(self.icon_bg,string.format("icon/item/item_bg_0%d.png",self.data.information.quality))
    end 
    if self.data.information.itemIcon or self.data.information.icon then
        -- self.icon:setSpriteFrame(self.data.information.itemIcon)
        global.panelMgr:setTextureFor(self.icon,self.data.information.itemIcon or self.data.information.icon)
    end
    self.number:setString(self.data.number or  0 )
    -- self.item_number_bg:setVisible(self.data.isshownumber)
end



--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIItem

--endregion
