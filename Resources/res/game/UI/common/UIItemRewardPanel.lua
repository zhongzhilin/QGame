--region UIItemRewardPanel.lua
--Author : Administrator
--Date   : 2016/08/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local UITableView = require("game.UI.common.UITableView")

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIItemRewardPanel  = class("UIItemRewardPanel", function() return gdisplay.newWidget() end )
local UIItemRewardItemCell = require("game.UI.common.UIItemRewardItemCell")

function UIItemRewardPanel:ctor()
    self:CreateUI()
end

function UIItemRewardPanel:CreateUI()
    local root = resMgr:createWidget("bag/bag_reward")
    self:initUI(root)
end

function UIItemRewardPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/bag_reward")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.Text = self.root.Node_export.Text_mlan_8_export
    self.Text1 = self.root.Node_export.Text1_mlan_8_export
    self.tbsize = self.root.Node_export.tbsize_export
    self.itsize = self.root.Node_export.itsize_export
    self.tb_node = self.root.Node_export.tb_node_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
--EXPORT_NODE_END

    self.tableView = UITableView.new()
        :setSize(self.tbsize:getContentSize())
        :setCellSize(self.itsize:getContentSize())
        :setCellTemplate(UIItemRewardItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)

    self.tb_node:addChild(self.tableView)
end

function UIItemRewardPanel:setData(data, isRecharge ,exitCall)
    -- body
    self.tbsize:setSwallowTouches(false)
    self.exitCall = exitCall

    for i,v in ipairs(data) do

        if v[2] < 0 then

            data[i] = nil
        end
    end

    if isRecharge then
        self.Text:setVisible(false)
        self.Text1:setVisible(true)
    else
        self.Text:setVisible(true)
        self.Text1:setVisible(false)
    end

    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function ()
        
        local nodeTimeLine = resMgr:createTimeline("bag/bag_reward")
        nodeTimeLine:setTimeSpeed(0.5)
        nodeTimeLine:play("animation0", false)
        self:runAction(nodeTimeLine)
    end)))

    self.tableView:setData(data)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIItemRewardPanel:exit(sender, eventType)
    global.panelMgr:closePanelForBtn("UIItemRewardPanel")
end


function UIItemRewardPanel:onExit()
    if self.exitCall then 
        self.exitCall()
    end
end 

--CALLBACKS_FUNCS_END

return UIItemRewardPanel

--endregion
