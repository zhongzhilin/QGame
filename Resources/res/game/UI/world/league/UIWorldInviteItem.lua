--region UIWorldInviteItem.lua
--Author : wuwx
--Date   : 2017/12/27
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPortraitWidget = require("game.UI.union.widget.UIPortraitWidget")
--REQUIRE_CLASS_END

local UIWorldInviteItem  = class("UIWorldInviteItem", function() return gdisplay.newWidget() end )

function UIWorldInviteItem:ctor()
    self:CreateUI()
end

function UIWorldInviteItem:CreateUI()
    local root = resMgr:createWidget("world/league/world_invite_list")
    self:initUI(root)
end

function UIWorldInviteItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/league/world_invite_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn = self.root.btn_export
    self.name = self.root.btn_export.name_export
    self.portrait = UIPortraitWidget.new()
    uiMgr:configNestClass(self.portrait, self.root.btn_export.portrait)
    self.battle = self.root.btn_export.battle.battle_export
    self.time = self.root.btn_export.time_export

    uiMgr:addWidgetTouchHandler(self.btn, function(sender, eventType) self:onDetailHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.btn:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.btn:setSwallowTouches(false)
end

function UIWorldInviteItem:setData(data)
    self.data = data
    dump(data)
    self.name:setString(data.szName)
    -- self.icon:setSpriteFrame(data.icon)
    if data.lOnline == 1 then
        self.time:setString(global.luaCfg:get_local_string(10250))
        self.time:setTextColor(cc.c3b(87, 213, 63)) 
    else
        self.time:setString(global.funcGame.getDurationToNow(data.lLastTime))
        self.time:setTextColor(cc.c3b(109, 79, 53)) 
    end

    self.battle:setString(data.lPower)
    self.portrait:setData(data.lFace,data.lBackID,data)
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIWorldInviteItem:onDetailHandler(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIWorldInviteItem

--endregion
