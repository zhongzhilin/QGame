local global = global
local luaCfg = global.luaCfg

local paraMgr = global.paraMgr
local resMgr = global.resMgr
local uiMgr = global.uiMgr

local WIDGET_NAME = "UIScrollBar"

local STATUS_IDLE = "STATUS_IDLE"

local STATUS_IS_FADE_IN = "STATUS_IS_FADE_IN"
local STATUS_COMPLETE_FADE_IN = "STATUS_COMPLETE_FADE_IN"

local STATUS_IS_WAIT = "STATUS_IS_WAIT"
local STATUS_COMPLETE_WAIT = "STATUS_COMPLETE_WAIT"

local STATUS_IS_FADE_OUT = "STATUS_IS_FADE_OUT"
local STATUS_COMPLETE_FADE_OUT = "STATUS_COMPLETE_FADE_OUT"

local UIWidget = class(WIDGET_NAME, function() return gdisplay.newWidget() end )

function UIWidget:ctor(widget)
    if widget then
        self.mRootWidget = widget
    else
        -- TODO create widget
        return
    end
    self:setNodeEventEnabled(true)
    self:setAutoFade(true)
    self:configUI()
end

function UIWidget:configUI()
    local widget = self.mRootWidget
    self.mSliderImage = uiMgr:configImage(widget, "Image_Slider")
    self.mSliderImage:ignoreContentAdaptWithSize(false)
    self.mSliderImage:setAnchorPoint(cc.p(0.5, 0))

    self.mBackImage = uiMgr:configImage(widget, "Image_Back")
    self.mBackImage:setAnchorPoint(cc.p(0.5, 0))
    
    uiMgr:setWidgetOpacity(widget, 255, true)
end

function UIWidget:updateUI()
    local widget = self.mRootWidget

    local scrollView = self.mScrollView
    local displaySize = scrollView:getSize()
    
    local container = scrollView:getInnerContainer()
    local containerSize = container:getSize()

    local position = cc.p(container:getPosition())
    
    local backImage = self.mBackImage
    local backSize = backImage:getSize()

    local sliderImage = self.mSliderImage
    local sliderSize = sliderImage:getSize()

    if containerSize.height > displaySize.height then
        local scale = displaySize.height / containerSize.height
        local height = scale * backSize.height
        sliderImage:setSize(cc.size(sliderSize.width, height))

        local min = 0
        local max = backSize.height - height

        local precent = -position.y / (containerSize.height - displaySize.height)
        local value = precent * max
        local y = math.clamp(value, min, max)
        sliderImage:setPositionY(y)

        widget:setVisible(true) 
    else
        widget:setVisible(false) 
    end
end

function UIWidget:onEnter()
    self:addLoopSchedule()

    self:reset()
end

function UIWidget:onExit()
    self:unscheduleAll()
end

function UIWidget:onEnterTransitionFinish()
    self:updateUI()
end

function UIWidget:addLoopSchedule()
    local onCallFunc = function()
        if not self.mAutoFadeFlag then
            return
        end
        self:checkFadeInOut()
    end
    self:schedule(onCallFunc, 0.1)
end

function UIWidget:reset()
    local widge = self.mRootWidget
    
    uiMgr:setWidgetOpacity(widge, 255)
    uiMgr:stopWidgetFadeIn(widge)
    uiMgr:stopWidgetFadeOut(widge)
    self:stopWaitAction(widge)
    
    local image = self.mSliderImage
    image.oldPosition = nil

    self.mStatus = STATUS_COMPLETE_FADE_IN
    self:updateUI()
end

function UIWidget:setScrollView(scrollView, callFunc)
    local onTouchHandler = function(sender, eventType)
        self:updateUI()

        if callFunc then
            callFunc()
        end
    end
    scrollView:addEventListenerScrollView(onTouchHandler)

    self.mScrollView = scrollView
end

function UIWidget:setAutoFade(value)
    self.mAutoFadeFlag = value or false
end

function UIWidget:checkFadeInOut()
    local widget = self.mRootWidget

    local image = self.mSliderImage
    local op = image.oldPosition
    if op == nil then
        op = cc.p(image:getPosition())
    end

    local np = cc.p(image:getPosition())
    image.oldPosition = np


    local value, offset = math.abs(np.y - op.y), 0
    local move = value > offset

    local status = self.mStatus
    if status == STATUS_IDLE then
        if move == true then
            self.mStatus = STATUS_IS_FADE_IN

            local onCallBack = function()
                self.mStatus = STATUS_COMPLETE_FADE_IN
            end
            uiMgr:runWidgetFadeIn(widget, 0.5, true, onCallBack)
        end
    elseif status == STATUS_IS_FADE_IN then

    elseif status == STATUS_COMPLETE_FADE_IN then
        self.mStatus = STATUS_IS_WAIT

        local onCallBack = function()
            self.mStatus = STATUS_COMPLETE_WAIT
        end
        self:runWaitAction(widget, 3, onCallBack)
    elseif status == STATUS_IS_WAIT then

    elseif status == STATUS_COMPLETE_WAIT then
        if move == false then
            self.mStatus = STATUS_IS_FADE_OUT
            
            local onCallBack = function()
                self.mStatus = STATUS_COMPLETE_FADE_OUT
            end
            uiMgr:runWidgetFadeOut(widget, 0.5, true, onCallBack)
        end
    elseif status == STATUS_IS_FADE_OUT then
        if move == true then
            self.mStatus = STATUS_IS_FADE_IN

            uiMgr:stopWidgetFadeOut(widget)
            local onCallBack = function()
                self.mStatus = STATUS_COMPLETE_FADE_IN
            end
            uiMgr:runWidgetFadeIn(widget, 0.5, true, onCallBack)
        end
    elseif status == STATUS_COMPLETE_FADE_OUT then
        self.mStatus = STATUS_IDLE
    else
        log.debug("[Error][ScrollBar] status(%s) is error", status)
    end
end

function UIWidget:runWaitAction(widget, time, callBack)
    self:stopWaitAction(widget)
        
    local onCallFunc = function()
        self:stopWaitAction(widget)

        if callBack then
            callBack()
        end
    end

    local array = CCArray:create()
    array:addObject(CCDelayTime:create(time))
    array:addObject(CCCallFunc:create(onCallFunc))

    local action = CCSequence:create(array)
    widget:runAction(action) 
    widget.waitAction = action
end

function UIWidget:stopWaitAction(widget)
    if widget and widget.waitAction then
        widget:stopAction(widget.waitAction)
        widget.waitAction = nil
    end
end

return UIWidget