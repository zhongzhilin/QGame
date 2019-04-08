--region UIHeroStarUp.lua
--Author : Untory
--Date   : 2017/11/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIHeroStarUpPro = require("game.UI.hero.UIHeroStarUpPro")
--REQUIRE_CLASS_END

local UIHeroStarUp  = class("UIHeroStarUp", function() return gdisplay.newWidget() end )

function UIHeroStarUp:ctor()
    self:CreateUI()
end

function UIHeroStarUp:CreateUI()
    local root = resMgr:createWidget("hero/hero_star_up")
    self:initUI(root)
end

function UIHeroStarUp:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_star_up")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.bg = self.root.Node_export.bg_export
    self.node1 = self.root.Node_export.bg_export.node1_export
    self.effect = self.root.Node_export.bg_export.effect_export
    self.node2 = self.root.Node_export.bg_export.node2_export
    self.proNode = self.root.Node_export.bg_export.node2_export.proNode_export
    self.pro1 = UIHeroStarUpPro.new()
    uiMgr:configNestClass(self.pro1, self.root.Node_export.bg_export.node2_export.proNode_export.pro1)
    self.pro2 = UIHeroStarUpPro.new()
    uiMgr:configNestClass(self.pro2, self.root.Node_export.bg_export.node2_export.proNode_export.pro2)
    self.pro3 = UIHeroStarUpPro.new()
    uiMgr:configNestClass(self.pro3, self.root.Node_export.bg_export.node2_export.proNode_export.pro3)
    self.pro4 = UIHeroStarUpPro.new()
    uiMgr:configNestClass(self.pro4, self.root.Node_export.bg_export.node2_export.proNode_export.pro4)
    self.pro5 = UIHeroStarUpPro.new()
    uiMgr:configNestClass(self.pro5, self.root.Node_export.bg_export.node2_export.proNode_export.pro5)
    self.icon = self.root.Node_export.bg_export.icon_export
    self.icon1 = self.root.Node_export.bg_export.icon1_export
    self.ownValue = self.root.Node_export.bg_export.ownValue_export
    self.ownValue_next = self.root.Node_export.bg_export.ownValue_next_export
    self.xing1 = self.root.Node_export.bg_export.xing1_export
    self.xing2 = self.root.Node_export.bg_export.xing2_export
    self.xing3 = self.root.Node_export.bg_export.xing3_export
    self.xing4 = self.root.Node_export.bg_export.xing4_export
    self.xing5 = self.root.Node_export.bg_export.xing5_export
    self.xing6 = self.root.Node_export.bg_export.xing6_export
    self.upxing1 = self.root.Node_export.bg_export.upxing1_export
    self.upxing2 = self.root.Node_export.bg_export.upxing2_export
    self.upxing3 = self.root.Node_export.bg_export.upxing3_export
    self.upxing4 = self.root.Node_export.bg_export.upxing4_export
    self.upxing5 = self.root.Node_export.bg_export.upxing5_export
    self.upxing6 = self.root.Node_export.bg_export.upxing6_export
    self.pro = self.root.Node_export.pro_mlan_10_export
    self.up_btn = self.root.Node_export.up_btn_export
    self.skill = self.root.Node_export.skill_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.up_btn, function(sender, eventType) self:up_star(sender, eventType) end)
--EXPORT_NODE_END
end

function UIHeroStarUp:setData(data,isEnoughItem,topPanelName)
    
    self.topPanelName = topPanelName

    self.data = data

    local star = data.serverData.lStar
    local nextStar = star + 1

    for i = 1,6 do
        self['xing' .. i]:setVisible(i <= star)
    end

    for i = 1,6 do
        self['upxing' .. i]:setVisible(i <= nextStar)
    end

    local nextBase = global.heroData:colHeroPro(data.heroId,data.serverData.lGrade,data.serverData.lStar + 1)    

    local hero_str = luaCfg:get_hero_strengthen_by(data.heroId)
    self.pro1:setData(luaCfg:get_local_string(10926),hero_str['step' .. star],hero_str['step' .. nextStar])

    local needDeletePower = 0
    local needAddPower = 0
    for i = 1,3 do

        local key = WCONST.BASE_PROPERTY[i].LOCAL_STR
        if data.serverData.lbase then 
            self['pro' .. i + 1]:setData(luaCfg:get_local_string(key),data.serverData.lbase[i],nextBase[i])    
            needDeletePower = needDeletePower + data.serverData.lbase[i]
            needAddPower = needAddPower + nextBase[i]
        end 
    end

    self.pro5:setData(luaCfg:get_local_string(10386),data.serverData.lbase[4],nextBase[4])    
    needDeletePower = needDeletePower + math.floor(data.serverData.lbase[4] / 10)
    needAddPower = needAddPower + math.floor(nextBase[4] / 10)

    self.ownValue:setString(data.serverData.lPower)

    local heroData = luaCfg:get_hero_property_by(data.heroId)
    local openSkillIndex = -1
    for i,v in ipairs(heroData.openLv) do
        if v == nextStar then
            openSkillIndex = i
        end
    end

    if openSkillIndex == -1 then
        self.skill:setVisible(false)
        self.pro:setVisible(false)
        self.openSkillIndex = -1
    else

        self.openSkillIndex = openSkillIndex
        self.skill:setVisible(true)
        self.pro:setVisible(true)
        local skillId = heroData.skill[openSkillIndex] 
        local skillConf = luaCfg:get_skill_by(skillId)
        if skillConf then
            global.panelMgr:setTextureFor(self.skill.Skill_icon,skillConf.icon)
            needAddPower = needAddPower + skillConf.combat
        end
    end

    self.ownValue_next:setString(data.serverData.lPower - needDeletePower + needAddPower)

    -- 因为最多只会激活一个技能，所以可以这样处理
    -- local newMap = {}
    -- for _,v in ipairs(nextData.serverData.lSkill) do
    --     if v ~= 0 then
    --         newMap[v] = true
    --     end
    -- end

    -- for _,v in ipairs(data.serverData.lSkill) do
    --     if v ~= 0 then
    --         newMap[v] = nil
    --     end
    -- end

    -- local newKey = nil
    -- for key,v in pairs(newMap) do
    --     newKey = key
    -- end

    -- print(newKey)    


    self.isEnoughItem = isEnoughItem 

    global.colorUtils.turnGray(self.up_btn, not (self.isEnoughItem and global.heroData:isHeroCanUpStar(data.heroId)))

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIHeroStarUp:exitCall(sender, eventType)

    global.panelMgr:closePanelForBtn('UIHeroStarUp')
end

function UIHeroStarUp:up_star(sender, eventType)

    
    if not self.isEnoughItem then

        global.tipsMgr:showWarning('noItemForUpdate')
        return
    end

    local state  , lv , star = global.heroData:isHeroCanUpStar(self.data.heroId)

    if not state then

        global.tipsMgr:showWarning(global.luaCfg:get_translate_string(11154 , lv , star))

        return
    end

    global.commonApi:heroAction(self.data.heroId, 7, 0, 0, 0, function(msg)
    
        if self.topPanelName == 'UIHeroPanel' or self.topPanelName == 'UIDetailPanel' then
            global.panelMgr:getPanel(self.topPanelName):showEffectForStarUp(self.openSkillIndex)
        end        
    
        global.tipsMgr:showWarning('Heroascend')        
        global.heroData:updateVipHero(msg.tgHero[1])
        global.panelMgr:closePanel('UIHeroStarUp')
    end) 
end
--CALLBACKS_FUNCS_END

return UIHeroStarUp

--endregion
