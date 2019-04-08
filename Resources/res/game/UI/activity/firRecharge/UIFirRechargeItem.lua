--region UIFirRechargeItem.lua
--Author : wuwx
--Date   : 2017/07/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIFirRechargeItem  = class("UIFirRechargeItem", function() return gdisplay.newWidget() end )

function UIFirRechargeItem:ctor()
    self:CreateUI()
end

function UIFirRechargeItem:CreateUI()
    local root = resMgr:createWidget("activity/recharge_activity/first_item_node")
    self:initUI(root)
end

function UIFirRechargeItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/recharge_activity/first_item_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.gift_name = self.root.gift_name_export
    self.gift_quality = self.root.gift_quality_export
    self.gift_icon = self.root.gift_icon_export
    self.num = self.root.num_export

--EXPORT_NODE_END
end

function UIFirRechargeItem:setData(data)
    local itemId = data[1]
    local count = data[2]
    local noline = data[4]
    local itemData = global.luaCfg:get_item_by(itemId)

    self.gift_name:setString(itemData.itemName)
    self.num:setString(count)
    -- self.root.Image_2:setVisible(not noline)
    
    if itemId<=8 then
        self.gift_icon:setSpriteFrame(itemData.itemIcon)
    else
        global.panelMgr:setTextureFor(self.gift_icon,itemData.itemIcon)
    end
    global.panelMgr:setTextureFor(self.gift_quality,string.format("icon/item/item_bg_0%d.png",itemData.quality))

    global.panelMgr:getPanel("UIFirRechargePanel"):showTips(self.gift_icon,itemId)

end

function UIFirRechargeItem:onExit()
    if self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
        self.m_TipsControl = nil
    end 
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIFirRechargeItem

--endregion
