--region UIPetEquipTips.lua
--Author : yyt
--Date   : 2017/12/11
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetEquipTips  = class("UIPetEquipTips", function() return gdisplay.newWidget() end )

function UIPetEquipTips:ctor()
    self:CreateUI()
end

function UIPetEquipTips:CreateUI()
    local root = resMgr:createWidget("pet/pet_skill_info_node")
    self:initUI(root)
end

function UIPetEquipTips:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_skill_info_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.board1 = self.root.board1_export
    self.node1 = self.root.board1_export.node1_export
    self.title1 = self.root.board1_export.node1_export.title1_export
    self.lvNum1 = self.root.board1_export.node1_export.lvNum1_export
    self.now1 = self.root.board1_export.node1_export.now1_mlan_10_export
    self.nowNum1 = self.root.board1_export.node1_export.now1_mlan_10_export.nowNum1_export
    self.cdTitle1 = self.root.board1_export.node1_export.cdTitle1_mlan_8_export
    self.cdTime1 = self.root.board1_export.node1_export.cdTitle1_mlan_8_export.cdTime1_export
    self.Node_Max = self.root.board1_export.node1_export.Node_Max_export
    self.maxCd = self.root.board1_export.node1_export.Node_Max_export.maxCd_export
    self.Node_Normal = self.root.board1_export.node1_export.Node_Normal_export
    self.nextLvNum1 = self.root.board1_export.node1_export.Node_Normal_export.nextLvNum1_export
    self.needCon1 = self.root.board1_export.node1_export.Node_Normal_export.needCon1_mlan_5_export
    self.need1 = self.root.board1_export.node1_export.Node_Normal_export.need1_mlan_5_export
    self.needText1 = self.root.board1_export.node1_export.Node_Normal_export.need1_mlan_5_export.needText1_mlan_9_export
    self.needNum1 = self.root.board1_export.node1_export.Node_Normal_export.need1_mlan_5_export.needNum1_export
    self.next1 = self.root.board1_export.node1_export.Node_Normal_export.next1_mlan_10_export
    self.nextNum1 = self.root.board1_export.node1_export.Node_Normal_export.next1_mlan_10_export.nextNum1_export
    self.cdTitle2 = self.root.board1_export.node1_export.Node_Normal_export.cdTitle2_mlan_8_export
    self.cdTime2 = self.root.board1_export.node1_export.Node_Normal_export.cdTitle2_mlan_8_export.cdTime2_export
    self.skillDes1 = self.root.board1_export.node1_export.skillDes1_export
    self.icon1 = self.root.board1_export.node1_export.icon1_export
    self.starF = self.root.board1_export.node1_export.starF_export
    self.starLvNumF = self.root.board1_export.node1_export.starF_export.starLvNumF_export
    self.starF1_bj = self.root.board1_export.node1_export.starF_export.starF1_bj_export
    self.starTotalF1 = self.root.board1_export.node1_export.starF_export.starF1_bj_export.starTotalF1_export
    self.starF1 = self.root.board1_export.node1_export.starF_export.starF1_bj_export.starTotalF1_export.starF1_export
    self.starF2 = self.root.board1_export.node1_export.starF_export.starF1_bj_export.starTotalF1_export.starF2_export
    self.starF2_bj = self.root.board1_export.node1_export.starF_export.starF2_bj_export
    self.starTotalF2 = self.root.board1_export.node1_export.starF_export.starF2_bj_export.starTotalF2_export
    self.starF3 = self.root.board1_export.node1_export.starF_export.starF2_bj_export.starTotalF2_export.starF3_export
    self.starF4 = self.root.board1_export.node1_export.starF_export.starF2_bj_export.starTotalF2_export.starF4_export
    self.starF3_bj = self.root.board1_export.node1_export.starF_export.starF3_bj_export
    self.starTotalF3 = self.root.board1_export.node1_export.starF_export.starF3_bj_export.starTotalF3_export
    self.starF5 = self.root.board1_export.node1_export.starF_export.starF3_bj_export.starTotalF3_export.starF5_export
    self.starF6 = self.root.board1_export.node1_export.starF_export.starF3_bj_export.starTotalF3_export.starF6_export
    self.starF4_bj = self.root.board1_export.node1_export.starF_export.starF4_bj_export
    self.starTotalF4 = self.root.board1_export.node1_export.starF_export.starF4_bj_export.starTotalF4_export
    self.starF7 = self.root.board1_export.node1_export.starF_export.starF4_bj_export.starTotalF4_export.starF7_export
    self.starF8 = self.root.board1_export.node1_export.starF_export.starF4_bj_export.starTotalF4_export.starF8_export
    self.starF5_bj = self.root.board1_export.node1_export.starF_export.starF5_bj_export
    self.starTotalF5 = self.root.board1_export.node1_export.starF_export.starF5_bj_export.starTotalF5_export
    self.starF9 = self.root.board1_export.node1_export.starF_export.starF5_bj_export.starTotalF5_export.starF9_export
    self.starF10 = self.root.board1_export.node1_export.starF_export.starF5_bj_export.starTotalF5_export.starF10_export
    self.starF6_bj = self.root.board1_export.node1_export.starF_export.starF6_bj_export
    self.starTotalF6 = self.root.board1_export.node1_export.starF_export.starF6_bj_export.starTotalF6_export
    self.starF11 = self.root.board1_export.node1_export.starF_export.starF6_bj_export.starTotalF6_export.starF11_export
    self.starF12 = self.root.board1_export.node1_export.starF_export.starF6_bj_export.starTotalF6_export.starF12_export
    self.starF7_bj = self.root.board1_export.node1_export.starF_export.starF7_bj_export
    self.starTotalF7 = self.root.board1_export.node1_export.starF_export.starF7_bj_export.starTotalF7_export
    self.starF13 = self.root.board1_export.node1_export.starF_export.starF7_bj_export.starTotalF7_export.starF13_export
    self.starF14 = self.root.board1_export.node1_export.starF_export.starF7_bj_export.starTotalF7_export.starF14_export
    self.starF8_bj = self.root.board1_export.node1_export.starF_export.starF8_bj_export
    self.starTotalF8 = self.root.board1_export.node1_export.starF_export.starF8_bj_export.starTotalF8_export
    self.starF15 = self.root.board1_export.node1_export.starF_export.starF8_bj_export.starTotalF8_export.starF15_export
    self.starF16 = self.root.board1_export.node1_export.starF_export.starF8_bj_export.starTotalF8_export.starF16_export
    self.starF9_bj = self.root.board1_export.node1_export.starF_export.starF9_bj_export
    self.starTotalF9 = self.root.board1_export.node1_export.starF_export.starF9_bj_export.starTotalF9_export
    self.starF17 = self.root.board1_export.node1_export.starF_export.starF9_bj_export.starTotalF9_export.starF17_export
    self.starF18 = self.root.board1_export.node1_export.starF_export.starF9_bj_export.starTotalF9_export.starF18_export
    self.starF10_bj = self.root.board1_export.node1_export.starF_export.starF10_bj_export
    self.starTotalF10 = self.root.board1_export.node1_export.starF_export.starF10_bj_export.starTotalF10_export
    self.starF19 = self.root.board1_export.node1_export.starF_export.starF10_bj_export.starTotalF10_export.starF19_export
    self.starF20 = self.root.board1_export.node1_export.starF_export.starF10_bj_export.starTotalF10_export.starF20_export
    self.board2 = self.root.board2_export
    self.node2 = self.root.board2_export.node2_export
    self.title2 = self.root.board2_export.node2_export.title2_export
    self.needCon2 = self.root.board2_export.node2_export.needCon2_mlan_5_export
    self.need2 = self.root.board2_export.node2_export.need2_mlan_5_export
    self.needText2 = self.root.board2_export.node2_export.need2_mlan_5_export.needText2_mlan_8_export
    self.needNum2 = self.root.board2_export.node2_export.need2_mlan_5_export.needNum2_export
    self.now2 = self.root.board2_export.node2_export.now2_mlan_10_export
    self.nowNum2 = self.root.board2_export.node2_export.now2_mlan_10_export.nowNum2_export
    self.cdTitle3 = self.root.board2_export.node2_export.cdTitle3_mlan_8_export
    self.cdTime3 = self.root.board2_export.node2_export.cdTitle3_mlan_8_export.cdTime3_export
    self.skillDes2 = self.root.board2_export.node2_export.skillDes2_export
    self.icon2 = self.root.board2_export.node2_export.icon2_export
    self.star = self.root.board2_export.node2_export.star_export
    self.star1_bj = self.root.board2_export.node2_export.star_export.star1_bj_export
    self.starTotal1 = self.root.board2_export.node2_export.star_export.star1_bj_export.starTotal1_export
    self.star1 = self.root.board2_export.node2_export.star_export.star1_bj_export.starTotal1_export.star1_export
    self.star2 = self.root.board2_export.node2_export.star_export.star1_bj_export.starTotal1_export.star2_export
    self.star2_bj = self.root.board2_export.node2_export.star_export.star2_bj_export
    self.starTotal2 = self.root.board2_export.node2_export.star_export.star2_bj_export.starTotal2_export
    self.star3 = self.root.board2_export.node2_export.star_export.star2_bj_export.starTotal2_export.star3_export
    self.star4 = self.root.board2_export.node2_export.star_export.star2_bj_export.starTotal2_export.star4_export
    self.star3_bj = self.root.board2_export.node2_export.star_export.star3_bj_export
    self.starTotal3 = self.root.board2_export.node2_export.star_export.star3_bj_export.starTotal3_export
    self.star5 = self.root.board2_export.node2_export.star_export.star3_bj_export.starTotal3_export.star5_export
    self.star6 = self.root.board2_export.node2_export.star_export.star3_bj_export.starTotal3_export.star6_export
    self.star4_bj = self.root.board2_export.node2_export.star_export.star4_bj_export
    self.starTotal4 = self.root.board2_export.node2_export.star_export.star4_bj_export.starTotal4_export
    self.star7 = self.root.board2_export.node2_export.star_export.star4_bj_export.starTotal4_export.star7_export
    self.star8 = self.root.board2_export.node2_export.star_export.star4_bj_export.starTotal4_export.star8_export
    self.star5_bj = self.root.board2_export.node2_export.star_export.star5_bj_export
    self.starTotal5 = self.root.board2_export.node2_export.star_export.star5_bj_export.starTotal5_export
    self.star9 = self.root.board2_export.node2_export.star_export.star5_bj_export.starTotal5_export.star9_export
    self.star10 = self.root.board2_export.node2_export.star_export.star5_bj_export.starTotal5_export.star10_export
    self.star6_bj = self.root.board2_export.node2_export.star_export.star6_bj_export
    self.starTotal6 = self.root.board2_export.node2_export.star_export.star6_bj_export.starTotal6_export
    self.star11 = self.root.board2_export.node2_export.star_export.star6_bj_export.starTotal6_export.star11_export
    self.star12 = self.root.board2_export.node2_export.star_export.star6_bj_export.starTotal6_export.star12_export
    self.star7_bj = self.root.board2_export.node2_export.star_export.star7_bj_export
    self.starTotal7 = self.root.board2_export.node2_export.star_export.star7_bj_export.starTotal7_export
    self.star13 = self.root.board2_export.node2_export.star_export.star7_bj_export.starTotal7_export.star13_export
    self.star14 = self.root.board2_export.node2_export.star_export.star7_bj_export.starTotal7_export.star14_export
    self.star8_bj = self.root.board2_export.node2_export.star_export.star8_bj_export
    self.starTotal8 = self.root.board2_export.node2_export.star_export.star8_bj_export.starTotal8_export
    self.star15 = self.root.board2_export.node2_export.star_export.star8_bj_export.starTotal8_export.star15_export
    self.star16 = self.root.board2_export.node2_export.star_export.star8_bj_export.starTotal8_export.star16_export
    self.star9_bj = self.root.board2_export.node2_export.star_export.star9_bj_export
    self.starTotal9 = self.root.board2_export.node2_export.star_export.star9_bj_export.starTotal9_export
    self.star17 = self.root.board2_export.node2_export.star_export.star9_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.board2_export.node2_export.star_export.star9_bj_export.starTotal9_export.star18_export
    self.star10_bj = self.root.board2_export.node2_export.star_export.star10_bj_export
    self.starTotal10 = self.root.board2_export.node2_export.star_export.star10_bj_export.starTotal10_export
    self.star19 = self.root.board2_export.node2_export.star_export.star10_bj_export.starTotal10_export.star19_export
    self.star20 = self.root.board2_export.node2_export.star_export.star10_bj_export.starTotal10_export.star20_export
    self.starLvNum = self.root.board2_export.node2_export.star_export.starLvNum_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPetEquipTips:setData(msg)

    dump(msg.information, " -- UIPetEquipTips: ")

    self.board1:setVisible(false)
    self.board2:setVisible(false)

    local configData = msg.information.curLvData.config
    local data = msg.information.curLvData
    if data.serverData and data.serverData.lState == 2 then -- 已激活
        self:havLockTips(msg, configData.triggerType)
    else
        self:unLockTips(msg, configData.triggerType)
    end

end

-- 未解锁技能  triggerType 1主动技能 2被动技能
function UIPetEquipTips:unLockTips(msg, triggerType)
    -- body
    local data = msg.information.curLvData
    local configData = msg.information.curLvData.config
    local nextLvData = msg.information.nextLvData
    local expandPer = luaCfg:get_pet_activation_by(1).skillExpand
    local unit = luaCfg:get_data_type_by(configData.buff).extra

    self.board2:setVisible(true)
    self.title2:setString(configData.name)
    global.panelMgr:setTextureFor(self.icon2, configData.icon)
    self.skillDes2:setString(luaCfg:get_local_string(configData.des))
    self.needNum2:setString(configData.needSkillPoint)

    -- -- 技能已满级
    local curPet = msg.curPet 
    -- self.needCondit2:setTextColor(cc.c3b(255,226,165))
    local nextIdTemp = configData.nextId
    if nextIdTemp == 0 then
        self.star:setVisible(false)
        -- self.needCondit2:setString(luaCfg:get_local_string(10952))
    else
        -- self.needCondit2:setString(luaCfg:get_translate_string(10986, nextLvData.petLv))
        -- if curPet.serverData and curPet.serverData.lGrade < nextLvData.petLv then 
        --     self.needCondit2:setTextColor(cc.c3b(180,29,11))
        -- end
        -- 升级条件
        self.star:setVisible(true)
        local lv = nextLvData.petLv
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
        self.star:setPositionX(self.Node_Normal:getPositionX()+self.needCon1:getContentSize().width+25)
    end


    self.cdTitle3:setVisible(false)
    self.nowNum2:setString(configData.name .. configData.value/expandPer .. unit)
    self.now2:setPositionY(-421)
    if triggerType == 1 then -- 主动技能
        self.now2:setPositionY(-455)
        self.cdTitle3:setVisible(true)
        self.cdTime3:setString(global.funcGame.formatTimeToHMS(configData.CDTime))
        self.nowNum2:setString(luaCfg:get_local_string(configData.activeDes, configData.value/expandPer .. unit))
        if configData.continueTime ~= 0 then 
            if configData.type == 33 then -- 反侦察
                self.nowNum2:setString(luaCfg:get_local_string(configData.activeDes, configData.continueTime/3600))
            else
                self.nowNum2:setString(luaCfg:get_local_string(configData.activeDes, configData.value/expandPer .. unit, configData.continueTime/3600))
            end
        end
    end

    global.tools:adjustNodePosForFather(self.nowNum2:getParent(), self.nowNum2)
    global.tools:adjustNodePosForFather(self.needNum2:getParent(), self.needNum2)
    global.tools:adjustNodePosForFather(self.cdTime3:getParent(), self.cdTime3)
    -- global.tools:adjustNodePosForFather(self.needCondit2:getParent(), self.needCondit2)
    self.needText2:setPositionX(self.needNum2:getPositionX()+self.needNum2:getContentSize().width)

end

-- 已解锁技能
function UIPetEquipTips:havLockTips(msg, triggerType)
    -- body
    local data = msg.information.curLvData
    local configData = msg.information.curLvData.config
    local nextLvData = msg.information.nextLvData
    local expandPer = luaCfg:get_pet_activation_by(1).skillExpand
    local unit = luaCfg:get_data_type_by(configData.buff).extra

    self.board1:setVisible(true)
    self.title1:setString(configData.name)
    self.lvNum1:setString("(Lv." .. data.serverData.lGrade .. ") ")
    global.panelMgr:setTextureFor(self.icon1, configData.icon)
    self.skillDes1:setString(luaCfg:get_local_string(configData.des))
    self.needNum1:setString(configData.needSkillPoint)

    -- 技能已满级
    local curPet = msg.curPet 
    --self.needCondit1:setTextColor(cc.c3b(255,226,165))
    local nextIdTemp = configData.nextId
    if nextIdTemp == 0 then
        --self.needCondit1:setString(luaCfg:get_local_string(10952))
        self.starF:setVisible(false)
    else
        -- self.needCondit1:setString(luaCfg:get_translate_string(10986, nextLvData.petLv))
        -- if curPet.serverData and curPet.serverData.lGrade < nextLvData.petLv then 
        --     self.needCondit1:setTextColor(cc.c3b(180,29,11))
        -- end
    
        -- 升级条件
        self.starF:setVisible(true)
        local lv = nextLvData.petLv
        local curClass = math.ceil(lv/10) 
        for i=1,10 do
            self["starF"..i.."_bj"]:setVisible(false)
            if i<=curClass then
                self["starF"..i.."_bj"]:setVisible(true)
            end
        end
        local per = 10
        local curLvClass = math.ceil(lv/per)
        if curLvClass == 1 then
            self.starLvNumF:setString("+"..lv)
        else
            self.starLvNumF:setString("+"..(lv-per*(curLvClass-1)))
        end
        self.starLvNumF:setPositionX(self["starF"..curClass.."_bj"]:getPositionX()+15)
        self.starF:setPositionX(self.Node_Normal:getPositionX()+self.needCon1:getContentSize().width+25)
    end


    self.nowNum1:setString(configData.name .. configData.value/expandPer .. unit)
    self.cdTitle1:setVisible(false)
    self.cdTitle2:setVisible(false)
    --self.now1:setPositionY(-375)
    self.next1:setPositionY(-545)
    if triggerType == 1 then -- 主动技能
        --self.now1:setPositionY(-357)
        self.next1:setPositionY(-576)
        self.cdTitle1:setVisible(true)
        self.cdTitle2:setVisible(true)
        self.cdTime1:setString(global.funcGame.formatTimeToHMS(configData.CDTime))
        self.nowNum1:setString(luaCfg:get_local_string(configData.activeDes, configData.value/expandPer .. unit))

        if configData.continueTime ~= 0 then 
            if configData.type == 33 then -- 反侦察
                self.nowNum1:setString(luaCfg:get_local_string(configData.activeDes, configData.continueTime/3600))
            else
                self.nowNum1:setString(luaCfg:get_local_string(configData.activeDes, configData.value/expandPer .. unit, configData.continueTime/3600))
            end
        end

    end

    self.Node_Normal:setVisible(false)
    self.Node_Max:setVisible(false)
    if data.serverData.lGrade < configData.skillMax then 
        self.Node_Normal:setVisible(true)
        self.nextLvNum1:setString(luaCfg:get_local_string(11082, "Lv." .. data.serverData.lGrade+1))
        self.cdTime2:setString(global.funcGame.formatTimeToHMS(nextLvData.CDTime))

        self.nextNum1:setString(configData.name ..  nextLvData.value/expandPer .. unit)
        if triggerType == 1 then -- 主动技能
            self.nextNum1:setString(luaCfg:get_local_string(configData.activeDes, nextLvData.value/expandPer .. unit))

            if nextLvData.continueTime ~= 0 then 
                if nextLvData.type == 33 then -- 反侦察
                    self.nextNum1:setString(luaCfg:get_local_string(nextLvData.activeDes, nextLvData.continueTime/3600))
                else
                    self.nextNum1:setString(luaCfg:get_local_string(nextLvData.activeDes, nextLvData.value/expandPer .. unit, nextLvData.continueTime/3600))
                end
            end

        end
    else
        self.Node_Max:setVisible(true)
        self.maxCd:setVisible(false)
        if triggerType == 1 then -- 主动技能
            self.maxCd:setVisible(true)
        end 
    end

    global.tools:adjustNodePosForFather(self.nowNum1:getParent(), self.nowNum1)
    global.tools:adjustNodePosForFather(self.nextNum1:getParent(), self.nextNum1)
    global.tools:adjustNodePosForFather(self.needNum1:getParent(), self.needNum1)
    global.tools:adjustNodePosForFather(self.cdTime1:getParent(), self.cdTime1)
    global.tools:adjustNodePosForFather(self.cdTime2:getParent(), self.cdTime2)

    global.tools:adjustNodePos(self.title1, self.lvNum1)
    self.needText1:setPositionX(self.needNum1:getPositionX()+self.needNum1:getContentSize().width)

end

--CALLBACKS_FUNCS_END

return UIPetEquipTips

--endregion
