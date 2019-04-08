--region UIDailyTaskRewardPanel.lua
--Author : untory
--Date   : 2016/08/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local propData = global.propData
local userData = global.userData
local dataMgr = global.dataMgr
local UITableView = require("game.UI.common.UITableView")
local UIDailyTaskRewardItemCell = require("game.UI.dailyMission.UIDailyTaskRewardItemCell")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END
local dailyTaskData = global.dailyTaskData

local UIDailyTaskRewardPanel  = class("UIDailyTaskRewardPanel", function() return gdisplay.newWidget() end )

function UIDailyTaskRewardPanel:ctor()
    self:CreateUI()
end

function UIDailyTaskRewardPanel:CreateUI()
    local root = resMgr:createWidget("task/task_daily_reward_bg")
    self:initUI(root)
end

function UIDailyTaskRewardPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "task/task_daily_reward_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Panel = self.root.Panel_export
    self.Node = self.root.Node_export
    self.Image_1 = self.root.Node_export.Node_2.Image_1_export
    self.get = self.root.Node_export.Node_2.get_export
    self.tableView_size = self.root.Node_export.Node_2.tableView_size_export
    self.cell = self.root.Node_export.Node_2.tableView_size_export.cell_export
    self.Button_1 = self.root.Node_export.Node_2.Button_1_export
    self.Text_state = self.root.Node_export.Node_2.Button_1_export.Text_state_export
    self.tableviewnode = self.root.Node_export.Node_2.tableviewnode_export
    self.effect = self.root.Node_export.effect_export

    uiMgr:addWidgetTouchHandler(self.Panel, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:jump_call(sender, eventType) end)
--EXPORT_NODE_END

    self.btn = self.Button_1

    self.tableView = UITableView.new()
        :setSize(self.tableView_size:getContentSize())
        :setCellSize(self.cell:getContentSize())
        :setCellTemplate(UIDailyTaskRewardItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)

    self.tableviewnode:addChild(self.tableView)

    self.tips_node = cc.Node:create()
    self:addChild(self.tips_node)

end

local picBg = {
    [1] = "ui_button/btn_equip_grey.png",
    [2] = "ui_button/btn_reward.png",
}

-- 設置boss  禮包数据
function UIDailyTaskRewardPanel:setBossData(id,isCanGet,gateid,call)
    self.is_show_boss = true
    self.gateid = gateid 
    self.itemid = id 
    self.finishcall = call
    local dropData = luaCfg:get_drop_by(id)
    self.tableView:setData(dropData.dropItem)
    self.get:setVisible(false)
    self.effect:setVisible(false)
    local stateStrId = ""
     self.CanGet = isCanGet
    local currentState = isCanGet
    if currentState ==false  then
        self.isCanGet = false
        stateStrId = 10016
        gevent:call(gsound.EV_ON_PLAYSOUND,"box_Close")
        self.btn:setEnabled(false)
        self.Button_1:loadTextures(picBg[1],picBg[1],picBg[1],ccui.TextureResType.plistType)
    else
        stateStrId = 10013
        self.btn:setEnabled(true)
        self.get:setVisible(true)
        self.effect:setVisible(true)
        local nodeTimeLine1 = resMgr:createTimeline("task/task_daily_reward_bg")
        nodeTimeLine1:play("animation0", false)
        self:runAction(nodeTimeLine1)
        self.Button_1:loadTextures(picBg[2],picBg[2],picBg[2],ccui.TextureResType.plistType)
    end
    self.Text_state:setString(luaCfg:get_local_string(stateStrId)) 
end

function UIDailyTaskRewardPanel:getBagData(id)
    
    local curLv = global.cityData:getBuildingById(1).serverData.lGrade
    local dailyData = luaCfg:daily_reward()
    for _,v in ipairs(dailyData) do
        if v.level == curLv then
            return v
        end
    end
end

function UIDailyTaskRewardPanel:setID(id)
    -- body

    local rewardData = self:getBagData(id) or {}
    local dropData = luaCfg:get_drop_by(rewardData["reward"..id] or 10001)

    self.tableView:setData(dropData.dropItem)

    self.id = id

    self.get:setVisible(false)
    self.effect:setVisible(false)
    local stateStrId = ""
    local currentState = dailyTaskData:getBoxs()[self.id].state
    self.Button_1:loadTextures(picBg[1],picBg[1],picBg[1],ccui.TextureResType.plistType)
    if currentState == WDEFINE.DAILY_TASK.TASK_STATE.WORKING then

        gevent:call(gsound.EV_ON_PLAYSOUND,"box_Close")
        self.isCanGet = false
        stateStrId = 10016
        self.btn:setEnabled(false)

    else

        self.isCanGet = true
        if currentState == WDEFINE.DAILY_TASK.TASK_STATE.GETD then
            stateStrId = 10201
            self.btn:setEnabled(false)
        elseif currentState == WDEFINE.DAILY_TASK.TASK_STATE.DONE then
            stateStrId = 10013
            self.btn:setEnabled(true)
            self.get:setVisible(true)
            self.effect:setVisible(true)
            local nodeTimeLine1 = resMgr:createTimeline("task/task_daily_reward_bg")
            nodeTimeLine1:play("animation0", false)
            self:runAction(nodeTimeLine1)
            self.Button_1:loadTextures(picBg[2],picBg[2],picBg[2],ccui.TextureResType.plistType)
        end
    end

    self.Text_state:setString(luaCfg:get_local_string(stateStrId)) 
   
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIDailyTaskRewardPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIDailyTaskRewardPanel")
end

function UIDailyTaskRewardPanel:jump_call(sender, eventType)
    if self.is_show_boss then 
        if self.CanGet then 
            global.BossChestAPI:gateBossChestReq(self.gateid,function(ret,msg)
                if ret.retcode == 0 then
                    global.bossData:setGateChestStatus(self.gateid,1) --设置礼包为已经领取状态
                    local dropData = luaCfg:get_drop_by(self.itemid)
                    if self.finishcall then
                        self.finishcall()
                    end 
                    if dropData then
                        global.panelMgr:closePanel("UIDailyTaskRewardPanel")
                        global.panelMgr:openPanel("UIItemRewardPanel"):setData(dropData.dropItem)
                    end 
                end 
             end)
        end
        self.CanGet = nil 
        self.is_show_boss = nil 
        return 
    else   
        if self.isCanGet == false then
            global.panelMgr:closePanel("UIDailyTaskRewardPanel")
            return
        end

        if not self.id then return end
        local rewardData = self:getBagData(self.id) 
        if not rewardData then return end
        local dropData = luaCfg:get_drop_by(rewardData["reward"..self.id])

        local id = self.id
        local currentScore = dailyTaskData:getBoxs()[self.id].score
        global.taskApi:getReward(1, currentScore,function(msg)
      
            global.panelMgr:openPanel("UIItemRewardPanel"):setData(dropData.dropItem)
            
            global.panelMgr:closePanel("UIDailyTaskRewardPanel")
            dailyTaskData:getBoxGift(id)

            local  taskPanel = global.panelMgr:getPanel("UIDailyTaskPanel")
            taskPanel.isOpenEffectId = currentScore
            taskPanel:updateScore(true)

            dailyTaskData:refershBoxState() -- 刷新建筑是否有未领取图标
        end)
    end 

    -- local msg = {

    --     status = 1000,
    --     dropItem={{2,20},{1,10}},
    -- }

    -- if msg.status == 1000 then
        
    --     local tipStr = dataMgr:updateItems(msg.dropItem)
    --     global.tipsMgr:showTaskTips(tipStr)

    --     global.panelMgr:closePanel("UIDailyTaskRewardPanel")
    --     dailyTaskData:getBoxGift(self.id)
    --     -- taskData:updateNormalTask(msg.taskData)
    -- elseif msg.status == taskData.GET_REQUEST_STATUS_ERROR then

    --     log.debug("领取失败")
    -- end
end
--CALLBACKS_FUNCS_END

return UIDailyTaskRewardPanel

--endregion
