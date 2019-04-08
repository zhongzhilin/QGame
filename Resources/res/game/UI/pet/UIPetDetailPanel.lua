--region UIPetDetailPanel.lua
--Author : yyt
--Date   : 2018/02/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPetStar1 = require("game.UI.pet.UIPetStar1")
--REQUIRE_CLASS_END

local UIPetDetailPanel  = class("UIPetDetailPanel", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

function UIPetDetailPanel:ctor()
    self:CreateUI()
end

function UIPetDetailPanel:CreateUI()
    local root = resMgr:createWidget("pet/pet_info")
    self:initUI(root)
end

function UIPetDetailPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.commonNode = self.root.Node_export.commonNode_export
    self.petTypet = self.root.Node_export.commonNode_export.petTypet_mlan_6_export
    self.petType = self.root.Node_export.commonNode_export.petTypet_mlan_6_export.petType_export
    self.petLvt = self.root.Node_export.commonNode_export.petLvt_mlan_6_export
    self.petStar = self.root.Node_export.commonNode_export.petLvt_mlan_6_export.petStar_export
    self.petStar = UIPetStar1.new()
    uiMgr:configNestClass(self.petStar, self.root.Node_export.commonNode_export.petLvt_mlan_6_export.petStar_export)
    self.powRankt = self.root.Node_export.commonNode_export.powRankt_mlan_10_export
    self.powRank = self.root.Node_export.commonNode_export.powRankt_mlan_10_export.powRank_export
    self.battleNode = self.root.Node_export.commonNode_export.battleNode_export
    self.battle = self.root.Node_export.commonNode_export.battleNode_export.battle_export
    self.ownert = self.root.Node_export.commonNode_export.ownert_mlan_6_export
    self.owner = self.root.Node_export.commonNode_export.ownert_mlan_6_export.owner_export
    self.skill4 = self.root.Node_export.skill.skill4_export
    self.sIcon4 = self.root.Node_export.skill.skill4_export.sIcon4_export
    self.skill3 = self.root.Node_export.skill.skill3_export
    self.sIcon3 = self.root.Node_export.skill.skill3_export.sIcon3_export
    self.skill2 = self.root.Node_export.skill.skill2_export
    self.sIcon2 = self.root.Node_export.skill.skill2_export.sIcon2_export
    self.skill1 = self.root.Node_export.skill.skill1_export
    self.sIcon1 = self.root.Node_export.skill.skill1_export.sIcon1_export
    self.Node_Attr = self.root.Node_export.Node_Attr_export
    self.label = self.root.Node_export.Node_Attr_export.label_export
    self.att4 = self.root.Node_export.Node_Attr_export.att4_export
    self.att1 = self.root.Node_export.Node_Attr_export.att1_export
    self.att5 = self.root.Node_export.Node_Attr_export.att5_export
    self.att2 = self.root.Node_export.Node_Attr_export.att2_export
    self.att6 = self.root.Node_export.Node_Attr_export.att6_export
    self.att3 = self.root.Node_export.Node_Attr_export.att3_export
    self.portrait_node = self.root.Node_export.portrait_node_export
    self.headFrame = self.root.Node_export.portrait_node_export.headFrame_export

    uiMgr:addWidgetTouchHandler(self.root.Panel, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.skill4, function(sender, eventType) self:skill3Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.skill3, function(sender, eventType) self:skill3Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.skill2, function(sender, eventType) self:skill2Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.skill1, function(sender, eventType) self:skill1Handler(sender, eventType) end)
--EXPORT_NODE_END

    self.tips_node = cc.Node:create()
    self.root:addChild(self.tips_node)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIPetDetailPanel:setData(data)

    dump(data, " ==> UIPetDetailPanel: ")

    -- 头像
    local petConfig = luaCfg:get_pet_type_by(tonumber(data.szParams[1]))
    local tempPet = global.petData:getPetConfig(tonumber(data.szParams[1]), data.lValue)
    local head = {}
    head.path = petConfig["iconRank"..tempPet.growingPhase]
    head.scale = 83
    global.tools:setCircleAvatar(self.portrait_node, head)
    self.petType:setString(tempPet.name .. " (".. tempPet.phaseName ..")")
    self.powRankt:setVisible(false)
    self.commonNode:setPositionY(0)
    self.battleNode:setPositionY(38)
    local spliteStr = '&'
    if data.lRank then
        spliteStr = '|'
        self.commonNode:setPositionY(20)
        self.battleNode:setPositionY(0)
        self.powRankt:setVisible(true)
        self.powRank:setString(data.lRank)
    end
    self.owner:setString(data.szParams[2] or "-")

    -- 设置星星
    global.tools:adjustNodePosForFather(self.petStar:getParent(),self.petStar)
    self.petStar:setData(data.lValue)
  
    -- 属性
    for i=1,6 do
        self["att"..i]:setVisible(false)
        local skill = global.petData:getPetPropertyClient(tempPet.propertyValueClient)
        if skill[i] then
            self["att"..i]:setVisible(true)
            local skillD = tempPet.propertyValue
            local dataType = luaCfg:get_data_type_by(skillD[i][1])
            self["att"..i]:setString(skill[i][1] .. ":+" .. skill[i][2]/100 .. dataType.extra)

            -- 超框适配处理
            if i == 1 or i == 4 then
            else
                local preAtt = self["att"..(i-1)]
                self.label:setString(preAtt:getString())
                local prePosY = preAtt:getPositionY()
                local labH = self.label:getContentSize().height
                local labW = self.label:getContentSize().width
                if labW > preAtt:getContentSize().width then -- 换行
                    labH = preAtt:getContentSize().height
                end
                self["att"..i]:setPositionY(prePosY-labH)
            end
        end
    end

    -- 技能
    local blockId = 0
    local isHaveUnion = data.szParams and ((#data.szParams) > 8)
    local skillIdTemp = {}
    if isHaveUnion then
        skillIdTemp = global.tools:strSplit(data.szParams[10] or "", spliteStr) 
        self.battle:setString(data.szParams[9])
        blockId = tonumber(data.szParams[8] or 0)     
    else
        skillIdTemp = global.tools:strSplit(data.szParams[7] or "", spliteStr) 
        self.battle:setString(data.szParams[6])
        blockId = tonumber(data.szParams[5] or 0)   
    end

    -- 头像框
    self.headFrame:setVisible(false)
    local headInfo = global.luaCfg:get_role_frame_by(blockId)
    if headInfo and headInfo.pic then
        self.headFrame:setVisible(true)
        global.panelMgr:setTextureFor(self.headFrame,headInfo.pic) 
    end 

    local isExitType = function (lType)
        for k,v in pairs(skillIdTemp or {}) do
            if v and v ~= "" and tonumber(v) > 0 then
                local tempConfig = luaCfg:get_pet_skill_by(tonumber(v))
                if tempConfig and tempConfig.type == lType then
                    return tempConfig.skillId
                end
            end
        end
        return 0
    end 
    local skill = {}
    for i=1,4 do
        local curType = petConfig.skill_type1[i]
        table.insert(skill,  isExitType(curType))
    end

    -- 主动技能
    for i=1,4 do

        if self["m_TipsControl"..i] then 
            self["m_TipsControl"..i]:ClearEventListener()
        end 

        local getCurSkillData = function (skillId)
            -- body
            local petSkillConfig = global.petData:getGodSkillConfigByLv(petConfig.skill_type1[i], 1)
            local skId = skillId or petSkillConfig.skillId
            local temp = {}
            temp.config = luaCfg:get_pet_skill_by(skId)
            temp.serverData = {
                lGrade = skillId and temp.config.lv or 0,
                lState = skillId and 2 or 0,
            }
            return temp
        end

        local petSkillConfig = global.petData:getGodSkillConfigByLv(petConfig.skill_type1[i], 1) -- 未解锁默认获取第一级技能
        self["sIcon"..i]:setVisible(false)
        if petSkillConfig then
            self["sIcon"..i]:setVisible(true)
            global.panelMgr:setTextureFor(self["sIcon"..i], petSkillConfig.icon)
        end
        global.colorUtils.turnGray(self["sIcon"..i], true)
        local curSkill = getCurSkillData() -- global.petData:getGodSkillByKind(petConfig.type, petConfig.skill_type1[i])
        if skill[i] and skill[i] ~= "" and tonumber(skill[i]) > 0 then -- 已经解锁

            curSkill = getCurSkillData(tonumber(skill[i]))
            local tempConfig = luaCfg:get_pet_skill_by(tonumber(skill[i]))
            global.panelMgr:setTextureFor(self["sIcon"..i], tempConfig.icon)
            global.colorUtils.turnGray(self["sIcon"..i], false)
        end
        self["skill"..i]:setTouchEnabled(false)

        -- tips
        local nextSkill = clone(petSkillConfig)
        if skill[i] and skill[i] ~= "" and tonumber(skill[i]) > 0 then  -- 可升级
            nextSkill = luaCfg:get_pet_skill_by(curSkill.config.nextId)
        end
        local temp = {curLvData=clone(curSkill), nextLvData=clone(nextSkill)}
        self["m_TipsControl"..i] = UIItemTipsControl.new()
        local tempdata ={information=temp, tips_type="UIPetEquipTips", curPet = clone(self.data)} 
        self["m_TipsControl"..i]:setdata(self["sIcon"..i], tempdata, self.tips_node)
        
    end

    global.tools:adjustNodePosForFather(self.petType:getParent(),self.petType)
    global.tools:adjustNodePosForFather(self.powRank:getParent(),self.powRank) 
    global.tools:adjustNodePosForFather(self.owner:getParent(),self.owner)

end

function UIPetDetailPanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanel("UIPetDetailPanel")
end

function UIPetDetailPanel:onExit()
    
    for i=1,4 do
        if self["m_TipsControl"..i] then 
            self["m_TipsControl"..i]:ClearEventListener()
        end 
    end
end

function UIPetDetailPanel:skill3Handler(sender, eventType)

end

function UIPetDetailPanel:skill3Handler(sender, eventType)

end

function UIPetDetailPanel:skill2Handler(sender, eventType)

end

function UIPetDetailPanel:skill1Handler(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIPetDetailPanel

--endregion
