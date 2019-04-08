--region UIBuyShopPanel.lua
--Author : anlitop
--Date   : 2017/03/13
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local propData = global.propData
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local shopwidget = require("game.UI.bag.shopwidget")
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END
local UIBuyShopPanel  = class("UIBuyShopPanel", function() return gdisplay.newWidget() end )

local CountSliderControl = require("game.UI.common.UICountSliderControl")


function UIBuyShopPanel:ctor()
    self:CreateUI()
end

function UIBuyShopPanel:CreateUI()
    local root = resMgr:createWidget("bag/show_pay")
    self:initUI(root)
end

function UIBuyShopPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/show_pay")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.name_export
    self.desc_text = self.root.Node_export.desc_text_export
    self.node_icon = shopwidget.new()
    uiMgr:configNestClass(self.node_icon, self.root.Node_export.node_icon)
    self.slider = self.root.Node_export.slider_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.Node_export.slider_export.cur)
    self.buy_button = self.root.Node_export.buy_button_export
    self.but_cost_sprite = self.root.Node_export.buy_button_export.but_cost_sprite_export
    self.buy_cost_text = self.root.Node_export.buy_button_export.buy_cost_text_export
    self.canbuy_text_node = self.root.Node_export.canbuy_text_node_mlan_4_export
    self.canbuy_text = self.root.Node_export.canbuy_text_node_mlan_4_export.canbuy_text_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.buy_button, function(sender, eventType) self:onBuy(sender, eventType) end)
--EXPORT_NODE_END

     self.slider.cur = self.cur
     self.sliderControl = CountSliderControl.new(self.slider,handler(self,self.onSliderBuyEvent) , true)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIBuyShopPanel:setData(data,SuccessbuyCall)

    self.data= data
    self.SuccessbuyCall = SuccessbuyCall
    local numn =  (propData:getShowProp(WCONST.ITEM.TID.DIAMOND,"") - propData:getShowProp(WCONST.ITEM.TID.DIAMOND,"") % self.data.cost) / self.data.cost
    if numn < 1 then numn = 1 end
    self.sliderControl:setMaxCount(numn)
    self:updateUI()
end 


function  UIBuyShopPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,function() 
        if self.data and self.SuccessbuyCall then 
            self:setData(self.data , self.SuccessbuyCall)
        end 
    end)
end 

function UIBuyShopPanel:setShopID(id,SuccessbuyCall)
    
    local shopData = luaCfg:get_shop_by(id)
    shopData.information = luaCfg:get_local_item_by(id)
    self:setData(shopData,SuccessbuyCall)
end

function UIBuyShopPanel:updateUI()
     
     self.name:setString(self.data.name)
     self.desc_text:setString(self.data.information.itemDes or self.data.information.des)
     -- self.node_icon.icon:setSpriteFrame(self.data.information.itemIcon)
     -- self.node_icon.icon_view:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",self.data.information.quality))
    global.panelMgr:setTextureFor(self.node_icon.icon_view,string.format("icon/item/item_bg_0%d.png",self.data.information.quality))
    global.panelMgr:setTextureFor(self.node_icon.icon,self.data.information.itemIcon or self.data.information.icon)

     if  self.data.limited == 0 then  --如果等于0  不是限购
        self.canbuy_text_node:setVisible(false)
        self.node_icon.xian:setVisible(false)
     else
        self.canbuy_text_node:setVisible(true)
         self.node_icon.xian:setVisible(true)
         -- self.canbuy_text:setString(self.data.limited-self.data.surplus..'/'..self.data.limited)
         --要购买的
        self.canbuy_text:setString(self.data.already_buy)
        local mojing_count =tonumber(propData:getShowProp(WCONST.ITEM.TID.DIAMOND,""))
        if mojing_count > self.data.cost * self.data.already_buy  then 
            self.sliderControl:setMaxCount(self.data.already_buy)
        end 
     end
     self.buy_cost_text:setString(self.data.cost)

   --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.canbuy_text:getParent(),self.canbuy_text)  
end


function UIBuyShopPanel:exit_call(sender, eventType)
    global.panelMgr:closePanel("UIBuyShopPanel")
end

function UIBuyShopPanel:onBuy(sender, eventType)
    --物品  id  ， 数量
    local itemid = self.data.itemId 
    local count  = self.sliderControl:getContentCount()

    if  tonumber(propData:getShowProp(WCONST.ITEM.TID.DIAMOND,""))<self.data.cost*count then 
         -- global.tipsMgr:showWarning("shop01")
         -- global.colorUtils.turnGray(self.buy_button,true)
         global.panelMgr:openPanel("UIRechargePanel") 
    else 
        -- global.colorUtils.turnGray(self.buy_button,false)
        global.ShopActionAPI:sedBuyShopReq(itemid,count,function(ret,msg)
                if ret.retcode ==0 then 

                    if self.SuccessbuyCall  then 

                        self.SuccessbuyCall()

                    end 

                    if self.data then 
                        global.tipsMgr:showWarning("shop03",count,self.data.name)
                    end 
                     
                    global.panelMgr:closePanel("UIBuyShopPanel")
                end 
        end)
    end 
end
 


function UIBuyShopPanel:onSliderBuyEvent(count)
      
    self.buy_cost_text:setString(self.data.cost*count) 
    
    if tonumber(propData:getShowProp(WCONST.ITEM.TID.DIAMOND,""))< self.data.cost*count then         
        self.buy_cost_text:setColor(gdisplay.COLOR_RED)
    else
        self.buy_cost_text:setColor(cc.c3b(255, 226, 165))
    end  
end
--CALLBACKS_FUNCS_END

return UIBuyShopPanel

--endregion
