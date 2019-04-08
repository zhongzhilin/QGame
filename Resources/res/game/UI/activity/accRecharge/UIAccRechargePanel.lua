--region UIAccRechargePanel.lua
--Author : wuwx
--Date   : 2017/07/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIAccRechargePanel  = class("UIAccRechargePanel", function() return gdisplay.newWidget() end )

local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

function UIAccRechargePanel:ctor()
    self:CreateUI()
end

function UIAccRechargePanel:CreateUI()
    local root = resMgr:createWidget("activity/recharge_activity/recharge_activity_panel")
    self:initUI(root)
end

function UIAccRechargePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/recharge_activity/recharge_activity_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.diamond_num = self.root.centre.Node_7.diamond_num_export
    self.chest_bg = self.root.centre.chest_bg_export
    self.loading_bg = self.root.centre.loading_bg_export
    self.loading = self.root.centre.loading_export
    self.node_chest = self.root.centre.node_chest_export
    self.next = self.root.centre.next_export
    self.gift_overtime_text = self.root.centre.timer_Node.gift_overtime_text_export
    self.contentLayout = self.root.centre.contentLayout_export
    self.itemLayout = self.root.centre.itemLayout_export
    self.node_tableView = self.root.centre.node_tableView_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_2, function(sender, eventType) self:onClosePanel(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.centre.intro_btn, function(sender, eventType) self:infoCall(sender, eventType) end)
--EXPORT_NODE_END

    local UIMultiTableView = require("game.UI.common.multiMenuView.UIMultiTableView")
    local UIAccRewardCell = require("game.UI.activity.accRecharge.UIAccRewardCell")
    self.tableView = UIMultiTableView.new()
        :setSize(self.contentLayout:getContentSize())
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIAccRewardCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)

    self.accTipsNode = cc.Node:create()
    self.root:addChild(self.accTipsNode)

    self.t_w = self.loading:getContentSize().width*self.loading_bg:getScaleX()
    -- self.t_w = 507
    self.m_pointData = self:getPointData()
    self.t_count = #self.m_pointData
    self.t_cellW = self.t_w/self.t_count

    self:initChest()
    -- self:initReward()
end

function UIAccRechargePanel:initChest(num)
    self.node_chest:removeAllChildren()
    self.chest = {}

    local UIAccChestWidget = require("game.UI.activity.accRecharge.UIAccChestWidget")
    
    for i=1,self.t_count do
        local chest = UIAccChestWidget.new()
        self.node_chest:addChild(chest)
        chest:setPositionX(self.t_cellW*0.5+(i-1)*self.t_cellW)
        chest.bar:setPositionX(self.t_cellW*0.5)
        chest:setData(self.m_pointData[i])
        self.chest[i] = chest
    end
end

function UIAccRechargePanel:onEnter()
end

function UIAccRechargePanel:onExit()
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

-- [LUA-print] dump from: [string "res/game/Data/ActivityData.lua"]:146: in function 'getCurrentActivityData'
-- [LUA-print] - "over_acativity" = {
-- [LUA-print] - }
-- [LUA-print] dump from: [string "res/game/UI/activity/accRecharge/UIAccRecha..."]:95: in function 'setData'
-- [LUA-print] - "<var>" = {
-- [LUA-print] -     "activity_id"        = 9001
-- [LUA-print] -     "btn" = {
-- [LUA-print] -         1 = 9
-- [LUA-print] -     }
-- [LUA-print] -     "castle_lv_max"      = 0
-- [LUA-print] -     "castle_lv_min"      = 1
-- [LUA-print] -     "content"            = 9
-- [LUA-print] -     "desc"               = 10751
-- [LUA-print] -     "desc_en"            = ""
-- [LUA-print] -     "end_notice"         = 90
-- [LUA-print] -     "icon"               = "icon/activity_open_s/activity_bg_10.png"
-- [LUA-print] -     "id"                 = 1
-- [LUA-print] -     "lv_max"             = 0
-- [LUA-print] -     "lv_min"             = 1
-- [LUA-print] -     "name"               = "累计充值活动"
-- [LUA-print] -     "name_en"            = ""
-- [LUA-print] -     "open_email"         = 10149
-- [LUA-print] -     "para1"              = 10148
-- [LUA-print] -     "para2"              = 0
-- [LUA-print] -     "para3"              = 0
-- [LUA-print] -     "para4"              = 0
-- [LUA-print] -     "para5"              = 0
-- [LUA-print] -     "para6"              = 0
-- [LUA-print] -     "point_rule"         = 0
-- [LUA-print] -     "rank"               = 0
-- [LUA-print] -     "reward"             = 0
-- [LUA-print] -     "reward_desc"        = ""
-- [LUA-print] -     "reward_desc_en"     = ""
-- [LUA-print] -     "reward_num"         = 1
-- [LUA-print] -     "reward_window"      = 0
-- [LUA-print] -     "serverdata" = {
-- [LUA-print] -         "lActId"   = 9001
-- [LUA-print] -         "lBngTime" = 1499941200
-- [LUA-print] -         "lEndTime" = 1500541200
-- [LUA-print] -         "lParam"   = 0
-- [LUA-print] -         "lParam2"  = 0
-- [LUA-print] -         "lStatus"  = 1
-- [LUA-print] -     }
-- [LUA-print] -     "simple_describe"    = "累计购买一定魔晶，就可以获得丰厚奖励！"
-- [LUA-print] -     "simple_describe_en" = ""
-- [LUA-print] -     "time_display"       = 0
-- [LUA-print] -     "type"               = 1
-- [LUA-print] - }

local UILongTipsControl = require("game.UI.common.UILongTipsControl")
function UIAccRechargePanel:showTips(icon,itemId)
    if not icon.m_TipsControl then
        icon.m_TipsControl = UILongTipsControl.new(icon,WCONST.LONG_TIPS_PANEL.ITEM_DESC)
    end
    icon.m_TipsControl:setData({information=global.luaCfg:get_item_by(itemId)})

    return m_TipsControl
end
function UIAccRechargePanel:getTipsNode()
    return self.root
end
function UIAccRechargePanel:getData()
    return self.data
end
function UIAccRechargePanel:setData(data)
    self.data =data
    self.payData = global.userData:getSumPay()
    if not self.data then return end
-- 
    -- dump(self.payData)
    self.diamond_num:setString(self.payData.lGet)
    self.m_currIdx = self:getCurrIdx(self.payData.lGet)
    local dm = self:getNextPointDt(self.m_currIdx)
    if dm>=0 then
        self.next:setString(global.luaCfg:get_local_string(10742,dm))
    else
        self.next:setString(global.luaCfg:get_local_string(10752))
    end
    self.loading:setPercent(self:getCurrPercent(self.payData.lGet))

    if not self.m_countDownTimer then
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
    self:countDownHandler()
    self:updateReward()
    self:gpsRule()
end

function UIAccRechargePanel:updateReward()
    self.chest_bg:setVisible(false)
    print("->>>>>>>>>>>>>"..self.m_currIdx)
    for i,v in pairs(self.chest) do
        if i == self.m_currIdx then
            self.chest_bg:setVisible(true)
            self.chest_bg:setPositionX(self.node_chest:getPositionX()+v:getPositionX())
        end
    end

    -- local dm = self:getNextPointDt(self.m_currIdx)
    for i=1,self.t_count do
        self.m_pointData[i].btReward = global.luaCfg:get_drop_by(self.m_pointData[i].reward)
        -- self.m_pointData[i].dm = self:getNextPointDt(i)
        -- 0:未达成，1：未领取，2：已经领取
        if self.m_currIdx > i then
            self.m_pointData[i].state = table.hasval(self.payData.lPickUp, self.m_pointData[i].point) and 2 or 1
        else
            self.m_pointData[i].state = 0
        end
        local rewardLen = #self.m_pointData[i].btReward.dropItem
        if rewardLen > 3 then
            self.m_pointData[i].uiData = {h = 275+(rewardLen-3)*60+15}
        else
            self.m_pointData[i].uiData = {h = 275+15}
        end
    end

    self.tableView:setData(self.m_pointData)
end

function UIAccRechargePanel:countDownHandler()
    local curr = global.dataMgr:getServerTime()
    local rest = 0
    if self.data.serverdata then
        rest = (self.data.serverdata.lEndTime or 0)-curr
    end
    if rest <= 0 then 
        rest = 0
        if self.m_countDownTimer then
            gscheduler.unscheduleGlobal(self.m_countDownTimer)
            self.m_countDownTimer = nil
        end
    end
    self.gift_overtime_text:setString(global.funcGame.formatTimeToHMS(rest))
end

function UIAccRechargePanel:getPointData()
    local points = global.luaCfg:point_reward()
    local data = {}
    for i,v in pairs(points) do
        if v.activity_id == 9001 then
            table.insert(data,v)
        end
    end
    table.sort(data,function(a,b)
        -- body
        return a.point < b.point
    end)
    return data
end

function UIAccRechargePanel:getCurrIdx(money)
    local idx = 1
    for i,v in ipairs(self.m_pointData) do
        if money<v.point then
            idx = i
            return idx
        end
    end
    return self.t_count+1
end

function UIAccRechargePanel:getNextPointDt(idx)
    if not self.m_pointData then return 0 end
    if idx > self.t_count then return -1 end
    local nowV = self.payData.lGet
    local nowIdx = idx
    value = self.m_pointData[nowIdx].point-nowV
    return value
end

function UIAccRechargePanel:getCurrPercent(money)
    if self.m_currIdx > self.t_count then return 100 end
    local nowV = self.m_pointData[self.m_currIdx].point
    local lastIdx = self.m_currIdx-1
    local per = 0
    if lastIdx < 1 then
        per = money/nowV/self.t_count*100
    else
        local lastV = self.m_pointData[lastIdx].point
        per = (lastIdx+(money-lastV)/(nowV-lastV))/self.t_count*100
    end
    return per
end

-- 制定定位规则
function UIAccRechargePanel:gpsRule()
    --dump(self.payData)
    if self.m_currIdx > self.t_count then
        -- 全部做完了
        if #self.payData.lPickUp > self.t_count then
            -- 全被领了
            self:gpsTBPos(self.t_count)
        else
            local minIdx = self.t_count+1
            local isHaveCanGet = false
            for i,v in pairs(self.m_pointData) do
                if table.hasval(self.payData.lPickUp,v.point) then
                else
                    if i < self.m_currIdx then
                        isHaveCanGet = true
                        if i < minIdx then
                            minIdx = i
                        end
                    end
                end
            end
            if not isHaveCanGet then
                minIdx = self.m_currIdx
            end
            self:gpsTBPos(minIdx)
        end
    else
        local minIdx = self.m_currIdx
        local isHaveCanGet = false
        for i,v in pairs(self.m_pointData) do
            if table.hasval(self.payData.lPickUp,v.point) then
            else
                if i < self.m_currIdx then
                    isHaveCanGet = true
                    if i < minIdx then
                        minIdx = i
                    end
                end
            end
        end
        if not isHaveCanGet then
            minIdx = self.m_currIdx
        end
        self:gpsTBPos(minIdx)
    end
end

-- 跟随定位到奖励list对应的cell
function UIAccRechargePanel:gpsTBPos(t_idx)
    local dh = 0
    local maxH = 0
    local viewH = self.contentLayout:getContentSize().height
    for i=t_idx,self.t_count do
        local v = self.m_pointData[i]
        if i == t_idx then
            dh = dh+(v.uiData.h-viewH)
        else
            dh = dh+v.uiData.h
        end
    end
    local offset = self.tableView:getContentOffset()
    offset.y = -dh
    self.tableView:setContentOffset(offset)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIAccRechargePanel:onClosePanel(sender, eventType)
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")
    global.panelMgr:closePanel("UIAccRechargePanel")
end

function UIAccRechargePanel:infoCall(sender, eventType)
    local data = global.luaCfg:get_introduction_by(19)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end
--CALLBACKS_FUNCS_END

return UIAccRechargePanel

--endregion
