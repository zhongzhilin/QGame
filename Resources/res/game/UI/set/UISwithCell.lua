--
-- Author: Your Name
-- Date: 2017-03-31 17:11:09
--


local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UISwithCell  = class("UISwithCell", function() return cc.TableViewCell:create() end )
local uiPushMessgeItem = require("game.UI.set.UIPushMessgeItem")

function UISwithCell:ctor()
    self:CreateUI()
end

function UISwithCell:CreateUI()
    self.item = uiPushMessgeItem.new() 
    self:addChild(self.item)
end

function UISwithCell:onClick()
	
end

function UISwithCell:setData(data)

    self.data = data
	local item = self.item
	local switchType=  global.panelMgr:getPanel("UISwitchPanel").switchType or 1 

	if switchType == 1 then 

		item.data = data 
		item.switch:setSelect(item.data.status,false ,true)
		item.message_type:setString(gls(item.data.title))
		item.message_content:setString(gls(item.data.des))

		item.switch:addEventListener(function(isOpen)
			global.PushInfoAPI:getConfigureList(3,item.data.id,function(ret,msg)
				
			end)
			item.data.status = isOpen
		end)
	end 

end

function UISwithCell:updateUI()
   --self.item:setData(self.data)
end

 
return UISwithCell