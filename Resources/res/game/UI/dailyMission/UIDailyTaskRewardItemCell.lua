local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData

local UIDailyTaskRewardItemCell  = class("UIDailyTaskItemCell", function() return cc.TableViewCell:create() end )
local UIDailyTaskRewardItem = require("game.UI.dailyMission.UIDailyTaskRewardItem")

function UIDailyTaskRewardItemCell:ctor()
    
    self:CreateUI()
end

function UIDailyTaskRewardItemCell:CreateUI()

    self.item = UIDailyTaskRewardItem.new()    
    self:addChild(self.item)
end

function UIDailyTaskRewardItemCell:onClick()
    -- gevent:call(global.gameEvent.EV_ON_SERVER_ITEM_SELECT, self.data.id)
    -- log.debug("on click")
    
    -- global.panelMgr:openPanel("UIDailyTaskDesc"):setData(self.data)
end

function UIDailyTaskRewardItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIDailyTaskRewardItemCell:updateUI()
    self.item:setData(self.data)
end

return UIDailyTaskRewardItemCell