--region UISkillItem.lua
--Author : Administrator
--Date   : 2017/03/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISkillItem  = class("UISkillItem", function() return gdisplay.newWidget() end )

function UISkillItem:ctor()
    
end

function UISkillItem:CreateUI()
    local root = resMgr:createWidget("hero/hero_skill_node")
    self:initUI(root)
end

function UISkillItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_skill_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.skill_node1 = self.root.skill_node1_export
    self.Skill_bg = self.root.skill_node1_export.Skill_bg_export
    self.Skill_icon = self.root.skill_node1_export.Skill_bg_export.Skill_icon_export
    self.lv_icon = self.root.skill_node1_export.Skill_bg_export.lv_icon_export
    self.spReadState = self.root.skill_node1_export.Skill_bg_export.spReadState_export
    self.skill_node2 = self.root.skill_node2_export
    self.lockbtn = self.root.skill_node2_export.lockbtn_export

    uiMgr:addWidgetTouchHandler(self.Skill_bg, function(sender, eventType) self:jnCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.lockbtn, function(sender, eventType) self:lockcall(sender, eventType) end)
--EXPORT_NODE_END
end

function UISkillItem:setData(index,heroData, isShare)

    self.index = index 
    self.data = heroData  
    self.isShare = isShare

    local skillCount = #heroData.skill
    if index > skillCount then

        self.skill_node2:setVisible(true)
        self.skill_node1:setVisible(false)
        self.spReadState:setVisible(false)
    else

        local skillType = heroData.skill[index]
        local skillLevel = heroData.openLv[index]   

        self.skill_node2:setVisible(false)
        self.skill_node1:setVisible(true)

        local skillConf = nil
        local isActive = false

        heroData.serverData =  heroData.serverData or {} 
        if heroData.serverData.lStar and heroData.serverData.lStar >= skillLevel then
            --已激活
            
            global.colorUtils.turnGray(self.Skill_icon,false)
        
            -- self.lv:setVisible(false)

            if heroData.serverData.lSkill then
                skillType = heroData.serverData.lSkill[index]              
            end

            isActive = true            
        else

            global.colorUtils.turnGray(self.Skill_icon,true)
            
            -- self.lv:setVisible(true)            
            -- self.lv:setString("Lv" .. skillLevel)

            self.spReadState:setVisible(false)
        end

        print('skillType',skillType)
        skillConf = luaCfg:get_skill_by(skillType)   
        if skillConf then

            -- self.Skill_icon:setSpriteFrame(skillConf.icon)
            global.panelMgr:setTextureFor(self.Skill_icon,skillConf.icon)
            self.lv_icon:setSpriteFrame("ui_surface_icon/icon_lv"..skillConf.lv .. ".png")
            
            if isActive then

                if skillConf.nextId == 0 then
                    self.spReadState:setVisible(false)
                else

                    local nextConf = luaCfg:get_skill_by(skillType + 1)
                    local isHaveEnouthBook = nextConf.itemNum <= global.normalItemData:getItemById(nextConf.lvupItem).count                    
                    self.spReadState:setVisible(isHaveEnouthBook and heroData.serverData.lGrade and heroData.serverData.lGrade >= nextConf.heroLv)
                end                
            end            
        else

            self.spReadState:setVisible(false)
        end                 
    end

    if isShare then
        self.spReadState:setVisible(false)
    end
end

function UISkillItem:closeTouch()
    self.Skill_bg:setTouchEnabled(false)
    self.lockbtn:setTouchEnabled(false)
    self.spReadState:setVisible(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UISkillItem:jnCall(sender, eventType)

    local panelSkill = global.panelMgr:openPanel("UISkillPanel")
    panelSkill:setData(self.index,self.data,self.isShare)    

    if self.isShare then
        panelSkill.level_lock:setVisible(false)
        panelSkill.btn_lvup:setVisible(false)
    end 
end

function UISkillItem:lockcall(sender, eventType)

    global.tipsMgr:showWarning("skilllock")
end
--CALLBACKS_FUNCS_END

return UISkillItem

--endregion
