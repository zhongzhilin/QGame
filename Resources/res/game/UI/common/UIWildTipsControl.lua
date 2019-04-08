
local UIWildTipsNode = require("game.UI.common.UIWildTipsNode")

local UIWallTipsNode = require("game.UI.common.UIWallTipsNode")

local UIWallDefTipsNode = require("game.UI.common.UIWallDefTipsNode")

local UIWildTipsControl  = class("UIWildTipsControl")
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg



function UIWildTipsControl:ctor()

end

function UIWildTipsControl:setdata(original,data,target)
	
	self.original = original 

	self.data =data
	
	self.target = target

	self:initTouch()

	self:setTips()

	if self.tips  then 
   		self:setTipsContontSize(self.tips:getContentSize())
	end
end

local tips_type = {wall=1 , wild= 2 , city = 3 } 

function UIWildTipsControl:setTips() 

	if self.data.tips_type  ==tips_type.wall then 

		if self.target and self.target.WallTips then  -- 所有items  都用一个tips

			self.tips = self.target.WallTips

		elseif not self.tips then

			local desc_node  =UIWallTipsNode.new()

			self.target:addChild(desc_node)

			self.target.WallTips = desc_node

			self.tips  = desc_node

			self.tips:setVisible(false)
		end   

	elseif self.data.tips_type  ==tips_type.wild   then 

		if self.target and self.target.WildTips then  -- 所有items  都用一个tips

			self.tips = self.target.WildTips

		elseif not self.tips then

			local desc_node  =UIWildTipsNode.new()

			self.target:addChild(desc_node)

			self.target.WildTips = desc_node

			self.tips  = desc_node

			self.tips:setVisible(false)
		end   

	elseif self.data.tips_type  ==tips_type.city then 

		if self.target and self.target.CityTips then  -- 所有items  都用一个tips

			self.tips = self.target.CityTips

		elseif not self.tips then

			local desc_node  =UIWallDefTipsNode.new()

			self.target:addChild(desc_node)

			self.target.CityTips = desc_node

			self.tips  = desc_node

			self.tips:setVisible(false)
		end   
	end 
	
end 

function UIWildTipsControl:updateData(data)
	self.data =data
end 

function UIWildTipsControl:bindTips(pos, isinit)


	self.tips:stopAllActions()
 	
	local time = 0.2
 	if self.isdelay then 
 		time = 0.2
 	end 
	

	local action = cc.Sequence:create(
			cc.DelayTime:create(time)
		, cc.CallFunc:create( function ()

		self.tips:setData(self.data)

		self.tips:setVisible(true)
		end 	
		)
	)

	self.tips:runAction(action)

	-- self:cleantimer()
	-- if self.isdelay then  --是否延迟显示 
	-- 	self.timer = gscheduler.scheduleGlobal(function()
	-- 		self.tips:setData(self.data)
	-- 		self.tips:setVisible(true)
	-- 		self:cleantimer()
	-- 	end, 0.2)
	-- 	
	-- else  
	-- 	self.timer = gscheduler.scheduleGlobal(function()
	-- 		self.tips:setData(self.data)
	-- 		self.tips:setVisible(true)
	-- 		self:cleantimer()
	-- 	end, 0.1)
	-- end 

	if not self.target then 
		self.tips:setPosition(cc.p(self:adjustPosition(pos)))
	else
		self.target:setPosition(cc.p(self:adjustPosition(pos)))
	end 

end

function UIWildTipsControl:cleantimer()
	if self.timer then
        gscheduler.unscheduleGlobal(self.timer)
        self.timer = nil
    end
end

function UIWildTipsControl:setIsDelay(isdelay)
	self.isdelay= isdelay
end 

local  part_height = 30 
-- local  gdisplay = {width =720 ,height =1280}
function UIWildTipsControl:adjustPosition(touchpoint)
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
 		touchpoint.y = touchNodePoint.y+part_height
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

-- tips
function UIWildTipsControl:setTipsContontSize(size)
	self.tipsContentSize = clone(size)
	-- dump(self.tipsContentSize,"默认向上显示")
end 

function UIWildTipsControl:adjustPositionY(touchpoint)
	print( gdisplay.height," gdisplay.height")
	if self.tipsContentSize then 
		if self.tipsContentSize.height +touchpoint.y > gdisplay.height  and touchpoint.y > gdisplay.height/2 then 
			touchpoint.y = touchpoint.y- self.tipsContentSize.height - part_height*2   -- tiips 向下显示
			-- -- tiaozheng 
			-- if touchpoint.x > gdisplay.width /2 then  -- 右边
			-- 	if touchpoint.x  - self.tipsContentSize.width > 0 then 
			-- 		touchpoint.x = 
			-- 	else 
			-- 	end   
			-- else  --左边 
			-- end 
			-- here 
		end 
	end
	return  touchpoint
end 


function UIWildTipsControl:initTouch()

	--添加监听	
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan) , cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchCancel), cc.Handler.EVENT_TOUCH_CANCELLED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self.original)

end

function UIWildTipsControl:onTouchCancel(touch , event)
	self:cleantimer()
	if self.tips   then 
		self.tips:stopAllActions()
		self.tips:setVisible(false)
	end 
end 
 
function UIWildTipsControl:onTouchMoved(touch, event)

    self.movetouch = touch:getLocation()
	local y =  math.abs((self.y - self.movetouch.y)) > 4
	local x =  math.abs((self.x - self.movetouch.x)) > 4
	if  y  or  x  then 
		self:cleantimer()
	end 

    if self.tips and self.tips:isVisible() then 
		local y =  math.abs((self.y - self.movetouch.y)) > 15
	    local x =  math.abs((self.x - self.movetouch.x)) > 15
	    if self.tips and ( y  or  x )then 
			self.tips:setVisible(false)
		end 
	end 
end


function UIWildTipsControl:onTouchBegan(touch, event)
	  	local beganPoint = touch:getLocation()
	  	self.x = beganPoint.x 
	  	self.y = beganPoint.y 
	  	self.beginPoint = clone(beganPoint)
	    local AnchorPoint = self.original:getAnchorPoint()
	    local worldpoint = self.original:convertToWorldSpaceAR(cc.p(0,0))
	    local originalrect = cc.rect(worldpoint.x,worldpoint.y,self.original:getBoundingBox().width,self.original:getBoundingBox().height)
	    local box = self.original:getBoundingBox()
	    local resRect = cc.rect(0,0,box.width,box.height)
		if self.checkmode ==1 then 
			resRect.width =resRect.width*2
			resRect.height =resRect.height*2
		end 	    
	    if CCHgame:isNodeBeTouch(self.original, resRect,beganPoint) then
	    	self:bindTips(self.beginPoint)
	    end
       -- end 
    return true
end

function UIWildTipsControl:setCheckMode(checkmode)
	self.checkmode =  checkmode 
end

function UIWildTipsControl:CheckContrains(rect , point)
	  if cc.rectContainsPoint(rect,point) then 
	    	self:bindTips(self.beginPoint)
	  end  
end

function UIWildTipsControl:onTouchEnded(touch, event)
	if self.tips   then 
		self.tips:stopAllActions()
		self.tips:setVisible(false)
	end 
	self:cleantimer()
end 


function UIWildTipsControl:isExitNoHideTips(state)

	self.isExitNoHideTips =  state 

end 


function UIWildTipsControl:ClearEventListener()
	self.isdelay= nil 
	if self.touchEventListener  then 
      	cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
      	self.touchEventListener  = nil
    end

    if self.tips   then 
    	if self.isExitNoHideTips then 

		else  
			self.tips:setVisible(false)
		end 
	end 
	self:cleantimer()
end 


return UIWildTipsControl