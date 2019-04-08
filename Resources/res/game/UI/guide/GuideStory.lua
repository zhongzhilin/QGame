local GuideStory = class("GuideStory", function() return gdisplay.newWidget() end )

function GuideStory:ctor(func)
    BaseWidget.ctor(self);
    
    self:renderUI(func);

    self:registerTouchEvent()
end

function GuideStory:renderUI(func)
    self.mask_layer = cc.LayerColor:create(cc.c4b(0,0,0,0))
    self:addChild(self.mask_layer);
    
    self.mask_layer:runAction(cc.Sequence:create(cc.FadeTo:create(1,255),cc.CallFunc:create(function()
        local ttfConfig = {
            fontFilePath = "fonts/YaHeiBold.ttf",
            fontSize = 26,
        }
        local stroy_config = {}
        local str = stroy_config[UserInfo.g_role_model.m_race].story_content;
        local str_real = string.gsub(str,"#br#","\n");
        self.lbl_story = cc.Label:createWithTTF(ttfConfig,str_real,cc.TEXT_ALIGNMENT_CENTER,960)
        self.lbl_story:setPosition(cc.p(480,343));
        self.lbl_story:setTextColor(cc.c4b(255,255,255,255))
        self.lbl_story:enableOutline(cc.c4b(0,0,0,255),2)
        self:addChild(self.lbl_story);

        self:ShowStory(self.lbl_story,0.1,func)
    end)))
end

function GuideStory:registerTouchEvent()
    local function onTouchBegan()
        print("GuideStory onTouchBegan")
        return true
    end
    local function onTouchEnded(touch, event)
        print("GuideStory onTouchEnded")
    end
    self.touch_listener = cc.EventListenerTouchOneByOne:create();
    self.touch_listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN);
    self.touch_listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED);
    local eventDispatcher = self:getEventDispatcher();
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.touch_listener, self)
    self.touch_listener:setSwallowTouches(true)
end

-- textDelayTime为每个字显示的延迟时间
function GuideStory:ShowStory(label, textDelayTime,func)
    local string = label:getString()
    -- 这里考虑了label可能有换行的情况
    local totalLen = string.utf8len(string) + label:getStringNumLines()
    for i = 0, totalLen - 1 do
        local sprite = label:getLetter(i)
        if sprite then
            sprite:setVisible(false)
            local textActionSeq = cc.Sequence:create(cc.DelayTime:create(textDelayTime * i), cc.Show:create())
            sprite:runAction(textActionSeq)
        end
    end
    if func then
        self:runAction(cc.Sequence:create(cc.DelayTime:create(textDelayTime*totalLen + 2),cc.CallFunc:create(function () 
            func()
        end)))
    end
end
return GuideStory;