local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIQuestionCell  = class("UIQuestionCell", function() return cc.TableViewCell:create() end )
local UIQuestionNode = require("game.UI.commonUI.UIQuestionNode")

function UIQuestionCell:ctor()
    self:CreateUI()
end

function UIQuestionCell:CreateUI()

    self.item = UIQuestionNode.new() 
    self:addChild(self.item)
end

function UIQuestionCell:onClick()
end

function UIQuestionCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIQuestionCell:updateUI()
    self.item:setData(self.data)
end

return UIQuestionCell