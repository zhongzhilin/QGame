--region TabControl.lua
--Author : Untory
--Date   : 2017/4/14

--[[
    热更 
--]]
local UIUpdateControl = class("UIUpdateControl")
local datetime = require "datetime"


local version_url = ""
local patch_url = ""

if _CPP_RELEASE == 1 then
    version_url = "http://wzxtupdate.030303.com/version"
    if _DEBUG_SERVER and _DEBUG_SERVER == 999 then
        version_url = "http://wzxtupdate.030303.com/version_new"
    end
    patch_url = "http://wzxtupdate.030303.com/patch/patch"
else
    
    local update_str = cc.UserDefault:getInstance():getStringForKey("debug_update_addr","")
    
    print("update_str",update_str)

    if update_str ~= "" then

        version_url = update_str .. "/version.php"
        patch_url = update_str .. "/patch/patch"
    else
        local app_cfg = require("app_cfg")
        if app_cfg.plat_index == 2 then
            version_url = "http://60.191.28.90:8484/download/GetVersion.php"
            patch_url = "http://60.191.28.90:8484/download/patch/patch"
        elseif app_cfg.plat_index == 3 then
            version_url = "http://wzxtupdate.030303.com/hotupdate/GetVersion.php"
            patch_url = "http://wzxtupdate.030303.com/download/compareFiles/creed_assets_debug/patch/patch"
        end
    end    
end
-- local patch_url = "http://120.55.112.152/download/compareFiles/patch/patch"
 
function UIUpdateControl:ctor(progressCall,comlepeteCall,errorCall)

    self.progressCall = progressCall
    self.comlepeteCall = comlepeteCall
    self.errorCall = errorCall
end

function UIUpdateControl:setDelegate(delegate)
    self.m_delegate = delegate
end

function UIUpdateControl:GetPreciseDecimal(nNum, n)
    if type(nNum) ~= "number" then
        return nNum;
    end
    
    n = n or 0;
    n = math.floor(n)
    local fmt = '%.' .. n .. 'f'
    local nRet = tonumber(string.format(fmt, nNum))

    return nRet;
end

function UIUpdateControl:formatByte(byte)
    
    if byte > 1024 then

        return self:GetPreciseDecimal(byte / 1024,2) .. "mb"
    else

        return byte .. "kb"
    end
end

--判断version1 是否 >= version2 
function UIUpdateControl:checkVersion(version1,version2)

    print("start check verison",version1,version2)

    if version1 == version2 then
        return true
    end

    local version1Arr = string.split(version1,'.')
    local version2Arr = string.split(version2,'.')
    local indexCount = #version1Arr
    for i = 1,indexCount do

        local i1 = tonumber(version1Arr[i])
        local i2 = tonumber(version2Arr[i])

        if i1 > i2 then

            return true
        elseif i1 < i2 then

            return false
        end
    end
end

local isneedupdate = false

function UIUpdateControl:isNeedUpdate()
    return isneedupdate
end

function UIUpdateControl:compareVersion(versionInfo,isAgain)

    print(versionInfo,"versionInfo")

    if versionInfo == "access_error" then

        -- if self.errorCall then self.errorCall(2) end
        if not global.netRpc:checkClientNetWithError() then
        else
            global.tipsMgr:showQuitConfirmPanelNoClientNet()
        end

        return
    end

    if versionInfo == "" then
        global.tipsMgr:showQuitConfirmPanel(false,"UIMaintancePanel")
        return
    end

    local json = require "base.pack.json"
    local versionData = json.decode(versionInfo)
    if not versionData then
        global.tipsMgr:showQuitConfirmPanel(false,"UIMaintancePanel")
        return
    end
    
    local curVersion = GLFGetAppVerStr()    
    local clientVersion = GLFGetClientVerStr()

    dump(versionData)

    local serverMinVer = versionData.last_client_ver
    print(clientVersion, serverMinVer)
    if self:checkVersion(clientVersion, serverMinVer) then

        local lastResVersion = versionData.last_app_ver
        --TODO 考虑一下没有这个版本的话怎么办
        
        if self:checkVersion(curVersion, lastResVersion) then

            --不需要更新
            print("不需要更新")

            if self.m_delegate then self.m_delegate:loadMapInfo() end
            if self.comlepeteCall then self.comlepeteCall() end

            return false
        else
            
            print("可以更新这个文件")            
            isneedupdate = true
            local patch_file = "patch" .. curVersion .. "-" .. lastResVersion .. ".zip"                
            local byte = versionData.tags[curVersion]

            if not byte then

                local panel = global.panelMgr:openPanel("UIPaltUpdateConfrimPanel"):setData(versionData["logs"])

                if self.errorCall then self.errorCall(10001) end
            else
                local updateStartCall = function()
                    -- body
                    local patch_url = patch_url .. curVersion .. "-" .. lastResVersion .. ".zip"                                
                    self.byte = byte
                    self.resUpdateMgr:setPackageUrl(patch_url)
                    local maxPercent=20
                    local waitper = maxPercent*0.8
                    local t_dt = 0.02
                    local wishSec = 5
                    local dpperframe = waitper/(wishSec/t_dt)
                    local currper = 0
                    local timer_temp = nil
                    timer_temp = gscheduler.scheduleGlobal(function()
                        currper = currper+dpperframe
                        if self.m_delegate then
                            self.m_delegate:changeLoading(currper) 
                        end
                        if currper >= waitper then
                            dpperframe = dpperframe*0.5
                            waitper = waitper+(maxPercent-waitper)*0.5
                        end
                    end,t_dt)

                    if self.m_delegate then
                        self.m_delegate.m_isFirstStartUpdateCall = function()
                            -- 已经开始更新了
                            if self.m_delegate then
                                self.m_delegate:changeLoading(maxPercent) 
                            end
                            if timer_temp then
                                gscheduler.unscheduleGlobal(timer_temp)
                            end
                        end
                    end
                    self.resUpdateMgr:startUpdate()
                end

                if isAgain then
                    updateStartCall()
                else
                    if self.errorCall then self.errorCall(10002) end
                    local panel = global.panelMgr:openPanel("UIUpdateConfrimPanel")
                    panel:setData({byte = self:formatByte(byte)},function()
                        updateStartCall()
                    end,function()
                        
                        global.funcGame:allExit()
                    end)
                end
            end            

            -- return curVersion .. "-" .. lastResVersion
            return false
        end
    else

        if self.errorCall then self.errorCall(10001) end
        print("需要去炮台更新")
        local panel = global.panelMgr:openPanel("UIPaltUpdateConfrimPanel"):setData(versionData["logs"])
        -- panel:setData("update03",function()
            
        --     global.tipsMgr:showWarningText("由于没有在平台上线，所以只能关闭游戏")
        --     global.delayCallFunc(function()
                
        --         global.funcGame:allExit()    
        --     end,nil,1)            
        -- end)

        return false
    end
end

--检测大版本跨度
function UIUpdateControl:checkJumpVersion()
    
    local cjson = require "base.pack.json"
    local fileUtils = cc.FileUtils:getInstance()
    if fileUtils:isFileExist("app_ver_update") then

        updateVer = cjson.decode(cc.FileUtils:getInstance():getStringFromFile("app_ver_update"))
        ver = cjson.decode(cc.FileUtils:getInstance():getStringFromFile("app_ver"))

        --当前版本比那个版本新
        if self:checkVersion(ver.app_ver, updateVer.app_ver) then

            fileUtils:removeDirectory(fileUtils:getWritablePath() .. "patch/")
            global.funcGame.RestartGame()
            return true
        end
    end

    return false
end
function UIUpdateControl:startCheck(isAgain)

    global.g_worldview = nil

    if device.platform == "windows" then
        global.delayCallFunc(function()
            if self.m_delegate then self.m_delegate:loadMapInfo() end
            self.comlepeteCall()
        end,nil,0)
    return end
    if isAgain then
        if _CPP_RELEASE == 1 then
            version_url = "http://wzxtupdate.030303.com/version"
            if _DEBUG_SERVER and _DEBUG_SERVER == 999 then
                version_url = "http://wzxtupdate.030303.com/version_new"
            end
            patch_url = "http://wzxtupdate.030303.com/patch/patch"
        else
            local app_cfg = require("app_cfg")
            if app_cfg.plat_index == 2 then
                version_url = "http://60.191.28.90:8484/download/GetVersion.php"
                patch_url = "http://60.191.28.90:8484/download/patch/patch"
            elseif app_cfg.plat_index == 3 then
                version_url = "http://wzxtupdate.030303.com/hotupdate/GetVersion.php"
                patch_url = "http://wzxtupdate.030303.com/download/compareFiles/creed_assets_debug/patch/patch"
            end
        end
    end

    local fileUtils = cc.FileUtils:getInstance()

    print("patch_url: ",patch_url)
    print("version_url: ",version_url)

    local progress = 0
    self.resUpdateMgr = cc.AssetsManager:new(
        patch_url,
        version_url,
        fileUtils:getWritablePath() .. "patch/")
    
    self.resUpdateMgr:retain()

    local failTimes = 0
    local s_time = datetime.now().secs
    self.resUpdateMgr:setDelegate(function(code)
        
        print("res update error",code)
        if isAgain then
            local d_err_t = datetime.now().secs-s_time
            print("ffff----->"..d_err_t)
            if d_err_t <= 1 and _CPP_RELEASE == 1 then
                local isClientNet,netState = global.netRpc:checkClientNetAvailable()
                if not isClientNet then
                else                
                    local panel = global.panelMgr:openPanel("UIMaintancePanel")
                    panel:setData(false, function()
                        global.funcGame.allExit()
                    end)
                    return
                end
            end
            if self.errorCall then self.errorCall(code) end
        else
            if progress and progress<= 0 then
                self.resUpdateMgr:release()
                self:startCheck(true)
            else
                failTimes = failTimes+1
                if self.errorCall and failTimes>5 then self.errorCall(code) end
            end
        end
    end, cc.ASSETSMANAGER_PROTOCOL_ERROR )

    self.resUpdateMgr:setDelegate(function(code)
        
        print("res update progress",code)

        local max = self.byte
        local cur = max * (code / 100)
        local str = self:formatByte(cur) .. "/" .. self:formatByte(max)

        progress = code

        if self.progressCall then self.progressCall(code,str) end
    end, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
   
    self.resUpdateMgr:setDelegate(function()
        
        print("res comlepete")
        -- CCHgame:RestartGame()
        -- global.funcGame.RestartGame()
        if self.comlepeteCall then self.comlepeteCall(true) end
    end, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )

    self.resUpdateMgr:setDelegate(function(versionInfo)
        
        print("self.resUpdateMgr:setDelegate(function(versionInfo)")

        return self:compareVersion(versionInfo,isAgain)
        -- print("res ASSETSMANAGER_PROTOCOL_COMPARE_VERSION")
    end, cc.ASSETSMANAGER_PROTOCOL_COMPARE_VERSION )

    self.resUpdateMgr:checkUpdate()
end

return UIUpdateControl

--endregion
