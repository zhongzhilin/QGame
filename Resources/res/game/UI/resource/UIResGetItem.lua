--region UIResGetItem.lua
--Author : yyt
--Date   : 2016/11/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local propData = global.propData
local resData = global.resData
local luaCfg = global.luaCfg
local normalItemData = global.normalItemData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIResGetItem  = class("UIResGetItem", function() return gdisplay.newWidget() end )

function UIResGetItem:ctor()
    self:CreateUI()
end

function UIResGetItem:CreateUI()
    local root = resMgr:createWidget("resource/res_item_node")
    self:initUI(root)
end

function UIResGetItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "resource/res_item_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon_bg = self.root.item_list_bg.icon_bg_export
    self.icon = self.root.item_list_bg.icon_bg_export.icon_export
    self.number = self.root.item_list_bg.icon_bg_export.item_number_bg.number_export
    self.buy_use_btn = self.root.item_list_bg.buy_use_btn_export
    self.diamond_num = self.root.item_list_bg.buy_use_btn_export.diamond_num_export
    self.use_btn = self.root.item_list_bg.use_btn_export
    self.item_name = self.root.item_name_export
    self.item_info = self.root.item_info_export

    uiMgr:addWidgetTouchHandler(self.buy_use_btn, function(sender, eventType) self:useAndBuy_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.use_btn, function(sender, eventType) self:use_click(sender, eventType) end)
--EXPORT_NODE_END
    self.getPanel = panelMgr:getPanel("UIResGetPanel")
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIResGetItem:setData(data, isBuild)
    
    self.isBuild = isBuild
    self.data = data
    -- self.icon_bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",data.quality))
    -- self.icon:setSpriteFrame(data.itemIcon)
    global.panelMgr:setTextureFor(self.icon,data.itemIcon)
    global.panelMgr:setTextureFor(self.icon_bg,string.format("icon/item/item_bg_0%d.png",data.quality))
    self.item_name:setString(data.itemName)
    self.item_info:setString(data.itemDes)

    local itemBagCount = normalItemData:getItemById(data.itemId).count
    self.number:setString(itemBagCount)
    self:checkCurNum(itemBagCount)
end

function UIResGetItem:checkCurNum(num)
    
    self.use_btn:setVisible(true)
    self.buy_use_btn:setVisible(true)
    self.use_btn:setEnabled(true)
    self.buy_use_btn:setEnabled(true)

    if num <= 0 then
        self.use_btn:setVisible(false)
        local buyData = luaCfg:get_shop_by(self.data.itemId)
        self.diamond_num:setString(buyData.cost)
    else
        self.buy_use_btn:setVisible(false)
    end
    
    -- 资源已满，不能使用和购买
    if self.getPanel.curResNum == self.getPanel.maxResNum then
        self.use_btn:setEnabled(false)
        self.buy_use_btn:setEnabled(false)
    end
end

function UIResGetItem:useAndBuy_click(sender, eventType)
    
    local diamondNum = tonumber(self.diamond_num:getString())
   -- local useDiamond =  propData:getShowProp(WCONST.ITEM.TID.DIAMOND,"")
   -- local maxCount = math.floor(useDiamond/diamondNum)

    -- 道具使用限制
    local maxCount =  math.ceil((self.getPanel.maxResNum - self.getPanel.curResNum)/self.data.effectPara1)
    local data = {diamondNum=diamondNum, itemId=self.data.itemId, maxCount = maxCount, curResId = self.getPanel.curResId}
    panelMgr:openPanel("UIItemBuyPanel"):setData(data, handler(self, self.buyAndUseCall))
end

function UIResGetItem:use_click(sender, eventType)
    local maxCount =  math.ceil((self.getPanel.maxResNum - self.getPanel.curResNum)/self.data.effectPara1)
    local curCount = tonumber(self.number:getString())
    if curCount < maxCount then
        maxCount = curCount
    end
    local itemUsePanel = panelMgr:openPanel("UIItemUsePanel")
    local data = {itemId = self.data.itemId, maxCount = maxCount, curResId = self.getPanel.curResId}
    itemUsePanel:setData(data, handler(self, self.useCall))
end

function UIResGetItem:useCall(count, exitCall, useNumber)

    if not self.data then return end
    global.itemApi:itemUse(self.data.itemId, count, 0, 0, function(msg)

        local data = normalItemData:useItem(self.data.itemId, count)
        if self.getItemInfo then
            local str = self:getItemInfo(self.data.itemId, count, useNumber)
            global.tipsMgr:showWarning(str)
        end
        if self.refershCall then 
            self:refershCall()
        end 
        exitCall()
    end)
end

function UIResGetItem:buyAndUseCall(data, exitCall)
    
    local itemId, count, useNumber = data.id, data.count, data.getCount
    global.itemApi:diamondUse(function(msg)
        
        if self.getItemInfo then 
            local str = self:getItemInfo(itemId, count, useNumber)
            global.tipsMgr:showWarning(str)
        end
        if self.refershCall then 
            self:refershCall()
        end 
        exitCall()

        if count > 1 then
            local item = global.luaCfg:get_item_by(itemId)
            if item and item.itemType == 101 and  item.typePara1 then 
                for _ , v in pairs(global.luaCfg:get_drop_by(item.typePara1).dropItem) do 
                    if v[1] <= 4 then 
                        local soundKey = "ui_harvest_"..v[1] 
                        gevent:call(gsound.EV_ON_PLAYSOUND,soundKey)
                    end 
                end                 
            end            
        end

    end,1,count,0,itemId)
end

function UIResGetItem:getItemInfo( itemId, count, useNumber )
    
    local tipStr = ""
    local itemData = luaCfg:get_item_by(self.getPanel.curResId)
    local itemNum = luaCfg:get_item_by(itemId).effectPara1*count
    if useNumber and useNumber > 0 then
        itemNum = useNumber
    end
    tipStr = itemData.itemName.." +"..itemNum
    return tipStr
end

-- 检查 资源是否已经到达上限
-- function UIResGetItem:checkResNum( count )

--     local curResNum = self.getPanel.curResNum + tonumber(count*self.data.effectPara1)
--     local maxResNum = self.getPanel.maxResNum
--     if curResNum > maxResNum then
--         return true
--     else
--         return false
--     end
-- end

function UIResGetItem:refershCall()
    
    -- 建筑升级建造条件 资源不足获取跳转
    if self.isBuild then
        gevent:call(global.gameEvent.EV_ON_UI_BUILD_FLUSH)
        gevent:call(global.gameEvent.EV_ON_UI_TECH_FLUSH)
    end

    resData:updataFlag(self.getPanel.curResId, 1)
    self.getPanel:setData(resData:getResById(self.getPanel.curResId))
end

--CALLBACKS_FUNCS_END

return UIResGetItem

--endregion
