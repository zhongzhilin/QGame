local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData

local NormalTaskItemCell  = class("NormalTaskItemCell", function() return cc.TableViewCell:create() end )
local NormalTaskItem = require("game.UI.mission.NormalTaskItem")

function NormalTaskItemCell:ctor()
    
    self:CreateUI()
end

function NormalTaskItemCell:CreateUI()

    self.item = NormalTaskItem.new()    
    self:addChild(self.item)
end

function NormalTaskItemCell:onClick()
    -- gevent:call(global.gameEvent.EV_ON_SERVER_ITEM_SELECT, self.data.id)
    -- log.debug("on click")
    
    local descPanel = global.panelMgr:openPanel("UITaskDescPanel")
    descPanel:setData(self.item.data)
end

function NormalTaskItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function NormalTaskItemCell:updateUI()
    self.item:setData(self.data)
end

return NormalTaskItemCell