--region UIUnionAdPanel.lua
--Author : Untory
--Date   : 2017/12/14
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUnionFlagWidget = require("game.UI.union.widget.UIUnionFlagWidget")
--REQUIRE_CLASS_END

local UIUnionAdPanel  = class("UIUnionAdPanel", function() return gdisplay.newWidget() end )

function UIUnionAdPanel:ctor()
    self:CreateUI()
end

function UIUnionAdPanel:CreateUI()
    local root = resMgr:createWidget("union/union_recommend")
    self:initUI(root)
end

function UIUnionAdPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_recommend")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.flang = UIUnionFlagWidget.new()
    uiMgr:configNestClass(self.flang, self.root.Node_export.flang)
    self.reward = self.root.Node_export.reward_export

    uiMgr:addWidgetTouchHandler(self.root.Panel, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.join, function(sender, eventType) self:joinHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIUnionAdPanel:onEnter()

    self.nodeTimeLine = resMgr:createTimeline("union/union_recommend")    
    self.root:stopAllActions()
    self.root:runAction(self.nodeTimeLine)


    self.nodeTimeLine:play("animation0",true)
end

local INPUT_MODE = {
    NORMAL = 0,
    FOREIGN = 1,
}
function UIUnionAdPanel:setData(data)
    self.data = data
    self.flang:setData(data.lTotem)
    self.reward:setString(string.format('【%s】%s',data.szShortName,data.szName))
    self.reward:setLocalZOrder(1)

    self.m_inputMode = global.panelMgr:getPanel("UIUnionPanel"):getInputMode()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionAdPanel:onCloseHandler(sender, eventType)

    global.panelMgr:closePanelForBtn('UIUnionAdPanel')
end

function UIUnionAdPanel:joinHandler(sender, eventType)
    
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
                global.panelMgr:closePanel("UIUnionAdPanel")
                global.panelMgr:closePanel("UIUnionPanel")
                global.panelMgr:openPanel("UIHadUnionPanel")
            end)
        end
    else
        --外交
        global.panelMgr:openPanel("UIUnionForeignChoicePanel"):setData(self.data)
    end
end
--CALLBACKS_FUNCS_END

return UIUnionAdPanel

--endregion
