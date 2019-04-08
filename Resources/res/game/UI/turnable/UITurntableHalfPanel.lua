--region UITurntableHalfPanel.lua
--Author : wuwx
--Date   : 2017/11/13
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UITurntableItem = require("game.UI.turnable.UITurntableItem")
local UITurntableLogItem = require("game.UI.turnable.UITurntableLogItem")
--REQUIRE_CLASS_END

local UITurntableHalfPanel  = class("UITurntableHalfPanel", function() return gdisplay.newWidget() end )
local ResSetControl = require("game.UI.commonUI.widget.ResSetControl")

function UITurntableHalfPanel:ctor()
    self:CreateUI()
end

function UITurntableHalfPanel:CreateUI()
    local root = resMgr:createWidget("turntable/turntable_day")
    self:initUI(root)
end

function UITurntableHalfPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "turntable/turntable_day")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Image = self.root.Image_export
    self.turntable3 = self.root.Image_export.turntable3_export
    self.turntable3 = UITurntableItem.new()
    uiMgr:configNestClass(self.turntable3, self.root.Image_export.turntable3_export)
    self.turntable4 = self.root.Image_export.turntable4_export
    self.turntable4 = UITurntableItem.new()
    uiMgr:configNestClass(self.turntable4, self.root.Image_export.turntable4_export)
    self.turntable5 = self.root.Image_export.turntable5_export
    self.turntable5 = UITurntableItem.new()
    uiMgr:configNestClass(self.turntable5, self.root.Image_export.turntable5_export)
    self.turntable2 = self.root.Image_export.turntable2_export
    self.turntable2 = UITurntableItem.new()
    uiMgr:configNestClass(self.turntable2, self.root.Image_export.turntable2_export)
    self.turntable1 = self.root.Image_export.turntable1_export
    self.turntable1 = UITurntableItem.new()
    uiMgr:configNestClass(self.turntable1, self.root.Image_export.turntable1_export)
    self.turntable6 = self.root.Image_export.turntable6_export
    self.turntable6 = UITurntableItem.new()
    uiMgr:configNestClass(self.turntable6, self.root.Image_export.turntable6_export)
    self.turntable7 = self.root.Image_export.turntable7_export
    self.turntable7 = UITurntableItem.new()
    uiMgr:configNestClass(self.turntable7, self.root.Image_export.turntable7_export)
    self.turntable8 = self.root.Image_export.turntable8_export
    self.turntable8 = UITurntableItem.new()
    uiMgr:configNestClass(self.turntable8, self.root.Image_export.turntable8_export)
    self.turntable9 = self.root.Image_export.turntable9_export
    self.turntable9 = UITurntableItem.new()
    uiMgr:configNestClass(self.turntable9, self.root.Image_export.turntable9_export)
    self.turntable10 = self.root.Image_export.turntable10_export
    self.turntable10 = UITurntableItem.new()
    uiMgr:configNestClass(self.turntable10, self.root.Image_export.turntable10_export)
    self.title = self.root.title_export
    self.btn_normal = self.root.btn_normal_export
    self.normal_gray = self.root.btn_normal_export.normal_gray_export
    self.btn_normal_icon = self.root.btn_normal_export.btn_normal_icon_export
    self.btn_normal_text = self.root.btn_normal_export.btn_normal_text_export
    self.btn_free1 = self.root.btn_free1_export
    self.free1_gray = self.root.btn_free1_export.free1_gray_export
    self.freeTime = self.root.freeTime_export
    self.btn_ten = self.root.btn_ten_export
    self.ten_gray = self.root.btn_ten_export.ten_gray_export
    self.btn_ten_icon = self.root.btn_ten_export.btn_ten_icon_export
    self.btn_ten_text = self.root.btn_ten_export.btn_ten_text_export
    self.divDiaBtn = self.root.divDiaBtn_export
    self.grayBg = self.root.divDiaBtn_export.grayBg_export
    self.divDiaNum = self.root.divDiaBtn_export.divDiaNum_export
    self.tips = self.root.tips_export
    self.zeroTime = self.root.zeroTime_export
    self.reset = self.root.reset_mlan_10_export
    self.node_layout = self.root.node_layout_export
    self.node_move = self.root.node_layout_export.node_move_export
    self.FileNode_1 = UITurntableLogItem.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.node_layout_export.node_move_export.FileNode_1)
    self.FileNode_2 = UITurntableLogItem.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.node_layout_export.node_move_export.FileNode_2)
    self.FileNode_3 = UITurntableLogItem.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.node_layout_export.node_move_export.FileNode_3)
    self.FileNode_4 = UITurntableLogItem.new()
    uiMgr:configNestClass(self.FileNode_4, self.root.node_layout_export.node_move_export.FileNode_4)
    self.FileNode_5 = UITurntableLogItem.new()
    uiMgr:configNestClass(self.FileNode_5, self.root.node_layout_export.node_move_export.FileNode_5)
    self.FileNode_6 = UITurntableLogItem.new()
    uiMgr:configNestClass(self.FileNode_6, self.root.node_layout_export.node_move_export.FileNode_6)
    self.FileNode_7 = UITurntableLogItem.new()
    uiMgr:configNestClass(self.FileNode_7, self.root.node_layout_export.node_move_export.FileNode_7)
    self.FileNode_8 = UITurntableLogItem.new()
    uiMgr:configNestClass(self.FileNode_8, self.root.node_layout_export.node_move_export.FileNode_8)
    self.FileNode_9 = UITurntableLogItem.new()
    uiMgr:configNestClass(self.FileNode_9, self.root.node_layout_export.node_move_export.FileNode_9)
    self.FileNode_10 = UITurntableLogItem.new()
    uiMgr:configNestClass(self.FileNode_10, self.root.node_layout_export.node_move_export.FileNode_10)
    self.FileNode_11 = UITurntableLogItem.new()
    uiMgr:configNestClass(self.FileNode_11, self.root.node_layout_export.node_move_export.FileNode_11)
    self.mojing = self.root.mojing_export
    self.poolBtn = self.root.poolBtn_export
    self.remain = self.root.remain_export

    uiMgr:addWidgetTouchHandler(self.btn_normal, function(sender, eventType) self:onCostDiamond(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_free1, function(sender, eventType) self:onCostDiamond(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_ten, function(sender, eventType) self:onCostTenDiamond(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.divDiaBtn, function(sender, eventType) self:divineClick(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.poolBtn, function(sender, eventType) self:gotoPool(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    local nodeTimeLine = resMgr:createTimeline("common/diamond_effect")
    nodeTimeLine:setTimeSpeed(0.5)
    nodeTimeLine:play("animation0", true)
    self.root:runAction(nodeTimeLine)
    self.btn_rmb = self.mojing.btn_rmb_export
    self.rmb_num = self.mojing.btn_rmb_export.rmb_num_export
    self.ResSetControl = ResSetControl.new(self.mojing,self)
    self.btn_rmb:setEnabled(false)

end

function UITurntableHalfPanel:onEnter()

    self.ResSetControl:setRmbDelay(0)
    self.ResSetControl:setData()


    self.m_finalId = nil
    self:setData(data)
end

function UITurntableHalfPanel:setData(data)
    -- self.Image
    self:checkDiamondEnough() 
    self:resetRewards()
    self:getRecentLog()
    self:initState()

    -- global.tools:adjustNodePos(self.divDiaBtn.dia_icon,self.divDiaNum)
end

function UITurntableHalfPanel:initState()

    local isFreeTimes = global.userData:getDyFreeLotteryCount() <= 0
    self.freeTime:setVisible(not isFreeTimes)
    self.btn_free1:setVisible(isFreeTimes)
    
    local lFreeLotteryTime = global.dailyTaskData:getFreeLotteryTime()
    if lFreeLotteryTime then
        self.func1 = function(dt)
            local svrTime = global.dataMgr:getServerTime()
            if lFreeLotteryTime then
                local restTime1 = lFreeLotteryTime - svrTime
                if restTime1 <= 0 then
                    restTime1 = 0
                else
                end
                self.freeTime:setString(global.funcGame.formatTimeToHMS(restTime1))
            end
        end
        if self.func1 then
            self:unschedule(self.func1)
        end
        self.func1()
        self:schedule(self.func1, 1, -1)
    end
    self:checkDiamondEnough() 

end

function UITurntableHalfPanel:resetRewards()
    -- self.Image

    local data = global.luaCfg:turntable_day_reward()
    self.m_items = {}
    self.m_initDic = self:decodeLastRecord()
    local len = table.nums(self.m_initDic)
    for i,v in ipairs(data) do

        local temp_v = {}
        if global.userData:isFirstDyFreeLotteryCount() and v.guideItem ~= 0 then
            temp_v = clone(v)
            temp_v.itemID = v.guideItem
            temp_v.num = v.guideNum
        else
            temp_v = v
        end

        if table.hasval(self.m_initDic,temp_v.itemID) then
        else
            table.insert(self.m_items,temp_v.itemID)
        end
    end

    if len < 10 then
        for i=1,10 do
            if self.m_initDic[i] then
            else
                local randIdx = math.random(#self.m_items)
                self.m_initDic[i] = self.m_items[randIdx]
                table.remove(self.m_items,randIdx)
            end
        end
    end

    self.Image:setRotation(0)
    self.m_angle = 0
    for i=1,10 do
        self["turntable"..i]:setData(self.m_initDic[i])
        self["turntable"..i]:setTestStr(i)
        self["turntable"..i]:setRotation(-self.m_angle)
    end

end

-- required string     lUserName       = 1;//用户名
-- required int32      lItemID     = 2;//道具ID
-- optional string     szParam     = 3;//扩展参数
function UITurntableHalfPanel:getRecentLog()
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
    end, 3)
end

function UITurntableHalfPanel:scrollLog(datas)
    self.node_layout:setVisible(true)
    self.m_itemWidgets = {}
    for i=1,11 do
        table.insert(self.m_itemWidgets,self["FileNode_"..i])
        if datas[i] then
            self["FileNode_"..i]:setVisible(true)
            self["FileNode_"..i]:setData(datas[i])
        else
            self["FileNode_"..i]:setVisible(false)
        end
    end
    local len = #datas
    if len <= 11 then
        return
    end
    local idx = 11
    self.scrollfunc = function(dt)
        if tolua.isnull(self.node_move) then return end
        self.node_move:runAction(cc.Sequence:create(cc.MoveBy:create(0.5,cc.p(0,30)),cc.CallFunc:create(function()
            -- body
            local temp = self.m_itemWidgets[1]
            local y = temp:getPositionY()
            temp:setPositionY(y-11*30)
            idx = idx+1
            if idx > len then
                idx = 1
            end
            self.m_itemWidgets[1]:setData(datas[idx])
            table.remove(self.m_itemWidgets,1)
            table.insert(self.m_itemWidgets,temp)
        end)))
    end
    if self.scrollfunc then
        self:unschedule(self.scrollfunc)
    end
    -- self.scrollfunc()
    self:schedule(self.scrollfunc, 1, -1)
end

-- 更改
function UITurntableHalfPanel:changeItem(idx,selectItemId)
    -- self.Image
    local lastItemId = self.m_initDic[idx]
    -- dump(self.m_items)
    if selectItemId and selectItemId~= 0 then

        local key = table.keyOfItem(self.m_initDic,selectItemId)
        if key then
            -- 已经在了，就交换位置
            local temp = self.m_initDic[key]
            self.m_initDic[key] = self.m_initDic[idx]
            self["turntable"..key]:setData(self.m_initDic[key])
            self["turntable"..key]:setTestStr(key)
            self.m_initDic[idx] = temp
            -- dump(self.m_initDic)
        else
            local key = table.keyOfItem(self.m_items,selectItemId)
            self.m_items[key] = self.m_initDic[idx]
            self.m_initDic[idx] = selectItemId
            -- dump(self.m_initDic,"---------------》")
        end
        self["turntable"..idx]:setData(self.m_initDic[idx])
        self["turntable"..idx]:setTestStr("s-"..idx)
    else
        local randIdx = math.random(#self.m_items)
        self.m_initDic[idx] = self.m_items[randIdx]
        self["turntable"..idx]:setData(self.m_initDic[idx])
        self["turntable"..idx]:setTestStr(idx)
        table.remove(self.m_items,randIdx)
        table.insert(self.m_items,lastItemId)
        -- dump(self.m_initDic)
    end
end

local lastIdx = 0
function UITurntableHalfPanel:updateItemRotation(initDic,list,islock)
    -- self.Image
    local randomList = list
    local selectedIdx = math.floor((self.m_angle%360+18)/36)+1
    if selectedIdx > 10 then
        selectedIdx = 1
    end
    for i=1,10 do
        self["turntable"..i]:setRotation(-self.m_angle)
    end

    print("selectedIdx==>>"..selectedIdx)
    if lastIdx == selectedIdx then
        -- 防止重复设置
        return
    end
    lastIdx = selectedIdx

    local reverseIdx = (selectedIdx+5)%10
    if reverseIdx == 0 then
        reverseIdx = 10
    end

    if islock and islock ~= 0 and islock == reverseIdx then
        -- 选中就不改了。
    else
        self:changeItem(reverseIdx)
    end
end

function UITurntableHalfPanel:idxToAngle(nowAngle,selectItemId)
    print("nowAngle="..nowAngle)
    local nowAngle = math.ceil(nowAngle)
    local nowIdx = math.floor((nowAngle%360+18)/36)+1
    if nowIdx > 10 then
        nowIdx = 1
    end

    local dstIdx = (nowIdx+5)%10
    if dstIdx == 0 then
        dstIdx = 10
    end
    print("dstIdx="..dstIdx)
    print("nowIdx="..nowIdx)
    local rest36 = nowAngle%36
    if rest36 >= 18 then
        rest36 = 36-rest36
    else
        rest36 = -rest36
    end
    local dstAngle = nowAngle+rest36+(36*(dstIdx-nowIdx))

    print("111dstAngle="..dstAngle)
    if (dstIdx-nowIdx) < 0 then
        dstAngle = dstAngle+360
    else
        -- dstAngle = dstAngle+360
    end
    self:changeItem(dstIdx,selectItemId)
    print("222dstAngle="..dstAngle)
    return dstAngle,dstIdx
end


-- 1+2+1 initv = 360
function UITurntableHalfPanel:rotate(initDic,list,selectItemId, isTen)
    local a = 400+math.random(50) --起步加速度
    local a1 = 0    --匀速
    local a2 = -200 --减速
    local a3 = -8  --匀速
    local t1 = 1  --起步时间 t1-0 = 1
    local t2 = 2  --匀速时间 t2-t1 = 1
    local t3 = 5  --减速时间t3-t2 = 3
    local dstv = 50 --最终匀速选择速度
    if isTen then
        t2 = 4
    end

    local v0 = 0
    local t = 1
    local vt = v0+a*t
    local interval = 0.025
    local dstAngle = 0
    local dstAngle1 = 0
    local dstAngle2 = 0
    local dstAngle3 = 0

    local dut = interval
    local det = interval
    local vt = vo
    local isFirst = true
    local islock = false
    local fianlAngle,selectedIdx = 0

    self.root.m_csbName = "turntable/turntable_day"
    self.root.m_actionStr = "animation0"
    -- (node,isloop,isRemoveSelf,frameListener,lastCallback)
    global.resMgr:addCsbTimeLine(self.root,true,nil,nil)
    self.func = function(dt)
        -- body
        dut = dut + interval
        if dut < t1  then
            -- 加速
            dstAngle = v0*dut+1/2*a*dut*dut
            vt = v0+a*dut
            print(vt)
            self.Image:setRotation(dstAngle)
            self.m_angle = dstAngle
        elseif dut >= t1 and dut <= t2 then
            -- 匀速
            v0 = vt
            dstAngle1 = dstAngle+vt*(dut-t1)
            print(vt)
            self.Image:setRotation(dstAngle1)
            self.m_angle = dstAngle1
        elseif dut >= t2 and dut <= t3 then

            if isTen then
                self:tenTurnOver(initDic,list,islock)
                return
            end

            -- 减速
            det = dut-t2
            vt = v0+a2*det
            dstAngle2 = dstAngle1+v0*det+1/2*a2*det*det
            if vt <= dstv and isFirst then
                isFirst = false
                a2 = 0
                v0 = dstv
                t2 = dut
                dstAngle1 = dstAngle2
                fianlAngle,selectedIdx = self:idxToAngle(dstAngle2,selectItemId)
                islock = selectedIdx
                print(fianlAngle)
                self.root.m_csbName = "turntable/turntable_day"
                self.root.m_actionStr = "animation1"
                -- (node,isloop,isRemoveSelf,frameListener,lastCallback)
                global.resMgr:addCsbTimeLine(self.root,nil,nil,nil)
                -- a3 = 
            end
            self.Image:setRotation(dstAngle2)
            self.m_angle = dstAngle2

        elseif dut >= t3 then
            -- 选中结果的阶段
            v0 = dstv
            det = dut-t3
            local da = v0*det+1/2*a3*det*det
            -- if da <= 5 then
            --     da = 5
            -- end
            dstAngle3 = dstAngle2+da
            self.m_angle = dstAngle3
            -- if fianlAngle - dstAngle3 <= 180 then
            --     islock = selectedIdx
            -- end

            if dstAngle3 >= fianlAngle then
                print("exit()")
                self.Image:setRotation(fianlAngle)
                if self.func then
                    self:unschedule(self.func)
                end
                self:rotateOverRecordInfo(selectedIdx)
            else
                self.Image:setRotation(dstAngle3)
            end
        end
        print(dut)
        self:updateItemRotation(initDic,list,islock)
    end
    if self.func then
        self:unschedule(self.func)
    end
    self:schedule(self.func, interval, -1)
end

function UITurntableHalfPanel:tenTurnOver(initDic,list,islock)

    self.Image:setRotation(0)
    if self.func then
        self:unschedule(self.func)
    end
    self.m_angle = 0
    self:updateItemRotation(initDic,list,islock)
    self:rotateOverRecordInfo(1)

end

function UITurntableHalfPanel:rotateOverRecordInfo(selectedIdx)
    
    if not selectedIdx or selectedIdx<1 or selectedIdx>10  then
        return
    end
  
    self.root.m_csbName = "turntable/turntable_day"
    self.root.m_actionStr = "animation2"
    -- (node,isloop,isRemoveSelf,frameListener,lastCallback)
    global.resMgr:addCsbTimeLine(self.root,nil,nil,nil)

    -- global.colorUtils.turnGray(self.grayBg,false)
    -- self.divDiaBtn:setTouchEnabled(true)
    self:setTouchUse(true)

    if self.m_finalId then
        if #self.m_finalId > 1 then
            global.panelMgr:openPanel("UITurntableHeroRewardPanel"):setData(self.m_finalId, true)
        else
            global.panelMgr:openPanel("UITurntableRewardPanel"):setData(self.m_finalId, true)
        end
    end

    self.clickstate = 0
    self.m_finalId = nil
    local str = self:getItemId(selectedIdx-2).itemID
    for i = -1,2 do
        str = str.."#"..self:getItemId(selectedIdx+i).itemID
    end
    cc.UserDefault:getInstance():setStringForKey("turntable_record_001",str)
    return str
end

function UITurntableHalfPanel:decodeLastRecord()
    local str = cc.UserDefault:getInstance():getStringForKey("turntable_record_001")
    local strArr = string.split(str, "#")
    local initDic = {}
    initDic[9] =tonumber(strArr[1])
    initDic[10]=tonumber(strArr[2])
    initDic[1] =tonumber(strArr[3])
    initDic[2] =tonumber(strArr[4])
    initDic[3] =tonumber(strArr[5])
    -- dump(initDic)
    return initDic
end

function UITurntableHalfPanel:getItemId(selectedIdx)
    if selectedIdx<1 then
        selectedIdx = 10-selectedIdx
    end
    if selectedIdx>10 then
        selectedIdx = selectedIdx-10
    end
    return self["turntable"..selectedIdx]:getItemId()
end

function UITurntableHalfPanel:checkDiamondEnough()
    
    -- local times = global.userData:getDayTurntableTimes(3).lCount or 0
    -- local costData = global.luaCfg:get_turntable_day_consume_by(times+1)
    -- if not costData then
    --     local len = #global.luaCfg:turntable_day_consume()
    --     costData = global.luaCfg:get_turntable_day_consume_by(len)
    -- end

    -- local diaNum = costData.cost
    -- self.divDiaNum:setString(diaNum) 
    -- global.tools:adjustNodePos(self.divDiaBtn.dia_icon,self.divDiaNum)

    -- self.diaNotEnough = false
    -- self.divDiaBtn:setTouchEnabled(true)
    -- if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,diaNum) then
    --     self.divDiaNum:setTextColor(gdisplay.COLOR_RED)
    --     global.colorUtils.turnGray(self.grayBg,true)
    --     self.diaNotEnough = true
    -- else
    --     self.divDiaNum:setTextColor(cc.c3b(255, 184, 34))
    --     global.colorUtils.turnGray(self.grayBg,false)
    -- end

    -- if times and times > 0 then
    --     self.countdown_func = function(dt)
    --         local lEndTime = global.dailyTaskData:getNextFlushTime()
    --         local restTime  = lEndTime - global.dataMgr:getServerTime()
    --         if restTime <= 0 then 
    --             restTime = 0

    --             global.userData:resetTurntableTimes(1)
    --             self.zeroTime:setVisible(false)
    --             self.reset:setVisible(false)

    --             if self.countdown_func then
    --                 self:unschedule(self.countdown_func)
    --             end
    --         end
    --         self.zeroTime:setString(global.funcGame.formatTimeToHMS(restTime))
    --     end
    --     if self.countdown_func then
    --         self:unschedule(self.countdown_func)
    --     end
    --     self.countdown_func()
    --     self:schedule(self.countdown_func, 1, -1)

    --     self.zeroTime:setVisible(true)
    --     self.reset:setVisible(true)
    -- else
    --     self.zeroTime:setVisible(false)
    --     self.reset:setVisible(false)
    -- end
    
    local data = global.luaCfg:get_turntable_day_cfg_by(1)
    self.diaTenNotEnough = false
    local haveItemCount = global.normalItemData:getItemNumByID(data.turntable_item) or 0 
    if haveItemCount < 10 then
        self.diaTenNotEnough = true
    end

    self.diaNotEnough = false
    if haveItemCount == 0 then
        self.diaNotEnough = true
    end

    self.remain:setString(haveItemCount)

end

local UILongTipsControl = require("game.UI.common.UILongTipsControl")
function UITurntableHalfPanel:showTips(icon,itemId)
    if not icon.m_TipsControl then
        icon.m_TipsControl = UILongTipsControl.new(icon,WCONST.LONG_TIPS_PANEL.ITEM_DESC)
    end
    icon.m_TipsControl:setData({information=global.luaCfg:get_local_item_by(itemId)})

    return m_TipsControl
end

function UITurntableHalfPanel:exit_call(sender, eventType)

    if self.m_finalId then

        if #self.m_finalId > 1 then
            global.panelMgr:openPanel("UITurntableHeroRewardPanel"):setData(self.m_finalId, true)
            self.m_finalId = nil
        else
            global.panelMgr:openPanel("UITurntableRewardPanel"):setData(self.m_finalId, true)
            self.m_finalId = nil
        end

    end
    global.panelMgr:closePanelForBtn("UITurntableHalfPanel")  
    global.panelMgr:destroyPanel("UITurntableHalfPanel") 

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UITurntableHalfPanel:divineClick(sender, eventType)
    -- print("click-------->")
    -- -- self.Image:setVisible(not self.Image:isVisible())
    -- if self.diaNotEnough then
    --      if global.panelMgr:getIndexPanelName(2) and global.panelMgr:getIndexPanelName(2) =="UITurntableEnterPanel"  then 
    --         global.panelMgr:closePanelExecptDown()    
    --         global.tipsMgr:showWarning("ItemUseDiamond")
    --     else 
    --         global.tipsMgr:showWarning("ItemUseDiamond")
    --         self:exit_call()
    --     end 
    --     return  
    -- end
    -- global.ActivityAPI:getSpinLottery(function(ret,msg)
    --     -- body
    --     if ret.retcode == WCODE.OK then
    --         global.userData:addDayTurntableTimes(3)
    --         if self.checkDiamondEnough then -- protect  
    --             self:checkDiamondEnough()
    --             global.colorUtils.turnGray(self.grayBg,true)
    --             self.divDiaBtn:setTouchEnabled(false)
    --             if not msg.lWin then return end
    --             local selectItem = global.luaCfg:get_turntable_day_reward_by(msg.lWin[1])
    --             self.m_finalId = selectItem
    --             self:resetRewards()
    --             self:rotate(self.m_initDic,self.m_items,selectItem.itemID)
    --         end 
    --     end
    -- end,3)
end

function UITurntableHalfPanel:setTouchUse(can)

    global.colorUtils.turnGray(self.normal_gray,not can)
    global.colorUtils.turnGray(self.ten_gray,not can)
    global.colorUtils.turnGray(self.btn_free1,not can)
    global.colorUtils.turnGray(self.poolBtn,not can)
    self.btn_normal:setTouchEnabled(can)
    self.btn_ten:setTouchEnabled(can)
    self.btn_free1:setTouchEnabled(can)
    self.poolBtn:setTouchEnabled(can)
end

function UITurntableHalfPanel:onCostDiamond(sender, eventType)
    
    local drawCall = function () 
        global.ActivityAPI:getSpinLottery(function(ret,msg)
            -- body
            if ret.retcode == WCODE.OK then
                if tolua.isnull(self) then
                    return
                end
                self:setTouchUse(false)
                if not msg.lWin then return end
                local selectItem = clone(global.luaCfg:get_turntable_day_reward_by(msg.lWin[1]))
                local temp_v = {}
                if global.userData:isFirstDyFreeLotteryCount() and selectItem.guideItem ~= 0 then
                    temp_v = clone(selectItem)
                    temp_v.itemID = selectItem.guideItem
                    temp_v.num = selectItem.guideNum
                else
                    temp_v = selectItem
                end

                self.m_finalId = temp_v
                self:resetRewards()
                self:rotate(self.m_initDic,self.m_items, temp_v.itemID)
            end
        end,3)
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
        panel:setData("50341",function ()
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
        global.userData:updateDyFreeLotteryCount(1)
    end

    drawCall()

end 

function UITurntableHalfPanel:onCostTenDiamond(sender, eventType)
    
    local drawCall = function () 
        global.ActivityAPI:getSpinLottery(function(ret,msg)
            -- body
            if ret.retcode == WCODE.OK then
                if tolua.isnull(self) then
                    return
                end

                self:setTouchUse(false)
                if not msg.lWin then return end
                local data = {}
                local selectItem = global.luaCfg:get_turntable_day_reward_by(msg.lWin[1])
                for i,v in ipairs(msg.lWin) do
                    local item = global.luaCfg:get_turntable_day_reward_by(v)
                    table.insert(data,item)
                end
                self.m_finalId = data
                self:resetRewards()
                self:rotate(self.m_initDic,self.m_items, selectItem.itemID, true)

            end
        end,5)
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
        panel:setData("50341",function ()
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

function UITurntableHalfPanel:canOneDraw()

    local data = global.luaCfg:get_turntable_day_cfg_by(1)
    local haveItemCount = global.normalItemData:getItemNumByID(data.turntable_item) or 0 
    need = 1 - haveItemCount
    if  haveItemCount == 0  and not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,data.turntable_cost)   then
        return false , data.turntable_cost , need
    else
        return true ,data.turntable_cost , need
    end

end 

function UITurntableHalfPanel:canTenDraw()
    local data = global.luaCfg:get_turntable_day_cfg_by(1)
    local haveItemCount = global.normalItemData:getItemNumByID(data.turntable_item) or 0 
    local need = 10 - haveItemCount
    if  haveItemCount == 0  and not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND, need * data.turntable_cost)   then
        return false  , need * data.turntable_cost , need
    else
        return true ,  need * data.turntable_cost , need
    end
end

function UITurntableHalfPanel:gotoPool(sender, eventType)
    global.panelMgr:openPanel('UIHeroComePool'):setTurnTableHalf()
end
--CALLBACKS_FUNCS_END

return UITurntableHalfPanel

--endregion
