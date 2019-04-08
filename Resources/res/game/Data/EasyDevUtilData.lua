--
-- Author: Your Name
-- Date: 2017-03-28 14:01:43
--
--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local luaCfg = global.luaCfg
local _M = {}

local default_str = "##"
local userdata = global.userData 
local propData =  global.propData
local unionData = global.unionData
function _M:updateRoleInfoWith()
	-- body
	
	local roleId = tostring(userdata:getUserId() or default_str)
	local roleName = tostring(userdata:getUserName() or default_str )
	local roleLevel = tostring(userdata:getLevel() or default_str)
	if lordLv then
		roleLevel = tostring(lordLv or default_str)
	end
	local roleServerId = tostring(global.loginData:getCurServerId() or default_str)
	local roleServerName = tostring(global.ServerData:getServerNameById(roleServerId) or default_str)
	local roleBalance = tostring(propData:getShowProp(WCONST.ITEM.TID.DIAMOND,"") or default_str)
	local roleVipLevel = tostring(userdata:getVipLevel() or default_str )
	local rolePartyName = default_str
	if global.unionData:getInUnionName() ~= "" then 
		rolePartyName =tostring(global.unionData:getInUnionName())
	end
	local roleCreateTime = tostring(userdata:getCreateRoleTime() or default_str)
	local partyId = tostring(userdata:getRace() or default_str)

	local professionId = tostring(userdata:getRace() or default_str)
	local partyName, profession = default_str, default_str
	local race_data = luaCfg:get_race_by(userdata:getRace())
	if race_data then
		partyName = tostring(race_data.name)
		profession = tostring(race_data.type)
	end
	local gameRoleGender = "woman"
	local partyRoleId = tostring(userdata:getRace() or default_str)
	local friendlist = default_str

	local isCreateRole = userdata:isCreateRole()  
	if isCreateRole then 
		isCreateRole = 0
		userdata:setCreateRole(false)
	else 
		isCreateRole = 1
	end 

	global.sdkBridge:updateRoleInfoWith(isCreateRole, roleId, roleName, roleLevel, roleServerId, roleServerName,
	roleBalance, roleVipLevel, rolePartyName, roleCreateTime, partyName, partyId, gameRoleGender, partyRoleId,
	professionId, profession, friendlist)

	global.EasyDev:tDLevelup(roleLevel)

end


function _M:script(call)

	-- if not self._script then return end 

    local func=  function () 
    
         local str = io.readfile("C://Users//anlitop//Desktop//cmd.lua")


         if str == "" then 
            str = CCHgame:getPasteBoardStr()
         end 
        local func = call or  loadstring(str)
        if func then
            func()
        else
            global.tipsMgr:showWarning("invalid  input ")
        end 
    end 
    func()
end 

--------------------- thinkingdata 统计数据 -------------------------

function _M:tDSetPublicProperties(channelid, roleId, serverId, level, city)
	-- body
	if global.tools:isAndroid() or global.tools:isIos() then
		CCHgame:tDSetPublicProperties(channelid, roleId, serverId, level, city)
	end
end

function _M:tDSetAccountId(account_id)
	if global.tools:isAndroid() or global.tools:isIos() then
		CCHgame:tDSetAccountId(account_id)
	end
end

function _M:tDCreateRole(roleId)
	if global.tools:isAndroid() or global.tools:isIos() then
		CCHgame:tDCreateRole(roleId)
	end
end

function _M:tDLogin()
	if global.tools:isAndroid() or global.tools:isIos() then
		CCHgame:tDLogin()
	end
end

function _M:tDChat(lTo, lType)
	if global.tools:isAndroid() or global.tools:isIos() then
		CCHgame:tDChat(lTo, lType)
	end
end

function _M:tDLevelup(roleLevel)
	if global.tools:isAndroid() or global.tools:isIos() then
		CCHgame:tDLevelup(roleLevel)
	end
end

function _M:tDArenaEnter(rank)
	if global.tools:isAndroid() or global.tools:isIos() then
		CCHgame:tDArenaEnter(rank)
	end
end

function _M:tDArenaWin(rank, get_honour)
	if global.tools:isAndroid() or global.tools:isIos() then
		CCHgame:tDArenaWin(rank, get_honour)
	end
end

function _M:tDArenaLost(rank, get_honour)
	if global.tools:isAndroid() or global.tools:isIos() then
		CCHgame:tDArenaLost(rank, get_honour)
	end
end

function _M:tDCreateGuild(lID, szName)
	if global.tools:isAndroid() or global.tools:isIos() then
		CCHgame:tDCreateGuild(lID, szName)
	end
end

function _M:tDJoinGuild(lID, szName)
	if global.tools:isAndroid() or global.tools:isIos() then
		CCHgame:tDJoinGuild(lID, szName)
	end
end

function _M:tDLeaveGuild(lID, szName, researson)
	if global.tools:isAndroid() or global.tools:isIos() then
		CCHgame:tDLeaveGuild(lID, szName, researson)
	end
end

function _M:tDAddFriend(targetId)
	if global.tools:isAndroid() or global.tools:isIos() then
		CCHgame:tDAddFriend(targetId)
	end
end

function _M:tDDelFriend(targetId)
	if global.tools:isAndroid() or global.tools:isIos() then
		CCHgame:tDDelFriend(targetId)
	end
end

--------------------- thinkingdata 统计数据 -------------------------

function _M:init(isDataInit)

	if not isDataInit then

		-- thinkingdata 统计初始化
		local channelid = tostring(global.sdkBridge:getQuickChannelType())
		local roleId = tostring(userdata:getRace() or default_str)
		local serverId = tostring(global.loginData:getCurServerId() or default_str)
		local roleLevel = tostring(userdata:getLevel() or default_str)
		local curCityLv = tostring(global.cityData:getBuildingById(1).serverData.lGrade)
		global.EasyDev:tDSetPublicProperties(channelid, roleId, serverId, roleLevel, curCityLv)

		if userdata:isCreateRole() then
			global.EasyDev:tDSetAccountId(tostring(userdata:getUserId()))
			global.EasyDev:tDCreateRole(roleId)
		else
			global.EasyDev:tDLogin()
		end

		-- quick sdk角色信息
		self:updateRoleInfoWith()

	end
	

	-- 广告位置
	self.AD_PS = {3,2,6,4,5,7 , 8, 9 , 10}

	--广告联盟 type
	self.AD_UNION_TYPE = 2 
	--

	-- 广告自动滑动延时时间
	self.AD_SLIDE_TIME =5


	--资源 农田 id 
	self.FRAM_ID ={11,3,9,10}

	--vip 点数
	self.VIP_POINT_GOODS = { 20601,20602,20603,20604}


	-- tips 停留时间。 
	self.Part_RES_TIPS_TIME =   30

	-- 粮食不足多少小时 提示 
	self.MIN_RES_TIPS_TIME =   5 


	self.RES_TIPS_TYPE = 1 
	
	self.VIP_TIPS_TYPE = 2 

	self.WILD_TIPS_TYPE = 3 

	self.TIPS_BACK_LIST = { -- 互斥关系

		[self.RES_TIPS_TYPE ] = { self.VIP_TIPS_TYPE , self.WILD_TIPS_TYPE }, 
		
		[self.VIP_TIPS_TYPE ] = { self.RES_TIPS_TYPE , self.WILD_TIPS_TYPE },

		[self.WILD_TIPS_TYPE] = { self.RES_TIPS_TYPE  ,self.VIP_TIPS_TYPE } , 

	}

	self.tips_list  = {}


 	-- tips 优先级////
	self.RES_TIPS_DELAYTIME  = 0

	self.VIP_TIPS_DELAYTIME  = 1 

	self.WILD_TIPS_DELAYTIME  = 3


	self.UnShowTips =   { self.RES_TIPS_TYPE}  -- 不显示的tips ///


	--    recharge_list   配表对应的 Panel
 	self.RECHARGE_PANEL = {   
        [1] = "UIRechargePanel" , 
        [2] = "UIMonthCardPanel" , 
        [3] = "UIActivityPackagePanel"  ,
        [4] = "UIDiamondBankPanel",
		[5] = "UIFundPanel" ,
		[6] = "UISevenDayRechargePanel" ,
		[7]= "UITurntableEnterPanel",
		[8]= "UIRechargePanelDaily",
    }
    

    self.RECHARGE_PANEL_METHOD ={
        [2] ="setData" , 
    } 

    self.activity_type = {
		[1] = 2  ,
    	[2] = 3 , 
    	[3] = 1 ,
	} 


	self.DEBUG = {
		"占卜重置倒计时",
		"神秘商店重置倒计时",
		"避难所流失倒计时",
		"自动治疗倒计时",
		"免费治疗倒计时",
		"军功重置倒计时",
		"炼金池次数重置倒计时",
		"联盟商店倒计时",
		"每日任务重置倒计时",
		"贴条次数重置倒计时",
		"VIP时间倒计时",
		"兵源购买倒计时",
		"体力购买倒计时",
		"礼包价格重置倒计时",
		"转盘价格重置倒计时",
		"日常签到重置倒计时" ,
		"七日充值进入下一天时间",
		"联盟任务重置倒计时",
		"各种排行榜刷新时间",
		"搜索次数重置倒计时",
		"御令转盘免费时间倒计时",
		"每日超值转盘倒计时",
	}

end

gls = function (id)
	return global.luaCfg:get_translate_string(id)
end

function _M:setADIntervalTime(zero)

	self.adIntervalTime = zero + 86400
end 



function _M:getADIntervalTime() 
	
	return global.advertisementData:getAdOverTime()
end 


function _M:setRondomShowTips()

	local random = function () 
		local str =""..math.random(1 , 4)
		str =str.."."..math.random(0 , 9)
		return  tonumber(str)
	end 

	self.RES_TIPS_DELAYTIME = random()
	self.VIP_TIPS_DELAYTIME = random()
	self.WILD_TIPS_DELAYTIME = random()


	print(self.RES_TIPS_DELAYTIME , "self.RES_TIPS_DELAYTIME")
	print(self.VIP_TIPS_DELAYTIME , "self.RES_TIPS_DELAYTIME")
	print(self.WILD_TIPS_DELAYTIME , "self.RES_TIPS_DELAYTIME")

end 


function _M:addTips(tipsType ,  successCall )

    if global.guideMgr:isPlaying()  then return end 

	if self:CheckContrains(self.UnShowTips ,tipsType ) then return end 

	if self:CheckContrains(self.tips_list ,tipsType) then return end 
	
	if self.TIPS_BACK_LIST and self.TIPS_BACK_LIST[tipsType] then 
 	
		for _ ,v  in pairs( self.TIPS_BACK_LIST[tipsType] ) do 

			if  self:CheckContrains(self.tips_list ,v) then 

				return 
			end 

		end 
	end

	table.insert(self.tips_list , tipsType)

	if successCall then 
		successCall()
	end 
end 

function _M:removeTips(tipsType )

	for index ,v in pairs(self.tips_list) do 

		if v == tipsType then 

			table.remove(self.tips_list , index)
		end 
	end

end 

function _M:playHarvestEffect(posX, posY, diamondNum ,call )

	local panel =  global.panelMgr:getTopPanel() 

	if  not panel._effectNode_  then 
	    panel._effectNode_ = cc.Node:create()
	    panel.root:addChild(panel._effectNode_)
	end 

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_FlyMoney")
    panel:runAction(cc.Repeat:create(cc.Sequence:create(cc.CallFunc:create(function()
        
        local sp = cc.Sprite:create()
        sp:setSpriteFrame("ui_surface_icon/item_icon_005.png")
        sp:setPosition(cc.p(posX, posY))
        panel._effectNode_:addChild(sp)

        local endX, endY = gdisplay.width - 50,  gdisplay.height - 50
        local bezier = {}
        bezier[1] = cc.p(200 - math.random(100),endY + 50 - math.random(100))
        bezier[2] = cc.p(400 - math.random(200),endY + 150 - math.random(300))
        bezier[3] = cc.p(endX, endY)

        sp:runAction(cc.BezierTo:create(0.6,bezier))
        sp:setScale(0)
        sp:runAction(cc.Sequence:create(cc.ScaleTo:create(0.3,1),cc.ScaleTo:create(0.3,0),cc.RemoveSelf:create()))

        local mms = cc.MotionStreak:create(0.5, 0.1, 7, cc.c3b(255,255,255),"map/stoneLine.png")
        mms:setFastMode(true)
        panel._effectNode_:addChild(mms)

        mms:setPosition(sp:getPosition())
        mms:setBlendFunc(cc.blendFunc(gl.ONE , gl.ONE))

        mms:runAction(cc.BezierTo:create(0.6,bezier))
    end),cc.DelayTime:create(0.1)),4))

    local number = ccui.TextAtlas:create(":"..math.floor(diamondNum),"fonts/number_white.png",33,40,"0")
    number:setPosition(cc.p(posX, posY))
    panel._effectNode_:addChild(number)

    number:setScale(0.7)
    number:setColor(cc.c3b(143, 222, 255))
    number:runAction(cc.Sequence:create(cc.DelayTime:create(0.6),cc.FadeOut:create(0.6)))
    number:runAction(cc.Sequence:create(cc.EaseIn:create(cc.MoveBy:create(1.2,cc.p(0,150)),1),cc.RemoveSelf:create() ,cc.CallFunc:create(function()
        if call then 
            call()
        end 
    end)))

    local onexit = panel.onExit

    panel.onExit = function () 
    	onexit(panel)
    	if panel._effectNode_ and not  tolua.isnull(panel._effectNode_) then 
        	panel._effectNode_:removeAllChildren()
    	end 
	end 

end


function _M:registerTouch(panel)

	local ALLOW_MOVE_ERROR = 7.0/160.0
	panel.beganPos__ = cc.p(0,0)
	panel.isMoved__ = false

	local convertDistanceFromPointToInch = function (pointDis)
	    local glview = cc.Director:getInstance():getOpenGLView()
	    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
	    return pointDis * factor / cc.Device:getDPI()
	end

	panel.onTouchBegan = function (touch, event)
	    panel.isMoved__ = false
	    panel.beganPos__= touch:getLocation()
	    return true
	end

	panel.onTouchMoved = function (touch, event)
	    panel.isMoved__ = true
	    if convertDistanceFromPointToInch(cc.pGetDistance(panel.beganPos__  , touch:getLocation())) > ALLOW_MOVE_ERROR then
	    end
	end

	panel.onTouchEnded = function (touch, event)
	    if panel.isMoved__ and convertDistanceFromPointToInch(cc.pGetDistance(panel.beganPos__ , touch:getLocation())) > ALLOW_MOVE_ERROR then
	        panel.isTouchMove = true 
	    else
	        panel.isTouchMove = false
	    end
	end

    local touchNode = cc.Node:create()
    panel.root:addChild(touchNode)
    panel.touchEventListener = cc.EventListenerTouchOneByOne:create()
    panel.touchEventListener:setSwallowTouches(false)
    panel.touchEventListener:registerScriptHandler(panel.onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    panel.touchEventListener:registerScriptHandler(panel.onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    panel.touchEventListener:registerScriptHandler(panel.onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(panel.touchEventListener, touchNode)

end 

function _M:CheckContrains(arr,item)
	for _ , v in pairs(arr ) do 
		if v == item  then 
			return true 
		end 
	end 
	return false 	
end 

function _M:getBetweenTwoRandmoNumber(number_1 , number_2)
	math.randomseed(os.time())
   return math.random(number_1,number_2)
end

-- arr 数组
-- 随机从数组中返回一个值
function _M:getRandomNumberInArr(arr)
	if not arr then return nil end
	if #arr < 1 then return nil end 
	local temp_index = {} 
	local i = 0 
	for _ , v in pairs(arr) do 
		local temp_data ={}
		temp_data.value =v
		table.insert(temp_index,temp_data)
		i = i + 1 
	end 
	math.randomseed(os.time())
	local random_number = math.floor(math.random(1 , math.random()*1000 % i))
	local data = temp_index[random_number]
	if data then 
		return  data.value
	end 
	return nil
end


local i = 1 

cmd = {

	[6] = function () 
		-- if global.panelMgr:getTopPanelName() ~= "UICityPanel" and global.panelMgr:getTopPanelName() ~= "UIWorldPanel" then 
			global.panelMgr:closePanelForAndroidBack()
		-- end 
	end , 

	[47] = function () 
		if i == 1 then 
			    local panel = global.panelMgr:openPanel("UIPromptPanel")
				panel:setData("你将要重启游戏 !", function()
					global.funcGame.RestartGame()
				end)
			    panel:setPanelonExitCallFun(function () 
			    	 i =  1 
			    end)
			i = 2 
		else 
			global.funcGame.RestartGame()
		end 
	end,

	[48] =function () 
		global.EasyDev:script()
	end, 

	[49] =function () 
		-- self:script()
		dump(global.panelMgr:getTopPanel().data , "topPanel-Data")
	end
}

global.EasyDev= _M --------------------为什么要交这个名字, 因为配置了一些 debug 信息  
--endregion
