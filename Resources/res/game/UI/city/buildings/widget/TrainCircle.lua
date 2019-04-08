--region TrainCircle.lua
--Author : yyt
--Date   : 2017/05/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local TrainCircle  = class("TrainCircle", function() return gdisplay.newWidget() end )

function TrainCircle:ctor()
    self:CreateUI()
end

function TrainCircle:CreateUI()
    local root = resMgr:createWidget("train/train_circle_node")
    self:initUI(root)
end

function TrainCircle:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "train/train_circle_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.circleBtn = self.root.Node_1.circleBtn_export
    self.Node_1 = self.root.Node_1.circleBtn_export.Node_1_export
    self.avatar = self.root.Node_1.circleBtn_export.avatar_export
    self.soldierNum = self.root.Node_1.circleBtn_export.soldierNum_export

    uiMgr:addWidgetTouchHandler(self.circleBtn, function(sender, eventType) self:harvestHandler(sender, eventType) end)
--EXPORT_NODE_END
	-- self.circleBtn:setSwallowTouches(false)
    self.nodeTimeLine = resMgr:createTimeline("train/train_circle_node")
    self.root:runAction(self.nodeTimeLine)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function TrainCircle:setData(soldierTrainData)

	self.soldierData = soldierTrainData
	-- self.avatar:setSpriteFrame(soldierTrainData.icon)
    global.panelMgr:setTextureFor(self.avatar,soldierTrainData.icon)
    self.avatar:setScale(0.7)
  	self:createProgress()
end

function TrainCircle:setHarvestCall(call)
    self.m_harvestCall = call
end

function TrainCircle:createProgress()

    -- 防止重复创建(切入后台，self.progress节点不会被清掉)
    if not self.progress then
    	self.progress = gdisplay.newProgressTimer("ui_surface_icon/train_circle_full.png", 0)
    	self.progress:setPercentage(0)
    	self.progress:setPosition(cc.p(0, 0))
    	self.progress:setMidpoint(cc.p(0.5, 0.5))
    	self.progress:setReverseDirection(false)
    	self.Node_1:addChild(self.progress)
    end
end

function TrainCircle:updateInfo(data, queueData)

    self.data = data
    self.queueData = queueData
	if self.progress then
		self.progress:setPercentage(data.percent)       
        self:playFullEffect(data.percent)
	end
    self:checkHarvestSoldier()
end

function TrainCircle:playFullEffect(percent)

    if self.nodeTimeLine then
        if percent >= 100 then
            self.nodeTimeLine:play("animation0", true)
        else
            self.nodeTimeLine:gotoFrameAndPause(25)
        end
    end  
end

function TrainCircle:checkHarvestSoldier()

    if not self.queueData then return end
    local harverNum = 0
    local totalTime = self.queueData.lEndTime-self.queueData.lStartTime
    local totalNum = self.queueData.lCount

    local currServerTime = global.dataMgr:getServerTime()
    local endTime = self.queueData.lEndTime

    if currServerTime >= endTime or totalTime <= 0 then

        self.soldierNum:setString(totalNum)
        harverNum = totalNum
    else

        local m_startTime = self.queueData.lStartTime  
        local leftTime = currServerTime-m_startTime
        if leftTime < 0 then leftTime = 0 end
        local m_output = math.floor((leftTime*totalNum)/totalTime)
        self.soldierNum:setString(m_output)
        harverNum = m_output
    end

    self:checkVisible(harverNum)

end

function TrainCircle:checkVisible(harverNum)

    if self.queueData.lSID == self.soldierData.id then
        if harverNum > 0 and (not self.circleBtn:isVisible()) then 
            -- self:showCircle()
        end
    end
end

function TrainCircle:playSound()
    
    gsound.stopEffect("city_click")
    if self.soldierData.type == 7 then
        if self.soldierData.skill == 1 then
            gevent:call(gsound.EV_ON_PLAYSOUND,"city_bartizan")
        else
            gevent:call(gsound.EV_ON_PLAYSOUND,"city_trap")
        end
    else
        gevent:call(gsound.EV_ON_PLAYSOUND,"city_train_"..self.soldierData.type)
    end
end

function TrainCircle:harvestHandler(sender, eventType)

    if tonumber(self.soldierNum:getString()) <= 0 then
        global.tipsMgr:showWarning("NotComplete")
        return
    end

	if self.m_harvestCall then        
        self:playSound()
        self.m_harvestCall(self.queueData)
    end
end

function TrainCircle:showCircle()

    self.circleBtn:setVisible(true)
    if self.nodeTimeLine then
        self.nodeTimeLine:play("animation1", false)
        self.nodeTimeLine:setLastFrameCallFunc(function()
            self:playFullEffect(self.data.percent)
        end)
    end
end

function TrainCircle:hideCircle()   
    self.circleBtn:setVisible(false)
    self.nodeTimeLine:gotoFrameAndPause(0)
end

--CALLBACKS_FUNCS_END

return TrainCircle

--endregion
