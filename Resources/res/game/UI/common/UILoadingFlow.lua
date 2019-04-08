local global = global
local luaCfg = global.luaCfg

local paraMgr = global.paraMgr
local resMgr = global.resMgr
local uiMgr = global.uiMgr

local UIWidget = class("UILoadingFlow", function() return gdisplay.newWidget() end )

function UIWidget:ctor()
    self:configUI()
end

function UIWidget:configUI()
    self:configTipsLabel()
    self:configDecoImage()
end

function UIWidget:updateUI()
    self:updateTipsLabel()
    self:updateBackImage()
end

function UIWidget:onEnter()
    self:updateUI()
end

function UIWidget:onExit()
    self:unscheduleAll()
end

function UIWidget:configTipsLabel()
    local label = uiMgr:createLabel()
    label:setFontSize(35)

    local px, py = gdisplay.cx, 100
    label:setPosition(cc.p(px, py))

    self:addChild(label, 1)
    self.mTipsLabel = label
end

function UIWidget:updateTipsLabel()
    local tips = global.battleData:getCurTips()
    if tips then
        local text = luaCfg:get_local_string(tips)
        self.mTipsLabel:setText(text)
    else
        self.mTipsLabel:setText("")
    end
end

function UIWidget:configDecoImage()
    local data = {
        "loading_deco.png",
        UI_TEX_TYPE_LOCAL,
    }
    self.mLeftDecoImage = uiMgr:createImage(data)
    self.mRightDecoImage = uiMgr:createImage(data)
    
    self.mRightDecoImage:setScaleX(-1)
    
    self:addChild(self.mLeftDecoImage, 0)
    self:addChild(self.mRightDecoImage, 0)
end

function UIWidget:updateBackImage()
    local label = self.mTipsLabel
    local labelWidth = label:getSize().width * label:getScaleX()
    
    local sx, sy = 40, 10
    local py = label:getPositionY()

    local leftImage = self.mLeftDecoImage
    local leftWidth = leftImage:getSize().width * math.abs(leftImage:getScaleX())

    local px = gdisplay.cx - labelWidth * 0.5 - sx -- leftWidth * 0.5
    leftImage:setPosition(cc.p(px, py - sy))
    
    local rightImage = self.mRightDecoImage
    local rightWidth = rightImage:getSize().width * math.abs(rightImage:getScaleX())

    local px = gdisplay.cx + labelWidth * 0.5 + sx --+ rightWidth * 0.5
    rightImage:setPosition(cc.p(px, py - sy))
end

return UIWidget