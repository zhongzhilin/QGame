--region UIShareHero.lua
--Author : untory
--Date   : 2017/06/05
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local equipData = global.equipData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UISkillItem = require("game.UI.hero.skill.UISkillItem")
--REQUIRE_CLASS_END

local UIShareHero  = class("UIShareHero", function() return gdisplay.newWidget() end )

function UIShareHero:ctor()
    self:CreateUI()
end

function UIShareHero:CreateUI()
    local root = resMgr:createWidget("hero/hero_share_panel")
    self:initUI(root)
end

function UIShareHero:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_share_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.hero_title = self.root.hero_title_fnt_mlan_12_export
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.ps_node = self.root.ScrollView_1_export.ps_node_export
    self.txt_power = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.txt_power_export
    self.hero_name = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_name_export
    self.hero_Lv = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_Lv_mlan_7.hero_Lv_export
    self.hero_type = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_type_mlan_7.hero_type_export
    self.hero_grow = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_grow_mlan_7.hero_grow_export
    self.hero_attack = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_attack_mlan_5.hero_attack_export
    self.attack_buff = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_attack_mlan_5.attack_buff_export
    self.hero_defense = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_defense_mlan_5.hero_defense_export
    self.defense_buff = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_defense_mlan_5.defense_buff_export
    self.hero_interior = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_interior_mlan_5.hero_interior_export
    self.interior_buff = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_interior_mlan_5.interior_buff_export
    self.hero_commander = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_Commander_mlan_5.hero_commander_export
    self.commander_buff = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_Commander_mlan_5.commander_buff_export
    self.hero_Commander = self.root.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_Commander_type_mlan_5.hero_Commander_export
    self.hero_icon = self.root.ScrollView_1_export.Slide_panel.details_bg_node.hero_icon_export
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
    self.left = self.root.ScrollView_1_export.Slide_panel.details_bg_node.left_export
    self.right = self.root.ScrollView_1_export.Slide_panel.details_bg_node.right_export
    self.xing6 = self.root.ScrollView_1_export.Slide_panel.details_bg_node.xing6_export
    self.xing5 = self.root.ScrollView_1_export.Slide_panel.details_bg_node.xing5_export
    self.xing4 = self.root.ScrollView_1_export.Slide_panel.details_bg_node.xing4_export
    self.xing3 = self.root.ScrollView_1_export.Slide_panel.details_bg_node.xing3_export
    self.xing2 = self.root.ScrollView_1_export.Slide_panel.details_bg_node.xing2_export
    self.xing1 = self.root.ScrollView_1_export.Slide_panel.details_bg_node.xing1_export
    self.loadingbar_bg = self.root.ScrollView_1_export.Slide_panel.Node_new.loadingbar_bg_export
    self.LoadingBar = self.root.ScrollView_1_export.Slide_panel.Node_new.loadingbar_bg_export.LoadingBar_export
    self.info = self.root.ScrollView_1_export.Slide_panel.Node_new.loadingbar_bg_export.info_export
    self.icon = self.root.ScrollView_1_export.Slide_panel.Node_new.icon_export
    self.equipment_bg1 = self.root.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg1_export
    self.icon1 = self.root.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg1_export.iconParent.icon1_export
    self.strog = self.root.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg1_export.strog_export
    self.equipment_bg2 = self.root.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg2_export
    self.icon2 = self.root.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg2_export.iconParent.icon2_export
    self.strog = self.root.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg2_export.strog_export
    self.equipment_bg3 = self.root.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg3_export
    self.icon3 = self.root.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg3_export.iconParent.icon3_export
    self.strog = self.root.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg3_export.strog_export
    self.equipment_bg4 = self.root.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg4_export
    self.icon4 = self.root.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg4_export.iconParent.icon4_export
    self.strog = self.root.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg4_export.strog_export
    self.equipment_bg5 = self.root.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg5_export
    self.icon5 = self.root.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg5_export.iconParent.icon5_export
    self.strog = self.root.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg5_export.strog_export
    self.equipment_bg6 = self.root.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg6_export
    self.icon6 = self.root.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg6_export.iconParent.icon6_export
    self.strog = self.root.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg6_export.strog_export

--EXPORT_NODE_END

    uiMgr:initScrollText(self.hero_Commander)

    -- self.ScrollView_1:setContentSize(cc.size(gdisplay.width, gdisplay.height - 80))
    self:adapt()

    self.titleNode = self.root.common_title
    uiMgr:addWidgetTouchHandler(self.titleNode.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)


    for i=1,6 do
        self["icon"..i]:setSwallowTouches(false)        

        local light = resMgr:createWidget("effect/equip_ad_lv")        
        light:setPosition(cc.p(90,90))
        self["icon"..i]:addChild(light)
        self['light'..i] = light
    end  

    for i=1,6 do
        uiMgr:addWidgetTouchHandler(self["icon"..i], function(sender, eventType) self:equipItem_click(i,sender) end)        
    end  
end


function UIShareHero:adapt()

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

function UIShareHero:equipItem_click(index,icon)
    
  
    -- local heroId = self.chooseHeroData.heroId
    -- local tmpHeroData = self.chooseHeroData

    local curEquipData = self.otherEquipData[index]
    local equipId = curEquipData.id or curEquipData[1] -- equipData:getHeroEquipByIndex(self.chooseHeroData.heroId,index)
    if equipId == -1 then

        -- global.panelMgr:openPanel("UIEquipPanel"):setData(index,self.chooseHeroData.heroId)
        --     :setEquipInfo(true, 10392,false,function(data)
                
        --         global.itemApi:swapEquip(0,data.lID,heroId,index,function(msg)
            
        --             -- global.panelMgr:getPanel("UIHeroPanel"):showEquipEffect(data,tmpHeroData,msg.tgHero[1])
        --             global.panelMgr:closePanel("UIEquipPanel")
        --             global.heroData:updateVipHero(msg.tgHero[1])            
        --         end)
        -- end) 
    else
        
        local data = {lID = 0,_tmpData = {},lCombat = curEquipData.lCombat or global.heroData:getHeroLCombat(curEquipData.lv or curEquipData[2],equipId), lGID = equipId, lStronglv = curEquipData.lv or curEquipData[2],
        tgAttr = curEquipData.tgAttr or global.equipData:colServerAtt(curEquipData.lv or curEquipData[2],equipId)}
        global.equipData:bindConfData(data)
        dump(data,'.moni data')
        global.panelMgr:openPanel("UIEquipPutDown"):setData(data)
            :setEquipInfo(false,'',true)
    end    
end

function UIShareHero:getItemID(heroId)
    
    local items = luaCfg:item()
    for _,v in pairs(items) do

        if v.itemType == 123 and v.typePara1 == heroId then

            return v.itemId
        end
    end
end

function UIShareHero:setData(data)

    global.shareHeroData = data 

    data.serverData.lbase = data.serverData.lbase or global.heroData:getHeroLBase(data)

    self.chooseHeroData = data
    local heroPro = global.heroData:getHeroPropertyById(data.serverData.lID)
    local serverData = data.serverData
    heroPro.serverData = serverData

    self.hero_name:setString(heroPro.name)
    self.hero_type:setString(heroPro.type)
    self.hero_grow:setString(heroPro.grow1)     
    -- self.hero_icon:setSpriteFrame(heroPro.nameIcon)   
    global.panelMgr:setTextureFor(self.hero_icon,heroPro.nameIcon)

    self.txt_power:setString(serverData.lPower)
    self.hero_Lv:setString(serverData.lGrade) 
    -- self.hero_show_text:setString(heroPro.show)

    for i = 1,4 do

        local key = WCONST.BASE_PROPERTY[i].KEY
        local base = data[key]
        self["hero_"..key]:setString(serverData.lbase[i])
        self[key.."_buff"]:setString(string.format("+%s",serverData.lextra[i]))

        if serverData.lextra[i] == 0 then

            self[key.."_buff"]:setVisible(false)  
        else  
            self[key.."_buff"]:setVisible(true)  
        end

        if i == 4 then

            self.hero_Commander:setString(global.heroData:getCommanderStr(heroPro))
        end

        self[key.."_buff"]:setPosition(cc.p(5 +self["hero_"..key]:getContentSize().width + self["hero_"..key]:getPositionX() + self[key.."_buff"]:getContentSize().width / 2,11))        
    end

    local hero_strengthen = luaCfg:get_hero_strengthen_by(heroPro.heroId)
    local max = hero_strengthen.maxStep

    serverData.lStar = serverData.lStar or 1
    for i = 1,6 do
        local star = self['xing' .. i] 
        star:setVisible(i <= max)
        global.colorUtils.turnGray(star, i > serverData.lStar )
    end
    
    self.hero_grow:setString(hero_strengthen['step' .. serverData.lStar])  
    global.heroData:setHeroIconBg(heroPro.heroId, self.left, self.right)

    local itemId = self:getItemID(heroPro.heroId)
    local count = data.itemCount or 0
    local hero_strengthen = luaCfg:get_hero_strengthen_by(heroPro.heroId)    
    local key = 'item' .. (serverData.lStar + 1)
    local grow = 1
    if hero_strengthen[key] and #hero_strengthen[key] == 2 then
        dump(hero_strengthen[key],'hero_strengthen[key]')
        grow = hero_strengthen[key][2]
    end
    local maxStep = hero_strengthen.maxStep
    self.info:setString(count .. '/' .. grow)
    self.LoadingBar:setPercent(count / grow * 100)

    
    if serverData.lStar >= maxStep then
        self.info:setString(luaCfg:get_local_string(10928))
    end

    for i = 0,5 do

        self["skill_" .. i]:setData(i + 1,heroPro, true)
        -- self["skill_" .. i]:closeTouch()
    end

    local equipData = data.equipData
    self.otherEquipData = equipData
    for i = 1,6 do

        local bg = self["equipment_bg"..i]
        local icon = self["icon"..i]
        local light = self['light'..i]
        local strongText = bg.strog_export
        local oneData = equipData[i]

        if oneData then

            local confData = luaCfg:get_equipment_by(oneData.id or oneData[1])
            local lv = oneData.lv or oneData[2]
            strongText:setString(":" .. lv)            
            strongText:setVisible(lv > 0)
            
            bg["Sprite_"..i]:setVisible(false)
            
            -- bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",confData.quality))
            global.panelMgr:setTextureFor(bg,string.format("icon/item/item_bg_0%d.png",confData.quality))
            icon:loadTextureNormal(confData.icon) 
            icon:loadTexturePressed(confData.icon)
            icon:setVisible(true)

            global.funcGame:initEquipLight(light,lv)
        else

            light:setVisible(false)
            strongText:setVisible(false)
            bg:setSpriteFrame("ui_surface_icon/hero_equipment_bg.png")
            bg["Sprite_"..i]:setVisible(true)
            icon:setVisible(false)
        end
    end

    global.panelMgr:setTextureFor(self.icon,'icon/item/item_icon_' .. heroPro.heroId .. '.png')

    global.tools:adjustNodePosForFather(self.hero_attack:getParent(),self.hero_attack)
    global.tools:adjustNodePosForFather(self.hero_defense:getParent(),self.hero_defense)
    global.tools:adjustNodePosForFather(self.hero_interior:getParent(),self.hero_interior)
    global.tools:adjustNodePosForFather(self.hero_commander:getParent(),self.hero_commander)
    global.tools:adjustNodePosForFather(self.hero_Commander:getScrollText():getParent(),self.hero_Commander:getParent())
    global.tools:adjustNodePosForFather(self.hero_Lv:getParent(),self.hero_Lv)
    global.tools:adjustNodePosForFather(self.hero_type:getParent(),self.hero_type)
    global.tools:adjustNodePosForFather(self.hero_grow:getParent(),self.hero_grow)


    global.tools:adjustNodePos(self.hero_attack,self.attack_buff)
    global.tools:adjustNodePos(self.hero_defense,self.defense_buff)    
    global.tools:adjustNodePos(self.hero_interior,self.interior_buff)    
    global.tools:adjustNodePos(self.hero_commander,self.commander_buff)


    self.ScrollView_1:jumpToTop()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIShareHero:exit_call()
    
    local isSkipLoad = nil
    if global.panelMgr:isPanelOpened("UIPKPanel") then
        isSkipLoad = true
    end
    global.panelMgr:closePanelForBtn("UIShareHero", nil, isSkipLoad)

end


function UIShareHero:onExit() 

    global.shareHeroData = nil 
end 


--CALLBACKS_FUNCS_END

return UIShareHero

--endregion
