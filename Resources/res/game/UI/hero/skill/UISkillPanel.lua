--region UISkillPanel.lua
--Author : Administrator
--Date   : 2017/03/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UISkillItem = require("game.UI.hero.skill.UISkillItem")
local UIItemBaseIcon = require("game.UI.common.UIItemBaseIcon")
--REQUIRE_CLASS_END

local UISkillPanel  = class("UISkillPanel", function() return gdisplay.newWidget() end )

function UISkillPanel:ctor()
    self:CreateUI()
end

function UISkillPanel:CreateUI()
    local root = resMgr:createWidget("hero/skill_strengthen_bg")
    self:initUI(root)
end

function UISkillPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/skill_strengthen_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.Node = self.root.Node_export
    self.bg = self.root.Node_export.bg_export
    self.node1 = self.root.Node_export.bg_export.node1_export
    self.skill_name_lv = self.root.Node_export.bg_export.node1_export.skill_name_lv_export
    self.skillitem = self.root.Node_export.bg_export.node1_export.skillitem_export
    self.skillitem = UISkillItem.new()
    uiMgr:configNestClass(self.skillitem, self.root.Node_export.bg_export.node1_export.skillitem_export)
    self.contentBuff = self.root.Node_export.bg_export.node1_export.contentBuff_export
    self.max_lv = self.root.Node_export.bg_export.node1_export.max_lv_export
    self.max_lock = self.root.Node_export.bg_export.node1_export.max_lock_export
    self.close_btn = self.root.Node_export.bg_export.node1_export.close_btn_export
    self.node2 = self.root.Node_export.bg_export.node2_export
    self.contentBuffDown = self.root.Node_export.bg_export.node2_export.contentBuffDown_export
    self.now_lv_icon = self.root.Node_export.bg_export.node2_export.contentBuffDown_export.now_lv_icon_export
    self.next_lv_icon = self.root.Node_export.bg_export.node2_export.contentBuffDown_export.next_lv_icon_export
    self.item_name = self.root.Node_export.bg_export.node2_export.item_name_export
    self.need_item_num = self.root.Node_export.bg_export.node2_export.need_item_num_export
    self.itemIcon = self.root.Node_export.bg_export.node2_export.itemIcon_export
    self.itemIcon = UIItemBaseIcon.new()
    uiMgr:configNestClass(self.itemIcon, self.root.Node_export.bg_export.node2_export.itemIcon_export)
    self.btn_lvup = self.root.Node_export.bg_export.node2_export.btn_lvup_export
    self.level_lock = self.root.Node_export.bg_export.node2_export.level_lock_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.close_btn, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_lvup, function(sender, eventType) self:uplevel(sender, eventType) end)
--EXPORT_NODE_END
end

function UISkillPanel:setBuffText(node,buffId,buffCount)
    
    local leagueCfg = luaCfg:get_data_type_by(buffId)
    local str = string.format("%s%s%s",buffCount,leagueCfg.str,leagueCfg.extra)
    node.pro_type:setString(leagueCfg.paraName .. "  ")
    node.base_pro:setString(str)

    global.tools:adjustNodePos(node.pro_type,node.base_pro)
end

function UISkillPanel:setData(index,heroData,isShare)

    self.heroData = heroData

    self.skillitem:setData(index,heroData)
    self.skillitem:closeTouch()    

    local skillType = heroData.skill[index]
    local skillLevel = heroData.openLv[index]   
    local skillConf = nil--luaCfg:get_skill_by(skillType)    
    local isNotOpen = false
    local isNoHero = not heroData.serverData.lSkill

    if heroData.serverData.lStar >= skillLevel then

        if heroData.serverData.lSkill then
            skillType = heroData.serverData.lSkill[index]              
        end            
    else
        
        isNotOpen = true
    end

    skillConf = luaCfg:get_skill_by(skillType)    

    self.skill_name_lv:setString(skillConf.name)
    -- self.skill_des:setString(skillConf.des or "no desc")

    self.now_lv_icon:setSpriteFrame("ui_surface_icon/icon_lv"..skillConf.lv .. ".png")
    self.next_lv_icon:setSpriteFrame("ui_surface_icon/icon_lv"..skillConf.lv + 1 .. ".png")
    self:setBuffText(self.contentBuff,skillConf.buff[1],skillConf.value[1])

    if skillConf.nextId == 0 or isNotOpen or isNoHero then

        self.bg:setContentSize(cc.size(540,300))
        self.node1:setPositionY(-359)
        self.node2:setVisible(false)        
        if isNoHero then
        
            self.max_lock:setVisible(true)
            self.max_lv:setVisible(false)
            self.max_lock:setString(luaCfg:get_local_string(10411,skillLevel))
        elseif not isNotOpen then

            self.max_lock:setVisible(false)
            self.max_lv:setVisible(true)
            self.max_lv:setString(luaCfg:get_local_string(10336))
        else

            self.max_lock:setVisible(true)
            self.max_lv:setVisible(false)
            self.max_lock:setString(luaCfg:get_local_string(10411,skillLevel))
        end

        return            
    else

        self.bg:setContentSize(cc.size(540,665))
        self.node1:setPositionY(0)
        self.node2:setVisible(true)
        self.max_lv:setVisible(false)
        self.max_lock:setVisible(false)
    end

    local nextConf = luaCfg:get_skill_by(skillType + 1)
   
    local itemCount = global.normalItemData:getItemById(nextConf.lvupItem).count
    if isShare then itemCount = 0 end
    
    self.isHaveEnouthBook = nextConf.itemNum <= itemCount
    self.need_item_num:setString(itemCount .. "/" .. nextConf.itemNum)
    self.itemIcon:setId(nextConf.lvupItem)
    self.item_name:setString(luaCfg:get_item_by(nextConf.lvupItem).itemName)    

    local leagueCfg = luaCfg:get_data_type_by(skillConf.buff[1])
    local str = string.format("%s%s%s",skillConf.value[1],leagueCfg.str,leagueCfg.extra)
    local nextStr = string.format("%s%s%s",nextConf.value[1],leagueCfg.str,leagueCfg.extra)
    self.contentBuffDown.pro_type:setString(leagueCfg.paraName)
    self.contentBuffDown.base_pro:setString(str)
    self.contentBuffDown.next_base_pro:setString(nextStr)

    self.contentSkillId = skillConf.skillId

    if heroData.serverData.lGrade < nextConf.heroLv then

        self.level_lock:setVisible(true)
        self.level_lock:setString(luaCfg:get_local_string(10437, nextConf.heroLv))
        self.btn_lvup:setEnabled(false)
    else
        self.level_lock:setVisible(false)
        self.btn_lvup:setEnabled(true)
    end    

    -- self:setBuffText(self.contentBuffDown,skillConf.buff[1],skillConf.value[1])
    -- self:setBuffText(self.nextBuff,nextConf.buff[1],nextConf.value[1])
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UISkillPanel:exit_call(sender, eventType)

    global.panelMgr:closePanelForBtn("UISkillPanel")
end

function UISkillPanel:uplevel(sender, eventType)

    if not self.isHaveEnouthBook then

        global.tipsMgr:showWarning("SkillBook01")
        return
    end

    local heroID = self.heroData.heroId
    global.commonApi:heroAction(heroID, 6, self.contentSkillId, 0, 0, function(msg)
        if msg and  msg.tgHero then 
            global.heroData:updateVipHero(msg.tgHero[1])   
        end 
        global.tipsMgr:showWarning("skilluplevelsuccess")
        global.panelMgr:closePanel("UISkillPanel")
    end) 
end

function UISkillPanel:exitCall(sender, eventType)

    global.panelMgr:closePanelForBtn("UISkillPanel")
end
--CALLBACKS_FUNCS_END

return UISkillPanel

--endregion
