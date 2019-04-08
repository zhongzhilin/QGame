--region UICommonHeroItem.lua
--Author : untory
--Date   : 2017/02/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UICommonHeroItem  = class("UICommonHeroItem", function() return gdisplay.newWidget() end )

function UICommonHeroItem:ctor()
   
   self:CreateUI() 
end

function UICommonHeroItem:CreateUI()
    local root = resMgr:createWidget("hero/common_hero_node")
    self:initUI(root)
end

function UICommonHeroItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/common_hero_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.head_icon = self.root.Button_1.head_icon_export
    self.soldier_type = self.root.Button_1.soldier_type_export
    self.type = self.root.Button_1.type_export
    self.grow = self.root.Button_1.grow_export
    self.condition = self.root.Button_1.condition_export
    self.left = self.root.Button_1.left_export
    self.right = self.root.Button_1.right_export
    self.loadingbar_bg = self.root.Button_1.loadingbar_bg_export
    self.LoadingBar = self.root.Button_1.LoadingBar_export
    self.info = self.root.Button_1.info_export
    self.hero_name = self.root.Button_1.hero_name_export
    self.hero_type = self.root.Button_1.hero_type_export
    self.buy_diamond_btn = self.root.Button_1.buy_diamond_btn_export
    self.diamand_gary = self.root.Button_1.buy_diamond_btn_export.diamand_gary_export
    self.diamond_num = self.root.Button_1.buy_diamond_btn_export.diamond_num_export
    self.buy_coin_btn = self.root.Button_1.buy_coin_btn_export
    self.coin_gary = self.root.Button_1.buy_coin_btn_export.coin_gary_export
    self.coin_num = self.root.Button_1.buy_coin_btn_export.coin_num_export
    self.coin_icon = self.root.Button_1.buy_coin_btn_export.coin_icon_export
    self.buy_exploit_btn = self.root.Button_1.buy_exploit_btn_export
    self.exploit_gary = self.root.Button_1.buy_exploit_btn_export.exploit_gary_export
    self.exploit_num = self.root.Button_1.buy_exploit_btn_export.exploit_num_export
    self.exploit_icon = self.root.Button_1.buy_exploit_btn_export.exploit_icon_export
    self.have = self.root.Button_1.have_export
    self.xing1 = self.root.Button_1.xing1_export
    self.xing2 = self.root.Button_1.xing2_export
    self.xing3 = self.root.Button_1.xing3_export
    self.xing4 = self.root.Button_1.xing4_export
    self.xing5 = self.root.Button_1.xing5_export
    self.xing6 = self.root.Button_1.xing6_export
    self.effect = self.root.effect_export

    uiMgr:addWidgetTouchHandler(self.buy_diamond_btn, function(sender, eventType) self:diamond_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.buy_coin_btn, function(sender, eventType) self:coin_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.buy_exploit_btn, function(sender, eventType) self:exploit_call(sender, eventType) end)
--EXPORT_NODE_END

    self.root.Button_1:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.root.Button_1:setSwallowTouches(false)
end

function UICommonHeroItem:setData(data)

    self.data = data

    self.root:stopAllActions()
    self.effect:setVisible(false)

    --新手引导
    self.buy_coin_btn:setName(self.buy_coin_btn:getName() .. data.heroId) 

    self.hero_name:setString(data.name)
    self.hero_type:loadTexture(data.typeIcon, ccui.TextureResType.plistType)
    self.soldier_type:loadTexture(data.soldierTypeIcon, ccui.TextureResType.plistType)    
    -- self.head_icon:setSpriteFrame(data.nameIcon)
    global.panelMgr:setTextureFor(self.head_icon,data.nameIcon)
    self.type:setString(global.heroData:getCommanderStr(data))
    
    local s = global.luaCfg:get_hero_strengthen_by(data.heroId)
    self.grow:setString(data.power + self:colSkillAddPower(data))

    print(data.condition,'data.condition',data.heroId)

    self.condition:setString(luaCfg:get_target_condition_by(data.condition).description)

    self.buy_coin_btn:setName("buy_coin_btn" .. data.heroId)

    self.isCanBuy = (data.isGetTarget.lCur / data.isGetTarget.lMax) >= 1 -- global.funcGame:checkTarget(data.condition)
    self.LoadingBar:setPercent(data.isGetTarget.lCur / data.isGetTarget.lMax * 100)    
    self.info:setString(data.isGetTarget.lCur .. '/' .. data.isGetTarget.lMax)
    if data.isGetTarget.lCur >= data.isGetTarget.lMax then
        self.info:setString(luaCfg:get_local_string(10985))
    end

    local starCount = 1
    if data.state == 1 or data.state == 3 or data.state == 4 then
        data.serverData = data.serverData or {}
        starCount = data.serverData.lStar or 1
    else
        starCount = 1
    end

    local hero_strengthen = luaCfg:get_hero_strengthen_by(data.heroId)
    local max = hero_strengthen.maxStep
    
    


    for i = 1,6 do
        local star = self['xing' .. i] 
        star:setVisible(i <= max)

        global.colorUtils.turnGray(star, i > starCount )
    end

    global.heroData:setHeroIconBg(data.heroId, self.left, self.right)
    if data.Strength and data.Strength == 3 then
        local nodeTimeLine = resMgr:createTimeline("hero/common_hero_node")
        nodeTimeLine:play("animation0", true)
        self.root:runAction(nodeTimeLine)
        self.effect:setVisible(true)
    end

    if self.isCanBuy then

        self.condition:setTextColor(cc.c3b(129,199,116)) 
    else

        self.condition:setTextColor(cc.c3b(212,67,67))
    end

    if not (data.state == 1 or data.state == 3 or data.state == 4) then

        self.have:setVisible(false)

        if data.costRes == 2 then

            -- self.buy_coin_btn:setEnabled(self.isCanBuy)
            global.colorUtils.turnGray(self.coin_gary,not self.isCanBuy)            

            self.buy_diamond_btn:setVisible(false)
            self.buy_exploit_btn:setVisible(false)            
            self.buy_coin_btn:setVisible(true)

            self.coin_num:setString(data.costNum)

            global.propData:checkEnoughWithColor(2,data.costNum,self.coin_num)
        elseif data.costRes == 6 then

            -- self.buy_diamond_btn:setEnabled(self.isCanBuy)

            global.colorUtils.turnGray(self.diamand_gary,not self.isCanBuy)            

            self.buy_diamond_btn:setVisible(true)
            self.buy_coin_btn:setVisible(false)
            self.buy_exploit_btn:setVisible(false)            

            self.diamond_num:setString(data.costNum)
            global.propData:checkEnoughWithColor(6,data.costNum,self.diamond_num)
        elseif data.costRes == 9 then

            -- self.buy_diamond_btn:setEnabled(self.isCanBuy)

            global.colorUtils.turnGray(self.exploit_gary,not self.isCanBuy)            

            self.buy_diamond_btn:setVisible(false)
            self.buy_coin_btn:setVisible(false)
            self.buy_exploit_btn:setVisible(true)            

            self.exploit_num:setString(data.costNum)
            global.propData:checkEnoughWithColor(9,data.costNum,self.exploit_num)
        end        
    else

        self.have:setVisible(true)

        self.buy_diamond_btn:setVisible(false)
        self.buy_coin_btn:setVisible(false)
        self.buy_exploit_btn:setVisible(false)
    end
end

function UICommonHeroItem:colSkillAddPower(data)
    
    local res = 0
    for i,v in ipairs(data.openLv) do

        if v == 1 then

            local skill = data.skill[i]
            local skillPower = luaCfg:get_skill_by(skill).combat
            res = res + skillPower
        end
    end

    return res
end

function UICommonHeroItem:actionSender()
        
    local data = clone(self.data)

    global.commonApi:heroAction(self.data.heroId, 3, 0, 0, 0, function(msg)

        global.panelMgr:openPanel("UIGotHeroPanel"):setData(data)
        -- global.tipsMgr:showWarningText(string.format(luaCfg:get_errorcode_by("GetHeroSuccess").text, self.data.name))
        global.heroData:updateVipHero(msg.tgHero[1])        
    end)    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UICommonHeroItem:diamond_call(sender, eventType)

    
    if not self.isCanBuy then        
        global.tipsMgr:showWarning("CantRecuit")
        return
    end

    if global.propData:checkEnoughWithTips(WCONST.ITEM.TID.DIAMOND,self.data.costNum) then
       
       self:actionSender() 
    end
end

function UICommonHeroItem:coin_call(sender, eventType)
    

    if not self.isCanBuy then        
        global.tipsMgr:showWarning("CantRecuit")
        return
    end

    if global.propData:checkEnoughWithTips(WCONST.ITEM.TID.GOLD,self.data.costNum) then

       self:actionSender() 
    end
end

function UICommonHeroItem:chooseHero(sender, eventType)

    -- if global.panelMgr:getPanel("UIHeroPanel").isMove then return end

    -- global.panelMgr:openPanel("UIDetailPanel"):setData(self.data)
end

function UICommonHeroItem:exploit_call(sender, eventType)

    if not self.isCanBuy then        
        global.tipsMgr:showWarning("CantRecuit")
        return
    end

    if global.propData:checkEnoughWithTips(WCONST.ITEM.TID.EXPLOIT,self.data.costNum) then

       self:actionSender() 
    end
end
--CALLBACKS_FUNCS_END

return UICommonHeroItem

--endregion
