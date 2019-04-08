--region UITurntableItem.lua
--Author : wuwx
--Date   : 2017/11/13
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITurntableItem  = class("UITurntableItem", function() return gdisplay.newWidget() end )

function UITurntableItem:ctor()
    
end

function UITurntableItem:CreateUI()
    local root = resMgr:createWidget("turntable/turntable_day_lst")
    self:initUI(root)
end

function UITurntableItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "turntable/turntable_day_lst")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.quit = self.root.quit_export
    self.icon = self.root.icon_export
    self.item_name = self.root.item_name_export

--EXPORT_NODE_END
end

function UITurntableItem:setData(id)
    local data = global.luaCfg:get_local_item_by(id)
    self.id = id
    self.data = data
    global.panelMgr:setTextureForAsync(self.icon,data.itemIcon,true)
    global.panelMgr:setTextureForAsync(self.quit,string.format("icon/item/item_bg_0%d.png",data.quality),true)
    self.item_name:setString(data.itemName)

    self.testStr = data.itemName

    global.panelMgr:getPanel("UITurntableHalfPanel"):showTips(self.icon,id)

end

function UITurntableItem:setTestStr(n)
    -- self.item_name:setString(self.testStr.."_"..n)
end

function UITurntableItem:getItemId()
    local data = {itemID = self.id}
    return data
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UITurntableItem

--endregion
