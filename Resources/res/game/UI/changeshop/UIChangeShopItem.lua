--region UIChangeShopItem.lua
--Author : yyt
--Date   : 2017/11/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIChangeShopItem  = class("UIChangeShopItem", function() return gdisplay.newWidget() end )

function UIChangeShopItem:ctor()
    self:CreateUI()
end

function UIChangeShopItem:CreateUI()
    local root = resMgr:createWidget("changshop/chang_node")
    self:initUI(root)
end

function UIChangeShopItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "changshop/chang_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.quit = self.root.Node_9.quit_export
    self.icon = self.root.Node_9.icon_export
    self.count = self.root.Node_9.count_export
    self.name = self.root.Node_9.name_export
    self.selectBg = self.root.Node_9.selectBg_export

    uiMgr:addWidgetTouchHandler(self.quit, function(sender, eventType) self:itemClickHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.quit:setPressedActionEnabled(false)
    self.quit:setSwallowTouches(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

-- data = {itemId=10204, isSelect=false}
function UIChangeShopItem:setData(data)

    self.data = data
    local itemData = luaCfg:get_item_by(data.itemId)
    if not itemData then
        itemData = luaCfg:get_equipment_by(data.itemId)
    end
    self.itemData = itemData
    self.selectBg:setVisible(data.isSelect)
    global.panelMgr:setTextureFor(self.icon, itemData.itemIcon)
    global.panelMgr:setTextureFor(self.quit, string.format("icon/item/item_bg_0%d.png",itemData.quality))
    self.havCount = global.normalItemData:getItemById(itemData.itemId).count
    self.count:setString(self.havCount)
    -- self.count:setVisible(global.chanPanel.curSelectIndex == 1)
end

function UIChangeShopItem:itemClickHandler(sender, eventType)

    if eventType == ccui.TouchEventType.began then
        global.chanPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if global.chanPanel.isPageMove then 
            return
        end
    
        self.selectBg:setVisible(true)
        if global.chanPanel:isCanShop(self.data.itemId) then
            global.chanPanel:leftShopItem(self.itemData, self.data.itemId, self.havCount)
        else
            global.chanPanel:rightChangeItem(self.itemData, self.data.itemId, self.havCount)
        end
    end
end
--CALLBACKS_FUNCS_END

return UIChangeShopItem

--endregion
