--region UIChestPanel.lua
--Author : yyt
--Date   : 2017/02/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local funcGame = global.funcGame
local dailyTaskData = global.dailyTaskData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIChestEffect = require("game.UI.chest.UIChestEffect")
--REQUIRE_CLASS_END

local UIChestPanel  = class("UIChestPanel", function() return gdisplay.newWidget() end )

function UIChestPanel:ctor()
    self:CreateUI()
end

function UIChestPanel:CreateUI()
    local root = resMgr:createWidget("chest/chest_bg")
    self:initUI(root)
end

function UIChestPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "chest/chest_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.max_num = self.root.Node_export.max_num_export
    self.now_num = self.root.Node_export.now_num_export
    self.wait_node = self.root.Node_export.wait_node_export
    self.time = self.root.Node_export.wait_node_export.time_export
    self.ButtonL = self.root.Node_export.bg_1.ButtonL_export
    self.NodeL = self.root.Node_export.bg_1.NodeL_export
    self.btnFreeBag = self.root.Node_export.bg_1.NodeL_export.btnFreeBag_export
    self.monster = self.root.Node_export.monster_export
    self.vipEffectNode = self.root.Node_export.bg_2.vipEffectNode_export
    self.vipEffectNode = UIChestEffect.new()
    uiMgr:configNestClass(self.vipEffectNode, self.root.Node_export.bg_2.vipEffectNode_export)
    self.NodeR = self.root.Node_export.bg_2.NodeR_export
    self.btnVipBag = self.root.Node_export.bg_2.NodeR_export.btnVipBag_export
    self.normalCostNode = self.root.Node_export.normalCostNode_export
    self.normalCostText = self.root.Node_export.normalCostNode_export.normalCostText_export
    self.vipCostNode = self.root.Node_export.vipCostNode_export
    self.vipCostText = self.root.Node_export.vipCostNode_export.vipCostText_export
    self.numNode = self.root.Node_export.numNode_export
    self.max_mons_num = self.root.Node_export.numNode_export.max_mons_num_export
    self.now_mons_num = self.root.Node_export.numNode_export.now_mons_num_export
    self.wait1_node = self.root.Node_export.wait1_node_export
    self.time1 = self.root.Node_export.wait1_node_export.time1_export
    self.model = self.root.model_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.ButtonL, function(sender, eventType) self:freeBagHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btnFreeBag, function(sender, eventType) self:buyFreeCount(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btnVipBag, function(sender, eventType) self:buyVipCount(sender, eventType) end)
--EXPORT_NODE_END

    self.freeData = luaCfg:get_free_chest_by(1)
    self.effectNode = cc.Node:create()
    self:addChild(self.effectNode)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIChestPanel:onEnter()

    self.nodeTimeLine = resMgr:createTimeline("chest/chest_bg")
    self:runAction(self.nodeTimeLine)

     self:addEventListener(global.gameEvent.EV_ON_UICHESTPANEL_UPDATE,function ()
        self:setData()
     end)
end


function UIChestPanel:setData()


    dailyTaskData:initFreeBagNum(dailyTaskData:getLastFreeMsg())


    self.model:setVisible(false)
    self.effectNode:removeAllChildren()

    self.now_freeNum = dailyTaskData:getFreeBagNum() --免费次数
    
    self.now_wildNum = dailyTaskData:getWildTimes() --现在的次数

    if self.now_freeNum < 0 then self.now_freeNum = 0 end
    if self.now_wildNum < 0 then self.now_wildNum = 0 end

    local wildData = luaCfg:get_wild_chest_by(2)
    self.wildData = wildData

    self.monster:setString(luaCfg:get_local_string(10344, wildData.num))

    self.max_mons_num:setString(wildData.num)

    self.now_mons_num:setString(self.now_wildNum)

    if not  self.notChange  then  --点击宝箱后 直接 打开 ， 不刷新界面。

        self:checkBtnState()
        self.max_num:setString(self.freeData.max)
        self.now_num:setString(self.now_freeNum)
    end 

    self.notChange  = false 

    self.m_restTime = math.floor(dailyTaskData:getRestTime() + global.dataMgr:getServerTime()) 
    self:checkTime()

    self.m_wildTime = math.floor(dailyTaskData:getWildRestTime() + wildData.time*60) 
    self:checkWildTime()

end


function UIChestPanel:checkBtnState()
    
    self.ButtonL:setVisible(false)
    self.NodeL:setVisible(true)
    self.btnFreeBag:setEnabled(true)
    self.normalCostNode:setVisible(false)
    self.vipCostNode:setVisible(false)
    self:setCost()
    if self.now_freeNum > 0 and self.now_freeNum <= self.freeData.max then
        
        self.NodeL:setVisible(false)
        self.ButtonL:setVisible(true)
        self.nodeTimeLine:play("animation0", true)
    else
        self.btnFreeBag:setEnabled(false)
        global.colorUtils.turnGray(self.btnFreeBag , true)
        -- self.normalCostNode:setVisible(true)
    end

    self.NodeR:setVisible(true)
    self.vipEffectNode:setVisible(false)
    local wildData = luaCfg:get_wild_chest_by(2)
    self.btnVipBag:setEnabled(false)

    if self.now_wildNum == wildData.num  then
        self.NodeR:setVisible(false)
        self.vipEffectNode:setVisible(true)
        self.vipEffectNode:setData(handler(self, self.vipBagHandlerCall))
        self.vipEffectNode:playEffect()
    else 
        global.colorUtils.turnGray(self.btnVipBag , true)
        if not dailyTaskData:checkIsCanWild() then 
            self.btnVipBag:setEnabled(true)
            self.vipCostNode:setVisible(true)
        end   
    end 
end

function UIChestPanel:setCost()

    local count = 0 

    local configinfo = 0 

    self.DIAMOND = tonumber( global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,""))

    -- 免费
    count = dailyTaskData:getFreeCostCout()+1

    configinfo = global.luaCfg:get_free_chest_by(1)

    if count > configinfo.maxCost then 

        count = configinfo.maxCost 
    end 

    self.nomarlFreeCost  =  tonumber(configinfo["cost"..count])

    self.normalCostText:setString( self.nomarlFreeCost )

    -- vip 
    count =  dailyTaskData:getMonsterCostCout()+1

    configinfo = global.luaCfg:get_wild_chest_by(2)


    self.vipFreeCost =  tonumber(configinfo["cost"..count])

    if count > configinfo.maxCost then 

        count = configinfo.maxCost 
    end 

   self.vipCostText:setString(self.vipFreeCost)


    if self.nomarlFreeCost > self.DIAMOND then 

        self.normalCostText:setTextColor(gdisplay.COLOR_RED)
    else 
        
        self.normalCostText:setTextColor(gdisplay.COLOR_WHITE)
    end 

    if self.vipFreeCost > self.DIAMOND then 

        self.vipCostText:setTextColor(gdisplay.COLOR_RED)
    else 
        
        self.vipCostText:setTextColor(gdisplay.COLOR_WHITE)
    end 
end 

function UIChestPanel:countDownHandler(dt)

    if not self.m_restTime then return end
    local restTime =  math.floor(self.m_restTime - global.dataMgr:getServerTime())

    if restTime <= 0 then

        global.uiMgr:addSceneModel(1)
        self.time:setString(funcGame.formatTimeToHMS(0))
        if (self.now_freeNum + 1) <= self.freeData.max then

            self.now_freeNum = self.now_freeNum + 1
            self.now_num:setString(self.now_freeNum)
        end

        self:checkBtnState()
        self.m_restTime = self.freeData.time*60 + global.dataMgr:getServerTime()
        self:checkTime()

        return
    end 

    self.time:setString(funcGame.formatTimeToHMS(restTime))
end

function UIChestPanel:countDownWildHandler(dt)

    if self.m_wildTime  then 

        local restTime =  math.floor(self.m_wildTime - global.dataMgr:getServerTime())
        
        if restTime <= 0 then
            global.uiMgr:addSceneModel(1)
            self.time1:setString(funcGame.formatTimeToHMS(0))
            dailyTaskData:setWildRestTime(0)

            self:checkBtnState()
            self:checkWildTime()
            return
        end

        self.time1:setString(funcGame.formatTimeToHMS(restTime))
    end 
end


function UIChestPanel:checkTime()

    if self.now_freeNum < self.freeData.max then
        self.wait_node:setVisible(true)

        if self.m_countDownTimer then
        else
            self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
            self:countDownHandler()
        end

    else

        self.wait_node:setVisible(false)
        if self.m_countDownTimer then
            gscheduler.unscheduleGlobal(self.m_countDownTimer)
            self.m_countDownTimer = nil
        end
    end

end

function UIChestPanel:onExit()
    self.want_close = false 
    self:cleanTimer()
end

function UIChestPanel:onCloseHanler(sender, eventType)
    
    gsound.stopEffect("city_click")

    self.want_close = self.want_close  

    if self.want_close then return end 

    self.want_close  = true 

    global.panelMgr:closePanelForBtn("UIChestPanel")

    dailyTaskData:setBagState(self.now_freeNum, self.now_wildNum)
    gevent:call(global.gameEvent.EV_ON_UI_REWARDBAG_FLUSHSTATE)
    self.effectNode:removeAllChildren()
end


function UIChestPanel:freeBagHandler(sender, eventType)
    

    global.taskApi:getRewardBag(1, function(msg)

        if tonumber(self.max_num:getString()) ==  tonumber(self.now_num:getString()) or checktime then 
            dailyTaskData.checktime = true 
        end

        dailyTaskData:initFreeBagNum(msg.tgPack)

        self:setData()
       
        self.model:setVisible(true)
        local bagAction = resMgr:createCsbAction("effect/bx_zi_jin","animation0",false,true, nil, function ( )
            
            self.model:setVisible(false)
        end)
        bagAction:setPosition(cc.p(gdisplay.width/2 ,gdisplay.height/2))
        self.effectNode:addChild(bagAction, 998)

        
        self:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function ( )
            
            global.panelMgr:openPanel("UIItemRewardPanel"):setData(self:changeItem(msg.tgItems)) 

        end)))

    end, 1)

end

function UIChestPanel:vipBagHandlerCall()
    
    global.taskApi:getRewardBag(2, function(msg)


        dailyTaskData.checkVipTime = true 
    
        dailyTaskData:setWildTimes(0)

        dailyTaskData:initVipBagNum(msg.tgPack)

        self:setData()

        self.model:setVisible(true)
        local bagAction = resMgr:createCsbAction("effect/bx_zi_jin2","animation0",false,true, nil, function ( )
            
            self.model:setVisible(false)
        end)
        bagAction:setPosition(cc.p(gdisplay.width/2 ,gdisplay.height/2))
        self.effectNode:addChild(bagAction, 998)
        
        self:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function ( )
          
            global.panelMgr:openPanel("UIItemRewardPanel"):setData(self:changeItem(msg.tgItems)) 
        end)))

    end, 1)

end

function UIChestPanel:checkWildTime()

    if not dailyTaskData:checkIsCanWild() then
        
        self.numNode:setVisible(false)
        self.wait1_node:setVisible(true)

        if self.m_countWildTimer then
        else
            self.m_countWildTimer = gscheduler.scheduleGlobal(handler(self,self.countDownWildHandler), 1)
            self:countDownWildHandler()
        end

    else
        self.numNode:setVisible(true)
        self.wait1_node:setVisible(false)

        if self.m_countWildTimer then
            gscheduler.unscheduleGlobal(self.m_countWildTimer)
            self.m_countWildTimer = nil
        end
    end

end



function UIChestPanel:cleanTimer()

   if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end

    if self.m_countWildTimer then
        gscheduler.unscheduleGlobal(self.m_countWildTimer)
        self.m_countWildTimer = nil
    end

end 



function UIChestPanel:changeItem(tagItems)
    
    tagItems = tagItems or {}
    local data = {}
    for _,v in pairs(tagItems) do
        
        local tb = {}
        tb[1] = v.lID
        tb[2] = v.lCount
        table.insert(data, tb)
    end
    return data
end


function UIChestPanel:confirm(_type)

     global.taskApi:getRewardBag(_type, function(msg)

        if _type == 3 then 

            self.notChange = true 

            self.btnFreeBag:setEnabled(false)

            dailyTaskData:initFreeBagNum(msg.tgPack,true)

            global.delayCallFunc(function()
                
                dailyTaskData.checktime = true 

                self:freeBagHandler(nil , nil ,true)

             end,nil , 0.1)       


        elseif _type == 4 then 

            dailyTaskData:initVipBagNum(msg.tgPack, true)

            global.tipsMgr:showWarning("chest_cd_clean")

        end 

        self:setData()

    end, 1)

end


function UIChestPanel:buyFreeCount(sender, eventType)

    if self.nomarlFreeCost > self.DIAMOND then 
         global.tipsMgr:showWarning("ItemUseDiamond")
    end 
    
    self:confirm(3)
end

function UIChestPanel:buyVipCount(sender, eventType)

    if self.vipFreeCost > self.DIAMOND then 
         global.tipsMgr:showWarning("ItemUseDiamond")
    end 

    self:confirm(4)

end
--CALLBACKS_FUNCS_END

return UIChestPanel

--endregion
