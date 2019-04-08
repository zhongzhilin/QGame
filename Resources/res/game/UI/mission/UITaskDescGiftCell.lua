local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData

local UITaskDescGiftCell  = class("UITaskDescGiftCell", function() return cc.TableViewCell:create() end )
local UITaskDescGiftItem = require("game.UI.mission.UITaskDescGiftItem")

function UITaskDescGiftCell:ctor()
    self:CreateUI()
end

function UITaskDescGiftCell:CreateUI()

    self.item = UITaskDescGiftItem.new()    
    self:addChild(self.item)
end

function UITaskDescGiftCell:onClick()
    -- gevent:call(global.gameEvent.EV_ON_SERVER_ITEM_SELECT, self.data.id)
    -- log.debug("on click")
    
    -- local descPanel = global.panelMgr:openPanel("UITaskDescPanel")
    -- descPanel:setData(self.data)
end

function UITaskDescGiftCell:setData(data)
    self.data = data
    self:updateUI()
end

function UITaskDescGiftCell:updateUI(idx)
    self.item:setData(self.data)
end

return UITaskDescGiftCell