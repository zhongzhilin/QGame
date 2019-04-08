--region UISalaryPanel.lua
--Author : yyt
--Date   : 2017/02/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local tipsMgr = global.tipsMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UISalaryItem = require("game.UI.salary.UISalaryItem")
local UISalaryEffect = require("game.UI.salary.UISalaryEffect")
--REQUIRE_CLASS_END

local UISalaryPanel  = class("UISalaryPanel", function() return gdisplay.newWidget() end )

function UISalaryPanel:ctor()
    self:CreateUI()
end

function UISalaryPanel:CreateUI()
    local root = resMgr:createWidget("salary/salary_bg")
    self:initUI(root)
end

function UISalaryPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "salary/salary_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.res = self.root.res_export
    self.Button_1 = self.root.Button_1_export
    self.res1_bg = self.root.Button_1_export.res1_bg_export
    self.FileNode_1 = self.root.Button_1_export.FileNode_1_export
    self.FileNode_1 = UISalaryItem.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Button_1_export.FileNode_1_export)
    self.Button_3 = self.root.Button_3_export
    self.res3_bg = self.root.Button_3_export.res3_bg_export
    self.FileNode_3 = self.root.Button_3_export.FileNode_3_export
    self.FileNode_3 = UISalaryItem.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.Button_3_export.FileNode_3_export)
    self.Button_2 = self.root.Button_2_export
    self.res2_bg = self.root.Button_2_export.res2_bg_export
    self.FileNode_2 = self.root.Button_2_export.FileNode_2_export
    self.FileNode_2 = UISalaryItem.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.Button_2_export.FileNode_2_export)
    self.Button_4 = self.root.Button_4_export
    self.res4_bg = self.root.Button_4_export.res4_bg_export
    self.FileNode_4 = self.root.Button_4_export.FileNode_4_export
    self.FileNode_4 = UISalaryItem.new()
    uiMgr:configNestClass(self.FileNode_4, self.root.Button_4_export.FileNode_4_export)
    self.effectNode = self.root.effectNode_export
    self.fontNode = self.root.fontNode_export
    self.fontNode = UISalaryEffect.new()
    uiMgr:configNestClass(self.fontNode, self.root.fontNode_export)
    self.restNode = self.root.restNode_export
    self.zeroTime = self.root.restNode_export.reset_mlan_9.zeroTime_export
    self.limit_num = self.root.Node_70.limit_num_export
    self.free_num = self.root.Node_70.free_num_export

    uiMgr:addWidgetTouchHandler(self.root.title_export.intro1_btn, function(sender, eventType) self:onHelpRecruitHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:btn1Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_3, function(sender, eventType) self:btn3Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_2, function(sender, eventType) self:btn2Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_4, function(sender, eventType) self:btn4Handler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    local ResSetControl = require("game.UI.commonUI.widget.ResSetControl")
    self.ResSetControl = ResSetControl.new(self.res)

end

local resIcon = {
    [1] = "ui_surface_icon/city_res_food.png",
    [2] = "ui_surface_icon/city_res_coin.png",
    [3] = "ui_surface_icon/city_res_wood.png",
    [4] = "ui_surface_icon/city_res_stone.png",
}

local linePath = {
    
    [1] = "map/foodLine.png",
    [2] = "map/coinLine.png",
    [3] = "map/woodLine.png",
    [4] = "map/stoneLine.png",
}

local resBg = {
    [1] = "salary_res_bg.png",
    [2] = "salary_res_lock_bg.png",
}

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UISalaryPanel:onEnter()

    self.fontNode:setVisible(false)
    self.effectNode:removeAllChildren()
    self.ResSetControl:setData()
    self.ResSetControl:playAnimation(self.res)

    -- 魔晶特效
    local nodeTimeLine = resMgr:createTimeline("salary/salary_bg")
    nodeTimeLine:play("animation0", true)
    self:runAction(nodeTimeLine)

    -- 零点通知
    self:addEventListener(global.gameEvent.EV_ON_REFRESH_SALARY,function ()
        self:setData(self.data or {})
    end)

    -- vip 消息更新
    self:addEventListener(global.gameEvent.EV_ON_UI_USER_UPDATE,function()
        self:reFreshNumber()
    end)
end

function UISalaryPanel:onExit()
    
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

function UISalaryPanel:reFreshNumber()
    self:setData(self.data) 
end 

function UISalaryPanel:setData(data)
    
    self.data = data

    local lFreeTimes, _ = global.refershData:getSalaryFreeCount()
    local cunt_vip_freenumber = global.vipBuffEffectData:getVipLevelEffect(3086).quantity or 0  --
    local vipfreenumber = global.vipBuffEffectData:getVipDiverseFreeNumber("lVipDiamondCount")
    vipfreenumber = cunt_vip_freenumber-vipfreenumber
    if not global.vipBuffEffectData:isVipEffective() then 
        vipfreenumber = 0
    end

    local limitcount  = self:getSalarylimitcount()

    if lFreeTimes + vipfreenumber > 0 and limitcount> 0  then 
        self.limit_num:setVisible(false)
        self.free_num:setVisible(true)
        self.free_num:setString(luaCfg:get_local_string(10368, lFreeTimes+vipfreenumber))
    else
        self.limit_num:setVisible(true)
        self.free_num:setVisible(false)
        if limitcount<=0 then limitcount =0 end 
        global.uiMgr:setRichText(self,"limit_num",50050,{today =limitcount })
    end 
    for i=1,4 do
        self["FileNode_"..i]:setData(i)
        self:checkResState(i)
    end

    -- 倒计时
    self.lEndTime = global.refershData:getSalaryFreshTime()
    if not self.m_countDownTimer then
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
    self:countDownHandler()

end

function UISalaryPanel:countDownHandler(dt)
    if self.lEndTime <= 0 then
        self.zeroTime:setString("00:00:00")
        return
    end
    local curr = global.dataMgr:getServerTime()
    local rest = math.floor(self.lEndTime - curr)
    if rest < 0 then
        global.refershData:requestDailaySalaryState()
        if self.m_countDownTimer then
            gscheduler.unscheduleGlobal(self.m_countDownTimer)
            self.m_countDownTimer = nil
        end
        return
    end
    self.zeroTime:setString(global.funcGame.formatTimeToHMS(rest))
end

function UISalaryPanel:getUseFreeCount() --已使用的次数=  基础免费  + vip免费  即使vip失效 也需要使用过的次数
    local lFreeTimes,diamondcount  = global.refershData:getSalaryFreeCount()
    lFreeTimes = global.refershData:getOriginalFreeNumber()-lFreeTimes
    local  cunt_vip_freenumber= global.vipBuffEffectData:getVipDiverseFreeNumber("lVipDiamondCount")
    return  lFreeTimes + cunt_vip_freenumber
 end 

-- 把炼金从次数改成 使用过的次数 QAQ
function UISalaryPanel:getSalarylimitcount()
    local lFreeTimes,diamondcount  = global.refershData:getSalaryFreeCount()
    local limit = global.luaCfg:config()[1].salary_limit 
    local viplimit= global.vipBuffEffectData:getCurrentVipLevelEffect(3081).quantity or 0 
    limit= limit+ viplimit
    return limit - (diamondcount+self:getUseFreeCount())
end 


function UISalaryPanel:checkResState(resId)
    
    self["Button_"..resId]:setTouchEnabled(true)
    local fileItem = self["FileNode_"..resId]
    if fileItem:getState() == 0 then
        self["res"..resId.."_bg"]:setSpriteFrame(resBg[2])
        self["Button_"..resId]:setTouchEnabled(false)
    else
        self["res"..resId.."_bg"]:setSpriteFrame(resBg[1])
    end

end

function UISalaryPanel:btn1Handler(sender, eventType)

    self:getSalary(1)
end

function UISalaryPanel:btn2Handler(sender, eventType)

    self:getSalary(2)
end

function UISalaryPanel:btn3Handler(sender, eventType)
    
    self:getSalary(3)
end

function UISalaryPanel:btn4Handler(sender, eventType)

    self:getSalary(4)
end


function UISalaryPanel:getSalary(resId)
    if self:getSalarylimitcount() <= 0 then 
         tipsMgr:showWarning("SALARY_LIMIT")
        return 
    end 

    local fileItem = self["FileNode_"..resId]

    if fileItem:getState() == 1 then

        self:getSalaryFunc(resId, fileItem.res_num:getString())

    elseif fileItem:getState() == 2 then

        local num = tonumber(fileItem.diamondNum:getString())
        if not self:checkDiamondEnough(num) then
            global.panelMgr:openPanel("UIRechargePanel")
            return
        else
            self:getSalaryFunc(resId, fileItem.res_num:getString())
        end

    else
        return
    end

end

function UISalaryPanel:getSalaryFunc(resId, resNum)

    
    local dataHandler = function(msg, errcode)
        if msg.tgBuyCount then 
            global.vipBuffEffectData:setVipDiverseFreeNumber("lVipDiamondCount", msg.tgBuyCount.lVipDiamondCount)
            global.refershData:setFreeCount(msg.tgBuyCount.lFreeCount, msg.tgBuyCount.lDiamondCount) 
            msg.tgBuyCount.lCritMultiple = msg.tgBuyCount.lCritMultiple or 0 
            gsound.stopEffect("city_click")
            if tonumber(msg.tgBuyCount.lCritMultiple) > 1 then
                gevent:call(gsound.EV_ON_PLAYSOUND,"build_wages_2")
            else
                gevent:call(gsound.EV_ON_PLAYSOUND,"build_wages_1")
            end
        end

        if self.setData then
            self:setData(self.data)
        end

        if errcode then 
            tipsMgr:showWarning("daysalay01")
        else
            global.uiMgr:addSceneModel(1.2)
            self:playHarvestEffect(resId)
            self:runAction(cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(function ()
                if msg and msg.tgBuyCount then
                    self.fontNode:setVisible(true)
                    self.fontNode:setData(msg.tgBuyCount.lCritMultiple, resNum)    
                end               
            end)))
        end
    end

    global.itemApi:diamondUse(function(msg)
            dataHandler(msg)
    end,10, resId, 0,0,0,"",function (ret,msg)
        if ret.retcode == 50 then
            --资源满了之后的处理
            dataHandler(msg, ret.retcode)
        end
    end)
end

function UISalaryPanel:playHarvestEffect(resId)

    self:runAction(cc.Repeat:create(cc.Sequence:create(cc.CallFunc:create(function()
        
        local sp = cc.Sprite:create()
        sp:setSpriteFrame(resIcon[resId])
        sp:setPosition(self["FileNode_"..resId]:convertToWorldSpace(cc.p(0,0)))
        self.effectNode:addChild(sp)

        local endX, endY = 0, gdisplay.height - 100
        if resId == 1 then endX = 30 else
            endX = (resId - 1) * (gdisplay.height/6 - (resId - 2)*5)
            if resId == 2 then endX = endX + 8 end
        end
        local bezier = {}
        bezier[1] = cc.p(200 - math.random(100),endY + 50 - math.random(100))
        bezier[2] = cc.p(400 - math.random(200),endY + 150 - math.random(300))
        bezier[3] = cc.p(endX, endY)

        sp:runAction(cc.BezierTo:create(0.6,bezier))
        sp:setScale(0)
        sp:runAction(cc.Sequence:create(cc.ScaleTo:create(0.3,1),cc.ScaleTo:create(0.3,0),cc.RemoveSelf:create()))

        local mms = cc.MotionStreak:create(0.5, 0.1, 7, cc.c3b(255,255,255),linePath[resId])
        mms:setFastMode(true)
        self.effectNode:addChild(mms)

        mms:setPosition(sp:getPosition())
        mms:setBlendFunc(cc.blendFunc(gl.ONE , gl.ONE))

        mms:runAction(cc.BezierTo:create(0.6,bezier))
    end),cc.DelayTime:create(0.1)),4))
end

function UISalaryPanel:checkDiamondEnough(num)
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,num) then
        return false
    else
        return true
    end
end

function UISalaryPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UISalaryPanel")  
end

function UISalaryPanel:onHelpRecruitHandler(sender, eventType)

    local data = luaCfg:get_introduction_by(12)
    global.panelMgr:openPanel("UIIntroducePanel"):setData(data)

end
--CALLBACKS_FUNCS_END

return UISalaryPanel

--endregion
