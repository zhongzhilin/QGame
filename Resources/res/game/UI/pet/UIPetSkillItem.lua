--region UIPetSkillItem.lua
--Author : yyt
--Date   : 2017/12/06
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetSkillItem  = class("UIPetSkillItem", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

function UIPetSkillItem:ctor()
    self:CreateUI()
end

function UIPetSkillItem:CreateUI()
    local root = resMgr:createWidget("pet/pet_third_node")
    self:initUI(root)
end

function UIPetSkillItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_third_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.name = self.root.name_export
    self.num = self.root.num_export
    self.condition = self.root.condition_mlan_8_export
    self.icon = self.root.icon_export
    self.btn = self.root.btn_export
    self.node_gray = self.root.btn_export.node_gray_export
    self.skillPoint = self.root.btn_export.skillPoint_export
    self.btnText = self.root.btn_export.btnText_export
    self.lvNum = self.root.lvNum_export
    self.star = self.root.star_export
    self.star1_bj = self.root.star_export.star1_bj_export
    self.starTotal1 = self.root.star_export.star1_bj_export.starTotal1_export
    self.star1 = self.root.star_export.star1_bj_export.starTotal1_export.star1_export
    self.star2 = self.root.star_export.star1_bj_export.starTotal1_export.star2_export
    self.star2_bj = self.root.star_export.star2_bj_export
    self.starTotal2 = self.root.star_export.star2_bj_export.starTotal2_export
    self.star3 = self.root.star_export.star2_bj_export.starTotal2_export.star3_export
    self.star4 = self.root.star_export.star2_bj_export.starTotal2_export.star4_export
    self.star3_bj = self.root.star_export.star3_bj_export
    self.starTotal3 = self.root.star_export.star3_bj_export.starTotal3_export
    self.star5 = self.root.star_export.star3_bj_export.starTotal3_export.star5_export
    self.star6 = self.root.star_export.star3_bj_export.starTotal3_export.star6_export
    self.star4_bj = self.root.star_export.star4_bj_export
    self.starTotal4 = self.root.star_export.star4_bj_export.starTotal4_export
    self.star7 = self.root.star_export.star4_bj_export.starTotal4_export.star7_export
    self.star8 = self.root.star_export.star4_bj_export.starTotal4_export.star8_export
    self.star5_bj = self.root.star_export.star5_bj_export
    self.starTotal5 = self.root.star_export.star5_bj_export.starTotal5_export
    self.star9 = self.root.star_export.star5_bj_export.starTotal5_export.star9_export
    self.star10 = self.root.star_export.star5_bj_export.starTotal5_export.star10_export
    self.star6_bj = self.root.star_export.star6_bj_export
    self.starTotal6 = self.root.star_export.star6_bj_export.starTotal6_export
    self.star11 = self.root.star_export.star6_bj_export.starTotal6_export.star11_export
    self.star12 = self.root.star_export.star6_bj_export.starTotal6_export.star12_export
    self.star7_bj = self.root.star_export.star7_bj_export
    self.starTotal7 = self.root.star_export.star7_bj_export.starTotal7_export
    self.star13 = self.root.star_export.star7_bj_export.starTotal7_export.star13_export
    self.star14 = self.root.star_export.star7_bj_export.starTotal7_export.star14_export
    self.star8_bj = self.root.star_export.star8_bj_export
    self.starTotal8 = self.root.star_export.star8_bj_export.starTotal8_export
    self.star15 = self.root.star_export.star8_bj_export.starTotal8_export.star15_export
    self.star16 = self.root.star_export.star8_bj_export.starTotal8_export.star16_export
    self.star9_bj = self.root.star_export.star9_bj_export
    self.starTotal9 = self.root.star_export.star9_bj_export.starTotal9_export
    self.star17 = self.root.star_export.star9_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.star_export.star9_bj_export.starTotal9_export.star18_export
    self.star10_bj = self.root.star_export.star10_bj_export
    self.starTotal10 = self.root.star_export.star10_bj_export.starTotal10_export
    self.star19 = self.root.star_export.star10_bj_export.starTotal10_export.star19_export
    self.star20 = self.root.star_export.star10_bj_export.starTotal10_export.star20_export
    self.starLvNum = self.root.star_export.starLvNum_export

    uiMgr:addWidgetTouchHandler(self.btn, function(sender, eventType) self:upSkillHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.btn:setSwallowTouches(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
local picName = {
    [1] = "ui_button/btn_task_sec_reward.png",
    [2] = "ui_button/btn_task_sec_equip.png",
}

function UIPetSkillItem:onEnter()
    self.skillHanding = false
end

function UIPetSkillItem:setData(data)

    -- dump(data, " ==> guide: ")
    self.btn:setName('guide_skill_'..data.config.buff)
    self.data = data
    self.configData = data.config
    self.name:setString(self.configData.name)
    -- self.num:setVisible(false)
    local maxLv = global.petData:getGodSkillConfigByLv(self.configData.type, 1).skillMax
    self.num:setString(luaCfg:get_local_string(10410,0, maxLv))

    self.lvNum:setVisible(false)
    self.btnText:setString(luaCfg:get_local_string(10941))
    global.colorUtils.turnGray(self.icon, true)
    global.panelMgr:setTextureFor(self.icon, self.configData.icon)
    self.btn:loadTextures(picName[2],picName[2],picName[2],ccui.TextureResType.plistType)
    self.node_gray:setSpriteFrame(picName[2])
    
    local curPet = global.skillPanel.data
    self.curPet = curPet

    local nextSkill = global.petData:getGodSkillConfigByLv(self.configData.type, 1)
    if data.serverData then -- 已经解锁

        self.name:setString(self.configData.name)
        global.panelMgr:setTextureFor(self.icon, self.configData.icon)

        if data.serverData.lState == 1 then -- 可激活
        elseif data.serverData.lState == 2 then  -- 可升级
            nextSkill = luaCfg:get_pet_skill_by(self.configData.nextId)
            -- self.num:setVisible(true)
            self.lvNum:setVisible(true)
            -- self.btnText:setString(luaCfg:get_local_string(10941))
            -- self.btn:loadTextures(picName[2],picName[2],picName[2],ccui.TextureResType.plistType)
            self.node_gray:setSpriteFrame(picName[2])
            
            self.num:setString(luaCfg:get_local_string(10410,data.serverData.lGrade, maxLv))
            self.lvNum:setString("Lv." .. data.serverData.lGrade)
            global.colorUtils.turnGray(self.icon, false)
        end  
    end

    global.colorUtils.turnGray(self.node_gray, false)
    -- 技能已满级
    self.condition:setTextColor(cc.c3b(255,226,165))
    local nextIdTemp = self.configData.nextId
    if nextIdTemp == 0 then
        self.condition:setString(luaCfg:get_local_string(10952))
        self.star:setVisible(false)
        self.btn:setVisible(false)
    else
        self.btn:setVisible(true)
        self.nextSkill = nextSkill
        self.condition:setString(luaCfg:get_local_string(11126))
        if curPet.serverData and curPet.serverData.lGrade < nextSkill.petLv then 
            self.condition:setTextColor(cc.c3b(180,29,11))
            global.colorUtils.turnGray(self.node_gray, true)
        end

        self.skillPoint:setString(nextSkill.needSkillPoint)
        self.skillPoint:setTextColor(cc.c3b(255, 226, 165))
        if nextSkill.needSkillPoint > curPet.serverData.lSkillPoint then
            self.skillPoint:setTextColor(gdisplay.COLOR_RED)
        end

        -- 升级条件
        self.star:setVisible(true)
        local lv = nextSkill.petLv
        local curClass = math.ceil(lv/10) 
        for i=1,10 do
            self["star"..i.."_bj"]:setVisible(false)
            if i<=curClass then
                self["star"..i.."_bj"]:setVisible(true)
            end
        end
        local per = 10
        local curLvClass = math.ceil(lv/per)
        if curLvClass == 1 then
            self.starLvNum:setString("+"..lv)
        else
            self.starLvNum:setString("+"..(lv-per*(curLvClass-1)))
        end
        self.starLvNum:setPositionX(self["star"..curClass.."_bj"]:getPositionX()+15)

    end


    -- tips
    if self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
        self.m_TipsControl  = nil 
    end
    local temp = {curLvData=clone(data), nextLvData=clone(nextSkill)}
    self.m_TipsControl = UIItemTipsControl.new()
    local tempdata ={information=temp, tips_type="UIPetEquipTips", curPet=clone(global.skillPanel.data)} 
    self.m_TipsControl:setdata(self.icon, tempdata, global.skillPanel.tips_node)
   
   global.tools:adjustNodePos(self.name, self.num)
end

function UIPetSkillItem:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
        self.m_TipsControl  = nil 
    end 
    self.skillHanding = false
end

function UIPetSkillItem:upSkillHandler(sender, eventType)
    
    if eventType == ccui.TouchEventType.began then
        global.skillPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if global.skillPanel.isPageMove then 
            return
        end

        if self.curPet.serverData and self.curPet.serverData.lGrade < self.nextSkill.petLv then
            gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")
            return global.tipsMgr:showWarning("petSkillNeedLvPrompt")
        end

        if self.nextSkill.needSkillPoint > self.curPet.serverData.lSkillPoint then
            gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")
            return global.tipsMgr:showWarning("petSkillPointPrompt")
        end

        -- 当前技能处在持续时间过程中提示errorcode
        if self.data.serverData and self.data.serverData.lExpired and self.data.serverData.lExpired > global.dataMgr:getServerTime()  then 
            return global.tipsMgr:showWarning("petSkillCantUp")
        end

        if self.skillHanding then return end
        self.skillHanding = true

        local operType = 3
        if self.data.serverData and self.data.serverData.lState == 2 then 
            operType = 1
        end
        global.petApi:actionSkill(function (msg)

            if not msg then return end
            global.petData:updateGodAnimal(msg.tagGodAnimal or {})
            global.petData:updateGodSkill(self.curPet.type, msg.tagGodAnimalSkill or {})
            
            gevent:call(gsound.EV_ON_PLAYSOUND,"pet_skillup")
            self.root:stopAllActions()
            local nodeTimeLine = resMgr:createTimeline("pet/pet_third_node")
            nodeTimeLine:play("animation0", false)
            self.root:runAction(nodeTimeLine)
            gevent:call(global.gameEvent.EV_ON_PET_SKILL, true)
            self.skillHanding = false

        end, self.curPet.type, operType, self.configData.type, self.configData.triggerType)
       
    end

end
--CALLBACKS_FUNCS_END

return UIPetSkillItem

--endregion
