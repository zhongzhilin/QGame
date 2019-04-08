--region UITurntableFullItem.lua
--Author : wuwx
--Date   : 2017/11/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITurntableFullItem  = class("UITurntableFullItem", function() return gdisplay.newWidget() end )

function UITurntableFullItem:ctor()
    
end

function UITurntableFullItem:CreateUI()
    local root = resMgr:createWidget("turntable/turntable_pay_lst")
    self:initUI(root)
end

function UITurntableFullItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "turntable/turntable_pay_lst")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.quit = self.root.quit_export
    self.icon = self.root.quit_export.icon_export
    self.count_text = self.root.quit_export.count_text_export
    self.name_text = self.root.name_text_export

--EXPORT_NODE_END
end

function UITurntableFullItem:setData(i_data)
    local data = global.luaCfg:get_local_item_by(i_data.itemID)
    self.id = i_data.itemID
    self.data = data
    global.panelMgr:setTextureForAsync(self.icon,data.itemIcon,true)
    global.panelMgr:setTextureForAsync(self.quit,string.format("icon/item/item_bg_0%d.png",data.quality),true)
    self.count_text:setString(i_data.num)
    self.name_text:setString(data.itemName)

    self.testStr = data.itemName

    global.panelMgr:getPanel("UITurntableFullPanel"):showTips(self.icon,i_data.itemID)
end

function UITurntableFullItem:setTestStr(n)
    -- self.item_name:setString(self.testStr.."_"..n)
end

function UITurntableFullItem:getItemId()
    local data = {itemID = self.id,num = self.count_text:getString()}
    return data
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UITurntableFullItem

--endregion
