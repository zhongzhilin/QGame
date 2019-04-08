--
-- Author: Your Name
-- Date: 2017-04-08 11:22:45
--
local gameReq = global.gameReq
local msgpack = require "msgpack"
local cjson = require "base.pack.json"

local _M = {mtimeout =15}

function _M:SimpleHttpCall(url, method, dictionaryData,transFormat,resqonseCall )
    local callmethod = method or "GET"
    local data = dictionaryData or {} 
    local finishcall  = finishCall  or function() end 
    local transformat = transFormat or 'json'
    local resqonsecall = resqonseCall
    local requesturl = url
    local ischeckspace = data.ischeckspace
    data.ischeckspace = nil
    local postdata = nil 
    if callmethod =="GET" then
        requesturl =requesturl..'?'
        for k ,v in pairs(data) do
            if ischeckspace and type(v) == "string" then
                v = string.gsub(v," ","-")
            end
            requesturl =requesturl..'&'..k..'='..v
        end  
    elseif callmethod =="POST" then
        if  transformat == 'json' then 
             postdata = json.encode(dictionaryData)
        elseif  transformat =='' then 
            return -- 暂不支持其他格式 
        end 
    end
    local request = nil
    local function onRequestFinished(event)

        print("=======> event: "..event.name)

        -- local request = event.request
        if event.name == "inprogress" then
        	return 
        elseif event.name == "failed" then
            print("--------->,http simplehttp--requesturl=",requesturl)
            if global.panelMgr:isPanelTop("UIMaintancePanel") then
            else
                global.tipsMgr:showQuitConfirmPanelNoClientNet()
            end
        elseif event.name == "completed" then  

            if cjson.decode(request:getResponseData()) then 
    	        local retCode = cjson.decode(request:getResponseData()).ret
                if retCode ~= 0 then
                    event.name = "failed"
                end
            end 

            log.trace("---->http call requesturl=%s, respone =%s",requesturl,vardump(cjson.decode(request:getResponseData())))
	        resqonsecall(request,event.name)
        end 
    end

    print("->http requesturl：　"..requesturl)
    request = gnetwork.createHTTPRequest(onRequestFinished, requesturl, method)
    if callmethod =="POST"  then request:setPOSTData(postdata, #postdata) end 
    request:addRequestHeader("Content-Type:application/text")
    request:setTimeout(self.mtimeout)
    request:start()
end 

global.SimpleHttpAPI = _M
