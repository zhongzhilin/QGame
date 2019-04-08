--region UIUnionJoinCondition.lua
--Author : wuwx
--Date   : 2017/01/11
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIUnionJoinCondition  = class("UIUnionJoinCondition", function() return gdisplay.newWidget() end )

function UIUnionJoinCondition:ctor()
    self:CreateUI()
end

function UIUnionJoinCondition:CreateUI()
    local root = resMgr:createWidget("union/union_switch")
    self:initUI(root)
end

function UIUnionJoinCondition:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_switch")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.Node_5.name_mlan_6_export
    self.attack_mode_cb1 = self.root.Node_export.Node_1.attack_mode_cb1_export
    self.attack_mode_cb2 = self.root.Node_export.Node_1.attack_mode_cb2_export
    self.info1 = self.root.Node_export.Node_1.info1_mlan_42_export
    self.info2 = self.root.Node_export.Node_1.info2_mlan_42_export
    self.level = self.root.Node_export.Node_1.level_export
    self.level = UIInputBox.new()
    uiMgr:configNestClass(self.level, self.root.Node_export.Node_1.level_export)
    self.battle = self.root.Node_export.Node_1.battle_export
    self.battle = UIInputBox.new()
    uiMgr:configNestClass(self.battle, self.root.Node_export.Node_1.battle_export)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Node_5.create, function(sender, eventType) self:saveHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack_mode_cb1, function(sender, eventType) self:call_cb1(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack_mode_cb2, function(sender, eventType) self:call_cb2(sender, eventType) end)
--EXPORT_NODE_END
    self.level:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.battle:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.Text1 = self.root.Node_export.Node_1.attack_mode_cb1_export.Text_mlan_1
    self.Text2 = self.root.Node_export.Node_1.attack_mode_cb2_export.Text_mlan_1

end

function UIUnionJoinCondition:onEnter()
    self:setData()
end

function UIUnionJoinCondition:setData()
    self.data = global.unionData:getInUnion()
    self.lAutoApprove = self.data.lAutoApprove

    self.level:setString(self.data.lMinBuild or 1)
    self.battle:setString(self.data.lMinPower or 0)
    self.attack_mode_cb1:setSelected(self.data.lAutoApprove == 1)
    self.attack_mode_cb2:setSelected(self.data.lAutoApprove == 0)

    global.tools:adjustNodePosForFather(self.Text1:getParent(),self.Text1)
    global.tools:adjustNodePosForFather(self.Text2:getParent(),self.Text2)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionJoinCondition:onCloseHanler(sender, eventType)
    global.panelMgr:closePanel("UIUnionJoinCondition")
end

function UIUnionJoinCondition:saveHandler(sender, eventType)
    local level = tonumber(self.level:getString())
    local battle = tonumber(self.battle:getString())
    self.data.lMinBuild = level or self.data.lMinBuild
    self.data.lMinPower = battle or self.data.lMinPower
    self.data.lAutoApprove = self.lAutoApprove
    local param ={
        lAutoApprove =self.data.lAutoApprove,
        lMinCityGrade = self.data.lMinBuild,
        lMinPower = self.data.lMinPower,
        lUpdateID={5,7,8}
    }
    global.unionApi:setAllyUpdate(param, function()
        global.unionData:setInUnion(self.data)
        global.tipsMgr:showWarning("unionRecruitOk")
        global.panelMgr:closePanel("UIUnionJoinCondition")
    end)
end

function UIUnionJoinCondition:call_cb1(sender, eventType)
    self.attack_mode_cb2:setSelected(false)
    self.attack_mode_cb1:setSelected(true)
    self.lAutoApprove = 1
end

function UIUnionJoinCondition:call_cb2(sender, eventType)
    self.attack_mode_cb2:setSelected(true)
    self.attack_mode_cb1:setSelected(false)
    self.lAutoApprove = 0
end
--CALLBACKS_FUNCS_END

return UIUnionJoinCondition

--endregion
