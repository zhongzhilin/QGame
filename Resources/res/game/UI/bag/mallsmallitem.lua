--region mallsmallitem.lua
--Author : anlitop
--Date   : 2017/03/13
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local propData = global.propData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local shopwidget = require("game.UI.bag.shopwidget")
--REQUIRE_CLASS_END

local mallsmallitem  = class("mallsmallitem", function() return gdisplay.newWidget() end )

function mallsmallitem:ctor()
    self:CreateUI()
end

function mallsmallitem:CreateUI()
    local root = resMgr:createWidget("bag/shop_item")
    self:initUI(root)
end

function mallsmallitem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/shop_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.mall_icon_node = self.root.bg.mall_icon_node_export
    self.mall_icon_node = shopwidget.new()
    uiMgr:configNestClass(self.mall_icon_node, self.root.bg.mall_icon_node_export)
    self.title = self.root.bg.title_export
    self.btn_normal = self.root.bg.btn_normal_export
    self.node_gray1 = self.root.bg.btn_normal_export.node_gray1_export
    self.text1 = self.root.bg.btn_normal_export.text1_export
    self.btn_discount = self.root.bg.btn_discount_export
    self.node_gray2 = self.root.bg.btn_discount_export.node_gray2_export
    self.oldprice_text = self.root.bg.btn_discount_export.oldprice_text_export
    self.newprice_text = self.root.bg.btn_discount_export.newprice_text_export

    uiMgr:addWidgetTouchHandler(self.btn_normal, function(sender, eventType) self:onBuy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_discount, function(sender, eventType) self:onRmbBuy(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function mallsmallitem:setData(data)
    self.data = data 
    self:updateUI()
end 

function mallsmallitem:updateUI()
    if self.data.price ==0 then 
        self.btn_normal:setVisible(true)
        self.btn_discount:setVisible(false)
        self.text1:setString(self.data.cost)

        if self.data.already_buy ==0 then
             global.colorUtils.turnGray(self.btn_normal,true)
        else
            global.colorUtils.turnGray(self.btn_normal,false)
        end 
    else 
        self.btn_normal:setVisible(false)
        self.btn_discount:setVisible(true)
        self.oldprice_text:setString(self.data.price)
        self.newprice_text :setString(self.data.cost)

        if self.data.already_buy ==0 then
             global.colorUtils.turnGray(self.btn_discount,true)
        else
            global.colorUtils.turnGray(self.btn_discount,false)
        end 
    end 
 
   self.title:setString(self.data.name)
   -- self.mall_icon_node.icon:setSpriteFrame(self.data.information.itemIcon)
   -- self.mall_icon_node.icon_view:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",self.data.information.quality))
    global.panelMgr:setTextureFor(self.mall_icon_node.icon_view,string.format("icon/item/item_bg_0%d.png",self.data.information.quality))
    global.panelMgr:setTextureFor(self.mall_icon_node.icon,self.data.information.itemIcon)
   if self.data.limited == 0 then 
        self.mall_icon_node.xian:setVisible(false )
    else
        self.mall_icon_node.xian:setVisible(true)
    end  
end

function mallsmallitem:checkXianGou()
    if tonumber(propData:getShowProp(WCONST.ITEM.TID.DIAMOND,"")) < self.data.cost then
         global.panelMgr:openPanel("UIRechargePanel") 
    else 
         if  self.data.limited ~= 0 then 
            if self.data.already_buy == 0 then 
                global.tipsMgr:showWarning("shop02")
            else 
                 global.panelMgr:openPanel("UIBuyShopPanel"):setData(self.data)
            end 
            -- global.ShopActionAPI:getTopReq(1,self.data.itemId,function(ret,msg)
            --     dump(ret)
            --     dump(msg)
            --      if ret.retcode ==0 then 
            --          self.data.surplus=msg.tgshopinfo[1].limite
            --          if self.data.surplus <=0 then 
            --             global.tipsMgr:showWarning("shop02")
            --          else           
            --             global.panelMgr:openPanel("UIBuyShopPanel"):setData(self.data)
            --          end
            --      end 
            --  end)
         else
             global. panelMgr:openPanel("UIBuyShopPanel"):setData(self.data)
         end 
     end 
end 

function mallsmallitem:onBuy(sender, eventType)
        self:checkXianGou()
end

function mallsmallitem:onRmbBuy(sender, eventType)
       self:checkXianGou()
end
--CALLBACKS_FUNCS_END

return mallsmallitem

--endregion
