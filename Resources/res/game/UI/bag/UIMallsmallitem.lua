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

local UIMallsmallitem  = class("UIMallsmallitem", function() return gdisplay.newWidget() end )
function UIMallsmallitem:ctor()
    self:CreateUI()
end

function UIMallsmallitem:CreateUI()
    local root = resMgr:createWidget("bag/shop_item")
    self:initUI(root)
end

function UIMallsmallitem:initUI(root)
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
    uiMgr:addWidgetTouchHandler(self.root.Button_1, function(sender, eventType) self:click_show_info(sender, eventType) end)
--EXPORT_NODE_END
    -- local function callback(ref, type)
    --     if type ==0 then
    --         local panel = global.panelMgr:getPanel("UIBagPanel") 
    --         panel.FileNode_1:setData(self.data)
    --         panel.FileNode_1:show()
    --         local  point= self.root.Button_1:convertToWorldSpace(cc.p(0,0))
    --     -- dump(point,"point----------------")
    --     -- dump(panel.FileNode_1.root.bg:getContentSize()," panel.FileNode_1-------------------")
    --     -- if self:CheckDirection() ==1 then
    --     --     local x  = point.x+ panel.FileNode_1.root.bg:getContentSize().width/2
    --     --     local y  =point.y+ panel.FileNode_1.root.bg:getContentSize().height
    --     --     print("x",x,'y',y)
    --     --     panel.FileNode_1:align(display.LEFT_BOTTOM,x,y)
    --     --  else
    --     --     local x  =point.x-30
    --     --     local y  =point.y+ panel.FileNode_1:getContentSize().height
    --     --     print("x",x,'y',y)
    --     --     panel.FileNode_1:align(display.LEFT_BOTTOM,x,y)
    --     -- end  
    --     -- dump(panel.FileNode_1:getPosition(),"panel.FileNode_1.getPosition()--------")
    --     local part = panel.FileNode_1.root.bg:getContentSize().width/2/2
    --     local height = panel.FileNode_1.root.bg:getContentSize().height/1.8
    --     panel.FileNode_1:setPosition(cc.p(display.width/2-part,point.y+height))
    --     global.panelMgr:getPanel("UIBagPanel").FileNode_1:setVisible(true)
    --     --panel.PanelToTips:runAction(cc.FadeIn:create(0.2))
    --     elseif type ==2 then
    --         global.panelMgr:getPanel("UIBagPanel").FileNode_1:setVisible(false)
    --     elseif type == 3 then
    --         global.panelMgr:getPanel("UIBagPanel").FileNode_1:setVisible(false)
    --     end
    --     return true 
    -- end
    -- self.root.Button_1:addTouchEventListener(callback)
    -- self.root.Button_1:setSwallowTouches(true)
end

function UIMallsmallitem:CheckDirection()
    local x =self.root.Button_1:convertToWorldSpace(cc.p(0,0)).x
    if x < gdisplay.width/2 then
        return 1 
    else 
        return 2 
    end  
end

function UIMallsmallitem:getIcon()
    return self.mall_icon_node 
end 


function UIMallsmallitem:setData(data)
    
    print(">>>tis is set data","hero_guide" .. data.itemId)

    self.root.bg:setName("hero_guide" .. data.itemId)

    self.data = data 
    self:updateUI()
    self.mall_icon_node:setData(data)

    self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,function() 
        self:updateUI()
   end)
end 

 
function UIMallsmallitem:longPressDeal(beganPoint,TipLayout)
    -- body

    local registerPanel =  global.panelMgr:getPanel("UIBagPanel").FileNode_1
    registerPanel:setVisible(true)
    registerPanel:runAction(cc.FadeIn:create(0.2))
    local layoutSize = registerPanel.root.bg:getContentSize()
    beganPoint.y = beganPoint.y + layoutSize.height/2 + 20

    local rightX = gdisplay.width - layoutSize.width/2
    if beganPoint.x >= rightX then
        beganPoint.x = rightX
    elseif (beganPoint.x - layoutSize.width/2) < 0 then
        beganPoint.x = layoutSize.width/2
    end

    local position = registerPanel.root.bg:convertToNodeSpace(cc.p(beganPoint.x, beganPoint.y))
    registerPanel:setPosition(cc.p( position.x, position.y))
end


function UIMallsmallitem:initTextTips(TipLayout)
      TipLayout:setData(self.data)
end


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIMallsmallitem:updateUI()

    local nowMoney = tonumber( global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,""))

    if self.data.price ==0 then 
        self.btn_normal:setVisible(true)
        self.btn_discount:setVisible(false)
        self.text1:setString(self.data.cost)

        if self.data.already_buy ==0 then
             global.colorUtils.turnGray(self.btn_normal,true)
        else
            global.colorUtils.turnGray(self.btn_normal,false)

            if  nowMoney >= self.data.cost then 
                self.text1:setTextColor(gdisplay.COLOR_WHITE)
            else 

                self.text1:setTextColor(gdisplay.COLOR_RED)
            end 
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

            if  nowMoney >= self.data.cost then 
                self.oldprice_text:setTextColor(gdisplay.COLOR_WHITE)
                self.newprice_text:setTextColor(gdisplay.COLOR_WHITE)
            else 
                self.oldprice_text:setTextColor(gdisplay.COLOR_RED)
                self.newprice_text:setTextColor(gdisplay.COLOR_RED)
            end 
        end 
    end 
 
   self.title:setString(self.data.name)
   -- self.mall_icon_node.icon:setSpriteFrame(self.data.information.itemIcon)
   -- self.mall_icon_node.icon_view:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",self.data.information.quality))
    global.panelMgr:setTextureFor(self.mall_icon_node.icon_view,string.format("icon/item/item_bg_0%d.png",self.data.information.quality))
    global.panelMgr:setTextureFor(self.mall_icon_node.icon,self.data.information.itemIcon or self.data.information.icon)
   if self.data.limited == 0 then 
        self.mall_icon_node.xian:setVisible(false )
    else
        self.mall_icon_node.xian:setVisible(true)
    end  
end


function UIMallsmallitem:checkXianGou()
    if tonumber(propData:getShowProp(WCONST.ITEM.TID.DIAMOND,"")) < self.data.cost then
         -- global.tipsMgr:showWarning("ItemUseDiamond")
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

function UIMallsmallitem:onBuy(sender, eventType)
        self:checkXianGou()
end

function UIMallsmallitem:onRmbBuy(sender, eventType)
       self:checkXianGou()
end

function UIMallsmallitem:click_show_info(sender, eventType)
    print(eventType)
end
--CALLBACKS_FUNCS_END

return UIMallsmallitem

--endregion
