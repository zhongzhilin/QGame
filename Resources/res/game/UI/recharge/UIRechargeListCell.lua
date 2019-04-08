local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIRechargeListCell  = class("UIRechargeListCell", function() return cc.TableViewCell:create() end )
local UIRechargeItem = require("game.UI.recharge.UIRechargeListItem")

function UIRechargeListCell:ctor()
    self:CreateUI()
end

function UIRechargeListCell:CreateUI()

    self.item = UIRechargeItem.new() 
    self:addChild(self.item)
end

local panel = global.EasyDev.RECHARGE_PANEL
local method = global.EasyDev.RECHARGE_PANEL_METHOD

function UIRechargeListCell:onClick()

    gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")
    

	local goToPanel = panel[self.data.id]

	if goToPanel ~= global.panelMgr:getTopPanelName() then 

		local last_panel = global.panelMgr:getTopPanelName()

		local p = global.panelMgr:openPanel(goToPanel)

		if  p then 

			if p.setIdx then
				p:setIdx(self.data.id)
			end

			if p.changeMode then  --隐藏一些东西
				p:changeMode()
			end
			if method[self.data.id] and p[method[self.data.id]] then 
				p[method[self.data.id]](p)
			end 
			global.panelMgr:closePanel(last_panel)
		end 
		
	end 

end

function UIRechargeListCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIRechargeListCell:updateUI()
    self.item:setData(self.data)
end

return UIRechargeListCell