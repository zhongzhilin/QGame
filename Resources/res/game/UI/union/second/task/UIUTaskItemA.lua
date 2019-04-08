--region UIUTaskItemA.lua
--Author : wuwx
--Date   : 2017/02/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUTaskItemA  = class("UIUTaskItemA", function() return gdisplay.newWidget() end )

function UIUTaskItemA:ctor()
    self:CreateUI()
end

function UIUTaskItemA:CreateUI()
    local root = resMgr:createWidget("union/union_task_list_boss")
    self:initUI(root)
end

function UIUTaskItemA:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_task_list_boss")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Button_1 = self.root.Button_1_export
    self.icon = self.root.Button_1_export.icon.icon_export
    self.text1 = self.root.Button_1_export.text.text1_export
    self.text2 = self.root.Button_1_export.text.text2_mlan_3_export
    self.text3 = self.root.Button_1_export.text.text3_mlan_4_export
    self.text4 = self.root.Button_1_export.text.text4_mlan_4_export
    self.text5 = self.root.Button_1_export.text.text5_export
    self.text6 = self.root.Button_1_export.text.text6_export
    self.text7 = self.root.Button_1_export.text.text7_mlan_5_export
    self.text8 = self.root.Button_1_export.text.text8_export
    self.task_btn = self.root.Button_1_export.task_btn_export
    self.btn_word = self.root.Button_1_export.task_btn_export.btn_word_export
    self.go_target = self.root.Button_1_export.go_target_export
    self.node_killed = self.root.Button_1_export.node_killed_export
    self.result_text = self.root.Button_1_export.node_killed_export.result_text_mlan_3_export

    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:taskRewardHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.task_btn, function(sender, eventType) self:onGet(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.go_target, function(sender, eventType) self:onGoTarget(sender, eventType) end)
--EXPORT_NODE_END
    self.Button_1:setSwallowTouches(false)
    self.Button_1:setZoomScale(WCONST.BUTTON_SCALE.SMALL)

end

local state = {
    NO = -2,--不满足条件
    LOCK = -1,--待开启
    DOING = 0,--已经开启
    GET = 1,--可领取
    GOT = 2,--已击杀
    FAIL = 3,--挑战失败
}
local unionBuildData = global.luaCfg:get_union_build_by(2)
function UIUTaskItemA:setData(data)

    self.data = data
    local itemData = global.luaCfg:get_union_task_by(data.sData.lID)
    -- self.icon:setSpriteFrame(itemData.icon)
    global.panelMgr:setTextureFor(self.icon,itemData.icon)
    self.text1:setString(itemData.taskDescription)
    --+个人贡献
    self.text5:setString("+"..itemData.rewardnum)
    self.text6:setString("+"..itemData.rewardboom)

    -- self.go_target:setVisible(itemData.taskType == 3)
    self.text7:setString(global.luaCfg:get_local_string(10389))

    if data.sData.lState == state.FAIL then
        data.sData.lState = state.LOCK
    end

    if (data.sData.lState == state.DOING) then
        self.go_target:setVisible(true)
        self.text8:setVisible(true)
        self.text7:setVisible(true)

        if not self.m_countDownTimer then
            self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
        end
        self:countDownHandler()
    else
        self.go_target:setVisible(false)
        self.text8:setVisible(false)
        self.text7:setVisible(false)
        if self.m_countDownTimer then
            gscheduler.unscheduleGlobal(self.m_countDownTimer)
            self.m_countDownTimer = nil
        end
    end

    if (data.sData.lState == state.FAIL) then
        --挑战失败
        self.node_killed:setVisible(true)
        self.task_btn:setVisible(false)

        self.node_killed:setSpriteFrame("ui_surface_icon/hero_frame_blue.png")
        self.result_text:setTextColor(cc.c3b(36, 108, 198))
        self.result_text:setString(global.luaCfg:get_local_string(10475))
    elseif (data.sData.lState == state.GOT) then
        self.node_killed:setVisible(true)
        self.task_btn:setVisible(false)
        -- 红色
        self.node_killed:setSpriteFrame("ui_surface_icon/hero_frame_red.png")
        self.result_text:setTextColor(cc.c3b(180, 29, 11))
        self.result_text:setString(global.luaCfg:get_local_string(10473))
    else
        if data.sData.lState == state.GET then
            local frame = "ui_button/btn_task_sec_reward.png"
            self.task_btn:loadTextures(frame,frame,frame,ccui.TextureResType.plistType)
            self.task_btn:setVisible(true)
            self.btn_word:setString(global.luaCfg:get_local_string(10013))
        elseif data.sData.lState == state.LOCK then
            local frame = "ui_button/btn_task_sec_equip.png"
            self.task_btn:loadTextures(frame,frame,frame,ccui.TextureResType.plistType)
            self.task_btn:setVisible(true)
            self.btn_word:setString(global.luaCfg:get_local_string(10355))
        elseif data.sData.lState == state.NO then
            self.task_btn:setVisible(false)
            self.text7:setVisible(true)
            self.text7:setString(global.luaCfg:get_local_string(10388,unionBuildData.name,itemData.taskLv))
        else
            self.task_btn:setVisible(false)
        end 
        self.node_killed:setVisible(false)
    end

    --润稿翻译处理 张亮
    global.tools:adjustNodePos(self.text2,self.text3)
    global.tools:adjustNodePos(self.text3,self.text5)

    global.tools:adjustNodePos(self.text4,self.text6)
    global.tools:adjustNodePos(self.text7,self.text8)

end

function UIUTaskItemA:countDownHandler()
    
    if not self.data then return end
    local curr = global.dataMgr:getServerTime()
    local rest = self.data.sData.boss.lTime-curr
    if rest < 0 then 
        -- gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_TASK)
        rest = 0
    end
    self.text8:setString(global.funcGame.formatTimeToHMS(rest))
end

function UIUTaskItemA:onExit()
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUTaskItemA:onGet(sender, eventType)
    if self.data.sData.lState == state.GET then
        --领取任务奖励
        global.unionApi:getAllyTaskBonus(function(msg)
            -- body

            local insertCall = function (srcData, decData)
                for _,v in pairs(decData) do
                    table.insert(srcData, v)
                end
            end
            local itemData = global.luaCfg:get_union_task_by(self.data.sData.lID)
            local getData = {}
            local reward1 = global.luaCfg:get_drop_by(itemData.boss_item)
            local reward2 = global.luaCfg:get_drop_by(itemData.reward_item)
            -- 自己是否是盟主
            table.insert(getData, {7, itemData.rewardnum})
            table.insert(getData, {8, itemData.rewardboom})
            if global.unionData:isLeader() then
                insertCall(getData, reward1.dropItem)
                insertCall(getData, reward2.dropItem)
            else
                insertCall(getData, reward2.dropItem)
            end
            global.panelMgr:openPanel("UIItemRewardPanel"):setData(getData)
            gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_TASK)

        end,self.data.sData.lID)
    elseif self.data.sData.lState == state.LOCK then
        if not global.unionData:isHadPower(8) then
            return global.tipsMgr:showWarning("unionPowerNot")
        end

        --开启任务
        local openCall = function ()
            -- body
            global.unionApi:openAllyTask(function(msg)
                -- body
                global.tipsMgr:showWarning("Uniontask02")
                local shareCall = function()
                    -- 分享到联盟
                    if not self.data or not self.data.sData then return end
                    if not self.data.sData.boss then return end

                    local WorldViewConst = require("game.UI.world.utils.WorldConst")
                    local posXY = WorldViewConst:converPix2Location(cc.p(self.data.sData.boss.lPosX, self.data.sData.boss.lPosY))
                    local x = math.round(posXY.x)
                    local y = math.round(posXY.y)

                    local lWildKind = 2
                    local itemData = global.luaCfg:get_union_task_by(self.data.sData.lID)

                    local tagSpl = {}
                    tagSpl.lKey = 3
                    tagSpl.lValue = 0
                    tagSpl.szParam = ""--vardump(self.data)
                    local sendData = {name = itemData.taskName,posX = x,posY = y,cityId = self.data.sData.boss.lID,wildKind = lWildKind}    
                    tagSpl.szInfo = vardump(sendData,"test")--global.mailData:getCurMailTitleStr()
                    tagSpl.lTime = 0

                    local panel = global.panelMgr:openPanel("UISharePanel")
                    panel:setData(tagSpl)
                    panel:unionShareHandler()
                end
                gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_TASK, shareCall)

            end,self.data.sData.lID)
        end

        local sPanel = global.panelMgr:getPanel("UIUTaskPanel")
        if sPanel:isHaveKillBoss() then
            openCall()
        else
            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("Uniontask08", function()
                openCall()
            end,self.text1:getString())
        end
    end
end

function UIUTaskItemA:onGoTarget(sender, eventType)
    if (self.data.sData.lState == state.DOING) and self.data.sData.boss and self.data.sData.boss.lID then
        global.funcGame:gpsWorldCity(self.data.sData.boss.lID,2)
    end
end

function UIUTaskItemA:taskRewardHandler(sender, eventType)
    
    local sPanel = global.panelMgr:getPanel("UIUTaskPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isPageMove then 
            return
        end

        global.panelMgr:openPanel("UIUTaskRewardPanel"):setData(self.data)

    end

end
--CALLBACKS_FUNCS_END

return UIUTaskItemA

--endregion
