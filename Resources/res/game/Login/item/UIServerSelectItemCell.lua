--region UIServerSelectItemCell.lua
--Author : ethan
--Date   : 2016/04/20
--generate by [generate_ui_code.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData

local UIServerSelectItemCell  = class("UIServerSelectItemCell", function() return cc.TableViewCell:create() end )
local UIServerSelectItem = require("game.Login.item.UIServerSelectItem")

function UIServerSelectItemCell:ctor()
    self:CreateUI()
end

function UIServerSelectItemCell:CreateUI()
    self.item = UIServerSelectItem.new()    
    self.item:CreateUI()
    self:addChild(self.item)
end

function UIServerSelectItemCell:onClick()
    gevent:call(global.gameEvent.EV_ON_SERVER_ITEM_SELECT, self.data.id)
end

function UIServerSelectItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIServerSelectItemCell:updateUI()
    self.item:setData(self.data)
end

return UIServerSelectItemCell

--endregion