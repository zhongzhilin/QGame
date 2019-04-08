local BaseWidget = require_ex("widget/BaseWidget")
local DesignerConfig    =  require_ex("data/DesignerConfig")
local guideUIIntro = class("guideUIIntro", function() return gdisplay.newWidget() end )

function guideUIIntro:ctor(data)
	BaseWidget.ctor(self)
	self.m_data = data

	self:renderUI()
end

function guideUIIntro:renderUI()
	self.intro_effect = cc.CSLoader:createNode(self.m_data.rsc..".csb")
    self.intro_action = cc.CSLoader:createTimeline(self.m_data.rsc..".csb")
    self.intro_effect:runAction(self.intro_action)
    self.intro_action:gotoFrameAndPlay(0,true)
    local function onFrameEvent(frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        local _, i_end = string.find(str, "playsound");
        if i_end then
            AudioMgr:playAudio(string.sub(str, i_end+2));
        elseif frame:getEvent() == "over" then
        	if self.intro_effect then
        		self.intro_effect:removeFromParent(true)
        		self.intro_effect = nil
        	end
        end
    end
    self.intro_action:setFrameEventCallFunc(onFrameEvent)
    self:addChild(self.intro_effect)

    self.lbl_title = self.intro_effect:getChildByName("text_title")
    self.lbl_title:setString("")

    self.lbl_text = self.intro_effect:getChildByName("text_guide_cont")
   
    local text = DesignerConfig.getRichTextByKey(self.m_data.text)
    if self.m_data.text then
        BattleMgr:playAudioInText(self.m_data.text)
    end
    if type(text) == "table" then
    	local lbl_text = ItemMgr.getRichTextNode(self.lbl_text, text)
    	self.intro_effect:addChild(lbl_text)
    	local richText = ItemMgr.getRichTextNode(lbl_text, text)
        self.richText = richText
        richText:setOpacity(0)
        richText:runAction(cc.FadeTo:create(1,255))

    else
    	self.lbl_text:setString(text)
    end

    self.intro_effect:setOpacity(0)
    self.intro_effect:runAction(cc.FadeTo:create(0.3,255))
end

function guideUIIntro:removeSelf()
    local fade = cc.FadeTo:create(0.5,0)
    local callfunc = cc.CallFunc:create(function ( ... )
        self:removeFromParent(true)
    end)
    local ac_remove = cc.Sequence:create(fade,callfunc)
    self.intro_effect:runAction(ac_remove)

    local ac_remove2 = clone(ac_remove)
    self.richText:runAction(ac_remove2)
end
return guideUIIntro