--region UITechInfoPanel.lua
--Author : yyt
--Date   : 2017/03/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UITechInfoItem = require("game.UI.science.tech.UITechInfoItem")
local UITechInfoNormalItem = require("game.UI.science.tech.UITechInfoNormalItem")
--REQUIRE_CLASS_END

local UITechInfoPanel  = class("UITechInfoPanel", function() return gdisplay.newWidget() end )

function UITechInfoPanel:ctor()
    self:CreateUI()
end

function UITechInfoPanel:CreateUI()
    local root = resMgr:createWidget("science/tech_info_bg")
    self:initUI(root)
end

function UITechInfoPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "science/tech_info_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.science_name = self.root.Node_export.science_name_export
    self.icon = self.root.Node_export.Image_14.icon_export
    self.res_icon = self.root.Node_export.Image_14.res_icon_export
    self.lv = self.root.Node_export.Image_14.lv_export
    self.des = self.root.Node_export.Image_14.des_export
    self.now_num = self.root.Node_export.Image_14.nowlv_mlan_6.now_num_export
    self.next_num = self.root.Node_export.Image_14.nextlv_mlan_6.next_num_export
    self.target = self.root.Node_export.Image_14.target_export
    self.targetFinish = self.root.Node_export.Image_14.targetFinish_export
    self.awaken_target = self.root.Node_export.Image_14.targetFinish_export.awaken_target_export
    self.target_finish = self.root.Node_export.Image_14.targetFinish_export.target_finish_export
    self.btn_study = self.root.Node_export.Image_14.btn_study_export
    self.time = self.root.Node_export.Image_14.btn_study_export.time_export
    self.btn_quickstudy = self.root.Node_export.Image_14.btn_quickstudy_export
    self.num = self.root.Node_export.Image_14.btn_quickstudy_export.num_export
    self.ScrollView_1 = self.root.Node_export.ScrollView_1_export
    self.FileNode_Now = self.root.Node_export.ScrollView_1_export.FileNode_Now_export
    self.FileNode_Now = UITechInfoItem.new()
    uiMgr:configNestClass(self.FileNode_Now, self.root.Node_export.ScrollView_1_export.FileNode_Now_export)
    self.FileNode_1 = self.root.Node_export.ScrollView_1_export.FileNode_1_export
    self.FileNode_1 = UITechInfoNormalItem.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.ScrollView_1_export.FileNode_1_export)
    self.FileNode_2 = self.root.Node_export.ScrollView_1_export.FileNode_2_export
    self.FileNode_2 = UITechInfoNormalItem.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.Node_export.ScrollView_1_export.FileNode_2_export)
    self.FileNode_3 = self.root.Node_export.ScrollView_1_export.FileNode_3_export
    self.FileNode_3 = UITechInfoNormalItem.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.Node_export.ScrollView_1_export.FileNode_3_export)
    self.FileNode_4 = self.root.Node_export.ScrollView_1_export.FileNode_4_export
    self.FileNode_4 = UITechInfoNormalItem.new()
    uiMgr:configNestClass(self.FileNode_4, self.root.Node_export.ScrollView_1_export.FileNode_4_export)
    self.FileNode_5 = self.root.Node_export.ScrollView_1_export.FileNode_5_export
    self.FileNode_5 = UITechInfoNormalItem.new()
    uiMgr:configNestClass(self.FileNode_5, self.root.Node_export.ScrollView_1_export.FileNode_5_export)
    self.FileNode_6 = self.root.Node_export.ScrollView_1_export.FileNode_6_export
    self.FileNode_6 = UITechInfoNormalItem.new()
    uiMgr:configNestClass(self.FileNode_6, self.root.Node_export.ScrollView_1_export.FileNode_6_export)
    self.FileNode_7 = self.root.Node_export.ScrollView_1_export.FileNode_7_export
    self.FileNode_7 = UITechInfoNormalItem.new()
    uiMgr:configNestClass(self.FileNode_7, self.root.Node_export.ScrollView_1_export.FileNode_7_export)
    self.FileNode_8 = self.root.Node_export.ScrollView_1_export.FileNode_8_export
    self.FileNode_8 = UITechInfoNormalItem.new()
    uiMgr:configNestClass(self.FileNode_8, self.root.Node_export.ScrollView_1_export.FileNode_8_export)
    self.FileNode_9 = self.root.Node_export.ScrollView_1_export.FileNode_9_export
    self.FileNode_9 = UITechInfoNormalItem.new()
    uiMgr:configNestClass(self.FileNode_9, self.root.Node_export.ScrollView_1_export.FileNode_9_export)
    self.FileNode_10 = self.root.Node_export.ScrollView_1_export.FileNode_10_export
    self.FileNode_10 = UITechInfoNormalItem.new()
    uiMgr:configNestClass(self.FileNode_10, self.root.Node_export.ScrollView_1_export.FileNode_10_export)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_study, function(sender, eventType) self:onNormalTechHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_quickstudy, function(sender, eventType) self:onNoCdTechHandler(sender, eventType) end)
--EXPORT_NODE_END

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UITechInfoPanel:onEnter()

    self.isClickTeching = false
    self:addEventListener(global.gameEvent.EV_ON_UI_TECH_FLUSH, function()
        if not self.isExit then
            self:setData(self.data)
            self:setTechBuff()
        end
    end)

    -- 科技加成
    self:setTechBuff()
    
end

function UITechInfoPanel:onExit()
    -- body
    self.isClickTeching = false
end

function UITechInfoPanel:setTechBuff()

    local buffTimeBuffVal = 0
    local tgReq, temp = {}, {}
    temp.lType = 11
    temp.lBind = 0
    table.insert(tgReq, temp)
    global.gmApi:effectBuffer(tgReq, function (msg)
        
        self.techTime = self.techTime or 0 
        msg.tgEffect = msg.tgEffect or {}
        for _,v in pairs(msg.tgEffect) do
            if v.tgEffect then 
                local temp = {lEffectID=3066, lVal=1}
                for _,vv in pairs(v.tgEffect) do
                    if vv.lEffectID == 3066 then
                        temp.lVal =  (1 - vv.lVal/100)*temp.lVal
                    elseif vv.lEffectID == 3046 then
                        buffTimeBuffVal = math.floor(100-(100-buffTimeBuffVal)*(100-vv.lVal)/100)
                    end
                end
                global.techData:setTechBuff(temp)
                self.techTime = self.techTime-math.floor(self.techTime*buffTimeBuffVal/100)
                if not tolua.isnull(self.time) then 
                    self.time:setString(global.funcGame.formatTimeToHMS(self.techTime))
                end 
            end
        end
        if not self.isExit then
            if self.setCondition then 
                self:setCondition()
            end 
        end
    end)
end

function UITechInfoPanel:setData(data)

    self.data = data
    self.des:setString(data.des)
    -- self.res_icon:setSpriteFrame(data.icon)
    global.panelMgr:setTextureFor(self.res_icon,data.icon)
    self.res_icon:setScale(0.8)
    self.science_name:setString(data.name)
    self.needDiamondNum = 0

    local contate = 0
    if data.conditState then
        if data.conditState.lCur >= data.conditState.lMax then
            contate = 1
        end
    end

    local condit = luaCfg:get_target_condition_by(data.edification)
    -- 启迪目标已完成
    if contate == 1 then
        self.targetFinish:setVisible(true)
        self.target:setVisible(false)
        local finishStr = luaCfg:get_local_string(10407, "") .. luaCfg:get_local_string(10476)
        self.target_finish:setString(finishStr)
        self.awaken_target:setString(luaCfg:get_local_string(10641, data.edificationEffect))
    else   
        self.targetFinish:setVisible(false) 
        self.target:setVisible(true)
        uiMgr:setRichText(self, "target", 50042 , {target = condit.description, num=data.edificationEffect})
    end

    self:setBuffParm(condit.id)
    self:setCondition()

    self:checkDiamondEnough(self.needDiamondNum)

    self.isExit = false
end

function UITechInfoPanel:checkDiamondEnough(num)
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,num) then
        self.num:setTextColor(gdisplay.COLOR_RED)
        return false
    else
        self.num:setTextColor(cc.c3b(255, 184, 34))
        return true
    end
end

-- 当前是否有科技第二队列月卡
function UITechInfoPanel:checkTechMonthCard()
    
    -- local monthCard = global.rechargeData:getMonthByType(4)
    -- if monthCard and monthCard.serverData.lState >= 0 then
    --     return true
    -- else
    --     return false
    -- end


    return global.techData:checkTechMonthCard()
end

function UITechInfoPanel:setCondition()
    
    local flag = false 
    local isNeed = false
    local totalNum = 0

    -- 当前是否有科技第二队列月卡
    local isTechMonthCard = self:checkTechMonthCard()

    local showNow = function ()
        self.FileNode_Now:setVisible(true)
        self.FileNode_Now:setData()
        flag = true 
        totalNum = totalNum + 1
    end

    local queue = global.techData:getQueueByTime()
    if (not isTechMonthCard) and global.techData:isHaveTech() then 
        showNow()
        if (#queue) == 1 then
            isNeed = true
        end
    else
        if (#queue) > 1 then
            showNow()
        else
            isNeed = true
            self.FileNode_Now:setVisible(false)
        end
    end

    local temp = luaCfg:science_lvup()

    local lvData = {}
    for _,v in pairs(temp) do
        if self.data.id == v.id and (self.data.lGrade+1) == v.lv then
            lvData = clone(v)
        end
    end

    if lvData.orderId then

        local totalTrigger = 10
        local isVis_Node = function (i)
            if flag then  
                self["FileNode_"..i].bg:setVisible(i%2 == 0)
            else
                self["FileNode_"..i].bg:setVisible(i%2 ~= 0)
            end
        end

        local isCanTech = true
        -- 前置科技
        for i=1,totalTrigger do
            self["FileNode_"..i]:setVisible(false)
            if lvData.preposeTarget[i] then
                self["FileNode_"..i]:setVisible(true)
                self["FileNode_"..i]:setData(lvData.preposeTarget[i], 1)
                isVis_Node(i)
                self["FileNode_"..i]:setState(self:getTechCondit(lvData.preposeTarget[i]))
                isCanTech = self:getTechCondit(lvData.preposeTarget[i]) and isCanTech
                totalNum = totalNum + 1
            end 
        end

        -- 建筑等级
        local prepNum = (#lvData.preposeTarget)
        for i=(prepNum+1), totalTrigger do
            if lvData.unlockTarget[i-prepNum] then
                self["FileNode_"..i]:setVisible(true)
                self["FileNode_"..i]:setData(lvData.unlockTarget[i-prepNum], 2)
                isVis_Node(i)
                isCanTech = global.funcGame:checkTarget(lvData.unlockTarget[i-prepNum]) and isCanTech
                totalNum = totalNum + 1
            end
        end

        -- 资源要求
        local sourNum = prepNum+(#lvData.unlockTarget)
        for i=sourNum+1, totalTrigger do
            if lvData.resource[i-sourNum] then

                local resource = clone(lvData.resource[i-sourNum])
                local buffs = global.techData:getTechBuff()
                if buffs.lEffectID then
                    resource[2] = math.ceil(buffs.lVal*resource[2])               
                end
                self["FileNode_"..i]:setVisible(true)
                self["FileNode_"..i]:setData(resource, 3)
                isVis_Node(i)
                isCanTech = global.cityData:checkResource(resource) and isCanTech
                totalNum = totalNum + 1
            end
        end

        self.btn_study:setEnabled(isCanTech and isNeed)
        self.btn_quickstudy:setEnabled(isCanTech and isNeed)

        local containSizeH = totalNum*50+10
        local contentSizeH = self.ScrollView_1:getContentSize().height
        if containSizeH < contentSizeH then
            containSizeH = contentSizeH          
        end

        local posY = 10
        if flag then
            self.FileNode_Now:setPositionY(containSizeH - 60)
            posY = 60
        end 
        for i=1,10 do
            self["FileNode_"..i]:setPositionY(containSizeH-50*i-posY)
        end

        self.ScrollView_1:setInnerContainerSize(cc.size(gdisplay.width, containSizeH))
        self.ScrollView_1:jumpToTop()

    end

end

-- 前置科技
function UITechInfoPanel:getTechCondit(preposeTargetId)
    
    local lvData = luaCfg:get_science_lvup_by(preposeTargetId)
    local scienceData = global.techData:getTechById(lvData.id)
    if lvData.lv <= scienceData.lGrade then
        return true
    end
    return false
end

function UITechInfoPanel:setBuffParm(conditId)

    local lvData = luaCfg:science_lvup()
    for _,v in pairs(lvData) do
        if v.id == self.data.id then
            local buffData = luaCfg:get_data_type_by(v.buff)
            if v.lv == self.data.lGrade then
                self.now_num:setString("+"..v.buffNum..buffData.extra)
            elseif v.lv == (self.data.lGrade+1) then
                self.next_num:setString("+"..v.buffNum..buffData.extra)
            
                local techTime = v.time
                local contate = 0
                if self.data.conditState then
                    if self.data.conditState.lCur >= self.data.conditState.lMax then
                        contate = 1
                    end
                end
                if contate == 1 then
                    local scienceData = luaCfg:get_science_by(self.data.id)
                    techTime = techTime*(1-scienceData.edificationEffect/100)
                end
                self.techTime = math.ceil(techTime)
                self.time:setString(global.funcGame.formatTimeToHMS(techTime))


                self.num:setString(global.funcGame.getDiamondCount(techTime))
                self.needDiamondNum = global.funcGame.getDiamondCount(techTime)
            end
        end
    end
    self.lv:setString(luaCfg:get_local_string(10410, self.data.lGrade, self.data.maxLv))

    if self.data.lGrade == 0 then 
        self.now_num:setString(0)
    end
    --修改科技页面重叠 阿成
    global.tools:adjustNodePosForFather(self.now_num:getParent(),self.now_num)
    global.tools:adjustNodePosForFather(self.next_num:getParent(),self.next_num)

end

function UITechInfoPanel:exitCall(sender, eventType)
    self.isExit = true
    global.panelMgr:closePanel("UITechInfoPanel")
end

function UITechInfoPanel:onNormalTechHandler(sender, eventType)
    
    if  self.isClickTeching then return end

    local confirmCall = function ()
        
        self.isClickTeching = true
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_scienbuilding")
        global.techApi:techScience(0, self.data.id, function (msg)
            
            self:dealCall(msg)
        end)
    end

    local isTechMonthCard = self:checkTechMonthCard()
    if global.techData:isHaveTech() and (not isTechMonthCard) then

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData("WEEK_CARD_RENEW_3", function ()
            global.panelMgr:openPanel("UIMonthCardPanel"):setData(handler(self, self.refershMonthCard))
        end)
        return
    end

    confirmCall()

end

function UITechInfoPanel:onNoCdTechHandler(sender, eventType)
    
    if  self.isClickTeching then return end

    local confirmCall = function ()
            
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_scienbuilding")
        if self:checkDiamondEnough(self.needDiamondNum) then

            self.isClickTeching = true
            global.techApi:techScience(1, self.data.id, function (msg)

                self:dealCall(msg)
                local scienceData = luaCfg:get_science_by(self.data.id)
                msg.tgTech = msg.tgTech or {}
                msg.tgTech[1] = msg.tgTech[1] or {}
                global.tipsMgr:showWarning(luaCfg:get_local_string(10438, scienceData.name, msg.tgTech[1].lGrade or 1))
            end)
        else
            
            global.panelMgr:openPanel("UIRechargePanel")
            return
        end
    end

    local isTechMonthCard = self:checkTechMonthCard()
    if global.techData:isHaveTech() and (not isTechMonthCard) then

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData("WEEK_CARD_RENEW_3", function ()
            global.panelMgr:openPanel("UIMonthCardPanel"):setData(handler(self, self.refershMonthCard))
        end)
        return
    end

    confirmCall()
    

end

-- 退出充值月卡刷新
function UITechInfoPanel:refershMonthCard()
    
    local data = global.techData:getTechById(self.data.id)
    self:setData(data)
end

function UITechInfoPanel:dealCall(msg)
    
    self:exitCall()
    msg.tgTech = msg.tgTech or {}
    msg.tgQueue = msg.tgQueue or {}
    global.techData:updateTech(msg.tgTech[1] or {}, msg.tgQueue[1] or {})

    self.isClickTeching = false
end
--CALLBACKS_FUNCS_END

return UITechInfoPanel

--endregion
