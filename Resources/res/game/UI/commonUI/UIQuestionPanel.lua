--region UIQuestionPanel.lua
--Author : yyt
--Date   : 2018/11/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UIQuestionPanel  = class("UIQuestionPanel", function() return gdisplay.newWidget() end )
local UIChatTableView = require("game.UI.chat.UIChatTableView")
local UIQuestionCell = require("game.UI.commonUI.UIQuestionCell")

function UIQuestionPanel:ctor()
    self:CreateUI()
end

function UIQuestionPanel:CreateUI()
    local root = resMgr:createWidget("common/questionnaire_survey")
    self:initUI(root)
end

function UIQuestionPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/questionnaire_survey")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.tableNode = self.root.Node_export.tableNode_export
    self.tabSize = self.root.Node_export.tabSize_export
    self.cellSize = self.root.Node_export.cellSize_export
    self.titleGetH = self.root.Node_export.titleGetH_export
    self.grayBg = self.root.Node_export.Button_1.grayBg_export
    self.FileNode_1 = CloseBtn.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.FileNode_1)

    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_1, function(sender, eventType) self:submitHandler(sender, eventType) end)
--EXPORT_NODE_END

    self.FileNode_1:setData(function()

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData("QuestionExit", function()
            global.panelMgr:closePanel("UIQuestionPanel")
        end)
    end)

    self.tableView = UIChatTableView.new()
        :setSize(self.tabSize:getContentSize())
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIQuestionCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN) 
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)  
        :setColumn(1)      
    self.tableNode:addChild(self.tableView)

    self.tableView:registerScriptHandler(handler(self, self.tableMove), cc.SCROLLVIEW_SCRIPT_SCROLL)

end

function UIQuestionPanel:tableMove()
    self.isStartMove = true
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIQuestionPanel:onEnter()

    self.isStartMove = false
    self:setData()
end

function UIQuestionPanel:setData()

    local getCellH = function (config)
        -- body

        if config.type == 3 then
            return 400, 0
        end

        local textH = 0
        self.titleGetH:setTextAreaSize(cc.size(self.titleGetH:getContentSize().width,0))
        self.titleGetH:setString(config.problem)
        local labelSize = self.titleGetH:getVirtualRendererSize()
        self.titleGetH:setContentSize(labelSize)
        textH = self.titleGetH:getContentSize().height

        local selectH = 0
        for i=1,15 do
            if config["answer_"..i] and config["answer_"..i] ~= "" then
                selectH = 70*i
            end
        end
        local otherH = config.other == 1 and 100 or 40
        return textH+selectH+otherH, textH
    end
    
    local totalTimes = luaCfg:get_investigation_by(1).totalTimes
    local curTimes = global.refershData:getlAnswerCount()+1
    local data = {}
    for i,v in ipairs(luaCfg:investigation()) do
        if v.day == curTimes then
            local temp = clone(v)
            temp.answer = ""
            local index = 0
            for i=1,15 do
                if temp["answer_"..i] and temp["answer_"..i] ~= "" then
                    temp["isSelect"..i] = false
                    index = i
                end
            end
            if temp.other == 1 then
                temp["isSelect"..(index+1)] = false
                temp.otherAnswer = ""
            end
            temp.cellH, temp.titleH = getCellH(temp)
            table.insert(data, temp)
        end
    end
    self.data = data
    self.tableView:setData(data)

    global.colorUtils.turnGray(self.grayBg, true)

end

function UIQuestionPanel:checkCanSubmit()
    
    local isCanSubmit = true
    for k,v in ipairs(self.data) do

        local value = 0
        if v.type == 3 then
            if v.answer == "" then 
                isCanSubmit = false
            end
        else

            local idx = 0
            local isSelected = false
            for i=1,15 do
                if v["answer_"..i] and v["answer_"..i] ~= "" then
                    if v["isSelect"..i] then
                        isSelected = true            
                    end   
                    idx = i
                end
            end

            if v["isSelect"..(idx+1)] then
                isSelected = true
            end

            isCanSubmit = isSelected 
        end
    end

    global.colorUtils.turnGray(self.grayBg, not isCanSubmit)

end

function UIQuestionPanel:submitHandler(sender, eventType)

    local tgAnswer = {}
    local szparam = ""
   
    local isCanSubmit = true
    for k,v in ipairs(self.data) do

        local value = 0
        if v.type == 3 then
            if v.answer == "" then 
                isCanSubmit = false
            else
                szparam = szparam .. v.ID.."@"..v.answer 
            end
        else

            local idx = 0
            local isSelected = false
            for i=1,15 do
                if v["answer_"..i] and v["answer_"..i] ~= "" then

                    if v["isSelect"..i] then
                        isSelected = true
                    end
                    local toValue = v["isSelect"..i] and 1 or 0
                    value = value + toValue*math.pow(2, (i-1))    
                    idx = i    
                end
            end

            if v["isSelect"..(idx+1)] then
                isSelected = true
                value = value + math.pow(2, idx)
                if v.otherAnswer and v.otherAnswer ~= "" then
                    szparam = szparam .. v.ID.."@"..v.otherAnswer .. "|"
                end
            end

            isCanSubmit = isSelected 
            
            local temp = {}
            temp.lID = v.ID
            temp.lValue = value
            table.insert(tgAnswer, temp)

        end

    end

    if not isCanSubmit then
        return global.tipsMgr:showWarning("cantSubmit")
    end

    if table.nums(tgAnswer) == 0 then
        local temp = {}
        temp.lID = 1
        temp.lValue = 0
        table.insert(tgAnswer, temp)
    end

    global.commonApi:answerQuestion(function (msg)
        -- body
        global.panelMgr:closePanel("UIQuestionPanel")
        local curTimes = global.refershData:getlAnswerCount()+1
        local reward = luaCfg:get_investigation_day_by(curTimes) or luaCfg:get_investigation_day_by(1)
        local drop2 = luaCfg:get_drop_by(reward.answerReward).dropItem
        global.tipsMgr:showWarning("QuestionnaireReward", drop2[1][2])
        global.refershData:setlAnswerCount(global.refershData:getlAnswerCount()+1)

    end, global.refershData:getlAnswerCount()+1, tgAnswer, szparam)


end
--CALLBACKS_FUNCS_END

return UIQuestionPanel

--endregion
