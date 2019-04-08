--region UIUShopItemB.lua
--Author : wuwx
--Date   : 2017/03/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUShopWidget = require("game.UI.union.second.shop.UIUShopWidget")
--REQUIRE_CLASS_END

local UIUShopItemB  = class("UIUShopItemB", function() return gdisplay.newWidget() end )

function UIUShopItemB:ctor()
    self:CreateUI()
end

function UIUShopItemB:CreateUI()
    local root = resMgr:createWidget("union/union_shop_item2")
    self:initUI(root)
end

function UIUShopItemB:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_shop_item2")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.name = self.root.name_export
    self.num_info = self.root.num_info_mlan_4_export
    self.num = self.root.num_info_mlan_4_export.num_export
    self.btn = self.root.btn_export
    self.node_gray = self.root.btn_export.node_gray_export
    self.text = self.root.btn_export.text_export
    self.open_info = self.root.open_info_export
    self.node_icon = UIUShopWidget.new()
    uiMgr:configNestClass(self.node_icon, self.root.node_icon)

    uiMgr:addWidgetTouchHandler(self.btn, function(sender, eventType) self:onBuy(sender, eventType) end)
--EXPORT_NODE_END
end

function UIUShopItemB:setData(data)
    self.data = data
    local dData = global.luaCfg:get_union_shop_by(data.lID)
    self.dData = dData
    local itemData = global.luaCfg:get_item_by(dData.itemID)
    self.itemData = itemData

    self.name:setString(itemData.itemName)

    self.node_icon:setData(data,itemData)
    if global.unionData:isEnoughInUnionBuildsLv(24,dData.shoplv) then
        self.btn:setVisible(true)
        self.open_info:setVisible(false)
        self.num_info:setVisible(true)
        self.num:setString(string.format("%s/%s",data.lCurCount,dData.limited))

        global.tools:adjustNodePosForFather(self.num:getParent(),self.num)

        
    else
        self.btn:setVisible(false)
        self.open_info:setVisible(true)
        self.num_info:setVisible(false)

        self.open_info:setString(global.luaCfg:get_local_string(10421,global.luaCfg:get_union_build_by(24).name,dData.shoplv))
    end

    if self.data.lCurCount <= 0 then
        global.colorUtils.turnGray(self.node_gray,true)
    else
        global.colorUtils.turnGray(self.node_gray,false)
    end

    self.text:setString(dData.shopboom)
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUShopItemB:onBuy(sender, eventType)
    if not global.unionData:isHadPower(21) then
        return global.tipsMgr:showWarning("unionPowerNot")
    end
    
    if self.data.lCurCount <= 0 then
        return global.tipsMgr:showWarning("Unionshop10")
    end

    if not global.unionData:isEnoughInUnionStrong(self.dData.shopboom) then
        return global.tipsMgr:showWarning("Unionshop08")
    end

    if self.dData.personal>0 and self.dData.personal <= self.data.lBuyCount then
        return global.tipsMgr:showWarning("Unionshop09")
    end
    global.panelMgr:openPanel("UIUShopBuyPanel"):setData(2,self.data,self.dData,self.itemData)
end
--CALLBACKS_FUNCS_END

return UIUShopItemB

--endregion
