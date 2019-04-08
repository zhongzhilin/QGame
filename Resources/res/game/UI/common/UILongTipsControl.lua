local UILongTipsControl  = class("UILongTipsControl")
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local curTips = nil

function hideTips()
	
	if curTips then

		curTips:removeFromParent()
		curTips = nil
	end
end

function initEvent()

	gevent:addListener(global.gameEvent.EV_ON_PANEL_CLOSE,function()

        hideTips()
    end)
end

initEvent()

function UILongTipsControl:ctor(original,tipsType)
	self.original = original
	self.tipsType = tipsType
	self:initTouch()
end

function UILongTipsControl:setData(data)
	self.data = data
end 

function UILongTipsControl:setDelayTime(time)
	self.delayTime = time
end

function UILongTipsControl:getTips()

	local tips = require(self.tipsType).new()
	global.scMgr:CurScene():addChild(tips,global.panelMgr.LAYER.LAYER_PANEL)

	if self.delayTime then
		tips:setVisible(false)
		tips:runAction(cc.Sequence:create(cc.DelayTime:create(self.delayTime),cc.Show:create()))
	end

	return tips
end

function UILongTipsControl:initTouch()

    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan) , cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchCancel), cc.Handler.EVENT_TOUCH_CANCELLED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self.original)
end

function UILongTipsControl:showTips(beganPoint)

	if curTips then return end

	curTips = self:getTips()

	if type(self.data) == "table" then
		curTips:setData(self.data)
	elseif type(self.data) == "function" then
		curTips:setData(self.data())
	end

	if curTips.board then

		local board = curTips.board
		local boardSize = board:getContentSize()
		local boardAnchor = board:getAnchorPoint()
		local worldSpace = board:convertToWorldSpace(cc.p(0,0))
		local boardNodePos = curTips:convertToNodeSpace(worldSpace)
		local minX = (boardAnchor.x) * boardSize.width + beganPoint.x + boardNodePos.x
		local maxX = (1 - boardAnchor.x) * boardSize.width + beganPoint.x + boardNodePos.x
		local minY = (boardAnchor.y) * boardSize.height + beganPoint.y + boardNodePos.y
		local maxY = (1 - boardAnchor.y) * boardSize.height + beganPoint.y + boardNodePos.y

		local addX = 0
		local addY = 0
		
		if minX < 0 then addX = -minX end
		if maxX > gdisplay.width then addX = gdisplay.width - maxX end
		if minY < 0 then addY = -minY end
		if maxY > gdisplay.height then addY = gdisplay.height - maxY end

		curTips:setPosition(cc.p(beganPoint.x + addX,beganPoint.y + addY))
	else
		curTips:setPosition(beganPoint)
	end	
end

function UILongTipsControl:onTouchCancel(touch , event)

	hideTips()
end 
 
function UILongTipsControl:onTouchMoved(touch, event)

    local movetouch = touch:getLocation()
    local startTouch = touch:getStartLocation()

    local isMoveY =  math.abs((startTouch.y - movetouch.y)) > 15
    local isMoveX =  math.abs((startTouch.x - movetouch.x)) > 15
    if isMoveY or isMoveX then 
		hideTips()
	end 
end

function UILongTipsControl:checkOriginalVisible(original)
	
	if not original:isVisible() then return false end

	if original:getParent() then
		return self:checkOriginalVisible(original:getParent())
	else
		return true
	end
end

function UILongTipsControl:onTouchBegan(touch, event)

  	local beganPoint = touch:getLocation() 
    local box = self.original:getContentSize()
    local resRect = cc.rect(0,0,box.width,box.height)

    if self:checkOriginalVisible(self.original) and CCHgame:isNodeBeTouch(self.original, resRect,beganPoint) then
    	self:showTips(beganPoint)
    end

    return true
end

function UILongTipsControl:onTouchEnded(touch, event)
	
	hideTips()
end

return UILongTipsControl