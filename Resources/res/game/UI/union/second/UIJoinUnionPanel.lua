--region UIJoinUnionPanel.lua
--Author : wuwx
--Date   : 2016/12/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUnionPro = require("game.UI.union.widget.UIUnionPro")
--REQUIRE_CLASS_END

local UIJoinUnionPanel  = class("UIJoinUnionPanel", function() return gdisplay.newWidget() end )

function UIJoinUnionPanel:ctor()
    self:CreateUI()
end

function UIJoinUnionPanel:CreateUI()
    local root = resMgr:createWidget("union/union_data_public")
    self:initUI(root)
end

function UIJoinUnionPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_data_public")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.FileNode_3 = UIUnionPro.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.Node_export.FileNode_3)
    self.name = self.root.Node_export.name_mlan_15_export
    self.request = self.root.Node_export.request.request_mlan_6_export
    self.chat = self.root.Node_export.chat.chat_mlan_6_export
    self.join1 = self.root.Node_export.join.join1_mlan_7_export
    self.tips1 = self.root.Node_export.recruit_title.tips1_mlan_15_export
    self.textl = self.root.Node_export.textl_export

    uiMgr:addWidgetTouchHandler(self.root.Panel, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.member, function(sender, eventType) self:memberHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.request, function(sender, eventType) self:contactHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.chat, function(sender, eventType) self:onMessage(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.join, function(sender, eventType) self:joinHandler(sender, eventType) end)
--EXPORT_NODE_END
end

local INPUT_MODE = {
    NORMAL = 0,
    FOREIGN = 1,
}
function UIJoinUnionPanel:setData(data)
    self.data = data or self.data
    
    self.m_inputMode = global.panelMgr:getPanel("UIUnionPanel"):getInputMode()

    self.FileNode_3:setData(data)
    self.textl:setString(self.data.szInfo)

    if self.m_inputMode == INPUT_MODE.NORMAL then
        if data.lAutoApprove == 1 then
            self.join1:setString(global.luaCfg:get_local_string(10283))
        else
            self.join1:setString(global.luaCfg:get_local_string(10282))
        end
    else
        --外交
        self.join1:setString(global.luaCfg:get_local_string(10311))
    end
end

function UIJoinUnionPanel:updateUI()
  if self.m_inputMode == INPUT_MODE.NORMAL then
        if self.data.lAutoApprove == 1 then
            self.join1:setString(global.luaCfg:get_local_string(10283))
        else
            self.join1:setString(global.luaCfg:get_local_string(10282))
        end
    else
        --外交
        self.join1:setString(global.luaCfg:get_local_string(10311))
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIJoinUnionPanel:memberHandler(sender, eventType)
    -- global.tipsMgr:showWarning("FuncNotFinish")

    global.panelMgr:openPanel("UIUnionMemberPanel"):setData(self.data)
end

function UIJoinUnionPanel:joinHandler(sender, eventType)
    -- 判断是否已加入联盟
    local luaCfg = global.luaCfg

    local lID = self.data.lID

    if self.m_inputMode == INPUT_MODE.NORMAL then
        if global.userData:checkJoinUnion() then
            global.tipsMgr:showWarning(luaCfg:get_local_string(10083))
        else
            global.unionApi:joinUnion(lID, 1, function(msg)
                global.unionData:setInUnion(msg.tgAlly)
                global.tipsMgr:showWarning(luaCfg:get_local_string(10080))
     
                global.panelMgr:closePanel("UIUnionSearchPanel")
                global.panelMgr:closePanel("UIJoinUnionPanel")
                global.panelMgr:closePanel("UIUnionPanel")
                global.panelMgr:openPanel("UIHadUnionPanel")
            end)
        end
    else
        --外交
        global.panelMgr:openPanel("UIUnionForeignChoicePanel"):setData(self.data)
    end
end

function UIJoinUnionPanel:contactHandler(sender, eventType)
    global.panelMgr:closePanel("UIJoinUnionPanel")
    global.panelMgr:openPanel("UIChatPrivatePanel"):init(self.data.lLeader)
end

function UIJoinUnionPanel:onCloseHanler(sender, eventType)
    global.panelMgr:closePanelForBtn("UIJoinUnionPanel")
end

function UIJoinUnionPanel:onMessage(sender, eventType)
    --联盟留言
    global.panelMgr:openPanel("UIUMsgPanel"):setData(self.data.lID)
end
--CALLBACKS_FUNCS_END

return UIJoinUnionPanel

--endregion
