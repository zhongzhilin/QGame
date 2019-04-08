--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local _M = {}
local lfs = require "lfs"

function _M:initCsbCache()
    local csb_path = "asset/ui/"

    local function traversalCsbPath(csb_path)
        for file in lfs.dir(csb_path) do
            if file ~= "." and file ~= ".." then
                local f = csb_path..'/'..file
                local attr = lfs.attributes(f)
                if attr and attr.mode == "directory" then
                    traversalCsbPath(f)
                else
                    if string.find(f, ".csb") then
                        cc.CSLoader:cacheCsbData(f)
                        cc.CSLoader:createTimeline(f)
--                        print("cache ", f)
                    end
                end
            end
        end
    end
    
    traversalCsbPath(csb_path)
end

global.csb_loader = _M

--endregion
