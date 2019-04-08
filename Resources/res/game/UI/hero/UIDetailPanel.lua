--region UIDetailPanel.lua
--Author : yyt
--Date   : 2016/09/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local gameEvent = global.gameEvent
local funcGame = global.funcGame
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIHeroNewNode = require("game.UI.hero.UIHeroNewNode")
local UIHeroExpItem = require("game.UI.hero.UIHeroExpItem")
local UISkillItem = require("game.UI.hero.skill.UISkillItem")
--REQUIRE_CLASS_END

local UIDetailPanel  = class("UIDetailPanel", function() return gdisplay.newWidget() end )

function UIDetailPanel:ctor()
    self:CreateUI()
end

function UIDetailPanel:CreateUI()
    local root = resMgr:createWidget("hero/hero_sec_bg")
    self:initUI(root)
end

function UIDetailPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_sec_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.hero_title = self.root.FileNode_1.hero_title_fnt_export
    self.layout_title = self.root.FileNode_1.layout_title_export
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.ps_node = self.root.ScrollView_1_export.ps_node_export
    self.FileNode_1_0 = UIHeroNewNode.new()
    uiMgr:configNestClass(self.FileNode_1_0, self.root.ScrollView_1_export.Slide_panel.details_bg_node.FileNode_1_0)
    self.txt_power = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.txt_power_export
    self.hero_name = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_name_export
    self.hero_Lv = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_Lv_mlan_7.hero_Lv_export
    self.hero_type = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_type_mlan_7.hero_type_export
    self.hero_grow = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_grow_mlan_7.hero_grow_export
    self.hero_attack = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_attack_mlan_7.hero_attack_export
    self.hero_defense = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_defense_mlan_7.hero_defense_export
    self.hero_interior = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_interior_mlan_7.hero_interior_export
    self.hero_commander = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_Commander_mlan_7.hero_commander_export
    self.hero_Commander = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_Commander_type_mlan_4.hero_Commander_export
    self.hero_icon = self.root.ScrollView_1_export.Slide_panel.details_bg_node.hero_icon_export
    self.expNode = self.root.ScrollView_1_export.Slide_panel.details_bg_node.expNode_export
    self.expNode = UIHeroExpItem.new()
    uiMgr:configNestClass(self.expNode, self.root.ScrollView_1_export.Slide_panel.details_bg_node.expNode_export)
    self.Skill_node = self.root.ScrollView_1_export.Slide_panel.details_bg_node.Skill_node_export
    self.skill_0 = UISkillItem.new()
    uiMgr:configNestClass(self.skill_0, self.root.ScrollView_1_export.Slide_panel.details_bg_node.Skill_node_export.skill_0)
    self.skill_1 = UISkillItem.new()
    uiMgr:configNestClass(self.skill_1, self.root.ScrollView_1_export.Slide_panel.details_bg_node.Skill_node_export.skill_1)
    self.skill_2 = UISkillItem.new()
    uiMgr:configNestClass(self.skill_2, self.root.ScrollView_1_export.Slide_panel.details_bg_node.Skill_node_export.skill_2)
    self.skill_3 = UISkillItem.new()
    uiMgr:configNestClass(self.skill_3, self.root.ScrollView_1_export.Slide_panel.details_bg_node.Skill_node_export.skill_3)
    self.skill_4 = UISkillItem.new()
    uiMgr:configNestClass(self.skill_4, self.root.ScrollView_1_export.Slide_panel.details_bg_node.Skill_node_export.skill_4)
    self.skill_5 = UISkillItem.new()
    uiMgr:configNestClass(self.skill_5, self.root.ScrollView_1_export.Slide_panel.details_bg_node.Skill_node_export.skill_5)
    self.xing1 = self.root.ScrollView_1_export.Slide_panel.details_bg_node.xing1_export
    self.xing2 = self.root.ScrollView_1_export.Slide_panel.details_bg_node.xing2_export
    self.xing3 = self.root.ScrollView_1_export.Slide_panel.details_bg_node.xing3_export
    self.xing4 = self.root.ScrollView_1_export.Slide_panel.details_bg_node.xing4_export
    self.xing5 = self.root.ScrollView_1_export.Slide_panel.details_bg_node.xing5_export
    self.xing6 = self.root.ScrollView_1_export.Slide_panel.details_bg_node.xing6_export
    self.right = self.root.ScrollView_1_export.Slide_panel.details_bg_node.right_export
    self.left = self.root.ScrollView_1_export.Slide_panel.details_bg_node.left_export
    self.hero_show_text = self.root.ScrollView_1_export.Slide_panel.hero_show_bg.hero_show_text_export
    self.Panel = self.root.Panel_export
    self.know_node = self.root.Panel_export.know_node_export
    self.toget_node = self.root.Panel_export.toget_node_export
    self.condition = self.root.Panel_export.toget_node_export.condition_export
    self.toget_btn_by_coin = self.root.Panel_export.toget_node_export.toget_btn_by_coin_export
    self.coin_gary = self.root.Panel_export.toget_node_export.toget_btn_by_coin_export.coin_gary_export
    self.coin_num = self.root.Panel_export.toget_node_export.toget_btn_by_coin_export.coin_num_export
    self.coin_icon = self.root.Panel_export.toget_node_export.toget_btn_by_coin_export.coin_icon_export
    self.toget_btn_by_diamond = self.root.Panel_export.toget_node_export.toget_btn_by_diamond_export_0
    self.diamand_gary = self.root.Panel_export.toget_node_export.toget_btn_by_diamond_export_0.diamand_gary_export
    self.diamond_num = self.root.Panel_export.toget_node_export.toget_btn_by_diamond_export_0.diamond_num_export
    self.diamond_icon = self.root.Panel_export.toget_node_export.toget_btn_by_diamond_export_0.diamond_icon_export
    self.get_node = self.root.Panel_export.get_node_export
    self.pay = self.root.Panel_export.get_node_export.pay_export
    self.cpay_oin_gary = self.root.Panel_export.get_node_export.pay_export.cpay_oin_gary_export
    self.getDesc = self.root.Panel_export.get_node_export.getDesc_mlan_14_export
    self.hero_get = self.root.Panel_export.hero_get_export
    self.intro_btn = self.root.intro_btn_export

    uiMgr:addWidgetTouchHandler(self.toget_btn_by_coin, function(sender, eventType) self:toget_coin_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.toget_btn_by_diamond, function(sender, eventType) self:toget_diamond_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.pay, function(sender, eventType) self:pay_handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.hero_get, function(sender, eventType) self:get_way_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.intro_btn, function(sender, eventType) self:infoCall(sender, eventType) end)
--EXPORT_NODE_END

    --滚动? 张亮
    uiMgr:initScrollText(self.hero_Commander)

    self.icon = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.icon

    self.titleNode = self.root.FileNode_1
    uiMgr:addWidgetTouchHandler(self.titleNode.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    -- local sizeHeight =gdisplay.height - self.layout_title:getContentSize().height - self.Panel:getContentSize().height
    self.scrollviewPanelNode = cc.Node:create()
    self.ScrollView_1:addChild(self.scrollviewPanelNode)
    -- self.ScrollView_1:setContentSize(cc.size(gdisplay.width, sizeHeight))
    -- self.ScrollView_1:setContentSize(cc.size(gdisplay.width, sizeHeight))
    self:adapt()

    self.HeroPanel = global.panelMgr:getPanel("UIHeroPanel")    


    -- self.ps_node = cc.Node:create()
    -- self.ps_node:setPosition( self.btn_Persuade:getPosition())
    -- self.root:addChild(self.ps_node)
   
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIDetailPanel:adapt()

    local sHeight =(gdisplay.height - 75)
    local defY = self.ScrollView_1:getContentSize().height
    self.ScrollView_1:setContentSize(cc.size(gdisplay.width, sHeight))
    local minsize= cc.size(gdisplay.width, defY)
    if sHeight < defY then 

    else
        self.ScrollView_1:setTouchEnabled(false)
        self.ScrollView_1:setInnerContainerSize(cc.size(gdisplay.width, sHeight))
        local tt =  self.ScrollView_1:getContentSize().height- self.ps_node:getPositionY()
        for _ ,v in pairs(self.ScrollView_1:getChildren()) do 
            v:setPositionY(v:getPositionY()+tt)
        end 
    end 
end 

function UIDetailPanel:onEnter()
    
    self.ScrollView_1:jumpToTop()

    self:addEventListener(gameEvent.EV_ON_UI_HERO_FLUSH,function()        
        
        self:setData(global.heroData:getHeroDataById(self.data.heroId))
    end)

    -- local nodeTimeLine =resMgr:createTimeline("effect/icon_zhaomu")
    -- self.btn_get:runAction(nodeTimeLine)
    -- nodeTimeLine:play("animation0",true)

end

function UIDetailPanel:showEffectForStarUp(openSkillIndex)
    
    global.uiMgr:addSceneModel(1.5)

    local csb = resMgr:createCsbAction('effect/hero_sj_star', 'animation0',false,true)        
    csb:setPosition(self.curXing:convertToWorldSpace(cc.p(24,24)))  
    global.scMgr:CurScene():addChild(csb,30)

    if openSkillIndex ~= -1 then

        local skill = self['skill_' .. openSkillIndex - 1]

        self:runAction(cc.Sequence:create(cc.DelayTime:create(1 / 60),cc.CallFunc:create(function()
            global.colorUtils.turnGray(skill,true)
        end),cc.DelayTime:create(0.65),cc.CallFunc:create(function()
            global.colorUtils.turnGray(skill,false)
            csb = resMgr:createCsbAction('effect/hero_sj_skill', 'animation0',false,true)        
            csb:setPosition(skill:convertToWorldSpace(cc.p(0,0)))  
            global.scMgr:CurScene():addChild(csb,30)
        end)))        
    end    
end

--col level1 skill add power
function UIDetailPanel:colSkillAddPower(data)
    
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

function UIDetailPanel:setData( data , isComeFromGird)
                
    -- dump(global.heroData:getVipHeroData())
    -- dump(global.heroData:getNormalHeroData())

    self.data = data

    dump(self.data ,"self.data ///")
    -- self.btn_Persuade:setEnabled(data.state == 0)

    self.hero_title:setString(data.name)
    self.intro_btn:setVisible(false)

    self.hero_get:setVisible(true)

    local serverData = self.data.serverData or {isMode = true,lPower = data.power + self:colSkillAddPower(data),lGrade = 1,lCurHP = data.hp,lCurEXP = 0,lStar = 1}
    --如果已经拥有，显示服务器数据，如果没有拥有，则显示默认数?
    serverData.lCurHP = serverData.lCurHP or 0
    self.txt_power:setString(serverData.lPower)
    self.hero_name:setString(data.name)
    self.hero_Lv:setString(serverData.lGrade) 
    -- self.hero_HP:setString(serverData.lCurHP .. "/" .. data.hp) 
    -- self.strengthBuy:setEnabled(not (serverData.isMode or serverData.lState == -1))
    -- self.hero_point:setVisible(global.heroData:CheckRedPoint(self.data.heroId))

    -- if serverData.lCurHP >= data.hp then self.strengthBuy:setTag(1) else self.strengthBuy:setTag(0) end

    -- self.strengthBuy:setPositionX(self.hero_HP:getContentSize().width + 134)
    self.hero_grow:setString(data.grow1) 

    -- self.icon:setPositionX(self.hero_name:getContentSize().width + self.hero_name:getPositionX() + 2) 
    -- self.txt_power:setPositionX(self.hero_name:getContentSize().width + self.hero_name:getPositionX() + 47) 

    if serverData.isMode then
        self.hero_attack:setString(data.attack) 
        self.hero_defense:setString(data.defense) 
        self.hero_interior:setString(data.interior) 
        self.hero_commander:setString(data.commander)
    else
        self.hero_attack:setString(global.heroData:getHeroProperty(data, 1)) 
        self.hero_defense:setString(global.heroData:getHeroProperty(data, 2)) 
        self.hero_interior:setString(global.heroData:getHeroProperty(data, 3)) 
        self.hero_commander:setString(global.heroData:getHeroProperty(data, 4))
    end        
    global.heroData:setHeroIconBg(data.heroId, self.left, self.right)
    
    local isBoss = (data.getType == 2 or data.getType == 3) and (not global.panelMgr:isPanelOpened('UIBuyHeroPanel'))
    serverData.lStar = serverData.lStar or 0
    local hero_strengthen = luaCfg:get_hero_strengthen_by(data.heroId)
    local max = hero_strengthen.maxStep
    self.curXing = nil
    for i = 1,6 do
        local star = self['xing' .. i]
        star:setVisible(i <= max)
        if serverData.lStar then 
            global.colorUtils.turnGray(star, i > serverData.lStar)
            if i == serverData.lStar + 1 then
                self.curXing = star
            end
        end 
    end
    self.hero_grow:setString(hero_strengthen['step' .. serverData.lStar])

    -- self.hero_icon:setSpriteFrame(data.nameIcon)
    global.panelMgr:setTextureFor(self.hero_icon,data.nameIcon)
    self.hero_show_text:setString(data.show)
    self.hero_type:setString(data.type)

    self.hero_Commander:setString(global.heroData:getCommanderStr(data))
    -- self.hero_commander:setPositionX(self.hero_Commander:getContentSize().width + 12)

    -- local i = 1
    -- for _,v in pairs(data.skill) do
    --     print (v)
    --     local skill = luaCfg:get_skill_by(v[1])
    --     self.Skill_node["Skill_"..i]:setSpriteFrame(skill.icon)
    --     i = i + 1
    -- end

    local tmpData = clone(data)
    tmpData.serverData = serverData

    self.FileNode_1_0:setData(tmpData)

    for i = 0,5 do

        self["skill_" .. i]:setData(i + 1,tmpData)
    end

    self.expNode:setData(serverData)

    -- self:startCountDown()

    -- self.btn_Stay:setVisible(false)
    -- self.btn_get:setVisible(false)
    -- self.btn_Persuade:setVisible(false)

    -- self.get_rolay_bt:setVisible(false)

    -- self.btn_Persuade:setPositionX(gdisplay.width/2)
    local gift_arr = global.luaCfg:gift()
    for _ ,v in pairs(gift_arr) do 
        if v.dropid == self.data.heroId  then 
            -- self.btn_Stay:setVisible(true)
            -- self.btn_Persuade:setPosition(self.ps_node:getPosition())
            break
        end 
    end    

    if isComeFromGird or true then

        -- print ( debug.getinfo(1).currentline )

        self.toget_node:setVisible(false)
        self.get_node:setVisible(true)
        -- self.detain_node:setVisible(false)
        self.know_node:setVisible(false)

        if data.state == 1 or data.state == 3 or data.state == 4 then
            self.getDesc:setString(luaCfg:get_local_string(10918))
            self.pay:setVisible(false)
            self.hero_get:setVisible(false)
        else
            if isBoss and false  then
                self.getDesc:setString('') -- 
                self.pay:setVisible(true)
            else
                self.getDesc:setString(luaCfg:get_local_string(10917)) -- 
                self.pay:setVisible(false)
            end            
        end
    else

        if  self.data.quality == 2 and (serverData.lState == -1 or self.data.state == 0 ) then -- epic hero

            self.get_rolay_bt:setVisible(true)

            self.toget_node:setVisible(false)            
            self.know_node:setVisible(false)
            self.get_node:setVisible(false)

        elseif data.state == 0 then
            
            if self.data.quality == 1 then

                self.condition:setString(luaCfg:get_target_condition_by(self.data.condition).description)

                self.toget_node:setVisible(true)
                -- self.detain_node:setVisible(false)
                self.know_node:setVisible(false)
                self.get_node:setVisible(false)
                local isCanBuy = global.funcGame:checkTarget(self.data.condition)


                if isCanBuy then

                    self.condition:setTextColor(cc.c3b(87,213,63)) 
                else

                    self.condition:setTextColor(cc.c3b(255,255,255))
                end

                self.isCanBuy = isCanBuy

                if self.data.costRes == 2 then

                    -- self.toget_btn_by_coin:setEnabled(isCanBuy)

                    global.colorUtils.turnGray(self.coin_gary,not self.isCanBuy)            

                    self.toget_btn_by_diamond:setVisible(false)
                    self.toget_btn_by_coin:setVisible(true)

                    self.coin_num:setString(self.data.costNum)
                elseif self.data.costRes == 6 then

                    global.colorUtils.turnGray(self.diamand_gary,not self.isCanBuy)            
                    -- self.toget_btn_by_diamond:setEnabled(isCanBuy)
                    
                    self.toget_btn_by_diamond:setVisible(true)
                    self.toget_btn_by_coin:setVisible(false)

                    self.diamond_num:setString(self.data.costNum)
                end 

                self.grace:setString("")
            else


                local impressData = luaCfg:get_hero_property_by(self.data.heroId)       
                self.maxImpress = impressData.impress
                self.grace:setString(luaCfg:get_local_string(10791,self.data.name,self.maxImpress))

                self.toget_node:setVisible(false)
                -- self.detain_node:setVisible(false)
                self.know_node:setVisible(true)
                self.get_node:setVisible(false)
            end        
        elseif data.state == 1 or data.state == 3 or data.state == 4 then

            self.toget_node:setVisible(false)
            self.get_node:setVisible(true)
            -- self.detain_node:setVisible(false)
            self.know_node:setVisible(false)

            self.getDesc:setString(luaCfg:get_local_string(10918)) -- 
        end
    end

    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.hero_attack:getParent(),self.hero_attack)
    global.tools:adjustNodePosForFather(self.hero_defense:getParent(),self.hero_defense)
    global.tools:adjustNodePosForFather(self.hero_interior:getParent(),self.hero_interior)
    global.tools:adjustNodePosForFather(self.hero_commander:getParent(),self.hero_commander)
   -- global.tools:adjustNodePosForFather(self.hero_Commander:getParent(),self.hero_Commander)
    global.tools:adjustNodePosForFather(self.hero_Commander:getScrollText():getParent(),self.hero_Commander:getParent()) 

    global.tools:adjustNodePosForFather(self.hero_Lv:getParent(),self.hero_Lv)
    global.tools:adjustNodePosForFather(self.hero_type:getParent(),self.hero_type)
    global.tools:adjustNodePosForFather(self.hero_grow:getParent(),self.hero_grow)
    


    
end

-- function UIDetailPanel:startCountDown()

--     local contentTime = global.dataMgr:getServerTime() 
--     local meetTime = contentTime
--     if self.data.serverData and self.data.serverData.lMeetTime then
--         meetTime = self.data.serverData.lMeetTime
--         -- print("meet time",meetTime)
--     end
    
--     self.m_restTime =  meetTime - contentTime
 
--     -- self:cutTimeHandler()
--     -- if self.m_countDownTimer then
--     -- else
--     --     self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.cutTimeHandler), 1)
--     -- end
-- end


function UIDetailPanel:getItemID()
    
    local items = luaCfg:item()
    for _,v in pairs(items) do

        if v.itemType == 123 and v.typePara1 == self.data.heroId then

            return v.itemId
        end
    end
end

-- function UIDetailPanel:cutTimeHandler()

--     self.m_restTime = self.m_restTime - 1

--     if self.m_restTime < 0 then     --不显示负的倒计?
    
--         self.m_restTime = 0
--     end

--     -- self.Text_time:setString(funcGame.formatTimeToHMS(self.m_restTime))    

-- end

function UIDetailPanel:stay_click(sender, eventType) --挽留

    if global.heroData:isFull() then

        global.tipsMgr:showWarning("207")
        
    else
        global.panelMgr:openPanel("UIStayDialog"):setData(self.data)
    end
end

function UIDetailPanel:persuade_click(sender, eventType) --说服

    -- global.tipsMgr:showWarning("NotOpen")

    print("fucj ///")

    global.panelMgr:openPanel("UIPersuadePanel"):setData(self.data)

    -- if  global.heroData:isCanRecruitHero() then
    --     global.tipsMgr:showWarning("HeroNumber")
    -- else
    --     local panel = global.panelMgr:openPanel("UIPromptPanel")
    --     panel:setData("HeroGet", handler(self, self.confirmCallBack))
    -- end
end

function UIDetailPanel:confirmCallBack( )
    
    self:exit_call()
    global.heroData:refershVipHeroState(self.data.heroId)
    self.HeroPanel:initNodeData()
end

function UIDetailPanel:exit_call(sender, eventType)

    global.panelMgr:closePanelForBtn("UIDetailPanel")  
end

function UIDetailPanel:onExit()
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end


function UIDetailPanel:know_call(sender, eventType)

    local itemId = self:getItemID()

    if global.normalItemData:getItemById(itemId).count > 0 then
    
        global.panelMgr:openPanel("UIBagUseSingle"):setData({id = itemId},function()
    
            global.tipsMgr:showWarningText(string.format(luaCfg:get_errorcode_by("KnowSuccess").text, self.data.name))        
        end)
    else
    
       global.panelMgr:openPanel("UIHeroNoOrder"):setData(nil, self.data.heroId)

    end   
end

function UIDetailPanel:toget_call(sender, eventType)

end
 
function UIDetailPanel:toget_coin_call(sender, eventType)
    
        
    if not self.isCanBuy then        
        global.tipsMgr:showWarning("CantRecuit")
        return
    end

    if global.propData:checkEnoughWithTips(WCONST.ITEM.TID.GOLD,self.data.costNum) then

       self:actionSender() 
    end
end

function UIDetailPanel:toget_diamond_call(sender, eventType)

        
    if not self.isCanBuy then        
        global.tipsMgr:showWarning("CantRecuit")
        return
    end

    if global.propData:checkEnoughWithTips(WCONST.ITEM.TID.DIAMOND,self.data.costNum) then
       
       self:actionSender() 
    end
end

function UIDetailPanel:actionSender()

    global.commonApi:heroAction(self.data.heroId, 3, 0, 0, 0, function(msg)
        
        global.panelMgr:openPanel("UIGotHeroPanel"):setData(self.data)
        
        -- global.tipsMgr:showWarningText(string.format(luaCfg:get_errorcode_by("GetHeroSuccess").text, self.data.name))
        global.heroData:updateVipHero(msg.tgHero[1])        
    end)    
end

function UIDetailPanel:addEnergy_click(sender, eventType)

    if sender:getTag() == 1 then
        global.tipsMgr:showWarning("FullHp")
        return
    end

    local heroID = self.data.heroId
    local panel = global.panelMgr:openPanel("UISpeedPanel")
    panel:setData(nil, 0, panel.TYPE_HERO_AGE, heroID)
end

function UIDetailPanel:infoCall(sender, eventType)

    local data = luaCfg:get_introduction_by(16)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end

function UIDetailPanel:onClickGetHero(sender, eventType)

    global.heroData:getHeroRequest(self.data)

end

function UIDetailPanel:get_Royal_Click(sender, eventType)

    global.panelMgr:openPanel("UIHeroNoOrder"):setData(nil, self.data.heroId)
        
end

function UIDetailPanel:pay_handler(sender, eventType)

    global.panelMgr:openPanel('UIBuyHeroPanel'):gps()
end

function UIDetailPanel:get_way_click(sender, eventType)

    local data ={}
    table.insert(data , global.luaCfg:get_hero_get_by(global.luaCfg:get_hero_property_by(self.data.heroId).heroGet))
    local panel = global.panelMgr:openPanel("UIHeroNoOrder")
    panel:setTitle("")
    panel.title:setString(gls(11149))
    panel.heroWay =true
    panel:updateData(data)

end
--CALLBACKS_FUNCS_END

return UIDetailPanel

--endregion
