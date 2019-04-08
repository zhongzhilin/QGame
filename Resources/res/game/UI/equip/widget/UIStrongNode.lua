--region UIStrongNode.lua
--Author : Administrator
--Date   : 2017/03/07
--generate by [ui_code_tool.py] automatically

local luaCfg = global.luaCfg
local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIStrongNode  = class("UIStrongNode", function() return gdisplay.newWidget() end )

function UIStrongNode:ctor()
    
end

function UIStrongNode:CreateUI()
    local root = resMgr:createWidget("equip/str_strong_node")
    self:initUI(root)
end

function UIStrongNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/str_strong_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.pro_symbol = self.root.pro_symbol_export
    self.icon = self.root.pro_symbol_export.icon_export
    self.name = self.root.pro_symbol_export.name_export
    self.count = self.root.pro_symbol_export.count_export

--EXPORT_NODE_END
end

function UIStrongNode:setData(buffData)
	
    if buffData == nil then

        self.name:setString(luaCfg:get_local_string(10446))
        self.name:setPositionY(-12)
        self.name:setTextColor(cc.c3b(43,60,83))
        self.icon:setVisible(false)
        self.count:setVisible(false)
    else

        self.name:setTextColor(cc.c3b(255,226,165))
        self.name:setPositionY(-32)
        self.icon:setVisible(true)
        self.count:setVisible(true)

        local itemData = luaCfg:get_item_by(buffData.item)
        local itemCount = global.normalItemData:getItemById(buffData.item).count
        -- self.icon:setSpriteFrame(itemData.itemIcon)
        global.panelMgr:setTextureFor(self.icon,itemData.itemIcon)
        self.name:setString(itemData.itemName)
        self.count:setString(string.format("(%s/%s)",itemCount,buffData.itemNum))

        self._isfull = buffData.itemNum <= itemCount
    end	
end

function UIStrongNode:isFull()
    return self._isfull
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIStrongNode

--endregion
