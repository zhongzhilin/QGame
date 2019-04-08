--region UIBuyHeroItem.lua
--Author : anlitop
--Date   : 2017/11/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBuyHeroItem  = class("UIBuyHeroItem", function() return gdisplay.newWidget() end )

function UIBuyHeroItem:ctor()
    self:CreateUI()
end

function UIBuyHeroItem:CreateUI()
    local root = resMgr:createWidget("gift/gift_hero_list")
    self:initUI(root)
end

function UIBuyHeroItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "gift/gift_hero_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.img = self.root.img_export
    self.name = self.root.name_export
    self.btn_magic_discount = self.root.btn_magic_discount_export
    self.oldPrice = self.root.btn_magic_discount_export.oldPrice_export
    self.linePic = self.root.btn_magic_discount_export.oldPrice_export.linePic_export
    self.arrowhead = self.root.btn_magic_discount_export.arrowhead_export
    self.gift_discount_newprice_text = self.root.btn_magic_discount_export.gift_discount_newprice_text_export
    self.grow1 = self.root.grow_mlan_11.grow1_export
    self.quality1 = self.root.quality_mlan_11.quality1_mlan_4_export
    self.type_icon = self.root.type_icon_export
    self.commander1 = self.root.commander_mlan_5.commander1_export
    self.node_killed = self.root.node_killed_export
    self.discount_node = self.root.discount_node_export
    self.time = self.root.discount_node_export.time_export
    self.hero_buy = self.root.hero_buy_mlan_18_export

    uiMgr:addWidgetTouchHandler(self.btn_magic_discount, function(sender, eventType) self:bt_gift_discount_buy(sender, eventType) end)
--EXPORT_NODE_END


    self.hero_buy_mlan =self.hero_buy
    

end


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

    
function UIBuyHeroItem:setData(data)

    self.data = data 

    if self.data.banner  and self.data.banner ~= "" then 

        global.panelMgr:setTextureFor(self.img, self.data.banner)
    end 

    -- self.type_icon:setSpriteFrame(self.data.banner)


    self.oldPrice:setString(self.data.unit..self.data.price)

    self.linePic:setContentSize(cc.size(self.oldPrice:getContentSize().width, self.linePic:getContentSize().height))

    self.gift_discount_newprice_text:setString(self.data.unit..self.data.cost)

    local hero =global.luaCfg:get_hero_property_by(self.data.dropid)

    if not hero then 
        return
    end 
    self.name:setString(hero.name)

    if hero.Strength == 2 then --史诗
        self.quality1:setString(gls(11125))

        self.quality1:setTextColor(cc.c3b(232, 67, 237))


    elseif  hero.Strength == 3 then --传说

        self.quality1:setString(gls(11124))

        self.quality1:setTextColor(cc.c3b(255, 120, 54))
    end 


    self.grow1:setString(hero.power + self:colSkillAddPower(hero))

    self.type_icon:setSpriteFrame(hero.typeIcon)

    self.commander1:setString(global.heroData:getCommanderStr(hero))

     self.node_killed:setVisible(global.heroData:isGotHero(hero.heroId))

     self.btn_magic_discount:setVisible(not global.heroData:isGotHero(hero.heroId))


     global.tools:adjustNodePosForFather(self.grow1:getParent() , self.grow1)
     global.tools:adjustNodePosForFather(self.quality1:getParent() , self.quality1)
     global.tools:adjustNodePosForFather(self.commander1:getParent() , self.commander1)



    if not self.timer then 
        self.timer = gscheduler.scheduleGlobal(handler(self,self.updateOverTime), 1)
    end

    self:updateOverTime()


    local isDisscount =  table.hasval(global.heroData:getDisscountHero(), self.data.id)

    self.discount_node:setVisible(isDisscount)
    self.hero_buy_mlan:setVisible(isDisscount)

    self.oldPrice:setVisible(isDisscount)
    self.arrowhead:setVisible(isDisscount)

    if isDisscount then 
        global.tools:adjustNodePos(self.arrowhead,self.oldPrice ,-5)
        global.tools:adjustNodePos(self.arrowhead , self.gift_discount_newprice_text)
    else
        global.tools:adjustNodeMiddle(self.gift_discount_newprice_text)
    end 
end 


function UIBuyHeroItem:onExit()

    self:cleanTimer()

end 


function UIBuyHeroItem:updateOverTime()

    local time =  -1 

    time = global.heroData:getDisscountHeroTime() - global.dataMgr:getServerTime()
    
    if table.hasval(global.heroData:getDisscountHero(), self.data.id)  and time >= 0  then 

      self.time:setString(global.vipBuffEffectData:getDayTime(time))

    else 
        self:cleanTimer()
    end 

end 

function UIBuyHeroItem:cleanTimer()

   if self.timer then
        gscheduler.unscheduleGlobal(self.timer)
        self.timer = nil
    end
end 


function UIBuyHeroItem:colSkillAddPower(data)
    
    local res = 0
    for i,v in ipairs(data.openLv) do

        if v == 1 then

            local skill = data.skill[i]            
            local skillPower = global.luaCfg:get_skill_by(skill).combat
            res = res + skillPower
        end
    end

    return res
end
function UIBuyHeroItem:isGot(id)

    for _ ,v  in  pairs( global.heroData:getGotHeroData() ) do 

        if v.heroId == id then 

            return true
        end 
    end 

    return false
end 


function UIBuyHeroItem:bt_gift_discount_buy(sender, eventType)
    
    global.sdkBridge:app_sdk_pay(self.data.id,function()

        global.panelMgr:openPanel("UIGotHeroPanel"):setData(global.luaCfg:get_hero_property_by(self.data.dropid))

    end)
    
end
--CALLBACKS_FUNCS_END

return UIBuyHeroItem

--endregion
