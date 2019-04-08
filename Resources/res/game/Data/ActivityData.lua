--
-- Author: Your Name
-- Date: 2017-04-21 15:16:17
--
 
local _M = {}
local luaCfg = global.luaCfg
global.gameEvent.EV_ON_UI_ACTIVITY_SERVERDAY_SELECT_UPDATE = "EV_ON_UI_ACTIVITY_SERVERDAY_SELECT_UPDATE"

function _M:init(msg, tagUpgrdeHero, tagNewHeroUpgrade)

 	self.data =  global.luaCfg:activity()
	self.rank_reward =  global.luaCfg:rank_reward()
	self.point_rule_data = global.luaCfg:point_rule()
	self.point_reward = global.luaCfg:point_reward()
	self.serverData = {}		
	

	dump(msg,"活动数据啊")

	if msg then 
		self.serverData = msg
		self:checkFirstRechargeActivity()
	end 


	self:setSevenDayNotifyRedCount(global.userData:getlAllyRedCountBy(10))
	--重连更新七日小红点
	local panel =global.panelMgr:getPanel("UISevenDays")
	local index = 1  
	if not  tolua.isnull(panel) then 
		index = panel.index
	end 
   	gevent:call(global.gameEvent.EV_ON_UI_ACTIVITY_SERVERDAY_SELECT_UPDATE ,  -1)

   	-- 七天英雄升级领取状态
   	self.tagUpgrdeHero = tagUpgrdeHero or {}
   	self.tagNewHeroUpgrade = tagNewHeroUpgrade or {}
   	-- 七天活动红点
   	if not self.activityRed then 
   		self.activityRed = {}
   	end
end


-- 七天英雄升级活动领取状态
function _M:updataActHeroById(id, state)
	-- body
	if not id then return end
	for k,v in pairs(self.tagUpgrdeHero) do
		if v.lID == id then
			v.lValue = state
			break
		end
	end
end

function _M:getActHeroUpgrade(id)
	for k,v in pairs(self.tagUpgrdeHero) do
		if v.lID == id then
			return v.lValue
		end
	end
	return 0
end

-- 七天英雄升级活动领取状态
function _M:updataNewActHeroById(id, state)
	-- body
	if not id then return end
	for k,v in pairs(self.tagNewHeroUpgrade) do
		if v.lID == id then
			v.lValue = state
			break
		end
	end
end

function _M:getNewActHeroUpgrade(id)
	for k,v in pairs(self.tagNewHeroUpgrade) do
		if v.lID == id then
			return v.lValue
		end
	end
	return 0
end

--七天活动红点未领取状态	
function _M:setActivityRed(redData)
	-- body
	local activityId = {[1]=15001, [2]=16001, [3]=30001, [4]=31001 , [5] = 72001, [6] = 73001 , }
	local activityState = {[15001]=0, [16001]=0, [30001]=0, [31001]=0 , [72001] = 0 , [73001] = 0 }
	for i=1,#activityId do
		local id = activityId[i]
        activityState[id] = redData[i]
    end
    self.activityRed = activityState
    gevent:call(global.gameEvent.EV_ON_ACTIVITY_RED)
end
-- 1 有红点
function _M:getActivityRed(actId)
	-- body
	self.activityRed = self.activityRed or {}
	local actState = self.activityRed[actId] or 0
	return actState == 1
end
-- 是否有活动红点
function _M:isActivityRed()
	-- body
	self.activityRed = self.activityRed or {}
	for k,v in pairs(self.activityRed) do
		if v == 1 then 
			return true
		end
	end
	return false
end
--更新当前活动红点状态
function _M:updateActRed(actId)
	-- body
	self.activityRed = self.activityRed or {}
	if self.activityRed[actId] then
		self.activityRed[actId] = 0
		gevent:call(global.gameEvent.EV_ON_ACTIVITY_RED)
	end
end



_M.activity_type = {

	openserveractivity 	= 1  ,  -- 2017年8月17日15:44:14    开服活动改为 充值活动
	dailyactivity 		= 2  , 
	largeactivity		= 3 , 

}

_M.activity_panel  = {
    
        UIKillPanel = { 13001,13002 } ,

        UILevelUpRewordPanel = { 15001 , 16001 ,  73001 , 72001 }  , 

        UIExpActivityPanel = { 2001 , 6001  , 8001 }  , 

        UIPlunderPanel = { 14001 , 11001  , 12001  ,24001 , 21001 , 22001 , 3001 ,22002,14002,3002,24002}  , 

        UIActivityBossPanel = { 25001 , 26001  , 27001 ,28001 }  , 

        UIUnionOccupationPanel = {29001} ,

        UITurntableFullPanel = {61001} , --每日
        
        UITurntableHeroPanel = {62001} , --英雄礼包

        UITurntableHalfPanel = {63001} ,  --魔晶 

        UISevenDays = {19001} , 

        UISevenDayRechargePanel = {60001} ,

        UIMiracleDoorInfoPanel ={4001 , 50001 ,51001,52001 ,53001} , 
}


-- message Activity
-- {
--     required int32      lActId  = 1;        //活动ID
--     required int32      lStatus = 2;        //活动状态 0:尚未开始  1：正在进行 8：等待发将  9：已经结束
--     required int32      lEndTime    = 3;        //结束时间
--     required int32      lBngTime    = 4;        //开始时间
--     optional int32      lParam  = 5;        //扩展字段
-- }

--         6 = {
-- [LUA-print] -             "lActId"   = 16001
-- [LUA-print] -             "lBngTime" = 1492876800
-- [LUA-print] -             "lEndTime" = 1493481600
-- [LUA-print] -             "lParam"   = 0
-- [LUA-print] -             "lStatus"  = 1
-- [LUA-print] -         }
-- [LUA-print] -         7 = {
-- [LUA-print] -             "lActId"   = 13001
-- [LUA-print] -             "lBngTime" = 1492876800
-- [LUA-print] -             "lEndTime" = 1493481600
-- [LUA-print] -             "lParam"   = 0
-- [LUA-print] -             "lStatus"  = 1
-- [LUA-print] -         }

_M.icon = "huodong_1_00000.png"
_M.scale = 0.5

-- 未开始活动 icon
_M.bg 	= 	"ui_surface_icon/city_train_loading.jpg"
_M.effect =	"ui_surface_icon/city_train_loading1.png"
 

-- 进行中活动 icon
_M.bg1 	= 	"ui_surface_icon/city_train_loading.jpg"
_M.effect1 ="ui_surface_icon/city_train_loading1.png"



function _M:getServerDataByActivityid(activity_id)
	for _ , v  in pairs(self.serverData) do 
		if activity_id == v.lActId then 
			return v 
		end 
	end 
end


-- 首次充值并不是一个活动 但是特殊处理为一个活动 (ˉ▽ˉ；)...  所以每次 直通车（拉取数据）时  需要检测是否需要 添加或删除 
--  首冲 没了， 也要 从数据中移除 

local firestRechageActivityId = 40001

function _M:checkFirstRechargeActivity()

	-- if true then return end 
	-- print(global.userData:canFirstPay() , "global.userData:canFirstPay()")
	-- dump(self.serverData ,"self.datra.....")

	-- local fakerData = {
	-- 	lActId = firestRechageActivityId,
	-- 	lStatus = -1,
	-- 	lParam = 0 ,
	-- 	lBngTime = 0 , 
	-- 	lEndTime = 0 
	-- } 

	if global.userData:canFirstPay() then 

		-- table.insert(self.serverData , fakerData)
	else 

		for index ,v in pairs(self.serverData) do 

			if v.lActId  ==  firestRechageActivityId then 

				table.remove(self.serverData , index)

				break
			end 
		end 

	end  

	self:updateUI()
end

function _M:localNotify() --记录尚未开启的活动 至 开启还有多少时间

	for _ ,v in pairs(self.serverData) do 
		if v.lStatus == 0  then 

			if v.lBngTime > global.dataMgr:getServerTime()  then 

				global.ClientStatusData:recordNotifyData(34 , v.lBngTime - global.dataMgr:getServerTime() , global.dataMgr:getServerTime(),v.lActId)
				
			end 
		end  
	end 
end 

function _M:getNoForeverServerData()

	local temp ={} 

	for _ ,v in pairs(self.serverData or {} )  do 

		if global.luaCfg:get_activity_by(v.lActId) and   global.luaCfg:get_activity_by(v.lActId).forever == 0   then 
			table.insert(temp , v)
		end 
	end 

	return temp 
end 


function _M:hanelServerData() 
	for _ , v in pairs(self.serverData) do 
		if v.lBngTime == v.lEndTime then  --9：已经结束
			v.lStatus = 9 
		end 
		if  v.lBngTime > global.dataMgr:getServerTime()  then --0:尚未开始 
			v.lStatus = 0 
		end 
		if  v.lBngTime <= global.dataMgr:getServerTime() and v.lEndTime > global.dataMgr:getServerTime() then --1：正在进行 
			v.lStatus = 1 	
		end 
	end 
end

local Activity_Wait_Time = 60*60*24*2  -- 显示即将开始活动 time
function _M:getCurrentActivityData(activity_type,activity_id) -- 得到当前活动 （正在进行， 将要开启， 已经结束 ）

	--self:hanelServerData()
	local activity_data = {} 
	local unfinished_activity ={}
	local already_activity ={}
	local coming_activity ={}
	local over_acativity = {} 
	local faker_acativity = {} 

	local all_activity = {already_activity , coming_activity , over_acativity , faker_acativity, unfinished_activity} 

	-- dump(self.serverData,"ajdl;jjasdf0000fffff")

	print(global.dataMgr:getServerTime(),"global.dataMgr:getServerTime()")
	for _ ,v in pairs(self.serverData) do 

		if global.luaCfg:get_activity_by(v.lActId) and  activity_type == global.luaCfg:get_activity_by(v.lActId).type then 

			if v.lStatus  == 1 then  --0:尚未开始  1：正在进行 8：等待发将  9：已经结束
				if v.lEndTime > global.dataMgr:getServerTime() then -- 检测服务器状态是否正确
					table.insert(already_activity,v)
				end
			elseif  v.lStatus  == 0 then 
				if v.lBngTime - global.dataMgr:getServerTime() <  global.luaCfg:get_activity_by(v.lActId).time_display*60*60 or global.luaCfg:get_activity_by(v.lActId).time_display== 0 then 
					if v.lBngTime >= global.dataMgr:getServerTime() then  -- 检测服务器状态是否正确
						table.insert(coming_activity,v)
					end 
				end 
			elseif v.lStatus == 9 then 
				-- if v.lEndTime-1  < global.dataMgr:getServerTime() then 
					local activity_time_regular = global.luaCfg:get_activity_time_regular_by(v.lActId)
					if activity_time_regular and global.dataMgr:getServerTime() < v.lEndTime + activity_time_regular.disappear_time then 
						table.insert(over_acativity,v)
					end 
				-- end 
			elseif v.lStatus == 2 then --敬请期待 

				table.insert(unfinished_activity , v)
			end  
		end 

	end 

	table.sort(unfinished_activity , function (A,B) 
		return A.lActId<B.lActId
	end)
	table.sort(already_activity,function(A,B)
		if  A.lEndTime ==  B.lEndTime then 
			return A.lActId<B.lActId
		end 
	 	return A.lEndTime <  B.lEndTime
	  end )
	table.sort(coming_activity,function(A,B) 
		if A.lEndTime ==  B.lEndTime then 
			return A.lActId<B.lActId
		end 
		return A.lBngTime <  B.lBngTime 
		end )

	table.sort(over_acativity , function (A,B) 
		if  A.lEndTime ==  B.lEndTime then 
			return A.lActId<B.lActId
		end 
	 	return A.lEndTime <  B.lEndTime
	end)

	for _ ,v in pairs(all_activity) do 
		for _ ,vv in pairs(v) do 
			local data = clone(global.luaCfg:get_activity_by(vv.lActId))
			data.serverdata =vv 
			table.insert(activity_data,data)
			if activity_id and activity_id == vv.lActId then
				return data
			end
		end 
	end 

	-- 新手签到 放到第一位置 。
	local newPlayerRegister =  nil 
	for index ,v in pairs(activity_data) do 
		if v.activity_id == 18001 then 
			newPlayerRegister  = v 
			table.remove(activity_data , index)
			break
		end 
	end
	local temp  ={}
	table.insert(temp , newPlayerRegister)
	for _ ,v in pairs(activity_data) do 
		table.insert(temp , v)
	end 
	activity_data  = temp  


	return activity_data
end 



function _M:getActivityById(activity_id) -- 有的活动 serverData 可能没有 （七日霸主之路） 

	local   serverdata  = nil 

	for _ ,v in pairs(self.serverData) do 

		if  v.lActId ==  activity_id then 

			serverdata = v 
		end 
	end 

	local data = clone(global.luaCfg:get_activity_by(activity_id))

	data.serverdata =   serverdata

	return data  
end


function _M:updaeAllActivityData()

	if true then return end 

	local arr_id  = {}

	local activity =global.luaCfg:activity()

	for _ ,v in pairs(activity) do

	    table.insert(arr_id , v.activity_id)
	end 

	global.ActivityAPI:ActivityListReq(arr_id,function(ret,msg) 
		self:updateActivityData(ret ,  msg )
		self:checkFirstRechargeActivity() -- 这里面会刷新界面  所有不用下面的代码
	end)

end 
 
function _M:requestActivityData(activity_id_arr,call)

	local temp={}
	if type(activity_id_arr) == "number" then 
		 table.insert(temp,activity_id_arr)
	elseif type(activity_id_arr) == "table" then 
			temp =activity_id_arr
	end
  	global.ActivityAPI:ActivityListReq(temp,function (ret , msg )
  		self:updateActivityData(ret , msg)
  		if call then 
  			call()
  		end 
  	end)
end

function _M:updateActivityData(ret, msg , call)

	if ret and ret.retcode == 0 then
		if msg.tagAct then -- 更新本地数据 
			for _ ,v in pairs(msg.tagAct)  do 
				local isNew  = true 
				for _ ,vv in pairs(self.serverData) do 
					if v.lActId == vv.lActId then 
						vv = clone(v) 
						isNew = false 
					end 
				end 
				if isNew then 
					table.insert(self.serverData ,clone(v))
				end 
			end
		end
	end 
end 

 
-- 得到活动宝箱数据线  领主冲级  城堡冲级
function _M:getActivityBoxData(activity_id )
 	local temp_data ={}
	for _ ,v in pairs(self.point_reward )do 
		if activity_id  == v.activity_id then 
			table.insert(temp_data,v)
		end 
	end 
	return  temp_data
end 


--获得所有point_rule 数据
function _M:getPointRuleById(activity_id)
	local temp_date ={}
	for _ ,v in  pairs(self.point_rule_data )  do 
		if v.acitivity_id == activity_id then 
			table.insert(temp_date,v)
		end 
	end
	return 	temp_date
end 

-- 根据活动id 获取该活动的所有等级数据 
function _M:getPointRuleDataByAitivityID(aitivity_id)
	 for _ ,v in pairs(self.data) do 
	 	if v.activity_id == aitivity_id then 
	 		if v.point_rule ==1  then 
	 			return self:getPointRuleById(aitivity_id)
	 		end 
	 	end  
	 end 
end 


-- 根据活动id 获取该活动的所有等级数据 
function _M:getPointBoxByAitivityID(aitivity_id)
	 for _ ,v in pairs(self.data) do 
	 	if v.activity_id == aitivity_id then 
	 		if v.point_rule ==1  then 
	 			return self:getPointRuleById(aitivity_id)
	 		end 
	 	end  
	 end 
end 



-- 根据活动类型 获取活动数据
function _M:getDataByType(activity_type)
	local activity_data = {}
	if not self.data then return activity_data end 
	for _ ,v in pairs(self.data) do 
		if v.type  == activity_type then 
			table.insert(activity_data,v)
		end 
	end 
	return activity_data
end 

-- [LUA-print] -     "activity_id" = 13001
-- [LUA-print] -     "id"          = 3
-- [LUA-print] -     "rank_max"    = 5
-- [LUA-print] -     "rank_min"    = 4
-- [LUA-print] -     "reward"      = 100029
-- [LUA-print] - }
-- [LUA-print] GuideMg
-- 排序排行榜
function _M:RankOrderData(data)
	local rank_data = {}
	-- dump(data,"data a ")
	for _ ,v in pairs(data) do 
		if v.rank_min ==v.rank_max then 
			v.rank = v.rank_min
			rank_data[v.rank_min] = clone(v)
		else
			for i = v.rank_min , v.rank_max  , 1 do 
				v.rank  = i 
				rank_data[i] = clone(v) 
			end 
		end 
	end
	-- dump(rank_data,"排序后")
	return rank_data
end  


-- 根据Dropid 获取 item
function _M:getDropItemByDropID(id)
	-- print("getDropItemByDropID========================",id)
	local item ={}
	local drop = global.luaCfg:get_drop_by(id)
	if drop then 
		for _ ,v in pairs(drop.dropItem) do 
			local temp_data   = {}
			temp_data.data = global.luaCfg:get_item_by(v[1]) or global.luaCfg:get_equipment_by(v[1]) or  global.luaCfg:get_lord_equip_by(v[1])
			temp_data.data.itemIcon = temp_data.data.itemIcon or temp_data.data.icon
			temp_data.data.itemName = temp_data.data.itemName or temp_data.data.name
			temp_data.number= v[2]
			temp_data.number_2= v[3]
			table.insert(item,temp_data)
		end 		
	end 
	return item 
end 

--根据活动id  去获取活动 排行数据 如果次活动不是排行类型 返回为 nil 


function _M:getRankRewardByActivityID(activity_id)
	if not activity_id then return nil end 
	local activity = global.luaCfg:get_activity_by(activity_id)
	if  not activity then return  nil end 
	local item ={}
	for _ ,v in pairs(self.rank_reward) do 
		if v.activity_id == activity_id then 
			table.insert(item,v)
		end 
	end 
	if #item <= 0  then return nil end 
	 return item 
end

function _M:getRankRewardListByActivityID(activity_id , level)
	if not activity_id then return nil end 
	local activity = global.luaCfg:get_activity_by(activity_id)
	if  not activity then return  nil end 
	local item ={}
	for _ ,v in pairs(self.rank_reward) do 
		if v.activity_id == activity_id then 
			local  copy = clone(v)
			copy.reward = v.rewardlist[level]
			table.insert(item,copy)
		end 
	end 
	if #item <= 0  then return nil end 
	 return item 
end

-- lBngTime" = 1492876800
-- -- [LUA-print] -             "lEndTime" = 1493481600
-- -- [LUA-print] -             "lParam"   = 0 -积分
-- -- [LUA-print] -             "lStatus"  = 1 


function _M:isRankActiviy(activity_id) --是否是 排行活动
	return global.luaCfg:get_activity_by(activity_id).rank == 1 
end 

function _M:isPointActiviy(activity_id) --是否是 积分活动
	return global.luaCfg:get_activity_by(activity_id).point_rule == 1 
end 

function _M:notifyUpdate(data)
	dump(data,"活动更新通知")
	if self.serverData then 
		for _ , v in  pairs(self.serverData) do 
			if v.lActId == data.tagAct.lActId then 
				v.lStatus =  data.tagAct.lStatus
				v.lBngTime =data.tagAct.lBngTime
				v. lEndTime = data.tagAct.lEndTime
				--self:hanelServerData()
				self:updateUI(v.lActId)
				return 
			end 
		end 
		table.insert(self.serverData ,clone( data.tagAct))
		self:updateUI(data.tagAct.lActId)
	end 
end 


function _M:updateUI(id)

	gevent:call(global.gameEvent.EV_ON_UI_ACTIVITY_UPDATE ,id)
end 


function _M:isShowNumberActiviy(activity_id) --活动奖品界面是否显示数量
	 return global.luaCfg:get_activity_by(activity_id).reward_num == 1 
end



function _M:getActivityOverTime() -- 得到主城 倒计时
	self.timer_data = self.timer_data or {}
	if self.timer_data and self.timer_data[1] then 
		for _ , v in pairs(self.serverData)  do
			if v.lActId  == self.overtimer_data.lActId  then
				if   v.lStatus == self.overtimer_data.lStatus then
					return self.timer_data
				end
			end
		end
	end 
	local coming_activity 	= {}
	local already_activity 	= {}
	local timer ={}
	for _ , v in  pairs(self.serverData) do
		if v.lStatus == 1 then
			table.insert(already_activity , v )
		elseif v.lStatus == 0 then
			if v.lBngTime > global.dataMgr:getServerTime() then
				table.insert(coming_activity ,v)
			end 
		end 
	end

	if #already_activity <=  0  and #coming_activity <= 0 then 
		return nil 
	end 

	if #already_activity > 0  then 
		table.sort(already_activity , function (A ,B)
			return A.lEndTime < B.lEndTime
		 end)
		timer.index =0
		timer.lBindID =99899998
		timer.lID =0
		timer.lStartTime =  already_activity[1].lBngTime
		timer.lTotleTime =  already_activity[1].lEndTime - already_activity[1].lBngTime
		timer.lRestTime =  already_activity[1].lEndTime - already_activity[1].lBngTime
		timer.lEndTime =  already_activity[1].lEndTime
		timer.rest = 10
		timer.type = 1 
		self.overtimer_data = clone(already_activity[1])
	elseif  #coming_activity > 0 then 
		table.sort(coming_activity , function (A ,B)
			return A.lBngTime < B.lBngTime
		 end)
		timer.index =0
		timer.lBindID =99899999
		timer.lID =0
		timer.lStartTime = global.dataMgr:getServerTime()
		timer.lTotleTime = coming_activity[1].lBngTime - global.dataMgr:getServerTime()
		timer.lRestTime =  coming_activity[1].lBngTime - global.dataMgr:getServerTime()
		timer.lEndTime =  coming_activity[1].lEndTime
		timer.rest = 10
		timer.type = 0 
		self.overtimer_data  = clone(coming_activity[1])
	end

	self.timer_data[1]=timer
	return self.timer_data
end


function _M:getMainUIActivity() -- 得到主界面活动 "最后结束的活动" 无活动 return nil 
	local show_type =  1 
	local  get_ac  =  function()
		local choosed_activity = nil  
		for _ , v in  pairs(self.serverData) do 
			if show_type == 1  then 		--  快要结束的活动
				if v.lStatus == 1 and v.lEndTime > global.dataMgr:getServerTime() then
					if choosed_activity then 
						if choosed_activity.lEndTime < v.lEndTime then
							choosed_activity = v 
						end
					else 
						choosed_activity = v 
					end 
				end 
			elseif show_type == 2 then 	-- 快要开始的活动
				if v.lStatus == 0 and  v.lBngTime - global.dataMgr:getServerTime() <  global.luaCfg:get_activity_by(v.lActId).time_display*60*60  then 
					if choosed_activity then 
						if choosed_activity.lBngTime > v.lBngTime then
							choosed_activity = v 
						end
					else 
						choosed_activity = v 
					end 
				end
			end 
		end
		if choosed_activity then 
			self.main_ui_activity 	= clone(global.luaCfg:get_activity_by(choosed_activity.lActId))
			self.main_ui_activity.serverdata = choosed_activity
		else
			self.main_ui_activity = nil 
		end 
	end

	if self.main_ui_activity then
		for _ ,v in pairs(self.serverData) do 
			if not self.main_ui_activity then  return end  -- 不知道为什么报错。  
			if self.main_ui_activity.serverdata.lActId == v.lActId then 
				local is_nede_update = false
				if show_type == 1 then 
					if v.lStatus ~=1 then 
						is_nede_update = true 
					end 
				elseif show_type == 2 then 	
					if v.lStatus ~= 0 then 
						is_nede_update = true 
					end 
				end
				if is_nede_update then 
					get_ac()
				end
				break  
			end 
		end 
	else
		get_ac()
	end
	return self.main_ui_activity
end

-- 
function _M:getActivityStatus()  -- 空闲列表 使用
	local startServerType = 1  -- 优先判断活动
	local already_activity 	= {} 
	for _ ,v in pairs(self:getNoForeverServerData()) do
		if v.lStatus == 1 then 
			table.insert(already_activity , v)
		end 
	end
	if #already_activity >  0 then 
		for _ ,v in pairs(already_activity) do  
			if global.luaCfg:get_activity_by(v.lActId) and  global.luaCfg:get_activity_by(v.lActId).type == startServerType then 
				return  true , 1 
			end
		end
		return 	true ,global.luaCfg:get_activity_by(already_activity[1].lActId).type 
	end
	return false
end 

function _M:getBtnState1( )

	return "NEW_SERVER"
end

function _M:getBtnState()


end 

function _M:CheckActivityState()

	local excute = function (id , call) 	
		for index ,v in pairs(self.serverData)  do 

			if v.lActId  == id then 

				call(self.serverData , index  , v )
				return 
			end 
		end 
	end

	excute(19001 , function(data , index  , v ) -- 七天霸主之路 
		if v.lStatus == 1 then 
			if v.lEndTime - global.dataMgr:getServerTime() > 0 then 
				return 
			end 
		end 
		table.remove(data , index)
		self:updateUI(19001)
 	end)

end 


function _M:gotoActivityPanelById(activity_id, isNotOpenPanel , notOpen) --

	local data = global.luaCfg:get_activity_by(activity_id)

	if not data then return false end 

	local activity_type  = data.type

	local flg = false 

	for _ ,v  in ipairs(self:getCurrentActivityData(activity_type)) do 

		if v.activity_id == activity_id then 	
			flg =  true 
			break
		end 
	end 

	if flg and (not isNotOpenPanel) then 

		local panel =   global.panelMgr:openPanel("UIActivityPanel")
		panel:setGPSActivityId(activity_id , notOpen)
		panel:setData(activity_type, false)

	end 

	return flg 
end


function _M:openActivityPanel(activity_id,itemNode) --

	if activity_id == 62001 then
		local targetId = luaCfg:get_turntable_hero_cfg_by(1).open_lv
		local isUnlock = global.funcGame:checkTarget(targetId)
	    if not isUnlock then
	        local triggerData = luaCfg:get_target_condition_by(targetId)
	        local builds = luaCfg:get_buildings_pos_by(triggerData.objectId)
	        global.tipsMgr:showWarning(luaCfg:get_local_string(11141,triggerData.condition))
	        return
	    end
	elseif activity_id == 63001 then
		if not global.funcGame:checkBuildAndBuildLV(15) then 
			return
		end
	end

	local activity_data = self:getActivityById(activity_id)


    for panel_name , v  in pairs(self.activity_panel) do 

        if table.hasval(v , activity_id ) then 

        	if not self:specialPanel(panel_name ,activity_data) then 
    	        local panel =  global.panelMgr:openPanel(panel_name)
    	        if panel_name ~= "UITurntableHalfPanel" then
	            	panel:setData(activity_data)
	            end
        	end 
            return 
        end 
    end 

	if  activity_data.activity_id == 18001 then 

        global.panelMgr:openPanel("UIRegisterPanel"):setData(global.dailyTaskData:getTagSignInfo())

	elseif activity_data.activity_id == 40001 then 

        global.panelMgr:openPanel("UIFirRechargePanel"):setData()

    elseif activity_data.activity_id ==  20001 then 

        global.panelMgr:openPanel("UIKingBattlePanel")  

    elseif activity_data.activity_id ==  9001 then 
        
        local panel = global.panelMgr:openPanel("UIAccRechargePanel")
        if not self.m_accData then
            self.m_accData = global.ActivityData:getCurrentActivityData(1,9001)
        end
        panel:setData(self.m_accData)

    elseif activity_data.activity_id ==  30001 then  -- 七天传说英雄培养

    	local panel =global.panelMgr:openPanel("UIActivityHeroUpPanel")
		panel:setData(activity_data)
    elseif activity_data.activity_id ==  31001 then  -- 七天传说英雄培养

    	local panel =global.panelMgr:openPanel("UIActivityNewHeroUpPanel")
		panel:setData(activity_data,itemNode)
    	
    else 
		local panel =global.panelMgr:openPanel("UIActivityDetailPanel")
		panel:setData(activity_data)
	end 
end 


function _M:specialPanel(panel_name , activity_data)

	-- if panel_name  == "UIActivityBossPanel" then 

	-- 	global.ActivityAPI:ActivityListReq({activity_data.activity_id},function(ret,msg)
	--         if msg and msg.tagAct then 
	--         	local panel =global.panelMgr:openPanel(panel_name)
	--             panel.rank:setString(msg.tagAct[1].lParam2 or 0 )
	--             panel.lv =  msg.tagAct[1].lParam
	-- 			panel:setData(activity_data)
	--         end 
 --    	end , false)
	-- 	return true 
	-- end 
	
	return 	false 
end 



function _M:openActivityRank(activity_id )
	
	local call  = self:getCallBack( nil , 6  , self:getActivityById(activity_id))

	call()
end 



function _M:getCallBack(panel_name , panel_index , data)


	print(panel_index,"panel_index>>>>>>>>>>>>")

	 function call (parm) 

            local panels = {
                [1] = "UINormalRewardPanel",
                [2] = "UIActivityRankPanel",
                [3] = "UIActivityPointPanel",
                [4] = "UIActivityRankPanel",
                [5] = "UIActivityRankPanel",
                [6] = "UIRankInfoPanel",
                [7] = "UIRegisterPanel",
                [8] = "UIActivityRulePanel", 
                [9] = "UIAccRechargePanel",
                [10] = "UIStorePanel", 
                [11] = "UILevelUpRewordPanel",
                [14] = "UIActivityInfoPanel",
                [15] = "UIActivityBossPanel" ,
                [16] = "" ,
            }


            print(panel_name ,"panel_name >>>>>>>>>>>")

            if panel_name then 
            	-- global.panelMgr:closePanel(panel_name)  
        	end 

            if panel_index  == 6  then 

                for _ ,v in pairs(global.luaCfg:activity_rank()) do

                    if v.activity_id == data.activity_id then 

                        local  panel =  global.panelMgr:openPanel("UIRankInfoPanel")

                        panel:setActvityData(v)

                        return 
                    end 
                end 

            elseif  panel_index == 10  then 

                local  activity = global.ActivityData:getActivityById(8001)

                if activity then 

                    if activity.serverdata and activity.serverdata.lStatus==1 then 

                         local panel = global.panelMgr:openPanel(panels[panel_index])

                    else 
                        global.tipsMgr:showWarning("activity_not_open")
                    end  
                else 
                    global.tipsMgr:showWarning("activity_not_open")
                end 

            elseif panel_index == 12 then 
				
				local mainCityLandId = global.worldApi:decodeLandId(global.userData:getWorldCityID())
    			if global.userData:getWorldCityID() == 0 then mainCityLandId = 1 end
    			local keys = {'to_temple','to_temple2','to_temple3','to_temple4'}
            	if global.luaCfg:get_temple_activity_by(data.activity_id) then 
	    			global.funcGame:gpsWorldCityWithOpen(global.luaCfg:get_temple_activity_by(data.activity_id)[keys[mainCityLandId]] , 1)
	    			return 
            	end 

            	global.ActivityAPI:requestTempleMapId(function(ret , msg)
            		
            		if ret.retcode == 0 then 
            			
            			global.funcGame:gpsWorldCityWithOpen(msg.lMapId , 1)
            		end 

            	end)


            elseif panel_index == 13 then 

        			global.funcGame:gpsWorldCity(parm , 1)
            elseif panel_index == 14 then

                local panel = global.panelMgr:openPanel(panels[panel_index])
                panel:setData(data)
            elseif panel_index == 15 then

            	if self:isActivityOpen(data.activity_id) then
            		local landId = math.floor(parm / 1000) - 24
	    			local bossIds = {160229999,160229999,160229999,160229999}
	    			
	    			if global.userData:isOpenFullMap() then
	    				bossIds = {160229999,580169999,250649999,640559999}
	    			end	
	    			
	    			local bossId = bossIds[landId]			            

		            global.funcGame:gpsWorldCity(bossId, false, true,function()

			            local widgetName = 'monsterObj' .. bossId
			            global.guideMgr:setStepArg(widgetName)
			            gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_AFTER_SEARCH)
			        end)
			    else
			    	global.tipsMgr:showWarning('cannotgpsnotopen')
            	end            	
            elseif panel_index == 16 then

    			local mainCityLandId = global.worldApi:decodeLandId(global.userData:getWorldCityID())
    			print(mainCityLandId,'wdaswajafnsfeh')
    			if global.userData:getWorldCityID() == 0 then mainCityLandId = 1 end
    			local keys = {'to_temple','to_temple2','to_temple3','to_temple4'}
    			global.funcGame:gpsWorldCity(global.luaCfg:get_temple_activity_by(data.activity_id)[keys[mainCityLandId]] , 1)

            else 
	            local panel = global.panelMgr:openPanel(panels[panel_index])
                panel:setData(data)
            end 
	end 

	return call 
end 


function _M:updateSevenDay()

    global.ActivityAPI:SevenActivityReq(function(msg)
    	-- self.sevenDayData =clone( msg ) 
   		gevent:call(global.gameEvent.EV_ON_UI_ACTIVITY_SERVERDAY_SELECT_UPDATE)
    end)

end 


function _M:finishSevenDay(id) 
	if self.sevenDayData then 
		for _ ,v in pairs(self.sevenDayData.tagTask) do 
			    if v.lID ==  id  then  
					v.lState = 2  
			    end     
		end

		-- print(id , "self.finishSevenDay.tagTask")
		-- dump(self.sevenDayData.tagTask ,"self.sevenDayData.tagTask")

		gevent:call(global.gameEvent.EV_ON_UI_ACTIVITY_SERVERDAY_SELECT_UPDATE , -1)
	end 
end 

function _M:getSevenDayRedPointNumber(day) -- return  status  , number 

	local red = false 
	local allNumber=  0 

	local  getNumber = function(d) 

		local temp  = {} 
		local redNumber = 0 

		local  target  =  global.luaCfg:get_seven_day_by(d)

		for i = 1 , target.max do

			local id = target["target"..i]

			table.insert(temp , id)

		end

		for _ ,v in pairs(self.sevenDayData.tagTask or {}) do 

			for _ ,vv in pairs(temp ) do 

			    if v.lID ==  vv and  v.lState == 1 then  

			    	 redNumber = redNumber +  1  
			    end     
			end 
		end

		return redNumber  
	end 

	if day and self.sevenDayData then 

		if type(day) == "table" then 

			for _ ,v  in  ipairs(day) do 

				allNumber = allNumber +  getNumber(v)
			end
		else 

			allNumber =  getNumber(day)
		end  


		if allNumber > 0 then 

			red = true 
		end 
	else 

		red = false 
		allNumber = 0 

	end 


	return red , allNumber
end 


function _M:isForever(id) --是否是永久活动
		
	for _ ,v in pairs(self.data) do 
	 	if v.activity_id == id then 
	 		 return (v.forever == 1 and v.sevenday ==0)
	 	end  
	 end 
	 return false 
end 

-- [LUA-print] -             "lActId"   = 16001
-- [LUA-print] -             "lBngTime" = 1492876800
-- [LUA-print] -             "lEndTime" = 1493481600
-- [LUA-print] -             "lParam"   = 0
-- [LUA-print] -             "lStatus"  = 1

function _M:isActivityOpen(id)

	for _ ,v in pairs(self.serverData or{} ) do 

		if v.lActId == id then 

			return v.lStatus == 1 
		end 
	end 
end 


local boosID = {
	25001 , 
	26001 ,
	27001 ,
	28001 ,
} 

function _M:getWorldBossActivity() --

	for _ ,v in pairs(self.serverData or{} ) do 

		if table.hasval(boosID , v.lActId) and v.lStatus == 1  then 

			return v.lActId
		end 
	end 

	local old = nil 

	for _ ,v in pairs(self.serverData or{} ) do 

		if table.hasval(boosID , v.lActId) then 

			if not old then old = v end 

			if  v.lBngTime - global.dataMgr:getServerTime() < old.lBngTime- global.dataMgr:getServerTime() then 
				old = v 
			end 
		end 
	end 
	
	if old then 
		return old.lActId
	end 
end 



function _M:setSevenDayNotifyRedCount(count)

	self.sevenDayNotifyRedCount = count

end 

function _M:getSevenDayNotifyRedCount()

	return self.sevenDayNotifyRedCount
end



global.ActivityData = _M

--endregion
