--region UIVipTips.lua
--Author : anlitop
--Date   : 2017/08/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIVipTips  = class("UIVipTips", function() return gdisplay.newWidget() end )

function UIVipTips:ctor()
    
end

function UIVipTips:CreateUI()
    local root = resMgr:createWidget("common/city_vip_tips")
    self:initUI(root)
end

function UIVipTips:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/city_vip_tips")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.text = self.root.Node_1.text_export

    uiMgr:addWidgetTouchHandler(self.root.Node_1.bg.Button_1, function(sender, eventType) self:click_close_tips(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIVipTips:onEnter()

	self:cleanTimer()

	if not self.timer then 
   		 self.timer = gscheduler.scheduleGlobal(handler(self,self.checkshow) ,5)  -- 每  5 秒钟 检测一下tips 
 	end 

 	self:addEventListener(global.gameEvent.EV_ON_GAME_PAUSE,function()
		self:Action(false)
 	end)


	self:addEventListener(global.gameEvent.EV_ON_UI_VIPUPDATE , function () 
		if  global.vipBuffEffectData:isVipEffective() then 
			self:Action(false)
		end 
	end)


 	self.first_in  = true 

	self.delay1  = gscheduler.performWithDelayGlobal(function()

		if self and  self.checkshow  then 

			self:checkshow()
		end 

		if self.delay1 then
	        gscheduler.unscheduleGlobal(self.delay1)
	        self.delay1 = nil
    	end


	end, global.EasyDev.VIP_TIPS_DELAYTIME)
end

function UIVipTips:Action(state)


    self.root:stopAllActions() 

    if state then 

    	self.root:setVisible(true)

        local nodeTimeLine =resMgr:createTimeline("common/city_vip_tips")

        self.root:runAction(nodeTimeLine)

        nodeTimeLine:play("animation0",false)

        nodeTimeLine:setLastFrameCallFunc(function()

        	self.scheduleId = gscheduler.performWithDelayGlobal(function()

				if self and self.root then 

					self.root:setVisible(true)

					local nodeTimeLine =resMgr:createTimeline("common/city_vip_tips")

        			self.root:runAction(nodeTimeLine)

					nodeTimeLine:play("animation1",false)

					global.EasyDev:removeTips(global.EasyDev.VIP_TIPS_TYPE)

				end 

			end, global.EasyDev.Part_RES_TIPS_TIME)

        end)

    else

    	global.EasyDev:removeTips(global.EasyDev.VIP_TIPS_TYPE)

		if self and self.root then 

			self.root:setVisible(false)

			if self.scheduleId then
	        	gscheduler.unscheduleGlobal(self.scheduleId)
	        	self.scheduleId = nil
    		end
		end 

    end 
end 


local part_time = global.luaCfg:get_config_by(1).resTipsTime or 10 
part_time =  part_time - 1 
part_time  = part_time * 60 

function UIVipTips:checkshow()

	if global.scMgr:isWorldScene() then return end 

	if global.userData:getLevel() < 4 then return end 
	
	if global.vipBuffEffectData:isVipEffective() then return end 

	local addTips = function ()
		global.EasyDev:addTips(global.EasyDev.VIP_TIPS_TYPE ,  function () 
		global.uiMgr:setRichText(self,"text",50114,{num =rest})
		self:Action(true) end )
	end

	if (not  global.EasyDev.vip_last_tips_time ) or self.first_in  or ( global.dataMgr:getServerTime() - global.EasyDev.vip_last_tips_time > part_time )  then 
		self.first_in = false
		global.EasyDev.vip_last_tips_time = global.dataMgr:getServerTime() 
		addTips()
	end 
end 


function UIVipTips:cleanTimer()

    if self.timer then

        gscheduler.unscheduleGlobal(self.timer)

        self.timer = nil
    end
end 


function UIVipTips:onExit()

	self:cleanTimer()

	global.EasyDev:removeTips(global.EasyDev.VIP_TIPS_TYPE)

	if self.delay1 then
        gscheduler.unscheduleGlobal(self.delay1)
        self.delay1 = nil
	end
	
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIVipTips:click_close_tips(sender, eventType)

	self:Action(false)
end


--CALLBACKS_FUNCS_END

return UIVipTips

--endregion
