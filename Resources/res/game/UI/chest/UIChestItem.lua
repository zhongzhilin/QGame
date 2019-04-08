--region UIChestItem.lua
--Author : yyt
--Date   : 2017/02/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local dailyTaskData =  global.dailyTaskData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIChestItem  = class("UIChestItem", function() return gdisplay.newWidget() end )

function UIChestItem:ctor()
    self:CreateUI()
end

function UIChestItem:CreateUI()
    local root = resMgr:createWidget("effect/picture_bx2")
    self:initUI(root)
end

function UIChestItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "effect/picture_bx2")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.pic = self.root.Button_1.iconBg.pic_export

    uiMgr:addWidgetTouchHandler(self.root.Button_1, function(sender, eventType) self:icon_click(sender, eventType) end)
--EXPORT_NODE_END
	-- self.root.Button_1:setSwallowTouches(false)
    
    self.nodeTimeLine = resMgr:createTimeline("effect/picture_bx2")
    self:runAction(self.nodeTimeLine)

    self.preState = -1
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIChestItem:onEnter()

    if not self.m_countDownTimer then
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.checkStateHandler), 2)
    end
    self:checkStateHandler()

end

function UIChestItem:setData()
    	
    local state = dailyTaskData:getBagState()

    local flag = 0
    if state > 0 then
        flag = 1
    end

    if self.preState ~= state then
        self:playEffectBag(flag)
        self.preState = state
    end

end

function UIChestItem:checkStateHandler( dt )

    dailyTaskData:initFreeBagNum(dailyTaskData:getLastFreeMsg())

    local now_freeNum = dailyTaskData:getFreeBagNum()
    local now_wildNum = dailyTaskData:getWildTimes()
    dailyTaskData:setBagState(now_freeNum, now_wildNum)
    gevent:call(global.gameEvent.EV_ON_UI_REWARDBAG_FLUSHSTATE)

end

function UIChestItem:playEffectBag( flag )

	if flag == 0 then 
		self.nodeTimeLine:play("animation0", true)
        global.colorUtils.turnGray(self.pic, true)
    else 
		self.nodeTimeLine:play("animation1", true)
        global.colorUtils.turnGray(self.pic, false)
	end
	gevent:call(global.gameEvent.EV_ON_UI_LEISURE)
end

function UIChestItem:onExit()

    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end

end

function UIChestItem:icon_click(sender, eventType)

	global.panelMgr:openPanel("UIChestPanel"):setData()

end
--CALLBACKS_FUNCS_END

return UIChestItem

--endregion
