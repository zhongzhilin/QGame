--region UIWolrdWildNewDropItem.lua
--Author : Untory
--Date   : 2017/12/22
--generate by [ui_code_tool.py] automatically

local luaCfg = global.luaCfg
local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWolrdWildNewDropItem  = class("UIWolrdWildNewDropItem", function() return gdisplay.newWidget() end )

function UIWolrdWildNewDropItem:ctor()
    self:CreateUI()
end

function UIWolrdWildNewDropItem:CreateUI()
    local root = resMgr:createWidget("wild/wild_ziyuan_drop_list")
    self:initUI(root)
end

function UIWolrdWildNewDropItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_ziyuan_drop_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.time = self.root.time_export
    self.rich_text = self.root.rich_text_export

--EXPORT_NODE_END
end

function UIWolrdWildNewDropItem:setData(data)
	-- self.time:setString(global.funcGame:xxx())
	self.time:setString(global.mailData:getFormatTime(data.lTime))
    local itemData = luaCfg:get_item_by(data.lItemID)
    local richId = 50252 + itemData.quality
    uiMgr:setRichText(self, 'rich_text', richId, {name = luaCfg:get_local_string(10265),num = data.lcount,item = itemData.itemName})
    local height = self.rich_text:getRichTextSize().height
    self.rich_text:setPositionY(37 + (height - 30) / 2)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIWolrdWildNewDropItem

--endregion
