--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local uiMgr = global.uiMgr
local resMgr = global.resMgr

local ComboBox = class("ComboBox", function() return gdisplay.newWidget() end)

function ComboBox:ctor(dropButton, openList, parent)
    self.dropButton_ = dropButton
    self.listParent_ = parent or self.dropButton_

    self.openList_ = openList
    uiMgr:configUITree(self.dropButton_)
    
    self:InitUI()
    self:setNodeEventEnabled(true)
end

function ComboBox:onEnter()
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchHandler), cc.Handler.EVENT_TOUCH_BEGAN)

    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(self.touchEventListener, -1)
end

function ComboBox:onExit()
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

function ComboBox:initOpenList()
    if self.openList_ then
        self.openList_:setVisible(false)
        uiMgr:configUITree(self.openList_)
    end
end

function ComboBox:createOpenList()
    if not self.openList_ and self.openListCsb then
        self.openList_ = resMgr:CreateWidget(self.openListCsb)
        self.listParent_:addChild(self.openList_)
        local buttonSize = self.listParent_:getContentSize()
        local pos = cc.p(buttonSize.width*0.5, 0)
        self.openList_:setPosition(pos)
        
        self:initOpenList()
        self:refreshItems()
    end
end

function ComboBox:InitUI()
    uiMgr:addWidgetTouchHandler(self.dropButton_, function(sender, eventType) self:onDropButtonClickHandler(sender, eventType) end)
    self:initOpenList()
end

function ComboBox:setOpenListCsb(csb)
    self.openListCsb = csb
end 

function ComboBox:setSelectedItemChangeHandler(handler)
    self.changeHandler_ = handler
end

--{{label="job1", data={}}, }
function ComboBox:setData(data)
    assert((data and #data > 0), "设置可用数据源")
    self.data_ = data
    self:setCurrentData(self.data_ and self.data_[1])
    self:refreshItems()
end

function ComboBox:setCurrentData(itemData)
    assert(itemData, "设置可用数据源")
    if itemData.label then
        local label = self.dropButton_.label or self.dropButton_.label_mlan
        if label then
            label:setString(itemData.label)
        end
    end
    self.selectedData_ = itemData
end

function ComboBox:setCurrentDataIndex(idx, isrefreshOuterData)
    if not self.data_ then
        return 
    end

    local itemData = self.data_[idx]
    self:setCurrentData(itemData)
    if isrefreshOuterData then
        if self.changeHandler_ then
            self.changeHandler_(itemData.data)
        end
    end
end

function ComboBox:getButtonItemByIdx(idx)
    assert(self.openList_.container_node["button"..idx.."_export"], string.format("openlist 按钮明明不符合规范 button%d", idx))
    return self.openList_.container_node["button"..idx.."_export"]
end    

function ComboBox:refreshItems()
    if self.openList_ == nil then
        return 
    end

    for i, itemData in ipairs(self.data_ or {}) do
        local button = self:getButtonItemByIdx(i)

        local label = button.label_export or button.label_mlan_export
        assert(label, "编辑ui的哥哥 列表里的文本命名错误")
        if itemData.label then
            label:setString(itemData.label)
        else
            itemData.label = label:getString()
        end
        button.data = itemData
        uiMgr:addWidgetTouchHandler(button, function(sender, eventType) self:onItemSelectedHandler(sender, eventType) end)
    end
end

function ComboBox:reset0penState()
    self.open_ = false
    self.selectedData_ = {}
end

function ComboBox:closeList()
    if not self.open_ then
        return
    end

    local callBackFunc = function()
        self.open_ = false
    end

    self.openList_.container_node:stopAllActions()
    self.openList_.container_node:setScaleY(1)
    local action = cc.ScaleTo:create(0.15, 1.0, 0)
    action = cc.EaseBackIn:create(action)
    local callback = cc.CallFunc:create(callBackFunc)
    self.openList_.container_node:runAction(cc.Sequence:create(action, callback))
end

function ComboBox:onDropButtonClickHandler(sender, eventType)
    if self.open_ then
        return
    end
    
    self:createOpenList()

    local visible = self.openList_:isVisible()
    self.openList_:setVisible(true)

    self.openList_.container_node:stopAllActions()

    self.openList_.container_node:setScaleY(0)
    local action = cc.ScaleTo:create(0.2, 1.0, 1.0)
    action = cc.EaseBackOut:create(action)
    self.openList_.container_node:runAction(action)

    self.open_ = true
end

function ComboBox:onItemSelectedHandler(item)
    self.openList_:setVisible(false)
    if self.selectedData_ ~= item.data then
        self:setCurrentData(item.data)
        if self.changeHandler_ then
            self.changeHandler_(item.data.data)
        end
    end
end

function ComboBox:onTouchHandler(touch, event)
    if event:getEventCode() == cc.EventCode.BEGAN then
        self:closeList()
    end
end

return ComboBox

--endregion
