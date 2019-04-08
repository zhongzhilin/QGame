--region UIGiftItem.lua
--Author : anlitop
--Date   : 2017/03/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIGiftItem  = class("UIGiftItem", function() return gdisplay.newWidget() end )

local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

function UIGiftItem:ctor()
    self:CreateUI()
end

function UIGiftItem:CreateUI()
    local root = resMgr:createWidget("gift/gift_item_node")
    self:initUI(root)
end

function UIGiftItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "gift/gift_item_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.gift_quality = self.root.gift_quality_export
    self.gift_icon = self.root.gift_quality_export.gift_icon_export
    self.gift_name = self.root.gift_name_export
    self.gift_number = self.root.gift_number_export

--EXPORT_NODE_END
end

function UIGiftItem:setData(data)
    self.data = data 
    self:UpdataUI()
end 

function UIGiftItem:UpdataUI()

    self.gift_number:setString(self.data[2])
    local item = global.luaCfg:get_item_by(self.data[1])
    self.item  = item 
    self.gift_name:setString(item.itemName)
    -- self.gift_icon:setSpriteFrame(item.itemIcon)
    -- self.gift_quality:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",item.quality))
    global.panelMgr:setTextureFor(self.gift_icon,item.itemIcon)
    global.panelMgr:setTextureFor(self.gift_quality,string.format("icon/item/item_bg_0%d.png",item.quality))

    self:registerTips(self.data.panel)

end 


function UIGiftItem:onExit()

    self:clearTips()
end 

function UIGiftItem:registerTips(tips_panel)

    self.tips_panel = tips_panel
    if self.tips_panel and  self.tips_panel.tips_node and self.item  then 
        self.m_TipsControl = UIItemTipsControl.new()
        self.m_TipsControl:setdata(self.gift_icon,{information=self.item},self.tips_panel.tips_node)
    end 
end 


function  UIGiftItem:clearTips()
   if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
    end 
end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIGiftItem

--endregion
