local global = global

local panelMgr = global.panelMgr
local resMgr = global.resMgr
local uiMgr = global.uiMgr

local WIDGET_NAME = "ServerNotifyPanel"

local CONTENT_WIDTH = 680
local CONTENT_HEIGHT = 315

local UIWidget = class(WIDGET_NAME, function() return gdisplay.newWidget() end )

function UIWidget:ctor()
    self.mRootWidget = resMgr:createWidget("LoginIn_tipsUI")
    self.mRootWidget:setSize(cc.size(gdisplay.width, gdisplay.height))    
    self:addChild(self.mRootWidget)

    self:configUI()
end

function UIWidget:configUI()
    self:configTitleLabel()
    self:configContentLabel()
    self:configConfirmButton()
    self:configScrollView()
end

function UIWidget:updateUI()
    self:updateTitleLabel()
    self:updateContentLabel()
    self:updateScrollView()
end

function UIWidget:setData(data, callBack)
    self:bindData(data, callBack)
    self:updateUI()
end

function UIWidget:bindData(data, callBack)
    self.mData = data
    self.mCallBack = callBack
end

function UIWidget:onEnter()
    self.mRootWidget:setVisible(true)
    self.mRootWidget:setTouchEnabled(true)
end

function UIWidget:onExit()
    self.mRootWidget:setVisible(false)
    self.mRootWidget:setTouchEnabled(false)
end

function UIWidget:configTitleLabel()
    self.mTitleLabel = uiMgr:configLabel(self.mRootWidget, "Label_Title")
end

function UIWidget:updateTitleLabel()
    local text = self.mData.title or ""
    self.mTitleLabel:setText(text)
end

function UIWidget:configContentLabel()
    self.mContentLabel = uiMgr:configLabel(self.mRootWidget, "Label_Content")
    self.mContentLabel:ignoreContentAdaptWithSize(false)
end

function UIWidget:updateContentLabel()
    local label = self.mContentLabel
    label:setSize(cc.size(CONTENT_WIDTH, 0))

    local text = self.mData.content or ""
    label:setText(text)

    local size = label:getContentSize()
    label:setSize(cc.size(size.width, size.height))

    local height = size.height
    if height > CONTENT_HEIGHT then 
        local py = height
        label:setPositionY(py)
    else
        local py = CONTENT_HEIGHT
        label:setPositionY(py)
    end
end

function UIWidget:configConfirmButton()
    local onTouched = function()
        panelMgr:closePanel(WIDGET_NAME)

        local callBack = self.mCallBack
        if callBack then
            callBack()
        end
    end
    self.mConfirmButton = uiMgr:configLabelButton(self.mRootWidget, "Button_Confirm", onTouched)
end

function UIWidget:configScrollView()
    local scrollView = uiMgr:configScrollView(self.mRootWidget, "ScrollView_Content")
    self.mScrollView = scrollView

    local UIScrollBar = require("game.ui.common.UIScrollBar")
    local layout = uiMgr:configLayout(self.mRootWidget, "Layout_ScrollBar")
    local widget = UIScrollBar.new(layout)
    widget:setScrollView(scrollView)
    self:addChild(widget)
    self.mScrollBarWidget = widget
end

function UIWidget:updateScrollView()
    local scrollView = self.mScrollView
    local innerContainerSize = scrollView:getInnerContainerSize()

    local label = self.mContentLabel
    local labelSize = label:getSize()
    local width = innerContainerSize.width
    local height = labelSize.height

    scrollView:setInnerContainerSize(cc.size(width, height))
    self.mScrollBarWidget:updateUI()
end

return UIWidget