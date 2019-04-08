--region UIUnionAppointedItem.lua
--Author : wuwx
--Date   : 2017/01/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPortraitWidget = require("game.UI.union.widget.UIPortraitWidget")
--REQUIRE_CLASS_END

local UIUnionAppointedItem  = class("UIUnionAppointedItem", function() return gdisplay.newWidget() end )

function UIUnionAppointedItem:ctor()
    
    self:CreateUI()
end

function UIUnionAppointedItem:CreateUI()
    local root = resMgr:createWidget("union/union_position_d")
    self:initUI(root)
end

function UIUnionAppointedItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_position_d")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn = self.root.btn_export
    self.portrait = UIPortraitWidget.new()
    uiMgr:configNestClass(self.portrait, self.root.btn_export.portrait)
    self.battle = self.root.btn_export.battle.battle_export
    self.name = self.root.btn_export.name_export
    self.time = self.root.btn_export.time_export
    self.btn_appointed = self.root.btn_export.btn_appointed_export
    self.btn_refuse = self.root.btn_export.btn_refuse_export

    uiMgr:addWidgetTouchHandler(self.btn_appointed, function(sender, eventType) self:appointedHanlder(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_refuse, function(sender, eventType) self:refuseHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.btn:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.btn:setSwallowTouches(false)
end

function UIUnionAppointedItem:setData(data)
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
    self.portrait:setData(data.lFace , data.lBackID, data)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionAppointedItem:appointedHanlder(sender, eventType)
    if not global.unionData:isLeader() then
        return global.tipsMgr:showWarning("unionPowerNot")
    end

    global.unionApi:allyAction(function(msg)
        -- body
        gevent:call(global.gameEvent.EV_ON_UNION_MEMBER_REFRESH)
        global.tipsMgr:showWarning("unionPositionOK")
    end,2,global.panelMgr:getPanel("UIUnionAppointedPanel"):getlClass(),self.data.lID)
end

function UIUnionAppointedItem:refuseHandler(sender, eventType)
    if not global.unionData:isLeader() then
        return global.tipsMgr:showWarning("unionPowerNot")
    end

    global.unionApi:allyAction(function(msg)
        -- body
        gevent:call(global.gameEvent.EV_ON_UNION_MEMBER_REFRESH)
        global.tipsMgr:showWarning("unionApplyNo")
    end,6,global.panelMgr:getPanel("UIUnionAppointedPanel"):getlClass(),self.data.lID)
end
--CALLBACKS_FUNCS_END

return UIUnionAppointedItem

--endregion
