--region UIAccRewardItem.lua
--Author : wuwx
--Date   : 2017/07/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIAccRewardItem  = class("UIAccRewardItem", function() return gdisplay.newWidget() end )

function UIAccRewardItem:ctor()
    self:CreateUI()
end

function UIAccRewardItem:CreateUI()
    local root = resMgr:createWidget("activity/recharge_activity/reward_node")
    self:initUI(root)
end

function UIAccRewardItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/recharge_activity/reward_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.img_bg = self.root.img_bg_export
    self.num = self.root.num_export
    self.centre = self.root.centre_export
    self.node_killed = self.root.centre_export.node_killed_export
    self.btn_go = self.root.centre_export.btn_go_export
    self.go = self.root.centre_export.btn_go_export.go_export

    uiMgr:addWidgetTouchHandler(self.btn_go, function(sender, eventType) self:go_recharge(sender, eventType) end)
--EXPORT_NODE_END
    
    self.m_drops = {}
end

function UIAccRewardItem:setData(data)
    self.data = data
    self.img_bg:setContentSize(self.img_bg:getContentSize().width,data.uiData.h-10)
    self.centre:setPositionY(45)
    self.num:setPositionY(data.uiData.h-30)
    -- self.num:setVisible(data.point)
    self.num:setString(global.luaCfg:get_local_string(10743,data.point))
    if data.state == 0 then
        local picName = "ui_button/btn_get1.png"
        self.btn_go:loadTextures(picName,picName,picName,ccui.TextureResType.plistType)
        self.go:setString(global.luaCfg:get_local_string(10746))
        self.btn_go:setVisible(true)
        self.node_killed:setVisible(false)
    elseif data.state == 1 then
        local picName = "ui_button/btn_reward.png"
        self.btn_go:loadTextures(picName,picName,picName,ccui.TextureResType.plistType)
        self.go:setString(global.luaCfg:get_local_string(10747))
        self.btn_go:setVisible(true)
        self.node_killed:setVisible(false)
    elseif data.state == 2 then
        self.btn_go:setVisible(false)
        self.node_killed:setVisible(true)
    end

    local UIAccDropWidget = require("game.UI.activity.accRecharge.UIAccDropWidget")
    local dropsLen = table.nums(self.m_drops)
    local realLen = #data.btReward.dropItem
    local len = (realLen<dropsLen) and dropsLen or realLen
    local startY = data.uiData.h-35-60
    for i=1,len do
        local drop = self.m_drops[i]
        if not drop then
            drop = UIAccDropWidget.new()
            self.centre:addChild(drop)
            drop:setPositionX(-self.centre:getPositionX()+20)
            self.m_drops[i] = drop
        end
        if i > realLen then
            drop:setVisible(false)
        else
            drop:setVisible(true)
            drop:setData(data.btReward.dropItem[i])
        end
        drop:setPositionY(startY-60*i)
    end
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIAccRewardItem:go_recharge(sender, eventType)
    if not self.data then return end

    if self.data.state == 0 then
        global.panelMgr:closePanel("UIAccRechargePanel")
        global.panelMgr:openPanel("UIRechargePanel")
    elseif self.data.state == 1 then
        global.taskApi:getReward(2, self.data.point,function(msg)
      
            global.panelMgr:openPanel("UIItemRewardPanel"):setData(self.data.btReward.dropItem)
            global.userData:addSumPayPoint(self.data.point)

            local  taskPanel = global.panelMgr:getPanel("UIAccRechargePanel")
            taskPanel:setData(taskPanel:getData())
        end)
    elseif self.data.state == 2 then
    end
end
--CALLBACKS_FUNCS_END

return UIAccRewardItem

--endregion
