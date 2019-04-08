--region UIAccRewardItem.lua
--Author : wuwx
--Date   : 2017/07/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIAccRewardCell  = class("UIAccRewardCell", function() return cc.TableViewCell:create() end )

function UIAccRewardCell:ctor()
    self:CreateUI()
end

function UIAccRewardCell:CreateUI()
    self.item = require("game.UI.activity.accRecharge.UIAccRewardItem").new() 
    self:addChild(self.item)
end

function UIAccRewardCell:onClick()
end

function UIAccRewardCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIAccRewardCell:updateUI()
    self.item:setData(self.data)
end

return UIAccRewardCell