--region CityCamera.lua
--Author : wuwx

local resMgr = global.resMgr
local uiMgr = global.uiMgr

local CityCamera  = class("CityCamera", function() return gdisplay.newWidget() end )

local NORMAL_SCALE_RATIO = 0.95
local BUILD_SCALE_RATIO = 1.2
local SCROLL_DURATION = 0.15
local CITY_CENTER = cc.p(1400,1497)
-- local CITY_CENTER = cc.p(0,100)

function CityCamera:ctor()
    self.cityView = global.g_cityView
    self.m_scrollView = self.cityView.m_scrollView

    self:init()
end

function CityCamera:init()
    -- self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    -- self.touchEventListener:setSwallowTouches(false)
    -- self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    -- self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    -- self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    -- self.touchEventListener:registerScriptHandler(handler(self, self.onTouchCancel), cc.Handler.EVENT_TOUCH_CANCELLED)
    -- cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self)
end

function CityCamera:onExit(touch, event)
    -- if self.touchEventListener then
    --     cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
    --     self.touchEventListener = nil
    -- end
end

function CityCamera:scrollOffset(i_doffset,animated)
    i_doffset = cc.pMul(i_doffset,NORMAL_SCALE_RATIO)
    local currOffset = self.m_scrollView:getContentOffset()
    local minOffset = self.m_scrollView:minContainerOffset()
    local maxOffset = self.m_scrollView:maxContainerOffset()
    local offset = currOffset or cc.p(0,0)
    offset = cc.pAdd(currOffset,i_doffset)
    -- offset = cc.pMul(offset,-1)
    offset.x = math.max(minOffset.x, math.min(maxOffset.x, offset.x));
    offset.y = math.max(minOffset.y, math.min(maxOffset.y, offset.y));
    self.m_scrollView:setContentOffset(offset,animated)
end

function CityCamera:scrollToPoint(i_p,animated)
    local convertToCenter = cc.pAdd(i_p,cc.pMul(cc.p(gdisplay.cx,gdisplay.cy),-1))
    local minOffset = self.m_scrollView:minContainerOffset()
    local maxOffset = self.m_scrollView:maxContainerOffset()
    local offset = convertToCenter or cc.p(0,0)
    offset = cc.pMul(offset,-1)
    offset.x = math.max(minOffset.x, math.min(maxOffset.x, offset.x));
    offset.y = math.max(minOffset.y, math.min(maxOffset.y, offset.y));
    if animated then
        self.m_scrollView:getContainer():stopAllActions()
        -- animated = SCROLL_DURATION
        self.m_scrollView:setContentOffsetInDuration(offset,SCROLL_DURATION)
    else
        self.m_scrollView:setContentOffset(offset,animated)
    end
end
function CityCamera:scrollToPointWithScale(i_p,i_scale,animated,overCall)

    local scale = i_scale or 1
    local containerSize = self.m_scrollView:getContainer():getContentSize()
    local viewSize = self.m_scrollView:getViewSize()
    local i_p = cc.pMul(i_p,scale)
    local convertToCenter = cc.pAdd(i_p,cc.pMul(cc.p(gdisplay.cx,gdisplay.cy),-1))
    local minOffset = cc.p(viewSize.width-containerSize.width*scale,viewSize.height-containerSize.height*scale)
    local maxOffset = self.m_scrollView:maxContainerOffset()
    local offset = convertToCenter or cc.p(0,0)
    offset = cc.pMul(offset,-1)
    offset.x = math.max(minOffset.x, math.min(maxOffset.x, offset.x));
    offset.y = math.max(minOffset.y, math.min(maxOffset.y, offset.y));
    -- log.debug("##offset=%s,convertToCenter=%s,minOffset=%s,maxOffset=%s,i_p=%s",
    --     vardump(offset),vardump(convertToCenter),vardump(minOffset),vardump(maxOffset),vardump(i_p))

    if animated then
        self.m_scrollView:getContainer():stopAllActions()
        -- animated = SCROLL_DURATION/5
        self.m_scrollView:setContentOffsetInDuration(offset,animated)
    else
        self.m_scrollView:setContentOffset(offset,animated)
    end
    -- self:setZoomScale(scale,animated)
    self:scrollScale(scale,animated,overCall)
end

function CityCamera:scrollScale(i_scale,animated,overCall)
    if animated then
        local actionT = {}
        table.insert(actionT,cc.ScaleTo:create(animated,i_scale))
        table.insert(actionT,cc.CallFunc:create(function()
            -- body
            if overCall then overCall() end
        end))
        -- self.m_scrollView:getContainer():stopActionByTag(100423)
        local m_scrollActionTag = cc.Sequence:create(actionT)
        -- m_scrollActionTag:setTag(100423)
        self.m_scrollView:getContainer():runAction(m_scrollActionTag)
    else
        self.m_scrollView:getContainer():setScale(i_scale)
        if overCall then overCall() end
    end
end

function CityCamera:resetCityCenter()
    self:scrollToPointWithScale(CITY_CENTER,NORMAL_SCALE_RATIO)
end

function CityCamera:resetNormalScale(pos,isAnimate,overCall)
    if self.noScale then  self.noScale = false return end

    if isAnimate then
        if type(isAnimate) ~= "number" then
            isAnimate = SCROLL_DURATION
        else
            isAnimate = (isAnimate == nil and SCROLL_DURATION or isAnimate)
        end
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_build_transition_far")
    end
    self:scrollToPointWithScale(pos,NORMAL_SCALE_RATIO,isAnimate,overCall)
end

function CityCamera:setBuildModel(pos,isAnimate,overCall)
    pos.y = pos.y-150
    pos.x = pos.x+112
    isAnimate = isAnimate == nil and SCROLL_DURATION or isAnimate

    if isAnimate then
        if type(isAnimate) ~= "number" then
            isAnimate = SCROLL_DURATION
        end
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_build_transition_far")
    end
    self:scrollToPointWithScale(pos,BUILD_SCALE_RATIO,isAnimate,overCall)
    -- print("###############CityCamera:setBuildModel  pos:%s",vardump(pos))
end

function CityCamera:setNoScaleModel(noScale)
    --只能生效一次
    self.noScale = noScale
end

return CityCamera

--endregion
