--region UIPKRePlayPanel.lua
--Author : zzl
--Date   : 2018/02/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPKRePlayHeroItemArr = require("game.UI.pk.player.UIPKRePlayHeroItemArr")
local UIfail = require("game.UI.replay.view.UIfail")
local UIwin = require("game.UI.replay.view.UIwin")
--REQUIRE_CLASS_END

local UIPKRePlayPanel  = class("UIPKRePlayPanel", function() return gdisplay.newWidget() end )

function UIPKRePlayPanel:ctor()
    self:CreateUI()
end

function UIPKRePlayPanel:CreateUI()
    local root = resMgr:createWidget("player_kill/player/player_main")
    self:initUI(root)
end

function UIPKRePlayPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player_kill/player/player_main")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.title = self.root.esc.title_fnt_export
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.ps_node = self.root.ScrollView_1_export.ps_node_export
    self.round_1 = self.root.ScrollView_1_export.round_1_export
    self.round_1 = UIPKRePlayHeroItemArr.new()
    uiMgr:configNestClass(self.round_1, self.root.ScrollView_1_export.round_1_export)
    self.round_2 = self.root.ScrollView_1_export.round_2_export
    self.round_2 = UIPKRePlayHeroItemArr.new()
    uiMgr:configNestClass(self.round_2, self.root.ScrollView_1_export.round_2_export)
    self.round_3 = self.root.ScrollView_1_export.round_3_export
    self.round_3 = UIPKRePlayHeroItemArr.new()
    uiMgr:configNestClass(self.round_3, self.root.ScrollView_1_export.round_3_export)
    self.p1_node = self.root.ScrollView_1_export.p1_node_export
    self.p2_node = self.root.ScrollView_1_export.p2_node_export
    self.mode = self.root.mode_export
    self.fail_effect = UIfail.new()
    uiMgr:configNestClass(self.fail_effect, self.root.fail_effect)
    self.win_effect = UIwin.new()
    uiMgr:configNestClass(self.win_effect, self.root.win_effect)

    uiMgr:addWidgetTouchHandler(self.root.ScrollView_1_export.skip, function(sender, eventType) self:result_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.mode, function(sender, eventType) self:exitCall(sender, eventType) end)
--EXPORT_NODE_END

   uiMgr:addWidgetTouchHandler(self.root.esc.esc, function(sender, eventType)  

        self:exitCall()

    end)

    self.win_effect:setVisible(false)
    self.fail_effect:setVisible(false)

    self:adapt()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

-- message PKRecord
-- {
--     required int32  lAtkID = 1;     //?????????ID
--     required int32  lDefID = 2;     //????????ID
--     required string szAtkName = 3;  //???????????
--     required string szDefName = 4;  //??????????
--     required int32  lAtkRank = 5;   //?????????
--     required int32  lDefRank = 6;   //????????
--     required int64  lAtkPower = 7;  //ս????
--     required int64  lDefPower = 8;  //ս????
--     required uint32 lAddTime = 9;   //ս??ʱ??
--     repeated int32  lResult = 10;   //???ʱ??
--     repeated int32  lRand = 11;     //?????
--     required PKGroup    tagAtk = 12;    //???????????
--     required PKGroup    tagDef = 13;    //??????????
--     repeated Item   tagItem = 14;   //???
--     optional string szParam = 15;   //??չ?????ƴ?????
-- }

function UIPKRePlayPanel:adapt()
    local sHeight =(gdisplay.height - 75)
    local defY = self.ScrollView_1:getContentSize().height
    self.ScrollView_1:setContentSize(cc.size(gdisplay.width, sHeight))
    if sHeight < defY then 
    else
        self.ScrollView_1:setTouchEnabled(false)
        self.ScrollView_1:setInnerContainerSize(cc.size(gdisplay.width, sHeight))
        local tt =  self.ScrollView_1:getContentSize().height- self.ps_node:getPositionY()
        for _ ,v in pairs(self.ScrollView_1:getChildren()) do 
            v:setPositionY(v:getPositionY()+tt)
        end 
    end 
end 


function UIPKRePlayPanel:onEnter()

    self.mode:setVisible(false)

    self.now_ronud =  0 

    self.ScrollView_1:jumpToTop()

    local loading_TimeLine = resMgr:createTimeline("player_kill/player/player_main")  
    loading_TimeLine:play("animation0", true)
    self.root:runAction(loading_TimeLine)

    self.over_end = false 

end 

function UIPKRePlayPanel:onExit()

    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")


    if self.timer then 
        gscheduler.unscheduleGlobal(self.timer)
    end 

    if self.result_effect and not tolua.isnull(self.result_effect) then 

        self.result_effect:removeFromParent()
    end 

end 

function UIPKRePlayPanel:setUserInfo(node , data) 

    node.rank_mlan_3.rank:setString(data.rank)
    node.playera_name:setString(data.name)
    node.power:setString(data.power)

end 

function UIPKRePlayPanel:setData(data , replay)

    dump(data ,"self.data ")

    if not data or not data.tagRecord then return end 

    self.data = data.tagRecord

    self:setUserInfo(self.p1_node , {rank=self.data.lAtkRank , name =self.data.szAtkName or "Joker" , power= self.data.lAtkPower})
    self:setUserInfo(self.p2_node, {rank=self.data.lDefRank , name =self.data.szDefName or "Joker" , power= self.data.lDefPower})

    self:hideHero()

    for i =1 , 3 do 
        local heroData = {attack=self.data.tagAtk.tagHero[i] , def =self.data.tagDef.tagHero[i]}
        heroData.attack.userId = self.data.lAtkID
        heroData.def.userId = self.data.lDefID                      
        local win = 0 
        if self.data.lResult[i+1] == 2 then 
            win = 1
        end 
        self["round_"..i]:setData({attack = self.data.lRand[i] , win= win } , heroData)
    end      

    self.replay  = replay

    if replay then 
         self.title:setString(gls(11117))
    else 
         self.title:setString(gls(11118))
    end 

    self:excute()
end

local rond_part = 3.5


function UIPKRePlayPanel:excute()

    local s1 = cc.Sequence:create(

        self:getC(function () self:hideHero() end ),

        cc.DelayTime:create(0.2),

        self:getC(function () self:showHero() end ),

        cc.DelayTime:create(1),

        self:getC(function () self:ronudAction() end ),

        cc.DelayTime:create(rond_part),

        self:getC(function () self:ronudAction() end ),

        cc.DelayTime:create(rond_part),

        self:getC(function () self:ronudAction() end ),

        cc.DelayTime:create(rond_part),

        self:getC(function () self:resultEffect()  end ),

        cc.DelayTime:create(rond_part * 0.2),

        self:getC(function () self:displayReword() end )
    )

    self:runAction(s1)
end 

function UIPKRePlayPanel:getC(call)

    return cc.CallFunc:create(call)
end 


local dayTime  = 1 

function UIPKRePlayPanel:ronudAction()
        
    self.now_ronud =  self.now_ronud + 1      

    self["round_"..self.now_ronud]:excute()    
end 

function UIPKRePlayPanel:hideHero()
    for i =1 , 3 do 
        self["round_"..i]:setScale(-100)
    end
end 

function UIPKRePlayPanel:showHero()
    for i =1 , 3 do 
        self["round_"..i]:test(3)
        global.delayCallFunc(function()
            if not tolua.isnull(self["round_"..i]) then 
                self["round_"..i]:setScale(1)
            end  
            end, 0 , 0.1)
    end
end

function UIPKRePlayPanel:resultEffect()

    if true then return end 

    self.mode:setVisible(true)

    if self.data.lResult[1] == 1 then 

       self.result_effect= UIwin.new()

        global.delayCallFunc(function()
                 self.timer=gevent:call(gsound.EV_ON_PLAYSOUND, "Player_VS")
        end, 0 , 0.2)
        
    else
        self.result_effect = UIfail.new()

    end 

    self.result_effect:setLocalZOrder(self.fail_effect:getLocalZOrder())
    self.result_effect:setScale(1.2)
    self.result_effect:setPosition(self.fail_effect:getPosition())
    self:addChild(self.result_effect)

    self.result_effect:showAction()

end 


   


function UIPKRePlayPanel:displayReword()

    if not  self.replay then 
        -- if self.data.tagItem then 
            -- local data = {} 
            -- for _ ,v in pairs(self.data.tagItem or {} ) do 
            --     local t = {} 
            --     t[1] = v.lID
            --     t[2] = v.lCount

            --     table.insert(data , t )
            -- end 
            global.panelMgr:openPanel("UIPKResultPanel"):setData(self.data)
        -- end 
    end 

    self.replay = true 

   self.over_end = true 
end 

function UIPKRePlayPanel:quickResult()
    for i =1 , 3 do 

        self["round_"..i]:quickResult()
    end
end 


function UIPKRePlayPanel:getheroInfo( heroId ,userId )

    local msg ={}
    msg.tgHero = msg.tgHero or {}
    msg.tgEquip = msg.tgEquip or {}

    if userId == self.data.lAtkID then 

        for _ , v in pairs(self.data.tagAtk.tagEquip or {} ) do 
            if v.lHeroID == heroId then 
                table.insert( msg.tgEquip , v)
            end 
        end 

        for _ , v in pairs(self.data.tagAtk.tagHero or {} ) do 
            if v.lID ==heroId then 
                 msg.tgHero  = v
            end 
        end 


    elseif userId == self.data.lDefID then 

        for _  , v in pairs(self.data.tagDef.tagEquip or {} ) do 
            if v.lHeroID ==heroId then 
                table.insert( msg.tgEquip , v)
            end 
        end 

        for _ , v in pairs(self.data.tagDef.tagHero or {} ) do 
            if v.lID ==heroId then 
                msg.tgHero  = v

            end 
        end 
    end 


    return msg

end 


function UIPKRePlayPanel:result_click(sender, eventType)
    
    if  self.over_end  then 

        return global.tipsMgr:showWarning(gls(10661))
    end 

    self:displayReword()

    self:quickResult()

    self:stopAllActions()

    self:resultEffect()
end


function UIPKRePlayPanel:exitCall(sender, eventType)

    self:displayReword()

    self:stopAllActions()

    global.panelMgr:destroyPanel("UIPKRePlayPanel")

end
--CALLBACKS_FUNCS_END

return UIPKRePlayPanel

--endregion
