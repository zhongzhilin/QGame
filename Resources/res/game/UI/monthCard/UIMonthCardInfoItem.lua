--region UIMonthCardInfoItem.lua
--Author : anlitop
--Date   : 2017/07/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMonthCardInfoItem  = class("UIMonthCardInfoItem", function() return gdisplay.newWidget() end )

local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")


function UIMonthCardInfoItem:ctor()

    self:CreateUI()

end

function UIMonthCardInfoItem:CreateUI()
    local root = resMgr:createWidget("month_card_ui/monthcardinfoItem")
    self:initUI(root)
end

function UIMonthCardInfoItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "month_card_ui/monthcardinfoItem")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon_bg = self.root.Node_1.icon_bg_export
    self.number = self.root.Node_1.icon_bg_export.number_export
    self.icon = self.root.Node_1.icon_bg_export.icon_export
    self.name = self.root.name_export
    self.num = self.root.num_export

--EXPORT_NODE_END
end


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

--    2 = {
-- [LUA-print] -         1 = 12803
-- [LUA-print] -         2 = 2
-- [LUA-print] -         3 = 100
-- [LUA-print] -     }

function UIMonthCardInfoItem:setData(data)

    self.data = data 

    local item = global.luaCfg:get_item_by(data[1])

    self.item = item 
    self.num:setString("x"..tostring(data[2]))

    self.name:setString(item.itemName)

    -- self.icon_bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",item.quality))

    -- self.icon:setSpriteFrame(item.itemIcon)
    global.panelMgr:setTextureFor(self.icon,item.itemIcon)
    global.panelMgr:setTextureFor(self.icon_bg,string.format("icon/item/item_bg_0%d.png",item.quality))

    self:registerTips(self.data.panel)
end 


function UIMonthCardInfoItem:onExit()

    self:clearTips()
end 


function UIMonthCardInfoItem:registerTips(tips_panel)
    self.tips_panel = tips_panel
    if self.tips_panel and  self.tips_panel.tips_node and self.item  then 
        self.m_TipsControl = UIItemTipsControl.new()
        self.m_TipsControl:setdata(self.icon,{information=self.item},self.tips_panel.tips_node)
    end 
end 


function  UIMonthCardInfoItem:clearTips()
   if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
    end 
end 



return UIMonthCardInfoItem

--endregion
