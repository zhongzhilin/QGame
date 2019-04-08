
--region TabControl.lua
--Author : Song
--Date   : 2016/4/14

--[[
    切换按钮组件 
--]]
local CountSliderControl = class("CountSliderControl")
local uiMgr = global.uiMgr
local gameEvent = global.gameEvent

--[[
    containerNode 按钮父容器  须指定容器中的按钮逻辑标签为从1开始的顺序
--]]

-- local topCountSlider = nil
local taskCount = -1

-- function CountSliderControl.getTopSlider()
    
--     return topCountSlider
-- end

function CountSliderControl.setTaskCount(count)
    
    taskCount = count
end

function CountSliderControl:ctor(containerNode, callFunc, isClear, isNotInput, isNotMaxCount)

    if callFunc ~= nil then self.callFunc = callFunc end

    topCountSlider = self

    self.slider = containerNode.slider
    self.max = containerNode.max
    self.inputText = containerNode.cur
    self.del = self.slider.del
    self.add = self.slider.add

    self.minCount = 1
    self.slider:addEventListener(handler(self, self.sliderChange))
    if not isNotInput then
        self.inputText:addEventListener(handler(self,self.inputChange))
    end
    uiMgr:addWidgetTouchHandler(self.del, function(sender, eventType) self:del_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.add, function(sender, eventType) self:add_call(sender, eventType) end)

    -- 点击是否清空
    self.isClear = isClear
    -- 是否取整
    self.isNotMaxCount = isNotMaxCount
    -- 是否不需要输入框
    self.isNotInput = isNotInput
    self.m_delegate = nil
end

function CountSliderControl:changeCount(contentCount,skipInputChange, isShowTips, event)

    if not self.maxCount then 
        -- [protect]
        return 
    end 

    contentCount = math.floor(contentCount + 0.5)
    if self.check_call then 
        local state , num =  self.check_call(contentCount) 
        if state then 
            contentCount = num 
            self.asjust_per = self:getValuePer(contentCount)
        else
            self.asjust_per = nil       
        end 
    end 

    self.curCount = contentCount
    if self.m_delegate then -- 检测上限条件
        contentCount, isMax = self.m_delegate:checkCondition(contentCount, isShowTips)
        if isMax then
            self.slider:setTouchEnabled(false)
            self.slider:setTouchEnabled(true)
        end
    end

    local pen = (contentCount - self.minCount) / (self.maxCount - self.minCount) * 100

    self.contentCount = contentCount

    if not skipInputChange then
        self.inputText:setString(self:setString(contentCount))
    end
    
    if self.callFunc then self.callFunc(contentCount, event) end
    -- if self.guideCall then self.guideCall(contentCount) end    

    if global.guideMgr:isPlaying() then

        if contentCount >= taskCount and taskCount ~= -1 then

            global.guideMgr:dealScript() 
            taskCount = -1     
            self.slider:setTouchEnabled(false)
            self.slider:setTouchEnabled(true)
        end
    end
    
    self.slider:setPercent(self.asjust_per or pen)

    self.del:setEnabled(true)
    self.add:setEnabled(true)

    if contentCount == self.minCount then

        self.del:setEnabled(false)
    end

    if contentCount == self.maxCount then

        self.add:setEnabled(false)
    end

    if self.minCount == 1 then
        if self.maxCount == 1 then
            self.slider:setPercent(100)
        elseif self.maxCount == 0 then
            self.slider:setPercent(0)
        end
    end
  
end

function CountSliderControl:setString(number)
    if self.formatCall then 
        return self.formatCall(number)
    end
    return number
end 

function CountSliderControl:setcheckCall(check_call)
    self.check_call = check_call
end 

function CountSliderControl:setMaxCount(maxCount, skipInputChange)
    -- body
    self.slider:setEnabled(true)
    self.inputText:setEnabled(true)
    self.del:setEnabled(true)
    self.add:setEnabled(true)
     
    self.maxCount = tonumber(maxCount)
    self.max:setString(string.format("%d",self.maxCount))
    self:changeCount(self.minCount, skipInputChange)  
end

function CountSliderControl:setMinCount(min)

    self.minCount = min or 0   
end

function CountSliderControl:setSingleCount(count)
    self.singleCount = count or 1
end

-- function CountSliderControl:setGuideEvent(guideCall)
    
--     self.guideCall = guideCall
-- end

-- function CountSliderControl:cleanGuideEvent()
    
--     self.guideCall = nil
-- end

function CountSliderControl:reSetMaxCount(maxCount)

    if maxCount == 0 then
        self.slider:setPercent(0)
        self.inputText:setString(0)
        self.contentCount=0
    else
        self.slider:setPercent(100)
        self.inputText:setString(1)
        self.contentCount=1
    end
   
    self.slider:setEnabled(false)
    self.max:setString(maxCount)
    self.inputText:setEnabled(false)
    self.del:setEnabled(false)
    self.add:setEnabled(false)
end

function CountSliderControl:setDelegate(delegate)
    self.m_delegate = delegate
end

function CountSliderControl:del_call(sender, eventType)

    if self.minCount <= 0 then 

        self:changeCount(self.contentCount - 1 )

    else

        if self.contentCount - self.minCount <=  self.minCount  then 

            self:changeCount( self.minCount  )
        else 
            self:changeCount( self.contentCount - self.minCount )

        end 
    end 
   
end

function CountSliderControl:add_call()
        
    if self.minCount <= 0 then 

        self:changeCount(self.contentCount + 1, nil, true)

    else 
      
        if self.contentCount + self.minCount > self.maxCount then 
            if self.isNotMaxCount then
                self:changeCount(self.contentCount, nil, true)
            else
                self:changeCount(self.maxCount, nil, true)
            end
        else 
            self:changeCount(self.contentCount +  self.minCount, nil, true)
        end 
    end 

end

function CountSliderControl:inputChange(eventType)
    -- body

    -- log.debug(eventType)
    if not self.maxCount then return end

    local number = tonumber(self.inputText:getString())

    -- 开始输入清空处理
    if eventType == "began" and self.isClear then
        self.inputText:setString("")
        number = self.minCount
    end

    if number == nil then
        if eventType == "return" then
            number = self.minCount
        else
            -- if not global.tools:isAndroid() then
            --     self.inputText:setString("")
            -- end
            return
        end
    end

    if not number or (number < self.minCount) then 
        number = self.minCount 
    end

    if number > self.maxCount then
        number = self.maxCount
    end

    if self.isNotMaxCount and (not self.isNotInput) then
        number = self:checkNum(number)
    end
    if  eventType ~= "return" then
        self:changeCount(number,true)
    else
        self:changeCount(number)
    end 
    
end

function CountSliderControl:checkNum(contentCount)

    if (self.minCount ~= 0) and (contentCount % self.minCount ~= 0) and (self.maxCount ~= 0) then 
        contentCount = contentCount - contentCount % self.minCount
        contentCount = contentCount + self.minCount
        if self.isNotMaxCount then
            contentCount = contentCount > self.maxCount and (contentCount-self.minCount) or contentCount
        else
            contentCount = contentCount > self.maxCount and self.maxCount or contentCount
        end
    end 
    return contentCount
end

function CountSliderControl:sliderChange(pSender, event)

    local pen =  pSender:getPercent()

    local contentCount = pen / 100 * (self.maxCount - self.minCount) + self.minCount
  
    if (self.minCount ~= 0) and (contentCount % self.minCount ~= 0) and (self.maxCount ~= 0) then 
        contentCount = contentCount - contentCount % self.minCount
        contentCount = contentCount + self.minCount
        if self.isNotMaxCount then
            contentCount = contentCount > self.maxCount and (contentCount-self.minCount) or contentCount
        else
            contentCount = contentCount > self.maxCount and self.maxCount or contentCount
        end
    end 

    self:changeCount(contentCount, nil, true, event)
end

function CountSliderControl:getValuePer(content)

    return  content /  (self.maxCount - self.minCount) * 100 + 1 
end 

function CountSliderControl:chooseAll()
    
    self:changeCount(self.maxCount)
end

function CountSliderControl:getContentCount()
    -- body
    return self.contentCount
end

function CountSliderControl:getCurCount()
    -- body
    return self.curCount
end

return CountSliderControl

--endregion
