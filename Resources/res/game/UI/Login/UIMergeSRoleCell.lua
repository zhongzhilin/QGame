local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userDat

local UIMergeSRoleCell  = class("UIMergeSRoleCell", function() return cc.TableViewCell:create() end )
local UIMergeSRoleItem = require("game.UI.Login.UIMergeSRoleItem")
local UILogin = require("game.UI.Login.UILogin")

function UIMergeSRoleCell:ctor()
    
    self:CreateUI()
end

function UIMergeSRoleCell:CreateUI()

    self.item = UIMergeSRoleItem.new() 
    self:addChild(self.item)
end

function UIMergeSRoleCell:setFocus(isSelected)
    self.item:setSelected(isSelected)
end

function UIMergeSRoleCell:onClick()

end

function UIMergeSRoleCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIMergeSRoleCell:updateUI()
    self.item:setData(self.data)
end

return UIMergeSRoleCell