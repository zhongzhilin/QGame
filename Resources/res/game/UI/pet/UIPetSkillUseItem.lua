--region UIPetSkillUseItem.lua
--Author : yyt
--Date   : 2017/12/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetSkillUseItem  = class("UIPetSkillUseItem", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

function UIPetSkillUseItem:ctor()
    self:CreateUI()
end

function UIPetSkillUseItem:CreateUI()
    local root = resMgr:createWidget("pet/pet_skill_use_node")
    self:initUI(root)
end

function UIPetSkillUseItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_skill_use_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.contentNode = self.root.Node_1.Image_1.contentNode_export
    self.shine = self.root.Node_1.Image_1.contentNode_export.shine_export
    self.lock = self.root.Node_1.Image_1.contentNode_export.lock_export
    self.icon = self.root.Node_1.Image_1.contentNode_export.icon_export
    self.skillName = self.root.Node_1.Image_1.contentNode_export.skillName_export
    self.cdTime = self.root.Node_1.Image_1.cdTime_export
    self.useTime = self.root.Node_1.Image_1.useTime_export
    self.useBtn = self.root.Node_1.useBtn_export
    self.lookBtn = self.root.Node_1.lookBtn_export

    uiMgr:addWidgetTouchHandler(self.useBtn, function(sender, eventType) self:useHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.lookBtn, function(sender, eventType) self:checkHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.useBtn:setSwallowTouches(false)
    self.lookBtn:setSwallowTouches(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
local picName = {
    [1] = "ui_button/btn_task_sec_reward.png",
    [2] = "ui_button/btn_task_sec_equip.png",
}
function UIPetSkillUseItem:setData(data)

    -- dump(data, " ==> UIPetSkillUseItem: ")
    
    self.useTime:setVisible(false)
    self.cdTime:setVisible(false)
    self.useBtn:setVisible(false)
    self.lookBtn:setVisible(false)

    self.data = data
    self.configData = data.config
    global.panelMgr:setTextureFor(self.icon, self.configData.icon)
    self.skillName:setString(self.configData.name)

    local curFightPet = global.petData:getGodAnimalByFighting() 
    self.curFightPet = curFightPet
    local nextSkill = global.petData:getGodSkillConfigByLv(self.configData.type, 1)
    global.colorUtils.turnGray(self.contentNode, true)

    if data.serverData and data.serverData.lState == 2  then -- 已经解锁

        nextSkill = luaCfg:get_pet_skill_by(self.configData.nextId)
        global.colorUtils.turnGray(self.contentNode, false)
        self.useBtn:setVisible(true)
    else
        self.lookBtn:setVisible(true)
    end

    self:initCd(data.serverData or {})

    -- tips
    if self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
        self.m_TipsControl  = nil 
    end
    local temp = {curLvData=clone(data), nextLvData=clone(nextSkill)}
    self.m_TipsControl = UIItemTipsControl.new()
    local tempdata ={information=temp, tips_type="UIPetEquipTips", curPet=clone(curFightPet)} 
    self.m_TipsControl:setdata(self.icon, tempdata, global.skillUsePanel.tips_node)

end

function UIPetSkillUseItem:initCd(serverData)

    serverData.lExpired = serverData.lExpired or 0
    local offTime1 = serverData.lExpired - global.dataMgr:getServerTime() --  时间偏移
    if serverData.lExpired and offTime1 > 5 then -- 持续结束时间
        self.useTime:setVisible(true)
        self.lExpEndTime = serverData.lExpired
        self:cutExpirTime()
    end

    serverData.lCdTime = serverData.lCdTime or 0
    local offTime2 = serverData.lCdTime - global.dataMgr:getServerTime() --  时间偏移
    if serverData.lCdTime and offTime2 > 5 then   -- 技能冷却时间
        self.cdTime:setVisible(true)
        self.lCdEndTime = serverData.lCdTime
        self:cutCdTime()
        self.useBtn:setVisible(false)
        self.lookBtn:setVisible(false)
    end

end

function UIPetSkillUseItem:cutExpirTime()

    if not self.m_cutDownTimerExp then
        self.m_cutDownTimerExp = gscheduler.scheduleGlobal(handler(self, self.m_cutDownTimerExpHandler), 1)
    end
    self:m_cutDownTimerExpHandler()
end

function UIPetSkillUseItem:m_cutDownTimerExpHandler()
    -- body
    if self.lExpEndTime <= 0 then
        self.useTime:setString("00:00:00")
        return
    end
    local curr = global.dataMgr:getServerTime()
    local rest = self.lExpEndTime - curr
    if rest < 0 then
        if self.m_cutDownTimerExp then
            gscheduler.unscheduleGlobal(self.m_cutDownTimerExp)
            self.m_cutDownTimerExp = nil
        end
        self:refersh()
        return
    end
    self.useTime:setString(global.funcGame.formatTimeToHMS(rest))
end

function UIPetSkillUseItem:cutCdTime()

    if not self.m_cutDownTimerCd then
        self.m_cutDownTimerCd = gscheduler.scheduleGlobal(handler(self, self.m_cutDownTimerCdHandler), 1)
    end
    self:m_cutDownTimerCdHandler()
end

function UIPetSkillUseItem:m_cutDownTimerCdHandler()
    -- body
    self.lCdEndTime = self.lCdEndTime or 0 
    if self.lCdEndTime <= 0 then
        if not tolua.isnull(self.cdTime) then 
            self.cdTime:setString("00:00:00")
        end 
        return
    end
    local curr = global.dataMgr:getServerTime()
    local rest = self.lCdEndTime - curr
    if rest < 0 then
        if self.m_cutDownTimerCd then
            gscheduler.unscheduleGlobal(self.m_cutDownTimerCd)
            self.m_cutDownTimerCd = nil
        end
        self:refersh()
        return
    end
    self.cdTime:setString(global.funcGame.formatTimeToHMS(rest))
end

function UIPetSkillUseItem:refersh()
    global.skillUsePanel:initPetSKill()
end

function UIPetSkillUseItem:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
        self.m_TipsControl  = nil 
    end 

    if self.m_cutDownTimerCd then
        gscheduler.unscheduleGlobal(self.m_cutDownTimerCd)
        self.m_cutDownTimerCd = nil
    end

    if self.m_cutDownTimerExp then
        gscheduler.unscheduleGlobal(self.m_cutDownTimerExp)
        self.m_cutDownTimerExp = nil
    end
end

function UIPetSkillUseItem:useHandler(sender, eventType)

    if eventType == ccui.TouchEventType.began then
        global.skillUsePanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
        if global.skillUsePanel.isPageMove then 
            return
        end

        gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")

        -- 免费迁城
        if self.configData.buff == 7001 then
            return global.tipsMgr:showWarning("moveCitySkill01")
        end

        -- 时空之门
        if self.configData.buff == 7002 and (not global.troopData:checkBackTroop()) then
            return global.tipsMgr:showWarning("noHomeBackTroop")
        end

        -- 行军加速
        if self.configData.buff == 7003 and (not global.troopData:checkWalkTroop()) then
            return global.tipsMgr:showWarning("noTroopGoing")
        end

        global.petApi:actionSkill(function (msg)
            -- body
            global.petData:updateGodAnimal(msg.tagGodAnimal or {})
            global.petData:updateGodSkill(self.curFightPet.type, msg.tagGodAnimalSkill or {})
            gevent:call(global.gameEvent.EV_ON_PET_SKILL, true)
            global.tipsMgr:showWarning("petUseSkill")

            -- 制造陷阱
            if self.configData.buff == 7008 then
                local petActive = luaCfg:get_pet_activation_by(1)
                local addCount = self.configData.value/petActive.skillExpand
                global.soldierData:addTrapBy({lID=72+global.userData:getRace()*1000, lCount=addCount})
            end

        end, self.curFightPet.type, 4, self.configData.type, 1)

    end

end

function UIPetSkillUseItem:checkHandler(sender, eventType)
    
    if eventType == ccui.TouchEventType.began then
        global.skillUsePanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
        if global.skillUsePanel.isPageMove then 
            return
        end

        gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")
        global.panelMgr:openPanel("UIPetSkillPanel"):setData(self.curFightPet)
    end
end
--CALLBACKS_FUNCS_END

return UIPetSkillUseItem

--endregion
