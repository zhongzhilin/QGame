--region UIWorldBossItem.lua
--Author : Untory
--Date   : 2017/12/26
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIItemBaseIcon = require("game.UI.common.UIItemBaseIcon")
--REQUIRE_CLASS_END

local UIWorldBossItem  = class("UIWorldBossItem", function() return gdisplay.newWidget() end )

function UIWorldBossItem:ctor()
    self:CreateUI()
end

function UIWorldBossItem:CreateUI()
    local root = resMgr:createWidget("wild/world_boss_monster_item")
    self:initUI(root)
end

function UIWorldBossItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/world_boss_monster_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.base_icon = UIItemBaseIcon.new()
    uiMgr:configNestClass(self.base_icon, self.root.base_icon)

--EXPORT_NODE_END
    self.base_icon:openLongTipsControl(0.1)
    self.base_icon:showName(cc.c3b(255,226,165))
end

function UIWorldBossItem:setData(data)
    -- body
    self.base_icon:setId(data[1],data[2])
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIWorldBossItem

--endregion
