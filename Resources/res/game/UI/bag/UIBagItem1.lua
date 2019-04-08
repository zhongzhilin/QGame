--region UIBagItem1.lua
--Author : yyt
--Date   : 2017/09/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBagItem1  = class("UIBagItem1", function() return gdisplay.newWidget() end )

function UIBagItem1:ctor()
    self:CreateUI()
end

function UIBagItem1:CreateUI()
    local root = resMgr:createWidget("bag/bag_item_1")
    self:initUI(root)
end

function UIBagItem1:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/bag_item_1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.quit = self.root.Node_1.quit_export
    self.icon = self.root.Node_1.icon_export
    self.count_text = self.root.Node_1.count_text_export
    self.item_name = self.root.Node_1.item_name_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIBagItem1:setItemData( dropData ,isSetName) -- isSetName  是否设置名字
    
    local itemData = luaCfg:get_item_by(dropData[1])
    if not itemData then
        itemData = luaCfg:get_equipment_by(dropData[1])
        -- self.icon:setSpriteFrame(itemData.icon)
        global.panelMgr:setTextureForAsync(self.icon,itemData.icon,true)
        self:setItemName(itemData.name , isSetName )
    else
        -- self.icon:setSpriteFrame(itemData.itemIcon)
        global.panelMgr:setTextureForAsync(self.icon,itemData.itemIcon,true)
        self:setItemName(itemData.itemName, isSetName )
    end

    -- self.quit:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",itemData.quality))
    global.panelMgr:setTextureFor(self.quit,string.format("icon/item/item_bg_0%d.png",itemData.quality),true)
    self.count_text:setString(dropData[2])

end

function UIBagItem1:setItemName(text, isVisible)
    self.item_name:setVisible(isVisible)
    self.item_name:setString(text)
end 

--CALLBACKS_FUNCS_END

return UIBagItem1

--endregion
