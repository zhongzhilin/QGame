--region UIGarrionItem.lua
--Author : untory
--Date   : 2017/02/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local heroData = global.heroData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIGarrionItem  = class("UIGarrionItem", function() return gdisplay.newWidget() end )

function UIGarrionItem:ctor()
    
end

function UIGarrionItem:CreateUI()
    local root = resMgr:createWidget("hero/heroGarrisonWidget/heroGarrionItem")
    self:initUI(root)
end

function UIGarrionItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/heroGarrisonWidget/heroGarrionItem")

-- do not edit code in this region!!!! 
--EXPORT_NODE_BEGIN
    self.state1 = self.root.hero_list_node.state1_export
    self.condition = self.root.hero_list_node.state1_export.condition_export
    self.add_btn = self.root.hero_list_node.state1_export.add_btn_export_0
    self.state2 = self.root.hero_list_node.state2_export
    self.add_btn = self.root.hero_list_node.state2_export.add_btn_export
    self.state3 = self.root.hero_list_node.state3_export
    self.pic = self.root.hero_list_node.state3_export.choose_hero.choose_hero1.pic_export
    self.hero_name = self.root.hero_list_node.state3_export.choose_hero.choose_hero1.hero_name_export
    self.heroLv = self.root.hero_list_node.state3_export.choose_hero.choose_hero1.heroLv_export
    self.hero_quality = self.root.hero_list_node.state3_export.choose_hero.choose_hero1.hero_quality_export
    self.hero_epic = self.root.hero_list_node.state3_export.choose_hero.choose_hero1.hero_quality_export.hero_epic_export
    self.skill_node = self.root.hero_list_node.state3_export.choose_hero.skill_node_export
    self.lv = self.root.hero_list_node.state3_export.choose_hero.skill_node_export.skill_1.lv_export
    self.lv_icon = self.root.hero_list_node.state3_export.choose_hero.skill_node_export.skill_1.lv_icon_export
    self.lv = self.root.hero_list_node.state3_export.choose_hero.skill_node_export.skill_2.lv_export
    self.lv_icon = self.root.hero_list_node.state3_export.choose_hero.skill_node_export.skill_2.lv_icon_export
    self.lv = self.root.hero_list_node.state3_export.choose_hero.skill_node_export.skill_3.lv_export
    self.lv_icon = self.root.hero_list_node.state3_export.choose_hero.skill_node_export.skill_3.lv_icon_export
    self.lv = self.root.hero_list_node.state3_export.choose_hero.skill_node_export.skill_4.lv_export
    self.lv_icon = self.root.hero_list_node.state3_export.choose_hero.skill_node_export.skill_4.lv_icon_export
    self.lv = self.root.hero_list_node.state3_export.choose_hero.skill_node_export.skill_5.lv_export
    self.lv_icon = self.root.hero_list_node.state3_export.choose_hero.skill_node_export.skill_5.lv_icon_export
    self.lv = self.root.hero_list_node.state3_export.choose_hero.skill_node_export.skill_6.lv_export
    self.lv_icon = self.root.hero_list_node.state3_export.choose_hero.skill_node_export.skill_6.lv_icon_export
    self.skill_lock_node = self.root.hero_list_node.state3_export.choose_hero.skill_lock_node_export

    uiMgr:addWidgetTouchHandler(self.add_btn, function(sender, eventType) self:chooseHero(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.hero_list_node.state3_export.choose_hero, function(sender, eventType) self:choose_hero_call(sender, eventType) end)
--EXPORT_NODE_END

    self.add_btn:setZoomScale(WCONST.BUTTON_SCALE.MID)
    self.root.hero_list_node.state3_export.choose_hero:setZoomScale(WCONST.BUTTON_SCALE.MID)
end

function UIGarrionItem:setData(index)
        
    self.index = index

    if global.funcGame:checkTarget(luaCfg:get_hero_garrison_by(index).condition) then
        --条件满足

        local heroData = heroData:getHeroByGarrisonPos(self.index)
        self:setHeroIcon(heroData)
    else

        self:setState(1)
    end
end

function UIGarrionItem:setState(state)
    
    for i = 1,3 do

        self["state"..i]:setVisible(state == i) 
        
        if state == i then
            self["initState"..i](self)
        end        
    end
end

function UIGarrionItem:initState1()
   
   local data = luaCfg:get_target_condition_by(luaCfg:get_hero_garrison_by(self.index).condition)
   self.condition:setString(data.description)
end

function UIGarrionItem:initState2()
    
end

function UIGarrionItem:initState3()

    local heroData = self.heroData

    -- self.pic:setSpriteFrame(self.heroData.nameIcon)
    global.panelMgr:setTextureFor(self.pic,heroData.nameIcon)

    self.hero_quality:setVisible(heroData.Strength == 3)
    self.heroLv:setString("LV." .. heroData.serverData.lGrade)
    self.hero_name:setString(heroData.name)

    local skillCount = #heroData.skill
    local isStudyAnyOne = false
    for i = 1,6 do

        local skillNode = self.skill_node["skill_"..i]
        if i > skillCount then
            skillNode:setVisible(false)
        else
            skillNode:setVisible(true)

            local skillType = heroData.skill[i]
            local skillLevel = heroData.openLv[i]

            local skillConf = nil

            if heroData.serverData.lGrade >= skillLevel then
            --已激活
          
                isStudyAnyOne = true  
                global.colorUtils.turnGray(skillNode,false)        
                skillType = heroData.serverData.lSkill[i]           

                skillNode.lv_export:setVisible(false)
            else

                skillNode.lv_export:setVisible(true)
                skillNode.lv_export:setString("Lv" .. skillLevel)
                global.colorUtils.turnGray(skillNode,true)                                        
            end

            skillConf = luaCfg:get_skill_by(skillType)   
            if skillConf then

                -- skillNode.Skill_icon:setSpriteFrame(skillConf.icon)
                global.panelMgr:setTextureFor(skillNode.Skill_icon,skillConf.icon)
                skillNode.lv_icon_export:setSpriteFrame("ui_surface_icon/icon_lv"..skillConf.lv .. ".png")
                -- self.lv_icon:setSpriteFrame("ui_surface_icon/icon_lv"..skillConf.lv .. ".png")
            end    
        end
    end

    if not isStudyAnyOne then
        
        --一个技能都没有学习的情况        
            
        self.skill_lock_node:setVisible(true)
        -- self.skill_lock_node:setPositionY(25)
        self.skill_node:setPositionY(-26)
    else
        
        self.skill_lock_node:setVisible(false)
        self.skill_node:setPositionY(-41)
        -- self.skill_lock_node:setPositionY(25)
    end

    -- for i = 1,6 do

    --     -- self.skill_node["skill_"..i]:setVisible(false)

    --     global.colorUtils.turnGray(self.skill_node["skill_"..i],true)
    -- end

    -- dump(self.heroData.serverData.lSkill,"self.heroData.serverData.lSkill")
    -- dump(self.heroData,"self.heroData")

    -- for i,v in pairs(self.heroData.serverData.lSkill) do
    --     local skill = luaCfg:get_skill_by(v)
    --     if skill then
        
    --         -- self.skill_node["skill_"..i]:setVisible(true)
    --         global.colorUtils.turnGray(self.skill_node["skill_"..i],false)
    --         self.skill_node["skill_"..i].Skill_icon:setSpriteFrame(skill.icon)            


    --     end
    -- end
end

function UIGarrionItem:setHeroIcon(heroData)

    self.heroData = heroData

    if heroData then

        self:setState(3)
    else

        self:setState(2)
    end

    global.panelMgr:getPanel("UIHeroGarrisionPanel"):flushBuff()
end

function UIGarrionItem:getGovInfo()
    
    if self.heroData then

        return global.heroData:getHeroProperty(self.heroData,3)
        -- return self.heroData.serverData.lbase[3]
    end

    return 0
end

function UIGarrionItem:getHeroData()
    
    return self.heroData
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIGarrionItem:chooseHero(sender, eventType)

    local curHeroData = self.heroData

    local panel = global.panelMgr:openPanel("UISelectHeroPanel")
    panel:setData(0,0,true,global.heroData:getGovActiveHero(0))
    panel:setTarget(self)
    panel:setExitCall(function()
        
        if self.heroData then

            global.commonApi:heroAction(self.heroData.heroId, 5, self.index, 1, 0, function(msg)
        
                -- dump(msg,">>>>>hero action msg")
                global.heroData:updateVipHero(msg.tgHero[1])
            end)                 
        end        
    end)
end

function UIGarrionItem:choose_hero_call(sender, eventType)

    local curHeroData = self.heroData

    local panel = global.panelMgr:openPanel("UISelectHeroPanel")
    panel:setData(curHeroData.heroId,curHeroData.heroId,true,global.heroData:getGovActiveHero(curHeroData.heroId))
    panel:setTarget(self)
    panel:setExitCall(function()
        
        if self.heroData then

            global.commonApi:heroAction(self.heroData.heroId, 5, self.index, 1, 0, function(msg)
        
                -- dump(msg,">>>>>hero action msg")
                global.heroData:updateVipHero(msg.tgHero[1])
            end)
        else

            if curHeroData then
            
                global.commonApi:heroAction(curHeroData.heroId, 5, self.index, 0, 0, function(msg)
        
                    -- dump(msg,">>>>>hero action msg")
                    global.heroData:updateVipHero(msg.tgHero[1])
                end)
            end            
        end        
    end)
end
--CALLBACKS_FUNCS_END

return UIGarrionItem

--endregion
