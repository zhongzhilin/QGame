--
-- Author: Your Name
-- Date: 2017-03-20 20:12:46
--
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UIDescribeItemCell  = class("UIDescribeItemCell", function() return cc.TableViewCell:create() end )
local UIUnionBtnItem = require("game.UI.vip.UIDescribeItem")

function UIDescribeItemCell:ctor()
    self:CreateUI()
end

function UIDescribeItemCell:CreateUI()
    self.item = UIUnionBtnItem.new() 
    self:addChild(self.item)
end
 

function UIDescribeItemCell:onClick()
end

function UIDescribeItemCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end
 
return UIDescribeItemCell