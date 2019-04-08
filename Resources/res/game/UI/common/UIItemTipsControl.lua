local UIItemDescriptionNode = require("game.UI.common.UIItemDescriptionNode")
local UIHeroTipsNode = require("game.UI.replay.view.UIHeroTipsNode")
local UIPetEquipTips = require("game.UI.pet.UIPetEquipTips")
local UIItemDescMode2 = require("game.UI.common.UIItemDescMode2")
local UIBuffDes = require("game.UI.commonUI.UIBuffDes")
local UIItemTipsControl  = class("UIItemTipsControl")
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg


function UIItemTipsControl:ctor()

end

function UIItemTipsControl:setdata(original,data,target)

	self.original = original 

	if data.information then 
		
		self.data =data
	else 
		self.data = {information =data} 
	end 

	self.target = target


	if not target then 
		local panel = global.panelMgr:getTopPanel()
		if not panel.tips_node then 
			local tips_node = cc.Node:create()
			panel.tips_node = tips_node
    		panel.root:addChild(tips_node)
		end 
    	self.target =panel.tips_node
	end 

	self:initTouch()
	-- print('self.original ',self.original )
	-- print('self.target ',self.target )
	self.data.control  = self


	self.tipsArr= {

		default = function () return UIItemDescriptionNode.new() end ,  
		replayHero = function () return UIHeroTipsNode.new() end ,  
		UIPetEquipTips = function () return UIPetEquipTips.new() end ,  
		UIItemDescMode2 = function () return UIItemDescMode2.new() end , 
		UIBuffDes = function () return UIBuffDes.new() end , 
	}

	self.tips_type = self.data.tips_type or  self.data.information.tips_type or  "default"

end 



function UIItemTipsControl:bindTips(pos)

	-- print("多少个tips a ;/////////////////////////////")

	if self.target and self.target[self.tips_type] and not self.tips  then  -- 所有items  都用一个tips
		self.tips = self.target[self.tips_type]
	end  	

	if not self.tips then 

		local desc_node =self.tipsArr[self.tips_type]()

		desc_node:setData(self.data)
		if not self.target then 
			self.original:addChild(desc_node)
		else
			self.target:addChild(desc_node)
			self.target[self.tips_type] = desc_node
		end
		self.tips = desc_node
		self.tips:setVisible(false)

		if self.isdelay then  --是否延迟显示 
			gscheduler.performWithDelayGlobal(function()
				if self.isTouch == 1 then 
					self.tips:setVisible(true)
				end 		    
			end, 0.2)
		else  
			gscheduler.performWithDelayGlobal(function()
				if self.isTouch == 1 then 
					self.tips:setVisible(true)
				end 		    
			end, 0.1)
		end 

	else 
		self.tips:setVisible(false)
		self.tips:setData(self.data)
		if self.isdelay then  --是否延迟显示 
			gscheduler.performWithDelayGlobal(function()
				if self.isTouch == 1 then 
					self.tips:setVisible(true)
				end 		    
			end, 0.2)
		else  
			gscheduler.performWithDelayGlobal(function()
				if self.isTouch == 1 then 
					self.tips:setVisible(true)
				end 		    
			end, 0.1)
		end 
	end
	if pos then 
		if not self.target then 
			self.tips:setPosition(cc.p(self:adjustPosition(pos)))
		--self.tips:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.FadeIn:create(0.5)))
		else
			self.target:setPosition(cc.p(self:adjustPosition(pos)))
			self.target:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.FadeIn:create(0.5)))
		end 
	end 
end


function UIItemTipsControl:setIsDelay(isdelay)
	self.isdelay= isdelay
end 

local part_height =  30 
function UIItemTipsControl:adjustPosition(touchpoint)
	
	self.tipsContentSize= self.tips.root.bg:getContentSize()

	local tipscw =self.tipsContentSize.width/2
	local tipsch = self.tipsContentSize.height

    local originalwWorldSpace = self.original:convertToWorldSpace(cc.p(0,0))
	local touchNodePoint =  self.original:convertToNodeSpace(touchpoint)

	if not self.target then  -- 如果直接在 原目标上加tips 
		if (originalwWorldSpace.x + touchNodePoint.x) < tipscw then 
			touchpoint.x = tipscw - originalwWorldSpace.x
		elseif (originalwWorldSpace.x + touchNodePoint.x + tipscw ) > gdisplay.width then
			-- local over =(originalwWorldSpace.x + touchNodePoint.x + tipscw) - gdisplay.width 
			local x = gdisplay.width- tipscw
			touchpoint.x = self.original:convertToNodeSpace(cc.p(x,0)).x
		else
			touchpoint.x = touchNodePoint.x 
		end 
 		touchpoint.y = touchNodePoint.y+tipsch/2
	else 
		-- tiips 向下显示
		if self.tipsContentSize.height +touchpoint.y > gdisplay.height  and touchpoint.y > gdisplay.height/2 then 
			touchpoint.y =   touchpoint.y - part_height * 2
			if touchpoint.y - self.tipsContentSize.height < 0 then 
				 touchpoint.y = 0
			else  
				touchpoint.y = touchpoint.y- self.tipsContentSize.height 
			end 
			if touchpoint.x > gdisplay.width/2  then  --right
				if touchpoint.x - self.tipsContentSize.width > 0  then 
					touchpoint.x =touchpoint.x - tipscw
				else 
					touchpoint.x  = tipscw 
				end
			else -- left 
				if  self.tipsContentSize.width + touchpoint.x < gdisplay.width  then 
						touchpoint.x =  touchpoint.x + tipscw
				else 
						touchpoint.x  = gdisplay.width - tipscw
				end
			end  
		else  -- 默认向上显示
			if tipscw > touchpoint.x  then -- 
				touchpoint.x = tipscw
			elseif (touchpoint.x+ tipscw)> gdisplay.width then 
				touchpoint.x  =  gdisplay.width-tipscw
			end
			if  self.tipsContentSize.height + touchpoint.y > gdisplay.height or  gdisplay.height <  self.tipsContentSize.height + touchpoint.y+part_height  then
				touchpoint.y =  gdisplay.height -   self.tipsContentSize.height
			else
				touchpoint.y = touchpoint.y + part_height
			end 
		end
	end 
	return touchpoint
end

-- 默认向上显示
-- tips

function UIItemTipsControl:setTipsContontSize(size)
	self.tipsContentSize = clone(size)
	dump(self.tipsContentSize,"默认向上显示")
end 

function UIItemTipsControl:adjustPositionY(y)

	print( gdisplay.height," gdisplay.height")
	print(  y ," y")
	dump(self.tipsContentSize,"默认向上=============显示")
	if self.tipsContentSize then 
		if self.tipsContentSize.height + y > gdisplay.height then 
			y = y- self.tipsContentSize.height
		end 
	end
	return  y
end 



function UIItemTipsControl:updateData(data)

	self.data  = data 

end 

function UIItemTipsControl:initTouch()

	--添加监听	
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan) , cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchCancel), cc.Handler.EVENT_TOUCH_CANCELLED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self.original)

end

function UIItemTipsControl:onTouchCancel(touch , event)
	if self.tips   then 
		self.tips:setVisible(false)
	end 
	self.isTouch  = 0 
end 
 
function UIItemTipsControl:onTouchMoved(touch, event)

    self.movetouch = touch:getLocation()
	local y =  math.abs((self.y - self.movetouch.y)) > 4
	local x =  math.abs((self.x - self.movetouch.x)) > 4
	if  y  or  x  then 
		self.isTouch = 0 
	end 

    if self.tips and self.tips:isVisible() then 
		local y =  math.abs((self.y - self.movetouch.y)) > 15
	    local x =  math.abs((self.x - self.movetouch.x)) > 15
	    if self.tips and ( y  or  x )then 
			self.tips:setVisible(false)
		end 
	end 
end


function UIItemTipsControl:onTouchBegan(touch, event)
		self.isTouch  =   self.isTouch  or 0 
		self.isTouch  = self.isTouch + 1
	  	local beganPoint = touch:getLocation()
	  	self.x = beganPoint.x 
	  	self.y = beganPoint.y 
	  	self.beginPoint = clone(beganPoint)
	    -- local AnchorPoint = self.original:getAnchorPoint()
	    -- local worldpoint = self.original:convertToWorldSpaceAR(cc.p(0,0))
	    -- local originalrect = cc.rect(worldpoint.x,worldpoint.y,self.original:getBoundingBox().width,self.original:getBoundingBox().height)
	    local box = self.original:getContentSize()
	    local resRect = cc.rect(0,0,box.width,box.height)
	    if CCHgame:isNodeBeTouch(self.original, resRect,beganPoint) then
	    	self:bindTips(self.beginPoint)
	    end
       -- end 
    return true
end


function UIItemTipsControl:setCheckMode(checkmode)
	self.checkmode =  checkmode 
end

function UIItemTipsControl:CheckContrains(rect , point)
	  if cc.rectContainsPoint(rect,point) then 
	    	self:bindTips(self.beginPoint)
	  end  
end

function UIItemTipsControl:onTouchEnded(touch, event)
	if self.tips   then 
		self.tips:setVisible(false)
	end 
	self.isTouch  = 0 
end 

function UIItemTipsControl:ClearEventListener()
	self.isTouch  = 0
	self.isdelay= nil 
	if self.touchEventListener  then 
      	cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
      	self.touchEventListener  = nil
    end

    if self.tips   then 
		self.tips:setVisible(false)
	end 
end 


return UIItemTipsControl