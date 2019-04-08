local luaCfg = global.luaCfg
local guideData = nil

local GuideManager = {}

function GuideManager:init()
    self.guide_config = {}
    guideData = global.guideData
    self:initListener()
end

-- function GuideManager:onEnter()
-- end

-- function GuideManager:onExit()
-- end

function GuideManager:over()
    if self.m_eventListener_start then
        gevent:removeListener(self.m_eventListener_start)
        self.m_eventListener_start = nil
    end

    if self.m_eventListener_next then
        gevent:removeListener(self.m_eventListener_next)
        self.m_eventListener_next = nil
    end

    cc.ScrollView:setNoTouchMove(false)
    
    if self.guide_layer then
        self.guide_layer:removeFromParent(true)
        self.guide_layer = nil;
    end
end

function GuideManager:initListener()
    log.debug("@guide:init listener success!")
    local callfunc = function(eventType,step)
        -- body
        if step then
            self:gotoStep(step)
        else
            self:gotoStep(guideData:getStep())
        end
    end
    self.m_eventListener_start = gevent:addListener(global.gameEvent.EV_ON_GUIDE_START, callfunc)

    local callfunc = function()
        -- body
        self:gotoStep(guideData:getNextStep(),func);
    end
    self.m_eventListener_next = gevent:addListener(global.gameEvent.EV_ON_GUIDE_NEXT, callfunc)
end

function GuideManager:gotoStep(index,func)
    if not global.OPENGUIDE then
        return
    end 
	if guideData:checkStepOver(index) then
        self:over()
        log.debug("@guide:gotoStep ,finish!")
		return
	end

    self:setStep(index)

    local info = guideData:getCurrConf()
    log.trace("@guide:gotoStep, getCurrConf=%s",vardump(info))
	if info.type == 2 then  --强制点击 
        self:addGuideLayer(func);
    end	
end

function GuideManager:setStep(step)
    -- log.trace("--setStep: %s,last_step: %s, stack:%s",step,guideData:getStep(),vardump(debug.traceback()))
    log.trace("--setStep: %s,last_step: %s",step,guideData:getStep())
    -- log.trace("--setStep:stack:%s",vardump(debug.traceback()))
    -- local a = debug.traceback()
    guideData:setStep(step)

    cc.UserDefault:getInstance():setIntegerForKey(WDEFINE.USERDEFAULT.GUIDE_STEP,step)
end

function GuideManager:addGuideLayer(func)
	if self.guide_layer then
		self.guide_layer:removeFromParent(true)
		self.guide_layer = nil;
	end

    local data = guideData:getCurrConf()

    --设置scrollview禁止滑动
    cc.ScrollView:setNoTouchMove(data.enforce == 1)

    if data.enforce == 1 then
        self.guide_layer = require("game.UI.guide.GuideMaskLayer").new(func)
        global.panelMgr:addWidgetToGuide(self.guide_layer)
        -- WindowManager:getInstance():showSecondWindow(self.guide_layer)
        local hand = self:addHand()
        self.guide_layer:setData(data,hand)
    else
        self.guide_layer = cc.Layer:create()
        global.panelMgr:addWidgetToGuide(self.guide_layer)
    end
end

function GuideManager:addHand(func)
    local resMgr = global.resMgr
    local name = "common/guide_hand_node"
    local actionStr = "click"
    local isloop = true
    local csb = resMgr:createCsbAction(name,actionStr,isloop,isRemoveSelf,frameListener)
    return csb
end

global.guideMgr = GuideManager
-- return GuideManager