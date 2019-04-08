--region UIPersuadePanel.lua
--Author : untory
--Date   : 2017/02/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local luaCfg = global.luaCfg
local uiMgr = global.uiMgr
local gameEvent = global.gameEvent
local funcGame = global.funcGame
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPersuadePanel  = class("UIPersuadePanel", function() return gdisplay.newWidget() end )

function UIPersuadePanel:ctor()
    self:CreateUI()
end

function UIPersuadePanel:CreateUI()
    local root = resMgr:createWidget("hero/hero_persuade_bg")
    self:initUI(root)
end

function UIPersuadePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_persuade_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.txt_Title = self.root.Node_export.txt_Title_export
    self.rest_time = self.root.Node_export.rest_time_export
    self.time = self.root.Node_export.time_mlan_export
    self.idle_desc = self.root.Node_export.idle_desc_mlan_export
    self.s1h = self.root.Node_export.Node_2.s1h_export
    self.s3h = self.root.Node_export.Node_3.s3h_export
    self.s8h = self.root.Node_export.Node_4.s8h_export
    self.item = self.root.Node_export.Node_5.item_export
    self.loadingbar_bg = self.root.Node_export.loadingbar_bg_export
    self.LoadingBar = self.root.Node_export.loadingbar_bg_export.LoadingBar_export
    self.now_num = self.root.Node_export.loadingbar_bg_export.now_num_export
    self.total_num = self.root.Node_export.loadingbar_bg_export.total_num_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.s1h, function(sender, eventType) self:action1(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.s3h, function(sender, eventType) self:action2(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.s8h, function(sender, eventType) self:action3(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.item, function(sender, eventType) self:gift(sender, eventType) end)
--EXPORT_NODE_END
    


    --润稿问题 张亮
    self.s1h_mlan = self.root.Node_export.Node_2.s1h_mlan
    self.s1h1 = self.root.Node_export.Node_2.s1h1
    self.s1h2_mlan = self.root.Node_export.Node_2.s1h2_mlan

    self.s3h_mlan = self.root.Node_export.Node_3.s3h_mlan
    self.s3h1 = self.root.Node_export.Node_3.s3h1
    self.s3h2_mlan = self.root.Node_export.Node_3.s3h2_mlan

    self.s8h_mlan = self.root.Node_export.Node_4.s8h_mlan
    self.s8h1 = self.root.Node_export.Node_4.s8h1
    self.s8h2_mlan = self.root.Node_export.Node_4.s8h2_mlan

    -- global.tools:adjustNodePos(self.s1h_mlan,self.s1h1)
    -- global.tools:adjustNodePos(self.s1h1,self.s1h2_mlan)

    -- global.tools:adjustNodePos(self.s3h_mlan,self.s3h1)
    -- global.tools:adjustNodePos(self.s3h1,self.s3h2_mlan)

    -- global.tools:adjustNodePos(self.s8h_mlan,self.s8h1)
    -- global.tools:adjustNodePos(self.s8h1,self.s8h2_mlan)

end

function UIPersuadePanel:onEnter()

    self:addEventListener(gameEvent.EV_ON_UI_HERO_FLUSH,function()
        self:setData(self.data,0.5)
    end)
end

function UIPersuadePanel:onExit()
    
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

function UIPersuadePanel:setData(data,time)

    self.data = data
    time = time or 0

    if self.data.state ~= 2 then
    
        global.panelMgr:closePanelForBtn("UIPersuadePanel")
        global.panelMgr:closePanelForBtn("UISpeedPanel")
        return
    end

    self:startCountDown()

    local impressData = luaCfg:get_hero_impression_by(self.data.heroId)
    self.maxImpress = impressData.impression
    self.total_num:setString(self.maxImpress)
    
    if data.impress > self.maxImpress then

        self.now_num:setString(self.maxImpress)
    else

        self.now_num:setString(data.impress)
    end
    
    self.LoadingBar:stopAllActions()
    self.LoadingBar:runAction(cc.ProgressFromTo:create(time,self.LoadingBar:getPercent(),(data.impress / self.maxImpress * 100)))
    -- self.LoadingBar:setPercent( )


   
end

function UIPersuadePanel:startCountDown()
    
    self.rest_time:setVisible(true)
    self.time:setVisible(true)
    self.idle_desc:setVisible(false)

    local contentTime = global.dataMgr:getServerTime() 
    local persuadeTime = global.heroData:getPersuadeTime()
    if persuadeTime == 0 then persuadeTime = contentTime end

    self.m_restTime = persuadeTime - contentTime    

    self:cutTimeHandler()
    if self.m_countDownTimer then
    else
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.cutTimeHandler), 1)
    end
end

function UIPersuadePanel:cutTimeHandler()

    self.m_restTime = self.m_restTime - 1
    local str = funcGame.formatTimeToHMS(self.m_restTime)    
    self.rest_time:setString(str)

    if self.m_restTime < 0 then
        if self.m_countDownTimer then
            gscheduler.unscheduleGlobal(self.m_countDownTimer)
            self.m_countDownTimer = nil
        end
        self.restTime = 0

        self.rest_time:setVisible(false)
        self.time:setVisible(false)
        self.idle_desc:setVisible(true)
        -- self:startCountDown()
        -- return


    end

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIPersuadePanel:exit_click(sender, eventType)

    global.panelMgr:closePanelForBtn("UIPersuadePanel")
end

function UIPersuadePanel:doAction(actionType)
    
    if self.m_restTime > 0 then

        global.tipsMgr:showWarning("HeroPersuading")
    else

        local actionCall = function()
            global.commonApi:heroAction(self.data.heroId, 2, actionType, 0, 0, function(msg)
        
                local preImpress = self.data.serverData.lImpress

                global.heroData:updateVipHero(msg.tgHero[1])

                local addImpress = msg.tgHero[1].lImpress - preImpress

                if msg.tgHero[1].lState == 0 then --0表示成功

                    global.panelMgr:openPanel("UIGotHeroPanel"):setData(self.data)
                    -- local csb = resMgr:createCsbAction("effect/talk_hero", "animation0", false, true)
                    -- uiMgr:configUITree(csb)
                    -- csb.hero.hero_pick:setSpriteFrame(self.data.nameIcon)
                    -- csb.hero.Text_47:setString(string.format(luaCfg:get_errorcode_by("PersuadeSuccess").text, self.data.name))
                    -- csb:setLocalZOrder(31)
                    -- csb:setPosition(cc.p(gdisplay.width / 2,gdisplay.height / 2))
                    -- global.scMgr:CurScene():addChild(csb)
                    -- global.tipsMgr:showWarningText(string.format(luaCfg:get_errorcode_by("PersuadeSuccess").text, self.data.name))
                else

                    if global.heroData:isFull() then
                        global.tipsMgr:showWarning("HeroPersuadeLimit")
                    else
                        global.tipsMgr:showWarning("PersuadeFailed",self.data.name,addImpress)                        
                    end                    
                end
            end)
        end

        if global.heroData:isFull() then

            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("HeroMaxConfirm", actionCall)
        else

            actionCall()
        end        
    end    
end

function UIPersuadePanel:action1(sender, eventType)
    
    self:doAction(1)
end

function UIPersuadePanel:action2(sender, eventType)

    self:doAction(2)
end

function UIPersuadePanel:action3(sender, eventType)

    self:doAction(3)
end

function UIPersuadePanel:gift(sender, eventType)

    local actionCall = function()
        
        local panel = global.panelMgr:openPanel("UISpeedPanel")
        panel:setData(nil, 0, panel.TYPE_HERO_GIFT, self.data.heroId)
    end

    if global.heroData:isFull() then

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData("HeroMaxConfirm", actionCall)
    else

        actionCall()
    end            
end
--CALLBACKS_FUNCS_END

return UIPersuadePanel

--endregion
