local resMgr = global.resMgr
local uiMgr = global.uiMgr

local CCSScrollView = class("CCSScrollView", function() return cc.ScrollView:create() end )

function CCSScrollView:ctor()
    self:setDelegate()
    self:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL)

    self:openRemoveUnusedTouches()
    -- return self
end


local lastScale = nil 

function CCSScrollView:initWithUIScrollView(i_scrollview,containerCsbName)

    local size = cc.size(0,0)
    local scrollSize = cc.size(0,0)
    if i_scrollview then
        size = i_scrollview:getContentSize()
        scrollSize = i_scrollview:getInnerContainerSize()
    end

    self:setDirection(cc.SCROLLVIEW_DIRECTION_BOTH)
    self:setTouchEnabled(true)
    self:setBounceable(false)
    self:setViewSize(size)
    -- self:setPosition(cc.p(-size.width*0.5,-size.height*0.5))

    local root = resMgr:createWidget(containerCsbName)
    uiMgr:configUITree(root)
    uiMgr:configUILanguage(root, containerCsbName)
    self:setContainer(root)

    self:getContainer():setContentSize(scrollSize)
    -- self:setMinScale(math.max(size.width/scrollSize.width,size.height/scrollSize.height))
    self:setMinScale(0.7)
    self:setMaxScale(1.8)

    i_scrollview:getParent():addChild(self)
    i_scrollview:removeFromParent()

    lastScale = self:getZoomScale()
    return root
end 


function CCSScrollView:initWithUIScrollViewSingle(i_scrollview,child)
    
    local size = cc.size(0,0)
    local scrollSize = cc.size(0,0)
    if i_scrollview then
        size = i_scrollview:getContentSize()
        scrollSize = child:getContentSize()
    end

    self:setDirection(cc.SCROLLVIEW_DIRECTION_BOTH)
    self:setTouchEnabled(true)
    self:setBounceable(false)
    self:setViewSize(size)
    -- self:setPosition(cc.p(-size.width*0.5,-size.height*0.5))

    --local map = cc.TMXTiledMap:create(mapName)
    self:setContainer(child)

    -- self:getContainer():setContentSize(scrollSize)
    -- self:setMinScale(math.max(size.width/scrollSize.width,size.height/scrollSize.height))
    -- self:setMaxScale(2)

    i_scrollview:getParent():addChild(self)
    i_scrollview:removeFromParent()
end

function CCSScrollView:setViewDidScroll(call)
    self.m_callDidScroll = call
end

function CCSScrollView:scrollViewDidScroll(scrollview)

    lastScale =  lastScale  or self:getZoomScale()
    if lastScale ~= self:getZoomScale() then 
        lastScale = self:getZoomScale()
        gevent:call(global.gameEvent.EV_ON_CITYSCROLLSCALECHANGE , scrollview)
    end

    if self.m_callDidScroll then 
        self.m_callDidScroll(scrollview) 
    end
end

return CCSScrollView