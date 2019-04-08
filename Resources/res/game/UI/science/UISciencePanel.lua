--region UISciencePanel.lua
--Author : yyt
--Date   : 2017/02/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIScienceEffect = require("game.UI.science.UIScienceEffect")
local UIScienceItem = require("game.UI.science.UIScienceItem")
--REQUIRE_CLASS_END

local UISciencePanel  = class("UISciencePanel", function() return gdisplay.newWidget() end )

function UISciencePanel:ctor()
    self:CreateUI()
end

function UISciencePanel:CreateUI()
    local root = resMgr:createWidget("science/science_main_bg")
    self:initUI(root)
end

function UISciencePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "science/science_main_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.effectStudy = self.root.effectStudy_export
    self.effectStudy = UIScienceEffect.new()
    uiMgr:configNestClass(self.effectStudy, self.root.effectStudy_export)
    self.FileNode_3 = self.root.adaptation.FileNode_3_export
    self.FileNode_3 = UIScienceItem.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.adaptation.FileNode_3_export)
    self.FileNode_2 = self.root.adaptation.FileNode_2_export
    self.FileNode_2 = UIScienceItem.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.adaptation.FileNode_2_export)
    self.FileNode_1 = self.root.adaptation.FileNode_1_export
    self.FileNode_1 = UIScienceItem.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.adaptation.FileNode_1_export)
    self.tips = self.root.tips_export

    uiMgr:addWidgetTouchHandler(self.root.intro1_btn, function(sender, eventType) self:onHelpHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UISciencePanel:onEnter()

    self:setData(true)    

    self:addEventListener(global.gameEvent.EV_ON_UI_TECH_FLUSH, function( )
        self:setData()
    end)

    local nodeTimeLine = resMgr:createTimeline("science/science_main_bg")
    nodeTimeLine:play("animation0", true)
    self:runAction(nodeTimeLine)

    self:playAudio()

end

function UISciencePanel:playAudio()
    self.soundHandler = gsound.playEffectForced("ui_scienLP")
end

function UISciencePanel:onExit()
    gaudio.stopSound(self.soundHandler)
end

function UISciencePanel:setData(flag)

    local tgQueue =  global.techData:getQueueByTime()
    self.effectStudy:setData(tgQueue)
    if flag then
        self.effectStudy:playEffect()
    end

    for i=1,3 do
        self["FileNode_"..i]:setData(i)
    end

    self.tips:setVisible(not global.techData:checkTechMonthCard())
    self.tips:setString(global.luaCfg:get_translate_string(10934))

end

function UISciencePanel:getSound()
    return self.soundHandler
end

function UISciencePanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UISciencePanel")  
end

function UISciencePanel:onHelpHandler(sender, eventType)

    local data = luaCfg:get_introduction_by(13)
    global.panelMgr:openPanel("UIIntroducePanel"):setData(data)
end
--CALLBACKS_FUNCS_END

return UISciencePanel

--endregion
