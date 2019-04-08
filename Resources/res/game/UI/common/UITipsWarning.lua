local UITipsWarning = nil
UITipsWarning = class("UITipsWarning",
                        function() return gdisplay.newWidget() end )

local DELAY_TIME = 1
local FADE_OUT_TIME = 0.5


function UITipsWarning:ctor()
    local label = global.uiMgr:createLabel()
    self:addChild(label, 1)    
    self.label = label
    self.label:setCascadeOpacityEnabled(true)
    -- self.label:setColor(gdisplay.COLOR_RED)

    local background = ccui.ImageView:create()    
    -- background:loadTexture("errorcode_bg.png",ccui.TextureResType.plistType)
    -- background:setScale9Enabled(true)
    -- background:setCapInsets(cc.rect(20,10,180,10))
    self:addChild(background)
    self.mBackground = background
end

function UITipsWarning:setText(str)
    if self.icon then
        self.icon:setVisible(false)
    end

    if self.label2 then
        self.label2:setVisible(false)
    end

    local onCallFunc = function()
        self.label:stopAllActions()
        self.mBackground:stopAllActions()

        global.panelMgr:closePanel("UITipsWarning")
    end
    
    self.label:setString(str)
    self.label:setPositionX(0)
    
    self.label:setOpacity(255)
    self.label:stopAllActions()    

    local a1 = cc.DelayTime:create(DELAY_TIME)
    local a2 = cc.FadeOut:create(FADE_OUT_TIME)
    local a3 = cc.CallFunc:create(onCallFunc)
    self.label:runAction(cc.Sequence:create({a1, a2, a3}))


    local size = self.label:getContentSize()
    size.width = size.width + 40
    size.height = size.height + 20    
    
    local background = self.mBackground
    background:setContentSize(size)
    background:setOpacity(255)
    background:stopAllActions()
    
    
    local a1 = cc.DelayTime:create(DELAY_TIME)
    local a2 = cc.FadeOut:create(FADE_OUT_TIME)
    local a3 = cc.CallFunc:create(onCallFunc)
    background:runAction(cc.Sequence:create({a1, a2, a3}))

    self:setScaleY(0)
    self:setVisible(true)
    self:stopAllActions()
    self:runAction(cc.Sequence:create(cc.EaseBackOut:create(
        cc.ScaleTo:create(0.45,1,1)),cc.DelayTime:create(2),
        cc.EaseBackIn:create(cc.ScaleTo:create(0.3,1,0)),cc.Hide:create()))
end

function UITipsWarning:setTextWithIcon(strArr,iconId)
    if strArr and #strArr > 0 then
        self:setText(strArr[1])

        local size = self.label:getContentSize()
        local labelSize = self.label:getContentSize()
        local labelAnchorP = self.label:getAnchorPoint()

        local icon = self.icon
        if not icon then
            icon = cc.Sprite:create(iconId)
            self.label:addChild(icon)
        end
        icon:setVisible(true)
        icon:setAnchorPoint(display.LEFT_CENTER)
        icon:setPositionX(labelSize.width)
        icon:setPositionY(labelSize.height*0.5)

        self.icon = icon

        local iconSize = icon:getContentSize()
        local iconX = icon:getPositionX()
        local iconAnchorP = icon:getAnchorPoint()
        local label2 = self.label2
        if not label2 then
            label2 = global.uiMgr:createLabel()
            self.label:addChild(label2)
        end
        label2:setVisible(true)
        label2:setAnchorPoint(labelAnchorP)
        label2:setString(strArr[2])
        local label2Size = label2:getContentSize()
        size.width = size.width + iconSize.width + label2Size.width
        label2:setPositionX(labelSize.width+iconSize.width+label2Size.width*0.5)
        label2:setPositionY(labelSize.height*0.5)


        self.label:setPositionX(-(size.width*0.5-labelSize.width*0.5))

        self.label2 = label2

        size.width = size.width + 40
        size.height = size.height + 20    
        local background = self.mBackground
        background:setContentSize(size)
    end
end

return UITipsWarning

