--region UIUShopBuyPanel.lua
--Author : wuwx
--Date   : 2017/03/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUShopWidget = require("game.UI.union.second.shop.UIUShopWidget")
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIUShopBuyPanel  = class("UIUShopBuyPanel", function() return gdisplay.newWidget() end )

function UIUShopBuyPanel:ctor()
    self:CreateUI()
end

function UIUShopBuyPanel:CreateUI()
    local root = resMgr:createWidget("union/union_show_pay1")
    self:initUI(root)
end

function UIUShopBuyPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_show_pay1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.title.name_export
    self.desc = self.root.Node_export.desc_export
    self.slider = self.root.Node_export.slider_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.Node_export.slider_export.cur)
    self.bnt_1 = self.root.Node_export.bnt_1_export
    self.icon_1 = self.root.Node_export.bnt_1_export.icon_1_export
    self.text1 = self.root.Node_export.bnt_1_export.text1_export
    self.bnt_2 = self.root.Node_export.bnt_2_export
    self.icon_2 = self.root.Node_export.bnt_2_export.icon_2_export
    self.text2 = self.root.Node_export.bnt_2_export.text2_export
    self.text3 = self.root.Node_export.bnt_2_export.text3_export
    self.type3_info = self.root.Node_export.type3_info_mlan_5_export
    self.type3 = self.root.Node_export.type3_info_mlan_5_export.type3_export
    self.node_icon = UIUShopWidget.new()
    uiMgr:configNestClass(self.node_icon, self.root.Node_export.node_icon)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.bnt_1, function(sender, eventType) self:onBuy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.bnt_2, function(sender, eventType) self:onRmbBuy(sender, eventType) end)
--EXPORT_NODE_END
    self.slider.cur = self.cur
    
    self.cur:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)

    local CountSliderControl = require("game.UI.common.UICountSliderControl")
    self.sliderControl = CountSliderControl.new(self.slider,function(count)
        -- body
        local numUnit = 0 
        if self.model == 1 then
            numUnit = self.dData.shopnum
        else
            numUnit = self.dData.shopboom
        end
        self.text1:setString(math.floor(count*numUnit))
        self.text2:setString(math.floor(count*numUnit))
        self.text3:setString(count*self.dData.crystal)
    end)
end

function UIUShopBuyPanel:setData(model,data,dData,itemData)
    self.model = model
    self.data = data
    self.dData = dData
    self.itemData = itemData

    self.name:setString(itemData.itemName)

    self.node_icon:setData(data,itemData)
    self.node_icon:showCount(false)
    self.desc:setString(itemData.itemDes)
    --限购标识
    self.type3_info:setVisible(dData.personal > 0)
    self.type3:setString(dData.personal-data.lBuyCount)

    global.tools:adjustNodePosForFather(self.type3:getParent(),self.type3)


    local maxCount = 0
    if self.model == 1 then
        --消耗个人贡献
        self.text1:setTextColor(gdisplay.COLOR_WHITE)
        self.bnt_1:setVisible(dData.crystal<=0)
        self.bnt_2:setVisible(dData.crystal>0)
        self.icon_1:setSpriteFrame("ui_surface_icon/union_shop_icon03.png")
        self.icon_2:setSpriteFrame("ui_surface_icon/union_shop_icon03.png")

        self.type3_info:setString(global.luaCfg:get_local_string(10423))
        maxCount = math.floor(global.userData:getlAllyStrong()/dData.shopnum)
        if dData.crystal>0 then
            local maxNum2 = math.floor(global.propData:getGold()/dData.crystal)
            maxCount = math.min(maxCount,maxNum2)
        end

        if dData.personal > 0 then
            self.bnt_1:setEnabled(data.lBuyCount<dData.personal)
            self.bnt_2:setEnabled(data.lBuyCount<dData.personal)
        else
            self.bnt_1:setEnabled(true)
            self.bnt_2:setEnabled(true)
        end
        if dData.personal > 0 then
            maxCount = math.min(dData.personal-data.lBuyCount,maxCount)
        end
    else
        --进货模式-》消耗联盟繁荣度
        self.bnt_1:setEnabled(true)
        self.bnt_1:setVisible(true)
        self.bnt_2:setVisible(false)
        self.icon_1:setSpriteFrame("ui_surface_icon/union_shop_icon02.png")
        self.icon_2:setSpriteFrame("ui_surface_icon/union_shop_icon02.png")

        self.type3_info:setString(global.luaCfg:get_local_string(10424))
        maxCount = math.floor(global.unionData:getInUnionStrong()/dData.shopboom)

        if global.unionData:isEnoughInUnionStrong(dData.shopboom*maxCount) then
            self.text1:setTextColor(gdisplay.COLOR_WHITE)
        else
            self.text1:setTextColor(gdisplay.COLOR_RED) 
        end
    end

    --限量标识
    if dData.limited > 0 and data.lCurCount then
        maxCount = math.min(data.lCurCount,maxCount)
    end

    if maxCount <= 0 then
        self.sliderControl:setMaxCount(maxCount)
        self.sliderControl:reSetMaxCount(maxCount)
        self.sliderControl:changeCount(0)
        self.bnt_1:setEnabled(false)
        self.bnt_2:setEnabled(false)
    else
        self.sliderControl:setMaxCount(maxCount)
        -- self.sliderControl:changeCount(maxCount)
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUShopBuyPanel:exit_call(sender, eventType)
    global.panelMgr:closePanel("UIUShopBuyPanel")
end

function UIUShopBuyPanel:onBuy(sender, eventType)
    -- self.model
    local count = self.sliderControl:getContentCount()
    global.unionApi:setAllyShopAction(function(msg)
        if self.model == 1 then
            global.tipsMgr:showWarning("Unionshop01",count,self.itemData.itemName)
        else
            global.tipsMgr:showWarning("Unionshop02",count,self.itemData.itemName)
        end
        global.panelMgr:closePanel("UIUShopBuyPanel")
        gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_SHOP)
    end,self.model,self.data.lID,count)
end

function UIUShopBuyPanel:onRmbBuy(sender, eventType)
    local count = self.sliderControl:getContentCount()
    global.unionApi:setAllyShopAction(function(msg)
        if self.model == 1 then
            global.tipsMgr:showWarning("Unionshop01",count,self.itemData.itemName)
        else
            global.tipsMgr:showWarning("Unionshop02",count,self.itemData.itemName)
        end
        global.panelMgr:closePanel("UIUShopBuyPanel")
        gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_SHOP)
    end,self.model,self.data.lID,count)
end
--CALLBACKS_FUNCS_END

return UIUShopBuyPanel

--endregion
