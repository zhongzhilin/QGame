--region UITurntableHeroPanel.lua
--Author : wuwx
--Date   : 2017/11/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UITurntableHeroItem = require("game.UI.turnable.UITurntableHeroItem")
--REQUIRE_CLASS_END

local UITurntableHeroPanel  = class("UITurntableHeroPanel", function() return gdisplay.newWidget() end )
local ResSetControl = require("game.UI.commonUI.widget.ResSetControl")
local UITurntableLogItem = require("game.UI.turnable.UITurntableLogItem")

function UITurntableHeroPanel:ctor()
    self:CreateUI()
end

function UITurntableHeroPanel:CreateUI()
    local root = resMgr:createWidget("turntable/turntable_hero")
    self:initUI(root)
end

function UITurntableHeroPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "turntable/turntable_hero")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.scrollview = self.root.scrollview_export
    self.FileNode_1 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.scrollview_export.Node_1.Node_8.FileNode_1)
    self.FileNode_2 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.scrollview_export.Node_1.Node_8.FileNode_2)
    self.FileNode_3 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.scrollview_export.Node_1.Node_8.FileNode_3)
    self.FileNode_4 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_4, self.root.scrollview_export.Node_1.Node_8.FileNode_4)
    self.FileNode_5 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_5, self.root.scrollview_export.Node_1.Node_8.FileNode_5)
    self.FileNode_6 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_6, self.root.scrollview_export.Node_1.Node_8.FileNode_6)
    self.FileNode_7 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_7, self.root.scrollview_export.Node_1.Node_8.FileNode_7)
    self.FileNode_8 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_8, self.root.scrollview_export.Node_1.Node_8.FileNode_8)
    self.FileNode_9 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_9, self.root.scrollview_export.Node_1.Node_8.FileNode_9)
    self.FileNode_10 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_10, self.root.scrollview_export.Node_1.Node_8.FileNode_10)
    self.FileNode_11 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_11, self.root.scrollview_export.Node_1.Node_8.FileNode_11)
    self.FileNode_12 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_12, self.root.scrollview_export.Node_1.Node_8.FileNode_12)
    self.effect = self.root.scrollview_export.Node_1.effect_export
    self.nownum = self.root.scrollview_export.nownum_export
    self.exploitIcon = self.root.scrollview_export.exploitIcon_export
    self.zeroTime = self.root.scrollview_export.zeroTime_export
    self.btn_normal = self.root.scrollview_export.btn_normal_export
    self.normal_gray = self.root.scrollview_export.btn_normal_export.normal_gray_export
    self.btn_normal_icon = self.root.scrollview_export.btn_normal_export.btn_normal_icon_export
    self.btn_normal_text = self.root.scrollview_export.btn_normal_export.btn_normal_text_export
    self.btn_free = self.root.scrollview_export.btn_free_export
    self.free_gray = self.root.scrollview_export.btn_free_export.free_gray_export
    self.btn_refresh_cost_text = self.root.scrollview_export.btn_free_export.btn_refresh_cost_text_export
    self.btn_refresh_icon = self.root.scrollview_export.btn_free_export.btn_refresh_icon_export
    self.btn_free1 = self.root.scrollview_export.btn_free1_export
    self.free1_gray = self.root.scrollview_export.btn_free1_export.free1_gray_export
    self.btn_ten = self.root.scrollview_export.btn_ten_export
    self.ten_gray = self.root.scrollview_export.btn_ten_export.ten_gray_export
    self.btn_ten_icon = self.root.scrollview_export.btn_ten_export.btn_ten_icon_export
    self.btn_ten_text = self.root.scrollview_export.btn_ten_export.btn_ten_text_export
    self.tips = self.root.scrollview_export.tips_export
    self.freeTime = self.root.scrollview_export.freeTime_export
    self.ButChange = self.root.scrollview_export.ButChange_export
    self.remain = self.root.scrollview_export.item_node.remain_export
    self.node_layout = self.root.scrollview_export.node_layout_export
    self.node_move = self.root.scrollview_export.node_layout_export.node_move_export
    self.mojing = self.root.mojing_export

    uiMgr:addWidgetTouchHandler(self.btn_normal, function(sender, eventType) self:onCostDiamond(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_free, function(sender, eventType) self:onFree(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_free1, function(sender, eventType) self:onCostDiamond(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_ten, function(sender, eventType) self:onCostTenDiamond(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.ButChange, function(sender, eventType) self:node2Btn4(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil)

    local defY = self.scrollview:getContentSize().height
    self.scrollview:setContentSize(cc.size(720,gdisplay.height - 80))
    if (gdisplay.height - 80) <= defY then
        self.scrollview:setInnerContainerSize(cc.size(720, defY))
        self.node_layout:setContentSize(cc.size(720, 250))
    else
        local sh = gdisplay.height-(defY-170)
        self.node_layout:setContentSize(cc.size(720, sh))
        local per = math.floor((sh-10)/30)
        self.node_layout:setContentSize(cc.size(720, per*30+10))

        self.scrollview:setInnerContainerSize(cc.size(720,gdisplay.height - 80))
        local tt = gdisplay.height - 80 - defY
        for _ ,v in pairs(self.scrollview:getChildren()) do 
            v:setPositionY(v:getPositionY()+tt)
        end 
        self.scrollview.background_1:setPositionY(0)
        self.ButChange:setPositionY(55)
    end

    if gdisplay.height - 80 >= 1200 then
        self.scrollview:setBounceEnabled(false)
    else
        self.scrollview:setBounceEnabled(true)
    end

    local nodeTimeLine = resMgr:createTimeline("common/diamond_effect")
    nodeTimeLine:setTimeSpeed(0.5)
    nodeTimeLine:play("animation0", true)
    self.root:runAction(nodeTimeLine)
    self.btn_rmb = self.mojing.btn_rmb_export
    self.rmb_num = self.mojing.btn_rmb_export.rmb_num_export
    self.ResSetControl = ResSetControl.new(self.mojing,self)
    self.btn_rmb:setEnabled(false)
    self.node_layout:setPositionY(0)
    
end


function UITurntableHeroPanel:onEnter()

    self.ResSetControl:setRmbDelay(0)
    self.ResSetControl:setData()

    self.needTicket = 9
    self.isDoing = false
    local loginDoneHandler = function()
        if self.isDoing then
            -- 先结束在刷新
        else
            self:setData()
        end
    end
    self:addEventListener(global.gameEvent.EV_ON_HERO_TURNTABLE_CHANGE, loginDoneHandler) 

    self:setData()
    
end

function UITurntableHeroPanel:onExit()

    self.scrollfunc = nil 
    
end 

function UITurntableHeroPanel:setData()
    -- self.Image
    self.m_currIdx = 1
    self:refresh()

    local lFreeLotteryTime = global.dailyTaskData:getFreeLotteryTime()
    print(lFreeLotteryTime)
    self.func = function(dt)
        local svrTime = global.dataMgr:getServerTime()
        local sData = global.userData:getDayTurntableTimes(2)
        local restTime  = sData.lEndTime - svrTime
        if restTime <= 0 then 
            restTime = 0
        end

        local dayNum = math.floor(restTime/(24*3600))
        local str = ""
        if dayNum > 0 then
            str = string.format(global.luaCfg:get_local_string(10675),dayNum ,global.funcGame.formatTimeToHMS(restTime-dayNum*24*3600)) 
        else
            str = global.funcGame.formatTimeToHMS(restTime)
        end
        self.zeroTime:setString(str)

        if lFreeLotteryTime then
            local restTime1 = lFreeLotteryTime - svrTime
            if restTime1 <= 0 then
                restTime1 = 0
            else
            end
            self.freeTime:setString(global.funcGame.formatTimeToHMS(restTime1))
        end

        if self.scrollfunc then 
            self.scrollfunc()
        end 

    end
    if self.func then
        self:unschedule(self.func)
    end
    self.func()
    self:schedule(self.func, 1, -1)

    self:getRecentLog()
end


-- required string     lUserName       = 1;//用户名
-- required int32      lItemID     = 2;//道具ID
-- optional string     szParam     = 3;//扩展参数
function UITurntableHeroPanel:getRecentLog()
    self.node_layout:setVisible(false)
    global.ActivityAPI:getTurnTableLog(function(ret,msg)
        -- body
        if ret.retcode == WCODE.OK then
            if msg.tagTurnTableLog then
                if self.scrollLog then 
                    self:scrollLog(msg.tagTurnTableLog)
                end 
            end
        end
    end , 4)
end

function UITurntableHeroPanel:scrollLog(datas)

    -- dump(datas , "datas")
    self.node_layout:setVisible(true)
    local sH = self.node_layout:getContentSize().height
    local allNum = math.floor((sH-10)/30) + 1
    allNum = allNum > #datas and #datas or allNum
    
    self.m_itemWidgets = {}
    for i=1,allNum do
        
        if not self["ItmeFileNode_"..i] then      
            self["ItmeFileNode_"..i] = UITurntableLogItem.new()
            self.node_move:addChild(self["ItmeFileNode_"..i])
            self["ItmeFileNode_"..i]:setPosition(cc.p(45, sH-30*i-10))
        end
        self["ItmeFileNode_"..i]:setData(datas[i])
        table.insert(self.m_itemWidgets,self["ItmeFileNode_"..i])       
    end
    local len = #datas
    if len <= allNum then
        return
    end
    local idx = allNum
    self.scrollfunc = function(dt)
        if tolua.isnull(self.node_move) then return end
        self.node_move:stopAllActions()
        self.node_move:runAction(cc.Sequence:create(cc.MoveBy:create(0.5,cc.p(0,30)),cc.CallFunc:create(function()
            -- body
            local temp = self.m_itemWidgets[1]
            local y = temp:getPositionY()
            temp:setPositionY(y-allNum*30)
            idx = idx+1
            if idx > len then
                idx = 1
            end
            self.m_itemWidgets[1]:setData(datas[idx])
            table.remove(self.m_itemWidgets,1)
            table.insert(self.m_itemWidgets,temp)
        end)))
    end
end


function UITurntableHeroPanel:checkResEnough()

    local data = global.luaCfg:get_turntable_hero_cfg_by(1)
    self.btn_normal_text:setString( 1 )
    self.btn_refresh_cost_text:setString(data.exploit)
    self.btn_ten_text:setString(self.needTicket)

    global.tools:adjustNodePos(self.btn_normal_icon,self.btn_normal_text)
    global.tools:adjustNodePos(self.btn_refresh_icon,self.btn_refresh_cost_text)

    local haveItemCount = global.normalItemData:getItemNumByID(14101) or 0 

    self.remain:setString(haveItemCount)

    self.diaNotEnough = false
    self.diaTenNotEnough = false
    if  haveItemCount == 0 then
        self.diaNotEnough = true
    else
        self.btn_normal_text:setTextColor(cc.c3b(255, 184, 34))
        global.colorUtils.turnGray(self.normal_gray,false)
    end

    local need = self.needTicket - haveItemCount
    if  haveItemCount < self.needTicket  then
        self.diaTenNotEnough = true
    else
        self.btn_ten_text:setTextColor(cc.c3b(255, 184, 34))
        global.colorUtils.turnGray(self.ten_gray,false)
    end

    self.freeNotEnough = false
    if global.userData:getCurrExploit() < data.exploit then
        self.btn_refresh_cost_text:setTextColor(gdisplay.COLOR_RED)
        global.colorUtils.turnGray(self.free_gray,true)
        self.freeNotEnough = true
    else
        self.btn_refresh_cost_text:setTextColor(cc.c3b(255, 184, 34))
        global.colorUtils.turnGray(self.free_gray,false)
    end
end



function UITurntableHeroPanel:canOneDraw()

    local data = global.luaCfg:get_turntable_hero_cfg_by(1)
    local haveItemCount = global.normalItemData:getItemNumByID(14101) or 0 
    need = 1 - haveItemCount
    if  haveItemCount == 0  and not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,data.cost)   then
        return false , data.cost , need
    else
        return true ,data.cost , need
    end

end 

function UITurntableHeroPanel:canTenDraw()
    local data = global.luaCfg:get_turntable_hero_cfg_by(1)
    local haveItemCount = global.normalItemData:getItemNumByID(14101) or 0 
    local need = self.needTicket - haveItemCount
    if  haveItemCount == 0  and not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND, need * data.cost)   then
        return false  , need * data.cost , need
    else
        return true ,  need * data.cost , need
    end
end 

function UITurntableHeroPanel:refresh()
    -- self.Image

    local sData = global.userData:getDayTurntableTimes(2)
    dump(sData)
    self.nownum:setString(global.userData:getCurrExploit())
    self:checkResEnough()

    local isFreeTimes = global.userData:getFreeLotteryCount() <= 0
    self.freeTime:setVisible(not isFreeTimes)
    self.btn_free1:setVisible(isFreeTimes)

    self.m_items = {}
    for i=1,12 do
        local temp = self:getDataByPosition(i)
        self["FileNode_"..i]:setData(temp, true)
        self["FileNode_"..i]:setScale(1.4)
        table.insert(self.m_items, temp)
    end
    table.sort(self.m_items, function(a,b)
        return a.pos<b.pos
    end)

    if not tolua.isnull(self.preActionNode) then
        self.preActionNode:removeFromParent()
    end
    self.preActionNode = global.resMgr:createWidget(string.format("effect/lhj_speed%02d",self.m_currIdx))
    self.effect:addChild(self.preActionNode)
    self.preActionNode:setVisible(false)
end

function UITurntableHeroPanel:rotate(dstItem,isTen)
    self.preActionNode:setVisible(true)
    local normalCycle = 1 --匀速圈子
    if isTen then
        normalCycle = 4
    end

    local dstIdx = self:getIdxByItem(dstItem)
    local currIdx = self.m_currIdx

    --gevent:call(gsound.EV_ON_PLAYSOUND,"turntable_3")--音效添加（张亮）
    self.preActionNode.m_csbName = string.format("effect/lhj_speed%02d",self.m_currIdx)
    self.preActionNode.m_actionStr = "animation0"
    -- (node,isloop,isRemoveSelf,frameListener,lastCallback)
    global.resMgr:addCsbTimeLine(self.preActionNode,nil,true,nil,function()
        -- body
        self:cycleMove(currIdx,normalCycle,function()
            print("---------->cycleMove over")
            -- body
            -- self.preActionNode.m_csbName = "turntable/turntable_hero"
            -- self.preActionNode.m_actionStr = "animation1"
            -- -- (node,isloop,isRemoveSelf,frameListener,lastCallback)
            -- global.resMgr:addCsbTimeLine(self.preActionNode,nil,nil,nil,function()
            --     print("#####self:finalSelect(dstIdx)")
            --     self:finalSelect(dstIdx)
            -- end)
            print("#####self:finalSelect(dstIdx)")
            if isTen then
                self.root.timeLine:gotoFrameAndPlay(0,0,false)
                self:rotateOver()
            else
                print(dstIdx)
                self:finalSelect(dstIdx)
            end
        end,isTen)
    end)

    self.m_currIdx = dstIdx
end

function UITurntableHeroPanel:cycleMove(startIdx,times,overCall,isTen)
    print("---------->cycleMove times="..times)
    if isTen then
        if times < 2 then
            if overCall then overCall() end
            return
        end
    end
    if times < 1 then
        if overCall then overCall() end
        return
    end
    local idxToFrame = {36,40,44,48,52,56,60,64,68,24,28,32}
    if startIdx > 12 then
        return
    end
    local startFrame = idxToFrame[startIdx]
    local endFrame = startFrame+4*12
    local finalFrame = 237
    if times == 1 then
        endFrame = finalFrame
    end
    self.root.m_csbName = "turntable/turntable_hero"
    -- self.root.m_actionStr = "animation0"
    if self.root.timeLine then
        self.root:stopAction(self.root.timeLine)
    end
    self.root.timeLine = global.resMgr:createTimeline(self.root.m_csbName)
    self.root.timeLine:gotoFrameAndPlay(startFrame,endFrame,false)
    self.root.timeLine:setLastFrameCallFunc(function()
        self:cycleMove(startIdx,times-1,overCall,isTen)
    end)
    if isTen then
        self.root.timeLine:setTimeSpeed(1+(5-times)*0.5)
    end
    self.root:runAction(self.root.timeLine)
end


function UITurntableHeroPanel:finalSelect(dstIdx,isTen)
    -- print("##########-->final dstIdx ="..dstIdx)
    if dstIdx > 12 then
        return
    end
    local idxToFrame = {315,335,355,375,395,415,435,455,475,255,275,295}
    local startFrame = 237
    local endFrame = idxToFrame[dstIdx]
    self.root.m_csbName = "turntable/turntable_hero"
    -- self.root.m_actionStr = "animation0"
    if self.root.timeLine then
        self.root:stopAction(self.root.timeLine)
    end
    self.root.timeLine = global.resMgr:createTimeline(self.root.m_csbName)
    self.root.timeLine:setTimeSpeed(1.2)
    self.root.timeLine:gotoFrameAndPlay(startFrame,endFrame,false)
    self.root.timeLine:setLastFrameCallFunc(function()
        self.root.timeLine:gotoFrameAndPlay(0,0,false)
        self:rotateOver()
    end)
    self.root:runAction(self.root.timeLine)
end

function UITurntableHeroPanel:rotateOver()
    self.isDoing = false

    if self.m_finalItem then
        if #self.m_finalItem > 1 then
            global.panelMgr:openPanel("UITurntableHeroRewardPanel"):setData(self.m_finalItem)
            self.m_finalItem = nil
        else
            global.panelMgr:openPanel("UITurntableRewardPanel"):setData(self.m_finalItem)
            self.m_finalItem = nil
        end
    end
    self:setTouchUse(true)
    self:refresh()
end

function UITurntableHeroPanel:getIdxByItem(itemData)
    return itemData.pos
end

function UITurntableHeroPanel:getDataByPosition(position)
    local data = global.luaCfg:turntable_hero_reward()
    for i,v in ipairs(data) do
        if v.pos == position then
            local temp_v = {}
            if global.userData:isFirstFreeLotteryCount() and v.guideItem ~= 0 then
                temp_v = clone(v)
                temp_v.itemID = v.guideItem
                temp_v.num = v.guideNum
            else
                temp_v = v
            end
            return temp_v
        end
    end
end

function UITurntableHeroPanel:setTouchUse(can)

    global.colorUtils.turnGray(self.free_gray,not can)
    global.colorUtils.turnGray(self.normal_gray,not can)
    global.colorUtils.turnGray(self.ten_gray,not can)
    global.colorUtils.turnGray(self.btn_free1,not can)
    global.colorUtils.turnGray(self.ButChange,not can)
    self.btn_normal:setTouchEnabled(can)
    self.btn_free:setTouchEnabled(can)
    self.btn_ten:setTouchEnabled(can)
    self.btn_free1:setTouchEnabled(can)
    self.ButChange:setTouchEnabled(can)

    for i=1,12 do
        self["FileNode_"..i].randomBtn:setTouchEnabled(can)
    end

end

local UILongTipsControl = require("game.UI.common.UILongTipsControl")
function UITurntableHeroPanel:showTips(icon,itemId)
    if not icon.m_TipsControl then
        icon.m_TipsControl = UILongTipsControl.new(icon,WCONST.LONG_TIPS_PANEL.ITEM_DESC)
    end
    icon.m_TipsControl:setData({information=global.luaCfg:get_local_item_by(itemId)})

    return m_TipsControl
end

function UITurntableHeroPanel:exit_call(sender, eventType)


    if self.m_finalItem then
        if #self.m_finalItem > 1 then
            global.panelMgr:openPanel("UITurntableHeroRewardPanel"):setData(self.m_finalItem)
            self.m_finalItem = nil
        else
            global.panelMgr:openPanel("UITurntableRewardPanel"):setData(self.m_finalItem)
            self.m_finalItem = nil
        end
    end
    global.panelMgr:closePanelForBtn("UITurntableHeroPanel")  
    global.panelMgr:destroyPanel("UITurntableHeroPanel") 

end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UITurntableHeroPanel:onFree(sender, eventType)
    if self.freeNotEnough then
        global.tipsMgr:showWarning("turntable01")
        return
    end
    -- 军功
    global.ActivityAPI:getSpinLottery(function(ret,msg)
        -- body
        if ret.retcode == WCODE.OK then
            if tolua.isnull(self) then
                return
            end
            self.isDoing = true
            self:setTouchUse(false)
            -- global.userData:addDayTurntableTimes(2)
        --     global.userData:addDayTurntableTimes()
        --     self:checkDiamondEnough()
        --     global.colorUtils.turnGray(self.grayBg,true)
        --     self.divDiaBtn:setTouchEnabled(false)
            if not msg.lWin then return end
            local selectItem = global.luaCfg:get_turntable_hero_reward_by(msg.lWin[1])
            self.m_finalItem = selectItem
            self:rotate(selectItem)
        end
    end,2,2)

end

function UITurntableHeroPanel:onCostDiamond(sender, eventType)

    local drawCall = function () 
        global.ActivityAPI:getSpinLottery(function(ret,msg)
            -- body
            if ret.retcode == WCODE.OK then
                if tolua.isnull(self) then
                    return
                end
                self.isDoing = true
                self:setTouchUse(false)
                -- global.userData:addDayTurntableTimes(2)
            --     global.userData:addDayTurntableTimes()
            --     self:checkDiamondEnough()
            --     global.colorUtils.turnGray(self.grayBg,true)
            --     self.divDiaBtn:setTouchEnabled(false)
                if not msg.lWin then return end
                local selectItem = global.luaCfg:get_turntable_hero_reward_by(msg.lWin[1])
                self.m_finalItem = self.m_items[self:getIdxByItem(selectItem)]
                self:rotate(selectItem)
            end
        end,2,1)
    end

    -- 魔晶
    if not self.btn_free1:isVisible() and self.diaNotEnough then

        local exitCall = function ()  
            if global.panelMgr:getIndexPanelName(2) and global.panelMgr:getIndexPanelName(2) =="UITurntableEnterPanel"  then 
                global.panelMgr:closePanelExecptDown()    
                global.tipsMgr:showWarning("ItemUseDiamond")
            else 
                global.tipsMgr:showWarning("ItemUseDiamond")
                self:exit_call()
            end
        end 

        local state , cost , have = self:canOneDraw()

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setRichData({have , cost})
        panel:setData("50339",function ()
            if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND, cost) then
                exitCall()
            else
                drawCall()
            end
        end)

        return 
    end

    if self.btn_free1:isVisible() then
        self.btn_free1:setVisible(false)
        global.userData:updateFreeLotteryCount(1)
        gevent:call(global.gameEvent.EV_ON_UI_LEISURE)
    end

    drawCall()
end

function UITurntableHeroPanel:onCostTenDiamond(sender, eventType)

    -- dropItem={{1,1400,100},{3,700,100},{2,700,100},{4,700,100},{5,5,100}}
    -- global.panelMgr:openPanel("UIItemRewardPanel"):setData(item, true )

    local drawCall = function () 
        global.ActivityAPI:getSpinLottery(function(ret,msg)
            -- body
            if ret.retcode == WCODE.OK then
                if tolua.isnull(self) then
                    return
                end
                self.isDoing = true
                self:setTouchUse(false)
                -- global.userData:addDayTurntableTimes(2)
            --     global.userData:addDayTurntableTimes()
            --     self:checkDiamondEnough()
            --     global.colorUtils.turnGray(self.grayBg,true)
            --     self.divDiaBtn:setTouchEnabled(false)
                if not msg.lWin then return end
                local data = {}
                local lowestOdds = 1000
                local selectItem = 0
                for i,v in ipairs(msg.lWin) do
                    local item = global.luaCfg:get_turntable_hero_reward_by(v)
                    if item.odds < lowestOdds then
                        lowestOdds = item.odds
                        selectItem = item
                    end
                    table.insert(data,item)
                end
                self.m_finalItem = data
                self:rotate(selectItem,true)
                -- global.panelMgr:openPanel("UIItemRewardPanel"):setData(self.m_finalItem)
                -- self:setTouchUse(true)
                -- self.m_finalItem = nil
                -- self:refresh()
            end
        end,4,1)
    end 

    -- 魔晶
    if self.diaTenNotEnough then
        local exitCall=   function () 
            if global.panelMgr:getIndexPanelName(2) and global.panelMgr:getIndexPanelName(2) =="UITurntableEnterPanel"  then 
                global.panelMgr:closePanelExecptDown()    
                global.tipsMgr:showWarning("ItemUseDiamond")
            else 
                global.tipsMgr:showWarning("ItemUseDiamond")
                self:exit_call()
            end 
        end 

        local state , cost ,  have = self:canTenDraw()

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setRichData({have, cost})
        panel:setData("50339",function ()
            if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND, cost) then
                exitCall()
            else
                drawCall()
            end
        end)

        return 
    end

    drawCall()
end

function UITurntableHeroPanel:node2Btn4(sender, eventType)
    global.panelMgr:openPanel("UIChangeShopPanel")
end
--CALLBACKS_FUNCS_END

return UITurntableHeroPanel

--endregion
