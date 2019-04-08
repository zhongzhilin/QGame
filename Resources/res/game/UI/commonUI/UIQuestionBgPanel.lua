--region UIQuestionBgPanel.lua
--Author : yyt
--Date   : 2018/11/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIQuestionBgPanel  = class("UIQuestionBgPanel", function() return gdisplay.newWidget() end )

function UIQuestionBgPanel:ctor()
    self:CreateUI()
end

function UIQuestionBgPanel:CreateUI()
    local root = resMgr:createWidget("common/questionnaire_bg")
    self:initUI(root)
end

function UIQuestionBgPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/questionnaire_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.noJoinNeed = self.root.Node_export.noJoinNeed_export
    self.joinNeed = self.root.Node_export.joinNeed_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.joinQuestionBtn, function(sender, eventType) self:joinHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.notJoinQuestionBtn, function(sender, eventType) self:noJoinHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIQuestionBgPanel:onEnter()

    self:setData()
end

function UIQuestionBgPanel:setData()

    local curTimes = global.refershData:getlAnswerCount()+1
    local reward = luaCfg:get_investigation_day_by(curTimes) or luaCfg:get_investigation_day_by(1)
    local drop1 = luaCfg:get_drop_by(reward.noanswerReward).dropItem
    local drop2 = luaCfg:get_drop_by(reward.answerReward).dropItem
    self.noJoinNeed:setString(drop1[1][2] .. ")")
    self.joinNeed:setString(drop2[1][2] .. ")")
end

function UIQuestionBgPanel:exit(sender, eventType)
    global.panelMgr:closePanelForBtn("UIQuestionBgPanel")
end

function UIQuestionBgPanel:joinHandler(sender, eventType)
    global.panelMgr:closePanel("UIQuestionBgPanel")
    global.panelMgr:openPanel("UIQuestionPanel")
end

function UIQuestionBgPanel:noJoinHandler(sender, eventType)
    
    global.commonApi:answerQuestion(function (msg)
    
        global.panelMgr:closePanel("UIQuestionBgPanel")
        local curTimes = global.refershData:getlAnswerCount()+1
        local reward = luaCfg:get_investigation_day_by(curTimes) or luaCfg:get_investigation_day_by(1)
        local drop1 = luaCfg:get_drop_by(reward.noanswerReward).dropItem
        global.tipsMgr:showWarning("QuestionnaireReward2", drop1[1][2])
        global.refershData:setlAnswerCount(curTimes)

    end, global.refershData:getlAnswerCount()+1, {}, "")

end
--CALLBACKS_FUNCS_END

return UIQuestionBgPanel

--endregion
