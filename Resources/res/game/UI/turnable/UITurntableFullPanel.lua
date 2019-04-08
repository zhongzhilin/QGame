--region UITurntableFullPanel.lua
--Author : wuwx
--Date   : 2017/11/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UITurntableFullItem = require("game.UI.turnable.UITurntableFullItem")
--REQUIRE_CLASS_END

local UITurntableFullPanel  = class("UITurntableFullPanel", function() return gdisplay.newWidget() end )
local ResSetControl = require("game.UI.commonUI.widget.ResSetControl")

function UITurntableFullPanel:ctor()
    self:CreateUI()
end

function UITurntableFullPanel:CreateUI()
    local root = resMgr:createWidget("turntable/turntable_pay")
    self:initUI(root)
end

function UITurntableFullPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "turntable/turntable_pay")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.scrollview = self.root.scrollview_export
    self.Image = self.root.scrollview_export.Image_export
    self.FileNode1 = self.root.scrollview_export.Image_export.FileNode1_export
    self.FileNode1 = UITurntableFullItem.new()
    uiMgr:configNestClass(self.FileNode1, self.root.scrollview_export.Image_export.FileNode1_export)
    self.FileNode2 = self.root.scrollview_export.Image_export.FileNode2_export
    self.FileNode2 = UITurntableFullItem.new()
    uiMgr:configNestClass(self.FileNode2, self.root.scrollview_export.Image_export.FileNode2_export)
    self.FileNode3 = self.root.scrollview_export.Image_export.FileNode3_export
    self.FileNode3 = UITurntableFullItem.new()
    uiMgr:configNestClass(self.FileNode3, self.root.scrollview_export.Image_export.FileNode3_export)
    self.FileNode4 = self.root.scrollview_export.Image_export.FileNode4_export
    self.FileNode4 = UITurntableFullItem.new()
    uiMgr:configNestClass(self.FileNode4, self.root.scrollview_export.Image_export.FileNode4_export)
    self.FileNode5 = self.root.scrollview_export.Image_export.FileNode5_export
    self.FileNode5 = UITurntableFullItem.new()
    uiMgr:configNestClass(self.FileNode5, self.root.scrollview_export.Image_export.FileNode5_export)
    self.FileNode6 = self.root.scrollview_export.Image_export.FileNode6_export
    self.FileNode6 = UITurntableFullItem.new()
    uiMgr:configNestClass(self.FileNode6, self.root.scrollview_export.Image_export.FileNode6_export)
    self.FileNode7 = self.root.scrollview_export.Image_export.FileNode7_export
    self.FileNode7 = UITurntableFullItem.new()
    uiMgr:configNestClass(self.FileNode7, self.root.scrollview_export.Image_export.FileNode7_export)
    self.FileNode8 = self.root.scrollview_export.Image_export.FileNode8_export
    self.FileNode8 = UITurntableFullItem.new()
    uiMgr:configNestClass(self.FileNode8, self.root.scrollview_export.Image_export.FileNode8_export)
    self.FileNode9 = self.root.scrollview_export.Image_export.FileNode9_export
    self.FileNode9 = UITurntableFullItem.new()
    uiMgr:configNestClass(self.FileNode9, self.root.scrollview_export.Image_export.FileNode9_export)
    self.FileNode10 = self.root.scrollview_export.Image_export.FileNode10_export
    self.FileNode10 = UITurntableFullItem.new()
    uiMgr:configNestClass(self.FileNode10, self.root.scrollview_export.Image_export.FileNode10_export)
    self.buy_gift = self.root.scrollview_export.buy_gift_export
    self.grayBg = self.root.scrollview_export.buy_gift_export.grayBg_export
    self.gift_price_text = self.root.scrollview_export.buy_gift_export.gift_price_text_export
    self.zeroTime = self.root.scrollview_export.zeroTime_export
    self.reset = self.root.scrollview_export.reset_mlan_15_export
    self.tips = self.root.scrollview_export.tips_export
    self.times = self.root.scrollview_export.day_times_mlan_8.times_export
    self.title = self.root.title_export
    self.mojing = self.root.mojing_export

    uiMgr:addWidgetTouchHandler(self.buy_gift, function(sender, eventType) self:onPay(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    local defY = self.scrollview:getContentSize().height
    self.scrollview:setContentSize(cc.size(720,gdisplay.height - 80))
    if (gdisplay.height - 80) <= defY then
        self.scrollview:setInnerContainerSize(cc.size(720, defY))
    else
        self.scrollview:setInnerContainerSize(cc.size(720,gdisplay.height - 80))
        local tt = gdisplay.height - 80 - defY
        for _ ,v in pairs(self.scrollview:getChildren()) do 
            v:setPositionY(v:getPositionY()+tt)
        end 
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

    global.tools:adjustNodeMiddle(self.zeroTime ,self.reset)
end

function UITurntableFullPanel:onEnter()

    self.ResSetControl:setRmbDelay(0)
    self.ResSetControl:setData()

    self.isDoing = false
    self.m_finalData = nil

    self:setData()
end

function UITurntableFullPanel:setData()
    -- self.Image
    local data = global.luaCfg:turntable_pay_reward()
    self.m_items = clone(data)
    self:resetRewards()

    local data = global.luaCfg:get_gift_by(58)
    self.gift_price_text:setString(data.unit..data.cost)

    local sData = global.userData:getDayTurntableTimes(1)
    local limitMax = global.luaCfg:get_gift_by(58).limit_time
    if sData and sData.lCount >= limitMax then
        self.times:setString(0)
        self:setTouchUse(false)
    else
        self:setTouchUse(true)
        local count = 0
        if sData and sData.lCount then
            count = sData.lCount
        end 
        self.times:setString(limitMax-count)
    end

    self.countdown_func = function(dt)
        local lEndTime = global.dailyTaskData:getNextFlushTime()
        local restTime  = lEndTime - global.dataMgr:getServerTime()
        if restTime <= 0 then 
            restTime = 0

            global.userData:resetTurntableTimes(1)
            if not self.isDoing then
                self:setTouchUse(true)
            end

            if self.countdown_func then
                self:unschedule(self.countdown_func)
            end
        end
        self.zeroTime:setString(global.funcGame.formatTimeToHMS(restTime))
    end
    if self.countdown_func then
        self:unschedule(self.countdown_func)
    end
    self.countdown_func()
    self:schedule(self.countdown_func, 1, -1)
end

function UITurntableFullPanel:resetRewards()
    -- self.Image

    self.Image:setRotation(0)
    self.m_angle = 0
    for i=1,10 do
        self["FileNode"..i]:setData(self.m_items[i])
        self["FileNode"..i]:setTestStr(i)
        self["FileNode"..i]:setRotation(-self.m_angle)
    end

end

local lastIdx = 0
function UITurntableFullPanel:updateItemRotation(list,islock)
    -- self.Image
    for i=1,10 do
        self["FileNode"..i]:setRotation(-self.m_angle)
    end
end

function UITurntableFullPanel:idxToAngle(nowAngle,selectItemId)
    print("nowAngle="..nowAngle)
    local nowAngle = math.ceil(nowAngle)
    local nowIdx = math.floor((nowAngle%360+18)/36)+1
    if nowIdx > 10 then
        nowIdx = 1
    end

    local dstIdx = 0
    print(selectItemId)
    table.walk(self.m_items,function(v,k)
        -- body
        if v.itemID == selectItemId then
            dstIdx = k
        end
    end)

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
    if (dstIdx-nowIdx) <= 0 then
        dstAngle = dstAngle+360
    else
        -- dstAngle = dstAngle+360
    end
    print("222dstAngle="..dstAngle)
    return dstAngle,dstIdx
end

-- 1+2+1 initv = 360
function UITurntableFullPanel:rotate(list,selectItemId)
    local a = 400+math.random(50) --起步加速度
    local a1 = 0    --匀速
    local a2 = -200 --减速
    local a3 = -4  --匀速
    local t1 = 1  --起步时间 t1-0 = 1
    local t2 = 3  --匀速时间 t2-t1 = 1
    local t3 = 7  --减速时间t3-t2 = 3
    local dstv = 50 --最终匀速选择速度

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

    self.root.m_csbName = "turntable/turntable_pay"
    self.root.m_actionStr = "animation0"
    -- (node,isloop,isRemoveSelf,frameListener,lastCallback)
    local initAngle = self.m_angle or 0 
    global.resMgr:addCsbTimeLine(self.root,true,nil,nil)
    self.func = function(dt)
        -- body
        dut = dut + interval
        if dut < t1  then
            -- 加速
            dstAngle = initAngle+v0*dut+1/2*a*dut*dut
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

                self.root.m_csbName = "turntable/turntable_pay"
                self.root.m_actionStr = "animation1"
                -- (node,isloop,isRemoveSelf,frameListener,lastCallback)
                global.resMgr:addCsbTimeLine(self.root,nil,nil,nil)
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
                self.m_angle = fianlAngle
                if self.func then
                    self:unschedule(self.func)
                end
                self:rotateOverRecordInfo(selectedIdx)
            else
                self.Image:setRotation(dstAngle3)
            end
        end
        print(dut)
        self:updateItemRotation(list,islock)
    end
    if self.func then
        self:unschedule(self.func)
    end
    self:schedule(self.func, interval, -1)
end

function UITurntableFullPanel:getItemId(selectedIdx)
    if selectedIdx<1 then
        selectedIdx = 10-selectedIdx
    end
    if selectedIdx>10 then
        selectedIdx = selectedIdx-10
    end
    return self["FileNode"..selectedIdx]:getItemId()
end

function UITurntableFullPanel:rotateOverRecordInfo(selectedIdx)
    print(selectedIdx)
    if not selectedIdx or selectedIdx<1 or selectedIdx>10 then
        return
    end

    -- self:setTouchUse(true)

    self.root.m_csbName = "turntable/turntable_pay"
    self.root.m_actionStr = "animation2"
    -- (node,isloop,isRemoveSelf,frameListener,lastCallback)
    global.resMgr:addCsbTimeLine(self.root,nil,nil,nil)

    global.panelMgr:openPanel("UITurntableRewardPanel"):setData(self:getItemId(selectedIdx))
    self.m_finalData = nil
end


function UITurntableFullPanel:exit_call(sender, eventType)
    if self.m_finalData then
        global.panelMgr:openPanel("UITurntableRewardPanel"):setData(self.m_finalData)
    end
    global.panelMgr:closePanelForBtn("UITurntableFullPanel")
    global.panelMgr:destroyPanel("UITurntableFullPanel")

end


function UITurntableFullPanel:test()
    self.m_finalData = 11401
    self:rotate(self.m_items,11401)
end

function UITurntableFullPanel:setTouchUse(can)
    global.colorUtils.turnGray(self.grayBg,not can)
    self.buy_gift:setTouchEnabled(can)
    self.zeroTime:setVisible(true)
    self.reset:setVisible(true)
    global.tools:adjustNodePos(self.reset, self.zeroTime)
end

local UILongTipsControl = require("game.UI.common.UILongTipsControl")
function UITurntableFullPanel:showTips(icon,itemId)
    if not icon.m_TipsControl then
        icon.m_TipsControl = UILongTipsControl.new(icon,WCONST.LONG_TIPS_PANEL.ITEM_DESC)
    end
    icon.m_TipsControl:setData({information=global.luaCfg:get_local_item_by(itemId)})

    return m_TipsControl
end

function UITurntableFullPanel:idxToFinalId(idx)
    local data = global.luaCfg:get_turntable_pay_reward_by(idx)
    return data
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UITurntableFullPanel:onPay(sender, eventType)

    local call = function()
        -- body
        global.ActivityAPI:getSpinLottery(function(ret,msg)
            -- body
            if ret.retcode == WCODE.OK then

                self.isDoing = true
                -- global.userData:addDayTurntableTimes(1)
                dump(msg)
                if not msg.lWin then return end
                if self.idxToFinalId then 
                    self.m_finalData = self:idxToFinalId(msg.lWin[1])
                    local selectItemId = self.m_finalData.itemID
                    self:rotate(self.m_items,selectItemId)
                end 

                if self.setData then 
                    self:setData()
                end 
            end
        end,1)
    end
   
    global.sdkBridge:app_sdk_pay(58,function()
        call()
    end)
     

end
--CALLBACKS_FUNCS_END

return UITurntableFullPanel

--endregion
