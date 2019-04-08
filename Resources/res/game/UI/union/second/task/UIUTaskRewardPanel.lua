--region UIUTaskRewardPanel.lua
--Author : yyt
--Date   : 2017/07/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUTaskRewardItem = require("game.UI.union.second.task.UIUTaskRewardItem")
--REQUIRE_CLASS_END

local UIUTaskRewardPanel  = class("UIUTaskRewardPanel", function() return gdisplay.newWidget() end )

function UIUTaskRewardPanel:ctor()
    self:CreateUI()
end

function UIUTaskRewardPanel:CreateUI()
    local root = resMgr:createWidget("union/union_task_reward")
    self:initUI(root)
end

function UIUTaskRewardPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_task_reward")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.Node_5.name_mlan_6_export
    self.bg = self.root.Node_export.Node_1.bg_export
    self.donate_text = self.root.Node_export.Node_1.bg_export.donate_text_mlan_4_export
    self.donate = self.root.Node_export.Node_1.bg_export.donate_export
    self.boom = self.root.Node_export.Node_1.bg_export.boom_export
    self.boom_text = self.root.Node_export.Node_1.bg_export.boom_text_mlan_4_export
    self.FileNode_e1 = self.root.Node_export.Node_1.FileNode_e1_export
    self.FileNode_e1 = UIUTaskRewardItem.new()
    uiMgr:configNestClass(self.FileNode_e1, self.root.Node_export.Node_1.FileNode_e1_export)
    self.FileNode_e2 = self.root.Node_export.Node_1.FileNode_e2_export
    self.FileNode_e2 = UIUTaskRewardItem.new()
    uiMgr:configNestClass(self.FileNode_e2, self.root.Node_export.Node_1.FileNode_e2_export)
    self.FileNode_c1 = self.root.Node_export.Node_1.FileNode_c1_export
    self.FileNode_c1 = UIUTaskRewardItem.new()
    uiMgr:configNestClass(self.FileNode_c1, self.root.Node_export.Node_1.FileNode_c1_export)
    self.FileNode_c2 = self.root.Node_export.Node_1.FileNode_c2_export
    self.FileNode_c2 = UIUTaskRewardItem.new()
    uiMgr:configNestClass(self.FileNode_c2, self.root.Node_export.Node_1.FileNode_c2_export)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
--EXPORT_NODE_END

    self.tips_node = cc.Node:create()
    self.root:addChild(self.tips_node)

    global.utaskPanel = self

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
    
function UIUTaskRewardPanel:setData(data)

    local uninoTask = luaCfg:get_union_task_by(data.sData.lID)
    self.donate:setString("+"..uninoTask.rewardnum)
    self.boom:setString("+"..uninoTask.rewardboom)
    local reward1 = luaCfg:get_drop_by(uninoTask.boss_item)
    local reward2 = luaCfg:get_drop_by(uninoTask.reward_item)

    global.tools:adjustNodePos(self.donate_text ,self.donate)
    self.boom_text:setPositionX(self.donate:getPositionX() + 60)
    global.tools:adjustNodePos(self.boom_text ,self.boom)

    if reward1 then
        for i=1,2 do
            self["FileNode_e"..i]:setVisible(false)
            if reward1.dropItem[i] then
                local rewardId1  = reward1.dropItem[i][1] 
                local rewardNum1 = reward1.dropItem[i][2]  
                self["FileNode_e"..i]:setVisible(true)                  
                self["FileNode_e"..i]:setData({id = rewardId1, num = rewardNum1})
            end
        end
    else
        self.FileNode_e1:setVisible(false)
        self.FileNode_e2:setVisible(false)
    end

    if reward2 then
        for i=1,2 do
            self["FileNode_c"..i]:setVisible(false)
            if reward2.dropItem[i] then
                local rewardId2  = reward2.dropItem[i][1] 
                local rewardNum2 = reward2.dropItem[i][2]
                self["FileNode_c"..i]:setVisible(true)                  
                self["FileNode_c"..i]:setData({id = rewardId2, num = rewardNum2})
            end
        end
    else
        self.FileNode_c1:setVisible(false)
        self.FileNode_c2:setVisible(false)
    end
    

    global.tools:adjustNodeMiddle(self.donate,self.donate_text ,self.boom ,self.boom_text) 

end

function UIUTaskRewardPanel:onCloseHanler(sender, eventType)
    global.panelMgr:closePanel("UIUTaskRewardPanel")
end

--CALLBACKS_FUNCS_END

return UIUTaskRewardPanel

--endregion
