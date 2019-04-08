--region UIUShopItemA.lua
--Author : wuwx
--Date   : 2017/03/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUShopWidget = require("game.UI.union.second.shop.UIUShopWidget")
--REQUIRE_CLASS_END

local UIUShopItemA  = class("UIUShopItemA", function() return gdisplay.newWidget() end )

function UIUShopItemA:ctor()
    self:CreateUI()
end

function UIUShopItemA:CreateUI()
    local root = resMgr:createWidget("union/union_shop_item1")
    self:initUI(root)
end

function UIUShopItemA:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_shop_item1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bj = self.root.bj_export
    self.name = self.root.name_export
    self.btn_1 = self.root.btn_1_export
    self.node_gray1 = self.root.btn_1_export.node_gray1_export
    self.text1 = self.root.btn_1_export.text1_export
    self.btn_2 = self.root.btn_2_export
    self.node_gray2 = self.root.btn_2_export.node_gray2_export
    self.text2 = self.root.btn_2_export.text2_export
    self.text3 = self.root.btn_2_export.text3_export
    self.node_icon = UIUShopWidget.new()
    uiMgr:configNestClass(self.node_icon, self.root.node_icon)

    uiMgr:addWidgetTouchHandler(self.btn_1, function(sender, eventType) self:onBuy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_2, function(sender, eventType) self:onRmbBuy(sender, eventType) end)
--EXPORT_NODE_END
end

function UIUShopItemA:setData(data)
    self.data = data
    local dData = global.luaCfg:get_union_shop_by(data.lID)
    self.dData = dData
    local itemData = global.luaCfg:get_item_by(dData.itemID)
    self.itemData = itemData

    self.name:setString(itemData.itemName)

    self.node_icon:setData(data,itemData)

    if dData.limited > 0 then
        --个人限量物品
        self.bj:setSpriteFrame("union_shop_d2.jpg")
    else
        self.bj:setSpriteFrame("union_shop_d1.jpg")
    end

    if self.dData.personal>0 and self.dData.personal <= self.data.lBuyCount then
        global.colorUtils.turnGray(self.node_gray1,true)
        global.colorUtils.turnGray(self.node_gray2,true)
    else
        global.colorUtils.turnGray(self.node_gray1,false)
        global.colorUtils.turnGray(self.node_gray2,false)
    end

    self.btn_1:setVisible(dData.crystal<=0)
    self.btn_2:setVisible(dData.crystal>0)
    self.text1:setString(dData.shopnum)
    self.text2:setString(dData.shopnum)
    self.text3:setString(dData.crystal)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIUShopItemA:onBuy(sender, eventType)
    if not global.userData:isEnoughlAllyStrong(self.dData.shopnum) then
        return global.tipsMgr:showWarning("Unionshop06")
    end
    if not global.propData:checkEnoughWithTips(WCONST.ITEM.TID.DIAMOND,self.dData.crystal) then 
        return
    end
    if self.dData.personal>0 and self.dData.personal <= self.data.lBuyCount then
        return global.tipsMgr:showWarning("Unionshop09")
    end
    global.panelMgr:openPanel("UIUShopBuyPanel"):setData(1,self.data,self.dData,self.itemData)
end

function UIUShopItemA:onRmbBuy(sender, eventType)
    if not global.userData:isEnoughlAllyStrong(self.dData.shopnum) then
        return global.tipsMgr:showWarning("Unionshop06")
    end
    if not global.propData:checkEnoughWithTips(WCONST.ITEM.TID.DIAMOND,self.dData.crystal) then 
        return
    end
    if self.dData.personal>0 and self.dData.personal <= self.data.lBuyCount then
        return global.tipsMgr:showWarning("Unionshop09")
    end
    global.panelMgr:openPanel("UIUShopBuyPanel"):setData(1,self.data,self.dData,self.itemData)
end
--CALLBACKS_FUNCS_END

return UIUShopItemA

--endregion
