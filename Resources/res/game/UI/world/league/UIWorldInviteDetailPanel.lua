--region UIWorldInviteDetailPanel.lua
--Author : wuwx
--Date   : 2017/12/27
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUnionMemProDetails = require("game.UI.union.widget.UIUnionMemProDetails")
--REQUIRE_CLASS_END

local UIWorldInviteDetailPanel  = class("UIWorldInviteDetailPanel", function() return gdisplay.newWidget() end )

function UIWorldInviteDetailPanel:ctor()
    self:CreateUI()
end

function UIWorldInviteDetailPanel:CreateUI()
    local root = resMgr:createWidget("world/league/world_invite_info")
    self:initUI(root)
end

function UIWorldInviteDetailPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/league/world_invite_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.FileNode_1 = UIUnionMemProDetails.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.FileNode_1)
    self.request = self.root.Node_export.request.request_mlan_6_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.request, function(sender, eventType) self:inviteHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIWorldInviteDetailPanel:setData(data)

    self.data = data
    self.FileNode_1:setData(data)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIWorldInviteDetailPanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanel("UIWorldInviteDetailPanel")
end

function UIWorldInviteDetailPanel:inviteHandler(sender, eventType)
    local dstId = global.panelMgr:getPanel("UIWorldInvitePanel"):getDstId()
    global.worldApi:sendInviteMoveCity(function()
        global.tipsMgr:showWarning("UnionInvitation")
        -- body
    end,1,dstId,self.data.lID)
    global.panelMgr:closePanel("UIWorldInviteDetailPanel")
    gevent:call(global.gameEvent.EV_ON_UNION_SELECTUSER, self.data)
end
--CALLBACKS_FUNCS_END

return UIWorldInviteDetailPanel

--endregion
