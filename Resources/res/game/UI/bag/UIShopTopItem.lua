--region UIShopTopItem.lua
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

local UIShopTopItem  = class("UIShopTopItem", function() return gdisplay.newWidget() end )


function UIShopTopItem:ctor()
    self:CreateUI()
end

function UIShopTopItem:CreateUI()
    local root = resMgr:createWidget("bag/shop_item2")
    self:initUI(root)
end

function UIShopTopItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/shop_item2")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.name = self.root.bg.name_export
    self.desc = self.root.bg.desc_export
    self.node_icon = shopwidget.new()
    uiMgr:configNestClass(self.node_icon, self.root.bg.node_icon)
    self.btn_normal = self.root.bg.btn_normal_export
    self.normal_price_text = self.root.bg.btn_normal_export.normal_price_text_export
    self.btn_discount = self.root.bg.btn_discount_export
    self.node_gray2 = self.root.bg.btn_discount_export.node_gray2_export
    self.oldprice_text = self.root.bg.btn_discount_export.oldprice_text_export
    self.newprice_text = self.root.bg.btn_discount_export.newprice_text_export
    self.top_sprite = self.root.top_sprite_export
    self.top_num_text = self.root.top_sprite_export.top_num_text_export

    uiMgr:addWidgetTouchHandler(self.btn_normal, function(sender, eventType) self:onBuy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_discount, function(sender, eventType) self:onRmbBuy(sender, eventType) end)
--EXPORT_NODE_END

-- local function callback(ref, type)
--         if type ==0 then
--             local panel = global.panelMgr:getPanel("UIBagPanel") 
--             panel.FileNode_1:setData(self.data)
--             panel.FileNode_1:show()
--             local  point= self.Button_1:convertToWorldSpace(cc.p(0,0))
--         local part = panel.FileNode_1.root.bg:getContentSize().width/2/2
--         local height = panel.FileNode_1.root.bg:getContentSize().height/1.8
--         panel.FileNode_1:setPosition(cc.p(display.width/2-part,point.y+height))
--         global.panelMgr:getPanel("UIBagPanel").FileNode_1:setVisible(true)
--         --panel.PanelToTips:runAction(cc.FadeIn:create(0.2))
--         elseif type ==2 then
--             global.panelMgr:getPanel("UIBagPanel").FileNode_1:setVisible(false)
--         elseif type == 3 then
--             global.panelMgr:getPanel("UIBagPanel").FileNode_1:setVisible(false)
--         end
--         return true 
--     end
--     self.Button_1:addTouchEventListener(callback)
--     self.Button_1:setSwallowTouches(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function  UIShopTopItem:setData(data)
    self.data = data
    self:updateUI()


   self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,function() 
    self:updateUI()
   end)
end 

function UIShopTopItem:getIcon()
    return self.node_icon 
end 

function UIShopTopItem:updateUI()
    if self.data.limited == 0 then 
       self.node_icon.xian:setVisible(false)
    else
       
        self.node_icon.xian:setVisible(true)
    end
    self.name:setString(self.data.name)
    self.top_num_text:setString(self.data.top)
    self.desc:setString(self.data.information.itemDes or self.data.information.des)
    -- self.node_icon.icon:setSpriteFrame(self.data.information.itemIcon)
    -- self.node_icon.icon_view:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",self.data.information.quality))
    global.panelMgr:setTextureFor(self.node_icon.icon_view,string.format("icon/item/item_bg_0%d.png",self.data.information.quality))
    global.panelMgr:setTextureFor(self.node_icon.icon,self.data.information.itemIcon  or self.data.information.icon)

    local nowMoney = tonumber( global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,""))

    if self.data.price ==0 then 
        self.btn_normal:setVisible(true)
        self.btn_discount:setVisible(false)
        self.normal_price_text:setString(self.data.cost)

        if  self.data.already_buy == 0  then
             global.colorUtils.turnGray(self.btn_normal,true)
        else
            global.colorUtils.turnGray(self.btn_normal,false)

            if  nowMoney >= self.data.cost then 
                self.normal_price_text:setTextColor(gdisplay.COLOR_WHITE)
            else 

                self.normal_price_text:setTextColor(gdisplay.COLOR_RED)
            end 
        end 

    else 
        self.btn_normal:setVisible(false)
        self.btn_discount:setVisible(true)
        self.oldprice_text:setString(self.data.price)
        self.newprice_text :setString(self.data.cost)

        if  self.data.already_buy == 0  then
             global.colorUtils.turnGray(self.btn_discount,true)
        else
            global.colorUtils.turnGray(self.btn_discount,false)

            if  nowMoney >= self.data.cost then 
                self.oldprice_text:setTextColor(gdisplay.COLOR_WHITE)
                self.newprice_text:setTextColor(gdisplay.COLOR_WHITE)
            else 
                self.oldprice_text:setTextColor(gdisplay.COLOR_RED)
                self.newprice_text:setTextColor(gdisplay.COLOR_RED)
            end 

        end 

    end 
end 

function UIShopTopItem:checkXianGou()
     -- if  self.data.limited ~= 0 then 
     --    global.ShopActionAPI:getTopReq(1,self.data.itemId,function(msg,ret)
     --         if ret.retcode ==0 then 
     --            self.data.surplus=msg.tgshopinfo[1].limite
     --             if self.data.surplus <= 0  then 
     --                global.tipsMgr:showWarning("你已超过购买上线")
     --             else           
     --                global.panelMgr:openPanel("UIBuyShopPanel"):setData(self.data)
     --             end
     --         end 
     --     end)
     -- else
     --     global. panelMgr:openPanel("UIBuyShopPanel"):setData(self.data)
     -- end 
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


function UIShopTopItem:onBuy(sender, eventType)
   self:checkXianGou()
end

function UIShopTopItem:onRmbBuy(sender, eventType)
    self:checkXianGou()
end

function UIShopTopItem:click_show_info(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIShopTopItem

--endregion
