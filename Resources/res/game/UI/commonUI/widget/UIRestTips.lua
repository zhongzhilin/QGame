--region UIRestTips.lua
--Author : anlitop
--Date   : 2017/05/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRestTips  = class("UIRestTips", function() return gdisplay.newWidget() end )

function UIRestTips:ctor()
    
end

function UIRestTips:CreateUI()
    local root = resMgr:createWidget("common/city_res_tips")
    self:initUI(root)
end

function UIRestTips:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/city_res_tips")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.text = self.root.bg.text_export

    uiMgr:addWidgetTouchHandler(self.root.bg.Button_1, function(sender, eventType) self:click_close_tips(sender, eventType) end)
--EXPORT_NODE_END
end

function UIRestTips:onEnter()

	self:cleanTimer()

	if not self.timer then 
   		 self.timer = gscheduler.scheduleGlobal(handler(self,self.checEnough) ,5)
 	end 

 	self:addEventListener(global.gameEvent.EV_ON_GAME_PAUSE,function()
		 	self:Action(false)
 	end)


 	self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,function()
 		self.isRes_Update = true 

		if self  and   self.checEnough then 
			self:checEnough()
		end 
		
 	end)

 	self.isRes_Update =  false 

 	self.delay1 = gscheduler.performWithDelayGlobal(function()

		if self  and   self.checEnough then 
			self:checEnough()
		end 


		if self.delay1 then
	        gscheduler.unscheduleGlobal(self.delay1)
	        self.delay1 = nil
    	end

	end, global.EasyDev.RES_TIPS_DELAYTIME) 	

end

function UIRestTips:Action(state)

    self.root:stopAllActions() 

    if state then 

    	self.root:setVisible(true)

        local nodeTimeLine =resMgr:createTimeline("common/city_res_tips")

        self.root:runAction(nodeTimeLine)

        nodeTimeLine:play("animation0",false)

        nodeTimeLine:setLastFrameCallFunc(function()

        	self.scheduleId = gscheduler.performWithDelayGlobal(function()

				if self and self.root then 

					 self.root:setVisible(true)

					local nodeTimeLine =resMgr:createTimeline("common/city_res_tips")

        			self.root:runAction(nodeTimeLine)

					nodeTimeLine:play("animation1",false)


					global.EasyDev:removeTips(global.EasyDev.RES_TIPS_TYPE)

				end 

			end, global.EasyDev.Part_RES_TIPS_TIME)

        end)

    else

    	global.EasyDev:removeTips(global.EasyDev.RES_TIPS_TYPE)

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
part_time  = part_time * 60 

function UIRestTips:checEnough()

	if not global.EasyDev.soldier_last_tips_time then 
		self:CheckFoodEnough()
		return 
	end 

	if  global.dataMgr:getServerTime() - global.EasyDev.soldier_last_tips_time > part_time  then 
		self:CheckFoodEnough()
		return 
	end 

	if self.isRes_Update then  -- 资源更新 只判断 隐藏 

		self:CheckFoodEnough()

		return 
	end
end 

	 
function UIRestTips:CheckFoodEnough()

	local soldierCost = global.resData:getFoodConsumpWithBuff() or 0

	if soldierCost <=0 then soldierCost = 1 end 
	
	local resAll = global. propData:getShowProp(WCONST.ITEM.TID.FOOD,"")
	
	local rest =  math.floor( resAll / soldierCost ) 
	local timeGap = global.EasyDev.MIN_RES_TIPS_TIME or 5

	if rest <  timeGap  then

		-- self.EasyDev.isShowed  -- 第一次 不考虑  检测时间  只要 粮食 不够

		if self.isRes_Update == false or not global.EasyDev.isShowed  then 

			global.EasyDev:addTips(global.EasyDev.RES_TIPS_TYPE , function()
				global.uiMgr:setRichText(self,"text",50071,{num =rest})
				self:Action(true) 
			 end )

			global.EasyDev.isShowed = true 

		end 

	else 

		self:Action(false)

	end

	global.EasyDev.soldier_last_tips_time =  global.dataMgr:getServerTime()


	self.isRes_Update =  false 
end 

	
function UIRestTips:cleanTimer()

    if self.timer then

        gscheduler.unscheduleGlobal(self.timer)

        self.timer = nil
    end
end 

function UIRestTips:onExit()

	self:cleanTimer()

	global.EasyDev.soldier_last_tips_time = nil 

	global.EasyDev:removeTips(global.EasyDev.RES_TIPS_TYPE)

end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIRestTips:click_close_tips(sender, eventType)
	self:Action(false)
end
--CALLBACKS_FUNCS_END

return UIRestTips

--endregion
