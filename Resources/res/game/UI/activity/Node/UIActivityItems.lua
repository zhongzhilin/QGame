--region UIServerSwitchItem.lua
--Author : anlitop
--Date   : 2017/04/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIAcDateWidget = require("game.UI.activity.Node.UIAcDateWidget")
--REQUIRE_CLASS_END

local UIActivityItems  = class("UIActivityItems", function() return gdisplay.newWidget() end )

function UIActivityItems:ctor()
    self:CreateUI()
end

function UIActivityItems:CreateUI()
    local root = resMgr:createWidget("activity/activity_node")
    self:initUI(root)
end

function UIActivityItems:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/activity_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.activity_item_node = self.root.activity_item_node_export
    self.ing_bg = self.root.activity_item_node_export.ing_bg_export
    self.ing_desc_bg = self.root.activity_item_node_export.ing_desc_bg_export
    self.activity_time = self.root.activity_item_node_export.activity_time_export
    self.activity_desc = self.root.activity_item_node_export.activity_desc_export
    self.activity_name = self.root.activity_item_node_export.activity_name_export
    self.activity_icon = self.root.activity_item_node_export.activity_icon_export
    self.date = self.root.activity_item_node_export.date_export
    self.date = UIAcDateWidget.new()
    uiMgr:configNestClass(self.date, self.root.activity_item_node_export.date_export)
    self.comming_soon = self.root.activity_item_node_export.comming_soon_mlan_9_export
    self.effect = self.root.effect_export
    self.redPoint = self.root.redPoint_export

--EXPORT_NODE_END

    self.frame_bg = self.root.activity_item_node_export.frame_bg  --新手引导优化
    -- self.root.Button_2:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
end
-- [LUA-print] -         7 = {
-- [LUA-print] -             "lActId"   = 13001
-- [LUA-print] -             "lBngTime" = 1492876800
-- [LUA-print] -             "lEndTime" = 1493481600
-- [LUA-print] -             "lParam"   = 0
-- [LUA-print] -             "lStatus"  = 1
-- [LUA-print] -         }

function UIActivityItems:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_ACTIVITY_RED, function ()
        if self.setData then
            self:setData(self.data)
        end
    end)
    
end

function UIActivityItems:setData(data)
    self.data = data 
    self:updateUI() 
    --dump(self.data,"66666666666")
    self.frame_bg:setName("frame_bg" .. self.data.activity_id)

    self.redPoint:setVisible(global.ActivityData:getActivityRed(self.data.activity_id))
end 

local color = {
    green = cc.c3b(48, 207, 37), --gdisplay.COLOR_GREEN,
    red = cc.c3b(191, 45, 38),
}

function UIActivityItems:playEffect()

    self.effect:stopAllActions()
    local nodeTimeLine =resMgr:createTimeline("activity/activity_node")
    self.effect:runAction(nodeTimeLine)
    nodeTimeLine:play("animation0",true)
end 



function UIActivityItems:updateUI()

    self:playEffect()

    
   self.data.time  = 0 

   --dump(self.data ,"更新 items")

    self:cleanTimer()
    -- self.data.serverdata.lStatus = -2

    self.ing_bg:setVisible(self.data.serverdata.lStatus == 1)
    self.effect:setVisible(self.data.serverdata.lStatus == 1)
    self.ing_desc_bg:setVisible(self.data.serverdata.lStatus == 1)


    if self.data.serverdata.lStatus == 1 then  -- 已开启

        self.activity_time:setTextColor(color.green)

        self.data.time  = self.data.serverdata.lEndTime - global.dataMgr:getServerTime()

    elseif  self.data.serverdata.lStatus == 0 then -- 未开启

        self.activity_time:setTextColor(color.red)

        self.data.time = self.data.serverdata.lBngTime - global.dataMgr:getServerTime()

    elseif self.data.serverdata.lStatus == 9 then  

        self.activity_time:setTextColor(color.red)

        local str =  global.luaCfg:get_local_string(10661)

        self.activity_time:setString(str)

        local activity_time_regular = global.luaCfg:get_activity_time_regular_by(self.data.activity_id)

         self.data.time  =  self.data.serverdata.lEndTime + activity_time_regular.disappear_time - global.dataMgr:getServerTime() 

    end 


    if  global.ActivityData:isForever(self.data.activity_id) then --显示为 "活动进行中"

        self.activity_time:setTextColor(color.green)

        self.activity_time:setString(global.luaCfg:get_local_string(10714))
    else

        if  self.data.time > 0 and self.data.serverdata.lStatus ~=-2 then 

            if not self.timer then 

                self.timer = gscheduler.scheduleGlobal(handler(self,self.updateOverTimeUI), 1)

            end

            self:updateOverTimeUI()
        else

            -- self:timeEndCall()
        end 
    end 

    -- self.activity_icon:setSpriteFrame(self.data.icon)
    global.panelMgr:setTextureFor(self.activity_icon,self.data.icon)

    self.activity_time:setVisible(self.data.serverdata.lStatus ~= 2)  --敬请期待

    self.activity_desc:setString(self.data.simple_describe)

    self.activity_name:setString(self.data.name)

    self.comming_soon:setVisible(self.data.serverdata.lStatus == 2)


    self.date:setVisible(false)

end 



function UIActivityItems:updateOverTimeUI()

    local day =  0 

    local remnantTime = 0

    local value = "" 

     if self.data.serverdata.lStatus == 1 then-- 已开启
        -- self.date:changeBg(false)

        self.data.time  = self.data.serverdata.lEndTime - global.dataMgr:getServerTime()

        local dayTime =  self.data.time- self.data.time % (24*60*60) -- 余数

        remnantTime = self.data.time % (24*60*60)

        day  = dayTime / (24*60*60)

        value = global.luaCfg:get_localization_by(10832).value

    elseif self.data.serverdata.lStatus == 0 then -- 未开启
        -- self.date:changeBg(true)
        self.data.time = self.data.serverdata.lBngTime - global.dataMgr:getServerTime()

        local dayTime =  self.data.time- self.data.time % (24*60*60) -- 余数

        remnantTime = self.data.time % (24*60*60)

        day  = dayTime / (24*60*60)

       value = global.luaCfg:get_localization_by(10831).value

    elseif self.data.serverdata.lStatus == 9 then  

        -- self.date:changeBg(false)

        local activity_time_regular = global.luaCfg:get_activity_time_regular_by(self.data.activity_id)

        self.data.time  = self.data.serverdata.lEndTime + activity_time_regular.disappear_time - global.dataMgr:getServerTime() 

    end 

    if  self.data.time  < 0 then 

        self:cleanTimer()

         self.data.time  = 0 

         self:timeEndCall()

        return 
    end

    local  tips = self:getString(day,remnantTime).." "..value
    self.m_str_time = self:getStringForSecond(day,remnantTime)

    if self.data.serverdata.lStatus == 9 then  --显示已结束

        tips = global.luaCfg:get_local_string(10661) 
    end 

    self.activity_time:setString(tips)

    -- self.date:setData(day,remnantTime)-- 隐藏 艺术字 时间
end 

  

function UIActivityItems:getString(i_day,i_restTime)
    
    local tData = global.funcGame._toFormatTime(i_restTime)
    -- self.day:setString(string.format("%02d",i_day))
    -- self.hour:setString(string.format("%02d",tData.hour))
    -- self.min:setString(string.format("%02d",tData.minute))

    return  global.luaCfg:get_local_string(10770,i_day,tData.hour,tData.minute)
end


function UIActivityItems:getStringForSecond(i_day,i_restTime)

    return global.luaCfg:get_local_string(10675,i_day,global.funcGame.formatTimeToHMS(i_restTime))
end


function UIActivityItems:timeEndCall()

    if true  then return end 

    local panel = global.panelMgr:getPanel("UIActivityPanel")

    panel:setData(panel.activity_type,true)
end 


function UIActivityItems:cleanTimer()

    if self.timer then

        gscheduler.unscheduleGlobal(self.timer)

        self.timer = nil

    end
end 


function UIActivityItems:onExit()
    self:cleanTimer()
end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIActivityItems:lordDetail_click(sender, eventType)

end
--CALLBACKS_FUNCS_END

function UIActivityItems:getCurrtimeStr()
    return self.m_str_time
end

function UIActivityItems:getStartTime()
    return self.data.serverdata.lBngTime
end
function UIActivityItems:getEndTime()
    return self.data.serverdata.lEndTime
end

return UIActivityItems

--endregion
