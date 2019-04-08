local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local speedData = global.speedData
local funcGame = global.funcGame
local normalItemData = global.normalItemData

local ItemQueueClear  = class("ItemQueueClear", function() return gdisplay.newWidget() end )

function ItemQueueClear:ctor( lType, queueId, callFunc)

    self.isNeedUse = true
    self.isNotCutTime = true
    self.curRestTime = 0
    self.cutTime = 0

    self.panel = global.speedPanel 
    self.queueId = queueId
    self.lType = lType
    self:initUI(callFunc)
end

function ItemQueueClear:initUI(callFunc)
    
    if self.lType == 3 then
        self.panel.textLeftTimeMlan:setString(luaCfg:get_local_string(10046))
    else 
        self.panel.textLeftTimeMlan:setString(luaCfg:get_local_string(10418))
    end

    self.updataTime = callFunc

    local a, b, c, d  = self.updataTime()
    self.m_restTime = math.floor(a or 0)
    self.m_totalTime = math.floor(b or 0)
    self.lockRestTime = math.floor(c or 0)
    self.m_endTime = self.m_restTime+global.dataMgr:getServerTime()
    
    self:checkNodeState()

    if not self.m_countDownTimer then
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.cutTimeHandler), 1)
    end
    self:cutTimeHandler()
end

function ItemQueueClear:setItemData(data)
    self.data = data 
    if data == nil then return end

    local spaceStr = self.panel.spaceNum:getString()
    if data.itemId == 6 then

        self:checkEnough()
        local maxCount =  math.floor(global.funcGame.getDiamondCount(self.m_restTime))
        if maxCount<=0 then 
            maxCount = 0
        end
        self.panel.need:setString( maxCount ) 

        if self.lType == 3 then     
            self.panel.textEnd:setString(self.panel:getSpaceStr()..string.format(luaCfg:get_local_string(10045)) .. "?")
        else     
            self.panel.textEnd:setString(self.panel:getSpaceStr()..string.format(luaCfg:get_local_string(10419)) .. "?")
        end
        
        self.panel:setLineBreak(self.panel.textEnd, self.panel.textEnd:getString())
        global.tools:adjustNodePos(self.panel.textHead, self.panel.need)
      
    else

        local itemCount = normalItemData:getItemById(data.itemId).count
        if itemCount <= 0 then
            self.panel:itemCountNotEnough(spaceStr, data.itemName)
        else
            self.panel.btnUse:setEnabled(true)
            local maxCount = math.ceil( (self.m_restTime / 60) / data.typePara1)
            local changeCountNum = self:checkMaxCount(itemCount, maxCount)
            if  itemCount <= maxCount then
                maxCount = itemCount
            end
            self.panel.sliderControl:setMaxCount(maxCount)
            if maxCount == 1 then
                self.panel.sliderControl:reSetMaxCount(1)
                self.panel.speedTime:setString(funcGame.formatTimeToHMS(data.typePara1*60))
            else
                self.panel.sliderControl:changeCount(changeCountNum)
                self.panel.speedTime:setString(funcGame.formatTimeToHMS(changeCountNum*data.typePara1*60))
            end
            self.panel.speedUseText:setString(luaCfg:get_local_string(10030))
            global.tools:adjustNodePos(self.panel.speedUseText, self.panel.speedTime)

        end
    end
end

function ItemQueueClear:cutTimeHandler()

    local item = self.panel.scrollviewPanel:getChildByTag(self.panel.curItemTag+1005)
    self.m_restTime = math.floor(self.m_endTime-global.dataMgr:getServerTime())

    if self.data ~= nil then
        local maxCount =  math.floor(global.funcGame.getDiamondCount(self.m_restTime))
        local needDiamondNum = tonumber(self.panel.need:getString())
        if item and item.data.itemId == 6  and maxCount ~= needDiamondNum then  -- 刷新魔晶需要数量
    
            self:checkEnough()
            if maxCount>0 then 
                self.panel.need:setString(maxCount-1) 
            else
                self.panel.need:setString(0) 
            end
        else
            local itemCount = normalItemData:getItemById(self.data.itemId).count
            local count = math.ceil( (self.m_restTime / 60) / self.data.typePara1)
            local curCount = tonumber(self.panel.sliderControl.max:getString())
            if  itemCount <= count then
                count = itemCount
            end
            if  count ~= curCount  and itemCount > 0 then

                local maxCount = count
                local changeCountNum = self:checkMaxCount(itemCount, maxCount)
                if  itemCount <= maxCount then
                    maxCount = itemCount
                end
                self.panel.sliderControl:setMaxCount(maxCount)
                if maxCount == 1 then
                    self.panel.sliderControl:reSetMaxCount(1)
                else
                    self.panel.sliderControl:changeCount(changeCountNum)
                end
            end
        end
    end

    if self.isNotCutTime then
        self.panel.LoadingBar:setPercent(self.m_restTime / self.m_totalTime * 100)
        if self.m_restTime > 0 then
            self.panel.txt_leftTime:setString(funcGame.formatTimeToHMS(self.m_restTime))
        else
            self.panel.txt_leftTime:setString("00:00:00")
        end 
    end

    if self.m_restTime <= 0 and self.isNotCutTime  then

        if self.m_countDownTimer then

            gscheduler.unscheduleGlobal(self.m_countDownTimer)
            self.m_countDownTimer = nil
            if item and (not self.panel.isFirstClick) then
                item:ActionBack()
            end
            self:cutLoadingBarToPer(0)
        end
        return
    end
end

function ItemQueueClear:cutLoadingBarToPer( per )

    local tempPer = self.panel.LoadingBar:getPercent()
    local cutTime = self.cutTime
    local restTime = self.curRestTime
    local cutPer = tempPer - per

    self.isNotCutTime = false
    if not tolua.isnull(self.panel) then -- protect 
        self.panel.topModel:setVisible(true)
        self.scheduleListenerLoad = gscheduler.scheduleGlobal(function()
           if tempPer <= per then
                self.isNotCutTime = true
                if self.scheduleListenerLoad then 
                    gscheduler.unscheduleGlobal(self.scheduleListenerLoad)
                end 
                if per == 0 then 
                    if self.m_countDownTimer then

                        gscheduler.unscheduleGlobal(self.m_countDownTimer)
                        self.m_countDownTimer = nil
                    end
                    self.panel.LoadingBar:setPercent(0)
                    local exitAction = cc.Sequence:create(cc.DelayTime:create(0.3), cc.CallFunc:create(function()
                        self.panel:exit()
                    end))
                    self:runAction(exitAction)
                    self.panel.txt_leftTime:setString("00:00:00")
                    return
                else
                    self.panel.topModel:setVisible(false)
                end
                self:cutTimeHandler()
                return
           end
            tempPer = tempPer - 1
            if restTime > 0 then
                self.panel.txt_leftTime:setString(funcGame.formatTimeToHMS(restTime))
                restTime = restTime - cutTime/cutPer
            end
           self.panel.LoadingBar:setPercent(tempPer)
        end, 1/60)
    end
end

function ItemQueueClear:clearQueue()
    local buildingId = self.panel.buildingId or 0
    local item = self.panel.scrollviewPanel:getChildByTag(self.panel.curItemTag+1005)
    if item.data.itemId == 6 then
        if self:checkEnough() then
            global.cityApi:clearQueue( self.queueId , 2 ,function(msg)
                local needNum =  tonumber(self.panel.need:getString())
                local diamondTotalNum = tonumber(item.num:getString())
                item.num:setString(string.format("%d",(diamondTotalNum - needNum)))
                normalItemData:updateItem({id = item.data.itemId,count = (diamondTotalNum - needNum)})

                self.isNotCutTime = false
                self.cutTime = self.m_restTime
                self.curRestTime = self.m_restTime
                self:cutLoadingBarToPer(0)
                item:ActionBack()
                self.m_restTime, self.m_totalTime = self.updataTime(msg, self.cutTime)
                self.m_restTime = self.m_restTime or 0
                self.m_endTime = self.m_restTime+global.dataMgr:getServerTime()
            end,buildingId)
        else
            global.panelMgr:openPanel("UIRechargePanel")
        end
    else

        local number = tonumber(self.panel.cur:getString())
        local cutTime = number * self.data.typePara1 * 60

        local curStep = global.guideMgr:getCurStep() or 0
        local isTrainGuide = global.guideMgr:isPlaying() and (curStep == 20011)

        if  cutTime > self.m_restTime and self.isNeedUse and not isTrainGuide then
            self.isNeedUse = true
            self.panel.topModel:setVisible(false)
            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("ItemUse", handler(self, self.itemClickCall))
            return
        end

        global.cityApi:clearQueue( self.queueId,3,function(msg)
            
            local count = tonumber(item.num:getString()) - number
            item.num:setString(string.format("%d",count))
            normalItemData:updateItem({id = item.data.itemId,count = count})

            self.curRestTime = self.m_restTime
            if self.m_restTime <= cutTime  then
                self.cutTime = self.m_restTime
                self.isNotCutTime = false
                self:cutLoadingBarToPer(0)
                item:ActionBack()
                self.m_restTime, self.m_totalTime = self.updataTime(msg, self.cutTime)
                self.m_endTime = self.m_restTime+global.dataMgr:getServerTime()
            else
                
                self.panel.btnUse:setEnabled(true)
                self.cutTime = cutTime
                self.m_restTime = self.m_restTime - cutTime
                self.m_restTime, self.m_totalTime = self.updataTime(msg, self.cutTime)
                self.m_endTime = self.m_restTime+global.dataMgr:getServerTime()
                self:cutLoadingBarToPer(self.m_restTime / self.m_totalTime * 100)
                if count == 0 then
                    self.panel.isFirstClick = true
                    self:itemCountNotEnough("", "")
                    item:ActionBack()
                    return
                else
                    local maxCount =  math.ceil( (self.m_restTime / 60) / self.data.typePara1)

                    if  count <= maxCount then
                        maxCount = count
                    end
                    self.panel.sliderControl:setMaxCount(maxCount)
                    if maxCount == 1 then
                        self.panel.sliderControl:reSetMaxCount(1)
                    end
                end
            end
        end, buildingId,item.data.itemId,number)
    end

end

function ItemQueueClear:itemClickCall()

    self.isNeedUse = false
    if not tolua.isnull(self.panel) then 
        self.panel:useItem_click()
    end 
end

function ItemQueueClear:itemCountNotEnough(spaceStr, itemName )
    
    self.panel:itemCountNotEnough("", "")
    self.panel.speedUseText:setString(luaCfg:get_local_string(10030))
    global.tools:adjustNodePos(self.panel.speedUseText, self.panel.speedTime)
end

function ItemQueueClear:checkEnough()
    local maxCount =  math.floor(global.funcGame.getDiamondCount(self.m_restTime))
    return self.panel:checkDiamondEnough(maxCount)
end

function ItemQueueClear:checkMaxCount( _curCount, _maxCount )
    
    local isChoose = 0
    if  _curCount <= _maxCount then
        _maxCount = _curCount
        isChoose = 1
    end
    if isChoose == 0 then  _maxCount = _maxCount - 1 end
    return  _maxCount
end

function ItemQueueClear:checkNodeState()
    
    self.panel.queueUnlock_node:setVisible(false)
    if self.queueId and self.queueId == 3 then
        self.panel.restTime_node:setVisible(true)

        self.m_openEndTime = global.cityData:getQueueById(3).lRestTime
        self:cutDownTimeLock()
        if self.m_countDownTimerLock then
        else
            self.m_countDownTimerLock = gscheduler.scheduleGlobal(handler(self,self.cutDownTimeLock), 1)
        end
    else
        self.panel.restTime_node:setVisible(false)
    end
end

function ItemQueueClear:cutDownTimeLock()

    local restTime = self.m_openEndTime - global.dataMgr:getServerTime()
    self.panel.leftTime:setString(funcGame.formatTimeToHMS(restTime))
    if restTime <= 0 then

        if self.m_countDownTimerLock then
            gscheduler.unscheduleGlobal(self.m_countDownTimerLock)
            self.m_countDownTimerLock = nil
        end
        self.panel.leftTime:setString("00:00:00")
        return
    end
end

function ItemQueueClear:onExit()
    
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end

    if self.m_countDownTimerLock then
        gscheduler.unscheduleGlobal(self.m_countDownTimerLock)
        self.m_countDownTimerLock = nil
    end

    if self.scheduleListenerLoad then
        gscheduler.unscheduleGlobal(self.scheduleListenerLoad)
        self.scheduleListenerLoad = nil
    end

end

return ItemQueueClear