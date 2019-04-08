--region UILordPanel.lua
--Author : yyt
--Date   : 2016/09/27
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIAdSlideNode = require("game.UI.advertisementItem.UIAdSlideNode")
--REQUIRE_CLASS_END

local UILordPanel  = class("UILordPanel", function() return gdisplay.newWidget() end )
local UIAdvertisementItem = require("game.UI.advertisementItem.UIAdvertisementItem")

local luaCfg = global.luaCfg
local equipData = global.equipData
local gameEvent =global.gameEvent

function UILordPanel:ctor()
    self:CreateUI()
end

function UILordPanel:CreateUI()
    local root = resMgr:createWidget("lord/lord_data_bg")
    self:initUI(root)
end

function UILordPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "lord/lord_data_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title_layout = self.root.title_layout_export
    self.FileNode_1 = UIAdSlideNode.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)
    self.acm_point = self.root.operation_bg2.btn_operation_node.btn_achievement.acm_point_export
    self.point_Text = self.root.operation_bg2.btn_operation_node.btn_achievement.acm_point_export.point_Text_export
    self.questPoint = self.root.operation_bg2.btn_operation_node.btn_questionnaire.questPoint_export
    self.ScroPanel = self.root.ScroPanel_export
    self.lord_tt = self.root.ScroPanel_export.lord_tt_export
    self.head_bt = self.root.ScroPanel_export.head_bt_export
    self.portrait_node = self.root.ScroPanel_export.head_bt_export.portrait_node_export
    self.headFream = self.root.ScroPanel_export.head_bt_export.portrait_node_export.headFream_export
    self.lord_red_point = self.root.ScroPanel_export.head_bt_export.lord_red_point_export
    self.equiment_node = self.root.ScroPanel_export.equiment_node_export
    self.equipment_bg1 = self.root.ScroPanel_export.equiment_node_export.equipment_bg1_export
    self.quality_1 = self.root.ScroPanel_export.equiment_node_export.equipment_bg1_export.quality_1_export
    self.back_bg_1 = self.root.ScroPanel_export.equiment_node_export.equipment_bg1_export.back_bg_1_export
    self.icon1 = self.root.ScroPanel_export.equiment_node_export.equipment_bg1_export.iconParent.icon1_export
    self.strog = self.root.ScroPanel_export.equiment_node_export.equipment_bg1_export.strog_export
    self.equipment_bg2 = self.root.ScroPanel_export.equiment_node_export.equipment_bg2_export
    self.quality_2 = self.root.ScroPanel_export.equiment_node_export.equipment_bg2_export.quality_2_export
    self.back_bg_2 = self.root.ScroPanel_export.equiment_node_export.equipment_bg2_export.back_bg_2_export
    self.icon2 = self.root.ScroPanel_export.equiment_node_export.equipment_bg2_export.iconParent.icon2_export
    self.strog = self.root.ScroPanel_export.equiment_node_export.equipment_bg2_export.strog_export
    self.equipment_bg3 = self.root.ScroPanel_export.equiment_node_export.equipment_bg3_export
    self.quality_3 = self.root.ScroPanel_export.equiment_node_export.equipment_bg3_export.quality_3_export
    self.back_bg_3 = self.root.ScroPanel_export.equiment_node_export.equipment_bg3_export.back_bg_3_export
    self.icon3 = self.root.ScroPanel_export.equiment_node_export.equipment_bg3_export.iconParent.icon3_export
    self.strog = self.root.ScroPanel_export.equiment_node_export.equipment_bg3_export.strog_export
    self.equipment_bg4 = self.root.ScroPanel_export.equiment_node_export.equipment_bg4_export
    self.quality_4 = self.root.ScroPanel_export.equiment_node_export.equipment_bg4_export.quality_4_export
    self.back_bg_4 = self.root.ScroPanel_export.equiment_node_export.equipment_bg4_export.back_bg_4_export
    self.icon4 = self.root.ScroPanel_export.equiment_node_export.equipment_bg4_export.iconParent.icon4_export
    self.strog = self.root.ScroPanel_export.equiment_node_export.equipment_bg4_export.strog_export
    self.equipment_bg5 = self.root.ScroPanel_export.equiment_node_export.equipment_bg5_export
    self.quality_5 = self.root.ScroPanel_export.equiment_node_export.equipment_bg5_export.quality_5_export
    self.back_bg_5 = self.root.ScroPanel_export.equiment_node_export.equipment_bg5_export.back_bg_5_export
    self.icon5 = self.root.ScroPanel_export.equiment_node_export.equipment_bg5_export.iconParent.icon5_export
    self.strog = self.root.ScroPanel_export.equiment_node_export.equipment_bg5_export.strog_export
    self.equipment_bg6 = self.root.ScroPanel_export.equiment_node_export.equipment_bg6_export
    self.quality_6 = self.root.ScroPanel_export.equiment_node_export.equipment_bg6_export.quality_6_export
    self.back_bg_6 = self.root.ScroPanel_export.equiment_node_export.equipment_bg6_export.back_bg_6_export
    self.icon6 = self.root.ScroPanel_export.equiment_node_export.equipment_bg6_export.iconParent.icon6_export
    self.strog = self.root.ScroPanel_export.equiment_node_export.equipment_bg6_export.strog_export
    self.exp_icon_bg = self.root.exp_node.exp_icon_bg_export
    self.exp_bar_bg = self.root.exp_node.exp_bar_bg_export
    self.exp_LoadingBar = self.root.exp_node.expLayout.exp_LoadingBar_export
    self.exp_loading_pic = self.root.exp_node.expLayout.exp_LoadingBar_export.exp_loading_pic_export
    self.exp_value = self.root.exp_node.exp_value_export
    self.exp_split = self.root.exp_node.exp_split_export
    self.exp_upper_limit = self.root.exp_node.exp_upper_limit_export
    self.expBuy = self.root.exp_node.expBuy_export
    self.strength_icon_bg = self.root.strength_node.strength_icon_bg_export
    self.strength_bar_bg = self.root.strength_node.strength_bar_bg_export
    self.strength_LoadingBar = self.root.strength_node.hpLayout.strength_LoadingBar_export
    self.strength_loading_pci = self.root.strength_node.hpLayout.strength_LoadingBar_export.strength_loading_pci_export
    self.strength_value = self.root.strength_node.strength_value_export
    self.strength_upper_limit = self.root.strength_node.strength_upper_limit_export
    self.strengthBuy = self.root.strength_node.strengthBuy_export
    self.lordName = self.root.lord_data_bg2.lord_data2_node.lord_name_mlan_5.lordName_export
    self.btn_edit = self.root.lord_data_bg2.lord_data2_node.btn_edit_export
    self.lord_lv = self.root.lord_data_bg2.lord_data2_node.lord_lv_mlan_10.lord_lv_export
    self.alliance_name = self.root.lord_data_bg2.lord_data2_node.alliance_name_mlan_10.alliance_name_export
    self.lord_id = self.root.lord_data_bg2.lord_data2_node.lord_id_mlan_10.lord_id_export
    self.bottom_layout = self.root.bottom_layout_export
    self.TipLayout = self.root.TipLayout_export

    uiMgr:addWidgetTouchHandler(self.root.operation_bg2.btn_operation_node.btn_achievement, function(sender, eventType) self:achieve_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.operation_bg2.btn_operation_node.btn_list, function(sender, eventType) self:rank_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.operation_bg2.btn_operation_node.btn_set, function(sender, eventType) self:setting_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.operation_bg2.btn_operation_node.btn_vip, function(sender, eventType) self:vip_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.operation_bg2.btn_operation_node.btn_questionnaire, function(sender, eventType) self:questionHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.head_bt, function(sender, eventType) self:iconChange_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScroPanel_export.head_bt_export.portrait_node_export.lord_icon_change_0, function(sender, eventType) self:iconChange_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.expBuy, function(sender, eventType) self:addExp_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.strengthBuy, function(sender, eventType) self:addEnergy_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.lord_data_bg2.lord_data2_node.lord_name_mlan_5.lordBtn, function(sender, eventType) self:nameEditHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_edit, function(sender, eventType) self:nameEditHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.strength_node = self.root.strength_node
    self:adapt()
    uiMgr:addWidgetTouchHandler(self.root.common_title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    self.touchSwitch = {self.strength_bar_bg, self.strength_icon_bg }
    for _,v in pairs(self.touchSwitch) do
        global.tipsMgr:registerLongPress(self, v, self.TipLayout ,
            handler(self, self.initTextTips), handler(self, self.longPressDeal))
    end  

    self.lastStrength = 0
    self.lastPer = 0

    for i=1,6 do
        self["icon"..i]:setSwallowTouches(false)        
    end

    self.head_bt:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    
    self.btn_questionnaire = self.root.operation_bg2.btn_operation_node.btn_questionnaire

 end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UILordPanel:adapt()

    local sHeight = gdisplay.height - self.title_layout:getContentSize().height - self.bottom_layout:getContentSize().height
    local defY = self.ScroPanel:getContentSize().height
    self.ScroPanel:setContentSize(cc.size(gdisplay.width, sHeight))
    local minsize= cc.size(gdisplay.width, defY)
    if sHeight < defY then 
        self.ScroPanel:setInnerContainerSize(minsize)
        self.lord_tt:setContentSize(minsize)
    else
        self.ScroPanel:setInnerContainerSize(cc.size(gdisplay.width, sHeight))
        self.lord_tt:setContentSize(self.ScroPanel:getContentSize())
        local tt = math.abs(self.lord_tt:getPositionY()-sHeight/2)
        for _ ,v in pairs(self.ScroPanel:getChildren()) do 
            v:setPositionY(v:getPositionY()+tt)
        end 
    end 
end 

function UILordPanel:onEnter()
    
    self.ScroPanel:jumpToTop()
    self:addEventListener(global.gameEvent.EV_ON_USER_FLUSHUSEMSG, function ()
        self:changeHeadIcon()
    end) 

    self:checkQuestion()
    self:addEventListener(global.gameEvent.EV_ON_QUESTIONNAIRE,function ()
        -- body
        self:checkQuestion()
    end)

    -- self:addEventListener(global.gameEvent.EV_ON_UI_USER_UPDATE, function ()
    --     self:setData()
    -- end)
   self.FileNode_1:setData(3)

    -- vip 消息更新
    self:addEventListener(global.gameEvent.EV_ON_UI_USER_UPDATE,function()
        self:setData()
        self:reFreshNumber()
        self:setHeroDetail(self.lordHero)
    end)
      
    local checkAcm = function()  
        self.acm_point:setVisible(false)     
        local achCount = global.achieveData:getAcieveNum()
        if achCount > 0 then
            self.acm_point:setVisible(true)
            self.point_Text:setString(achCount)
        end      
    end    
   

    self:addEventListener(global.gameEvent.EV_ON_UI_ACM_UPDATE, function()       
        checkAcm()
    end)
    checkAcm()


    -- local checkDiplomatic = function ()
    --     -- body
    --     self.diplomaticPoint:setVisible(false)
    --     local appCount = global.unionData:getApproveCount()
    --     if appCount > 0 then
    --         self.diplomaticPoint:setVisible(true)
    --         self.dipCount:setString(appCount)
    --     end
    -- end
    -- self:addEventListener(global.gameEvent.EV_ON_APPROVECOUNT_UPDATE, function()       
    --     checkDiplomatic()
    -- end)
    -- checkDiplomatic()

    -- 获取
    -- global.techApi:divineList(4, function (msg)
    --     self.divine = msg 
    -- end)

     -- 头像 消息更新
    self:addEventListener(global.gameEvent.EV_ON_HEAMFREAM_UPDATE,function()
        self:reFreshHeadFrame()
    end)

    global.loginApi:clickPointReport(nil,15,nil,nil)

    self.lordHero = global.userData:getLordHero()

    -- self.lordHero = global.heroData:getNormalHeroData()[10]
    self.chooseHeroData =  self.lordHero
   
    local setEquiment = function ()
        for i=1,6 do
            uiMgr:addWidgetTouchHandler(self["icon"..i], function(sender, eventType) self:equipItem_click(i,sender) end)        
        end
    end 

    self:addEventListener(gameEvent.EV_ON_UI_HERO_FLUSH,function()
        self:setHeroDetail(self.lordHero)
    end)

    setEquiment()
    self:setHeroDetail(self.lordHero)
    self:registerTouchListener()
    self:cleanEffect()

    global.userData:updateLordEquipBuff()

    self:updataStrengthBuff()

    self:addEventListener(global.gameEvent.EV_ON_LORDE_EQUIP_BUFF_UPDATE,function()
        self:updataStrengthBuff()
    end)

    self:addEventListener(global.gameEvent.EV_ON_LOGIC_NOTIFY_RED_POINT,function()
        self:updateLordRedPoint()
    end)

    self:updateLordRedPoint()
end



function UILordPanel:updateLordRedPoint()

    self.lord_red_point:setVisible(false)

    if global.userData:getHeadFrameRed() > 0 then

        self.lord_red_point:setVisible(true)
    end 
end 



function UILordPanel:updataStrengthBuff()

    global.userData:getLordEquipBuff(3051 , function (val ) 

        print("val->>>>>>>>>>>1111" ,val )
         self.loradEquipBuff = val 
    end)

end



function UILordPanel:reFreshHeadFrame()
    -- self.headFream:setSpriteFrame(global.userheadframedata:getCrutFrame().pic)
    local headInfo = global.userheadframedata:getCrutFrame()
    if headInfo and headInfo.pic then
        global.panelMgr:setTextureFor(self.headFream,headInfo.pic)
    end
end 


function UILordPanel:reFreshNumber()
    self:checkStrength()
    self.lastStrength = tonumber(self.strength_value:getString())
    self.lastPer = self.strength_LoadingBar:getPercent()

    if global.panelMgr:getTopPanelName() == "UIBuyEnergyPanel"  then 
        local buyEnergyPanel = global.panelMgr:getPanel("UIBuyEnergyPanel")
        buyEnergyPanel:setData(handler(self, self.buyStrengthHandler))
    end 
end 

function UILordPanel:onExit()
    -- 移除长按事件监听
    global.tipsMgr:removeLongPress(self)
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end

    if self.pandectCall then 
         self.pandectCall()
         self.pandectCall = nil 
    end 

end

function UILordPanel:setData()

    --self.exp_loading_pic:setVisible(false)
    --self.strength_loading_pci:setVisible(false)
    self:reFreshHeadFrame()

    local userName = userData:getUserName()
    local userLv = userData:getLevel()
    local curHp = userData:getCurHp()
    local maxHp = userData:getMaxHp()
    local curExp = userData:getCurExp()
    local maxExp = userData:getMaxExp()

    if global.chatData:isJoinUnion() then
        local szShortName = global.unionData:getUnionShortName(global.unionData:getInUnionShortName()) or ""
        local szName = global.unionData:getInUnionName() or ""
        self.alliance_name:setString(string.format("%s%s",szShortName,szName))
    else
        self.alliance_name:setString("-")
    end
    
    self.lordName:setString(userName)
    self.lord_id:setString(userData:getUserId())
    self.lord_lv:setString(userLv)

    self.strength_value:setString(curHp)
    self.strength_upper_limit:setString(maxHp)
    self.exp_value:setString(curExp)
    self.exp_upper_limit:setString(maxExp)
    self.exp_LoadingBar:setPercent( curExp/maxExp*100 )
    self.strength_LoadingBar:setPercent( curHp/maxHp*100 )

    self.expBuy:setEnabled(true)
    if userLv and userLv >= table.nums(global.luaCfg:lord_exp()) then 
        self.exp_value:setVisible(false)
        self.exp_upper_limit:setVisible(false)
        self.exp_split:setString("MAX")
        self.expBuy:setEnabled(false)
    else 
        self.exp_value:setVisible(true)
        self.exp_upper_limit:setVisible(true)
        self.exp_split:setString("/")
    end  

    local barW1 = self.exp_LoadingBar:getContentSize().width
    self.exp_loading_pic:setPosition(cc.p(barW1*(curExp/maxExp), 0))

    local barW = self.strength_LoadingBar:getContentSize().width
    if curHp > maxHp then curHp = maxHp end
    self.strength_loading_pci:setPosition(cc.p(barW*(curHp/maxHp), 0))

    self:changeHeadIcon()

    self:checkStrength()

    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.lord_id:getParent(),self.lord_id)
    global.tools:adjustNodePosForFather(self.alliance_name:getParent(),self.alliance_name)
    global.tools:adjustNodePosForFather(self.lord_lv:getParent(),self.lord_lv)

end

function UILordPanel:checkQuestion()
    local totalTimes = luaCfg:get_investigation_by(1).totalTimes or 0
    local curTimes = global.refershData:getlAnswerCount() or 0
    self.btn_questionnaire:setVisible(curTimes<totalTimes)

    self.questPoint:setVisible(false)
    if curTimes<totalTimes and not global.refershData:isQuestionToday() then
        self.questPoint:setVisible(true)
    end

end

function UILordPanel:checkStrength()
    
    -- local buyTimes = global.dailyTaskData:getBuyStrengthTimes()
    -- local vipData = luaCfg:get_vip_func_by(userData:getVipLevel())
    -- local vipfreenumber = global.vipBuffEffectData:getVipDiverseFreeNumber("lVipLordCount") 
    -- if buyTimes >= vipData.energyBuyTimes+vipfreenumber then
    --     self.strengthBuy:setEnabled(false)  
    -- else
    --     self.strengthBuy:setEnabled(true)
    -- end

end

function UILordPanel:changeHeadIcon()

    -- 领主头像
    local head = clone(global.headData:getCurHead())
    if head then
        head.scale = head.scale1
        global.tools:setCircleAvatar(self.portrait_node, head)
    end
end

local rest_hp_divine = {1 , 27, 53}


function UILordPanel:initTextTips() 
    -- --体力恢复加快x% =  基础恢复时间 / (1+x%)
    -- local  vipbuff =  global.vipBuffEffectData:getCurrentVipLevelEffect(3051).quantity or 0 
    -- local  divinebuff = 0
    local allbuff =  0 
    -- if self.divine and self.divine.tgDivine and  self.divine.tgDivine[1] then 
    --     if global.EasyDev:CheckContrains(rest_hp_divine, self.divine.tgDivine[1].ID) then
    --        divinebuff = global.luaCfg:get_divine_by(self.divine.tgDivine[1].ID).value
    --     end 
    -- end 

    -- allbuff = vipbuff + divinebuff

    if self.loradEquipBuff and self.loradEquipBuff > 0 then 
        allbuff =  allbuff +   self.loradEquipBuff 
    end 
    -- print(vipbuff,"vipbuff",divinebuff,"divinebuff", "loradEquipBuff" , self.loradEquipBuff ,allbuff,"allbuff")
    -- print("vipbuff" ,vipbuff)
    -- print("divinebuff" ,divinebuff)
    -- print("loradEquipBuff" ,self.loradEquipBuff)
    print("allbuff" ,allbuff)

    local recoverData = luaCfg:get_lord_exp_by(userData:getLevel())

    local time = math.floor(recoverData.recover /(1 + allbuff/100))

    local rest_hp = userData:getMaxHp() - userData:getCurHp()
    if rest_hp <= 0 then 
        uiMgr:setRichText(self.TipLayout.data_note_bg_1,"textTop_second_mlan_52",50074,{sec =time})
    else 
        local alltime =rest_hp * time 
        local h = math.floor(alltime / global.define.HOUR)
        local m  =  math.floor((alltime - (h * global.define.HOUR)) / global.define.MINUTE)
        local reset_text= string.format(global.luaCfg:get_local_string(10694), h , m)
        uiMgr:setRichText(self.TipLayout.data_note_bg_1,"textTop_second_mlan_52",50049,{sec =time , time = reset_text})
    end 

end

function UILordPanel:longPressDeal(beganPoint)

    self.TipLayout:runAction(cc.FadeIn:create(0.2))

    local offsetY = self.TipLayout.data_note_bg_1:getContentSize().height/2 + 10
    local x, y = self.strength_bar_bg:getPosition()
    local position = self.strength_node:convertToWorldSpace(cc.p(x, y))

    local layoutW = self.TipLayout.data_note_bg_1:getContentSize().width
    local rightX = gdisplay.width - layoutW
    if beganPoint.x >= rightX then
        beganPoint.x = rightX
    end
    self.TipLayout:setPosition(cc.p( beganPoint.x + layoutW/2 , position.y+offsetY ))
end

function UILordPanel:titleChange_click(sender, eventType)

end

function UILordPanel:iconChange_click(sender, eventType)
    global.panelMgr:openPanel("UIRoleHeadPanel"):setData()   
end

function UILordPanel:addExp_click()
    local panel = global.panelMgr:openPanel("UISpeedPanel")
    panel:setData(nil, 0, panel.TYPE_LORD_EXP, 0)
end

function UILordPanel:addEnergy_click(sender, eventType)
    

    self.lastStrength = tonumber(self.strength_value:getString())
    self.lastPer = self.strength_LoadingBar:getPercent()
    self.lastHp = userData:getCurHp()

    local buyEnergyPanel = global.panelMgr:openPanel("UIBuyEnergyPanel")
    buyEnergyPanel:setData(handler(self, self.buyStrengthHandler))

end

function UILordPanel:buyStrengthHandler(msg)

    self:checkStrength()
    local time = 1 - self.strength_LoadingBar:getPercent()/100
    local expData = luaCfg:get_lord_exp_by(userData:getLevel())

    if time == 0 then
        self:scroNum( self.lastStrength , userData:getCurHp(), 1)
    else
        self:changLoadingBar(100, userData:getCurHp(), time) 
    end
end

function UILordPanel:changLoadingBar(per, num, time)

    self.strength_LoadingBar:runAction(cc.ProgressFromTo:create(time, self.lastPer, per))
    local barW = self.strength_LoadingBar:getContentSize().width
    local maxHp = userData:getMaxHp()  
    local curHp = userData:getCurHp()  
    if curHp > maxHp then curHp = maxHp end
    self.strength_loading_pci:runAction(cc.MoveTo:create(time,cc.p(barW*(curHp/maxHp), 0)))
    self:scroNum(self.lastStrength , num, time)    
end

function UILordPanel:scroNum(startNum, endNum, time )

    local scoreNode = cc.Node:create()
    self.root:addChild(scoreNode)

    scoreNode:setPositionX(startNum)
    if scoreNode:getPositionX() ~= endNum then
            scoreNode:runAction(cc.Sequence:create(cc.CallFunc:create(function()
                
                scoreNode:runAction(cc.MoveTo:create(time, cc.p(endNum,0)))
                scoreNode:runAction(cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(time / 30),cc.CallFunc:create(function ()
                    
                    local numStr = scoreNode:getPositionX()
                    self.strength_value:setString(math.floor(numStr))
                end)), 30))          
            end)))            
    else
        self.strength_value:setString(endNum)
    end
end

function UILordPanel:note_click(sender, eventType)

end

function UILordPanel:achieve_click(sender, eventType)

    global.panelMgr:openPanel("UIAchievePanel")
end

function UILordPanel:rank_click(sender, eventType)

    local checkTrigger = function ()
        -- body
        local buildData = luaCfg:get_buildings_pos_by(29)
        if global.cityData:checkTrigger(buildData.triggerId[1]) then
            return true
        else
            local triggerData = luaCfg:get_triggers_id_by(buildData.triggerId[1])
            local triggerBuilding = luaCfg:get_buildings_pos_by(triggerData.buildsId)
            local str = luaCfg:get_local_string(10043,triggerBuilding.buildsName,triggerData.triggerCondition,buildData.buildsName)
            global.tipsMgr:showWarning(str)
            return false
        end
    end

    if not checkTrigger() then
        return
    end
    global.panelMgr:openPanel("UIRankPanel")
    
end

function UILordPanel:setting_click(sender, eventType)

    global.panelMgr:openPanel("UISetPanel")
end

function UILordPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UILordPanel")  
end


function UILordPanel:vip_click(sender, eventType)
    global.panelMgr:openPanel("UIvipPanel")
end



function UILordPanel:setHeroDetail( data )
    
    local equips = equipData:getHeroEquips(self.chooseHeroData.heroId) -- 得到英雄已经穿戴的装备

    for i,v in ipairs(equips) do

        local bg = self["equipment_bg"..i]
        local icon = self["icon"..i]
        local strongText = bg.strog_export
        icon:getParent():stopAllActions()
        icon:getParent():setOpacity(255)

        bg.up_point:setVisible(false)

        local quality= self["quality_"..i]
        local backbg = self["back_bg_"..i]
        quality:setVisible(false)
        backbg:setVisible(false)


        if v ~= -1 then -- 已经穿上去了

            local eData = equipData:getEquipById(v)
            local confData = eData.confData--luaCfg:get_equipment_by(eData.lGID)

            strongText:setString(":" .. eData.lStronglv)    
            strongText:setVisible(eData.lStronglv > 0)

            local isBetter = equipData:isHaveBetterOneCanSuit(self.chooseHeroData,eData.lCombat,i)
            if isBetter then
                bg.up_point:setVisible(true)
            end

            quality:setVisible(true)
            backbg:setVisible(false)

            bg["Sprite_"..i]:setVisible(false)
            global.panelMgr:setTextureFor(quality,string.format("icon/item/item_bg_0%d.png",confData.quality))
            global.panelMgr:setTextureFor(icon,confData.icon)
            icon:setVisible(true)
        else            

            strongText:setVisible(false)
            quality:setVisible(false)
            backbg:setVisible(true)

            bg["Sprite_"..i]:setVisible(true)
            local state = equipData:getHeroEquipState(self.chooseHeroData,i)
            icon:setVisible(true)            

            --查询是否有可以装备的道具 0->没有对应装备 1->有装备但是不能装备 2->有可以装备的装备
            if state == 0 then

                icon:setVisible(false)
            elseif state == 1 then

                icon:getParent():runAction(cc.RepeatForever:create(cc.Sequence:create(cc.EaseInOut:create(cc.Sequence:create(cc.FadeTo:create(1, 30),cc.FadeTo:create(1, 255)),1),cc.DelayTime:create(0))))
                icon:loadTextureNormal("ui_button/add_yellow_btn.png", ccui.TextureResType.plistType)
                icon:loadTexturePressed("ui_button/add_yellow_btn.png", ccui.TextureResType.plistType)
            elseif state == 2 then

                icon:getParent():runAction(cc.RepeatForever:create(cc.Sequence:create(cc.EaseInOut:create(cc.Sequence:create(cc.FadeTo:create(1, 30),cc.FadeTo:create(1, 255)),1),cc.DelayTime:create(0))))
                -- icon:getParent():runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeTo:create(0.5, 50),cc.DelayTime:create(1),cc.FadeTo:create(0.5, 255),cc.DelayTime:create(1))))
                icon:loadTextureNormal("ui_button/add_green_btn.png", ccui.TextureResType.plistType)
                icon:loadTexturePressed("ui_button/add_green_btn.png", ccui.TextureResType.plistType)
            end
        end
    end

end


function UILordPanel:registerTouchListener()
    
    local touchNode = cc.Node:create()
    self:addChild(touchNode)
    local contentMoveX, contentMoveY = 0, 0

    local  listener = cc.EventListenerTouchOneByOne:create()

    local function touchBegan(touch, event)
       contentMoveX = 0
       contentMoveY = 0
       return true
    end
    local function touchMoved(touch, event)
       
       local diff = touch:getDelta()
       contentMoveX = contentMoveX + math.abs(diff.x)
       contentMoveY = contentMoveY + math.abs(diff.y)
    end
    local function touchEnded(touch, event)

        if contentMoveX > 15 or contentMoveY > 15 then
            self.isMove = true
        else
            self.isMove = false
        end
    end

    listener:setSwallowTouches(false)
    listener:registerScriptHandler(touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(touchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(touchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, touchNode)

end


function UILordPanel:cleanEffect()
    
    for i = 1,6 do

        self["equipment_bg"..i]:removeChildByTag(98)
    end

end


function UILordPanel:showEquipEffect(index)
    
    local effect = resMgr:createCsbAction("effect/equipment_light", "animation0", false, true)
    effect:setPosition(cc.p(176 / 2,176 / 2))
    effect:setScale(1 / 0.6)
    effect:setTag(98)
    self["equipment_bg"..index]:addChild(effect)

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_EquipHero")

end 

function UILordPanel:equipItem_click(index,sender)

    if self.isMove  then return end 

    local heroId = self.chooseHeroData.heroId
    local tmpHeroData = self.chooseHeroData

    local heroId = self.chooseHeroData.heroId
    local tmpHeroData = self.chooseHeroData

    local equipId = equipData:getHeroEquipByIndex(self.chooseHeroData.heroId,index)
    if equipId == -1 then

        global.panelMgr:openPanel("UIEquipPanel"):setData(index , self.chooseHeroData.heroId)
            :setEquipInfo(true, 10392,false,function(data)
                
                global.itemApi:swapEquip(0,data.lID,heroId,index,function(msg)

                    self:showEquipEffect(index)

                    global.panelMgr:closePanel("UIEquipPanel")

                end)
        end) 
    else
   
        global.panelMgr:openPanel("UIEquipPutDown"):setData(equipData:getEquipById(equipId))
            :setEquipInfo(true,10393,true,function(data)
            
                if global.equipData:isEquipLimit() then
                    
                    global.tipsMgr:showWarning("equipFull")
                else
                    global.itemApi:swapEquip(1,data.lID,heroId,index,function(msg)
                        
                        gevent:call(gsound.EV_ON_PLAYSOUND,"patch_new_1")
                        global.panelMgr:closePanel("UIEquipPutDown")
                    end)
                end            
            end)
    end    


end 

function UILordPanel:setPandectCall(callBack)
    -- body
    self.pandectCall = callBack
end



function UILordPanel:nameEditHandler(sender, eventType)
    self:openNameChange()
end

function UILordPanel:openNameChange()
    -- body
    local configData = luaCfg:get_config_by(1)
    local data = { num=configData.renameCost, content = configData.renameTime/60, titleId = 10233, info = self.lordName:getString(), }
    local panel = global.panelMgr:openPanel("UIMoJUsePanel")
    panel:setData(data, function (name)
        -- body
        self.lordName:setString(name)
        userData:setUserName(name)
        global.tipsMgr:showWarning("RenameSuccess")

        -- 更新自己部队领主名字
        global.troopData:refershLordName()
        gevent:call(global.gameEvent.EV_ON_UPDATE_USERNAME)
    end)
end

function UILordPanel:questionHandler(sender, eventType)

    if global.refershData:isQuestionToday() then
        return global.tipsMgr:showWarning("nextDayQuestion")
    end
    global.panelMgr:openPanel("UIQuestionBgPanel")

end

function UILordPanel:namelick(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UILordPanel

--endregion
