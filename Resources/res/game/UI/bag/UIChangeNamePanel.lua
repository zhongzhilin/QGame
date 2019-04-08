--region UIChangeNamePanel.lua
--Author : untory
--Date   : 2017/07/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIChangeNamePanel  = class("UIChangeNamePanel", function() return gdisplay.newWidget() end )

function UIChangeNamePanel:ctor()
    self:CreateUI()
end

function UIChangeNamePanel:CreateUI()
    local root = resMgr:createWidget("bag/change_name")
    self:initUI(root)
end

function UIChangeNamePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/change_name")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.free_btn = self.root.Node_export.Node_5.free_btn_export
    self.input = self.root.Node_export.Node_1.input_export
    self.input = UIInputBox.new()
    uiMgr:configNestClass(self.input, self.root.Node_export.Node_1.input_export)
    self.info1 = self.root.Node_export.Node_1.info1_mlan_40_export
    self.changeName = self.root.Node_export.Node_1.changeName_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.free_btn, function(sender, eventType) self:confrimHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.changeName, function(sender, eventType) self:changeName_call(sender, eventType) end)
--EXPORT_NODE_END
end

function UIChangeNamePanel:onEnter()
    
    self.input:setString("")
    self:changeName_call()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIChangeNamePanel:play()
    -- body

    self.root:stopAllActions()

    local nodeTimeLine = resMgr:createTimeline("bag/change_name")
    -- nodeTimeLine:setLastFrameCallFunc(function()

    --     if msg == nil then return end
        
    -- end)
    nodeTimeLine:play("animation0", false)
    self.root:runAction(nodeTimeLine)
end

function UIChangeNamePanel:onCloseHanler(sender, eventType)

    global.panelMgr:closePanel("UIChangeNamePanel")
end

function UIChangeNamePanel:confrimHandler(sender, eventType)

    local str = self.input:getString()    

    if self:checkNameStr(str) then
    
        global.itemApi:itemUse(11901, 1, 0, 0, function()
            
            global.tipsMgr:showWarning("RenameSuccess")
            global.panelMgr:closePanel("UIChangeNamePanel")

            global.userData:setUserName(self.input:getString())
            
        end,self.input:getString()) 

    end 
end


function UIChangeNamePanel:checkNameStr(str)

    if str == "" then
            
        global.tipsMgr:showWarningTime("CantEmpty")
        return false
    end
    
    local errcode, spaceNum = 0, 0
    local list = string.utf8ToList(str)
    for i=1,#list do
        
        if list[1] == " "  then
            errcode = -1
        end

        if list[i] == " " then
            spaceNum = spaceNum + 1
        end

        if list[#list] == " "  then
            errcode = 1
        end 
    end

    -- 不能全部为空格
    if spaceNum == #list then
        global.tipsMgr:showWarningTime("CantSpaceAll")
        return false
    end

    -- 首尾不能为空
    if errcode ~= 0 then
        global.tipsMgr:showWarningTime("CantSpace")
        return false
    end

    if string.isEmoji(str) then
        global.tipsMgr:showWarning("13")
        return false
    end

    return true
end

function UIChangeNamePanel:changeName_call(sender, eventType)
    
    if sender then 

        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_RandomName")
        self:play() 
    end

    global.loginApi:getRandName(function(ret,msg)
        -- body
        if ret.retcode == WCODE.OK then
            local firstStr = luaCfg:get_rand_name_by(msg.lFirstName).text
            local secStr = luaCfg:get_rand_name_by(msg.lSecondName).text
            local addStr = ""
            if msg.lAddName then
                addStr = luaCfg:get_rand_name_by(msg.lAddName).text
            end
            -- local strName = string.format("%s %s %s",firstStr,secStr,addStr)
            -- if global.languageData:isCN() then
            --     strName = string.format("%s%s%s",firstStr,secStr,addStr)
            -- end

            local strName = string.format("%s%s%s",firstStr,secStr,addStr)

            self.input:setString(strName)
        end
    end)
end
--CALLBACKS_FUNCS_END

return UIChangeNamePanel

--endregion
