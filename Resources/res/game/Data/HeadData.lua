--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local global = global
local luaCfg  = global.luaCfg

local _M = {
    allHead = {},
    m_isSdefine = false,
    m_SdeMd5 = "",
    sdefineDefaultPath = "mine_90086357_definePortrait.png",
    sdefinePath = "mine_90086357_definePortrait.png",
    sdefineZipPath = "mine_90086357_defineZips.zip",
    m_lCustomIcoCount = 0 , 
    m_androidAssetPath = nil
}


function _M:init(szCustomIco)  
    

    if global.tools:isAndroid() then
        local ss = gluaj.callGooglePayStaticMethod("getAssetsPath",{},"()Ljava/lang/String;")
        self.m_androidAssetPath = ss
        self.sdefineDefaultPath = ss.."/mine_90086357_definePortrait.png"
        self.sdefinePath = ss.."mine_90086357_definePortrait.png"
        self.sdefineZipPath = ss.."/mine_90086357_defineZips.zip"
    end
	self:initSdefineHead(szCustomIco)
    if self.allHead and table.nums(self.allHead) > 0 then
    else
		self:initData()
	end

end

-- 普通、士兵、传说、史诗、稀有
function _M:initData()
	local raceId = global.userData:getRace()
    local roldHeadData = luaCfg:rolehead()
    local data = {[1]={}, [2]={}, [3]={}, [4]={}, [5]={}, } 

    for _,v in pairs(roldHeadData) do
        
        v.state = 0		-- 选择状态
        v.useState = 0	-- 是否可以使用状态
        if v.id == global.userData:getlUserPic() then
        	v.state = 1
        end
        if v.race == 0 and v.type == 1 then
            table.insert(data[1], v)
        elseif v.race == raceId and v.type == 2 then
            table.insert(data[2], v)
        elseif v.race == 0 and v.type == 6 then
            table.insert(data[3], v)
        elseif v.race == 0 and v.type == 3 then
        	table.insert(data[4], v)
        elseif v.race == 0 and v.type == 4 then
        	table.insert(data[5], v)
        end
    end

    for _,v in pairs(data) do
        table.sort(v, function(s1, s2) return s1.order < s2.order end )
    end

    self.allHead = data

    self:refershUseState()
    self:sortData()

end


function _M:setlCustomIcoCount(s)
	self.m_lCustomIcoCount = s or 0
end

function _M:isSdefineCanfree()
	return self.m_lCustomIcoCount < 1
end

function _M:getlCustomIcoCount()
	return self.m_lCustomIcoCount
end


local app_cfg = require("app_cfg")
local crypto   = require "hqgame"
function _M:initSdefineHead(szCustomIco)
	self.m_SdeMd5 = szCustomIco or ""
	if not self.m_SdeMd5 or self.m_SdeMd5 == "" then
		self.m_isSdefine = false
	else
		self.m_isSdefine = true
		self.sdefinePath = self:getSdefineDownloadPath(self.m_SdeMd5)
	end	
end

function _M:getPortraitPath()
	if cc.FileUtils:getInstance():isFileExist(self.sdefinePath) then
		return self.sdefinePath
	end
	return self.sdefineDefaultPath
end

function _M:downloadPngzips(md5s)
	if not md5s then
		return
	end
	-- local md5s = {md5s[1]}
	local tempstr = ""
	for i,v in pairs(md5s) do
		if v~= "" and not cc.FileUtils:getInstance():isFileExist(self:getSdefineDownloadPath(v)) then
			if tempstr == "" then
				tempstr = v
			else
				tempstr = tempstr .."|" .. v
			end
		end
	end

	if tempstr == "" then
		return
	end
    local url = app_cfg.get_serverlist_url()
    url = string.gsub(url,"verify.php","ico/download.php?")
	url = url.."filename="..tempstr.."&iszip=1&sid="..global.loginData:getCurServerId()
    local sdefineZipPath = string.gsub(self.sdefineZipPath,"_90086357_",string.format("_%s_",os.time()))
    url = gnetwork.encodeURI(url)
    print("downloadPngzips-->---------------<",url)
	CCHgame:downloadFile(url, sdefineZipPath)
	return sdefineZipPath
end

function _M:addDownLoadCall(root,storagePath,callback)
	if not storagePath then return {} end
    local listener = cc.EventListenerCustom:create(storagePath.."_FILEWRITE_SUCCESS",function() 
        print("文件下载成功/////////////////////")

        if cc.FileUtils:getInstance():isFileExist(storagePath) then
            local dstpath = global.headData:getSdefineDownloadPath()
            if CCHgame:unzipfile(cc.FileUtils:getInstance():fullPathForFilename(storagePath),dstpath,"") then
                -- gevent:call(global.gameEvent.EV_ON_UI_DOWNLOADFILE_REFRESH_OTHERHEAD)
                if callback then callback() end
            else
                print("error:解压文件失败-----?dstpath=",dstpath.."---storagePath="..storagePath)
            end
        end
    end)
    local listener1=  cc.EventListenerCustom:create(storagePath.."_DOWNLORD_ERROR",function() 
        print("下载出错/////////////////////")

    end)
    local listener2 =  cc.EventListenerCustom:create(storagePath.."_DOWNLORD_SUCCESS",function() 
        print("数据下载成功////////////////////")
    end)
    local listener3=  cc.EventListenerCustom:create(storagePath.."_DOWNLORDING",function(prent) 
        dump(tonumber(prent), "数据下载中。")
    end)
    local eventDispatcher =root:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,root)
    local eventDispatcher =root:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener1,root)
    local eventDispatcher =root:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener2,root)
    local eventDispatcher =root:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener3,root)

    return {listener,listener1,listener2,listener3}
end

function _M:convertHeadData(data,head)
	local tempHead = clone(head)
	if data and data.szCustomIco and data.szCustomIco ~= "" then
		local newPath = self:getSdefineDownloadPath(data.szCustomIco)
        if cc.FileUtils:getInstance():isFileExist(newPath) then
			tempHead.path = newPath
        end
		return tempHead
	else
		return tempHead
	end
end

function _M:getSdefineDownloadPngPath(name)
	local path = cc.FileUtils:getInstance():getWritablePath().."sdefinePortrait/"

    if not cc.FileUtils:getInstance():isDirectoryExist(path) then
        cc.FileUtils:getInstance():createDirectory(path)
    end
    if md5 then
    	path = string.format("%s%s",path,name)
    end
	return path
end

function _M:getSdefineDownloadPath(md5)
	local path = cc.FileUtils:getInstance():getWritablePath().."sdefinePortrait/"

    if global.tools:isAndroid() then
        if not self.m_androidAssetPath then
        	self.m_androidAssetPath = gluaj.callGooglePayStaticMethod("getAssetsPath",{},"()Ljava/lang/String;")
        end
        local ss = self.m_androidAssetPath
        path = ss.."/sdefinePortrait/"
    end


    if not cc.FileUtils:getInstance():isDirectoryExist(path) then
        cc.FileUtils:getInstance():createDirectory(path)
    end
    if md5 then
    	path = string.format("%s%s.png",path,md5)
    end
	return path
end

function _M:setSdefineHead(szCustomIco)
	self.m_SdeMd5 = szCustomIco

	if not self.m_SdeMd5 or self.m_SdeMd5 == "" then
		self.m_isSdefine = false
	else
		self.m_isSdefine = true
		self.sdefinePath = self:getSdefineDownloadPath(self.m_SdeMd5)
	end	

	print("-------->",self.m_SdeMd5)
	print("-------->",self.m_isSdefine)
	gevent:call(global.gameEvent.EV_ON_USER_FLUSHUSEMSG)
end

function _M:getSdefineHead()
	return self.m_SdeMd5
end

function _M:getAllHead()
	
	return self.allHead
end

function _M:isSdefineHead()
	return self.m_isSdefine
end

function _M:getCurHead(noUse)
	if self:isSdefineHead() and not noUse and cc.FileUtils:getInstance():isFileExist(self:getPortraitPath()) then
		local data = {state = 0,useState = 0,path = self:getPortraitPath(),id = 9999999}
		local t_data = luaCfg:get_rolehead_by(101)
		data.scale = t_data.scale
		data.scale1 = t_data.scale1
		data.scale2 = t_data.scale2
		return data
	end

	for i=1,#self.allHead do
		for _,v in pairs(self.allHead[i]) do
			if v.state == 1 and v.useState == 1 then
				return v
			end
		end
	end

	-- 当前没有选择头像，默认系统头像
	local race = luaCfg:get_race_by(global.userData:getRace() or 1)
	if race then
    	return self:refershHeadState(race.head)
    end
end

function _M:getCurHeadStateById(id,noUse)
	if self:isSdefineHead() and not noUse and cc.FileUtils:getInstance():isFileExist(self:getPortraitPath()) then
		local data = {state = 0,useState = 0,path = self:getPortraitPath(),id = 9999999}
		local t_data = luaCfg:get_rolehead_by(101)
		data.scale = t_data.scale
		data.scale1 = t_data.scale1
		data.scale2 = t_data.scale2
		return data
	end

	for i=1,#self.allHead do
		for _,v in pairs(self.allHead[i]) do
			if v.id == id then
				return v
			end
		end
	end
end

-- 建筑状态变化修改使用状态
function _M:refUseStateByBuildId(buildId)

	local buildingType = luaCfg:get_buildings_pos_by(buildId).buildingType
	for i=1,#self.allHead do
		for _,v in pairs(self.allHead[i]) do
			if v.triggerType == 1 and v.triggerId == buildingType then 
				v.useState = 1
			end
		end
	end
	self:sortData()
	gevent:call(global.gameEvent.EV_ON_USER_FLUSHUSEMSG)
end

function _M:refershUseState()

	for i=1,#self.allHead do
		for _,v in pairs(self.allHead[i]) do
			
			if v.triggerType == 0 then
				v.useState = 1
			elseif v.triggerType == 1 then
				v.useState = self:getCurUseStateType1(v.triggerId)
			elseif v.triggerType == 2 then
				v.useState = self:getCurUseStateType2(v.triggerId)
			end
		end
	end
end

-- 建筑触发
function _M:getCurUseStateType1(buildingType)
	
	local useState = 0
	local registerBuild = global.cityData:getRegistedBuild()

    for _,v in pairs(registerBuild) do
        if v.buildingType == buildingType then
            useState = 1
        end
    end
    return useState
end

-- 英雄触发
function _M:getCurUseStateType2(heroId)

	local useState = 0
	local hero = global.heroData:getGotHeroData()

    for _,v in pairs(hero) do
        if v.heroId == heroId then
            useState = 1
        end
    end
    return useState
end

function _M:refershHeadState(id)
	local data = {}
	for i=1,#self.allHead do
		for _,v in pairs(self.allHead[i]) do
			
			if v.id == id then
				v.state = 1 
				data = v
			else
				v.state = 0
			end
		end
	end
	
	gevent:call(global.gameEvent.EV_ON_USER_FLUSHUSEMSG)
	return data
end

function _M:sortData()

	function sortFunc(a, b)
        if a.useState == b.useState then
            return a.order < b.order
        else
            return a.useState > b.useState
        end
    end

	for i=1,#self.allHead do		
		table.sort( self.allHead[i], sortFunc)
	end

 end 
 

global.headData = _M

--endregion
