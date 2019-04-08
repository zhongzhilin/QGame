--region UIHeroNode4.lua
--Author : Untory
--Date   : 2018/03/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIHeroStarList = require("game.UI.hero.UIHeroStarList")
--REQUIRE_CLASS_END

local UIHeroNode4  = class("UIHeroNode4", function() return gdisplay.newWidget() end )

function UIHeroNode4:ctor()
    
end

function UIHeroNode4:CreateUI()
    local root = resMgr:createWidget("hero/hero_come_node")
    self:initUI(root)
end

function UIHeroNode4:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_come_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.top_node = self.root.ScrollView_1_export.top_node_export
    self.poolBtn = self.root.ScrollView_1_export.top_node_export.poolBtn_export
    self.intro_btn = self.root.ScrollView_1_export.top_node_export.intro_btn_export
    self.no_hero = self.root.ScrollView_1_export.no_hero_mlan_export
    self.nolv_hero = self.root.ScrollView_1_export.nolv_hero_mlan_export
    self.bottom_node = self.root.ScrollView_1_export.bottom_node_export
    self.have_hero = self.root.ScrollView_1_export.have_hero_export
    self.center_node = self.root.ScrollView_1_export.have_hero_export.center_node_export
    self.loadingbar_bg = self.root.ScrollView_1_export.have_hero_export.center_node_export.loadingbar_bg_export
    self.LoadingBar = self.root.ScrollView_1_export.have_hero_export.center_node_export.loadingbar_bg_export.LoadingBar_export
    self.info = self.root.ScrollView_1_export.have_hero_export.center_node_export.loadingbar_bg_export.info_export
    self.overtime_text = self.root.ScrollView_1_export.have_hero_export.center_node_export.reset_mlan.overtime_text_export
    self.hero_name = self.root.ScrollView_1_export.have_hero_export.center_node_export.hero_name_export
    self.hero_icon = self.root.ScrollView_1_export.have_hero_export.center_node_export.Node_56.hero_icon_export
    self.left = self.root.ScrollView_1_export.have_hero_export.center_node_export.Node_56.left_export
    self.right = self.root.ScrollView_1_export.have_hero_export.center_node_export.Node_56.right_export
    self.effect_node = self.root.ScrollView_1_export.have_hero_export.center_node_export.effect_node_export
    self.hero_type = self.root.ScrollView_1_export.have_hero_export.center_node_export.hero_type_export
    self.strengthBuy = self.root.ScrollView_1_export.have_hero_export.center_node_export.strengthBuy_export
    self.expBuy = self.root.ScrollView_1_export.have_hero_export.center_node_export.expBuy_export
    self.stars = UIHeroStarList.new()
    uiMgr:configNestClass(self.stars, self.root.ScrollView_1_export.have_hero_export.center_node_export.stars)
    self.change_node = self.root.ScrollView_1_export.have_hero_export.change_node_export
    self.chat = self.root.ScrollView_1_export.have_hero_export.change_node_export.chat_export
    self.beer = self.root.ScrollView_1_export.have_hero_export.change_node_export.beer_export
    self.food = self.root.ScrollView_1_export.have_hero_export.change_node_export.food_export
    self.chat_hp = self.root.ScrollView_1_export.have_hero_export.chat_hp_mlan.chat_hp_export
    self.beer_hp = self.root.ScrollView_1_export.have_hero_export.beer_hp_mlan.beer_hp_export
    self.food_hp = self.root.ScrollView_1_export.have_hero_export.food_hp_mlan.food_hp_export
    self.time_text = self.root.ScrollView_1_export.have_hero_export.time_mlan.time_text_export

    uiMgr:addWidgetTouchHandler(self.poolBtn, function(sender, eventType) self:gotoPool(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.intro_btn, function(sender, eventType) self:info_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.strengthBuy, function(sender, eventType) self:addEnergy_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.expBuy, function(sender, eventType) self:addExp_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.chat, function(sender, eventType) self:action1(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.beer, function(sender, eventType) self:action2(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.food, function(sender, eventType) self:action3(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView_1_export.have_hero_export.start1_btn, function(sender, eventType) self:start1_game(sender, eventType) end)
--EXPORT_NODE_END

    self:adapt()

    global.uiMgr:setRichText(self,'nolv_hero',50340)


end

function UIHeroNode4:adapt()
    -- self.top_node:setPositionY(gdisplay.height)
    if gdisplay.height < self.ScrollView_1:getContentSize().height then 
        self.ScrollView_1:setContentSize(cc.size(self.ScrollView_1:getContentSize().width ,  gdisplay.height-150))
    else 
        self.effect_node:setLocalZOrder(1)
        self.bottom_node:setPositionY(1280 - gdisplay.height)
        self.have_hero:setPositionY(1280 - gdisplay.height)
        self.center_node:setPositionY(795+gdisplay.height-1280)
    end
end 

function UIHeroNode4:onEnter()
    self.effect_node:removeAllChildren()
    self.center_node:setScale(1,1)
    self.isplayingEffect = false 
    self:restplayEffect()
    self.nolv_hero:setVisible(false)
    self.no_hero:setVisible(false)

    self.ScrollView_1:jumpToTop()
end

function UIHeroNode4:onExit()
    self:restplayEffect()
end 

function UIHeroNode4:setData(data)

    -- dump(data ,"data")

    self.expBuy:setVisible(false)

    self.data = data    
    if self.isplayingEffect then return end --cant update when play effect 
    if data == nil then
        -- no hero can be persufade
        local t = global.cityData:getBuildingById(15)
        if t.serverData and t.serverData.lGrade < 5  then 
            self.nolv_hero:setVisible(true)
        else
            self.no_hero:setVisible(true)
        end 

        self.have_hero:setVisible(false)
        return
    end

    self.have_hero:setVisible(true)
    self.serverData = data.serverData
    self.hero_name:setString(data.name)
    --global.uiMgr:setRichText(self,'hero_name',50331,{key_1 = data.name})
    -- print(self.hero_name:getContentSize().width,'hero_name:getRichTextSize().width')
    --self.strengthBuy:setPositionX(self.hero_name:getContentSize().width / 2 + 50)
    self.hero_type:loadTexture(self.data.typeIcon,ccui.TextureResType.plistType)
    global.panelMgr:setTextureFor(self.hero_icon,data.nameIcon) 
    global.funcGame:dealHeroRect(self,data)

    self:startCheckTime()

    local impressData = luaCfg:get_hero_impression_by(self.data.heroId)
    self.impressData = impressData
    self.maxImpress = impressData.impression
    self.info:setString(self.serverData.lImpress .. '/' .. self.maxImpress)
    self.LoadingBar:setPercent(self.serverData.lImpress / self.maxImpress * 100)

    self.chat_hp:setString(luaCfg:get_hero_persuade_by(1).impression .. '-' .. luaCfg:get_hero_persuade_by(1).maxImpression)
    self.beer_hp:setString(luaCfg:get_hero_persuade_by(2).impression .. '-' .. luaCfg:get_hero_persuade_by(2).maxImpression)
    self.food_hp:setString(luaCfg:get_hero_persuade_by(3).impression .. '-' .. luaCfg:get_hero_persuade_by(3).maxImpression)

    global.tools:adjustNodePosForFather(self.chat_hp:getParent(),self.chat_hp)
    global.tools:adjustNodePosForFather(self.beer_hp:getParent(),self.beer_hp)
    global.tools:adjustNodePosForFather(self.food_hp:getParent(),self.food_hp)

    self.strengthBuy:setVisible(self:isCanFlush())

    self.stars:setData(self.data.heroId,1)
end

function UIHeroNode4:isCanFlush()
    local barLevel = self:getBarLevel()
    local bar_unlock_data = luaCfg:hero_unlock()
    local heroData = global.heroData
    local count = 0
    for _,v in ipairs(bar_unlock_data) do
        if #v.hero > 0 and barLevel >= v.lv then
            local heroId = v.hero[1][1]
            local singleHeroData = heroData:getHeroDataById(heroId)
            if not (singleHeroData.state == 1 or singleHeroData.state == 3 or singleHeroData.state == 4) then
                count = count + 1
            end
        end
    end

    return count >= 2
end

function UIHeroNode4:getBarLevel()
    local buildData = global.cityData:getTopLevelBuild(15)    
    if buildData then
        return buildData.serverData.lGrade
    end
    return 0
end

function UIHeroNode4:startCheckTime()

    self:checkTime()
    self:schedule(function()
        self:checkTime()
    end,1)
end

function UIHeroNode4:checkTime()
    
    local endTime = self.serverData.lMeetTime
    local contentTime = global.dataMgr:getServerTime()
    local cutTime = endTime - contentTime
    local persuadeTime = global.heroData:getPersuadeTime()
    self.m_restTime = persuadeTime - contentTime

    if persuadeTime == 0 then
        self.m_restTime = 0
    end

    self.time_text:getParent():setVisible(self.m_restTime ~= 0)
    global.colorUtils.turnGray(self.change_node,self.m_restTime ~= 0)

    local str = global.funcGame.formatTimeToDHMS(cutTime)
    self.overtime_text:setString(str)
    self.time_text:setString(global.funcGame.formatTimeToDHMS(self.m_restTime))
    global.tools:adjustNodePosForFather(self.overtime_text:getParent(),self.overtime_text)
end

function UIHeroNode4:addGiftEffect()
    local child = resMgr:createCsbAction('effect/hero_sf_songli','animation0',false,true)    
    -- child:setPosition(cc.p(gdisplay.width / 2,gdisplay.height / 2))
    self.effect_node:addChild(child)

    gevent:call(gsound.EV_ON_PLAYSOUND,'hero_say_4')
end

function UIHeroNode4:doAction(actionType)

    if self.m_restTime > 0 then

        global.tipsMgr:showWarning("HeroPersuading")
    else

        local actionCall = function()

            local data = self.data 

            global.commonApi:heroAction(data.heroId, 2, actionType, 0, 0, function(msg)
            
                msg = msg or {}

                local paths = {'hero_sf_talk','hero_sf_xiaozuo','hero_sf_yanqin'}
                local child = resMgr:createCsbAction('effect/' .. paths[actionType],'animation0',false,true)    
                -- child:setPosition(cc.p(gdisplay.width / 2,gdisplay.height / 2))
                self.effect_node:addChild(child)

                gevent:call(gsound.EV_ON_PLAYSOUND,'hero_say_' .. actionType)

                local preImpress = data.serverData.lImpress

                if msg.tgHero and msg.tgHero[1] then
                    global.heroData:updateVipHero(msg.tgHero[1])
                end

                local addImpress = msg.tgHero[1].lImpress - preImpress

                if msg.tgHero and msg.tgHero[1].lState == 0 then --0表示成功

                    global.panelMgr:openPanel("UIGotHeroPanel"):setData(data)
                    -- local csb = resMgr:createCsbAction("effect/talk_hero", "animation0", false, true)
                    -- uiMgr:configUITree(csb)
                    -- csb.hero.hero_pick:setSpriteFrame(data.nameIcon)
                    -- csb.hero.Text_47:setString(string.format(luaCfg:get_errorcode_by("PersuadeSuccess").text, data.name))
                    -- csb:setLocalZOrder(31)
                    -- csb:setPosition(cc.p(gdisplay.width / 2,gdisplay.height / 2))
                    -- global.scMgr:CurScene():addChild(csb)
                    -- global.tipsMgr:showWarningText(string.format(luaCfg:get_errorcode_by("PersuadeSuccess").text, data.name))
                else

                    if global.heroData:isFull() then
                        global.tipsMgr:showWarning("HeroPersuadeLimit")
                    else
                        global.tipsMgr:showWarning("PersuadeFailed",data.name,addImpress)                        
                    end                    
                end
            end)
        end

        if global.heroData:isFull() then

            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("HeroMaxConfirm", actionCall)
        else

            actionCall()
        end        
    end    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIHeroNode4:start1_game(sender, eventType)
    local actionCall = function()
        
        local panel = global.panelMgr:openPanel("UISpeedPanel")
        panel:setData(nil, 0, panel.TYPE_HERO_GIFT, self.data.heroId)
    end

    if global.heroData:isFull() then

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData("HeroMaxConfirm", actionCall)
    else

        actionCall()
    end
end

function UIHeroNode4:onClickTaskHandler(sender, eventType)

end

function UIHeroNode4:action1(sender, eventType)
    self:doAction(1)
end

function UIHeroNode4:action2(sender, eventType)
    self:doAction(2)
end

function UIHeroNode4:action3(sender, eventType)
    self:doAction(3)
end

function UIHeroNode4:gotoPool(sender, eventType)
    global.panelMgr:openPanel('UIHeroComePool')
end

function UIHeroNode4:addEnergy_click(sender, eventType)

    local panel = global.panelMgr:openPanel("UICommonUseDiamond")
    local diamond = luaCfg:get_config_by(1).resetHero
    panel:setData(luaCfg:get_local_string(11142),luaCfg:get_local_string(11143,diamond),diamond,function()
            -- self.center_node:runAction(cc.Sequence:create(cc.ScaleTo:create(0.15,0,1),cc.ScaleTo:create(0.15,1,1)))
            self.isplayingEffect = true 
            global.itemApi:diamondUse(function (msg)
                self:playEffect()
                global.delayCallFunc(function()
                    self.isplayingEffect = false 
                    if self.setData and global.panelMgr:isPanelOpened("UIHeroPanel") then 
                        self:setData(self.data)
                    end 
                end, 0 , 1.1)
            end, 17)
    end)
end

function UIHeroNode4:playEffect()
    gevent:call(gsound.EV_ON_PLAYSOUND,"hero_get_1")
    self.nodeTimeLine =resMgr:createTimeline("hero/hero_come_node")
    self.root:runAction(self.nodeTimeLine)
    self.nodeTimeLine:play("animation0",false)
end 

function UIHeroNode4:restplayEffect()
    if self.nodeTimeLine and not tolua.isnull(self.nodeTimeLine) then 
        self.nodeTimeLine:gotoFrameAndPause(0)
    end 
end 

function UIHeroNode4:info_click(sender, eventType)
local data = luaCfg:get_introduction_by(44)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end

function UIHeroNode4:addExp_click(sender, eventType)

    local panel = global.panelMgr:openPanel("UICommonUseDiamond")
    local diamond = luaCfg:get_config_by(1).resetHero
    panel:setData(luaCfg:get_local_string(11145),luaCfg:get_local_string(10337,self.impressData.DetainTime / 60),self.impressData.DiamondCost,function()
        global.commonApi:heroAction(self.data.heroId, 1, 0, 0, 0, function(msg)
        
           
            -- global.tipsMgr:showWarningText(string.format(luaCfg:get_errorcode_by("GetHeroSuccess").text, self.data.name))
            global.tipsMgr:showWarning('DetainSuccess',self.data.name)
            global.heroData:updateVipHero(msg.tgHero[1])        
        end)
    end)
end
--CALLBACKS_FUNCS_END

return UIHeroNode4

--endregion
