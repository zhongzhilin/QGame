local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData

local UIDailyTaskItemCell  = class("UIDailyTaskItemCell", function() return cc.TableViewCell:create() end )
local UIDailyTaskItem = require("game.UI.dailyMission.UIDailyTaskItem")

function UIDailyTaskItemCell:ctor()
    
    self:CreateUI()
end

function UIDailyTaskItemCell:CreateUI()

    self.item = UIDailyTaskItem.new()    
    self:addChild(self.item)
end

function UIDailyTaskItemCell:onClick()
    -- gevent:call(global.gameEvent.EV_ON_SERVER_ITEM_SELECT, self.data.id)
    -- log.debug("on click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_DayTaskClick")
    
    if self.data.state == WDEFINE.DAILY_TASK.TASK_STATE.LOCK then

        local taskData = luaCfg:get_daily_task_by(self.data.id)
    	local buildName = luaCfg:get_buildings_pos_by(taskData.unlockId).buildsName
        local lv = taskData.unlockLv
        global.tipsMgr:showWarning(luaCfg:get_local_string(10200, buildName, lv))
    	return
    elseif self.data.state == WDEFINE.DAILY_TASK.TASK_STATE.DONE  then 
        self:confirmCall()
        return 
    end 

    global.panelMgr:openPanel("UIDailyTaskDesc"):setData(self.data, handler(self, self.confirmCall))
end

function UIDailyTaskItemCell:confirmCall()
    
    if self.data.state == WDEFINE.DAILY_TASK.TASK_STATE.DONE then
        self.item:taskFinished()
    end 
end

function UIDailyTaskItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIDailyTaskItemCell:updateUI()
    self.item:setData(self.data)
end

return UIDailyTaskItemCell