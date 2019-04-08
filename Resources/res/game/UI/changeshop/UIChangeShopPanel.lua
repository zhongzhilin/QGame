--region UIChangeShopPanel.lua
--Author : yyt
--Date   : 2017/11/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIAdSlideNode = require("game.UI.advertisementItem.UIAdSlideNode")
--REQUIRE_CLASS_END

local UIChangeShopPanel  = class("UIChangeShopPanel", function() return gdisplay.newWidget() end )
local UIChangeShopCell = require("game.UI.changeshop.UIChangeShopCell")
local UITableView = require("game.UI.common.UITableView")
local CountSliderControl = require("game.UI.common.UICountSliderControl")

function UIChangeShopPanel:ctor()
    self:CreateUI()
end

function UIChangeShopPanel:CreateUI()
    local root = resMgr:createWidget("changshop/changshop_bg")
    self:initUI(root)
end

function UIChangeShopPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "changshop/changshop_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.titleNode = self.root.titleNode_export
    self.titleSelect = self.root.titleSelect_export
    self.topNode = self.root.topNode_export
    self.botNode = self.root.botNode_export
    self.tbSize = self.root.tbSize_export
    self.cellSize = self.root.cellSize_export
    self.tbNode = self.root.tbNode_export
    self.confirmText = self.root.confirmText_export
    self.Button_1 = self.root.Button_1_export
    self.Node1 = self.root.Button_1_export.Node1_export
    self.name1 = self.root.Button_1_export.Node1_export.name1_export
    self.quit1 = self.root.Button_1_export.Node1_export.quit1_export
    self.addIcon1 = self.root.Button_1_export.Node1_export.iconParent1.addIcon1_export
    self.icon1 = self.root.Button_1_export.Node1_export.icon1_export
    self.countBg1 = self.root.Button_1_export.Node1_export.countBg1_export
    self.count1 = self.root.Button_1_export.Node1_export.count1_export
    self.Button_2 = self.root.Button_2_export
    self.Node2 = self.root.Button_2_export.Node2_export
    self.name2 = self.root.Button_2_export.Node2_export.name2_export
    self.quit2 = self.root.Button_2_export.Node2_export.quit2_export
    self.addIcon2 = self.root.Button_2_export.Node2_export.iconParent2.addIcon2_export
    self.icon2 = self.root.Button_2_export.Node2_export.icon2_export
    self.countBg2 = self.root.Button_2_export.Node2_export.countBg2_export
    self.count2 = self.root.Button_2_export.Node2_export.count2_export
    self.slider = self.root.slider_export
    self.lineText = self.root.slider_export.lineText_export
    self.grayBg = self.root.changeBtn.grayBg_export
    self.FileNode_1 = UIAdSlideNode.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)

    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:shopHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.addIcon1, function(sender, eventType) self:shopHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_2, function(sender, eventType) self:changeHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.addIcon2, function(sender, eventType) self:changeHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.changeBtn, function(sender, eventType) self:confirmHandler(sender, eventType) end)
--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode, self.botNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIChangeShopCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(6)
    self.tbNode:addChild(self.tableView)
  
    self.sliderControl = CountSliderControl.new(self.slider, handler(self,  self.changCountCallBack), nil, true, true) 
    global.chanPanel = self
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIChangeShopPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIChangeShopPanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIChangeShopPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIChangeShopPanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIChangeShopPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIChangeShopPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIChangeShopPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()  
        if self.refersh then
            self:refersh()   
        end
    end) 

    self:addEventListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function ()  
        if self.refersh then
            self:refersh()   
        end   
    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_ADUPDATE, function ()
        if self.refersh then
            self:refersh()   
        end 
    end)

    self.isPageMove = false
    self:registerMove()
    self:setData()
    self:defaultSelect()

    self.FileNode_1:setData(10)
end

-- 使用道具默认选中第一个
function UIChangeShopPanel:defaultSelect()

    local canShop = self:getCanShop()
    if table.nums(canShop) > 0 then

        self:shopHandler()
        local defaultItemId = canShop[1].itemId
        local itemData = luaCfg:get_item_by(defaultItemId) or luaCfg:get_equipment_by(defaultItemId)
        self:leftShopItem(itemData, defaultItemId, global.normalItemData:getItemById(defaultItemId).count)
    end
end

function UIChangeShopPanel:setData()
    
    self.tableView:setData({})
    self.leftItem  = nil
    self.rightItem = nil
    self.isEnoughShop = false
    
    for i=1,2 do
        self["icon"..i]:setVisible(false)
        self["count"..i]:setVisible(false)
        self["name"..i]:setVisible(false)
        self["countBg"..i]:setVisible(false)
        self["addIcon"..i]:setVisible(true)
        global.panelMgr:setTextureForAsync(self["quit"..i],"icon/item/item_bg_01.png",true)
    end

    self:checkCanChange()
    self.slider:setVisible(false)
    self.confirmText:setVisible(false)
    self.titleSelect:setString(luaCfg:get_local_string(10924))
end

function UIChangeShopPanel:setSliderVal(min, max)

    max = max or 0
    min = min or 0
    if min > max then max = min  end
    self.sliderControl:setMaxCount(max)
    self.sliderControl:setMinCount(min)
    self.sliderControl:changeCount(min)
end

-- 可以出售的道具
function UIChangeShopPanel:getCanShop(itemId)

    if self.leftItem then
        itemId = self.leftItem
    end

    if self.rightItem then 
        return self:getCanShopById(self.rightItem)
    end

    local shopData = {}
    local changItem = luaCfg:get_change_item_by(12301)
    for k,v in ipairs(changItem.showGroup) do
        local temp = {}
        temp.itemId = v
        temp.isSelect = false
        if itemId and v == itemId then
            temp.isSelect = true
        end
        table.insert(shopData, temp)
    end

    shopData = self:sortData(shopData)

    return shopData 
end

-- 可以兑换的道具
function UIChangeShopPanel:getCanChange(itemId)

    if self.rightItem then
        itemId = self.rightItem
    end

    if self.leftItem then 
        return self:sortData(self:getCanChangeById(self.leftItem))
    end

    local changeData = {}
    local changItem = luaCfg:change_item()
    for k,v in pairs(changItem) do
        local temp = {}
        temp.itemId = v.itemId
        temp.isSelect = false
        if itemId and v.itemId == itemId then
            temp.isSelect = true
        end
        table.insert(changeData, temp)
    end
    return changeData
end

function UIChangeShopPanel:isCanShop(itemId)

    local changItem = luaCfg:get_change_item_by(12301)
    for k,v in pairs(changItem.showGroup) do
        if v == itemId then
            return true
        end
    end
    return false
end

function UIChangeShopPanel:getCanShopById(itemId)
    
    local changItem = luaCfg:change_item()
    for _,v in pairs(changItem) do
        if v.itemId == itemId then
            local data = {}
            for i,vv in ipairs(v.itemGroup) do
                local temp = {}
                temp.itemId = vv
                temp.isSelect = false
                if self.leftItem and self.leftItem == vv then
                    temp.isSelect = true
                end
                table.insert(data, temp)
            end
            return data
        end
    end
end

function UIChangeShopPanel:getCanChangeById(itemId)
    local data = {}
    local changItem = luaCfg:change_item()
    for _,v in pairs(changItem) do
        for i,vv in ipairs(v.itemGroup) do
            if itemId == vv then
                local temp = {}
                temp.itemId = v.itemId
                temp.isSelect = false
                if self.rightItem and self.rightItem == v.itemId then
                    temp.isSelect = true
                end
                table.insert(data, temp)
                break
            end
        end
    end
    return data
end

-- 获取兑换数量比例
function UIChangeShopPanel:getChangeSingleNum(shopId, changeId)

    local changItem = luaCfg:change_item()
    for _,v in pairs(changItem) do
        if v.itemId == changeId then
            for i=1,v.maxNum do
                local cur = v["change"..i.."Id"]
                if cur == shopId then
                    return v["change"..i.."Num"], v["item"..i.."num"]
                end
            end
        end
    end
    return 0, 0
end

function UIChangeShopPanel:changCountCallBack()

    if not self.isEnoughShop then return end
    local curCount = self.sliderControl:getContentCount()
    local cur = self.shopCount > self.changeCount and (curCount/self.shopCount) or (curCount*self.changeCount)
    self.count2:setString(cur)
    self.count1:setString(curCount)
    self.lineText:setPositionX(self.sliderControl.inputText:getPositionX()+8)
    self.slider.max:setPositionX(self.lineText:getPositionX()+8)
    self.confirmText:setString(global.luaCfg:get_local_string(10927,  curCount, self.leftName, cur, self.rightName))
end

function UIChangeShopPanel:showConfirm(shopCount, changeCount)

    self.slider:setVisible(true)
    self.confirmText:setVisible(true)
    self.lineText:setPositionX(self.sliderControl.inputText:getPositionX()+8)
    self.slider.max:setPositionX(self.lineText:getPositionX()+8)
    self.shopCount, self.changeCount = self:getChangeSingleNum(self.leftItem, self.rightItem)
    self:setSliderVal(shopCount, self.shopHavCount)
    self.confirmText:setString(global.luaCfg:get_local_string(10927, shopCount, self.leftName, changeCount, self.rightName))

    self.count1:setVisible(true)
    self.countBg1:setVisible(true)
    self.count1:setString(shopCount)

    self.isEnoughShop = true
    self.count1:setTextColor(cc.c3b(255, 226, 165))
    if shopCount > self.shopHavCount then
        self.count1:setTextColor(gdisplay.COLOR_RED)
        self.isEnoughShop = false
    end
    self:checkCanChange()
end

function UIChangeShopPanel:checkCanChange()

    global.colorUtils.turnGray(self.grayBg, true)
    if self.leftItem and self.rightItem and self.isEnoughShop then
        global.colorUtils.turnGray(self.grayBg, false)
    end
end

function UIChangeShopPanel:getItemName(itemId)
    local itemData = luaCfg:get_item_by(itemId)
    if not itemData then
        itemData = luaCfg:get_equipment_by(itemId)
    end
    return itemData.itemName or itemData.name
end

-- 左边选中item
function UIChangeShopPanel:leftShopItem(itemData, selectItemId, havCount, isRefresh)

    self.icon1:setVisible(true)
    self.name1:setVisible(true)
    self.addIcon1:setVisible(false)


    self.itemLeftData = itemData
    self.leftItem = selectItemId
    self.shopHavCount = havCount
    global.panelMgr:setTextureFor(self.icon1, itemData.itemIcon or itemData.icon)
    global.panelMgr:setTextureForAsync(self.quit1,string.format("icon/item/item_bg_0%d.png",itemData.quality),true)
    self.leftName = itemData.itemName or itemData.name
    self.name1:setString(self.leftName)

    if self.rightItem then
        local shopCount, changeCount = self:getChangeSingleNum(self.leftItem, self.rightItem)
        self.count2:setString(changeCount)
        self:showConfirm(shopCount, changeCount)
    end

    if not isRefresh then
        self.tableView:setData(self:getCanShop(selectItemId), true)
        self:checkCanChange()
    end
end

-- 右边选中item
function UIChangeShopPanel:rightChangeItem(itemData, selectItemId, havCount, isRefresh)

    self.icon2:setVisible(true)
    self.count2:setVisible(true)
    self.name2:setVisible(true)
    self.countBg2:setVisible(true)
    self.addIcon2:setVisible(false)

    self.itemRightData = itemData
    self.rightItem = selectItemId
    global.panelMgr:setTextureFor(self.icon2, itemData.itemIcon or itemData.icon)
    global.panelMgr:setTextureForAsync(self.quit2,string.format("icon/item/item_bg_0%d.png",itemData.quality),true)
    self.rightName = itemData.itemName or itemData.name
    self.name2:setString(self.rightName)

    if self.leftItem then
        local shopCount, changeCount = self:getChangeSingleNum(self.leftItem, self.rightItem)
        self.count2:setString(changeCount)
        self:showConfirm(shopCount, changeCount)
    end
    if not isRefresh then
        self.tableView:setData(self:sortData(self:getCanChange(selectItemId)), true)
        self:checkCanChange()
    end
end

-- 左边
function UIChangeShopPanel:shopHandler(sender, eventType)
    
    if self.leftItem and self.curSelectIndex == 1 then 
        return 
    end

    self.curSelectIndex = 1
    self.lastOffset2 = self.tableView:getContentOffset()
    if self.rightItem then
        self.tableView:setData(self:getCanShopById(self.rightItem))
    else
        self.tableView:setData(self:getCanShop())
    end
    self.titleSelect:setString(luaCfg:get_local_string(10924))
    self:checkCanChange()
    if self.lastOffset1 and self.lastOffset1.y < 0  and self.leftItem and self.tableView:minContainerOffset().y < 0 then
        self.tableView:setContentOffset(self.lastOffset1)
    end
end

-- 右边
function UIChangeShopPanel:changeHandler(sender, eventType)

    if self.rightItem and self.curSelectIndex == 2 then 
        return 
    end
   
    if self.leftItem then 
        self.curSelectIndex = 2
        self.lastOffset1 = self.tableView:getContentOffset()
        self.tableView:setData(self:sortData(self:getCanChangeById(self.leftItem)))
        self.titleSelect:setString(luaCfg:get_local_string(10925))
        self:checkCanChange()

        if self.lastOffset2 and self.lastOffset2.y < 0 and self.rightItem and self.tableView:minContainerOffset().y < 0 then 
            self.tableView:setContentOffset(self.lastOffset2)
        end
    else
        global.tipsMgr:showWarning("exchange03")
    end
    
end

function UIChangeShopPanel:sortData(data)

    if #data > 0 then
        table.sort(data, function(s1, s2) 

            local getQuit = function (itemId)
                local itemData = luaCfg:get_item_by(itemId)
                if not itemData then
                    itemData = luaCfg:get_equipment_by(itemId)
                end
                return itemData.quality
            end

            if getQuit(s1.itemId) ~= getQuit(s2.itemId) then
                return getQuit(s1.itemId) < getQuit(s2.itemId) 
            else
                return s1.itemId < s2.itemId
            end
        end)
    end
    return data
end

function UIChangeShopPanel:confirmHandler(sender, eventType)
    
    if not self.leftItem then
        global.tipsMgr:showWarning("exchange03")
        return
    elseif not self.rightItem then
        global.tipsMgr:showWarning("exchange02")
        return
    elseif not self.isEnoughShop then
        global.tipsMgr:showWarning("exchange04", self:getItemName(self.leftItem))
        return
    end

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setRichData({self.count1:getString(), self.leftName, self.count2:getString(), self.rightName})
    panel:setData("50231", function()

        global.itemApi:changeShop(function (msg)
            -- body
            global.tipsMgr:showWarning("exchange01",  self.count2:getString(), self:getItemName(self.rightItem))
            self:refersh()
        end, self.rightItem, self.leftItem, self.sliderControl:getContentCount())
    end)
end

function UIChangeShopPanel:refersh()

    if self.itemLeftData and self.itemRightData then
        self.tableView:setData(self.tableView:getData(), true)
        self:leftShopItem(self.itemLeftData, self.leftItem, global.normalItemData:getItemById(self.leftItem).count, true)
        self:rightChangeItem(self.itemRightData, self.rightItem, global.normalItemData:getItemById(self.rightItem).count, true)
        self:checkCanChange()
    end
end

function UIChangeShopPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIChangeShopPanel")
end
--CALLBACKS_FUNCS_END

return UIChangeShopPanel

--endregion
