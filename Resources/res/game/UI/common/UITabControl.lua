--region TabControl.lua
--Author : Song
--Date   : 2016/4/14

--[[
    切换按钮组件 
--]]
local TabControl = class("TabControl")

--[[
    containerNode 按钮父容器  须指定容器中的按钮逻辑标签为从1开始的顺序
--]]
function TabControl:ctor(containerNode, changeHandler, defaultIdx , normalTextColor , pressedTextColor)
    self.buttons_ = {}

    local children = containerNode:getChildren()
    local childCount = containerNode:getChildrenCount()
    assert(childCount > 1, "error, tabControl needs two buttons at least")

    if "table" == type(children) then
        for i = 1, childCount, 1 do        
            local childNode = children[i]
            
            if childNode.getDescription and childNode:getDescription() == "Button" then
                childNode:setZoomScale(0)
                childNode.index = childNode:getTag()
                table.insert(self.buttons_, childNode)                
                global.uiMgr:addWidgetTouchHandler(childNode, handler(self, self.onButtonClick), true)
                -- global.uiMgr:addWidgetTouchHandler(childNode, handler(self, self.onButtonTouch), true)
            end
        end
    end

    self.normalTextColor = normalTextColor
    self.pressedTextColor = pressedTextColor
    self:setSelectedChangeHandler(changeHandler)
    self:setSelectedIdx(defaultIdx or 1)
    self:refreshState()
end

function TabControl:setClickEnabled(value)
    self.onlyDisableStyle = value
    self:refreshState()
end

function TabControl:setEnabledIndex(index)
    self.isEnableSelected = index
end

function TabControl:setSelectedChangeHandlerWithEvent(changehandler)
    self.selectedChangeHandlerWithEvent_ = changehandler
end

function TabControl:setSelectedChangeHandler(changehandler)
    self.selectedChangeHandler_ = changehandler
end

function TabControl:refreshState()
    for i, button in ipairs(self.buttons_) do
        local selected = button.index ~= self.selectedIdx_
        local childs = button:getChildren()
        local text_name = button.text_mlan
        for i,v in pairs(childs) do
            if string.find(v:getName(),'text_mlan') then
                text_name = v
            end
        end
        if selected then
            if self.normalTextColor then text_name:setTextColor(self.normalTextColor) end
        else
            if self.pressedTextColor then text_name:setTextColor(self.pressedTextColor) end
        end

        if self.onlyDisableStyle then
            button:getRendererNormal():setVisible(false)
            button:getRendererClicked():setVisible(false)
            button:getRendererDisabled():setVisible(true)
        else
            button:setEnabled(selected)            
        end
        self:itemStateChange(button, not selected)
    end
end

function TabControl:refreshStateWithEvent(eventType)
    for i, button in ipairs(self.buttons_) do
        local selected = button.index ~= self.selectedIdx_
        if self.selectedChangeHandlerWithEvent_ then
            self.selectedChangeHandlerWithEvent_(button, not selected, eventType)
        end
    end
end

function TabControl:setItemChangeHandler(changeHandler)
    self.itemChangeHandler = changeHandler
end

function TabControl:itemStateChange(item, selected)
    if self.itemChangeHandler then
        self.itemChangeHandler(item, selected)
    end
end

function TabControl:setSelectedIdx(selectedIdx)
    self.selectedIdx_ = selectedIdx 
    self:refreshState()
end

function TabControl:getSelectedIdx()
    return self.selectedIdx_ 
end

local lastSelectedIdx = nil
function TabControl:onButtonClick(target, eventType)


    if self.isEnableSelected ~= nil and self.isEnableSelected == target.index then 
        if eventType == ccui.TouchEventType.began then 
            self.selectedChangeHandler_(target.index)
        end
        return
    end
    if eventType == ccui.TouchEventType.began then 
        lastSelectedIdx = self.selectedIdx_
        self.selectedIdx_ = target.index
    elseif eventType == ccui.TouchEventType.moved then 
    elseif eventType == ccui.TouchEventType.ended then 
        self:refreshState()
        local pos = {x = 0, y = 0}
        for i, button in ipairs(self.buttons_) do
           if button.index == self.selectedIdx_ then
               pos.x,pos.y = button:getPosition()
               break
           end
        end

        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_flip")
        if self.selectedChangeHandler_ then 
            self.selectedChangeHandler_(target.index, pos)
        end
    elseif eventType == ccui.TouchEventType.canceled then 
        self.selectedIdx_ = lastSelectedIdx
    end
    if self.selectedChangeHandlerWithEvent_ then
        self:refreshStateWithEvent(eventType)
    end

end

-- function TabControl:setEnabledSelect( ... )
--     -- body
-- end

return TabControl

--endregion
