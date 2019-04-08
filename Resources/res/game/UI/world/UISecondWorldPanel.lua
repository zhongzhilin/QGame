--region UISecondWorldPanel.lua
--Author : untory
--Date   : 2016/09/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISecondWorldPanel  = class("UISecondWorldPanel", function() return gdisplay.newWidget() end )

local g_worldview = nil

function UISecondWorldPanel:ctor()
    self:CreateUI()
    g_worldview = global.g_worldview
end

function UISecondWorldPanel:CreateUI()
    local root = resMgr:createWidget("world/world_map_add")
    self:initUI(root)
end

function UISecondWorldPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/world_map_add")

    self:initTouch()

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.parent = self.root.parent_export
    self.ScrollView = self.root.parent_export.ScrollView_export
    self.centerMap = self.root.parent_export.ScrollView_export.Node_5.centerMap_export
    self.currentPos = self.root.parent_export.ScrollView_export.Node_5.centerMap_export.currentPos_export
    self.city = self.root.parent_export.ScrollView_export.Node_5.centerMap_export.city_export
    self.name = self.root.btn1.name_export

    uiMgr:addWidgetTouchHandler(self.root.btn1, function(sender, eventType) self:back_call(sender, eventType) end)
--EXPORT_NODE_END
	
	self.miracleNode = cc.Node:create()
	self.centerMap:addChild(self.miracleNode)
	global.worldApi:mapMiracle(handler(self,self.createMiracle))
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UISecondWorldPanel:back_call(sender, eventType)

	
	global.panelMgr:closePanel("UISecondWorldPanel")
end
--CALLBACKS_FUNCS_END

function UISecondWorldPanel:onEnter()

	self.parent:stopAllActions()
	self.parent:setScale(5)
	self.parent:runAction(cc.ScaleTo:create(0.5,1))

	-- self.ScrollView:scrollToPercentBothDirection(cc.p(50,50),0,false)

	local nodeTimeLine = resMgr:createTimeline("world/map_spot")
    -- nodeTimeLine:setLastFrameCallFunc(function()

    -- end)
    nodeTimeLine:play("animation0", true)
    self.currentPos:runAction(nodeTimeLine)
end

function UISecondWorldPanel:createMiracle(msg)
	local luaCfg = global.luaCfg
	local worldSurface = luaCfg:world_surface()

	local points = msg.tgMiracle or {}
	local typeIcon = {}

	for k,v in pairs(worldSurface) do
		typeIcon[v.type] = v.bigmap
	end

	for i,p in ipairs(points) do
		-- local s = cc.Sprite:createWithSpriteFrameName(typeIcon[p.ltype])
	    local s = ccui.Button:create(typeIcon[p.ltype],typeIcon[p.ltype],nil,ccui.TextureResType.plistType)
		self.miracleNode:addChild(s)
		s:setAnchorPoint(cc.p(0.5,0))
		local pos = self:convertBigPos(cc.p(p.lposx,p.lposy))
		s:setPosition(pos)
    	uiMgr:addWidgetTouchHandler(s, function(sender, eventType) 
    		self:onBigWorldPos(cc.p(sender:getPosition()))
    	end)
	end
end

function UISecondWorldPanel:initTouch()

    local  listener = cc.EventListenerTouchOneByOne:create()

    local touchNode = cc.Node:create()
    touchNode:setLocalZOrder(9)
    self:addChild(touchNode)

    listener:setSwallowTouches(false)
    listener:registerScriptHandler(handler(self,self.touchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(handler(self,self.touchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(handler(self,self.touchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, touchNode)
	
end

function UISecondWorldPanel:convertBigPos(pos)
	
	local map_width = g_worldview.const.INFO.MAP_WIDTH

	local size = self.centerMap:getContentSize()

	local xPen = (pos.x / (2048 * map_width)) * size.width
	local yPen = (pos.y / (2048 * map_width)) * size.height

	xPen = xPen + size.width / 2
	yPen = yPen + size.height / 2

	return cc.p(xPen,yPen)
end

function UISecondWorldPanel:setCurrentPos(pos)
	local pos = self:convertBigPos(pos)

	self:scrollToPoint(cc.p(pos.x,pos.y))

	self.currentPos:setPosition(pos.x,pos.y)	
end

function UISecondWorldPanel:touchBegan(touch, event)
	
	self.moveDt = 0
	return true
end

function UISecondWorldPanel:touchMoved(touch, event)

	self.moveDt = self.moveDt + cc.pGetLength(touch:getDelta())

	-- log.debug("self.moveDt " .. cc.pGetLength(touch:getDelta()))
	-- log.debug("self.trueDt " .. self:convertDistanceFromPointToInch(cc.pGetLength(touch:getDelta())))
end

function UISecondWorldPanel:scrollToPoint(pos,time)

	time = time or 0

	local size = self.centerMap:getContentSize()	
	local width = size.width
	local screen_width = gdisplay.width


	if pos.x < screen_width / 2 then

		pos.x = 0
	else

		pos.x = pos.x - screen_width / 2
	end

	if pos.x > width - screen_width / 2 then

		pos.x = width - screen_width
	end


	local pen = pos.x / (width - screen_width) * 100

	self.ScrollView:scrollToPercentHorizontal(pen,time,true)
end

function UISecondWorldPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UISecondWorldPanel:touchEnded(touch, event)

	if self.moveDt > 20 then return end

	local pos = touch:getLocation()
	pos = self.centerMap:convertToNodeSpace(pos)
	self.currentPos:setPosition(pos)


	self.parent:stopAllActions()
	self.parent:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.ScaleTo:create(0.5,5),cc.CallFunc:create(function()
		self:choosePos(pos)
	end)))

	local posTemp = clone(pos)
	self:scrollToPoint(posTemp,0.5)
end

--切入具体的世界点
function UISecondWorldPanel:onBigWorldPos(pos)

	self.currentPos:setPosition(pos)

	self.parent:stopAllActions()
	self.parent:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.ScaleTo:create(0.5,5),cc.CallFunc:create(function()
		self:choosePos(pos)
	end)))

	local posTemp = clone(pos)
	self:scrollToPoint(posTemp,0.5)
end

function UISecondWorldPanel:choosePos(pos)

	local map_width = g_worldview.const.INFO.MAP_WIDTH
	local size = self.centerMap:getContentSize()
	pos.x = pos.x - size.width / 2
	pos.y = pos.y - size.height / 2

	local xPen = (pos.x / size.width) * 2048 * map_width * -1
	local yPen = (pos.y / size.height) * 2048 * map_width * -1

	global.panelMgr:closePanel("UISecondWorldPanel")
	local scrollview = global.panelMgr:getPanel("UIWorldPanel").m_scrollView
	scrollview:setOffset(cc.p(xPen,yPen))
end

return UISecondWorldPanel

--endregion
