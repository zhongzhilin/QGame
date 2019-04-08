local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIPetSkillUseCell  = class("UIPetSkillUseCell", function() return cc.TableViewCell:create() end )
local UIPetSkillUseItem = require("game.UI.pet.UIPetSkillUseItem")

function UIPetSkillUseCell:ctor()
    self:CreateUI()
end

function UIPetSkillUseCell:CreateUI()

    self.item = UIPetSkillUseItem.new() 
    self:addChild(self.item)
end

function UIPetSkillUseCell:onClick()
end

function UIPetSkillUseCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIPetSkillUseCell:updateUI()
    self.item:setData(self.data)
end

return UIPetSkillUseCell