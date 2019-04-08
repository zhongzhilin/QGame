--region UIEnterEffect.lua
--Author : anlitop
--Date   : 2017/06/06
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIEnterEffect  = class("UIEnterEffect", function() return gdisplay.newWidget() end )

function UIEnterEffect:ctor()
    
end

function UIEnterEffect:CreateUI()
    local root = resMgr:createWidget("effect/huodong_icon4")
    self:initUI(root)
end

function UIEnterEffect:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "effect/huodong_icon4")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.light = self.root.huodong.light_export
    self.time = self.root.time_export
    self.point_red = self.root.point_red_export

--EXPORT_NODE_END

    self.light= self.root.huodong.light_export
end


function UIEnterEffect:setData(data)
    self:clearTimer()
    self.data = data 
    if self.data then 
        if not self.timer then 
            self.timer = gscheduler.scheduleGlobal(handler(self,self.updataOverTimeUI), 1)
        end 
        self:updataOverTimeUI()
    end 
    self:show()
end




function UIEnterEffect:Action(state)
if state  then 
        self.root:stopAllActions() 
        self.light:setVisible(true)
        self.nodeTimeLine =resMgr:createTimeline("effect/huodong_icon4")
        self.root:runAction(self.nodeTimeLine)
        self.nodeTimeLine:play("animation0",true)
        -- self.particle:setVisible(true)
    else
        self.light:setVisible(false)
        if not tolua.isnull(self.nodeTimeLine) then 
            self.nodeTimeLine:gotoFrameAndPause(0)
        end 
        -- self.particle:setVisible(false)
        self.root:stopAllActions() 
    end 
end 

function UIEnterEffect:updataOverTimeUI()
   local time =self.data.lEndTime - global.dataMgr:getServerTime()
    if  time  <= 0 then 
        self:clearTimer()
        time= 0 
    end 
    self.time:setString(global.funcGame.formatTimeToHMS(time))
end 


function UIEnterEffect:hide()
    self:setVisible(false)
end 

function UIEnterEffect:show()
    self:setVisible(true)
end 

function UIEnterEffect:clearTimer()
    if self.timer then
        gscheduler.unscheduleGlobal(self.timer)
        self.timer = nil
    end
end 

function UIEnterEffect:onExit()
    self:clearTimer()
end 
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIEnterEffect

--endregion
