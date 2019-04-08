--region UIAccDropWidget.lua
--Author : wuwx
--Date   : 2017/07/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIAccDropWidget  = class("UIAccDropWidget", function() return gdisplay.newWidget() end )

function UIAccDropWidget:ctor()
    self:CreateUI()
end

function UIAccDropWidget:CreateUI()
    local root = resMgr:createWidget("activity/recharge_activity/reward_item_node")
    self:initUI(root)
end

function UIAccDropWidget:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/recharge_activity/reward_item_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon_bg = self.root.Node_1.icon_bg_export
    self.icon = self.root.Node_1.icon_export
    self.count_text = self.root.Node_1.count_text_export
    self.item_name = self.root.Node_1.item_name_export
    self.name = self.root.name_export
    self.num = self.root.num_export

--EXPORT_NODE_END
end

function UIAccDropWidget:setData(data)
    local itemId = data[1]
    local count = data[2]
    local itemData = global.luaCfg:get_item_by(itemId)
    self.name:setString(itemData.itemName)
    -- self.item_name:setString(itemData.itemName)
    -- self.count_text:setString(1)
    self.count_text:setVisible(false)
    self.item_name:setVisible(false)

    self.num:setString(count)

    if itemId<=8 then
        self.icon:setSpriteFrame(itemData.itemIcon)
    else
        global.panelMgr:setTextureFor(self.icon,itemData.itemIcon)
    end
    global.panelMgr:setTextureFor(self.icon_bg,string.format("icon/item/item_bg_0%d.png",itemData.quality))

    global.panelMgr:getPanel("UIAccRechargePanel"):showTips(self.icon_bg,itemId)

end
function UIAccDropWidget:onExit()
end


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIAccDropWidget

--endregion
