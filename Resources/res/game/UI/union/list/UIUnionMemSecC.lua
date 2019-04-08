--region UIUnionMemSecC.lua
--Author : wuwx
--Date   : 2016/12/30
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPortraitWidget = require("game.UI.union.widget.UIPortraitWidget")
--REQUIRE_CLASS_END

local UIUnionMemSecC  = class("UIUnionMemSecC", function() return gdisplay.newWidget() end )

function UIUnionMemSecC:ctor()
    
    self:CreateUI()
end

function UIUnionMemSecC:CreateUI()
    local root = resMgr:createWidget("union/union_member_new")
    self:initUI(root)
end

function UIUnionMemSecC:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_member_new")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn = self.root.btn_export
    self.name = self.root.btn_export.name_export
    self.battle = self.root.btn_export.battle.battle_export
    self.time = self.root.btn_export.time_export
    self.btn_refuse = self.root.btn_export.btn_refuse_export
    self.btn_agree = self.root.btn_export.btn_agree_export
    self.portrait = UIPortraitWidget.new()
    uiMgr:configNestClass(self.portrait, self.root.btn_export.portrait)

    uiMgr:addWidgetTouchHandler(self.btn_refuse, function(sender, eventType) self:refuseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_agree, function(sender, eventType) self:agreeHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.btn:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.btn:setSwallowTouches(false)
end

function UIUnionMemSecC:setData(data)
    self.data = data

    self.name:setString(data.sData.szName)
    -- self.icon:setSpriteFrame(data.icon)
    -- self.num:setString(string.format("%s/%s",self.data.count,20))
    self.time:setVisible(data.canLookOnlineState)
    if data.sData.lOnline == 1 then
        self.time:setString(global.luaCfg:get_local_string(10250))
        self.time:setTextColor(cc.c3b(87, 213, 63)) 
    else
        self.time:setString(global.funcGame.getDurationToNow(data.sData.lLastTime))
        self.time:setTextColor(cc.c3b(109, 79, 53)) 
    end
    self.battle:setString(data.sData.lPower)
    
    self.portrait:setData(data.sData.lFace,data.sData.lBackID,data.sData)
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIUnionMemSecC:agreeHandler(sender, eventType)
    if not global.unionData:isHadPower(22) then
        return global.tipsMgr:showWarning("unionPowerNot")
    end
    global.unionApi:replyUnionApply(1, {self.data.sData.lID}, function(msg)
        -- z
        gevent:call(global.gameEvent.EV_ON_UNION_MEMBER_REFRESH)
    end)
end

function UIUnionMemSecC:refuseHandler(sender, eventType)
    if not global.unionData:isHadPower(22) then
        return global.tipsMgr:showWarning("unionPowerNot")
    end
    global.unionApi:replyUnionApply(2, {self.data.sData.lID}, function(msg)
        -- body
        gevent:call(global.gameEvent.EV_ON_UNION_MEMBER_REFRESH)
    end)

end
--CALLBACKS_FUNCS_END

return UIUnionMemSecC

--endregion
