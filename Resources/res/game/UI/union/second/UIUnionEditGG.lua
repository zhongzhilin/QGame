--region UIUnionEditGG.lua
--Author : wuwx
--Date   : 2017/01/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIUnionEditGG  = class("UIUnionEditGG", function() return gdisplay.newWidget() end )

function UIUnionEditGG:ctor()
    self:CreateUI()
end

function UIUnionEditGG:CreateUI()
    local root = resMgr:createWidget("union/union_text_edit")
    self:initUI(root)
end

function UIUnionEditGG:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_text_edit")

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

function UIUnionEditGG:onEnter()
    self:setData()
end

function UIUnionEditGG:onExit()
    gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_PANEL)
end


function UIUnionEditGG:setData(data)
    self.notice:setString(global.unionData:getInUnionSzNotice())
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionEditGG:onCloseHanler(sender, eventType)

    global.panelMgr:closePanel("UIUnionEditGG")
end

function UIUnionEditGG:saveHandler(sender, eventType)
    global.unionApi:setAllyUpdate({szNotice=self.notice:getString(),lUpdateID={4}}, function()
        global.tipsMgr:showWarning("UnionBoardOk")
        global.panelMgr:closePanel("UIUnionEditGG")
    end)
end
--CALLBACKS_FUNCS_END

return UIUnionEditGG

--endregion
