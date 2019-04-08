--region ScrollLoadView.lua
--Author : Song
--Date   : 2016/6/7
--此文件由[BabeLua]插件自动生成

--拖动选择列表

require("game.UI.common.scrollSelectView.ScrollSelectItemBase")
local UIScrollView = require("game.UI.common.UIScrollView")
local ScrollListItemPool = require("game.UI.common.scrollSelectView.ScrollListItemPool")
local ScrollLoadView = class("ScrollLoadView", UIScrollView)

--基本坐标工具方法
local SIZE = function(node) return node:getContentSize() end
local W = function(node) return node:getContentSize().width * node:getScale() end
local H = function(node) return node:getContentSize().height * node:getScale() end
local S_SIZE = function(node , w , h) return node:setContentSize(cc.size(w , h)) end
local S_XY = function(node , x , y) node:setPosition(x,y) end
local AX = function(node) return node:getAnchorPoint().x end
local AY = function(node) return node:getAnchorPoint().y end
local MAX_ITEM_COUNT = 30

function ScrollLoadView:ctor(params)
    ScrollLoadView.super.ctor(self, params)
    self:setNodeEventEnabled(true)
    self:setBounceable(true)
    self:setTouchType(false)
    self.bounceEaseing = "sineOut"
    --cc.VerticalFillOrder
    self.fillOrder_ = params.fillOrder or cc.VerticalFillOrder.TOP_DOWN
    self:init()
    self.items_ = {}
    self.itemsLayoutInfo_ = {}--pos 
    self.itemPool_ = ScrollListItemPool.new(params.maxCount or  MAX_ITEM_COUNT)
end

function ScrollLoadView:onExit()
    self:stopRelock()
    self:clear()
end

function ScrollLoadView:init()
    --创建一个容器node
    local innerContainer = display.newNode()
    --初始容器大小为视图大小
    S_SIZE(innerContainer , self:getViewRect().width , self:getViewRect().height)
    self:addScrollNode(innerContainer)
    self.innerContainer = innerContainer
    S_XY(innerContainer , self.viewRect_.x , self.viewRect_.y)
    
    self.lastMaxScale_ = 0;

    self.normalScale = 0.8
    self.scaleRange = 0.3

    self:onScroll(handler(self, self.onScrollHandler))
end

function ScrollLoadView.extendParams(param1,param2)
    if not param2 then
        return param1
    end
    for k , v in pairs(param2) do
        param1[k] = param2[k]
    end
    return param1
end

--[[
    创建一个itme 放入缓存池， 获取item容器信息
]]
function ScrollLoadView:initItemInfo()
    if self.itemAnchorPoint_ then return end

    local item = self.delegate_.getNewItem()
    self.itemPool_:recycleObject(item)

    item:setScale(1)
    local normalSize = SIZE(item)
    self.normalSize_ = normalSize

    self.itemAnchorPoint_ = item:getAnchorPoint()

    local params = ScrollLoadView.extendParams({
        --宽间距
        widthGap = 0,
        --高间距
        heightGap = 6,
    }, params)
    self.params_ = params
end

function ScrollLoadView:setSelectRect(rect)
    self.selectRect = rect

--    local shape3 = display.newRect(cc.rect(0, self.selectRect.y, self.selectRect.width, self.selectRect.height),
--         {fillColor = cc.c4f(1,0,0,0.5), borderColor = cc.c4f(0,1,0,0.5), borderWidth = 1})
--    self:addChild(shape3)
end

function ScrollLoadView:setSelectedHandler(handler)
    self.selectHandler_ = handler
end

function ScrollLoadView:setDelegate(delegate)
    self.delegate_ = delegate
end

function ScrollLoadView:removeAllItem()
    self.innerContainer:removeAllChildren()
    self.items_ = {}
end

function ScrollLoadView:onScrollHandler(event)
    self:stopRelock()
    self:refreshItems()

    if self.scrollHandler_ ~=nil then
        self.scrollHandler_(event)
    end
--    log("scroll curr pos<%f, %f>", self:getContentOffset().x, self:getContentOffset().y)
end

function ScrollLoadView:setScrollHandler(handler)
    self.scrollHandler_ = handler
end

function ScrollLoadView:scheduleRelock(dt)
    self:scrollBy(0, self.finalDist_ * (dt / 0.2))
    self:refreshItems()

--    log("lockItem<%d>, scale<%f>",self.lockItem_.index, self.lockItem_:getScale())
    if math.abs(self.lockItem_:getScale() - (self.normalScale + self.scaleRange)) <= 0.1 then 
        self:stopRelock()
    end
end

function ScrollLoadView:itemAtIndex(idx)
    return self.items_[idx]
end

function ScrollLoadView:removeItemFromList(idx)
    if self.items_[idx] then
       self.items_[idx]:removeFromParent()
       self.items_[idx] = nil
    end
end

function ScrollLoadView:addItemToList(idx, item)
--    assert(self.items_[idx])
    if self.items_[idx] then
        print("111")
    end
    self.items_[idx] = item
    self.innerContainer:addChild(item)
end

function ScrollLoadView:getCacheIgtem()
    return self.itemPool_:getObject()
end

function ScrollLoadView:isOutOfSight(idx)
    local pos = self:getItemPosition(idx)
    local scale = self:getItemScale(idx)
    local posY = self.innerContainer:getPositionY() + pos.y
    local height = self:getItemHeight(idx)

    local itemRect = cc.rect(0, posY-height*0.5, self.normalSize_.width, height)
    return not cc.rectIntersectsRect(self:getViewRect(), itemRect)
end

function ScrollLoadView:positionOfIndex(idx)
    local itemCount = self.delegate_.numberOfItem()

    local x = 0.0
    local y = 0.0
    local prevY = 0.0
    for i = itemCount ,1 , -1 do
        local scale = self.normalScale
        if index == i then 
            scale = self.normalScale + self.scaleRange
        end

        local h = self.normalSize_.height *scale
        x = self.viewRect_.width * self.itemAnchorPoint_.x
        y = prevY
        y = y + h * self.itemAnchorPoint_.y
        
        if idx == i then 
            return y
        end

        prevY = prevY + (self.params_.heightGap + h)
    end

    return 0
end

function ScrollLoadView:relockItem()
    self:stopRelock()
    
    local nearetItemIdx = nil 
    local minDist = 100000
    local itemCount = self.delegate_.numberOfItem()

    for i=1, itemCount, 1 do
        local itemPos = self:getItemPosition(i)
        local dist = math.abs(self:caclDist(itemPos.y))
        if dist < minDist then 
            minDist = dist
            nearetItemIdx = i
        end
    end
    
    if nearetItemIdx then 
        self:scrollToItem(nearetItemIdx, true)
    end
end

function ScrollLoadView:scrollToItemByIndex(idx)
   self:scrollToItem(idx) 
end

function ScrollLoadView:scrollToItem(idx, ease)
    if idx then 
        local y = self:positionOfIndex(idx)

        local halfH = self.selectRect.height*0.5
        local centerY = self.selectRect.y + halfH
        local targetContentY = centerY - y

        local function relockCompleted(args)
            local item = self:itemAtIndex(idx)
            if self.delegate_ and self.delegate_.onItemSelected then 
                self.delegate_.onItemSelected(self, item)
                self:selecteItem(item)
            end
        end

        local function valueChange(y)
            self:scrollTo(self.position_.x, y)
            self:refreshItems()
--            self:selecteItem(item)
        end

        if ease then
--            log("self.position_.y:"..self.position_.y)
            self.scrollNode:stopAllActions()
            self:stopAllActions()
            local distAbs = math.abs(self.position_.y -  targetContentY)
            local time = 0.3
            if distAbs < 20 then 
                time = 0.1
            end

            local valueAction = cc.ActionFloat:create(time, self.position_.y, targetContentY, valueChange)
            local ease = cc.EaseOut:create(valueAction, 1.0)
            local callBack_ = cc.CallFunc:create(relockCompleted)
            local seqAction = cc.Sequence:create(ease, callBack_)
            self:runAction(seqAction)
        else
--        log("scroll to item<%d>, taget container pos<%f, %f> itemPosY<%f>", item.index, targetPos.x, targetPos.y, y)
            self:scrollTo(self.position_.x, targetContentY)
            self:refreshItems()
            local item = self:itemAtIndex(idx)
            self:selecteItem(item)
        end
    end
end

function ScrollLoadView:selecteItem(item)
    if self.selectHandler_ then 
        self.selectHandler_(item)
    end
end

function ScrollLoadView:stopRelock()
    if self.relockHandle_ then 
        scheduler.unscheduleGlobal(self.relockHandle_)
        self.relockHandle_ = nil
    end
end

function ScrollLoadView:getItemLayoutInfo(idx)
    local itemLayoutInfo = self.itemsLayoutInfo_[idx]
    if itemLayoutInfo == nil then
        self.itemsLayoutInfo_[idx] = {}
    end
    return self.itemsLayoutInfo_[idx]
end

function ScrollLoadView:setItemPosition(idx, x, y)
    local itemLayoutInfo = self:getItemLayoutInfo(idx)
    itemLayoutInfo.pos = cc.p(x, y)
end

function ScrollLoadView:getItemPosition(idx)
    local itemLayoutInfo = self:getItemLayoutInfo(idx)
    return itemLayoutInfo and itemLayoutInfo.pos
end

function ScrollLoadView:setItemScale(idx, scale)
    local itemLayoutInfo = self:getItemLayoutInfo(idx)
    itemLayoutInfo.scale = scale
end

function ScrollLoadView:getItemScale(idx)
    local itemLayoutInfo = self:getItemLayoutInfo(idx)
    return itemLayoutInfo and itemLayoutInfo.scale or 1
end

function ScrollLoadView:getItemHeight(idx)
    local itemScale = self:getItemScale(idx)
    return self.normalSize_.height * itemScale
end

function ScrollLoadView:refrehItemLayout(idx)
    local scale = self:getItemScale(idx)
    local pos = self:getItemPosition(idx)

    local item = self:itemAtIndex(idx)
    if item then
        item:setScale(scale)
        item:setPosition(pos)
    end 
end

function ScrollLoadView:refreshItems()
--    local items = self.items_

    local x = 0.0
    local y = 0.0
    local prevY = 0.0
    local total = self.delegate_.numberOfItem()
    for i = total ,1 , -1 do
        x = self.viewRect_.width * self.itemAnchorPoint_.x
        y = prevY
        y = y + self:getItemHeight(i) * self.itemAnchorPoint_.y
        self:setItemPosition(i, x, y)

        local scale = 1
        self:setItemScale(i, scale)

        local state = (scale == self.normalScale) and ScrollSelectItemState.NORMAL or ScrollSelectItemState.SELECTED

        y = prevY
        local hN = self:getItemHeight(i)
        y = y + hN * self.itemAnchorPoint_.y
        self:setItemPosition(i, x, y)
        
        prevY = prevY + (self.params_.heightGap + self:getItemHeight(i))

        if self:isOutOfSight(i) then
--            printInfo("item<%d> is out of Sight", i)
            if self:itemAtIndex(i) then
               self.itemPool_:recycleObject(self:itemAtIndex(i))
               self:removeItemFromList(i)
            end
        else
--            printInfo("item<%d> is in sight", i)
            local item = self:itemAtIndex(i)
            if not item then
                item = self:getCacheIgtem() or self.delegate_.getNewItem()
                self:addItemToList(i,item)
                self.delegate_.refreshItem(item, i)
            end
            item.index = i
            self:refrehItemLayout(i)
            -- item:setState(state)
        end
    end
    S_SIZE(self.innerContainer , self:getViewRect().width ,-prevY)
end

function ScrollLoadView:elasticScroll()
	self:relockItem()
end

function ScrollLoadView:caclDist(y)
    local posY = self.innerContainer:getPositionY() + y
    local halfH = self.selectRect.height*0.5
    local centerY = self.selectRect.y+halfH
    local dist = centerY - posY
    return dist
end

function ScrollLoadView:clearItems()
    for key , item in pairs(self.items_ or {}) do
        self:removeItemFromList(key)
    end
    self.items_ = {}
    self.itemsLayoutInfo_ = {}
end

function ScrollLoadView:reloadData()
    self:clearItems()
    self:initItemInfo()

    if self.delegate_.numberOfItem() > 0 then 
        local firstIdx = self.fillOrder_ == cc.VerticalFillOrder.TOP_DOWN  and 1 or #self.items_
        self:scrollToItem(firstIdx)
    end
end

function ScrollLoadView:refreshAllData()
    for i, item in ipairs(self.items_) do
        self.delegate_.refreshItem(item, item.index)
    end
end

function ScrollLoadView:getAllItems()
    return self.items_ or {}
end

function ScrollLoadView:clear()
    if self.itemPool_ then 
        self.itemPool_:clearPool()
    end
end

return ScrollLoadView
--endregion
