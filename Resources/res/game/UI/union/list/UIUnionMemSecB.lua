--region UIUnionMemSecB.lua
--Author : wuwx
--Date   : 2016/12/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPortraitWidget = require("game.UI.union.widget.UIPortraitWidget")
--REQUIRE_CLASS_END

local UIUnionMemSecB  = class("UIUnionMemSecB", function() return gdisplay.newWidget() end )

function UIUnionMemSecB:ctor()
    
    self:CreateUI()
end

function UIUnionMemSecB:CreateUI()
    local root = resMgr:createWidget("union/union_member_mem")
    self:initUI(root)
end

function UIUnionMemSecB:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_member_mem")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn = self.root.btn_export
    self.name = self.root.btn_export.name_export
    self.battle = self.root.btn_export.battle.battle_export
    self.time = self.root.btn_export.time_export
    self.portrait = UIPortraitWidget.new()
    uiMgr:configNestClass(self.portrait, self.root.btn_export.portrait)

--EXPORT_NODE_END
    self.btn:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.btn:setSwallowTouches(false)
end

function UIUnionMemSecB:setData(data)
    self.data = data

    self.name:setString(data.sData.szName)
    -- self.icon:setSpriteFrame(data.icon)
    self.time:setVisible(data.canLookOnlineState)
    if data.sData.lOnline == 1 then
        self.time:setString(global.luaCfg:get_local_string(10250))
        self.time:setTextColor(cc.c3b(87, 213, 63)) 
    else
        self.time:setString(global.funcGame.getDurationToNow(data.sData.lLastTime))
        self.time:setTextColor(cc.c3b(109, 79, 53)) 
    end
    self.battle:setString(data.sData.lPower)
    -- self.portrait:setData(data.sData.lFace)
    self.portrait:setData(data.sData.lFace,data.sData.lBackID,data.sData)
    -- dump(self.data,"UIUnionMemSecB////////////////////////////")
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
--CALLBACKS_FUNCS_END

return UIUnionMemSecB

--endregion
