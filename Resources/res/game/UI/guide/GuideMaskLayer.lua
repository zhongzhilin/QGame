local GuideMaskLayer = class("GuideMaskLayer", function() return gdisplay.newWidget() end )

function GuideMaskLayer:ctor(func,bgOpacity)
    self.m_TouchRect = nil
	self.bgOpacity = bgOpacity
    self.m_touchCallfunc = func
    self:registerTouchEvent()
	self:renderUI()
end

function GuideMaskLayer:onEnter()
end

function GuideMaskLayer:onExit()
    if self.touch_listener then
        self:getEventDispatcher():removeEventListener(self.touch_listener);
        self.touch_listener = nil;
    end

    if self.touch_listener_clip then
        self:getEventDispatcher():removeEventListener(self.touch_listener_clip);
        self.touch_listener_clip = nil;
    end

    if self.scheduleId then
        gscheduler.unscheduleGlobal(self.scheduleId)
        self.scheduleId = nil
    end

    -- if self.hand and not tolua.isnull(self.hand) then
    --     self.hand:removeFromParent()
    --     self.hand = nil
    -- end
end

function GuideMaskLayer:renderUI()
	local size = cc.size(gdisplay.width, gdisplay.height)
	local bgColor = cc.c3b(0, 0, 0) --非高亮区域颜色
	local bgOpacity = 0.5 --非高亮区域透明度
    if self.bgOpacity then
        bgOpacity = self.bgOpacity
    end
	local layerColor = cc.LayerColor:create(cc.c4b(bgColor.r, bgColor.g, bgColor.b, bgOpacity * 255), size.width, size.height)
	
    self.touchNode = cc.Layer:create()
    self:addChild(self.touchNode)

    if global.guideData:getGuideRect() then
    	self.clipNode = cc.ClippingNode:create();
        self.clipNode:setInverted(true)--设定遮罩的模式true显示没有被遮起来的纹理   如果是false就显示遮罩起来的纹理  
        self.clipNode:setAlphaThreshold(0.4) --设定遮罩图层的透明度取值范围 
        self.clipNode:addChild(layerColor)
        self:addChild(self.clipNode)
    end
	
--    self.batchNode = cc.SpriteBatchNode:create("Images/circle.png")
--    self.circleSpr = cc.Sprite:createWithTexture(self.batchNode:getTexture())
--    self.batchNode:addChild(self.circleSpr)
--    self.clipNode:setStencil(self.batchNode)
end

function GuideMaskLayer:setData(data,hand)
    -- if data then return end
    self.hand = hand
    self.data = data
    local width = data.width
    local height = data.height
    local posX = data.posX
    local posY = data.posY
    if data.isScale9 then
        self.circleSpr = cc.Scale9Sprite:createWithSpriteFrameName("ui_surface_icon/guide_region.png",cc.rect(2,2,4,4))
        self.circleSpr:setContentSize(cc.size(data.width,data.height))
    else
        -- self.circleSpr = cc.Sprite:createWithSpriteFrameName(data.hotArea..".png")
        local target = self:getTouchTarget(data)
        if not target then 
            target = cc.Sprite:create()
        else
            log.trace("@@GuideMaskLayer:setData getTarget Success")
        end
        local targetSize = target:getContentSize()
        local targetAnchor = target:getAnchorPoint()
        local targetPos = cc.p(target:getPosition())
        width = targetSize.width
        height = targetSize.height
        pos = target:convertToWorldSpace(cc.p(0,0))
        posX = pos.x
        posY = pos.y

        -- global.panelMgr:addWidgetToGuide(hand)
        self:addChild(hand,10000)
        hand:setPosition(posX+width*0.5, posY+height*0.5)
        self:adjustHandPos()
        log.trace("@@GuideMaskLayer:target rect w:%s,h:%s,x:%s,y:%s,ax:%s,ay:%s,name:%s,data.target:%s",width,height,posX,posY,targetAnchor.x,targetAnchor.y,target:getName(),data.target)


        if global.guideData:getGuideRect() then
            self.circleSpr = cc.Sprite:createWithSpriteFrameName("ui_surface_icon/guide_region.png")

            local circleSize = self.circleSpr:getContentSize()
            local scale = math.max(width/circleSize.width,height/circleSize.height)
            self.circleSpr:setScale(scale>1 and 1 or scale)
            self.clipNode:setStencil(self.circleSpr)
            self.circleSpr:setPosition(posX+width*0.5, posY+height*0.5)
        end
    end     

    -- if self.clipNode then
        local function onTouchBegan(touch, event)
            if not self.m_TouchRect then
                return false
            end
            local location = touch:getLocation()
            if cc.rectContainsPoint(self.m_TouchRect,cc.p(location.x,location.y)) then
                return true
            end
            return false
        end
        local function onTouchEnded(touch, event)

            local location = touch:getLocation()
            if cc.rectContainsPoint(self.m_TouchRect,cc.p(location.x,location.y)) then
                log.trace("@GuideMaskLayer:onTouchBegan-->step touch finish")
                --选中点击内容
                local guideData = global.guideData
                local nextGuideData = guideData:getNextConf()
                local callfunc = function(event)
                    gevent:call(global.gameEvent.EV_ON_GUIDE_NEXT)
                end
                if guideData:isCruxStep() then
                    --关键步特殊处理，等发协议返回之后处理
                    self:addEventListener(global.gameEvent.EV_ON_GUIDE_FINISH_CRUX_STEP, callfunc)
                elseif nextGuideData and ((WDEFINE.GUIDE_TARGET_KEY.OPERATE == nextGuideData.paths)
                    or (WDEFINE.GUIDE_TARGET_KEY.BUILDLIST == nextGuideData.paths)) then
                    --针对有动画延后的特殊处理
                    self:addEventListener(global.gameEvent.EV_ON_GUIDE_FINISH_ACTION_STEP, callfunc)
                else
                    --end事件先后顺序无法确定，延后一帧处理
                    gscheduler.performWithDelayGlobal(function()
                        gevent:call(global.gameEvent.EV_ON_GUIDE_NEXT)
                    end,0.0)
                end
                if self.m_touchCallfunc then
                    self.m_touchCallfunc(event);
                end
                self.m_TouchRect = nil
                return false
            end
        end
        --注册触摸事件
        local touch_listener = cc.EventListenerTouchOneByOne:create();
        touch_listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
        touch_listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
        touch_listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_CANCELLED )
        local eventDispatcher = self:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(touch_listener, self.touchNode) 
        touch_listener:setSwallowTouches(false)

        self.touch_listener_clip = touch_listener
    -- end

    self.m_TouchRect = cc.rect(posX,posY,width,height)


    if global.guideData:getGuideRect() then
        self.m_touchLayerColor = cc.LayerColor:create(cc.c4b(255,0,0, 0.5*255), width, height)
        self.m_touchLayerColor:setPosition(cc.p(posX,posY))
        self:addChild(self.m_touchLayerColor,9999)
    end
end


function GuideMaskLayer:getTouchTarget(data)
    local sceneMgr = global.scMgr
    local panelMgr = global.panelMgr
    local guideData = global.guideData
    if sceneMgr:isCurrScene(string.ucfirst(data.scene)) then
        local name = panelMgr:getTopPanelName()
        if name == data.paths then
            local panel = panelMgr:getPanel(name)
            if panel[data.target] then
                return panel[data.target]
            else
                local btn = guideData:getTarget(data.paths,data.target)
                if btn then
                    return btn
                end
            end
        else
            if sceneMgr:isMainScene() then
                local cityView = global.g_cityView
                if WDEFINE.GUIDE_TARGET_KEY.BUILDINGS == data.paths then
                    local buildingItem = cityView:getTouchMgr():getBuildingNodeBy(tonumber(data.target))
                    if buildingItem then
                        --定位过去
                        global.funcGame.gpsCityBuildingById(tonumber(data.target),false)
                        return buildingItem:getBuildingSprite()
                    end
                elseif WDEFINE.GUIDE_TARGET_KEY.OPERATE== data.paths then
                    local operateMgr = cityView:getOperateMgr()
                    if operateMgr then
                        local btn = operateMgr:getBtnBy(data.target)
                        if btn then
                            return btn
                        end
                    end
                elseif WDEFINE.GUIDE_TARGET_KEY.UI == data.paths then
                    local btn = guideData:getTarget(data.paths,data.target)
                    if btn then
                        return btn
                    end
                elseif WDEFINE.GUIDE_TARGET_KEY.BUILDLIST == data.paths then
                    local buildListItem = cityView:getBuildListPanel():gpsCardByBuildingType(tonumber(data.target))
                    -- local btn = guideData:getTarget(data.paths,data.target)
                    if buildListItem then
                        return buildListItem:getBtn()
                    end
                else
                end
            end
        end
        log.error("@@@@@@@@@@@GuideMaskLayer:getTouchTarget cannot get target:%s,panel:%s,guidestep:%s",data.target,name,data.step)

        if guideData.temp_step and guideData.temp_step == guideData:getStep() then
            guideData.temp_tryTimes = guideData.temp_tryTimes+1
        else
            guideData.temp_step = guideData:getStep()
            guideData.temp_tryTimes = 0
        end
        self.scheduleId = gscheduler.performWithDelayGlobal(function()
            gevent:call(global.gameEvent.EV_ON_GUIDE_START,guideData:getStep())
        end,0.3)

        if guideData.temp_tryTimes >= 4 then
            --尝试4次后执行
            --回退到当前引导的第一步
            if guideData:getBackStep() == guideData.temp_step then
                assert(true,"引导无法继续")
            else
                gevent:call(global.gameEvent.EV_ON_GUIDE_START,guideData:getBackStep())
            end
        end
        log.error("@@@@@@@@@@@GuideMaskLayer:getTouchTarget try again self.step:%s,self.tryTimes:%s,guideData:getStep():%s",guideData.temp_step,guideData.temp_tryTimes,guideData:getStep())
        return nil
    end
end

function GuideMaskLayer:registerTouchEvent()
    local function onTouchBegan(touch, event)
        return self:onTouchBegan(touch, event)
    end

    local function onTouchMoved(touch, event)
        self:onTouchMoved(touch, event)
    end

    local function onTouchEnded(touch, event)
        self:onTouchEnded(touch, event)
    end

    local function onTouchCancelled(touch, event)
        self:onTouchCancelled(touch, event)
    end
    --注册触摸事件
    self.touch_listener = cc.EventListenerTouchOneByOne:create();
    self.touch_listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    self.touch_listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    self.touch_listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    self.touch_listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_CANCELLED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.touch_listener, self) 
    self.touch_listener:setSwallowTouches(true)
end

function GuideMaskLayer:onTouchBegan(touch, event)
    if not self.m_TouchRect then
        log.trace("@GuideMaskLayer:onTouchBegan-->step touch invalid return")
        return false
    end
    
    local location = touch:getLocation()
    if cc.rectContainsPoint(self.m_TouchRect,cc.p(location.x,location.y)) then
        return false
    end
    log.trace("@GuideMaskLayer:onTouchBegan-->step touch not click right rect")
    return true
end

function GuideMaskLayer:onTouchMoved(touch, event)
 
end

function GuideMaskLayer:onTouchEnded(touch, event)
end

function GuideMaskLayer:onTouchCancelled(touch, event)

end

function GuideMaskLayer:adjustHandPos()
    local screenPos = self.hand:convertToWorldSpace(cc.p(0,0))
    local size = self.hand.guide_hand_export:getContentSize()
    local rect = cc.rect(screenPos.x-size.width*0.5,screenPos.y-size.height*0.5,size.width,size.height)

    local width = gdisplay.width
    local height = gdisplay.height

    local inchx = 0
    local inchy = 0
    if rect.x < inchx then
        self.hand.guide_hand_export:setFlippedX(false)
        self.hand:setPositionX(screenPos.x-0)
    end
    if rect.x+rect.width > width-inchx then
        self.hand.guide_hand_export:setFlippedX(true)
        self.hand:setPositionX(screenPos.x-size.width)
    end
    if rect.y < inchy then
        self.hand.guide_hand_export:setFlippedY(false)
        self.hand:setPositionY(screenPos.y)
    end
    if rect.y+rect.height > height then
        self.hand.guide_hand_export:setFlippedY(true)
        self.hand:setPositionY(screenPos.y-size.height)
    end
end

return GuideMaskLayer