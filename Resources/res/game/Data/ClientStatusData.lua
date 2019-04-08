--
-- Author: Your Name
-- Date: 2017-04-13 12:24:37
--
--
-- Author: Your Name
-- Date: 2017-04-07 22:03:08
--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local _M = {}
local luaCfg = global.luaCfg
local json    = require "json"
local crypto  = require "hqgame"
local app_cfg = require "app_cfg"
_M.TYPE_LOG = -99999929
_M.DEVEIE_STATUS ={PAUSE=100,RUNING=101,RRSUME=103}
function _M:init()
	self.resume_call =  {} 
	self.pause_call  =  {}
	self.call_number={
		infinite ="infinite" , 
	}
	-- 继续回调
	-- self:addClientResumeCall("CheckPauseGameTime",handler(self,self.CheckPauseGameTime))
	self:addClientResumeCall("sedClientStatusToServer",handler(self,self.sedClientStatusToServer))
	self:addClientResumeCall("cleanLocalNotify",handler(self,self.cleanLocalNotify))

	-- 暂停回调
	self:addClientPauseCall("sedClientStatusToServer",handler(self,self.sedClientStatusToServer))
	self:addClientPauseCall("updateLocalNotifyData",handler(self,self.updateLocalNotifyData))

	self.deveie_status = self.DEVEIE_STATUS.RUNING

	if device.platform == "ios" then
		self:setSendIosTokenCall()
	end 

	self:cleanIosAllNotification() --每次进入游戏的时候清理本地推送（苹果本地推送不清理 会一直存在）
end

function _M:sedClientStatusToServer(status) -- 切后台 status=1  返回 status=0
	global.PushInfoAPI:sendClientStatus(status,function(ret, msg) end)
end

function _M:CheckPauseGameTime()
	local run_bg_max_time  = 60*30
	if self:getClientLastResumeTime() - self:getClientLastPauseTime() >= run_bg_max_time  then
		-- global.funcGame.RestartGame()
		self:Errorhandle(WCODE.ERR_NET_DISABLE)
	end
end

function _M:RestartGameNotInLoginScene(msg,time,isClose)
	if isClose then
		if msg and msg == 10619 then
			-- 确定是服务器维护中了
			global.tipsMgr:showQuitConfirmPanelNoClientNet(false)
		else
			global.tipsMgr:showQuitConfirmPanel(msg)
		end
	else
		global.tipsMgr:showWarning(msg)
		gscheduler.performWithDelayGlobal(function()
	       	if not global.scMgr:isLoginScene()  then 
				global.funcGame.RestartGame()
			end 
	   end, time)
	end
end 

function _M:Errorhandle(code)
	print("#####------>>>>>>>>>>Errorhandle::")
	print(code)
	local tipsContent=  nil
	local isClose = false
	local secs = WDEFINE.NET.RESTART_DELAY
	if code  == WCODE.ERR_SERVER_UPDATE then  -- 服务器更新通知
		tipsContent = global.luaCfg:get_local_string(10496,secs)
	elseif code == WCODE.ERR_SERVER_KICKING then -- 维护性服务器关闭的踢出通知
		tipsContent = 10619
    	isClose = true
	elseif code == WCODE.ERR_SERVER_CLOSING then -- 服务器维护中
		tipsContent = 10619
    	isClose = true
	elseif code == WCODE.ERR_SERVER_REBOOTED then -- 服务器重启过
		tipsContent = global.luaCfg:get_local_string(10498,secs)
		-- tipsContent = "服务器已经维护过，需要重启（PS：暂时测试代码！后面会改的）"
    elseif code == WCODE.ERR_NET_DISABLE then -- 客户端后台连接超时
		-- tipsContent = global.luaCfg:get_local_string(10498,secs)
		global.funcGame.RestartGame()
		return
		-- tipsContent = "客户端后台连接超时！（PS：暂时测试代码！后面会改的）"
		-- global.funcGame.RestartGame()
    elseif code == WCODE.ERR_ABNORMAL_LOGIN then -- 其他设备登陆
    	print("------>gevent_is_back()=")
    	print(gevent_is_back())
    	if gevent_is_back() then return end
    	tipsContent =global.luaCfg:get_local_string(10531)
    	isClose = true
    end
    global.netRpc:KickOut()
	self:RestartGameNotInLoginScene(tipsContent,secs,isClose)
end

--  - "这是记录的推送数据" = {
-- [LUA-print] -     1 = {
-- [LUA-print] -         "delayTime"   = 78314.986987829208
-- [LUA-print] -         "id"          = 16
-- [LUA-print] -         "record_time" = 1492409543.0130122
-- [LUA-print] -     }
-- [LUA-print] -     2 = {
-- [LUA-print] -         "delayTime"   = 0
-- [LUA-print] -         "id"          = 4
-- [LUA-print] -         "record_time" = 0
-- [LUA-print] -     }
function _M:recordNotifyData(id,delayTime,record_time , parm)

	print(id,"记录的推送数据 id")
	local push_message = luaCfg:get_push_message_by(id)
	-- dump(push_message,"push_message")
	local notifydata  = {}
	notifydata.id = push_message.id 
	notifydata.delayTime = delayTime 
	notifydata.ticker = push_message.title
	notifydata.title = push_message.title 
	notifydata.conent = push_message.text  
	notifydata.record_time = record_time 
	notifydata.type = push_message.type 
	notifydata.isvalid= 0 
	notifydata.parm = parm

	self:setText(notifydata)
	table.insert(self.recordNotify_arr,notifydata)
	-- dump(self.recordNotify_arr,"记录的推送数据")	
end


function _M:setText(notifydata)

	if  notifydata.id == 34 then  --活动 
		local name = global.luaCfg:get_activity_by(notifydata.parm).name		
		name = name or "" 
		notifydata.conent = string.format(notifydata.conent, name)
	elseif notifydata.id == 35 then  -- 部队到达目的地
	  --   local endStationStr = "-"
	  --   local goStationStr  =  "" 
	  --   local lState = notifydata.parm.lState
	  --   if lState == 1 then
	  --       goStationStr = notifydata.parm.szSrcName
	  --       endStationStr = notifydata.parm.szTargetName
	  --   elseif lState == 2 then
	  --       goStationStr = notifydata.parm.szSrcName
	  --       endStationStr = notifydata.parm.szTargetName
	  --   end
	 -- local target =  global.troopData:getNameByType(notifydata.parm.lDstType, endStationStr)
	 	notifydata.conent = string.format(notifydata.conent, notifydata.parm.szName)
	 	print(notifydata.conent ,"sdfsdf")
	end 

end 

function _M:log(conetnet)
end 

function _M:updateLocalNotifyData()
	-- NotifyHelper:addNotification(100,10,"测试通知", "测试通知","updateLocalNotifyData")
	self.recordNotify_arr =  {} 
	print("1========")
	global.cityData:localNotify() -- 士兵 城防  建筑队列
	print("2==========")
	global.vipBuffEffectData:localNotify() -- vip 时间
	print("3============")
	global.techData:localNotify() -- 科技
	print("4=======")
	global.resData:localNotify() -- 占领的资源消失
	print("5==========")
	global.ActivityData:localNotify() -- 活动开始
	print("6==========")
	global.MySteriousData:localNotify() -- 神秘商店刷新
	print("7==========")
	self:unionHelpLocalNotify() -- 联盟帮助 
	print("8==========")
	self:troopMsgLocalNotify()
	print("9==========")

	self:handlerOrderNotifyData()
	self:addLocalNotifyData()
	-- self.recordNotify_arr =  nil 
end 


local maxTime = 24 * 60 * 60 * 2   -- 超过 2 天 不推送

function _M:addLocalNotifyData()
	-- dump(self.recordNotify_arr,"清理后数据")
	-- NotifyHelper:addNotification(100,10,"测试通知", "测试通知","addLocalNotifyData")
 	--static void AddNotification(const char* key , const char* text , const char* tag , long firstDate);

	for _ ,v in pairs(self.recordNotify_arr) do

		if v.delayTime > 0  and  v.delayTime < maxTime then  

			NotifyHelper:addNotification(v.id,v.delayTime,v.ticker, v.title,v.conent)

			if device.platform  == "ios" then

				CCNative:AddNotification(tostring(v.id) ,tostring(v.conent), "once" , v.delayTime)

			end 

		end 

	end 
	
end

local OCCLASS_NAME = "AppController"
local ios ="ios"
function _M:setSendIosTokenCall()
    local ocClassName =  OCCLASS_NAME
    local ocMethodName = "sendIosToken"
    local ocParams = {
        callBack = function (token)
        				print("setSendIosTokenCall success////////////")
        				if token  then
        					local st_arr = global.tools:strSplit(token, ' ') 
        					print(token ,"token")
        					local deviceToken =  "" 
        					for _ , v in pairs(st_arr) do
        						deviceToken = deviceToken .. v 
        					end 
        					deviceToken = self:luaReomve(deviceToken , "<")
        					deviceToken = self:luaReomve(deviceToken , ">")

        					self.deviceTokenData  = {platformflat =ios  , token = deviceToken}  

        				end 
                    end,
    }
    gluaoc.callStaticMethod(ocClassName, ocMethodName, ocParams)
end


function _M:luaReomve(str,remove)  
    local lcSubStrTab = {}  
    while true do  
        local lcPos = string.find(str,remove)  
        if not lcPos then  
            lcSubStrTab[#lcSubStrTab+1] =  str      
            break  
        end  
        local lcSubStr  = string.sub(str,1,lcPos-1)  
        lcSubStrTab[#lcSubStrTab+1] = lcSubStr  
        str = string.sub(str,lcPos+1,#str)  
    end  
    local lcMergeStr =""  
    local lci = 1  
    while true do  
        if lcSubStrTab[lci] then  
            lcMergeStr = lcMergeStr .. lcSubStrTab[lci]   
            lci = lci + 1  
        else   
            break  
        end  
    end  
    return lcMergeStr  
end

local  test = {-1 , 35, 34} -- 保留所有的推送 

function _M:handlerOrderNotifyData() --相同id的推送消息 只保留一个
	-- dump(self.recordNotify_arr,"清理前数据")
	for _ ,v in pairs(self.recordNotify_arr) do
		v.delayTime =v.delayTime - (global.dataMgr:getServerTime() - v.record_time) 
		if v.delayTime > 0 then  
		else
			v.isvalid= -1 
		end 
	end

	for i = #self.recordNotify_arr, 1, -1 do
	   if self.recordNotify_arr[i].isvalid == -1 then 
			table.remove(self.recordNotify_arr, i)
		end 
	end
		
	local push_message = global.luaCfg:push_message() -- 同类中选取一个最小的
	for _ ,v in pairs(push_message) do 
		local temp = {} 
		for _ , vv  in pairs(self.recordNotify_arr) do 
			if vv.id == v.id then 
				table.insert(temp,vv)
			end 
		end

		if  global.EasyDev:CheckContrains(test , v.id) then --保留所有 

		else 
			table.sort(temp,function(A,B)   return A.delayTime < B.delayTime end)
			for index , v in pairs(temp) do  
				if index > 1 then 
					v.isvalid = -1 
				end 
			end
		end  
	end 

 
	if global.PushConfigData:getConfigData() then 
		for indxe ,v in pairs(self.recordNotify_arr) do
			for _ , vv  in pairs(global.PushConfigData:getConfigData()) do 
				if vv.id == v.type  and  not vv.status then
					 v.isvalid = -1 
				end 
			end 
		end
	end

	for i = #self.recordNotify_arr, 1, -1 do
	   if self.recordNotify_arr[i].isvalid  == -1 then 
			table.remove(self.recordNotify_arr, i)
		end 
	end

end 


function _M:cleanLocalNotify()


	self:log("清理通知----------------")

	NotifyHelper:cleanAllNotification()

	self:cleanIosAllNotification()

	self.recordNotify_arr = nil 

end


function _M:cleanIosAllNotification()

	if device.platform == "ios" then

		for _  , v in pairs(luaCfg:push_message())do 
			CCNative:CancelNotification(tostring(v.id))
		end 

		CCNative:CancelAllNotification()
	end 
end 


function _M:setClientLastPauseTime(time)
	self.last_pause_time  = time 
end 

function _M:getClientLastPauseTime()
	return 	self.last_pause_time
end 

function _M:setClientLastResumeTime(time)
	self.last_resume_time  = time 
end 

function _M:getClientLastResumeTime()
	local tm = self.last_resume_time
	return tm
end 

function _M:getBgDuration()
	if self.last_pause_time and self.last_resume_time then
		return (self.last_resume_time-self.last_pause_time)
	else
		return 0
	end
end 

function _M:ClientResume() -- 客户端继续回调
	-- 如果游戏没有暂停过 则没有 继续的说法
	if self.deveie_status ~= self.DEVEIE_STATUS.PAUSE then  return  end 
	self.deveie_status = self.DEVEIE_STATUS.RRSUME
	self.deveie_status = self.DEVEIE_STATUS.RUNING
	for i ,v in pairs(self.resume_call) do 
		if v and v.callnumber == self.call_number.infinite then 
			self:excuteClientResumeCall(v)
		elseif v and v.callnumber > 0 then 
			self:excuteClientResumeCall(v)
			v.callnumber =v.callnumber -1 
		elseif v and v.callnumber <= 0 then 
			table.remove(i,self.resume_call)
		end 
	end
end 
 
function _M:ClientPause() -- 客户端暂停回调
	-- 如果游戏不在运行中 则没有暂停的说法
	if 	self.deveie_status ~= self.DEVEIE_STATUS.RUNING then return end
	self.deveie_status = self.DEVEIE_STATUS.PAUSE
	for i ,v in pairs(self.pause_call) do 
		if v and v.callnumber== self.call_number.infinite then 
			self:excuteClientPauseCall(v)
		elseif v and v.callnumber > 0 then 
			self:excuteClientPauseCall(v)
			v.callnumber =v.callnumber -1 
		elseif v and v.callnumber <= 0 then 
			table.remove(i,self.pause_call)
		end 
	end 	
end

function _M:excuteClientPauseCall(v)
	if v.key == "sedClientStatusToServer" then 
		v.call(1)
	else
		v.call()
	end 
end 

function _M:excuteClientResumeCall(v)

	if v.key == "sedClientStatusToServer" then 
		v.call(0)
	else
		v.call()
	end 
end 


function _M:addClientPauseCall(key , callback , callnumber)
	if not  callnumber then  callnumber = self.call_number.infinite end 
	local call  ={}
	call.key = key
	call.call =callback 
	call.callnumber = callnumber
	table.insert(self.pause_call,call)
end 

function _M:delClientPauseCall(key)
	for k , v in pairs(self.pause_call) do 
		if v.key == key then 
			table.remove(k,self.pause_call)
		end 
	end 
end 

function _M:addClientResumeCall(key , callback, callnumber) 
	if not  callnumber then  callnumber = self.call_number.infinite end 
	local call  ={}
	call.key = key
	call.call =callback 
	call.callnumber = callnumber
	table.insert(self.resume_call,call)
end 

function _M:delClientResumeCall(key) 
	for k , v in pairs(self.resume_call) do 
		if  v.key == key  then 
			table.remove(k,self.resume_call)
		end 
	end 	
end 


function _M:unionHelpMsg(msg)
	self.helpMsg = msg 
end 
--  -    			 "lHelpTime" = 1502208776
-- [LUA-print] -     "tgBuild" = {
-- [LUA-print] -         "lEndTime"   = 1502226771
-- [LUA-print] -         "lID"        = 1
-- [LUA-print] -         "lLevel"     = 1
-- [LUA-print] -         "lState"     = 1
-- [LUA-print] -         "lTotleTime" = 21600

function _M:unionHelpLocalNotify()
	if self.helpMsg and self.helpMsg.lHelpTime then 
		local time  = self.helpMsg.lHelpTime  - global.dataMgr:getServerTime()
		if time > 0 then 
			self:recordNotifyData(31, time, global.dataMgr:getServerTime())
		end 
	end 
end 


function _M:troopMsg(msg)

	-- dump(msg ,"添加的士兵")

	self.troopmsgaArr =  self.troopmsgaArr or  {} 
	
	for i = #self.troopmsgaArr, 1, -1 do -- 清理时间 过期的数据
	   	if  self.troopmsgaArr[i].lAttackEndTime  - global.dataMgr:getServerTime() <  0  then 
			table.remove(self.troopmsgaArr, i)
		end 
	end

	for i = #self.troopmsgaArr, 1, -1 do -- 清理时间 相同id的数据
	   if  self.troopmsgaArr[i].lID  == msg.lID  then 
			table.remove(self.troopmsgaArr, i)
		end 
	end
 		
 	if msg.lAttackEndTime  and msg.lState  == 1  then  -- 行军中队伍加入

		table.insert(self.troopmsgaArr , msg)
 	end 

	-- dump(self.troopmsgaArr ,"出发的的士兵啊//////////")
end 

function _M:troopMsgLocalNotify()

	-- dump(self.troopmsgaArr ,"出发的的士兵啊//////////")
	if not self.troopmsgaArr then return end 
	for _ ,v in  ipairs(self.troopmsgaArr) do 

		if v.lAttackEndTime  then 
			local time  =v.lAttackEndTime  - global.dataMgr:getServerTime()

			if time > 0 then 
				self:recordNotifyData(35, time, global.dataMgr:getServerTime() , clone(v))
			end 
		end 
	end 

end 


global.ClientStatusData = _M

--endregion
