--region UIQuestionNode.lua
--Author : yyt
--Date   : 2018/11/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIQuestionNode  = class("UIQuestionNode", function() return gdisplay.newWidget() end )
local UIQuestionSelect = require("game.UI.commonUI.UIQuestionSelect")

function UIQuestionNode:ctor()
    self:CreateUI()
end

function UIQuestionNode:CreateUI()
    local root = resMgr:createWidget("common/questionnaire_node")
    self:initUI(root)
end

function UIQuestionNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/questionnaire_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node1 = self.root.Node1_export
    self.title = self.root.Node1_export.title_export
    self.answerNode = self.root.Node1_export.answerNode_export
    self.line = self.root.Node1_export.line_export
    self.Node2 = self.root.Node2_export
    self.textQuto = self.root.Node2_export.textQuto_export
    self.answerQuto = self.root.Node2_export.answerQuto_export
    self.answerQuto = UIInputBox.new()
    uiMgr:configNestClass(self.answerQuto, self.root.Node2_export.answerQuto_export)
    self.answerQutoBtn = self.root.Node2_export.answerQutoBtn_export

    uiMgr:addWidgetTouchHandler(self.answerQutoBtn, function(sender, eventType) self:autoClickHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.answerQutoBtn:setLocalZOrder(1)
    self.answerQutoBtn:setSwallowTouches(false)

    self.answerQuto:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIQuestionNode:onEnter()
    self.answerQuto:addEventListener(handler(self, self.answerQutoCall))
end
function UIQuestionNode:answerQutoCall(eventType)
    if eventType == "return" then

        local errorcode = 0
        local str = self.answerQuto:getString()
        local spaceNum = 0
        local list = string.utf8ToList(str)
        for i=1,#list do

            if list[i] == "|" or list[i] == "@" then
                errorcode = 1
                break
            end
            if list[i] == " " or list[i] == "\n"  then
                spaceNum = spaceNum + 1
            end
        end
        if errorcode == 1 then
            str = ""
            self.answerQuto:setString("") 
            global.tipsMgr:showWarningTime("illegalChar")
        end

        -- 不能全部为空格
        if spaceNum >= #list then 
            str = ""  
            self.answerQuto:setString("")         
            global.tipsMgr:showWarningTime("Testtips004")
        end
        self.data.answer = str
        global.panelMgr:getPanel("UIQuestionPanel"):checkCanSubmit()

    end
end

function UIQuestionNode:setData(data)

    self.data = data
    self.Node1:setVisible(false)
    self.Node2:setVisible(false)

    if data.type == 3 then

        self.Node2:setVisible(true)
        self.textQuto:setString(data.index .. "." .. data.problem)
        self.Node2:setPositionY(50)
        self.answerQuto:setString(data.answer or "")

    else

        self.Node1:setVisible(true)
        self.title:setString(data.index .. "." .. data.problem)
        self.title:setPositionY(data.cellH-30)
        self.answerNode:removeAllChildren()
        self.answerNode:setPosition(cc.p(-230, self.title:getPositionY()-data.titleH-35))

        local gapItem = 65
        local index = 0
        for i=1,15 do
            if data["answer_"..i] and data["answer_"..i] ~= "" then
                local item = UIQuestionSelect.new()                 
                local temp = {}
                temp.id = i
                temp.isSelect = data["isSelect"..i]
                temp.answerStr = data["answer_"..i]
                item:setData(temp, handler(self, self.selectHandler)) 
                item:setPosition(cc.p(0, -(i-1)*gapItem))
                self.answerNode:addChild(item)
                index = i
            end
        end

        if data.other == 1 then
            local item = UIQuestionSelect.new()                 
            local temp = {}
            temp.id = (index+1)
            temp.otherAnswer = data.otherAnswer
            temp.isSelect = data["isSelect"..temp.id]
            temp.answerStr = luaCfg:get_local_string(11166)
            item:setData(temp, handler(self, self.selectHandler)) 
            item:setPosition(cc.p(0, -(temp.id-1)*gapItem))
            self.answerNode:addChild(item)
        end

        self.line:setPositionY(0)

    end

end

function UIQuestionNode:selectHandler(id, otherAnswer)

    if otherAnswer then
        self.data.otherAnswer = otherAnswer
        return
    end
    
    local child = self.answerNode:getChildren()
    for k,v in pairs(child) do

        if self.data.type == 1 then

            if v.data.id == id then
                v.data.isSelect = true
                self.data["isSelect"..v.data.id] = true
            else
                v.data.isSelect = false
                self.data["isSelect"..v.data.id] = false
            end

        else

            if v.data.id == id then
                v.data.isSelect = not v.data.isSelect
                self.data["isSelect"..v.data.id] = not self.data["isSelect"..v.data.id]
            end
        
        end

        v:setData(v.data, handler(self, self.selectHandler))

    end

end


function UIQuestionNode:autoClickHandler(sender, eventType)
    
    local sPanel = global.panelMgr:getPanel("UIQuestionPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isStartMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isStartMove then 
            return
        end

        self.answerQuto:touchDownAction()
    end
    
end
--CALLBACKS_FUNCS_END

return UIQuestionNode

--endregion
