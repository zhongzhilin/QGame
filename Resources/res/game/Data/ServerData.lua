--
-- Author: Your Name
-- Date: 2017-04-07 22:03:08
--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local _M = {}
local luaCfg = global.luaCfg
-- local json    = require "json"
local cjson = require "base.pack.json"
local crypto  = require "hqgame"
local app_cfg = require "app_cfg"

 _M.unicode_encoded=1 

function _M:init()
	
	self.serverList ={} 

	self:setURL(app_cfg.get_serverlist_url())
	self:setMethod(app_cfg.server_list_method)
	self:setTransFormat(app_cfg.server_list_transformat)
	self:setDictionaryData(app_cfg.server_list_dictionarydata)
	self:setPW(app_cfg.server_list_pw)
	self:addDictionaryData("lang" , global.languageData:getCurrentLanguage())
  -- self:setEncoded(self.unicode_encoded)
  -- self:requestServerList()

 end

function _M:requestServerList(call,minSvrid)
	self.m_call = call
	if minSvrid then
		self:addDictionaryData("min",minSvrid)
	end
    global.SimpleHttpAPI:SimpleHttpCall(self.url,self.method,self:getDictionaryData(),self.transFormat ,handler(self,self.baseResqonseCall))
end

function _M:baseResqonseCall(request,status)
	if self.resqonseCall  then 
		self.resqonseCall(request,status)
		self.resqonseCall = nil 
	end
	if status=="failed" then 

		self.serverList = {} 
		
	else 
		local responsedata = request:getResponseData()
	    if responsedata then 
	       for _ ,v in pairs(cjson.decode(responsedata).param or {}) do
	       		local isExit = false 
				for ii, vv in pairs(self.serverList) do 
					if tonumber(vv.serverid) == tonumber(v.serverid) then 	
		       			isExit = true
		       			table.assign(self.serverList[ii],v)
		       			break
					end
				end 	       	
				if not isExit then
		       		table.insert(self.serverList , v)
				end 
	       end 
	  	end

	  	-- dump(self.serverList  ,"self.serverList ")
	end 
	if self.m_call then self.m_call(status) end 
end

function _M:setEncoded(encoded)
    self.encoded = encoded
end 

function _M:setResqonseCall(finishcall )
	self.resqonseCall =	finishcall 
end 

function _M:setCode(code)
	self.code  =  code or self.code 
end

function _M:setpartner_id(partner_id)
	self.partner_id  =  partner_id 
end

function _M:getCode()
	return self.code 
end 

function _M:getpartner_id()
	return self.partner_id 
end

function _M:addDictionaryData(key , value )
	if self.dictionaryData  then 
		self.dictionaryData[key] = value 
	end 
end 

function _M:setDictionaryData(data, isGet)
	self.dictionaryData = data or {code='list',sn=nil,sc=nil,partner_id=1}
	self:setCode(self.dictionaryData.code)

	if not isGet then
		self:setpartner_id(self.dictionaryData.partner_id)
	else
		self:setpartner_id(0)
	end
end

function _M:getDictionaryData()
	local original = gdevice.getOpenUDID()
    local fake = global.sdkBridge:getMD5Passport()
	self.dictionaryData.sn = original
	self.dictionaryData.sc = fake
	self.dictionaryData.code = self:getCode()
	if self:getpartner_id() ~= 0 then
		self.dictionaryData.partner_id = self:getpartner_id()
	end
	return self.dictionaryData
end 

function _M:setURL(url)
	self.url = url or app_cfg.get_serverlist_url()
end 

function _M:setPW(pw)
	self.pw  = pw or "c7802D62fbbd35e3*("
	-- self.pw  = "yanzhen"
end 

function _M:getPW()
	return self.pw 
end 

function _M:setMethod(method)
	self.method = method or "GET"
end 

function _M:setTransFormat(format)
	self.transFormat = format or "json"
end 

function _M:reLoadSeverList(finishCall)
	self:setresqonseCall(finishCall)
	self:requestServerList()
end

-- "image"      = "www.baidu.com"
-- "ip"         = "192.168.10.112:1036"
-- "isfirst"    = "1"
-- "language"   = "1"
-- "serverid"   = "2"
-- "servername" = "内网开发服"
-- "status"     = "0"
function _M:getSeverList()
	return  self.serverList or {}
end

function _M:hasServerList()
	return self.serverList and (#self.serverList>0)
end

function _M:getServerNameById(id)
	for _ ,v in pairs(self.serverList) do 
		if v.serverid == id then 
			return v.servername 
		end 
	end 
	return ""
end 

function _M:getServerDataBy(svrId)
	-- dump(self.serverList)
	local t_svrId = svrId or global.loginData:getCurServerId()
	print(t_svrId)
	if not t_svrId then		
        return nil
	end
	if not self.serverList then
		return nil
	end
    for _,v in pairs(self.serverList) do
        if tonumber(v.newsvrid) == tonumber(t_svrId) then
        	if v.url and v.url ~= "" then
			    local spstrs = string.split(v.ip, ":")    
			    local addr = spstrs[1]
			    local port = toint(spstrs[2])
    			v.ip = string.format("%s:%s",v.url,port)
        	end
        	return v
        end
    end

	return self:getFirstSvrData()
end

function _M:isInServerList(svrId)
	local firId = nil
	local isfind = false
	for _ ,v in pairs(self.serverList) do
        if tonumber(v.newsvrid) == tonumber(svrId) then
			isfind = true
		end 

		if tonumber(v.isfirst) == 1 then 
			firId = v.newsvrid
		end 
	end 

	return isfind,firId
end 

function _M:getFirstSvrData()
	for _ ,v in pairs(self.serverList) do 
		if tonumber(v.isfirst) == 1 then 
			return v
		end 
	end 
	return nil
end 

function _M:isSvrCanLogin(svrData)

	if not svrData.status then return true end
    if _CPP_RELEASE == 1 then
    	-- if tonumber(svrData.serverid) == 8 then return true end
    	return ((tonumber(svrData.status) ~= WCODE.SERVER_STATE_CLOSED) or svrData.dop or self:isIosCheckSvr(svrData.check) or (_DEBUG_SERVER and _DEBUG_SERVER == 999))
    else
    	return (tonumber(svrData.status) ~= WCODE.SERVER_STATE_OK)
    end
end

-- 检测是否合服
function _M:checkMergeServer(severId)
	local svrData = self:getServerDataBy(id)
	if tonumber(svrData.serverid) == tonumber(svrData.newsvrid) then
		return false
	else
		return svrData
	end
end
function _M:isIosCheckSvr(check)
	if _CPP_RELEASE ~= 1 then
		return false
	end
	return (check and global.tools:isIos() and (tonumber(check) <= tonumber(CCNative:getBuildVersion())))
end
function _M:isIosChecking(defaultSelectSeverId)
	if not self.serverList then return nil end
	for _ ,v in pairs(self.serverList) do 
		if self:isIosCheckSvr(v.check) then 
			return v.newsvrid
		end 
	end 
	return nil
end

function _M:isIosSvrCanRecharge(id)
	local svrData = {}
	if type(id) == "table" then
		svrData = id
	else
		svrData = self:getServerDataBy(id)
	end

    return tonumber(svrData.no_off) ~= 0
end

-- 上传lua报错信息
local lastMd5Key = ""
function _M:postErrorLog(errorMsg)
	if not errorMsg or errorMsg == "" or global.tools:isWindows() then
		return
	end
    errorMsg = string.gsub(errorMsg,"'","#")
    --print("enter postErrorLog(errorMsg)="..errorMsg)
    local md5Key = crypto.md5(string.gsub(errorMsg,"%d+",""), false)
    if string.find(lastMd5Key,md5Key..";") then
    	return
    end
    lastMd5Key = lastMd5Key..md5Key..";"
    --print("start postErrorLog(errorMsg)")
	-- body
	local sev_id = (global.loginData:getCurServerId() or 0)
    local app_cfg = require "app_cfg"
    local url = app_cfg.get_plat_url().."ReportErrorLog/UploadErrorlog.php"
	local postFinishCall = function (event)

		if event.name == "inprogress" then 
        elseif event.name == "failed" then
            print(" <----  POST ERRORMSG failed!  ---->")
        elseif event.name == "completed" then  	        
            print(" <----  POST ERRORMSG success! ---->")    	    
        end 
	end
    local request = gnetwork.createHTTPRequest(postFinishCall, url, "POST", true)
    request:addRequestHeader("Content-Type:text/html")

    local req = {
    	userId = global.userData:getUserId(),
    	sev_id = sev_id,
    	version= GLFGetAppVerStr(),
    	dev_id = gdevice.getOpenUDID(),
    	useMem = global.funcGame:getUseMemMB(),
    	md5 = md5Key,
    	LUA_ERROR = errorMsg,
    }
    dump(req)

    postdata = cjson.encode(req)
    request:setPOSTData(postdata, #postdata)
    request:setTimeout(15)
    request:start()
	
	-- local logFilePath = "log/log.txt"    
 --    gnetwork.uploadFile(function(evt)
 --            if evt.name == "completed" then
 --                local request = evt.request
 --                printf("REQUEST getResponseStatusCode() = %d", request:getResponseStatusCode())
 --                printf("REQUEST getResponseHeadersString() =\n%s", request:getResponseHeadersString())
 --                printf("REQUEST getResponseDataLength() = %d", request:getResponseDataLength())
 --                printf("REQUEST getResponseString() =\n%s", request:getResponseString())
 --            end
 --        end,
 --        url,
 --        {
 --            fileFieldName=logFilePath,
 --            filePath=gdevice.writablePath..logFilePath,
 --            contentType="Content-Type:text/html",
 --            extra={
 --                {"userId", global.userData:getUserId()},
 --                {"sev_id", global.loginData:getCurServerId()},
 --                {"version", GLFGetAppVerStr()},
 --                {"dev_id", gdevice.getOpenUDID()},
 --            }
 --        }
 --    )
end

global.ServerData = _M

--endregion
