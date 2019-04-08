--region UIEffectNode.lua
--Author : anlitop
--Date   : 2017/05/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIEffectNode  = class("UIEffectNode", function() return gdisplay.newWidget() end )

function UIEffectNode:ctor()
    
end

function UIEffectNode:CreateUI()
    local root = resMgr:createWidget("effect/huodong_icon2")
    self:initUI(root)
end

function UIEffectNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "effect/huodong_icon2")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.time = self.root.time_mlan_4_export

--EXPORT_NODE_END

    self.particle = self.root.Particle_exprot

end

-- [LUA-print] -             "lActId"   = 13001
-- [LUA-print] -             "lBngTime" = 1492876800
-- [LUA-print] -             "lEndTime" = 1493481600
-- [LUA-print] -             "lParam"   = 0
-- [LUA-print] -             "lStatus"  = 1

function UIEffectNode:setData(data)
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


function UIEffectNode:Action(state)
     self.root:stopAllActions() 
    if state then 
        local nodeTimeLine =resMgr:createTimeline("effect/huodong_icon2")
        self.root:runAction(nodeTimeLine)
        nodeTimeLine:play("animation0",true)
        self.particle:setVisible(true)
    else
        self.particle:setVisible(false)
    end 
end 

function UIEffectNode:updataOverTimeUI()
   local time =self.data.lEndTime - global.dataMgr:getServerTime()
    if  time  <= 0 then 
        self:clearTimer()
        time= 0 
    end 
	self.time:setString(global.funcGame.formatTimeToHMS(time))
end 


function UIEffectNode:hide()
    self:setVisible(false)
end 

function UIEffectNode:show()
    self:setVisible(true)
end 

function UIEffectNode:clearTimer()
	if self.timer then
        gscheduler.unscheduleGlobal(self.timer)
        self.timer = nil
    end
end 

function UIEffectNode:onExit()
	self:clearTimer()
end 
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIEffectNode

--endregion
