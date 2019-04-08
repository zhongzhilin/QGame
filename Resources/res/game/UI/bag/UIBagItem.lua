--region UIBagItem.lua
--Author : Administrator
--Date   : 2016/08/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBagItem  = class("UIBagItem", function() return gdisplay.newWidget() end )
local UIBagUseBoard = require("game.UI.bag.UIBagUseBoard")

function UIBagItem:ctor()
    
    self:CreateUI()
end

function UIBagItem:CreateUI()
    local root = resMgr:createWidget("bag/bag_item")
    self:initUI(root)
end

function UIBagItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/bag_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.quit = self.root.Node_1.quit_export
    self.light = self.root.Node_1.light_export
    self.icon = self.root.Node_1.icon_export
    self.count_text = self.root.Node_1.count_text_export
    self.item_name = self.root.Node_1.item_name_export

--EXPORT_NODE_END

    self.light:setVisible(false)
end

function UIBagItem:setData(data)
    
    if not data then return end
    local itemData = luaCfg:get_item_by(data.id)
    if not itemData then
        itemData = luaCfg:get_equipment_by(data.id)
    end
    if not itemData then return end

    global.panelMgr:setTextureForAsync(self.icon,itemData.itemIcon or itemData.icon, true)
    global.panelMgr:setTextureForAsync(self.quit,string.format("icon/item/item_bg_0%d.png",itemData.quality),true)
    self.count_text:setString(data.count)
    self.data = data
end

--　领主升级奖励道具
function UIBagItem:setItemData( dropData ,isSetName) -- isSetName  是否设置名字
    
    local itemData = luaCfg:get_item_by(dropData[1])
    if not itemData then
        itemData = luaCfg:get_equipment_by(dropData[1])
        -- self.icon:setSpriteFrame(itemData.icon)
        if itemData then 
            global.panelMgr:setTextureForAsync(self.icon,itemData.icon,true)
            self:setItemName(itemData.name , isSetName )
        end 
    else
        -- self.icon:setSpriteFrame(itemData.itemIcon)
        global.panelMgr:setTextureForAsync(self.icon,itemData.itemIcon,true)
        self:setItemName(itemData.itemName, isSetName )
    end

    -- self.quit:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",itemData.quality))
    global.panelMgr:setTextureFor(self.quit,string.format("icon/item/item_bg_0%d.png",itemData.quality),true)
    self.count_text:setString(dropData[2])
end

function UIBagItem:onExit()
    self.item_name:setVisible(false)
end 

function UIBagItem:setItemName(text, isVisible)
    self.item_name:setVisible(isVisible)
    self.item_name:setString(text)
end 


function UIBagItem:showUse()
    -- body
    self.light:setVisible(true)
    self.root:setPositionY(200)

    UIBagUseBoard:getInstance():bindToItem(self, self.data.sort)

    -- local showBoard = UIBagUseBoard:getInstance():bindToItem(self, self.data.sort)
    -- self:addChild(showBoard)
end

function UIBagItem:hideUse()
    -- body

    self.light:setVisible(false)
    self.root:setPositionY(0)

    UIBagUseBoard:getInstance():hideSelf(self)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIBagItem

--endregion
