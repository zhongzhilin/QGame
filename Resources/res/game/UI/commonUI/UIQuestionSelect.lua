--region UIQuestionSelect.lua
--Author : yyt
--Date   : 2018/11/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIQuestionSelect  = class("UIQuestionSelect", function() return gdisplay.newWidget() end )

function UIQuestionSelect:ctor()
    self:CreateUI()
end

function UIQuestionSelect:CreateUI()
    local root = resMgr:createWidget("common/questionnaire_select")
    self:initUI(root)
end

function UIQuestionSelect:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/questionnaire_select")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.select = self.root.Button_1.select_export
    self.answer = self.root.Button_1.answer_export
    self.other = self.root.other_export
    self.answerInput = self.root.other_export.answerInput_export
    self.answerInput = UIInputBox.new()
    uiMgr:configNestClass(self.answerInput, self.root.other_export.answerInput_export)

    uiMgr:addWidgetTouchHandler(self.root.Button_1, function(sender, eventType) self:selectHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.root.Button_1:setSwallowTouches(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIQuestionSelect:onEnter()
    self.answerInput:addEventListener(handler(self, self.answerInputCall))
end
function UIQuestionSelect:answerInputCall(eventType)

    if eventType == "began" then
        if self.m_handler and not self.data.isSelect then
            self.m_handler(self.data.id)
        end

    end
    if eventType == "return" then

        local errorcode = 0
        local str = self.answerInput:getString()
        local list = string.utf8ToList(str)
        for i=1,#list do
            if list[i] == "|" or list[i] == "@" then
                errorcode = 1
                break
            end
        end

        if errorcode == 1 then
            str = ""
            self.answerInput:setString("") 
            global.tipsMgr:showWarningTime("illegalChar")
        end

        self.data.otherAnswer = str
        if self.m_handler then
            self.m_handler(self.data.id, self.data.otherAnswer)
        end
        global.panelMgr:getPanel("UIQuestionPanel"):checkCanSubmit()
        
    end
end

function UIQuestionSelect:setData(data, m_handler)
    
    self.data = data
    self.m_handler = m_handler
    self.answer:setString(data.answerStr or "-")
    self.select:setVisible(data.isSelect)

    self.other:setVisible(false)
    if data.otherAnswer then
        self.other:setVisible(true)   
        self.answerInput:setMaxLength(20)
        self.answerInput:setString(data.otherAnswer) 
        self.other:setPositionX(60)
    end

end

function UIQuestionSelect:selectHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIQuestionPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isStartMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isStartMove then 
            return
        end
        if self.m_handler then
            self.m_handler(self.data.id)
        end
        global.panelMgr:getPanel("UIQuestionPanel"):checkCanSubmit()
    end

end

--CALLBACKS_FUNCS_END

return UIQuestionSelect

--endregion
