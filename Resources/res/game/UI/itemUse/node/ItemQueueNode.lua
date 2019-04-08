local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local speedData = global.speedData
local funcGame = global.funcGame
local normalItemData = global.normalItemData

local ItemQueueNode  = class("ItemQueueNode", function() return gdisplay.newWidget() end )

function ItemQueueNode:ctor(queueId, callFunc)
   
    self.initNumber = 0
    self.isNeedUse = true
    self.isNotCutTime = true
    self.curRestTime = 0
    self.cutTime = 0

    self.panel = global.speedPanel 
    self.queueId = queueId
    self:initUI(callFunc)
end

function ItemQueueNode:initUI(callFunc)
    
    self.panel.textLeftTimeMlan:setString(luaCfg:get_local_string(10047))
    self.updataTime = callFunc

    local a, b, c, d  = self.updataTime()
    self.m_restTime = math.floor(a or 0)
    self.m_totalTime = math.floor(b or 0)
    self.lockRestTime = math.floor(c or 0)
    self.m_endTime = self.m_restTime+global.dataMgr:getServerTime()
    
    self:checkNodeState()
    global.tools:adjustNodePos(self.panel.text,self.panel.leftTime)

    local num =  math.floor(global.funcGame.getDiamondCount(self.m_restTime))
    self.initNumber = num

    if not self.m_countDownTimer then
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.cutTimeHandler), 1)
    end
    self:cutTimeHandler()
    
end

function ItemQueueNode:setItemData(data)
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
        self.panel.textEnd:setString(self.panel:getSpaceStr()..string.format(luaCfg:get_local_string(10040)) .. "?")
        
        self.panel:setLineBreak(self.panel.textEnd, self.panel.textEnd:getString())
        global.tools:adjustNodePos(self.panel.textHead, self.panel.need)
      
    else

        local itemCount = normalItemData:getItemById(data.itemId).count
        if itemCount <= 0 then
            self.panel:itemCountNotEnough(spaceStr, data.itemName)
        else
            self.panel.btnUse:setEnabled(true)
            local maxCount = math.ceil( (self.m_restTime / 60) / data.typePara1) 
            if  itemCount <= maxCount then
                maxCount = itemCount
            end
            self.panel.sliderControl:setMaxCount(maxCount)
            if maxCount == 1 then
                self.panel.sliderControl:reSetMaxCount(1)
                self.panel.speedTime:setString(funcGame.formatTimeToHMS(data.typePara1*60))
            else

                local rest = self:getRecommendTime(self.m_restTime) 
                local changeCountNum = math.ceil( (rest / 60) / data.typePara1) 
                changeCountNum = self:checkMaxCount(changeCountNum, maxCount, itemCount)
                self.panel.sliderControl:changeCount(changeCountNum)
                self.panel.speedTime:setString(funcGame.formatTimeToHMS(changeCountNum*data.typePara1*60))
                self.initNumber = changeCountNum

            end
            self.panel.speedUseText:setString(luaCfg:get_local_string(10030))
            global.tools:adjustNodePos(self.panel.speedUseText, self.panel.speedTime)

        end

        -- 使用百分比队列加速道具
        if data.itemType == 210 then

            self.panel.slider:setVisible(false)
            self.panel.speedTime_node:setVisible(false)
            self.panel.mojing_node:setVisible(true)
            self.panel.need:setString(1)
            self.panel.need:setTextColor(cc.c3b(255, 226, 165))
            self.panel.textEnd:setString(self.panel:getSpaceStr()..string.format(luaCfg:get_local_string(10135), data.itemName) .. "?")

        end
    end
end

function ItemQueueNode:cutTimeHandler()

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

            if itemCount > 0 then

                local maxCount = count
                if  itemCount <= maxCount then
                    maxCount = itemCount
                end

                if maxCount ~= curCount then
                    self.panel.sliderControl:setMaxCount(maxCount)
                    self.panel.sliderControl:changeCount(self.initNumber)
                end

                if maxCount == 1 then
                    self.panel.sliderControl:reSetMaxCount(1)
                else 

                    local rest = self:getRecommendTime(self.m_restTime) 
                    local changeCountNum = math.ceil( (rest / 60) / self.data.typePara1)
                    changeCountNum = self:checkMaxCount(changeCountNum, maxCount, itemCount)
                    if self.initNumber ~= changeCountNum then
                        self.panel.sliderControl:changeCount(changeCountNum)
                        self.initNumber = changeCountNum
                    end
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

function ItemQueueNode:cutLoadingBarToPer( per )

    local tempPer = self.panel.LoadingBar:getPercent()
    local cutTime = self.cutTime
    local restTime = self.curRestTime
    local cutPer = tempPer - per

    self.isNotCutTime = false
    self.panel.topModel:setVisible(true)
 
    self.scheduleListenerLoad = gscheduler.scheduleGlobal(function()
        if tempPer <= per then
            self.isNotCutTime = true
            gscheduler.unscheduleGlobal(self.scheduleListenerLoad)
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
            else
                self.panel.topModel:setVisible(false)

                -- 小于免费时间
                if restTime <= global.cityData:getFreeBuildTime() then
                    self.panel:exit()                   
                end
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

function ItemQueueNode:clearQueue()
    local buildingId = self.panel.buildingId or 0
    local item = self.panel.scrollviewPanel:getChildByTag(self.panel.curItemTag+1005)
    if item.data.itemId == 6 then
        if self:checkEnough() then
            global.cityApi:clearQueue( self.queueId , 2 ,function(msg)
                local needNum =  tonumber(self.panel.need:getString())
                local diamondTotalNum = tonumber(item.num:getString())
                local leftNum = diamondTotalNum - needNum
                if leftNum <  0 then leftNum = 0 end
                item.num:setString(string.format("%d",leftNum))
                normalItemData:updateItem({id = item.data.itemId,count = leftNum})

                self.isNotCutTime = false
                self.cutTime = self.m_restTime
                self.curRestTime = self.m_restTime
                self:cutLoadingBarToPer(0)
                item:ActionBack()
                self.m_restTime, self.m_totalTime = self.updataTime(msg)
                self.m_endTime = self.m_restTime+global.dataMgr:getServerTime()
            end,buildingId)
        else
            global.panelMgr:openPanel("UIRechargePanel")
        end
    else

        local number = tonumber(self.panel.cur:getString())
        if self.data.itemType == 210 then -- 百分比加速道具
            number = 1
        end

        local clearType = 0
        if self.m_restTime <= global.cityData:getFreeBuildTime() then
            clearType = 0 
        else
            clearType = 3
        end

        local cutTime = number * self.data.typePara1 * 60
        if self.data.itemType == 210 then
            cutTime = self.m_restTime*(1-self.data.typePara1/100)
        end 

        if  cutTime > self.m_restTime and self.isNeedUse then
            self.isNeedUse = true
            self.panel.topModel:setVisible(false)
            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("ItemUse", handler(self, self.itemClickCall))
            return
        end

        local clearCall = function ()

            global.cityApi:clearQueue( self.queueId,clearType,function(msg)
                
                local count = tonumber(item.num:getString()) - number
                if count < 0 then count = 0 end
                item.num:setString(string.format("%d",count))
                normalItemData:updateItem({id = item.data.itemId,count = count})

                self.curRestTime = self.m_restTime
                if self.m_restTime <= cutTime  then
                    self.cutTime = self.m_restTime
                    self.isNotCutTime = false
                    self:cutLoadingBarToPer(0)
                    item:ActionBack()
                    self.m_restTime, self.m_totalTime = self.updataTime(msg)
                    self.m_endTime = self.m_restTime+global.dataMgr:getServerTime()
                else
                    
                    self.panel.btnUse:setEnabled(true)
                    self.cutTime = cutTime
                    self.m_restTime = self.m_restTime - cutTime
                    self.m_restTime, self.m_totalTime = self.updataTime(msg)
                    self.m_endTime = self.m_restTime+global.dataMgr:getServerTime()
                    self:cutLoadingBarToPer(self.m_restTime / self.m_totalTime * 100)

                    if count == 0 then
                        self.panel.isFirstClick = true
                        self:itemCountNotEnough("", "")
                        item:ActionBack()
                        return
                    else
                        local maxCount =  math.ceil( (self.m_restTime / 60) / self.data.typePara1)
                        if count <= maxCount then
                            maxCount = count
                        end
                        self.panel.sliderControl:setMaxCount(maxCount)
                        if maxCount == 1 then
                            self.panel.sliderControl:reSetMaxCount(1)
                        end

                        -- 如果剩余时间小于免费时间
                        local rest = self:getRecommendTime(self.m_restTime)
                        if rest <= global.cityData:getFreeBuildTime() then                  
                            item:ActionBack()
                        end
                    end
                end
            end, buildingId,item.data.itemId,number, function ()
                self.panel:exit()
            end)

        end

        if self.data.itemType == 210 then
            local panel = global.panelMgr:openPanel("UIPromptPanel") 
            panel:setPanelExitCallFun(function ()
                if not tolua.isnull(self.panel) then
                    self.panel.topModel:setVisible(false)
                end
            end) 
            panel:setData(10913, function()
                clearCall()
            end) 
        else
            clearCall()
        end

    end

end

function ItemQueueNode:itemClickCall()

    self.isNeedUse = false
    self.panel:useItem_click()
end

function ItemQueueNode:itemCountNotEnough(spaceStr, itemName )
    
    self.panel:itemCountNotEnough("", "")
    self.panel.speedUseText:setString(luaCfg:get_local_string(10030))
    global.tools:adjustNodePos(self.panel.speedUseText, self.panel.speedTime)
end

function ItemQueueNode:checkEnough()
    local maxCount =  math.floor(global.funcGame.getDiamondCount(self.m_restTime))
    return self.panel:checkDiamondEnough(maxCount)
end

function ItemQueueNode:checkMaxCount(_curCount, _maxCount, _itemCount)

    if  _itemCount <= _curCount then
        _curCount = _itemCount
    elseif  _curCount == _maxCount then
       _curCount = _curCount - 1
    end
    return  _curCount
end

function ItemQueueNode:checkNodeState()
    
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

function ItemQueueNode:cutDownTimeLock()

    local restTime = self.m_openEndTime - global.dataMgr:getServerTime()
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

-- 获取推荐规模时间(除去 免费时间和vip时间)
function ItemQueueNode:getRecommendTime(restTime)
    
    local normFree = global.cityData:getFreeBuildTime()
    
    print("--> normFree:"..normFree)

    local curRest = restTime - normFree
    return curRest
end

function ItemQueueNode:onExit()
    
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

return ItemQueueNode