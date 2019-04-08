local luaCfg = global.luaCfg

local _M = class("ConnectingPanel", function() return gdisplay.newWidget() end )

local SHOW_LABEL_DELAY = 1
local SHOW_LABEL_SECOND_DELAY = 5
local AUTO_CLOSE_DELAY = 20
local gameEvent = global.gameEvent

function _M:onEnter()
	--log.debug("ConnectingPanel onEnter self.delayTime %s", self.delayTime)

	if self.label then
		self.label:removeFromParent()
		self.label = nil
	end
    local callFunc = function(csb_name)
    	if self.noCircle then
    		return
    	end
	    self.labelBg:setVisible(true)
	    self.circle:setVisible(true)

	    gevent:call(gameEvent.EV_ON_NET_SHOW_CIRCLE)

        -- self.circle:runAction(cc.RepeatForever:create(cc.RotateBy:create(1.5, 360)))
        if not csb_name then return end
    	if self.label then
			self.label:removeFromParent()
			self.label = nil
		end
		local name = csb_name
		local actionStr = "animation0"
		local isloop = true
	    local label = global.resMgr:createCsbAction(name,actionStr,isloop)
		label:setPosition(cc.p(gdisplay.size.width * 0.5 - label:getContentSize().width * 0.5, gdisplay.size.height * 0.5))
	    self:addChild(label, 10)
		self.label = label
    end
	
    -- print("--->>>>>>>>>>111")
	local showLabelTime = 0
	local isShowOnce = false
	local function update()

        showLabelTime = showLabelTime + 1

    	-- print("--->>>>>>>>>>")
    	-- print(showLabelTime)
    	-- print("--->>>>>>>>>>22")
        if showLabelTime >= SHOW_LABEL_DELAY then
        	if not isShowOnce then
        		global.netRpc:addReconnectTimes()
        		isShowOnce = true
        		global.badNetTimes = global.badNetTimes+1
        	end
        	global.badNetDt = global.badNetDt+1
			callFunc("world/map_Load")
        end
        if showLabelTime > AUTO_CLOSE_DELAY then
        	global.tipsMgr:showQuitConfirmPanelNoClientNet()
        end
    end
	
	if self.handler == nil then
        self.handler = gscheduler.scheduleGlobal(update, 1)
    end

    self.maskLayerListener:setSwallowTouches(true)
    self.circle:stopAllActions()
    self.circle:setVisible(false)
    self.labelBg:setVisible(false)

    global.isConnecting = true
end

function _M:onExit()
	--log.debug("ConnectingPanel onExit self.delayTime = nil")
	if self.handler ~= nil then
		gscheduler.unscheduleGlobal(self.handler)
        self.handler = nil
    end
    if self.maskLayerListener then
    	self.maskLayerListener:setSwallowTouches(false)
    end
    self.delayTime = nil
	if self.label then
		self.label:removeFromParent()
		self.label = nil
	end

    global.isConnecting = false
    self.noCircle = false
end

function _M:showLoading(delayTime)
	self.delayTime = delayTime
	log.debug("ConnectingPanel showLoading self.delayTime = %s", self.delayTime)
end

function _M:closeNetForbid()
    self.maskLayerListener:setSwallowTouches(false)
    self.noCircle = true
    global.isConnecting = false
end

function _M:ctor()
	
	local blackBg = cc.LayerColor:create()
	self:addChild(blackBg, 1)
	blackBg:setContentSize(cc.size(gdisplay.size.width, gdisplay.size.height))
	blackBg:setColor(cc.c3b(0, 0, 0))
	blackBg:setOpacity(0)

	local onTouch = function(eventType, ...)
        return true
    end

    local maskLayer = cc.Node:create()
    self:addChild(maskLayer)

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(function() log.debug("yes") return true end, cc.Handler.EVENT_TOUCH_BEGAN)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, maskLayer)
    listener:setSwallowTouches(true)

    self.maskLayerListener = listener
	
	-- local labelBg = cc.Sprite:create("tipsback.png")
	local labelBg = cc.Node:create()
	self:addChild(labelBg, 9)
	labelBg:setScaleY(1.5)
	labelBg:setPosition(cc.p(gdisplay.size.width * 0.5, gdisplay.size.height * 0.5))
	
	-- local circle = cc.Sprite:create("loading_circle.png")
	local circle = cc.Node:create()
	self:addChild(circle, 10)
	circle:setPosition(cc.p(gdisplay.size.width * 0.5 - labelBg:getContentSize().width / 2 + circle:getContentSize().width - 6, gdisplay.size.height * 0.5))
	

	self.labelBg = labelBg
	self.circle = circle
end

return _M

