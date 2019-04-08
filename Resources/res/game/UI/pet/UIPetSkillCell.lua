local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIPetSkillCell  = class("UIPetSkillCell", function() return cc.TableViewCell:create() end )
local UIPetSkillItem = require("game.UI.pet.UIPetSkillItem")

function UIPetSkillCell:ctor()
    self:CreateUI()
end

function UIPetSkillCell:CreateUI()

    self.item = UIPetSkillItem.new() 
    self:addChild(self.item)
end

function UIPetSkillCell:onClick()
end

function UIPetSkillCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIPetSkillCell:updateUI()
    self.item:setData(self.data)
end

return UIPetSkillCell