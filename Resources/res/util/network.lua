
local network = {}

--[[--

检查地 WIFI 网络是否可用

提示： WIFI 网络可用不代表可以访问互联网。

@return boolean 网络是否可用

]]
function network.isLocalWiFiAvailable()
    return CCNetwork:isLocalWiFiAvailable()
end

--[[--

检查互联网连接是否可用

通常，这里接口返回 3G 网络的状态，具体情况与设备和操作系统有关。 

@return boolean 网络是否可用

]]
function network.isInternetConnectionAvailable()
    return CCNetwork:isInternetConnectionAvailable()
end

--[[--

检查是否可以解析指定的主机名

~~~ lua

if network.isHostNameReachable("www.google.com") then
    -- 域名可以解析
end

~~~

注意： 该接口会阻塞程序，因此在调用该接口时应该提醒用户应用程序在一段时间内会失去响应。 

@return boolean 主机名是否可以解析

]]
function network.isHostNameReachable(hostname)
    if type(hostname) ~= "string" then
        echoError("network.isHostNameReachable() - invalid hostname %s", tostring(hostname))
        return false
    end
    return CCNetwork:isHostNameReachable(hostname)
end

--[[--

返回互联网连接状态值

状态值有三种：

-   kCCNetworkStatusNotReachable: 无法访问互联网
-   kCCNetworkStatusReachableViaWiFi: 通过 WIFI
-   kCCNetworkStatusReachableViaWWAN: 通过 3G 网络

@return string 互联网连接状态值

]]
function network.getInternetConnectionStatus()
    return CCNetwork:getInternetConnectionStatus()
end

local specialchars = {"#","|","+"," "}
function network.decodeURI(s)
    s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return s
end

function network.encodeURI(s)
    print("----asdfasdfasdf.>>>>",s)
    for _,v in pairs(specialchars) do
        print(v)
        -- 需要用%进行转义
        -- if v == "+" then
        --     s = string.gsub(s, v, "%%2B")
        -- else
        s = string.gsub(s, v, "%"..string.format("%%%02X", string.byte(v)))
        -- end
    end
    return s
end

--[[--

创建异步 HTTP 请求，并返回 CCHTTPRequest 对象。 

~~~ lua

function onRequestFinished(event)
    local ok = (event.name == "completed")
    local request = event.request
 
    if not ok then
        -- 请求失败，显示错误代码和错误消息
        print(request:getErrorCode(), request:getErrorMessage())
        return
    end
 
    local code = request:getResponseStatusCode()
    if code ~= 200 then
        -- 请求结束，但没有返回 200 响应代码
        print(code)
        return
    end
 
    -- 请求成功，显示服务端返回的内容
    local response = request:getResponseString()
    print(response)
end
 
-- 创建一个请求，并以 POST 方式发送数据到服务端
local url = "http://www.mycompany.com/request.php" 
local request = network.createHTTPRequest(onRequestFinished, url, "POST")
request:addPOSTValue("KEY", "VALUE")
 
-- 开始请求。当请求完成时会调用 callback() 函数
request:start()

~~~

@return CCHTTPRequest 结果

]]
function network.createHTTPRequest(callback, url, method, noRet, isSkip)

    if not method then method = "GET" end
    if string.upper(tostring(method)) == "GET" then
        method = kCCHTTPRequestMethodGET
    else
        method = kCCHTTPRequestMethodPOST
    end

    local function onRequestFinished(event)
        -- print("----------------->event")
        -- dump(event)
        -- print(event.request:getResponseData())
        -- local retData = json.decode(event.request:getResponseString())
        -- dump(retData)
        if event.name == "failed" and not noRet then
            if global.panelMgr:isPanelTop("UIMaintancePanel") then
            else
                global.tipsMgr:showQuitConfirmPanelNoClientNet()
            end
        end
        if callback then callback(event) end
    end
    -- if not isSkip then
    --     url = string.gsub(url,"+","%%2B")
    -- end
    if not global.tools:isIos() then
        string.gsub(url,"https:","http:")
    end
    url = network.encodeURI(url)
    print("decode url----->",url)
    return CCHTTPRequest:createWithUrl(onRequestFinished, url, method)
end

--- Upload a file through a CCHTTPRequest instance.
-- @author zrong(zengrong.net)
-- Creation: 2014-04-14
-- @param callback As same as the first parameter of network.createHTTPRequest.
-- @param url As same as the second parameter of network.createHTTPRequest.
-- @param datas Includes following values:
--      fileFiledName(The input label name that type is file);
--      filePath(A absolute path for a file)
--      contentType(Optional, the file's contentType, default is application/octet-stream)
--      extra(Optional, the key-value table that transmit to form)
-- for example:
--[[
    network.uploadFile(function(evt)
            if evt.name == "completed" then
                local request = evt.request
                printf("REQUEST getResponseStatusCode() = %d", request:getResponseStatusCode())
                printf("REQUEST getResponseHeadersString() =\n%s", request:getResponseHeadersString())
                printf("REQUEST getResponseDataLength() = %d", request:getResponseDataLength())
                printf("REQUEST getResponseString() =\n%s", request:getResponseString())
            end
        end,
        "http://127.0.0.1/upload.php",
        {
            fileFieldName="filepath",
            filePath=device.writablePath.."screen.jpg",
            contentType="Image/jpeg",
            extra={
                {"act", "upload"},
                {"submit", "upload"},
            }
        }
    )
    ]]
--      

local function length_of_file(filename)
    local fh = assert(io.open(filename, "rb"))
    local len = assert(fh:seek("end"))
    fh:close()
    return len
end
function network.uploadFile(callback, url, datas)
    assert(datas or datas.fileFieldName or datas.filePath, "Need file datas!")
    local request = network.createHTTPRequest(callback, url, "POST")
    local fileFieldName = datas.fileFieldName
    local filePath = datas.filePath
    local contentType = datas.contentType
    if contentType then
        request:addFormFile(fileFieldName, filePath, contentType)
    else
        request:addFormFile(fileFieldName, filePath)
    end
    if datas.extra then
        for i in ipairs(datas.extra) do
            local data = datas.extra[i]
            request:addFormContents(data[1], data[2])
        end
    end
    request:start()
    return request
end

local function parseTrueFalse(t)
    t = string.lower(tostring(t))
    if t == "yes" or t == "true" then return true end
    return false
end

function network.makeCookieString(cookie)
    local arr = {}
    for name, value in pairs(cookie) do
        if type(value) == "table" then
            value = tostring(value.value)
        else
            value = tostring(value)
        end

        arr[#arr + 1] = tostring(name) .. "=" .. string.urlencode(value)
    end

    return table.concat(arr, "; ")
end

function network.parseCookie(cookieString)
    local cookie = {}
    local arr = string.split(cookieString, "\n")
    for _, item in ipairs(arr) do
        item = string.trim(item)
        if item ~= "" then
            local parts = string.split(item, "\t")
            -- ".amazon.com" represents the domain name of the Web server that created the cookie and will be able to read the cookie in the future
            -- TRUE indicates that all machines within the given domain can access the cookie
            -- "/" denotes the path within the domain for which the variable is valid
            -- "FALSE" indicates that the connection is not secure
            -- "2082787601" represents the expiration date in UNIX time (number of seconds since January 1, 1970 00:00:00 GMT)
            -- "ubid-main" is the name of the cookie
            -- "002-2904428-3375661" is the value of the cookie

            local c = {
                domain = parts[1],
                access = parseTrueFalse(parts[2]),
                path = parts[3],
                secure = parseTrueFalse(parts[4]),
                expire = toint(parts[5]),
                name = parts[6],
                value = string.urldecode(parts[7]),
            }

            cookie[c.name] = c
        end
    end

    return cookie
end

gnetwork = network

return network