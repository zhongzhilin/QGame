--region UIPetInfoPanel.lua
--Author : yyt
--Date   : 2017/12/06
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPetStar = require("game.UI.pet.UIPetStar")
local UIAdSlideNode = require("game.UI.advertisementItem.UIAdSlideNode")
local UIPetShare = require("game.UI.pet.UIPetShare")
--REQUIRE_CLASS_END

local UIPetInfoPanel  = class("UIPetInfoPanel", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")
local UIPetIcon = require("game.UI.pet.UIPetIcon")

function UIPetInfoPanel:ctor()
    self:CreateUI()
end

function UIPetInfoPanel:CreateUI()
    local root = resMgr:createWidget("pet/pet_second")
    self:initUI(root)
end

function UIPetInfoPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_second")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.NodeTitle = self.root.title_export.NodeTitle_export
    self.name = self.root.title_export.NodeTitle_export.name_fnt_mlan_6_export
    self.growName = self.root.title_export.NodeTitle_export.growName_fnt_mlan_6_export
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.petMiddleBg = self.root.ScrollView_1_export.petMiddleBg_export
    self.middleT = self.root.ScrollView_1_export.middleT_export
    self.ImageRight = self.root.ScrollView_1_export.middleT_export.ImageRight_export
    self.ImageLeft = self.root.ScrollView_1_export.middleT_export.ImageLeft_export
    self.NodeT = self.root.ScrollView_1_export.NodeT_export
    self.att3 = self.root.ScrollView_1_export.NodeT_export.botNode.att3_export
    self.att6 = self.root.ScrollView_1_export.NodeT_export.botNode.att6_export
    self.att2 = self.root.ScrollView_1_export.NodeT_export.botNode.att2_export
    self.att5 = self.root.ScrollView_1_export.NodeT_export.botNode.att5_export
    self.att1 = self.root.ScrollView_1_export.NodeT_export.botNode.att1_export
    self.att4 = self.root.ScrollView_1_export.NodeT_export.botNode.att4_export
    self.firstGrow = self.root.ScrollView_1_export.NodeT_export.botNode.firstGrow_export
    self.firstGrowTitle = self.root.ScrollView_1_export.NodeT_export.botNode.firstGrowTitle_mlan_8_export
    self.go_btn = self.root.ScrollView_1_export.NodeT_export.botNode.go_btn_export
    self.label = self.root.ScrollView_1_export.NodeT_export.botNode.label_export
    self.skill1 = self.root.ScrollView_1_export.NodeT_export.skill.skill1_export
    self.sIcon1 = self.root.ScrollView_1_export.NodeT_export.skill.skill1_export.sIcon1_export
    self.skill2 = self.root.ScrollView_1_export.NodeT_export.skill.skill2_export
    self.sIcon2 = self.root.ScrollView_1_export.NodeT_export.skill.skill2_export.sIcon2_export
    self.skill3 = self.root.ScrollView_1_export.NodeT_export.skill.skill3_export
    self.sIcon3 = self.root.ScrollView_1_export.NodeT_export.skill.skill3_export.sIcon3_export
    self.skill4 = self.root.ScrollView_1_export.NodeT_export.skill.skill4_export
    self.sIcon4 = self.root.ScrollView_1_export.NodeT_export.skill.skill4_export.sIcon4_export
    self.NodeTop = self.root.ScrollView_1_export.NodeTop_export
    self.NodeStar = self.root.ScrollView_1_export.NodeTop_export.NodeStar_export
    self.NodeStar = UIPetStar.new()
    uiMgr:configNestClass(self.NodeStar, self.root.ScrollView_1_export.NodeTop_export.NodeStar_export)
    self.txt_power = self.root.ScrollView_1_export.NodeTop_export.txt_power_export
    self.friendly_bg = self.root.ScrollView_1_export.NodeTop_export.friendly_bg_export
    self.loadBg = self.root.ScrollView_1_export.NodeTop_export.friendly_bg_export.loadBg_export
    self.friendlyBar = self.root.ScrollView_1_export.NodeTop_export.friendly_bg_export.loadBg_export.friendlyBar_export
    self.loadingEffect = self.root.ScrollView_1_export.NodeTop_export.friendly_bg_export.loadBg_export.loadingEffect_export
    self.frendNum = self.root.ScrollView_1_export.NodeTop_export.friendly_bg_export.loadBg_export.frendNum_export
    self.status = self.root.ScrollView_1_export.NodeTop_export.status_export
    self.modify = self.root.ScrollView_1_export.NodeTop_export.modify_export
    self.Node_PageView = self.root.ScrollView_1_export.Node_PageView_export
    self.PageView_1 = self.root.ScrollView_1_export.Node_PageView_export.PageView_1_export
    self.Node_Slider = self.root.ScrollView_1_export.Node_Slider_export
    self.FileNode_1 = self.root.ScrollView_1_export.Node_Slider_export.FileNode_1_export
    self.FileNode_1 = UIAdSlideNode.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.ScrollView_1_export.Node_Slider_export.FileNode_1_export)
    self.Node_Gorw = self.root.ScrollView_1_export.Node_Gorw_export
    self.garrisonNeed1 = self.root.ScrollView_1_export.Node_Gorw_export.garrisonNeed1_export
    self.preGrow = self.root.ScrollView_1_export.Node_Gorw_export.preGrow_export
    self.curGrow = self.root.ScrollView_1_export.Node_Gorw_export.curGrow_export
    self.Node_Cd = self.root.ScrollView_1_export.Node_Cd_export
    self.add1 = self.root.ScrollView_1_export.Node_Cd_export.add1_export
    self.addF1 = self.root.ScrollView_1_export.Node_Cd_export.add1_export.addF1_export
    self.add2 = self.root.ScrollView_1_export.Node_Cd_export.add2_export
    self.addF2 = self.root.ScrollView_1_export.Node_Cd_export.add2_export.addF2_export
    self.add3 = self.root.ScrollView_1_export.Node_Cd_export.add3_export
    self.addF3 = self.root.ScrollView_1_export.Node_Cd_export.add3_export.addF3_export
    self.Button_3 = self.root.ScrollView_1_export.Node_Cd_export.Button_3_export
    self.interactive3 = self.root.ScrollView_1_export.Node_Cd_export.Button_3_export.interactive3_mlan_7_export
    self.cdTime3 = self.root.ScrollView_1_export.Node_Cd_export.Button_3_export.cdTime3_export
    self.Button_2 = self.root.ScrollView_1_export.Node_Cd_export.Button_2_export
    self.interactive2 = self.root.ScrollView_1_export.Node_Cd_export.Button_2_export.interactive2_mlan_7_export
    self.cdTime2 = self.root.ScrollView_1_export.Node_Cd_export.Button_2_export.cdTime2_export
    self.Button_1 = self.root.ScrollView_1_export.Node_Cd_export.Button_1_export
    self.interactive1 = self.root.ScrollView_1_export.Node_Cd_export.Button_1_export.interactive1_mlan_7_export
    self.cdTime1 = self.root.ScrollView_1_export.Node_Cd_export.Button_1_export.cdTime1_export
    self.NodeMT = self.root.ScrollView_1_export.Node_Cd_export.NodeMT_export
    self.rightBtn = self.root.ScrollView_1_export.Node_Cd_export.NodeMT_export.rightBtn_export
    self.leftBtn = self.root.ScrollView_1_export.Node_Cd_export.NodeMT_export.leftBtn_export
    self.rightRole = self.root.ScrollView_1_export.Node_Cd_export.NodeMT_export.rightRole_mlan_6_export
    self.leftRole = self.root.ScrollView_1_export.Node_Cd_export.NodeMT_export.leftRole_mlan_6_export
    self.feedEquipBtn = self.root.ScrollView_1_export.Node_Cd_export.NodeMT_export.feedEquipBtn_export
    self.feedResBtn = self.root.ScrollView_1_export.Node_Cd_export.NodeMT_export.feedResBtn_export
    self.feedItemBtn = self.root.ScrollView_1_export.Node_Cd_export.NodeMT_export.feedItemBtn_export
    self.petButton = self.root.ScrollView_1_export.Node_Cd_export.NodeMT_export.petButton_export
    self.petPos = self.root.ScrollView_1_export.petPos_export
    self.sharePanel = self.root.sharePanel_export
    self.shareNode = self.root.sharePanel_export.shareNode_export
    self.shareNode = UIPetShare.new()
    uiMgr:configNestClass(self.shareNode, self.root.sharePanel_export.shareNode_export)

    uiMgr:addWidgetTouchHandler(self.root.title_export.shareBtn, function(sender, eventType) self:shareHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.go_btn, function(sender, eventType) self:checkSkillHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.skill1, function(sender, eventType) self:skill1Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.skill2, function(sender, eventType) self:skill2Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.skill3, function(sender, eventType) self:skill3Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.skill4, function(sender, eventType) self:skill3Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.modify, function(sender, eventType) self:changeStateHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.PageView_1, function(sender, eventType) self:touEvnenter(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.Button_3, function(sender, eventType) self:upFriend3Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_2, function(sender, eventType) self:upFriend2Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:upFriend1Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.rightBtn, function(sender, eventType) self:rightHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.leftBtn, function(sender, eventType) self:leftHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.feedEquipBtn, function(sender, eventType) self:feedEquipHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.feedResBtn, function(sender, eventType) self:feedResHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.feedItemBtn, function(sender, eventType) self:feedItemHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.petButton, function(sender, eventType) self:petClickHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end)

    self.ScrollView_1:setTouchEnabled(true)
    local contentSize = self.ScrollView_1:getContentSize().height
    local sHeight = gdisplay.height - 75
    self.ScrollView_1:setContentSize(cc.size(gdisplay.width, sHeight))
    if sHeight >= contentSize then
        self.ScrollView_1:setTouchEnabled(false)
    end

    self.tips_node = cc.Node:create()
    self:addChild(self.tips_node)

    self.petButton:setSwallowTouches(false)
    self.PageView_1:setSwallowTouches(false)
    self.PageView_1:addEventListener(handler(self, self.pageViewEvent))

    self.ttOffset = 0
    self:adapt(contentSize)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIPetInfoPanel:adapt(contentSize)
  
    if (gdisplay.height - 80) > contentSize then
        
        self.ScrollView_1:setInnerContainerSize(cc.size(720,gdisplay.height - 80))
        local tt = gdisplay.height - 80 - contentSize
        for _,v in pairs(self.ScrollView_1:getChildren()) do 
            v:setPositionY(v:getPositionY()+tt)
        end 

        self.ttOffset = tt
        self.NodeTop:setPositionY(self.NodeTop:getPositionY()+tt)
        self.petMiddleBg:setContentSize(cc.size(gdisplay.width+tt, self.petMiddleBg:getContentSize().height+tt))
        self.ImageLeft:setContentSize(cc.size(self.ImageLeft:getContentSize().width, self.ImageLeft:getContentSize().height+tt))
        self.ImageRight:setContentSize(cc.size(self.ImageRight:getContentSize().width, self.ImageRight:getContentSize().height+tt))
        self.NodeT:setPositionY(0)
        self.ScrollView_1.effectL:setPositionY(self.ScrollView_1.effectL:getPositionY()-tt)
        self.ScrollView_1.effectR:setPositionY(self.ScrollView_1.effectR:getPositionY()-tt)
        self.middleT:setPositionY(self.middleT:getPositionY()-tt)
        for i=1,3 do
            self["Button_"..i]:setPositionY(self["Button_"..i]:getPositionY()-tt)
            self["add"..i]:setPositionY(self["add"..i]:getPositionY()-tt)
        end
        
        self.NodeMT:setPositionY(self.NodeMT:getPositionY()-tt/2)
        self.petPos:setPositionY(self.petPos:getPositionY()-tt/2)
        self.Node_PageView:setPositionY(self.Node_PageView:getPositionY()-tt/2)
        self.Node_Gorw:setPositionY(self.Node_Gorw:getPositionY()-tt/2)

    end
end

function UIPetInfoPanel:pageViewEvent(sender, eventType )

    if eventType == ccui.PageViewEventType.turning then
        local curIndex = self.PageView_1:getCurrentPageIndex()
        self:refersh(curIndex, true)
    end
end

function UIPetInfoPanel:refersh(index, isNoRset)

    self.curDefaultSelect = index

    -- 当前成长阶段
    local curSelectData = self.data or {} 
    local curGarrData = global.petData:getPetConfigByGrow(curSelectData.type, index+1)
    if curGarrData then

        local curGarrGrowing = 1
        local curGarrGrowPet = global.petData:getGodAnimalByType(curSelectData.type)
        if curGarrGrowPet.serverData and curGarrGrowPet.serverData.lGrade and curGarrGrowPet.serverData.lGrade > 0 then
            curGarrGrowing = global.petData:getPetConfig(curSelectData.type, curGarrGrowPet.serverData.lGrade).growingPhase
        end

        self.Node_Gorw:setVisible(curGarrData.growingPhase > curGarrGrowing)
        self.leftBtn:setVisible(curGarrData.growingPhase ~= 1)
        self.rightBtn:setVisible(curGarrData.growingPhase ~= global.petData:getPetGrowMax())
        self.leftRole:setVisible(curGarrData.growingPhase ~= 1)
        self.rightRole:setVisible(curGarrData.growingPhase ~= global.petData:getPetGrowMax())

        self.curGrow:setString(curGarrData.phaseAptitude)
        local preGarrData = global.petData:getPetConfigByGrow(curSelectData.type, index)
        if preGarrData then
            self.preGrow:setString(preGarrData.phaseAptitude)
        end

        self.garrisonNeed1:setVisible(curGarrData.growingPhase ~= 1)
        local starClass, starNum = global.petData:getPetStarClassByLv(curGarrData.lv)
        self.garrisonNeed1:setString(luaCfg:get_translate_string(10978, starClass, starNum, curGarrData.phaseName))
    end
    
end

function UIPetInfoPanel:onEnter()

    local nodeTimeLine = resMgr:createTimeline("pet/pet_second")
    nodeTimeLine:play("animation2", true)
    self:runAction(nodeTimeLine)
     
    self:addEventListener(global.gameEvent.EV_ON_PET_REFERSH, function ()
        if self.setData then
            self:setData(global.petData:getGodAnimalByType(self.data.id))
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_PET_PLAYEFFECT, function (event, fireNum)
        if self.playEffect then
            self:playEffect(fireNum)
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_PET_SKILL, function (event, isNoReset)
        if self.setData then
            self:setData(global.petData:getGodAnimalByType(self.data.id))
        end
    end)

    local reFreshAd = function () 
        if global.advertisementData:isPsLock(11) then 
            self.FileNode_1:setVisible(false)
        else 
            self.FileNode_1:setData(11)
            self.FileNode_1:setVisible(true)
        end 
        self:adjustps()
    end 

    self:addEventListener(global.gameEvent.EV_ON_UI_ADUPDATE, function ()
        reFreshAd()
    end)
    reFreshAd()

end

function UIPetInfoPanel:adjustps()
    if self.FileNode_1:isVisible() then 
        self.NodeTop:setPositionY(5+self.ttOffset)
        self.PageView_1:setContentSize(cc.size(self.PageView_1:getContentSize().width,  600))
    else 
        self.NodeTop:setPositionY(100+self.ttOffset)
        self.PageView_1:setContentSize(cc.size(self.PageView_1:getContentSize().width,  700))
    end
end 

function UIPetInfoPanel:setData(data)

    if not data then return end
    self.data = data
    local petConfig = global.petData:getPetConfig(data.id, data.serverData.lGrade)
    self.NodeStar:setData(data.serverData.lGrade)
    self.status:setString(luaCfg:get_local_string(10940))
    self.status:setTextColor(cc.c3b(141, 211, 255))
    if data.serverData.lState == 1 then -- 出战中
        self.status:setString(luaCfg:get_local_string(10939))
        self.status:setTextColor(cc.c3b(188, 245, 133))
    end
    self.txt_power:setString(data.serverData.lPower)

    local nextLv = data.serverData.lGrade+1
    if data.serverData.lGrade >= data.maxLv then
        self.frendNum:setString("MAX")
        self.friendlyBar:setPercent(100)
    else
        local nextConfig = global.petData:getPetConfig(data.id, nextLv)
        self.frendNum:setString(data.serverData.lImpress .. "/" .. nextConfig.exp)
        self.friendlyBar:setPercent(data.serverData.lImpress/nextConfig.exp*100)
    end

    local lW = self.friendlyBar:getContentSize().width
    local per = self.friendlyBar:getPercent()
    local curLw = lW*per/100
    self.loadingEffect:setPositionX(curLw)

    self.name:setString(petConfig.name)
    self.growName:setString("("..petConfig.phaseName..")")
    self.growName:setPositionX(self.name:getPositionX()+self.name:getContentSize().width)
    local width = self.name:getContentSize().width + self.growName:getContentSize().width
    self.NodeTitle:setPositionX(gdisplay.width/2-width/2)
    
    for i=1,6 do
        self["att"..i]:setVisible(false)
        local skill = global.petData:getPetPropertyClient(petConfig.propertyValueClient)
        if skill[i] then
            self["att"..i]:setVisible(true)
            local skillD = petConfig.propertyValue
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
    
    self.firstGrow:setString(petConfig.phaseAptitude)
    self.firstGrow:setPositionX(self.firstGrowTitle:getPositionX()+self.firstGrowTitle:getContentSize().width)

    self:initSkillServer()
    global.petApi:getSkill(function (msg)
        -- body
        if not msg then return end
        if not msg.tagGodAnimalSkill then return end
        global.petData:setGodSkillByType(data.type, msg.tagGodAnimalSkill)
        if self.initSkillServer then 
            self:initSkillServer()
        end 
    end, data.type, 0)

    -- 各种方式cd
    self:initFriendCd()

    -- 各阶段
    self:showPage()
    
    self.sharePanel:setVisible(false)
end

function UIPetInfoPanel:showPage()

    self.maxPetGrow = global.petData:getPetGrowMax()
    self.PageView_1:removeAllPages()
    if self.maxPetGrow > 0 then
 
        for i=1,self.maxPetGrow do
            local item= UIPetIcon.new()
            item:setData(global.petData:getPetConfigByGrow(self.data.type, i))
            self.PageView_1:addPage(item)
        end 
        if self.data.serverData then
            local configData = global.petData:getPetConfig(self.data.type, self.data.serverData.lGrade)
            self:jumpToPage(configData.growingPhase-1)
        else
            self:jumpToPage(0)
        end
    end
end

function UIPetInfoPanel:jumpToPage(index)
    
    index = self.curDefaultSelect or index
    self.PageView_1:setCurrentPageIndex(index) -- 无动画跳转
    self:refersh(index)
end

function UIPetInfoPanel:initSkillServer()

    for i=1,4 do

        if self["m_TipsControl"..i] then 
            self["m_TipsControl"..i]:ClearEventListener()
        end 

        local petSkillConfig = global.petData:getGodSkillConfigByLv(self.data.skill_type1[i], 1) -- 未解锁默认获取第一级技能
        self["sIcon"..i]:setVisible(false)
        if petSkillConfig then
            self["sIcon"..i]:setVisible(true)
            global.panelMgr:setTextureFor(self["sIcon"..i], petSkillConfig.icon)
        end
        self["skill"..i]:setTouchEnabled(false)
        global.colorUtils.turnGray(self["sIcon"..i], true)
        local curSkill = global.petData:getGodSkillByKind(self.data.type, self.data.skill_type1[i])

        if curSkill.serverData and curSkill.serverData.lState == 2 then -- 已经解锁
            local tempConfig = luaCfg:get_pet_skill_by(curSkill.serverData.lID)
            global.panelMgr:setTextureFor(self["sIcon"..i], tempConfig.icon)
            global.colorUtils.turnGray(self["sIcon"..i], false)
        end

        -- tips
        local nextSkill = clone(petSkillConfig)
        if curSkill.serverData and curSkill.serverData.lState == 2 then  -- 可升级
            nextSkill = luaCfg:get_pet_skill_by(curSkill.config.nextId)
        end
        local temp = {curLvData=clone(curSkill), nextLvData=clone(nextSkill)}
        self["m_TipsControl"..i] = UIItemTipsControl.new()
        local tempdata ={information=temp, tips_type="UIPetEquipTips", curPet = clone(self.data)} 
        self["m_TipsControl"..i]:setdata(self["sIcon"..i], tempdata, self.tips_node)
        
    end
end

function UIPetInfoPanel:initFriendCd()
    
    for i=1,3 do
        local interData = luaCfg:get_pet_interactive_by(i)
        self["addF"..i]:setString(interData.friendly*self.data.serverData.lGrade)
        self["add"..i]:setLocalZOrder(99999)
        self["interactive"..i]:setVisible(true)
        self["cdTime"..i]:setVisible(false)
        local cdtime = self.data.serverData.lMeetTimes
        if cdtime and cdtime[i] and cdtime[i] > global.dataMgr:getServerTime() then
            self["interactive"..i]:setVisible(false)
            self["cdTime"..i]:setVisible(true)
            self["lEndTime"..i] = cdtime[i]
            self:cutTime(i)
        end

        local textW = self["add"..i]:getContentSize().width + self["addF"..i]:getContentSize().width
        self["add"..i]:setPositionX(self["Button_"..i]:getPositionX() - textW/4)
    end
end

function UIPetInfoPanel:cutTime(i)

    if not self["m_countDownTimer"..i] then
        self["m_countDownTimer"..i] = gscheduler.scheduleGlobal(handler(self,self["countDownHandler"..i]), 1)
    end
    self["countDownHandler"..i](self)
end

function UIPetInfoPanel:countDownHandler1()
    self:countDownHandler(1)
end
function UIPetInfoPanel:countDownHandler2()
    self:countDownHandler(2)
end
function UIPetInfoPanel:countDownHandler3()
    self:countDownHandler(3)
end

function UIPetInfoPanel:countDownHandler(i)

    if self["lEndTime"..i] <= 0 then
        self["cdTime"..i]:setString("00:00:00")
        return
    end
    local curr = global.dataMgr:getServerTime()
    local rest = self["lEndTime"..i] - curr
    if rest < 0 then
        if self["m_countDownTimer"..i] then
            gscheduler.unscheduleGlobal(self["m_countDownTimer"..i])
            self["m_countDownTimer"..i] = nil
        end
        self:reFresh()
        return
    end
    self["cdTime"..i]:setString(global.funcGame.formatTimeToHMS(rest))
end

function UIPetInfoPanel:reFresh()
    -- body
    self:setData(global.petData:getGodAnimalByType(self.data.id))
end

function UIPetInfoPanel:onExit()
    
    self.curDefaultSelect = nil
    for i=1,3 do
        if self["m_countDownTimer"..i] then
            gscheduler.unscheduleGlobal(self["m_countDownTimer"..i])
            self["m_countDownTimer"..i] = nil
        end
    end

    if not tolua.isnull(self.effectAction) then
        self.effectAction:removeFromParent()
    end

    for i=1,4 do
        if self["m_TipsControl"..i] then 
            self["m_TipsControl"..i]:ClearEventListener()
        end 
    end

end

function UIPetInfoPanel:changeStateHandler(sender, eventType)

    global.panelMgr:closePanelForBtn("UIPetInfoPanel")
    global.panelMgr:openPanel("UIPetPanel")
end

function UIPetInfoPanel:checkSkillHandler(sender, eventType)
    global.panelMgr:openPanel("UIPetSkillPanel"):setData(self.data)
end

function UIPetInfoPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIPetInfoPanel")
end

function UIPetInfoPanel:skill1Handler(sender, eventType)
    self:skillCall(1)
end

function UIPetInfoPanel:skill2Handler(sender, eventType)
    self:skillCall(2)
end

function UIPetInfoPanel:skill3Handler(sender, eventType)
    self:skillCall(3)
end

function UIPetInfoPanel:skillCall(index)
    if self.data then 
        local curSkillServer = global.petData:getGodSkillByKind(self.data.id, self.data.skill_type1[index])
        if curSkillServer and curSkillServer.lState == 2 then
        else
            global.tipsMgr:showWarning("petSkillUnlock2") 
        end
    end 
end

function UIPetInfoPanel:feedEquipHandler(sender, eventType)
    -- 达到满级
    if global.petData:isGodAnimalMaxLv(self.data.type) then
        return global.tipsMgr:showWarning("petLvMax")
    end
    global.panelMgr:openPanel("UIPetEquipPanel"):setData(self.data)
end

function UIPetInfoPanel:feedResHandler(sender, eventType)
    -- 达到满级
    if global.petData:isGodAnimalMaxLv(self.data.type) then
        return global.tipsMgr:showWarning("petLvMax")
    end
    global.panelMgr:openPanel("UIPetFriendlyPanel"):setData(self.data)
end

function UIPetInfoPanel:upFriend3Handler(sender, eventType)
    self:feedCall(3)
end

function UIPetInfoPanel:upFriend2Handler(sender, eventType)
    self:feedCall(2)
end

function UIPetInfoPanel:upFriend1Handler(sender, eventType)
    self:feedCall(1)
end

-- operType: 1 问候 2 抚摸 3一起玩
function UIPetInfoPanel:feedCall(operType)
    
    if not self.data then return end
    
    -- 达到满级
    if global.petData:isGodAnimalMaxLv(self.data.type) then
        return global.tipsMgr:showWarning("petLvMax")
    end

    -- bod
    local cdtime = self.data.serverData.lMeetTimes
    if cdtime and cdtime[operType] and cdtime[operType] > global.dataMgr:getServerTime() then
        return global.tipsMgr:showWarning("petInteractivePrompt")
    end

    global.petApi:actionPet(function (msg)
        -- body
        if not msg then return end
        global.petData:updateGodAnimal(msg.tagGodAnimal or {})
        gevent:call(global.gameEvent.EV_ON_PET_REFERSH)

        local interData = luaCfg:get_pet_interactive_by(operType)
        self:playEffect(interData.friendly*self.data.serverData.lGrade)
    end, 2, self.data.type, 1, operType)

end

function UIPetInfoPanel:playEffect(friNum)
    -- body
    if not tolua.isnull(self.effectAction) then
        self.effectAction:removeFromParent()
    end
    gevent:call(gsound.EV_ON_PLAYSOUND,"pet_interactive")
    local addAction = resMgr:createCsbAction("pet/petFriend_effect","animation0",false,true)
    addAction:setPosition(self.petPos:getPosition())            
    self.ScrollView_1:addChild(addAction, 997)
    addAction:setTag(997)
    uiMgr:configUITree(addAction)    
    addAction.effect.addEffect:setVisible(true)
    addAction.effect.addEffect1:setVisible(false)
    addAction.effect.addEffect:setOpacity(0)
    addAction.effect.addEffect.addEffectNum:setString(friNum)    
    self.effectAction = addAction

    self.root:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function ()
        gevent:call(gsound.EV_ON_PLAYSOUND,"pet_feelup")
    end) ))

end

local last = ""
function UIPetInfoPanel:petClickHandler(sender, eventType)
    
    local music = "pte_dianji_".. self.data.type
    if last ~= "" then 
        gsound.stopEffect(last)
    end
    last = music
    gevent:call(gsound.EV_ON_PLAYSOUND,music)
end

-- 分享神兽
function UIPetInfoPanel:shareHandler(sender, eventType)
    
    if not self.data then return end
    local isVisi = self.sharePanel:isVisible()
    if not isVisi then
        self:showSharePanel()
    else
        self:hideSharePanel()
    end
end

function UIPetInfoPanel:showSharePanel()

    if self.sharePanel:isVisible() then return end
    
    uiMgr:addSceneModel(0.7)
    self.shareNode:setData(self.data, "UIPetInfoPanel")
    self.sharePanel:setVisible(true)
    local nodeTimeLine = resMgr:createTimeline("pet/pet_second")
    nodeTimeLine:play("animation0", false)
    nodeTimeLine:setLastFrameCallFunc(function()

        self.sharePanel:setVisible(true)
    end)
    self.root:runAction(nodeTimeLine)

end

function UIPetInfoPanel:hideSharePanel()
    
    if not self.sharePanel:isVisible() then return end

    uiMgr:addSceneModel(0.7)
    local nodeTimeLine = resMgr:createTimeline("pet/pet_second")
    nodeTimeLine:play("animation1", false)
    nodeTimeLine:setLastFrameCallFunc(function()
    
        self.sharePanel:setVisible(false)
    end)
    self.root:runAction(nodeTimeLine)

end

function UIPetInfoPanel:touEvnenter(sender, eventType)
end

function UIPetInfoPanel:rightHandler(sender, eventType)
    
    uiMgr:addSceneModel(0.5)
    local curIndex = self.PageView_1:getCurrentPageIndex() + 1
    self.PageView_1:scrollToPage(curIndex)
    self:refersh(curIndex, true)
end

function UIPetInfoPanel:leftHandler(sender, eventType)
    
    uiMgr:addSceneModel(0.5)
    local curIndex = self.PageView_1:getCurrentPageIndex() - 1
    self.PageView_1:scrollToPage(curIndex)
    self:refersh(curIndex, true)
end

function UIPetInfoPanel:feedItemHandler(sender, eventType)
    
    -- 达到满级
    if global.petData:isGodAnimalMaxLv(self.data.type) then
        return global.tipsMgr:showWarning("petLvMax")
    end
    local panel = global.panelMgr:openPanel("UISpeedPanel")   --神兽喂养道具使用
    panel:setData(nil, nil,panel.TYPE_PET_ITEM, self.data.type)
    
end
--CALLBACKS_FUNCS_END

return UIPetInfoPanel

--endregion
