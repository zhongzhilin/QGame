--region UIMysteriousItem.lua
--Author : anlitop
--Date   : 2017/03/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local propData = global.propData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMysteriousItem  = class("UIMysteriousItem", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")
function UIMysteriousItem:ctor()
    self:CreateUI()
end

function UIMysteriousItem:CreateUI()
    local root = resMgr:createWidget("random_shop/random_shop_node")
    self:initUI(root)
end

function UIMysteriousItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "random_shop/random_shop_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.parent_node = self.root.parent_node_export
    self.btn_magic_discount = self.root.parent_node_export.btn_magic_discount_export
    self.node_gray2 = self.root.parent_node_export.btn_magic_discount_export.node_gray2_export
    self.magic_discount_oldprice_text = self.root.parent_node_export.btn_magic_discount_export.magic_discount_oldprice_text_export
    self.magic_discount_newprice_text = self.root.parent_node_export.btn_magic_discount_export.magic_discount_newprice_text_export
    self.btn_magic_normal = self.root.parent_node_export.btn_magic_normal_export
    self.node_gray1 = self.root.parent_node_export.btn_magic_normal_export.node_gray1_export
    self.magic_normal_text = self.root.parent_node_export.btn_magic_normal_export.magic_normal_text_export
    self.btn_gold_normal = self.root.parent_node_export.btn_gold_normal_export
    self.node_gray1 = self.root.parent_node_export.btn_gold_normal_export.node_gray1_export
    self.gold_normal_text = self.root.parent_node_export.btn_gold_normal_export.gold_normal_text_export
    self.btn_gold_discount = self.root.parent_node_export.btn_gold_discount_export
    self.node_gray2 = self.root.parent_node_export.btn_gold_discount_export.node_gray2_export
    self.gold_discount_oldprice_text = self.root.parent_node_export.btn_gold_discount_export.gold_discount_oldprice_text_export
    self.gold_discount_newprice_text = self.root.parent_node_export.btn_gold_discount_export.gold_discount_newprice_text_export
    self.quit = self.root.parent_node_export.quit_export
    self.icon = self.root.parent_node_export.icon_export
    self.name_text = self.root.parent_node_export.name_text_export
    self.super_worth_sprite = self.root.parent_node_export.super_worth_sprite_export
    self.surprised_price_sprite = self.root.parent_node_export.surprised_price_sprite_export
    self.node_killed = self.root.parent_node_export.node_killed_export

    uiMgr:addWidgetTouchHandler(self.btn_magic_discount, function(sender, eventType) self:onmagic_discount_buy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_magic_normal, function(sender, eventType) self:onmagic_normal_buy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_gold_normal, function(sender, eventType) self:ongold_normal_buy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_gold_discount, function(sender, eventType) self:ongold_discount_buy(sender, eventType) end)
--EXPORT_NODE_END

 -- local function callback(ref, type)
 --        if type ==0 then
 --           -- if self:CheckDirection() then 
 --           -- elseif self:CheckDirection() then 
 --           -- else
 --           -- end 
 --            local panel = global.panelMgr:getPanel("UIMysteriousPanel") 
 --            panel.FileNode_1:setData(self.data)
 --            panel.FileNode_1:show()
 --            local  point= self.Button_1:convertToWorldSpace(cc.p(0,0)) 
 --            local part = panel.FileNode_1.root.bg:getContentSize().width/2/2
 --            local height = panel.FileNode_1.root.bg:getContentSize().height-15
 --            panel.FileNode_1:setPosition(cc.p(display.width/2-part,point.y+height))
 --            global.panelMgr:getPanel("UIMysteriousPanel").FileNode_1:setVisible(true)
 --            global.panelMgr:getPanel("UIMysteriousPanel").FileNode_1:runAction(cc.FadeIn:create(0.5))
 --        elseif type ==2 then
 --            global.panelMgr:getPanel("UIMysteriousPanel").FileNode_1:setVisible(false)
 --        elseif type == 3 then
 --            global.panelMgr:getPanel("UIMysteriousPanel").FileNode_1:setVisible(false)
 --        end
 --        return true 
 --    end
 --    self.Button_1:addTouchEventListener(callback)
 --    self.Button_1:setSwallowTouches(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIMysteriousItem:CheckDirection()
    local x =self.root.Button_1:convertToWorldSpace(cc.p(0,0)).x
    if x < gdisplay.width/2- self.Button_1:getContentSize().width then
        return 1 
    elseif x > gdisplay.width/2+self.Button_1:getContentSize().width then
        return 3
    else
        return 2 
    end 
end


function UIMysteriousItem:setData(data)
    self.data =data
    self:rotateEffect()
    self:updateUI()
    self.m_TipsControl = UIItemTipsControl.new()
    local tempdata ={information =data.information } 
    print('tempdata.information.tips_node',tempdata.information.tips_node)
    self.m_TipsControl:setdata(self.icon,tempdata,data.tips_node)
end 
  -- [1] = { ID=1,  itemId=10104,  name="1500粮食袋",  type=1,  price=0,  cost=15,  quality=0,  weight=1,  },


function UIMysteriousItem:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
    end 
end

function UIMysteriousItem:updateUI()

    self.name_text:setString(self.data.name)
    -- self.icon:setSpriteFrame(self.data.information.itemIcon)
    -- self.quit:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",self.data.information.quality))
    global.panelMgr:setTextureFor(self.icon,self.data.information.itemIcon or self.data.information.icon )
    global.panelMgr:setTextureFor(self.quit,string.format("icon/item/item_bg_0%d.png",self.data.information.quality))

    local temp = {self.icon  , self.quit  , self.btn_magic_discount  , self.btn_magic_normal , self.btn_gold_normal , self.btn_gold_discount} 
    for _ ,v in  pairs(temp) do 
        global.colorUtils.turnGray( v , self.data.lstate == 1 )
    end 


    if self.data.quality==0 then  -- 显示超值 或 其他
        self.super_worth_sprite:setVisible(false)
        self.surprised_price_sprite:setVisible(false)
    elseif self.data.quality==1 then 
        self.super_worth_sprite:setVisible(false)
        self.surprised_price_sprite:setVisible(true)
    elseif self.data.quality==2 then 
         self.super_worth_sprite:setVisible(true)
        self.surprised_price_sprite:setVisible(false)
    end 

    if self.data.type ==1  then  -- 消耗金币
         self.btn_magic_discount:setVisible(false)
         self.btn_magic_normal:setVisible(false)
        if self.data.price ==0 then 
            self.btn_gold_normal:setVisible(true)
            self.btn_gold_discount:setVisible(false)
            self.gold_normal_text:setString(self.data.cost)

            if self.data.lstate  ~= 1 then 
               if tonumber(propData:getShowProp(WCONST.ITEM.TID.GOLD,"")) >= self.data.cost then  -- 已开启
                    self.gold_normal_text:setTextColor(gdisplay.COLOR_WHITE)
                else   
                    self.gold_normal_text:setTextColor(gdisplay.COLOR_RED)
                end
            end 

        else 
            self.btn_gold_normal:setVisible(false)
            self.btn_gold_discount:setVisible(true)
            self.gold_discount_oldprice_text:setString(self.data.price)
            self.gold_discount_newprice_text:setString(self.data.cost)

            if self.data.lstate  ~= 1 then 
                if tonumber(propData:getShowProp(WCONST.ITEM.TID.GOLD,"")) >= self.data.cost then  -- 已开启
                    self.gold_discount_oldprice_text:setTextColor(gdisplay.COLOR_WHITE)
                    self.gold_discount_newprice_text:setTextColor(gdisplay.COLOR_WHITE)
                else   
                    self.gold_discount_oldprice_text:setTextColor(gdisplay.COLOR_RED)
                    self.gold_discount_newprice_text:setTextColor(gdisplay.COLOR_RED)
                end 
            end 

        end
    elseif self.data.type ==2  then --还是魔晶
        self.btn_gold_normal:setVisible(false)
        self.btn_gold_discount:setVisible(false)
        if self.data.price ==0 then 
            self.btn_magic_normal:setVisible(true)
            self.btn_magic_discount:setVisible(false)
            self.magic_normal_text:setString(self.data.cost)

            if self.data.lstate  ~= 1 then 
                if tonumber(propData:getShowProp(WCONST.ITEM.TID.DIAMOND,"")) >= self.data.cost then  -- 已开启
                    self.magic_normal_text:setTextColor(gdisplay.COLOR_WHITE)
                else   
                    self.magic_normal_text:setTextColor(gdisplay.COLOR_RED)
                end  
            end 
        else 
            self.btn_magic_normal:setVisible(false)
            self.btn_magic_discount:setVisible(true)
            self.magic_discount_oldprice_text:setString(self.data.price)
            self.magic_discount_newprice_text :setString(self.data.cost)

            if self.data.lstate  ~= 1 then 
                if tonumber(propData:getShowProp(WCONST.ITEM.TID.DIAMOND,"")) >= self.data.cost then  -- 已开启
                    self.magic_discount_oldprice_text:setTextColor(gdisplay.COLOR_WHITE)
                    self.magic_discount_newprice_text:setTextColor(gdisplay.COLOR_WHITE)
                else   
                    self.magic_discount_oldprice_text:setTextColor(gdisplay.COLOR_RED)
                    self.magic_discount_newprice_text:setTextColor(gdisplay.COLOR_RED)
                end
            end  
        end

    end

    self.node_killed:setVisible(self.data.lstate == 1 )
end

function UIMysteriousItem:rotateEffect()
    self.parent_node:runAction(cc.OrbitCamera:create(0,1,0,0,360,0,0))
    if  self.data.isrotate then 
        self.parent_node:runAction(cc.OrbitCamera:create(0.3,1,0,0,360,0,0))
        self.data.isrotate = nil
    end 
end 

function UIMysteriousItem:updateEffect()
     self.effect_node_1:stopAllActions()
     self.effect_node_2:stopAllActions()
    if self.data.quality==0 then  -- 显示超值 或 其他
        self.effect_node_1:setVisible(false)
        self.effect_node_2:setVisible(false)
    elseif self.data.quality==1 then 
        self.effect_node_1:setVisible(true)
        self.effect_node_2:setVisible(false)
        local nodeTimeLine =resMgr:createTimeline("citybuff/city_buff_effect")
        self.node_effect_1:runAction(nodeTimeLine)
        nodeTimeLine:play("animation0",true)
    elseif self.data.quality==2 then 
        self.effect_node_1:setVisible(false)
        self.effect_node_2:setVisible(true)
        local nodeTimeLine =resMgr:createTimeline("citybuff/city_buff_effect")
        self.node_effect_2:runAction(nodeTimeLine)
        nodeTimeLine:play("animation0",true)
    end 
end 

function UIMysteriousItem:checkMoney()

    if self.data.lstate  == 1 then 

        global.tipsMgr:showWarning("randomShopSaled")
        return 
    end 

    if self.data.type == 1 then -- 消耗金币
        if tonumber(propData:getGold()) < self.data.cost then
              global.tipsMgr:showWarning("ItemUseCoin")
        else
             global.panelMgr:openPanel("UIBuySteriousPanel"):setData(self.data)
        end 
    elseif self.data.type ==2 then 
        if tonumber(propData:getShowProp(WCONST.ITEM.TID.DIAMOND,"")) < self.data.cost then
               global.panelMgr:openPanel("UIRechargePanel")
        else
             global.panelMgr:openPanel("UIBuySteriousPanel"):setData(self.data)
         end 
    end 
end 

function UIMysteriousItem:onmagic_discount_buy(sender, eventType)
        self:checkMoney()
end 

function UIMysteriousItem:onmagic_normal_buy(sender, eventType)
        self:checkMoney()
end

function UIMysteriousItem:ongold_normal_buy(sender, eventType)
        self:checkMoney()
end

function UIMysteriousItem:ongold_discount_buy(sender, eventType)
        self:checkMoney()
end

function UIMysteriousItem:click_show_info(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIMysteriousItem

--endregion
