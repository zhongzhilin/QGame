--region UIUDonateItem.lua
--Author : wuwx
--Date   : 2017/02/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUDonateItem  = class("UIUDonateItem", function() return gdisplay.newWidget() end )

function UIUDonateItem:ctor()
    self:CreateUI()
end

function UIUDonateItem:CreateUI()
    local root = resMgr:createWidget("union/union_donate_list")
    self:initUI(root)
end

function UIUDonateItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_donate_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon_view = self.root.Node_1.icon_view_export
    self.icon = self.root.Node_1.icon_export
    self.icon_num = self.root.Node_1.icon_num_export
    self.name = self.root.name_export
    self.type1 = self.root.type1_mlan_6_export
    self.text1 = self.root.type1_mlan_6_export.text1_export
    self.type2 = self.root.type2_mlan_6_export
    self.text2 = self.root.type2_mlan_6_export.text2_export
    self.type3 = self.root.type3_mlan_3_export
    self.text3 = self.root.type3_mlan_3_export.text3_export

    uiMgr:addWidgetTouchHandler(self.root.change, function(sender, eventType) self:onDonate(sender, eventType) end)
--EXPORT_NODE_END
    
    self.icon_num:setVisible(false)
end

function UIUDonateItem:setData(data)
    self.data = data

    if data.sData.type == 2 then
        --道具捐献特殊处理
        self.icon_num:setVisible(true)

        local itemCount = global.normalItemData:getItemById(data.sData.itemID).count
        self.icon_num:setString(itemCount)
    else
        self.icon_num:setVisible(false)
    end

    local itemData = global.luaCfg:get_item_by(data.sData.itemID)
    
    local quality = itemData.quality
    if quality == 0 then quality = 1 end
    -- self.icon_view:setSpriteFrame(string.format("icon/item/item_bg_0%d.png",quality))
    global.panelMgr:setTextureFor(self.icon_view,string.format("icon/item/item_bg_0%d.png",quality))

    if data.sData.icon == "" then
        local itemIcon = itemData.itemIcon
        -- self.icon:setSpriteFrame(itemIcon)
        global.panelMgr:setTextureFor(self.icon,itemIcon)
    else
        -- self.icon:setSpriteFrame(data.sData.icon)
        global.panelMgr:setTextureFor(self.icon,data.sData.icon)
    end

    self.name:setString(itemData.itemName)
    self.text1:setString("+"..data.sData.display*data.sData.num)
    self.text2:setString("+"..data.sData.display*data.sData.boom)
    self.text3:setString(data.sData.display.." "..itemData.itemName)

    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.text1:getParent(),self.text1)
    global.tools:adjustNodePosForFather(self.text2:getParent(),self.text2)
    global.tools:adjustNodePosForFather(self.text3:getParent(),self.text3)   
    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUDonateItem:onDonate(sender, eventType)
    global.panelMgr:openPanel("UIUDonateUsePanel"):setData(self.data.sData)
end
--CALLBACKS_FUNCS_END

return UIUDonateItem

--endregion
