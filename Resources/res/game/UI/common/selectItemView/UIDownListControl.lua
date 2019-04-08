--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local uiMgr = global.uiMgr
local resMgr = global.resMgr

local UIDownListControl = class("UIDownListControl", function() return gdisplay.newWidget() end)

function UIDownListControl:ctor(dropButton, parent)
    self.dropButton_ = dropButton
    self.listParent_ = parent or self.dropButton_.node_tableView

    self.openList_ = nil
    uiMgr:configUITree(self.dropButton_)
    
    self:InitUI()
    self:setNodeEventEnabled(true)
end

function UIDownListControl:onEnter()
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchHandler), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchHandler), cc.Handler.EVENT_TOUCH_ENDED)

    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self.dropButton_.touch)

    self.dropButton_.contentLayout:setSwallowTouches(true)
    self.dropButton_.itemLayout:setSwallowTouches(false)
    self.dropButton_.contentLayout:setVisible(false)
end

function UIDownListControl:onExit()
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

function UIDownListControl:initOpenList()
    if self.openList_ then
        self.openList_:setVisible(false)
        uiMgr:configUITree(self.openList_)
    end
end

function UIDownListControl:createOpenList()
    if not self.openList_ and self.itemCsb_ then
        local UIDownSelectItemView = require("game.UI.common.selectItemView.UIDownSelectItemView")
        self.tableView = UIDownSelectItemView.new()
            :setSize(self.dropButton_.contentLayout:getContentSize())
            :setCellSize(self.dropButton_.itemLayout:getContentSize())
            :setCellCsbTemplate(self.itemCsb_, self.itemUpdateCall_, self)
            :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
            :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
            :setColumn(1)
        self.listParent_:addChild(self.tableView)

        local contentSize = self.dropButton_.contentLayout:getContentSize()
        self.tableView:setPositionY(-contentSize.height)

        self.openList_ = self.listParent_
        
        self:initOpenList()
        self:refreshItems()
    end
end

function UIDownListControl:InitUI()
    uiMgr:addWidgetTouchHandler(self.dropButton_, function(sender, eventType) self:onDropButtonClickHandler(sender, eventType) end)
    self:initOpenList()
end

function UIDownListControl:setOpenListCsb(csb,itemUpdateCall)
    self.itemCsb_ = csb
    self.itemUpdateCall_ = itemUpdateCall
end 

function UIDownListControl:setSelectedItemChangeHandler(handler)
    self.changeHandler_ = handler
end

--{{text="job1", data={}}, }
function UIDownListControl:setData(data)
    assert((data and #data > 0), "设置可用数据源")
    self.data_ = data
    self:setCurrentData(self.data_ and self.data_[1])
    self:refreshItems()
end

function UIDownListControl:setCurrentData(itemData)
    assert(itemData, "设置可用数据源")
    if itemData.text then
        local label = self.dropButton_.text
        if label then
            label:setString(itemData.text)
        end
    end
    self.selectedData_ = itemData
end

function UIDownListControl:getCurrentData()
    return self.selectedData_
end


function UIDownListControl:setCurrentDataIndex(idx, isrefreshOuterData)
    if not self.data_   or  not idx  or  idx > #self.data_  then
        return 
    end
    -- if true then return end 
    local itemData = self.data_[idx]
    self:setCurrentData(itemData)
    if isrefreshOuterData then
        if self.changeHandler_ then
            self.changeHandler_(itemData)
        end
    end
end

function UIDownListControl:refreshItems()
    if self.openList_ == nil then
        return 
    end

    self.tableView:setData(self.data_)
end

function UIDownListControl:reset0penState()
    self.open_ = false
    self.selectedData_ = {}
end

function UIDownListControl:closeList()
    if not self.open_ then
        return
    end

    local callBackFunc = function()
        self.open_ = false
        self.dropButton_.contentLayout:setVisible(false)
        self.touchEventListener:setSwallowTouches(false)
    end

    self.openList_:stopAllActions()
    self.openList_:setScaleY(1)
    local action = cc.ScaleTo:create(0.15, 1.0, 0)
    action = cc.EaseBackIn:create(action)
    local callback = cc.CallFunc:create(callBackFunc)
    self.openList_:runAction(cc.Sequence:create(action, callback))
end

function UIDownListControl:onDropButtonClickHandler(sender, eventType)
    if self.open_ then
        return
    end
    
    self:createOpenList()

    local visible = self.openList_:isVisible()
    self.openList_:setVisible(true)
    self.dropButton_.contentLayout:setVisible(true)
    self.touchEventListener:setSwallowTouches(true)
    self:refreshItems()

    self.openList_:stopAllActions()

    self.openList_:setScaleY(0)
    local action = cc.ScaleTo:create(0.2, 1.0, 1.0)
    action = cc.EaseBackOut:create(action)
    self.openList_:runAction(action)

    self.open_ = true
end

function UIDownListControl:onItemSelectedHandler(cell)
    self.openList_:setVisible(false)
    if self.selectedData_ ~= cell.data then
        self:setCurrentData(cell.data)
        if self.changeHandler_ then
            self.changeHandler_(cell.data)
        end
    end
    self:closeList()
end

function UIDownListControl:onTouchHandler(touch, event)
    if event:getEventCode() == cc.EventCode.BEGAN then
        return true
    elseif event:getEventCode() == cc.EventCode.ENDED then
        self:closeList()
    end
end

return UIDownListControl

--endregion
