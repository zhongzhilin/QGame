--region ResourceNumControl.lua
--Author : wuwx
--Date   : 2016/08/24
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local propData = global.propData

local textScrollControl = require("game.UI.common.UITextScrollControl")
local ResourceNumControl  = class("ResourceNumControl")

ResourceNumControl.delay = 0.6

function ResourceNumControl:ctor(root,i_isReverse)
	-- 当为界面上的资源条时，要设置反向进度
	self.m_isReverse = i_isReverse
	print("function ResourceNumControl:ctor(root,i_isReverse)")
	print(i_isReverse)

    self:initUI(root)
end

function ResourceNumControl:initUI(root)
    self.root = root
    self.num = self.root.resBtn.num_export
    self.icon = self.root.resBtn.btn_click_export.icon_export
    self.num_icon =self.root.resBtn.num_export.num_icon_export
    if not self.num_icon then 
	    self.num_icon =self.root.resBtn.num_icon_export
    end 

    if self.root.resBtn.LoadPanel_export then
    	self.loadBarSp = self.root.resBtn.LoadPanel_export.loadBarSp_export
    	self.loadLayout = self.root.resBtn.LoadPanel_export.loadLayout_export
    end
    uiMgr:addWidgetTouchHandler(self.root.resBtn, function(sender, eventType) self:onResClickHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.resBtn.btn_click_export, function(sender, eventType) self:onResClickHandler(sender, eventType) end)

    self._scoreNode = cc.Node:create()
    self.root:addChild(self._scoreNode)

    self._isOpenEffect = false
    self.delay = 0.6
end

function ResourceNumControl:onResClickHandler(sender, eventType)
    local resPanel = global.panelMgr:openPanel("UIResPanel")
    resPanel:setData()
end

function ResourceNumControl:setData(data)
	local propNum = propData:getProp(data.itemId)
	local per,resData,maxNum ,currNum= global.resData:getPropPer(data.itemId)

	if data.itemId == WCONST.ITEM.TID.SOLDIER then --兵源
		propNum = currNum
	end 
	if per > 100 then per=100 end
	self.itemW = 0

	if self.loadBarSp then
		self.loadBarSp:setSpriteFrame(resData.bgViewPic)
		self.itemW = self.loadLayout:getContentSize().width
	end
	
	self.num:setScale(1)
	self.icon:setScale(1)


	local updateCall = function (curr)
		-- body
		if self.loadBarSp then
			if tonumber(curr) > tonumber(maxNum) then curr=maxNum end
			local perT = curr/maxNum*100
			if self.m_isReverse then
				self.loadBarSp:setPositionX(self.itemW*(perT/100-1))
			else
				self.loadBarSp:setPositionX(self.itemW*(1-perT/100))
			end
		end
	end

	local refershMaxResCall = function ()

		if self.loadBarSp then
			local perC,resData,maxNum = global.resData:getPropPer(data.itemId)
			if perC > 100 then perC=100 end
			if self.m_isReverse then
				self.loadBarSp:setPositionX(self.itemW*(perC/100-1))
			else
				self.loadBarSp:setPositionX(self.itemW*(1-perC/100))
			end
		end
	end

	if self._isOpenEffect then

		-- if self.endPropNum ~= propNum then

		-- 	self.endPropNum = propNum
		-- 	local delay = self.isNotify and 0.6 or 0
			
		-- 	self._scoreNode:runAction(cc.Sequence:create(cc.DelayTime:create(delay),cc.CallFunc:create(function()
				
		-- 		self._scoreNode:runAction(cc.MoveTo:create(1,cc.p(propNum,0)))
		-- 		self._scoreNode:runAction(cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(1 / 30),cc.CallFunc:create(function ()
				
		-- 			local numStr = self._scoreNode:getPositionX()
		-- 			self.num:setString(propData:getShowStr(math.floor(numStr)))
		-- 		end)),30))

		-- 		self.num:runAction(cc.Repeat:create(cc.Sequence:create(cc.ScaleTo:create(0.075,1.2),cc.ScaleTo:create(0.075,1)),8))
		-- 		self.icon:runAction(cc.Repeat:create(cc.Sequence:create(cc.ScaleTo:create(0.075,1.2),cc.ScaleTo:create(0.075,1)),8))				
		-- 	end)))
		-- 	-- print("################ResourceNumControl:setData _scoreNode:run action")
		-- else
		
		-- 	self.endPropNum = propNum
		-- 	self.num:setString(propData:getShowStr(propNum))
		-- end

		-- if self.loadBarSp then
		-- 	if self.m_isReverse then
		-- 		self.loadBarSp:setPositionX(self.itemW*(per/100-1))
		-- 	else
		-- 		self.loadBarSp:setPositionX(self.itemW*(1-per/100))
		-- 	end
		-- end
		
		if self.endPropNum ~= propNum then
			local delay = self.isNotify and 0.6 or 0
			
			if global._isUpdateByTask then
				delay = 1.6
			end

			self._scoreNode:runAction(cc.Sequence:create(cc.DelayTime:create(delay),cc.CallFunc:create(function()
				textScrollControl.startScroll(self.num,propNum,1,textScrollControl.formalCallSplit,refershMaxResCall,updateCall)
				self.num:runAction(cc.Repeat:create(cc.Sequence:create(cc.ScaleTo:create(0.075,1.2),cc.ScaleTo:create(0.075,1)),8))
				self.icon:runAction(cc.Repeat:create(cc.Sequence:create(cc.ScaleTo:create(0.075,1.2),cc.ScaleTo:create(0.075,1)),8))								
				if self.num_icon then 
					self.num_icon:runAction(cc.Repeat:create(cc.Sequence:create(cc.ScaleTo:create(0.075,1.2),cc.ScaleTo:create(0.075,1)),8))
				end 
				global._isUpdateByTask = false
			end)))
			self.endPropNum = propNum
		end
	elseif not self._isOpenEffect and self.isNotify then

		--当不开发滚动效果并且从通知发起更新数据时，证明目前在二级面板上，只滚动数字，不跳动icon和数字
		-- if self.endPropNum ~= propNum then
			
		-- 	self.endPropNum = propNum
		-- 	local delay = self.isNotify and 0.6 or 0
		-- 	self._scoreNode:runAction(cc.Sequence:create(cc.DelayTime:create(delay),cc.CallFunc:create(function()
				
		-- 		self._scoreNode:runAction(cc.MoveTo:create(1,cc.p(propNum,0)))
		-- 		self._scoreNode:runAction(cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(1 / 30),cc.CallFunc:create(function ()
				
		-- 			local numStr = self._scoreNode:getPositionX()
		-- 			self.num:setString(propData:getShowStr(math.floor(numStr)))
		-- 		end)),30))			
		-- 	end)))
		-- else

		-- 	self.endPropNum = propNum
		-- 	self.num:setString(propData:getShowStr(propNum))
		-- end

		if self.endPropNum ~= propNum then

			local delay = self.isNotify and 0.6 or 0
			self._scoreNode:runAction(cc.Sequence:create(cc.DelayTime:create(delay),cc.CallFunc:create(function()

				textScrollControl.startScroll(self.num,propNum,1,textScrollControl.formalCallSplit,refershMaxResCall,updateCall)
			end)))
			self.endPropNum = propNum
		end
	else

		self.endPropNum = propNum
		self.num:setString(propData:getShowStr(propNum))
		if self.loadBarSp then
			if self.m_isReverse then
				self.loadBarSp:setPositionX(self.itemW*(per/100-1))
			else
				self.loadBarSp:setPositionX(self.itemW*(1-per/100))
			end
		end

		self._scoreNode:setPositionX(propNum)	
		self._isOpenEffect = true
	end

    self.icon:setSpriteFrame(data.itemIcon)

	-- log.debug("ResourceNumControl:setData(data) str=%s",self._scoreNode:getPositionX())
	-- log.debug("ResourceNumControl:setData(data) str=%s,trace=%s",self._scoreNode:getPositionX(),vardump(debug.traceback()))
end

function ResourceNumControl:setFirstScroll(s,isNotify)
	self._isOpenEffect = s
	self.isNotify = isNotify
end

return ResourceNumControl

--endregion
