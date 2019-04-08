--region UIUnionAskItem.lua
--Author : wuwx
--Date   : 2017/01/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPortraitWidget = require("game.UI.union.widget.UIPortraitWidget")
--REQUIRE_CLASS_END

local UIUnionAskItem  = class("UIUnionAskItem", function() return gdisplay.newWidget() end )

function UIUnionAskItem:ctor()
    self:CreateUI()
end

function UIUnionAskItem:CreateUI()
    local root = resMgr:createWidget("union/union_please_list")
    self:initUI(root)
end

function UIUnionAskItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_please_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn = self.root.btn_export
    self.name = self.root.btn_export.name_export
    self.battle = self.root.btn_export.battle.battle_export
    self.time = self.root.btn_export.time_export
    self.portrait = UIPortraitWidget.new()
    uiMgr:configNestClass(self.portrait, self.root.btn_export.portrait)

    uiMgr:addWidgetTouchHandler(self.btn, function(sender, eventType) self:onDetailHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.btn:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.btn:setSwallowTouches(false)
end

function UIUnionAskItem:setData(data)
    self.data = data

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


function UIUnionAskItem:onDetailHandler(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIUnionAskItem

--endregion
