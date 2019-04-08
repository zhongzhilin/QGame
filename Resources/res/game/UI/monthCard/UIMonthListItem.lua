--region UIMonthListItem.lua
--Author : zzl
--Date   : 2017/12/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMonthListItem  = class("UIMonthListItem", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

function UIMonthListItem:ctor()
    self:CreateUI()
end

function UIMonthListItem:CreateUI()
    local root = resMgr:createWidget("month_card_ui/month_card_reward_list1")
    self:initUI(root)
end

function UIMonthListItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "month_card_ui/month_card_reward_list1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.yellow = self.root.yellow_export
    self.blue = self.root.blue_export
    self.quit = self.root.quit_export
    self.icon = self.root.quit_export.icon_export
    self.name = self.root.name_export
    self.count = self.root.count_export

--EXPORT_NODE_END
end


function UIMonthListItem:setData(data)

    local item = global.luaCfg:get_local_item_by(data[1])

    self.count:setString("x"..data[2])

    self.name:setString(item.itemName)

    if item.quality then 
        global.panelMgr:setTextureFor(self.quit,string.format("icon/item/item_bg_0%d.png",item.quality))
    end 

    if item.itemIcon or item.icon then
        global.panelMgr:setTextureFor(self.icon,item.itemIcon or item.icon)
    end

    self.m_TipsControl = UIItemTipsControl.new()
    self.m_TipsControl:setdata( self.icon , item)

end 


function UIMonthListItem:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
    end 
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIMonthListItem

--endregion
