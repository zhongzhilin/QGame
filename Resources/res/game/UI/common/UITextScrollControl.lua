local TextScrollControl = class("TextScrollControl", function() return gdisplay.newWidget() end )
local uiMgr = global.uiMgr

function TextScrollControl.startScroll(text,to,time,formatCall,callFunc,updateCall)
    
    local str = string.gsub(text:getString(),"%/","")
    local preContent = tonumber(str)
    if preContent == nil then preContent = 0 end

    if text._textScrollControl then

        if preContent == 0 then
            preContent = text._textScrollControl.content
        end

        text._textScrollControl:removeFromParent()
    end       

    local textScrollControl = TextScrollControl.new(text,preContent,to,time,formatCall,callFunc,updateCall)
    text:addChild(textScrollControl)
    text._textScrollControl = textScrollControl
end

function TextScrollControl.stopScroll(text)
    if text._textScrollControl then
        text._textScrollControl:removeFromParent()
        text._textScrollControl = nil
    end           
end

function TextScrollControl.startScrollFromTo(text,from,to,time,formatCall,callFunc,updateCall)

    local preContent = from

    if text._textScrollControl then

        -- if preContent == 0 then
        --     preContent = text._textScrollControl.content
        -- end        
        
        text._textScrollControl:removeFromParent()
    end           

    local textScrollControl = TextScrollControl.new(text,preContent,to,time,formatCall,callFunc,updateCall)
    text:addChild(textScrollControl)
    text._textScrollControl = textScrollControl
end

function TextScrollControl.toInt(num)
    
    return tostring(math.floor(num))    
end

function TextScrollControl.formalCallSplit(souceStr)
    local len = #souceStr
    local str = ""
    for i = 1,len do
        str = string.sub(souceStr,len-i+1,len-i+1)..str
        if i%3 == 0 and i < len then
            str = "/"..str
        end
    end    
    return souceStr -- 修改为 原文本返回 2018年3月21日17:19:28
end

function TextScrollControl:ctor(text,from,to,time,formatCall,callFunc,updateCall)

   if callFunc ~= nil then self.callFunc = callFunc end 
   if formatCall ~= nil then self.formatCall = formatCall end
   if updateCall ~= nil then self.updateCall = updateCall end

   self.text = text
   self.from = from
   self.to = to
   self.time = time

   self.content = from
   self.step = (to - from) / time / 60

   
    if not self.scheduleListenerId then
        self.scheduleListenerId = gscheduler.scheduleGlobal(function(dt)
            
            if tolua.isnull(self) then
                -- global.unscheduleGlobal(self.scheduleListenerId)
                return                
            end

            self:updateScroll(dt)
        end, 1 / 60)
    end
end

function TextScrollControl:onEnter()
end

function TextScrollControl:updateScroll(dt)
    if not dt then return end
    self.content = self.content + self.step * (dt / (1 / 60))

    local isEnough = false
    
    if (self.step > 0) == (self.content >= self.to) then

        isEnough = true

        self.content = self.to

        if self.scheduleListenerId ~= nil then
            gscheduler.unscheduleGlobal(self.scheduleListenerId)
            self.scheduleListenerId = nil
        end
        -- self:runAction(cc.RemoveSelf:create())
        -- print("######### self.scheduleListenerId ~= nil then")
    end

    local str = self.toInt(self.content)
    
    if self.formatCall then

        self.text:setString(self.formatCall(str))
    else

        -- print(">>>>>>>>>>>>self.text set string",str)
        self.text:setString(str)
    end    

    if self.updateCall then self.updateCall(str) end

    if isEnough then
        if self.callFunc then self.callFunc() end
    end
end

function TextScrollControl:onExit()
    if self.scheduleListenerId ~= nil then

        gscheduler.unscheduleGlobal(self.scheduleListenerId)
        self.scheduleListenerId = nil
    end
end

return TextScrollControl