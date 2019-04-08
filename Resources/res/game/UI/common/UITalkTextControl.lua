local UITalkTextControl = class("UITalkTextControl", function() return gdisplay.newWidget() end )
local uiMgr = global.uiMgr

local TALK_SPEED = 1

function UITalkTextControl.startScroll(text,content,needTail , call ,time )

    if text._talkTextControl then
        text._talkTextControl:removeFromParent()
    end       

    local talkTextControl = UITalkTextControl.new(text,content  , needTail  , call, time )
    text:addChild(talkTextControl)
    text._talkTextControl = talkTextControl    
end

function UITalkTextControl.endTalk(text)
    
    if text._talkTextControl then
        
        print("text._talkTextControl ")

        text:setString(text._talkTextControl.content)

        text._talkTextControl:removeFromParent()
        text._talkTextControl = nil        

        return true
    else

        print("text._talkTextControl return false")

        return false
    end
end

function UITalkTextControl:ctor(text,content,needTail , call , time )

    self.text = text
    self.content = content
    self.contentArr = string.utf8ToList(content)
    self.needTail = needTail
    self.curContentArr = {}

    self.text:setString("")

    self.call = call 

    self.time = time or TALK_SPEED

    if not self.scheduleListenerId then
        self.scheduleListenerId = gscheduler.scheduleGlobal(function(dt)
            
            if tolua.isnull(self) then
                print("warin there are a in loop schedule need to clean")
                return
            end

            self:updateTalk(dt)
        end,  self.time / 60)
    end

end

function UITalkTextControl:updateTalk(dt)
    
    if #self.contentArr == 0 then

        if self.call then 
            self.call()
        end 
        gscheduler.unscheduleGlobal(self.scheduleListenerId)
        self.text._talkTextControl = nil
        self:removeFromParent()        
        self.scheduleListenerId = nil

        return
    end

    local first = self.contentArr[1]
    table.remove(self.contentArr,1)

    table.insert(self.curContentArr,first)
    local resStr = ""
    for _,v in ipairs(self.curContentArr) do

        resStr = resStr .. v
    end

    self.text:setString(resStr)

end

function UITalkTextControl:onExit()
    if self.scheduleListenerId ~= nil then

        gscheduler.unscheduleGlobal(self.scheduleListenerId)
        self.scheduleListenerId = nil
    end
end

return UITalkTextControl