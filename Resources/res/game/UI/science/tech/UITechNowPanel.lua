--region UITechNowPanel.lua
--Author : yyt
--Date   : 2017/03/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local funcGame = global.funcGame
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITechNowPanel  = class("UITechNowPanel", function() return gdisplay.newWidget() end )

function UITechNowPanel:ctor()
    self:CreateUI()
end

function UITechNowPanel:CreateUI()
    local root = resMgr:createWidget("science/tech_now_info_bg")
    self:initUI(root)
end

function UITechNowPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "science/tech_now_info_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.science_name = self.root.Node_export.Image_14.science_name_export
    self.icon = self.root.Node_export.Image_14.icon_export
    self.res_icon = self.root.Node_export.Image_14.res_icon_export
    self.lv = self.root.Node_export.Image_14.lv_export
    self.des = self.root.Node_export.Image_14.des_export
    self.now_num = self.root.Node_export.Image_14.nowlv_mlan_6.now_num_export
    self.next_num = self.root.Node_export.Image_14.nextlv_mlan_6.next_num_export
    self.targetFinish = self.root.Node_export.Image_14.targetFinish_export
    self.targetStr = self.root.Node_export.Image_14.targetFinish_export.targetStr_export
    self.target_finish = self.root.Node_export.Image_14.targetFinish_export.target_finish_export
    self.awaken_target = self.root.Node_export.Image_14.awaken_target_export
    self.loadingbar_bg = self.root.Node_export.Image_14.loadingbar_bg_export
    self.LoadingBar = self.root.Node_export.Image_14.loadingbar_bg_export.LoadingBar_export
    self.time = self.root.Node_export.Image_14.loadingbar_bg_export.time_export
    self.btn_speed = self.root.Node_export.Image_14.btn_speed_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_speed, function(sender, eventType) self:onSpeedHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UITechNowPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_UI_TECH_FLUSH, function()

        local curQueue = global.techData:getTechById(self.data.id)
        if curQueue  then
            self:setData(curQueue) 
        end
    end)
    
end

function UITechNowPanel:setCondition(data)
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
        self.awaken_target:setVisible(false)
        local finishStr = luaCfg:get_local_string(10407, "") .. luaCfg:get_local_string(10476)
        self.target_finish:setString(finishStr)
        self.targetStr:setString(luaCfg:get_local_string(10641, data.edificationEffect))
    else   
        self.targetFinish:setVisible(false) 
        self.awaken_target:setVisible(true)
        uiMgr:setRichText(self, "awaken_target", 50042 , {target = condit.description, num=data.edificationEffect})
    end
end

function UITechNowPanel:setData(data)
    
    if not data then return  end 

    self.data = data
    self.des:setString(data.des)
    -- self.res_icon:setSpriteFrame(data.icon)
    global.panelMgr:setTextureFor(self.res_icon,data.icon)
    self.science_name:setString(data.name)

    if data.conditState then
        self:setCondition(data)
    else
        self.targetFinish:setVisible(false) 
        global.techApi:conditSucc({data.edification}, function (msg)
            if msg.tgInfo and msg.tgInfo[1] and self.data then
                self.data.conditState = msg.tgInfo[1]
                self:setCondition(self.data)
            end
        end)
    end

    self:setBuffParm()

    self.curQueue = global.techData:getQueueById(data.id) 
    if self.curQueue then
        
        self.m_totalTime = self.curQueue.lTotleTime 
        if self.m_countDownTimer then
        else
            self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
        end
        self:countDownHandler()

    else
        self.m_restTime = 0  -- 加速面板使用
        self:exitCall()
    end 
    
end

function UITechNowPanel:countDownHandler(dt)

    if not self.curQueue then return end
    self.curQueue.lRestTime = self.curQueue.lRestTime or 0
    

    local curServerTime = global.dataMgr:getServerTime()
    if self.curQueue.lRestTime <= 0 then
        self.m_restTime = math.floor(self.curQueue.lRestTime)
    else
        self.curQueue.lStartTime = self.curQueue.lStartTime or 0
        self.m_restTime = math.floor(self.curQueue.lRestTime - (curServerTime-self.curQueue.lStartTime))
    end
 
    if self.m_restTime <= 0 then
        self:techOver()
        return
    end
    
    self.LoadingBar:setPercent((1-self.m_restTime / self.m_totalTime)*100)
    self.time:setString(funcGame.formatTimeToHMS(self.m_restTime))
end

function UITechNowPanel:techOver()

    self.LoadingBar:setPercent(100)
    self.time:setString("00:00:00")

    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
    self:exitCall()
end

function UITechNowPanel:onExit( )
    -- body
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

function UITechNowPanel:setBuffParm()
    
    local lvData = luaCfg:science_lvup()
    for _,v in pairs(lvData) do
        if v.id == self.data.id then

            local buffData = luaCfg:get_data_type_by(v.buff)
            if v.lv == self.data.lGrade then
                self.now_num:setString("+"..v.buffNum..buffData.extra)
            elseif v.lv == (self.data.lGrade+1) then
                self.next_num:setString("+"..v.buffNum..buffData.extra)
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



function UITechNowPanel:exitCall(sender, eventType)
    global.panelMgr:closePanel("UITechNowPanel")
end

function UITechNowPanel:onSpeedHandler(sender, eventType)
    
    local function leftTimeAndTotalTime(data)

        if data then
            --使用道具消除训练cd回调方法
            global.techData:referQueue(data)
            if self.curQueue then 
                self.curQueue.lRestTime = data.lRestTime or 0
                self.curQueue.lStartTime = data.lSysTime or 0
            end 
            if self.m_restTime then 
                self.m_restTime = data.lRestTime or 0
            end 
        end
        return self.m_restTime, self.m_totalTime
    end

    local panel = global.panelMgr:openPanel("UISpeedPanel")   -- 科技加速

    if self.curQueue and self.curQueue.lID then 
        panel:setData(leftTimeAndTotalTime, self.curQueue.lID, panel.TYPE_TECH_SPEED)
    end 

end
--CALLBACKS_FUNCS_END

return UITechNowPanel

--endregion
