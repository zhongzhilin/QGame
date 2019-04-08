--region UISevenDayRechargeItem.lua
--Author : anlitop
--Date   : 2017/11/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISevenDayRechargeItem  = class("UISevenDayRechargeItem", function() return gdisplay.newWidget() end )

function UISevenDayRechargeItem:ctor()
    self:CreateUI()
end

function UISevenDayRechargeItem:CreateUI()
    local root = resMgr:createWidget("fund/recharge_daily_item")
    self:initUI(root)
end

function UISevenDayRechargeItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "fund/recharge_daily_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.item_name = self.root.item_name_export
    self.quit = self.root.item_node.quit_export
    self.icon = self.root.item_node.icon_export
    self.count_text = self.root.item_node.count_text_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
    
-- {1,540,100}
-- {12315,20,100}
function UISevenDayRechargeItem:setData(data)

    self.data = data 

    local itemData = global.luaCfg:get_local_item_by(self.data[1])

    self.item_name:setString(itemData.itemName)
    self.count_text:setString(self.data[2])


    global.panelMgr:setTextureForAsync(self.icon,itemData.itemIcon or itemData.icon, true)
    global.panelMgr:setTextureForAsync(self.quit,string.format("icon/item/item_bg_0%d.png",itemData.quality),true)

end 

--CALLBACKS_FUNCS_END

return UISevenDayRechargeItem

--endregion
