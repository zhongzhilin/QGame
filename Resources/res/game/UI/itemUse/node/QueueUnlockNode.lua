local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local speedData = global.speedData
local funcGame = global.funcGame
local normalItemData = global.normalItemData

local QueueUnlockNode  = class("QueueUnlockNode", function() return gdisplay.newWidget() end )

function QueueUnlockNode:ctor( callFunc,queueId )
    self.panel = global.speedPanel 
    self.queueId = queueId
    self:initUI(callFunc)
end

function QueueUnlockNode:onEnter() 
    
end

function QueueUnlockNode:initUI(callFunc)

	self.unLockQueue = callFunc
    self.lockRestTime = 0
    self.panel.queueUnlock_node:setVisible(true)
    self.panel.queueUnlock_node.txt_leftTime_mlan_34:setString(luaCfg:get_local_string(10041))
    self.panel.restTime_node:setVisible(false)
    self.panel.timeline_node:setVisible(false)

    self.lockRestTime = self.unLockQueue( 0 )
    self:checkNodeState()
end

function QueueUnlockNode:onExit()
    

    if self.m_countDownTimerLock then
        gscheduler.unscheduleGlobal(self.m_countDownTimerLock)
        self.m_countDownTimerLock = nil
    end
    if not tolua.isnull(self.panel.btnUse) then
        self.panel.btnUse.use_mlan_4:setString(luaCfg:get_local_string(10897))
    end

end

function QueueUnlockNode:checkNodeState()
    
    if self.queueId and self.queueId == 3 then

        self.m_openEndTime = global.cityData:getQueueById(3).lRestTime
        self:cutDownTimeLock()
        global.tools:adjustNodePos(self.panel.text,self.panel.leftTime)
        if self.m_countDownTimerLock then
        else
            self.m_countDownTimerLock = gscheduler.scheduleGlobal(handler(self,self.cutDownTimeLock), 1)
        end
    end
end

function QueueUnlockNode:cutDownTimeLock()
    if not self.lockRestTime or self.lockRestTime<=0 then
        return
    end
    local restTime = math.ceil(self.lockRestTime - global.dataMgr:getServerTime())

    if not self.panel.restTime_node:isVisible() then
        self.panel.restTime_node:setVisible(true)
    end

    local dayNum = math.floor(restTime/(24*3600))
    local str = ""
    if dayNum > 0 then
        str = string.format(global.luaCfg:get_local_string(10675),dayNum ,global.funcGame.formatTimeToHMS(restTime-dayNum*24*3600)) 
    else
        str = global.funcGame.formatTimeToHMS(restTime)
    end
    global.tools:adjustNodePos(self.panel.text,self.panel.leftTime)
    self.panel.leftTime:setString(str)
    if restTime <= 0 then

        if self.m_countDownTimerLock then
            gscheduler.unscheduleGlobal(self.m_countDownTimerLock)
            self.m_countDownTimerLock = nil
        end
        self.panel.leftTime:setString("00:00:00")
        return
    end
end

function QueueUnlockNode:setItemData(data)

    self.panel.speedTime_node:setVisible(true)
	local spaceStr = self.panel.spaceNum:getString()
    self.panel.btnUse.use_mlan_4:setString(luaCfg:get_local_string(10897))
    if data.itemId == 6 then

		local spaceStr = self.panel.spaceNum:getString()
		local queueData = luaCfg:get_build_queue_by(3)
	    for _,v in pairs(queueData.unlockCost) do
	        if v[1] == 6 then
	            self.panel.need:setString(v[2])
	        end
	    end
	    self.panel.textEnd:setString(self.panel:getSpaceStr()..string.format(luaCfg:get_local_string(10039), queueData.time) .. "?")
        self.panel:setLineBreak(self.panel.textEnd, self.panel.textEnd:getString())
        global.tools:adjustNodePos(self.panel.textHead, self.panel.need)
    
    elseif data.itemType == 133 then
        -- 建造周卡
        self.panel.slider:setVisible(false)
        self.panel.speedTime_node:setVisible(false)
        self.panel.btnUse.use_mlan_4:setString(luaCfg:get_local_string(10014))
	else
        self.panel.slider:setVisible(true)
		local itemCount = normalItemData:getItemById(data.itemId).count
		if itemCount <= 0 then
            self.panel:itemCountNotEnough(spaceStr, data.itemName)
            self.panel.speedUseText:setString(luaCfg:get_local_string(10031))
        else
     		self.panel.btnUse:setEnabled(true)
			local maxCount = itemCount
	        self.panel.sliderControl:setMaxCount(maxCount)
	        if maxCount == 1 then
	            self.panel.sliderControl:reSetMaxCount(1)
	        end

	        self.panel.speedUseText:setString(luaCfg:get_local_string(10031))
	        local restTime = data.typePara1*60
	        self.panel.speedTime:setString(funcGame.formatTimeToHMS(restTime))           
	    end
        global.tools:adjustNodePos(self.panel.speedUseText, self.panel.speedTime)
	end
end

function QueueUnlockNode:unLockThreeQueue()
    
    local item = self.panel.scrollviewPanel:getChildByTag(self.panel.curItemTag+1005)

    local exitAction = cc.Sequence:create(cc.CallFunc:create(function()
        item:ActionBack()
    end),cc.DelayTime:create(0.3), cc.CallFunc:create(function()
        self.panel:exit()
        if item.data.itemId == 6 then
            local needNum =  tonumber(self.panel.need:getString())
            local diamondTotalNum = tonumber(item.num:getString())
            if self.panel:checkDiamondEnough(needNum) then
                self.lockRestTime =   self.unLockQueue( item.data.itemId,  0)

                item.num:setString(string.format("%d",(diamondTotalNum - needNum)))

                normalItemData:updateItem({id = item.data.itemId,count = (diamondTotalNum - needNum)}) 
            end
        elseif item.data.itemType == 133 then
            -- 建造周卡前往周卡界面
            local panel = global.panelMgr:openPanel("UIMonthCardPanel")
            panel:setData()
            panel:jumpCardForBuild()
        else
            local number = tonumber(self.panel.cur:getString())
            self.lockRestTime = self.unLockQueue( item.data.itemId,  number)
            normalItemData:updateItem({id = item.data.itemId,count = number})
        end
        
    end))
    self:runAction(exitAction)
end

return QueueUnlockNode
	