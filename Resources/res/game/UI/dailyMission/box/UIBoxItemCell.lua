local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData

local UIBoxItemCell  = class("UIBoxItemCell", function() return cc.TableViewCell:create() end )
local UIBoxItem = require("game.UI.dailyMission.box.UIBoxItem")

function UIBoxItemCell:ctor()
    
    self:CreateUI()
end

function UIBoxItemCell:CreateUI()

    self.item = UIBoxItem.new()    
    self:addChild(self.item)
end

function UIBoxItemCell:onClick()    
    

    global.panelMgr:openPanel("UIDailyTaskRewardPanel"):setID(self.data.sort)
end

function UIBoxItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIBoxItemCell:updateUI()
    self.item:setData(self.data)
end

return UIBoxItemCell