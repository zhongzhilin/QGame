local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIInviteItemCell  = class("UIInviteItemCell", function() return cc.TableViewCell:create() end )

function UIInviteItemCell:ctor()
    self:CreateUI()
end

function UIInviteItemCell:CreateUI()

end

function UIInviteItemCell:onClick()
 
end

function UIInviteItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIInviteItemCell:updateUI()

	local classname = "game.UI.invite.UIInviteItem"..global.panelMgr:getPanel("UIInvitePanel").index
	print(classname ,"classname->>>")
	if not self.item or self.item.__cname~=classname then 
		if self.item  then self.item:removeFromParent() end 
		self.item =  require(classname).new()
    	self:addChild(self.item)
	end

    self.item:setData(self.data)
end

return UIInviteItemCell