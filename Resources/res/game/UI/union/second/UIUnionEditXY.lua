--region UIUnionEditXY.lua
--Author : wuwx
--Date   : 2017/01/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIUnionEditXY  = class("UIUnionEditXY", function() return gdisplay.newWidget() end )

function UIUnionEditXY:ctor()
    self:CreateUI()
end

function UIUnionEditXY:CreateUI()
    local root = resMgr:createWidget("union/union_text_xy_edit")
    self:initUI(root)
end

function UIUnionEditXY:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_text_xy_edit")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.notice = self.root.Node_export.Node_1.notice_export
    self.notice = UIInputBox.new()
    uiMgr:configNestClass(self.notice, self.root.Node_export.Node_1.notice_export)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Node_5.create, function(sender, eventType) self:saveHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.notice:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
end

function UIUnionEditXY:onEnter(data)
    self:setData()
end

function UIUnionEditXY:onExit()
    gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_PANEL)
end

function UIUnionEditXY:setData(data)
    self.notice:setString(global.unionData:getInUnionSzInfo())
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionEditXY:onCloseHanler(sender, eventType)

    global.panelMgr:closePanel("UIUnionEditXY")
end

function UIUnionEditXY:saveHandler(sender, eventType)

    global.unionApi:setAllyUpdate({szInfo=self.notice:getString(),lUpdateID={3}}, function()
        global.tipsMgr:showWarning("UnionNoticeOk")
        global.panelMgr:closePanel("UIUnionEditXY")
    end)
end
--CALLBACKS_FUNCS_END

return UIUnionEditXY

--endregion
