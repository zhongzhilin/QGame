local guideNewButton = class("guideNewButton", function() return gdisplay.newWidget() end )

guideNewButton.m_isMoved = nil
function guideNewButton:ctor(button,func)
	BaseWidget.ctor(self)
	self:registerTouchEvent()

    self.button_info = {}
	self.m_finish_func = func
	self:renderUI(button)
	self.isCanTouch = false
    self.m_isMoved = false
	
end

function guideNewButton:onExitTransitionDidStart()
    BaseWidget.onExitTransitionDidStart(self)

    if self.touch_listener then
        self:getEventDispatcher():removeEventListener(self.touch_listener)
        self.touch_listener = nil
    end
end

function guideNewButton:registerTouchEvent()
    local function onTouchBegan()
        return true
    end
    local function onTouchEnded(touch, event)
       self:doTouch()
    end
    self.touch_listener = cc.EventListenerTouchOneByOne:create();
    self.touch_listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN);
    self.touch_listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED);
    local eventDispatcher = self:getEventDispatcher();
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.touch_listener, self)
    self.touch_listener:setSwallowTouches(true)
end


function guideNewButton:renderUI()
    local button  = self:createNewButton(self.button_info)
    button:setButtonEnabled(false)
    self.guide_button_effect = cc.CSLoader:createNode("UIEffect/effect_xingongneng.csb")
    self.guide_button_action = cc.CSLoader:createTimeline("UIEffect/effect_xingongneng.csb")
    local button_layer = self.guide_button_effect:getChildByName("Node_1")
    button_layer:addChild(button,2)
    self.guide_button_effect:runAction(self.guide_button_action)
    self.guide_button_effect:setPosition(display.width/2,display.height/2)
    self.guide_button_action:gotoFrameAndPlay(0, 38, false)
    local function onFrameEvent(frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        local _, i_end = string.find(str, "playsound");
        if i_end then
            AudioMgr:playAudio(string.sub(str, i_end+2));
        elseif frame:getEvent() == "start1" then
            self.guide_button_action:gotoFrameAndPlay(38, 53, true)
            self.isCanTouch = true
            self.auto_move = cc.Sequence:create(cc.DelayTime:create(0.6),cc.CallFunc:create(function ()
                self:moveButton(button)
            end))
            self:runAction(self.auto_move)
        elseif frame:getEvent() == "over" then
        	self:moveButton(button)
        end
    end
    self.guide_button_action:setFrameEventCallFunc(onFrameEvent)
    self:addChild(self.guide_button_effect)
end

function guideNewButton:moveButton(button)
    if self.m_isMoved then
        return
    end
    self.m_isMoved = true
    self.isCanTouch = false
    self:insertButton()
    button:retain()
    button:removeFromParent(false)
    button:setPosition(display.width/2,display.height/2)
    button.parent:addChild(button)
    button:release()
    local move = cc.MoveTo:create(20*GameData.g_FrameInterval,self.button_info.targetPos)
    local easeout = cc.EaseSineInOut:create(move)
    local end_effect = cc.CallFunc:create(function()
        if self.particle_node then
            self.particle_node:removeFromParent(true)
            self.particle_node = nil
        end
        end)
    local delay = cc.DelayTime:create(15*GameData.g_FrameInterval)
    local callfunc = cc.CallFunc:create(function ()
        button:setButtonEnabled(true)
        self:endEffect(button,function ()
            if self.m_finish_func then
                self.m_finish_func()
            end
            self:removeFromParent(true)
        end)  
    end)
    button:runAction(cc.Sequence:create(easeout,end_effect,delay,callfunc,callfunc2))

    local to_small = cc.ScaleTo:create(20*GameData.g_FrameInterval,0.8) 
    local to_large = cc.ScaleTo:create(5*GameData.g_FrameInterval,1.15)
    local to_normal = cc.ScaleTo:create(8*GameData.g_FrameInterval,1)
    button.btn_common:runAction(cc.Sequence:create(to_small,to_large,to_normal))

    self.particle_node = cc.ParticleSystemQuad:create("UIEffect/effect_xinggongn.plist");
    self.particle_node:setScale(1.5)
    self.particle_node:setPositionType(cc.POSITION_TYPE_FREE);
    self.particle_node:setPosition(0,0)
    button:addChild(self.particle_node,-1);

    if self.guide_button_effect then
        self.guide_button_effect:removeFromParent(true)
        self.guide_button_effect = nil
    end
end

function guideNewButton:createNewButton()
	local  button
	local city = GameData.targetList["city"]
	if self.button_info.type == 1 or self.button_info.type == 2 then  --插入到最顶上按钮队列 或 插入到引导寻路的按钮队列
        button = city.ui_window:createNewButton(self.button_info)
        button.parent = city.ui_window
    elseif self.button_info.type == 3 or self.button_info.type == 4 then -- 插入到右侧竖着一列 或 插入到右侧竖着一行
        button = GameData.targetList["mainBtn"]:createNewButton(self.button_info)
        button.parent = GameData.targetList["mainBtn"].button_layer
    end
    return button
end

function guideNewButton:insertButton()
	local city = GameData.targetList["city"]
	if self.button_info.type == 1 or self.button_info.type == 2 then  --插入到最顶上按钮队列 或 插入到引导寻路的按钮队列
        city.ui_window:insertButton(self.button_info)

    elseif self.button_info.type == 3 or self.button_info.type == 4 then -- 插入到右侧竖着一列 或 插入到右侧竖着一行
        GameData.targetList["mainBtn"]:insertButton(self.button_info)
    end
end

function guideNewButton:doTouch()
	if self.isCanTouch then
		self.isCanTouch = false
		self.guide_button_action:gotoFrameAndPlay(self.guide_button_action:getCurrentFrame(),false)
        if self.auto_move then
            self:stopAction(self.auto_move)
            self.auto_move = nil
        end
	end

end


function guideNewButton:endEffect(node,func)
	self.guide_end_effect = cc.CSLoader:createNode("UIEffect/effect_xingongneng_feidao.csb")
    self.guide_end_action = cc.CSLoader:createTimeline("UIEffect/effect_xingongneng_feidao.csb")
    self.guide_end_effect:runAction(self.guide_end_action)
    self.guide_end_action:gotoFrameAndPlay(0,false)
    local function onFrameEvent(frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        local _, i_end = string.find(str, "playsound");
        if i_end then
            AudioMgr:playAudio(string.sub(str, i_end+2));
        elseif frame:getEvent() == "over" then
            if func then
                func()
            end
        	if self.guide_end_effect then
        		self.guide_end_effect:removeFromParent(true)
        		self.guide_end_effect = nil
        	end
        end
    end
    self.guide_end_action:setFrameEventCallFunc(onFrameEvent)
    node:addChild(self.guide_end_effect)
end

return guideNewButton