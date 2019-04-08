--region UIScienceDItem.lua
--Author : yyt
--Date   : 2017/02/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIScienceDItem  = class("UIScienceDItem", function() return gdisplay.newWidget() end )

function UIScienceDItem:ctor()
    self:CreateUI()
end

function UIScienceDItem:CreateUI()
    local root = resMgr:createWidget("science/science_details_node")
    self:initUI(root)
end

function UIScienceDItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "science/science_details_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.line1 = self.root.Node_Line.Node_L.line1_export
    self.line2 = self.root.Node_Line.Node_L.line2_export
    self.line3 = self.root.Node_Line.Node_L.line3_export
    self.line4 = self.root.Node_Line.Node_L.line4_export
    self.line5 = self.root.Node_Line.Node_R.line5_export
    self.line6 = self.root.Node_Line.Node_R.line6_export
    self.line7 = self.root.Node_Line.Node_R.line7_export
    self.line8 = self.root.Node_Line.Node_R.line8_export
    self.Node_M = self.root.Node_Line.Node_M_export
    self.line9 = self.root.Node_Line.Node_M_export.line9_export
    self.Button_1 = self.root.Button_1_export
    self.grayBg = self.root.Button_1_export.grayBg_export
    self.time = self.root.Button_1_export.time_export
    self.des = self.root.Button_1_export.des_export
    self.type = self.root.Button_1_export.type_export
    self.target = self.root.Button_1_export.target_export
    self.targetRich = self.root.Button_1_export.targetRich_export
    self.target_finish = self.root.Button_1_export.target_finish_export
    self.lv = self.root.Button_1_export.lv_export
    self.iconBg = self.root.Button_1_export.iconBg_export
    self.icon = self.root.Button_1_export.icon_export
    self.loading_bg = self.root.Button_1_export.loading_bg_export
    self.LoadingBar = self.root.Button_1_export.loading_bg_export.LoadingBar_export
    self.effect = self.root.Button_1_export.effect_export

    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:onTechHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.Button_1:setSwallowTouches(false)

end

local bg = {
    [1] = "science_info_bg.jpg",
    [2] = "science_info_bg1.jpg",
    [3] = "science_info_bg2.jpg",
}

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIScienceDItem:setData(data)
    
    --dump(data,"科技数据")

    self.data = data

    self.Button_1:setName("Button_1_export"..data.lockState)

    self.type:setString(data.name)
    self.des:setString(data.des)
    -- self.icon:setSpriteFrame(data.icon)
    global.panelMgr:setTextureFor(self.icon,data.icon)
    self.icon:setScale(0.5)

    self.target:setVisible(false)
    self.targetRich:setVisible(false)
    self.target_finish:setVisible(false)
    self.effect:setVisible(false)

    local condit = luaCfg:get_target_condition_by(data.edification)
    local contate = 0
    if data.conditState then
        if data.conditState.lCur >= data.conditState.lMax then
            contate = 1
        end

        if contate == 1 then

            self.target_finish:setVisible(true)
            local proStr = ""
            if condit.objectType == 6 then
                proStr = luaCfg:get_local_string(10447)
            else
                proStr = luaCfg:get_local_string(10410, data.conditState.lMax, data.conditState.lMax)
            end 
            self.target_finish:setString(luaCfg:get_local_string(10407, condit.description) .. " " .. proStr)
        
        else

            if data.lockState == 0 then
                self.target:setVisible(true)

                local proStr = ""
                if condit.objectType ~= 6 then
                    proStr = luaCfg:get_local_string(10410, data.conditState.lCur, data.conditState.lMax)
                else
                    proStr = luaCfg:get_local_string(10444)
                end
                self.target:setString(proStr ..  luaCfg:get_local_string(10406, condit.description))

            else

                if condit.objectType == 6 then
                    self.targetRich:setVisible(true)
                    uiMgr:setRichText(self, "targetRich", 50041 , {target = condit.description})
                else
                    self.target:setVisible(true)
                    local pror = luaCfg:get_local_string(10410, data.conditState.lCur, data.conditState.lMax)
                    self.target:setString(pror .. luaCfg:get_local_string(10406, condit.description))
                end
            end
            
        end
    end

    local picBg = ""
    if data.lGrade < data.maxLv then
        self.lv:setString(luaCfg:get_local_string(10410, data.lGrade, data.maxLv))
        if data.branch == 0 then
            picBg = bg[1]
        else
            picBg = bg[2]
        end
    else
        self.lv:setString("(Max)")
        picBg = bg[3]
    end
    self.LoadingBar:setPercent(data.lGrade/data.maxLv*100)
    self.Button_1:loadTextures(picBg,picBg,picBg,ccui.TextureResType.plistType)
    if data.lockState == 0 then
        self.grayBg:loadTexture(bg[2],ccui.TextureResType.plistType)
    else
        self.grayBg:loadTexture(picBg,ccui.TextureResType.plistType)
    end

    if data.branch == 0 then
        self.iconBg:setSpriteFrame("science_icon_bg.jpg")    
    else
        self.iconBg:setSpriteFrame("science_icon_bg1.jpg")
    end 

    if global.techData:isTeching(self.data.id) then

        self.time:setVisible(true)
        self.curQueue = global.techData:getQueueById(self.data.id)
        self.m_totalTime = self.curQueue.lTotleTime
        if self.m_countDownTimer then
        else
            self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
        end
        self:countDownHandler()

        if self.m_restTime > 0 then

            self.effect:setVisible(true)
            self.root:stopAllActions()
            local timeLine = resMgr:createTimeline("science/science_details_node")
            timeLine:play("animation0", true)
            self.root:runAction(timeLine)
        end

    else
        self.time:setVisible(false)
    end 
    
    self:adjustLine(data)    

    global.colorUtils.turnGray(self.Button_1, data.lockState == 0)

end

function UIScienceDItem:countDownHandler(dt)

    if not self.curQueue then return end
    local curServerTime = global.dataMgr:getServerTime()
    if self.curQueue.lRestTime <= 0 then
        self.m_restTime = self.curQueue.lRestTime
    else
        local lStartTime = self.curQueue.lStartTime or 0 
        self.m_restTime = self.curQueue.lRestTime - (curServerTime-lStartTime)
    end
    
    if self.m_restTime <= 0 then
        
        self:techOver()
        return
    end
    self.time:setString(global.funcGame.formatTimeToHMS(self.m_restTime))
end

function UIScienceDItem:techOver()

    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
    self.time:setVisible(false)
end

function UIScienceDItem:onExit()
    -- body
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

function UIScienceDItem:adjustLine()

    local pos = {320, 400}

    if self.data.branch == 0 then
        
        self.Node_M:setPositionX(-80)
        self.Button_1:setPositionX(pos[1])
    else
        self.Node_M:setPositionX(0)
        self.Button_1:setPositionX(pos[2])
    end

    for i=1,9 do

        self["line"..i]:setVisible(false)
        for j=1,#self.data.line do
            
            local lineV = self.data.line[j]
            local v = self.data.line[j]
            if v > 10 then v = v-10 end 
            if v == i then

                self["line"..v]:setVisible(true)
                self["line"..v].press:setVisible(lineV > 9)
                if lineV > 9  then
                    if self.data.effectFlag then 
                        if self.data.effectFlag[j] == 1 then
                            self["line"..v].press:setOpacity(255)
                        else
                            self["line"..v].press:setOpacity(0)
                            self["line"..v].press:runAction(cc.Sequence:create( cc.FadeIn:create(0.5), cc.FadeOut:create(0.2),cc.FadeIn:create(0.4) ))
                        end
                        self.data.effectFlag[j] = 1
                    end       
                end
            end
        end
    end
    
end

function UIScienceDItem:onTechHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIScienceDPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isStartMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isStartMove then 
            return
        end

        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_scienceclick")

        -- 是否满级
        if self.data.lGrade >= self.data.maxLv then
            global.panelMgr:openPanel("UITechMaxLvPanel"):setData(self.data)
        else

            if global.techData:isTeching(self.data.id) then
                global.panelMgr:openPanel("UITechNowPanel"):setData(self.data)
            else
                global.panelMgr:openPanel("UITechInfoPanel"):setData(self.data)
            end 
        end
    end

end
--CALLBACKS_FUNCS_END

return UIScienceDItem

--endregion
