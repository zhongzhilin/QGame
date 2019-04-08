--region TabControl.lua
--Author : Song
--Date   : 2016/4/14
local localFileManger = class("localFileManger")

local pbpack = require "pbpack"
local lfs = require"lfs"


function localFileManger:ctor()

    self.fileUtils = cc.FileUtils:getInstance()


    self.basePath = self.fileUtils:getWritablePath().."war/"..global.loginData:getCurServerId()

    if not self.fileUtils:isDirectoryExist(self.basePath) then 
        self.fileUtils:createDirectory(self.basePath)
    end 

end 

function localFileManger:getInstance()

    if not global.localFileManger then 
         global.localFileManger = localFileManger.new()
    end 

    return  global.localFileManger
end 


function localFileManger:getAllFile()

    local filename_lsit = {} 

    if not self.fileUtils:isDirectoryExist(self.basePath) then 
         return nil      
    end 

    function attrdir (path)
        for file in lfs.dir(path) do
            if file ~= "." and file ~= ".." then
                table.insert(filename_lsit , file)
            end 
        end
    end


    attrdir(self.basePath)


    return filename_lsit
end 

local app_cfg = require "app_cfg"
local url = app_cfg.get_plat_url()..'download/bigfight.php?svr_id=%s&fight_id=%s&replay=1'

local boom = {[1]= 0xEF,[2] =0xBB,[3] =0xBF}

function localFileManger:replaceBoom(ret)

    local byteStr = ""
    if string.byte(ret,1)==9 and string.byte(ret,2)==10  then 
        for i=3, string.len(ret) do         
            local t = string.byte(ret, i)
            byteStr = byteStr .. string.char(t)
        end
    end
    return byteStr
end



function localFileManger:downloradWarData(war_id ,panel)

    war_id = tostring(war_id)

    local status  , data_name = self:CheckisExitsPlus(war_id)

    if status  then 

        local pbText = io.readfile(self.basePath.."/"..data_name)

        -- local pbText ="" 
        -- local file = io.open(self.basePath.."/"..data_name)
        -- for line in file:lines()  do
        --     print("what it is " ,tonumber(line ,16))
        --     pbText = line
        -- end
        pbText = self:replaceBoom(pbText)

        local t = global.netRpc:packBodyForOuter(pbText)
        if not t.tagBody then 
            -- global.tipsMgr:showWarning("file decode error  71")
            -- if device.platform ~= "windows" then 
                self:deleteFile(self.basePath.."/"..data_name)
            -- end
            return
        end 

        panel.war_data  = t
        panel:initPlayer()

        if device.platform ~= "windows" then 
            self:deleteFile(self.basePath.."/"..data_name)
        end
    else  

        -- local serverinfo = nil 
        -- for _ ,v in pairs(global.ServerData:getSeverList()) do 
        --     if tonumber(v.serverid) ==  tonumber(global.loginData:getCurServerId())then 
        --         serverinfo =v 
        --     end 
        -- end 
        -- dump(serverinfo,"serverinfo/////////")
        -- local info =  global.tools:strSplit(serverinfo.ip, ':')
        -- if  not info[1]  then global.tipsMgr:showWarning("downloadurl error 87 ") end 

        -- if  global.loginData:getCurServerId() == 4  then  --晶晶服 端口不一样
        --     info[1] = info[1]..":8486/FightReplayFiles/"
        -- else 
        --     info[1] = info[1].."/FightReplayFiles/"
        -- end  

        -- local request_url =  info[1]..war_id..".txt"

        -- print(request_url,"request_url./////////////////////")

        local filename = self.basePath.."/".. tostring(war_id).."time"..global.dataMgr:getServerTime()

        -- if device.platform ~= "windows" then 
        --     if not string.find(request_url,"http://") then 
        --         request_url = "http://"..request_url
        --     end 
        -- end 

        local request_url = string.format(replayURL,global.loginData:getCurServerId() ,war_id)
        CCHgame:downloadWarData(request_url ,filename)
    end 

end


function localFileManger:deleteFileByWarId(war_id)

    war_id = tostring(war_id)

    local status , data_name = self:CheckisExitsPlus(war_id)

    if status then 
        self:deleteFile(self.basePath.."/"..data_name)
    end 
    
end 


function localFileManger:get_local_data(war_id,panel) 

    war_id = tostring(war_id)

    local status  , data_name = self:CheckisExitsPlus(war_id)

    if status  then 

        local pbText = io.readfile(self.basePath.."/"..data_name)

        pbText = self:replaceBoom(pbText)

        local t = global.netRpc:packBodyForOuter(pbText)
        if not t.tagBody then

            -- global.tipsMgr:showWarning("file decode error 113 ")

            self:deleteFile(self.basePath.."/"..data_name)

            return
        end 

        panel.war_data  = t
        panel:initPlayer()

    else  
        
        global.tipsMgr:showWarning("read file error 125")
    end 
end 


function  localFileManger:CheckisExits(war_id)

    local allfile =  self:getAllFile()

    if not allfile then return false end 

    for _  , v in pairs(allfile) do
        local info = global.tools:strSplit(v, 'time') 
        if tostring(war_id) == info[1] then 
            return true 
        end          
    end 

    return false 
end

function  localFileManger:CheckisExitsPlus(war_id) -- 返回 状态 和 文件名

    local allfile =  self:getAllFile()

    if not allfile then return false end 

    local  filename = nil 
    for _  , v in pairs(allfile) do
        filename = v 
        local info = global.tools:strSplit(v, 'time') 
        if tostring(war_id) == info[1] then 
            return true  , filename
        end          
    end 
    return false  , filename
end 

function localFileManger:getFileData(file_path)
    local data = nil 
    if self.fileUtils:isFileExist(file_path) then 
        local inp = io.open(file_path, "rb")
        data = inp:read("*all")
    end 
    return data 
end 


function localFileManger:deleteFile(filename)

    return  self.fileUtils:removeFile(filename)
end 


return localFileManger