--region UITurntableLogItem.lua
--Author : wuwx
--Date   : 2017/11/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITurntableLogItem  = class("UITurntableLogItem", function() return gdisplay.newWidget() end )

function UITurntableLogItem:ctor()
    self:CreateUI()
end

function UITurntableLogItem:CreateUI()
    local root = resMgr:createWidget("turntable/turntable_day_chat")
    self:initUI(root)
end

function UITurntableLogItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "turntable/turntable_day_chat")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.describe = self.root.describe_export
    self.add = self.root.add_export

--EXPORT_NODE_END
end

function UITurntableLogItem:setData(i_data)
    local data = global.luaCfg:get_local_item_by(i_data.lItemID)

	self.describe:setString(global.luaCfg:get_local_string(10929,i_data.lUserName))
	self.add:setString(data.itemName)

    global.tools:adjustNodePos(self.describe,self.add)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UITurntableLogItem

--endregion
