
---@classdef gdevice
gdevice = {}

local json = require "json"

gdevice.platform    = "unknown"
gdevice.model       = "unknown"

local app = cc.Application:getInstance()
local target = app:getTargetPlatform()
if target == cc.PLATFORM_OS_WINDOWS then
    gdevice.platform = "windows"
elseif target == cc.PLATFORM_OS_MAC then
    gdevice.platform = "mac"
elseif target == cc.PLATFORM_OS_ANDROID then
    gdevice.platform = "android"
elseif target == cc.PLATFORM_OS_IPHONE or target == cc.PLATFORM_OS_IPAD then
    gdevice.platform = "ios"
    local director = cc.Director:getInstance()
    local view = director:getOpenGLView()
    local framesize = view:getFrameSize()
    local w, h = framesize.width, framesize.height
    if w == 640 and h == 960 then
        gdevice.model = "iphone 4"
    elseif w == 640 and h == 1136 then
        gdevice.model = "iphone 5"
    elseif w == 750 and h == 1334 then
        gdevice.model = "iphone 6"
    elseif w == 1242 and h == 2208 then
        gdevice.model = "iphone 6 plus"
    elseif w == 768 and h == 1024 then
        gdevice.model = "ipad"
    elseif w == 1536 and h == 2048 then
        gdevice.model = "ipad retina"
    end
elseif target == cc.PLATFORM_OS_WINRT then
    gdevice.platform = "winrt"
elseif target == cc.PLATFORM_OS_WP8 then
    gdevice.platform = "wp8"
end

local language_code = app:getCurrentLanguageCode()
local language_ = app:getCurrentLanguage()
print("#####asdfasd")
print(language_)
print(language_code)
if language_ == cc.LANGUAGE_CHINESE then
    language_ = "cn"
elseif language_ == cc.LANGUAGE_FRENCH then
    language_ = "fr"
elseif language_ == cc.LANGUAGE_ITALIAN then
    language_ = "it"
elseif language_ == cc.LANGUAGE_GERMAN then
    language_ = "de"
elseif language_ == cc.LANGUAGE_SPANISH then
    language_ = "es"
elseif language_ == cc.LANGUAGE_DUTCH then
    language_ = "nl"
elseif language_ == cc.LANGUAGE_RUSSIAN then
    language_ = "ru"
elseif language_ == cc.LANGUAGE_KOREAN then
    language_ = "kr"
elseif language_ == cc.LANGUAGE_JAPANESE then
    language_ = "jp"
elseif language_ == cc.LANGUAGE_HUNGARIAN then
    language_ = "hu"
elseif language_ == cc.LANGUAGE_PORTUGUESE then
    language_ = "pt"
elseif language_ == cc.LANGUAGE_ARABIC then
    language_ = "ar"
else
    if language_code == "en" then
    else
        print("###----> no language code:"..language_code)
    end
    language_ = "en"
end

gdevice.language = "cn"
gdevice.writablePath = cc.FileUtils:getInstance():getWritablePath()
gdevice.directorySeparator = "/"
gdevice.pathSeparator = ":"
if gdevice.platform == "windows" then
    gdevice.directorySeparator = "\\"
    gdevice.pathSeparator = ";"
end

function gdevice.getIphoneModel()
    local platform = CCNative:getPlatform()
    if platform == "iPhone1,1" then 
        return "iPhone 2G"
    elseif platform == "iPhone1,2" then 
        return "iPhone 3G"
    elseif platform == "iPhone2,1" then 
        return "iPhone 3GS"
    elseif platform == "iPhone3,1" then 
        return "iPhone 4"
    elseif platform == "iPhone3,2" then 
        return "iPhone 4"
    elseif platform == "iPhone3,3" then 
        return "iPhone 4"
    elseif platform == "iPhone4,1" then 
        return "iPhone 4S"
    elseif platform == "iPhone5,1" then 
        return "iPhone 5"
    elseif platform == "iPhone5,2" then 
        return "iPhone 5"
    elseif platform == "iPhone5,3" then 
        return "iPhone 5c"
    elseif platform == "iPhone5,4" then 
        return "iPhone 5c"
    elseif platform == "iPhone6,1" then 
        return "iPhone 5s"
    elseif platform == "iPhone6,2" then 
        return "iPhone 5s"
    elseif platform == "iPhone7,1" then 
        return "iPhone 6 Plus"
    elseif platform == "iPhone7,2" then 
        return "iPhone 6"
    elseif platform == "iPhone8,1" then 
        return "iPhone 6s"
    elseif platform == "iPhone8,2" then 
        return "iPhone 6s Plus"
    elseif platform == "iPhone8,4" then 
        return "iPhone SE"
    elseif platform == "iPhone9,1" then 
        return "iPhone 7"
    elseif platform == "iPhone9,2" then 
        return "iPhone 7 Plus"
    elseif platform == "iPhone9,3" then 
        return "iPhone 7"
    elseif platform == "iPhone9,4" then 
        return "iPhone 7 Plus"
    elseif platform == "iPhone10,1" then 
        return "iPhone 7 Plus"
    elseif platform == "iPhone10,2" then 
        return "iPhone 7 Plus"
    elseif platform == "iPhone10,3" then 
        return "iPhone 7 Plus"
    elseif platform == "iPhone10,4" then 
        return "iPhone 7 Plus"
    elseif platform == "iPhone10,5" then 
        return "iPhone 7 Plus"
    elseif platform == "iPhone10,6" then 
        return "iPhone 7 Plus"
    elseif platform == "iPod1,1" then   
        return "iPod Touch 1G"
    elseif platform == "iPod2,1" then   
        return "iPod Touch 2G"
    elseif platform == "iPod3,1" then   
        return "iPod Touch 3G"
    elseif platform == "iPod4,1" then   
        return "iPod Touch 4G"
    elseif platform == "iPod5,1" then   
        return "iPod Touch 5G"
    elseif platform == "iPad1,1" then   
        return "iPad 1G"
    elseif platform == "iPad2,1" then   
        return "iPad 2"
    elseif platform == "iPad2,2" then   
        return "iPad 2"
    elseif platform == "iPad2,3" then   
        return "iPad 2"
    elseif platform == "iPad2,4" then   
        return "iPad 2"
    elseif platform == "iPad2,5" then   
        return "iPad Mini 1G"
    elseif platform == "iPad2,6" then   
        return "iPad Mini 1G"
    elseif platform == "iPad2,7" then   
        return "iPad Mini 1G"
    elseif platform == "iPad3,1" then   
        return "iPad 3"
    elseif platform == "iPad3,2" then   
        return "iPad 3"
    elseif platform == "iPad3,3" then   
        return "iPad 3"
    elseif platform == "iPad3,4" then   
        return "iPad 4"
    elseif platform == "iPad3,5" then   
        return "iPad 4"
    elseif platform == "iPad3,6" then   
        return "iPad 4"
    elseif platform == "iPad4,1" then   
        return "iPad Air"
    elseif platform == "iPad4,2" then   
        return "iPad Air"
    elseif platform == "iPad4,3" then   
        return "iPad Air"
    elseif platform == "iPad4,4" then   
        return "iPad Mini 2G"
    elseif platform == "iPad4,5" then   
        return "iPad Mini 2G"
    elseif platform == "iPad4,6" then   
        return "iPad Mini 2G"
    elseif platform == "iPad4,7"   then   return "iPad Mini 3"       
    elseif platform == "iPad4,8"   then   return "iPad Mini 3"       
    elseif platform == "iPad4,9"   then   return "iPad Mini 3"       
    elseif platform == "iPad5,1"   then   return "iPad Mini 4 (WiFi)"
    elseif platform == "iPad5,2"   then   return "iPad Mini 4 (LTE)" 
    elseif platform == "iPad5,3"   then   return "iPad Air 2"        
    elseif platform == "iPad5,4"   then   return "iPad Air 2"        
    elseif platform == "iPad6,3"   then   return "iPad Pro 9.7"      
    elseif platform == "iPad6,4"   then   return "iPad Pro 9.7"      
    elseif platform == "iPad6,7"   then   return "iPad Pro 12.9"     
    elseif platform == "iPad6,8"   then   return "iPad Pro 12.9"     
    elseif platform == "iPad6,11"  then   return "iPad 5 (WiFi)"     
    elseif platform == "iPad6,12"  then   return "iPad 5 (Cellular)" 
    elseif platform == "iPad7,1"   then   return "iPad Pro 12.9 inch 2nd gen (WiFi)"
    elseif platform == "iPad7,2"   then   return "iPad Pro 12.9 inch 2nd gen (Cellular)"
    elseif platform == "iPad7,3"   then   return "iPad Pro 10.5 inch (WiFi)"        
    elseif platform == "iPad7,4"   then   return "iPad Pro 10.5 inch (Cellular)"        
    else
        return "unknown"
    end
end
    

function gdevice.showActivityIndicator()
    CCNative:showActivityIndicator()
end

function gdevice.hideActivityIndicator()
    CCNative:hideActivityIndicator()
end

function gdevice.showAlert(title, message, buttonLabels, listener)
    -- if type(buttonLabels) ~= "table" then
    --     buttonLabels = {tostring(buttonLabels)}
    -- end
    
    -- if gdevice.platform == "android" then
    --     local tempListner = function(event)
    --         if type(event) == "string" then
    --             event = json.decode(event)
    --             event.buttonIndex = tonumber(event.buttonIndex)
    --         end
    --         if listener then listener(event) end
    --     end
    --     gluaj.callStaticMethod("org/cocos2dx/utils/PSNative", "createAlert", {title, message, buttonLabels, tempListner}, "(Ljava/lang/String;Ljava/lang/String;Ljava/util/Vector;I)V");
    -- else
    --     local defaultLabel = ""
    --     if #buttonLabels > 0 then
    --         defaultLabel = buttonLabels[1]
    --         table.remove(buttonLabels, 1)
    --     end
        
    --     CCNative:createAlert(title, message, defaultLabel)
    --     for i, label in ipairs(buttonLabels) do
    --         CCNative:addAlertButton(label)
    --     end
        
    --     if type(listener) ~= "function" then
    --         listener = function() end
    --     end
        
    --     CCNative:showAlert(listener)
    -- end
end

function gdevice.cancelAlert()
    CCNative:cancelAlert()
end

local crypto  = require "hqgame"
function gdevice.getOpenUDID()
    -- local uuid = CCHgame:getDeviceInfo()
    local uuid = ""
    if global.tools:isWindows() then
        uuid = cc.UserDefault:getInstance():getStringForKey("hello.good")
    elseif global.tools:isIos() then
        uuid = crypto.md5(CCNative:getOpenUDID(), false)
        -- print("fsadfasdfasdfasd")
        -- print("getIDFA="..CCNative:getIDFA())
        -- print("getIDFV="..CCNative:getIDFV())
        -- print("getBundleId="..CCNative:getBundleId())
        -- print("getXCVersion="..CCNative:getXCVersion())
        -- print("getBuildVersion="..CCNative:getBuildVersion())
        -- print("getPackageName="..CCNative:getPackageName())
        -- print("getBatteryQuantity="..CCNative:getBatteryQuantity())
        -- print("getTotalMemorySize="..CCNative:getTotalMemorySize())
        -- print("getAvailableMemorySize="..CCNative:getAvailableMemorySize())
        -- print("getIP="..CCNative:getIP(true))
        -- print("getCountryCode="..CCNative:getCountryCode())
        -- print("getSystemName="..CCNative:getSystemName())
        -- print("getSystemVersion="..CCNative:getSystemVersion())
        -- print("getPlatform="..CCNative:getPlatform())
        -- print("getIsoCountryCode="..CCNative:getIsoCountryCode())
        -- print("isAllowsVOIP=")
        -- print(CCNative:isAllowsVOIP())
        -- print("getMobileCountryCode="..CCNative:getMobileCountryCode())
        -- print("getMobileNetworkCode="..CCNative:getMobileNetworkCode())
        -- print("getNetworktype="..CCNative:getNetworktype())    
    elseif global.tools:isAndroid() then
        uuid = crypto.md5(CCHgame:getDeviceInfo(), false)
        if global.sdkBridge:getHttpSn() then
            uuid = global.sdkBridge:getHttpSn()
        end 
    end
    if not uuid or uuid == "" then
        uuid = crypto.md5(string.format("DFGHFNbG5PImF@9y9*m6Z%s",os.time()), false)
        cc.UserDefault:getInstance():setStringForKey("hello.good",uuid)
    end
    return uuid
end

function gdevice.openURL(url)
    CCNative:openURL(url)
end

function gdevice.showInputBox(title, message, defaultValue)
    title = title or "INPUT TEXT"
    message = message or "INPUT TEXT, CLICK OK BUTTON"
    defaultValue = defaultValue or ""
    return CCNative:getInputText(title, message, defaultValue)
end

function gdevice.showInfo()
    log.debug("# gdevice.platform              = " .. gdevice.platform)
    log.debug("# gdevice.model                 = " .. gdevice.model)
    log.debug("# gdevice.language              = " .. gdevice.language)
    log.debug("# gdevice.writablePath          = " .. gdevice.writablePath)
    log.debug("# gdevice.directorySeparator    = " .. gdevice.directorySeparator)
    log.debug("# gdevice.pathSeparator         = " .. gdevice.pathSeparator)
    log.debug("#")
end


